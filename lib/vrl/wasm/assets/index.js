import { resolve } from '../Cargo.toml';
import $ from 'jquery';

const initialEvent = {
  message: "bar=baz foo=bar",
  timestamp: "2021-03-02T18:51:01.513+00:00"
};

const initialProgram = `
  . |= parse_key_value!(string!(.message))
  del(.message)
  .id = uuid_v4()
`;

const getResult = (program, event) => {
  const input = {
    program: program,
    event: event
  }

  const vrlResult = resolve(input);

  if (vrlResult.result) {
    let html = JSON.stringify(vrlResult.result);
    $('#event').css('display', 'block').html(html);

    if (vrlResult.output) {
      let out = JSON.stringify(vrlResult.output);
      console.log(out);
      $('#output-box').css('display', 'block');
      $('#output').html(out);
    }
  } else if (vrlResult.error) {
    let html = JSON.stringify(vrlResult.error);
    $('#output-box').css('display', 'block');
    $('#output').html(html);
  }

  $('#program').val('');
}

const run = () => {
  var event = $('#event').text();
  var program = $('#program').val();
  getResult(program, JSON.parse(event));
}

$(() => {
  getResult(initialProgram, initialEvent);

  // Run if the Submit button is clicked
  $('#submit').on('click', () => run());

  // Run if Enter is pressed
  $('#program').on('keypress', (e) => {
    if (e.key == 'Enter') {
      run();
    }
  });
});
