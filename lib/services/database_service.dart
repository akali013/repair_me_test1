import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repair_me_test1/models/Appointment.dart';
import 'package:repair_me_test1/models/ChatRoom.dart';
import 'package:repair_me_test1/models/Mechanic.dart';
import 'package:repair_me_test1/models/Payment.dart';
import 'package:repair_me_test1/models/Review.dart';
import 'package:repair_me_test1/models/Service.dart';
import 'package:repair_me_test1/models/Shop.dart';
import 'package:repair_me_test1/models/ShopPayment.dart';
import 'package:repair_me_test1/models/User.dart';
import 'package:repair_me_test1/models/Vehicle.dart';

const String USER_COLLECTION_REF = "Users";
const String MECHANIC_COLLECTION_REF = "Mechanics";
const String SHOP_COLLECTION_REF = "Shops";
const String VEHICLE_COLLECTION_REF = "Vehicles";
const String APPOINTMENT_COLLECTION_REF = "Appointments";
const String CHATROOM_COLLECTION_REF = "ChatRooms";
const String PAYMENT_COLLECTION_REF = "Payments";
const String SHOPPAYMENT_COLLECTION_REF = "ShopPayments";
const String REVIEW_COLLECTION_REF = "Reviews";
const String SERVICE_COLLECTION_REF = "Services";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;
  late final CollectionReference _mechanicsRef;
  late final CollectionReference _shopsRef;
  late final CollectionReference _vehiclesRef;
  late final CollectionReference _appointmentsRef;
  late final CollectionReference _chatRoomsRef;
  late final CollectionReference _paymentsRef;
  late final CollectionReference _shopPaymentsRef;
  late final CollectionReference _reviewsRef;
  late final CollectionReference _servicesRef;
  
  // Automatically convert each document to its corresponding type in the app
  // whether it's going to or from Firestore
  DatabaseService() {
    _usersRef = _firestore.collection(USER_COLLECTION_REF).withConverter<User>(
      fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!), 
      toFirestore: (user, _) => user.toJson()
    );
    _mechanicsRef = _firestore.collection(MECHANIC_COLLECTION_REF).withConverter<Mechanic>(
      fromFirestore: (snapshots, _) => Mechanic.fromJson(snapshots.data()!), 
      toFirestore: (mechanic, _) => mechanic.toJson()
    );
    _shopsRef = _firestore.collection(SHOP_COLLECTION_REF).withConverter<Shop>(
      fromFirestore: (snapshots, _) => Shop.fromJson(snapshots.data()!), 
      toFirestore: (shop, _) => shop.toJson()
    );
    _vehiclesRef = _firestore.collection(VEHICLE_COLLECTION_REF).withConverter<Vehicle>(
      fromFirestore: (snapshots, _) => Vehicle.fromJson(snapshots.data()!), 
      toFirestore: (vehicle, _) => vehicle.toJson()
    );
    _appointmentsRef = _firestore.collection(APPOINTMENT_COLLECTION_REF).withConverter<Appointment>(
      fromFirestore: (snapshots, _) => Appointment.fromJson(snapshots.data()!), 
      toFirestore: (appt, _) => appt.toJson()
    );
    _chatRoomsRef = _firestore.collection(CHATROOM_COLLECTION_REF).withConverter<ChatRoom>(
      fromFirestore: (snapshots, _) => ChatRoom.fromJson(snapshots.data()!), 
      toFirestore: (room, _) => room.toJson()
    );
    _paymentsRef = _firestore.collection(PAYMENT_COLLECTION_REF).withConverter<Payment>(
      fromFirestore: (snapshots, _) => Payment.fromJson(snapshots.data()!), 
      toFirestore: (payment, _) => payment.toJson()
    );
    _shopPaymentsRef = _firestore.collection(SHOPPAYMENT_COLLECTION_REF).withConverter<ShopPayment>(
      fromFirestore: (snapshots, _) => ShopPayment.fromJson(snapshots.data()!), 
      toFirestore: (payment, _) => payment.toJson()
    );
    _reviewsRef = _firestore.collection(REVIEW_COLLECTION_REF).withConverter<Review>(
      fromFirestore: (snapshots, _) => Review.fromJson(snapshots.data()!), 
      toFirestore: (review, _) => review.toJson()
    );
    _servicesRef = _firestore.collection(SERVICE_COLLECTION_REF).withConverter<Service>(
      fromFirestore: (snapshots, _) => Service.fromJson(snapshots.data()!), 
      toFirestore: (service, _) => service.toJson()
    );
  }

  // User functions
  // Get all user documents in the Users collection
  Stream<QuerySnapshot> getUsers() {
    return _usersRef.snapshots();
  }

  // Add a user document with a randomly generated userID
  void addUser(User user) async {
    _usersRef.add(user);
  }

  void updateUser(String userID, User user) {
    _usersRef.doc(userID).update(user.toJson());
  }

  void deleteUser(String userID) {
    _usersRef.doc(userID).delete();
  }

  // Mechanic functions
  Stream<QuerySnapshot> getMechanics() {
    return _mechanicsRef.snapshots();
  }

  void addMechanic(Mechanic mechanic) async {
    _mechanicsRef.add(mechanic);
  }

  void updateMechanic(String mechanicID, Mechanic mechanic) {
    _mechanicsRef.doc(mechanicID).update(mechanic.toJson());
  }

  void deleteMechanic(String mechanicID) {
    _mechanicsRef.doc(mechanicID).delete();
  }

  // Shop functions
  Stream<QuerySnapshot> getShops() {
    return _shopsRef.snapshots();
  }

  void addshop(Shop shop) async {
    _shopsRef.add(shop);
  }

  void updateShop(String shopID, Shop shop) {
    _shopsRef.doc(shopID).update(shop.toJson());
  }

  void deleteShop(String shopID) {
    _shopsRef.doc(shopID).delete();
  }

  // Vehicle functions
  Stream<QuerySnapshot> getVehicles() {
    return _vehiclesRef.snapshots();
  }

  void addVehicle(Vehicle vehicle) async {
    _vehiclesRef.add(vehicle);
  }

  void updateVehicle(String vehicleID, Vehicle vehicle) {
    _vehiclesRef.doc(vehicleID).update(vehicle.toJson());
  }

  void deleteVehicle(String vehicleID) {
    _vehiclesRef.doc(vehicleID).delete();
  }

  // Appointment functions
  Stream<QuerySnapshot> getAppointments() {
    return _appointmentsRef.snapshots();
  }

  void addAppointment(Appointment appointment) async {
    _appointmentsRef.add(appointment);
  }

  void updateAppointment(String appointmentID, Appointment appointment) {
    _appointmentsRef.doc(appointmentID).update(appointment.toJson());
  }

  void deleteAppointment(String appointmentID) {
    _appointmentsRef.doc(appointmentID).delete();
  }

  // Chat room functions
  Stream<QuerySnapshot> getChatRooms() {
    return _chatRoomsRef.snapshots();
  }

  void addChatRoom(ChatRoom chatRoom) async {
    _chatRoomsRef.add(chatRoom);
  }

  void updateChatRoom(String chatRoomID, ChatRoom chatRoom) {
    _chatRoomsRef.doc(chatRoomID).update(chatRoom.toJson());
  }

  void deleteChatRoom(String chatRoomID) {
    _chatRoomsRef.doc(chatRoomID).delete();
  }

  // Payment functions
  Stream<QuerySnapshot> getPayments() {
    return _paymentsRef.snapshots();
  }

  void addPayment(Payment payment) async {
    _paymentsRef.add(payment);
  }

  void updatePayment(String paymentID, Payment payment) {
    _paymentsRef.doc(paymentID).update(payment.toJson());
  }

  void deletePayment(String paymentID) {
    _paymentsRef.doc(paymentID).delete();
  }

  // Shop payment functions
  Stream<QuerySnapshot> getshopPayments() {
    return _shopPaymentsRef.snapshots();
  }

  void addShopPayment(ShopPayment shopPayment) async {
    _shopPaymentsRef.add(shopPayment);
  }

  void updateShopPayment(String shopPaymentID, ShopPayment shopPayment) {
    _shopPaymentsRef.doc(shopPaymentID).update(shopPayment.toJson());
  }

  void deleteShopPayment(String shopPaymentID) {
    _shopPaymentsRef.doc(shopPaymentID).delete();
  }

  // Review functions
  Stream<QuerySnapshot> getReviews() {
    return _reviewsRef.snapshots();
  }

  void addReview(Review review) async {
    _reviewsRef.add(review);
  }

  void updateReview(String reviewID, Review review) {
    _reviewsRef.doc(reviewID).update(review.toJson());
  }

  void deleteReview(String reviewID) {
    _reviewsRef.doc(reviewID).delete();
  }

  // Service functions
  Stream<QuerySnapshot> getServices() {
    return _servicesRef.snapshots();
  }

  void addService(Service service) async {
    _servicesRef.add(service);
  }

  void updateService(String serviceID, Service service) {
    _servicesRef.doc(serviceID).update(service.toJson());
  }

  void deleteService(String serviceID) {
    _servicesRef.doc(serviceID).delete();
  }
}