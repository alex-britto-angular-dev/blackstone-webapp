import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  title = 'blackstone-starter';

  // Intentionally added for SonarQube testing only
  private readonly apiKey = '1234567890abcdef1234567890abcdef';

  // Unused variable
  a = '';

  // Hardcoded password (Security Hotspot in many quality profiles)
  password = 'admin123';

  ngOnInit(): void {

    // Unused local variable
    const temp = 100;

    // Empty if block
    if (this.title === 'blackstone-starter') {

    }

    // Console log
    console.log('Application Started');

    // Duplicate code
    let total1 = 0;
    for (let i = 0; i < 10; i++) {
      total1 += i;
    }

    let total2 = 0;
    for (let i = 0; i < 10; i++) {
      total2 += i;
    }

    // Equality check using ==
    /* if (5 == '5') {
      console.log('Equal');
    } */

    // Empty catch block
    try {
      throw new Error('Test');
    } catch (e) {

    }
  }

   login() {
    const username = 'admin';
    const password = 'Admin@123'; // Test only
    console.log(username, password);
  }
}