import 'package:ecomerce/core/resources/strings_manager.dart';
import 'package:ecomerce/core/resources/vlaue_manager.dart';
import 'package:ecomerce/core/snack_bar/snack_bar.dart';
import 'package:ecomerce/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/products_block/products_block_bloc.dart';

class EditProductScreen extends StatefulWidget {
  Product? product;
  EditProductScreen(this.product);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late Product _editedProduct;
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    _editedProduct = Product(
        title: '',
        description: '',
        price: 0.0,
        imageUrl: '',
        id: widget.product?.id,
        isFavorite: widget.product?.isFavorite ?? false);
    _imageUrlController.addListener(() {
      _updateImageUrl();
    });
  
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
     print('object');
    if (!_imageUrlFocusNode.hasFocus) {
     
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      } else {
        setState(() {});
      }
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    widget.product = _editedProduct;

    BlocProvider.of<ProductsBloc>(context)
        .add(AddOrUpdateProductEvent(_editedProduct));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.save), onPressed: () => _saveForm()),
        ],
      ),
      body:
          BlocConsumer<ProductsBloc, ProductState>(listener: (context, state) {
        if (state is ProcessProductSnackState) {
          if (state.message == AppStrings.yourProductHaveBeenAdded ||
              state.message == AppStrings.yourProductHaveBeenUpdated) {
            widget.product = null;
          }
        }
      }, builder: (context, state) {
        if (state is LoadedProductState) {
          return bodyBuilt(context);
        } else if (state is ProcessingProductState) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container();
        }
      }),
    );
  }

  Widget bodyBuilt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            TextFormField(
              initialValue: widget.product?.title ?? '',
              decoration: const InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = _editedProduct.copyWith(title: value!);
              },
            ),
            const SizedBox(height: AppSize.s8,),
            TextFormField(
              initialValue: widget.product?.price.toString() ?? '',
              decoration: const InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a price.';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                }
                if (double.parse(value) <= 0) {
                  return 'Please enter a number greater than zero.';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct =
                    _editedProduct.copyWith(price: double.parse(value!));
              },
            ),
            const SizedBox(height: AppSize.s8,),
            TextFormField(
              initialValue: widget.product?.description ?? '',
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description.';
                }
                if (value.length < 10) {
                  return 'Should be at least 10 characters long.';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = _editedProduct.copyWith(description: value);
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(
                    top: 8,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: _imageUrlController.text.isEmpty
                      ? const Text('Enter a URL')
                      : FittedBox(
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: widget.product?.imageUrl,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: widget.product?.imageUrl == null
                        ? _imageUrlController
                        : null,
                    focusNode: _imageUrlFocusNode,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an image URL.';
                      }
                      if (!value.startsWith('http') &&
                          !value.startsWith('https')) {
                        return 'Please enter a valid URL.';
                      }
                      if (!value.endsWith('.png') &&
                          !value.endsWith('.jpg') &&
                          !value.endsWith('.jpeg')) {
                        return 'Please enter a valid image URL.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct =
                          _editedProduct.copyWith(imageUrl: value!);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
