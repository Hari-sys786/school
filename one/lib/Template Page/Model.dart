class smsTemplate {
  String title;
  String description;
  String example;

  smsTemplate(
      {required this.title, required this.description, required this.example});
}

List<smsTemplate> templateList = [
  smsTemplate(
      title: "Re-opens",
      description:
          "Dear Parent, School reopens on {#var#} Admissions are Open, Kennedy Up School",
      example:
          "Dear Parent, School reopens on 04-june-2022 Admissions are Open, Kennedy Up School"),
  smsTemplate(
      title: "Festivals",
      description:
          "Dear Parent, School will be closed from {#var#} in the view of {#var#}, School will re-open on {#var#} Kennedy Up School",
      example:
          "Dear Parent, School will be closed from 26-sep-2022 in the view of Dusshera festival, School will re-open on 07-oct-2022 Kennedy Up School"),
  smsTemplate(
      title: "Sudden Holiday",
      description:
          "Dear Parent, School re-opens on {#var#} Please send your children, Kennedy Up School",
      example:
          "Dear Parent, School re-opens on 04-july-2022 Please send your children, Kennedy Up School"),
  smsTemplate(
      title: "One day holiday",
      description:
          "Dear Parent, Tomorrow is Holiday Due to {#var#}, School reopens on {#var#} Kennedy up School",
      example:
          "Dear Parent, Tomorrow is Holiday Due to Vinayaka chavathi, School reopens on 04-july-2022 Kennedy up School"),
  smsTemplate(
      title: "Fees",
      description:
          "Dear Parent, Please pay your child fees balance Ignore If already Paid. Kennedy Up School",
      example:
          "Dear Parent, Please pay your child fees balance Ignore If already Paid. Kennedy Up School"),
  smsTemplate(
      title: "Public Holiday",
      description:
          "Dear Parent, In the View of {#var#} Celebrations are held at school please attend the event Kennedy Up school",
      example:
          "Dear Parent, In the View of Independence day Celebrations are held at school please attend the event Kennedy Up school"),
];

List<smsTemplate> wishTemp = [
  smsTemplate(
      title: "Vijayadashami",
      description:
          "మీకు మీ కుటుంబ సభ్యులకు విజయదశమి శుభాకాంక్షలు Kennedy Up School",
      example:
          "మీకు మీ కుటుంబ సభ్యులకు విజయదశమి శుభాకాంక్షలు Kennedy Up School"),
  smsTemplate(
      title: "Uniform",
      description:
          "మీ అబ్బాయి/అమ్మాయికి స్కూల్ యూనిఫామ్ కుట్టించ గలరు. Kennedy Up School",
      example:
          "మీ అబ్బాయి/అమ్మాయికి స్కూల్ యూనిఫామ్ కుట్టించ గలరు. Kennedy Up School"),
  smsTemplate(
      title: "Christmas",
      description:
          "మీకు మీ కుటుంబ సభ్యులకు క్రిస్మస్ శుభాకాంక్షలు Kennedy Up School",
      example:
          "మీకు మీ కుటుంబ సభ్యులకు క్రిస్మస్ శుభాకాంక్షలు Kennedy Up School"),
  smsTemplate(
      title: "Sankranthri",
      description:
          "మీకు మీ కుటుంబ సభ్యులకు సంక్రాంతి శుభాకాంక్షలు Kennedy Up School",
      example:
          "మీకు మీ కుటుంబ సభ్యులకు సంక్రాంతి శుభాకాంక్షలు Kennedy Up School"),
  smsTemplate(
      title: "Common",
      description:
          "మీకు మీ కుటుంబ సభ్యులకు {#var#} శుభాకాంక్షలు Kennedy Up School",
      example:
          "మీకు మీ కుటుంబ సభ్యులకు సంక్రాంతి శుభాకాంక్షలు Kennedy Up School"),
];
