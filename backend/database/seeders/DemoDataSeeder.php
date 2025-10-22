<?php
namespace Database\Seeders;
use Illuminate\Database\Seeder;
class DemoDataSeeder extends Seeder {
  public function run() {
    \DB::table('users')->insert([['name'=>'Admin','email'=>'admin@auvenstudio.com','password'=>bcrypt('Auven@123')]]);
  }
}
