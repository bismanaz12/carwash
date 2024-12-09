import 'dart:async';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:http/http.dart' as http;

Future<String?> resolveMdnsToIp(String serviceName) async {
  final MDnsClient client = MDnsClient();
  String? ipAddress;

  try {
    await client.start();
    final PtrResourceRecord ptr = await client
        .lookup<PtrResourceRecord>(
            ResourceRecordQuery.serverPointer(serviceName))
        .first;

    // Look for the service instance
    final SrvResourceRecord srv = await client
        .lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))
        .first;

    // Look up the IP address of the target
    final IPAddressResourceRecord ip = await client
        .lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv4(srv.target))
        .first;

    ipAddress = ip.address.address;
    print('Resolved IP: $ipAddress');
  } catch (e) {
    print('Error resolving mDNS: $e');
  } finally {
    client.stop();
  }

  return ipAddress;
}

Future<void> callApi(String serviceName) async {
  String? ipAddress = await resolveMdnsToIp(serviceName);

  if (ipAddress != null) {
    // Call the API using the resolved IP
    final response = await http.get(Uri.parse('http://$ipAddress'));

    if (response.statusCode == 200) {
      print('API response: ${response.body}');
    } else {
      print('Failed to call API, status code: ${response.statusCode}');
    }
  } else {
    print('Could not resolve mDNS to IP address.');
  }
}

void main() async {
  String serviceName = 'wled-1'; // Replace with your mDNS service name
  await callApi(serviceName);
}
