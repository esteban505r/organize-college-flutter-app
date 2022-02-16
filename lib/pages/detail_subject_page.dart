import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organize_college/bloc/subjects/subjects_cubit.dart';
import 'package:organize_college/bloc/subjects/subjects_state.dart';
import 'package:organize_college/models/subject_model.dart';
import 'package:organize_college/utils/colors.dart';
import 'package:organize_college/utils/icons_info.dart';

class DetailSubjectPage extends StatefulWidget {
  final int id;

  const DetailSubjectPage(this.id, {Key? key}) : super(key: key);

  @override
  State<DetailSubjectPage> createState() => _DetailSubjectPageState();
}

class _DetailSubjectPageState extends State<DetailSubjectPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<SubjectsCubit>().getSubjectById(widget.id);
    });
    return Scaffold(
      body: BlocBuilder<SubjectsCubit, SubjectsState>(
          builder: (context, snapshot) {
        switch (snapshot.runtimeType) {
          case SubjectsLoading:
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          case SubjectsInitial:
          case SubjectsFilled:
            SubjectModel subjectModel = snapshot
                .getSubjects()
                .firstWhere((element) => element.id == widget.id);
            return _createWidgetSubjectsFilled(subjectModel);
          case SubjectsError:
            return const Center(
              child: Text("ERROR"),
            );
          default:
            return Container();
        }
      }),
    );
  }

  Widget _buildFab() {
    //starting fab position
    const double defaultTopMargin = 206.0 - 4.0;
    //pixels from top where scaling should start
    const double scaleStart = 96.0;
    //pixels from top where scaling should end
    const double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: AppColors.secondaryColor,
          onPressed: () => {},
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _createWidgetSubjectsFilled(SubjectModel subjectModel) {
    return Stack(
      children: [
        NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(subjectModel.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: Container(
                      color: AppColors.primaryColor,
                      child: SafeArea(
                          child: Icon(
                        IconsInfo.getIconById(subjectModel.icon ?? 0).icon,
                        size: 50,
                        color: Colors.white,
                      )),
                    )),
              ),
            ];
          },
          body: Column(
            children: [],
          ),
        ),
        _buildFab()
      ],
    );
  }
}
