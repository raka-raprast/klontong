import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klontong/core/services/new_product_service.dart';
import 'package:klontong/core/utils/notification.dart';
import 'package:klontong/data/models/product.dart';
import 'package:klontong/data/repositories/new_product_repository.dart';
import 'package:klontong/presentation/bloc/product/new_product/new_product_bloc.dart';

class AddNewProductScreen extends StatefulWidget {
  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final Cloudinary _cloudinary = Cloudinary.signedConfig(
    cloudName: 'dtb7tvlgu',
    apiKey: '544718533339783',
    apiSecret: 'mAhi4MaFs_S1O2xPFsWGtfvFOuI',
  );

  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    final NewProductApiClient apiClient = NewProductApiClient();
    final NewProductRepositoryImpl newProductRepository =
        NewProductRepositoryImpl(apiClient);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NewProductBloc(newProductRepository))
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Product'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<NewProductBloc, NewProductState>(
            listener: (context, state) {
              if (state is NewProductAddedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added successfully!')),
                );
                Navigator.pop(context);
              } else if (state is NewProductErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    defaultForm(
                      controller: _categoryIdController,
                      decoration:
                          const InputDecoration(labelText: 'Category ID'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category ID';
                        }
                        return null;
                      },
                    ),
                    defaultForm(
                      controller: _categoryNameController,
                      decoration:
                          const InputDecoration(labelText: 'Category Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category name';
                        }
                        return null;
                      },
                    ),
                    defaultForm(
                      controller: _skuController,
                      decoration: const InputDecoration(labelText: 'SKU'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an SKU';
                        }
                        return null;
                      },
                    ),
                    defaultForm(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    defaultForm(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    defaultForm(
                      controller: _weightController,
                      decoration: const InputDecoration(labelText: 'Weight'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a weight';
                        }
                        return null;
                      },
                    ),
                    defaultForm(
                      controller: _widthController,
                      decoration: const InputDecoration(labelText: 'Width'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a width';
                        }
                        return null;
                      },
                    ),
                    defaultForm(
                      controller: _lengthController,
                      decoration: const InputDecoration(labelText: 'Length'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a length';
                        }
                        return null;
                      },
                    ),
                    defaultForm(
                      controller: _heightController,
                      decoration: const InputDecoration(labelText: 'Height'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a height';
                        }
                        return null;
                      },
                    ),
                    defaultForm(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _imageFile != null
                        ? Image.file(
                            File(_imageFile!.path),
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            fit: BoxFit.fitWidth,
                          )
                        : GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: const Center(
                                child: Icon(Icons.add),
                              ),
                            ),
                          ),
                    const SizedBox(height: 16),
                    // ElevatedButton(
                    //   onPressed: _pickImage,
                    //   child: Text('Pick Image'),
                    // ),
                    const SizedBox(height: 16),
                    // if (_uploadUrl != null) ...[
                    //   const SizedBox(height: 16),
                    //   const Text('Image URL:'),
                    //   Text(_uploadUrl!),
                    // ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _submitForm(context);
                      },
                      child: const Text('Add Product'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<String> _uploadImage() async {
    if (_imageFile == null) return "";

    try {
      final response = await _cloudinary.upload(
        file: _imageFile!.path,
        resourceType: CloudinaryResourceType.image,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload successful!')),
      );

      return response.secureUrl ?? "";
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
      return "";
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    var url = await _uploadImage();

    if (url.isNotEmpty) {
      if (_formKey.currentState?.validate() ?? false) {
        final product = Product(
          id: '', // Assuming the ID will be generated by the backend
          categoryId: int.parse(_categoryIdController.text),
          categoryName: _categoryNameController.text,
          sku: _skuController.text,
          name: _nameController.text,
          description: _descriptionController.text,
          weight: double.parse(_weightController.text),
          width: double.parse(_widthController.text),
          length: double.parse(_lengthController.text),
          height: double.parse(_heightController.text),
          imageUrl: url, // Use uploaded URL or empty string
          price: double.parse(_priceController.text),
        );

        BlocProvider.of<NewProductBloc>(context)
            .add(AddNewProductEvent(product));
      }
    } else {
      showSnackbar(
          context, 'Error can\'t create new product please try again!');
    }
  }

  Widget defaultForm(
      {required TextEditingController controller,
      InputDecoration? decoration,
      TextInputType? keyboardType,
      String? Function(String?)? validator}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none, labelText: decoration?.labelText),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
