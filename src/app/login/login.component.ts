import { Component, OnInit, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  username = '';
  password = '';
  message = '';

  private http = inject(HttpClient);

  login() {
    const body = {
      username: this.username,
      password: this.password
    };

    this.http.post(
      'https://localhost:7049/api/Auth/login',
      body
    ).subscribe({
      next: (res) => {
        console.log(res);
        this.message = 'Login Successful';
      },
      error: () => {
        this.message = 'Invalid Login';
      }
    });
  }

  ngOnInit(): void {
    console.log('Application Started');
  }
}