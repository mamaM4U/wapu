import { check, sleep } from 'k6';
import http from 'k6/http';

export const options = {
  vus: 10000,
  duration: '10s',
};

export default function () {
  const res = http.get('http://chip-app:8080/api/link');

  check(res, {
    'is status 200': (r) => r.status === 200,
  });

  sleep(1);
}
