import 'package:namnam/model/category.dart';
import 'package:namnam/model/response/ApiResponse.dart';
import 'package:namnam/model/response/Status.dart';
import 'package:namnam/network/ApiEndPoints.dart';
import 'package:namnam/network/NetworkApiService.dart';
import 'package:namnam/network/services/categories_service.dart';
import 'package:namnam/model/request/create_category_request.dart';
import 'package:namnam/core/Utility/Preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesServiceImpl implements CategoriesService {
  final NetworkApiService _networkApiService = NetworkApiService();

  @override
  Future<ApiResponse<List<Category>>> getCategories({int? parentId}) async {
    print('CategoriesServiceImpl: Starting getCategories request...');
    try {
      // Get access token from preferences
      final prefs = await SharedPreferences.getInstance();
      final prefProvider = PrefProvider(prefs);
      final accessToken = prefProvider.getAccessToken();
      
      print('CategoriesServiceImpl: Access token retrieved: ${accessToken.isNotEmpty ? 'Present' : 'Not found'}');
      
      // Build query parameters
      Map<String, dynamic> queryParams = {};
      // Always pass parentId parameter - empty string if null, otherwise the value
      queryParams['parentId'] = parentId?.toString() ?? '';
      
      print('CategoriesServiceImpl: Query parameters: $queryParams');

      final response = await _networkApiService.fetchData(
        ApiEndPoints.getCategories,
        queryParams,
        accessToken.isNotEmpty ? accessToken : null, // Use Bearer token if available
      );

      print('CategoriesServiceImpl: Network response - Status: ${response.status}, Message: ${response.message}');
      print('CategoriesServiceImpl: Response data: ${response.data}');

      if (response.status == Status.COMPLETED) {
        if (response.data != null) {
          print('CategoriesServiceImpl: Processing successful response...');
          
          // Parse the data as a List
          if (response.data is List) {
            final List<Category> categories = (response.data as List)
                .map((item) => Category.fromJson(item))
                .toList();
            
            print('CategoriesServiceImpl: Categories parsed - Count: ${categories.length}');
            return ApiResponse(
              Status.COMPLETED,
              categories,
              response.message,
            );
          } else {
            print('CategoriesServiceImpl: Response data is not a List');
            return ApiResponse(
              Status.ERROR,
              null,
              'Invalid response format: Expected List',
            );
          }
        } else {
          print('CategoriesServiceImpl: Response data is null');
          return ApiResponse(
            Status.ERROR,
            null,
            'No categories data received',
          );
        }
      } else {
        print('CategoriesServiceImpl: Response status is not COMPLETED');
        
        // Check if it's an authentication error
        if (response.message?.toLowerCase().contains('unauthorized') == true) {
          return ApiResponse(
            Status.ERROR,
            null,
            'Authentication failed. Please log in again.',
          );
        }
        
        return ApiResponse(
          Status.ERROR,
          null,
          response.message ?? 'Failed to fetch categories',
        );
      }
    } catch (e) {
      print('CategoriesServiceImpl: Exception occurred: $e');
      return ApiResponse(
        Status.ERROR,
        null,
        'Failed to fetch categories: $e',
      );
    }
  }

  @override
  Future<ApiResponse<Category>> createCategory(CreateCategoryRequest request) async {
    print('CategoriesServiceImpl: Starting createCategory request...');
    try {
      // Get access token from preferences
      final prefs = await SharedPreferences.getInstance();
      final prefProvider = PrefProvider(prefs);
      final accessToken = prefProvider.getAccessToken();
      
      print('CategoriesServiceImpl: Access token retrieved: ${accessToken.isNotEmpty ? 'Present' : 'Not found'}');
      print('CategoriesServiceImpl: Request data: ${request.toJson()}');

      final response = await _networkApiService.postResponse(
        ApiEndPoints.createCategory,
        request.toJson(),
        accessToken.isNotEmpty ? accessToken : null,
      );

      print('CategoriesServiceImpl: Network response - Status: ${response.status}, Message: ${response.message}');
      print('CategoriesServiceImpl: Response data: ${response.data}');

      if (response.status == Status.COMPLETED) {
        if (response.data != null) {
          print('CategoriesServiceImpl: Processing successful response...');
          final category = Category.fromJson(response.data);
          print('CategoriesServiceImpl: Category created - ID: ${category.categoryId}');
          return ApiResponse(
            Status.COMPLETED,
            category,
            response.message,
          );
        } else {
          print('CategoriesServiceImpl: Response data is null');
          return ApiResponse(
            Status.ERROR,
            null,
            'No category data received',
          );
        }
      } else {
        print('CategoriesServiceImpl: Response status is not COMPLETED');
        
        // Check if it's an authentication error
        if (response.message?.toLowerCase().contains('unauthorized') == true) {
          return ApiResponse(
            Status.ERROR,
            null,
            'Authentication failed. Please log in again.',
          );
        }
        
        return ApiResponse(
          Status.ERROR,
          null,
          response.message ?? 'Failed to create category',
        );
      }
    } catch (e) {
      print('CategoriesServiceImpl: Exception occurred: $e');
      return ApiResponse(
        Status.ERROR,
        null,
        'Failed to create category: $e',
      );
    }
  }
}
