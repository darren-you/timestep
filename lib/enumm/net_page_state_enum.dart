enum NetPageStateEnum {
  pageLoading(state: -1),
  pageError(state: 0),
  pageSuccess(state: 1),
  pageDown(state: 2),
  ;

  final int state;

  const NetPageStateEnum({
    required this.state,
  });
}
