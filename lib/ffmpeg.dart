import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config.dart';
import 'exportprogress.dart';
import 'getinfo.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:shared_preferences/shared_preferences.dart';

class FFmpegTerminal extends StatefulWidget {
  const FFmpegTerminal({Key? key}) : super(key: key);

  @override
  _FFmpegTerminalState createState() => _FFmpegTerminalState();
}

class _FFmpegTerminalState extends State<FFmpegTerminal> {
  final List<String> _commandslist = [
    '-0',
    '-1',
    '-10',
    '-100',
    '-1000',
    '-15',
    '-16',
    '-2',
    '-20',
    '-200ms',
    '-240M',
    '-3',
    '-30',
    '-31',
    '-32',
    '-32768',
    '-4',
    '-40ms',
    '-60',
    '-70',
    '-8',
    '-900',
    '-99',
    '->',
    '-?',
    '-AC-3',
    '-AC3',
    '-Agent',
    '-B-frames',
    '-Cookie',
    '-DBL_MAX',
    '-FLT_MAX',
    '-Factor',
    '-Frame',
    '-GENERIC',
    '-L',
    '-LATM',
    '-Point',
    '-TS',
    '-aac_coder',
    '-ab',
    '-abr',
    '-absf',
    '-ac',
    '-accurate_seek',
    '-acodec',
    '-ad_conv_type',
    '-adrift_threshold',
    '-af',
    '-aframes',
    '-aiv',
    '-algorithm',
    '-allowed_media_types',
    '-alpha_bits',
    '-alternate_scan',
    '-amplification',
    '-an',
    '-analyzeduration',
    '-angle',
    '-antialias',
    '-apad',
    '-application',
    '-apply_defdispwin',
    '-apre',
    '-aq',
    '-aq-mode',
    '-aq-strength',
    '-ar',
    '-arnr-maxframes',
    '-arnr-strength',
    '-arnr-type',
    '-arnr_max_frames',
    '-arnr_strength',
    '-arnr_type',
    '-aspect',
    '-async',
    '-atag',
    '-attach',
    '-aud',
    '-audio_buffer_size',
    '-audio_device_number',
    '-audio_preload',
    '-audio_service_type',
    '-auth_type',
    '-auto-alt-ref',
    '-avioflags',
    '-avoid_negative_ts',
    '-axis',
    '-b',
    '-b-bias',
    '-b-pyramid',
    '-b_sensitivity',
    '-b_strategy',
    '-based',
    '-bass_amount',
    '-bass_range',
    '-benchmark',
    '-benchmark_all',
    '-bf',
    '-bidir_refine',
    '-bit',
    '-bit_rate',
    '-bits_per_codeword',
    '-bits_per_mb',
    '-bits_per_raw_sample',
    '-block',
    '-blocksize',
    '-bluray-compat',
    '-border_mask',
    '-brand',
    '-brd_scale',
    '-bsf',
    '-bsfs',
    '-bt',
    '-buffer_size',
    '-bufsize',
    '-bug',
    '-buildconf',
    '-c',
    '-ca_file',
    '-cafile',
    '-canvas_size',
    '-cbr_quality',
    '-center_mix_level',
    '-center_mixlev',
    '-cert_file',
    '-ch_mode',
    '-change_field_order',
    '-channel',
    '-channel_coupling',
    '-channel_layout',
    '-channels',
    '-chapter',
    '-chars_per_frame',
    '-charset',
    '-cheby',
    '-chroma_elim_threshold',
    '-chroma_intra_matrix',
    '-chroma_sample_location',
    '-chromaoffset',
    '-chunk_duration',
    '-chunk_size',
    '-chunked_post',
    '-cinema_mode',
    '-clev',
    '-clock',
    '-cluster_size_limit',
    '-cluster_time_limit',
    '-cmp',
    '-cname',
    '-code_size',
    '-codec',
    '-codecs',
    '-coder',
    '-color',
    '-color_primaries',
    '-color_range',
    '-color_trc',
    '-colors',
    '-colorspace',
    '-comp_duration',
    '-compression_algo',
    '-compression_level',
    '-compute_pcr',
    '-connect',
    '-content_type',
    '-context',
    '-continue',
    '-cookies',
    '-copyinkf',
    '-copypriorss',
    '-copyright',
    '-copytb',
    '-copyts',
    '-correct_ts_overflow',
    '-cpl_start_band',
    '-cplxblur',
    '-cpu-used',
    '-cpuflags',
    '-crf',
    '-crf_max',
    '-cryptokey',
    '-cubic',
    '-custom_stride',
    '-cutoff',
    '-dark_mask',
    '-data_partitioning',
    '-dc',
    '-dcodec',
    '-dct',
    '-deadline',
    '-deblock',
    '-debug',
    '-debug_ts',
    '-decode',
    '-decoders',
    '-default_delay',
    '-deinterlace',
    '-dframes',
    '-dheadphone_mode',
    '-dia_size',
    '-dialnorm',
    '-direct-pred',
    '-disable_xch',
    '-disto_alloc',
    '-distortion',
    '-dither_method',
    '-dither_scale',
    '-dither_type',
    '-dmix_mode',
    '-dn',
    '-dpi',
    '-dpm',
    '-draw_mouse',
    '-drc_scale',
    '-driver',
    '-drop-frame',
    '-drop_frame_timecode',
    '-dst_format',
    '-dst_h_chr_pos',
    '-dst_range',
    '-dst_v_chr_pos',
    '-dsth',
    '-dstw',
    '-dsur_mode',
    '-dsurex_mode',
    '-dts_delta_threshold',
    '-dts_error_threshold',
    '-dtshd_fallback_time',
    '-dtshd_rate',
    '-dtx',
    '-dual_mono_mode',
    '-dump',
    '-dump_attachment',
    '-dumpgraph',
    '-e-weighted',
    '-ec',
    '-encoders',
    '-encoding',
    '-end',
    '-end_offset',
    '-endian',
    '-energy_levels',
    '-enhance',
    '-err_detect',
    '-error',
    '-error-resilient',
    '-error_protection',
    '-error_rate',
    '-extern_huff',
    '-extra_window_size',
    '-f',
    '-f_err_detect',
    '-fast-pskip',
    '-fastfirstpass',
    '-fdebug',
    '-fflags',
    '-field-first',
    '-field_order',
    '-fifo_size',
    '-file',
    '-filter',
    '-filter_complex',
    '-filter_complex_script',
    '-filter_script',
    '-filter_size',
    '-filter_type',
    '-filters',
    '-final_delay',
    '-first_pts',
    '-fix_sub_duration',
    '-fix_teletext_pts',
    '-fixed_alloc',
    '-fixed_quality',
    '-flags',
    '-flags2',
    '-flush_packets',
    '-flv_metadata',
    '-force_fps',
    '-force_key_frames',
    '-forced_subs_only',
    '-format',
    '-formats',
    '-fpre',
    '-fpsprobesize',
    '-frag_duration',
    '-frag_size',
    '-frame',
    '-frame-parallel',
    '-frame_duration',
    '-frame_size',
    '-framerate',
    '-frames',
    '-frames_per_packet',
    '-friendly',
    '-fs',
    '-ftp-anonymous-password',
    '-ftp-write-seekable',
    '-g',
    '-generated',
    '-gifflags',
    '-global_quality',
    '-gop_timecode',
    '-graph',
    '-graph_file',
    '-guess_layout_max',
    '-h',
    '-hash',
    '-headers',
    '-help',
    '-hex',
    '-hide_banner',
    '-hls_list_size',
    '-hls_time',
    '-hls_wrap',
    '-hwaccel',
    '-hwaccel_device',
    '-i',
    '-ibias',
    '-iblock',
    '-ich',
    '-icl',
    '-icon_title',
    '-icy',
    '-id3v2_version',
    '-idct',
    '-ignore_editlist',
    '-ignore_length',
    '-ignore_loop',
    '-ildctcmp',
    '-in',
    '-in_channel_count',
    '-in_channel_layout',
    '-in_sample_fmt',
    '-in_sample_rate',
    '-indexmem',
    '-individual_header_trailer',
    '-infty',
    '-initial_offset',
    '-initial_pause',
    '-inspired',
    '-inter_matrix',
    '-internal_sample_fmt',
    '-intra',
    '-intra-refresh',
    '-intra_matrix',
    '-intra_vlc',
    '-iods_audio_profile',
    '-iods_video_profile',
    '-isf',
    '-ism_lookahead',
    '-isr',
    '-isync',
    '-itsoffset',
    '-itsscale',
    '-iv',
    '-joint_stereo',
    '-kaiser_beta',
    '-keep_ass_markup',
    '-key',
    '-key_file',
    '-keyframes',
    '-keyint_min',
    '-knee',
    '-lag-in-frames',
    '-last_pred',
    '-lavfi',
    '-layer',
    '-layouts',
    '-length',
    '-level',
    '-lfe_mix_level',
    '-linear',
    '-linear_interp',
    '-linespeed',
    '-list_devices',
    '-list_dither',
    '-list_drivers',
    '-list_options',
    '-listen',
    '-listen_timeout',
    '-lmax',
    '-lmin',
    '-localaddr',
    '-localport',
    '-location',
    '-loglevel',
    '-lookahead_count',
    '-loop',
    '-loopend',
    '-loopstart',
    '-loro_cmixlev',
    '-loro_surmixlev',
    '-lossless',
    '-lowpass',
    '-lowqual',
    '-lowres',
    '-lpc_coeff_precision',
    '-lpc_passes',
    '-lpc_type',
    '-ltrt_cmixlev',
    '-ltrt_surmixlev',
    '-luma_elim_threshold',
    '-lumi_aq',
    '-lumi_mask',
    '-mail',
    '-map',
    '-map_channel',
    '-map_chapters',
    '-map_metadata',
    '-matrix_encoding',
    '-max-intra-rate',
    '-max_alloc',
    '-max_delay',
    '-max_error_rate',
    '-max_extra_cb_iterations',
    '-max_file_size',
    '-max_interleave_delta',
    '-max_partition_order',
    '-max_port',
    '-max_prediction_order',
    '-max_samples',
    '-max_size',
    '-max_soft_comp',
    '-max_strips',
    '-maxrate',
    '-mb_info',
    '-mb_threshold',
    '-mbcmp',
    '-mbd',
    '-mblmax',
    '-mblmin',
    '-mbs_per_slice',
    '-mbtree',
    '-me_method',
    '-me_range',
    '-me_threshold',
    '-memc_only',
    '-mepc',
    '-metadata',
    '-metadata_header_padding',
    '-min_comp',
    '-min_delay',
    '-min_frag_duration',
    '-min_hard_comp',
    '-min_partition_order',
    '-min_port',
    '-min_prediction_order',
    '-min_strips',
    '-minrate',
    '-mixed-refs',
    '-mixing_level',
    '-mode',
    '-moov_size',
    '-movflags',
    '-mpeg_quant',
    '-mpegts_copyts',
    '-mpegts_flags',
    '-mpegts_m2ts_mode',
    '-mpegts_original_network_id',
    '-mpegts_pmt_start_pid',
    '-mpegts_service_id',
    '-mpegts_start_pid',
    '-mpegts_transport_stream_id',
    '-mpv_flags',
    '-multiple_requests',
    '-muxdelay',
    '-muxpreload',
    '-muxrate',
    '-mv0_threshold',
    '-n',
    '-nal-hrd',
    '-nitris_compat',
    '-no_bitstream',
    '-no_resync_search',
    '-noise_reduction',
    '-non_linear_quant',
    '-nr',
    '-nssew',
    '-numlayers',
    '-numresolution',
    '-obmc',
    '-och',
    '-ocl',
    '-of-stream',
    '-offset',
    '-offset_x',
    '-offset_y',
    '-oggpagesize',
    '-only',
    '-optimize_mono',
    '-original',
    '-osf',
    '-osr',
    '-out',
    '-out_channel_count',
    '-out_channel_layout',
    '-out_h',
    '-out_sample_fmt',
    '-out_sample_rate',
    '-out_w',
    '-output_channel',
    '-output_sample_bits',
    '-output_ts_offset',
    '-outputs',
    '-override_ffserver',
    '-overrun_nonfatal',
    '-p_mask',
    '-packet_loss',
    '-packetsize',
    '-page_duration',
    '-pagesize',
    '-palette',
    '-param0',
    '-param1',
    '-partitions',
    '-pass',
    '-passlogfile',
    '-password',
    '-pattern_type',
    '-payload_type',
    '-pbias',
    '-peak',
    '-pel',
    '-per_frame_metadata',
    '-pes_payload_size',
    '-phase_shift',
    '-pix_fmt',
    '-pix_fmts',
    '-pixel_format',
    '-pkt_size',
    '-playlist',
    '-point',
    '-post_data',
    '-postfilter',
    '-pre',
    '-pre_dia_size',
    '-precision',
    '-precmp',
    '-pred',
    '-prediction_order_method',
    '-preload',
    '-preme',
    '-preset',
    '-probesize',
    '-processed',
    '-profile',
    '-prog_order',
    '-progress',
    '-protocols',
    '-ps',
    '-psnr',
    '-psy',
    '-psy-rd',
    '-psymodel',
    '-q',
    '-qblur',
    '-qcomp',
    '-qdiff',
    '-qmax',
    '-qmin',
    '-qp',
    '-qpel-blocksize',
    '-qphist',
    '-qscale',
    '-qsquish',
    '-quake3_compat',
    '-quality',
    '-quant_mat',
    '-quantizer_noise_shaping',
    '-r',
    '-ray',
    '-rc-lookahead',
    '-rc_buf_aggressivity',
    '-rc_eq',
    '-rc_init_cplx',
    '-rc_init_occupancy',
    '-rc_lookahead',
    '-rc_max_vbv_use',
    '-rc_min_vbv_use',
    '-rc_override',
    '-rc_qmod_amp',
    '-rc_qmod_freq',
    '-rc_strategy',
    '-re',
    '-readable',
    '-refcounted_frames',
    '-reference',
    '-reference_stream',
    '-refs',
    '-reinit_filter',
    '-rematrix_maxval',
    '-rematrix_volume',
    '-remove_at_exit',
    '-reorder_queue_size',
    '-replaygain',
    '-replaygain_noclip',
    '-replaygain_preamp',
    '-report',
    '-request_channel_layout',
    '-request_channels',
    '-request_sample_fmt',
    '-resample_cutoff',
    '-resampler',
    '-resend_headers',
    '-reserve_index_space',
    '-reservoir',
    '-reset_timestamps',
    '-reuse',
    '-reverb_delay',
    '-reverb_depth',
    '-rf64',
    '-rmvol',
    '-room_type',
    '-rtbufsize',
    '-rtmp_app',
    '-rtmp_playpath',
    '-rtp_flags',
    '-rtpflags',
    '-rtsp_flags',
    '-rtsp_transport',
    '-s',
    '-safe',
    '-same_quant',
    '-sameq',
    '-sample',
    '-sample_fmt',
    '-sample_fmts',
    '-sample_rate',
    '-sample_size',
    '-sc_factor',
    '-sc_threshold',
    '-scan',
    '-scan_offset',
    '-scodec',
    '-scplx_mask',
    '-sdp_flags',
    '-seek2any',
    '-seekable',
    '-segment_format',
    '-segment_frames',
    '-segment_list',
    '-segment_list_entry_prefix',
    '-segment_list_flags',
    '-segment_list_size',
    '-segment_list_type',
    '-segment_start_number',
    '-segment_time',
    '-segment_time_delta',
    '-segment_times',
    '-segment_wrap',
    '-segment_wrap_number',
    '-send_expect_100',
    '-separated',
    '-seq',
    '-shortest',
    '-show_region',
    '-skip_alpha',
    '-skip_bottom',
    '-skip_empty_cb',
    '-skip_exp',
    '-skip_factor',
    '-skip_frame',
    '-skip_idct',
    '-skip_initial_bytes',
    '-skip_iods',
    '-skip_loop_filter',
    '-skip_threshold',
    '-skip_top',
    '-skipcmp',
    '-slev',
    '-slice-max-size',
    '-slicecrc',
    '-slices',
    '-smc-interval',
    '-sn',
    '-spdif_flags',
    '-spec-compliant',
    '-specific',
    '-speed',
    '-spre',
    '-src_format',
    '-src_h_chr_pos',
    '-src_range',
    '-src_v_chr_pos',
    '-srch',
    '-srcw',
    '-srtp_in_params',
    '-srtp_in_suite',
    '-srtp_out_params',
    '-srtp_out_suite',
    '-ss',
    '-ssim',
    '-ssim_acc',
    '-ssrc',
    '-stag',
    '-standard',
    '-standardized',
    '-start',
    '-start_number',
    '-start_number_range',
    '-start_time',
    '-start_time_realtime',
    '-stats',
    '-stdin',
    '-stereo_mode',
    '-stereo_rematrixing',
    '-stimeout',
    '-streamid',
    '-strftime',
    '-strict',
    '-strict-displaywin',
    '-strip_number_adaptivity',
    '-structured_slices',
    '-sub_charenc',
    '-sub_charenc_mode',
    '-subcmp',
    '-subfps',
    '-subq',
    '-surround_delay',
    '-surround_depth',
    '-surround_mix_level',
    '-surround_mixlev',
    '-svcd',
    '-swr_flags',
    '-sws_dither',
    '-sws_flags',
    '-t',
    '-t2',
    '-tables_version',
    '-tag',
    '-target',
    '-tcplx_mask',
    '-thread_type',
    '-threads',
    '-ticks_per_frame',
    '-tile-columns',
    '-tile-rows',
    '-time',
    '-timecode',
    '-timecode_frame_start',
    '-timelimit',
    '-timeout',
    '-timestamp',
    '-tls_verify',
    '-to',
    '-top',
    '-trans_color',
    '-trellis',
    '-truncate',
    '-ts_from_file',
    '-ts_packetsize',
    '-tsf',
    '-ttl',
    '-tune',
    '-tvstd',
    '-uch',
    '-umv',
    '-update',
    '-updatefirst',
    '-use_absolute_path',
    '-use_editlist',
    '-use_odml',
    '-use_wallclock_as_timestamps',
    '-used_channel_count',
    '-user-agent',
    '-user_agent',
    '-usetoc',
    '-v',
    '-vad',
    '-variance',
    '-variance_aq',
    '-vbr',
    '-vbsf',
    '-vc',
    '-vcd',
    '-vcodec',
    '-vdt',
    '-vendor',
    '-verbosity',
    '-version',
    '-vf',
    '-vframes',
    '-video_device_number',
    '-video_size',
    '-video_stream',
    '-video_stream_expr',
    '-video_stream_h',
    '-video_stream_ptxt',
    '-video_stream_w',
    '-video_track_timescale',
    '-vismv',
    '-vn',
    '-vol',
    '-vp8',
    '-vp8flags',
    '-vp9',
    '-vpre',
    '-vstats',
    '-vstats_file',
    '-vsync',
    '-vtag',
    '-way',
    '-weightb',
    '-weighted',
    '-weightp',
    '-width',
    '-window_fullscreen',
    '-window_size',
    '-window_title',
    '-wpredp',
    '-write_apetag',
    '-write_bext',
    '-write_header',
    '-write_header_trailer',
    '-write_id3v1',
    '-write_id3v2',
    '-write_xing',
    '-x264-params',
    '-x264opts',
    '-x265-params',
    '-xerror',
    '-y'
  ];
  final ScrollController _contr = ScrollController();

  String suggestiontext = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await getStoreversion();
      final prefs = await SharedPreferences.getInstance();
      final bool? tut = prefs.getBool('tut');
      if (tut == null) {
        Alert(
          style: Config.alertConfig,
          context: context,
          title: 'Note',
          desc: '''Please do not mention the input and output commands as it is handled by the app.

Use " " to insert spaces.

This app cannot process audio files as an output format.

Font config and vid.stab will be supported soon.''',
          buttons: [
            DialogButton(
              highlightColor: const Color.fromRGBO(0, 0, 0, 0),
              splashColor: const Color.fromRGBO(0, 0, 0, 0),
              radius: const BorderRadius.all(Radius.circular(20)),
              color: Config.bbcolor,
              child: Text(
                "Next",
                style: TextStyle(color: Config.backgroundColor, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Alert(
                  style: Config.alertConfig,
                  context: context,
                  title: 'Usage',
                  desc: 'Pressing space bar on keyboard will do the work.',
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Image.asset('assets/wr.png'),
                            const Icon(
                              Icons.close_rounded,
                              size: 75,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Image.asset('assets/ri.png'),
                          const Icon(
                            Icons.done_rounded,
                            size: 75,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                      splashColor: const Color.fromRGBO(0, 0, 0, 0),
                      radius: const BorderRadius.all(Radius.circular(20)),
                      color: Config.bbcolor,
                      child: Text(
                        "OK",
                        style: TextStyle(color: Config.backgroundColor, fontSize: 20),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await prefs.setBool('tut', true);
                      },
                      width: 120,
                    )
                  ],
                ).show();
              },
              width: 120,
            )
          ],
        ).show();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final FocusNode _focus = FocusNode();
  final FocusNode _focus1 = FocusNode();

  bool editmode = false;
  var videoinfo = GetMediaInfo();
  double tduration = 0;
  int dinvcma = 0;
  TextEditingController tct = TextEditingController();
  TextEditingController exn = TextEditingController();
  int cindex = -1;
  List<String> finalarg = [];
  List<Map> displayarg = [
    {'command': 'ffmpeg', 'allowedit': false, 'iscommand': false}
  ];
  int listlength = 1;
  getStoreversion() async {
    String localVersion = '1.1.9';
    final uri = Uri.https("play.google.com", "/store/apps/details", {"id": "com.crossplat.ffmpegmobile"});
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    final document = parse(response.body);
    final additionalInfoElements = document.getElementsByClassName('hAyfc');
    final versionElement = additionalInfoElements.firstWhere(
      (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
    );
    final storeVersion = versionElement.querySelector('.htlgb')!.text;
    final sectionElements = document.getElementsByClassName('W4P4ne');
    final releaseNotesElement = sectionElements.firstWhere(
      (elm) => elm.querySelector('.wSaTQd')!.text == 'What\'s New',
    );
    final releaseNotes = releaseNotesElement.querySelector('.PHBdkd')?.querySelector('.DWPxHb')?.text;
    String rNotes = '';
    for (int i = 0; i < releaseNotes!.length; i++) {
      if (releaseNotes[i] == '.') {
        rNotes += releaseNotes[i];
        if (!(i == releaseNotes.length - 1)) {
          rNotes += '\n\n';
        }
      } else {
        rNotes += releaseNotes[i];
      }
    }
    if (localVersion != storeVersion) {
      await Alert(
        style: Config.alertConfig,
        context: context,
        title: "Update Availible",
        desc: rNotes,
        buttons: [
          DialogButton(
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
            splashColor: const Color.fromRGBO(0, 0, 0, 0),
            radius: const BorderRadius.all(Radius.circular(20)),
            color: Config.bbcolor,
            child: Text(
              "Update",
              style: TextStyle(color: Config.backgroundColor, fontSize: 20),
            ),
            onPressed: () {
              launch('https://play.google.com/store/apps/details?id=com.crossplat.ffmpegmobile');
              Navigator.pop(context);
            },
            width: 120,
          ),
          DialogButton(
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
            splashColor: const Color.fromRGBO(0, 0, 0, 0),
            radius: const BorderRadius.all(Radius.circular(20)),
            color: Config.bbcolor,
            child: Text(
              "Cancel",
              style: TextStyle(color: Config.backgroundColor, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          ),
        ],
      ).show();
    }
  }

  shortcutbutton(button) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            tct.text += button;
            tct.selection = TextSelection.fromPosition(
              TextPosition(
                offset: tct.text.length,
              ),
            );
          });
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 2, right: 2),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Config.bbcolor.withOpacity(0.1),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Text(
            button,
            style: TextStyle(color: Config.textcolor, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  comwidget(index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (!editmode) cindex = index;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: (cindex == index)
                ? displayarg[index]['allowedit']
                    ? Colors.blueGrey.withOpacity(0.3)
                    : Colors.red.withOpacity(0.3)
                : Config.backgroundColor,
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
            child: Text(
              displayarg[index]['command'],
              style: TextStyle(
                color: displayarg[index]['iscommand'] ? Colors.purple.shade400 : Config.textcolor,
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (cindex == index && displayarg[index]['allowedit'])
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: InkWell(
                    onTap: () {
                      if (displayarg[cindex - 1]['allowedit']) {
                        setState(() {
                          var temp = displayarg[cindex];
                          var temp2 = finalarg[cindex - 1];
                          displayarg[cindex] = displayarg[cindex - 1];
                          finalarg[cindex - 1] = finalarg[cindex - 2];
                          displayarg[cindex - 1] = temp;
                          finalarg[cindex - 2] = temp2;
                          cindex--;
                        });
                      }
                    },
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.blue.shade500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (!(cindex == displayarg.length - 1)) {
                          if (displayarg[cindex + 1]['allowedit']) {
                            var temp = displayarg[cindex];
                            var temp2 = finalarg[cindex - 1];
                            displayarg[cindex] = displayarg[cindex + 1];
                            finalarg[cindex - 1] = finalarg[cindex];
                            displayarg[cindex + 1] = temp;
                            finalarg[cindex] = temp2;
                            cindex++;
                          }
                        }
                      });
                    },
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.orange.shade500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    if (editmode) {
                      setState(() {
                        tct.text = '';
                        FocusScope.of(context).unfocus();
                        editmode = false;
                        cindex = -1;
                      });
                    } else {
                      setState(() {
                        FocusScope.of(context).requestFocus();
                        tct.text = displayarg[index]['command'];
                        editmode = true;
                      });
                    }
                  },
                  child: Icon(
                    editmode ? Icons.cancel_outlined : Icons.edit_outlined,
                    color: Colors.teal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      displayarg.removeAt(cindex);
                      finalarg.removeAt(cindex - 1);
                      listlength = displayarg.length;
                      tct.text = '';
                      FocusScope.of(context).unfocus();
                      cindex = -1;
                      editmode = false;
                    });
                  },
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red.shade300,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  importmedia() async {
    bool storagepermisson = await Config.requestpermission(Permission.storage);
    if (!storagepermisson) {
      Alert(
        style: Config.alertConfig,
        context: context,
        title: "Please give media and storage permission",
        buttons: [
          DialogButton(
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
            splashColor: const Color.fromRGBO(0, 0, 0, 0),
            radius: const BorderRadius.all(Radius.circular(20)),
            color: Config.bbcolor,
            child: Text(
              "OK",
              style: TextStyle(color: Config.backgroundColor, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    } else {
      await Config.createfolder("FFmpeg");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();

        for (int i = 0; i < files.length; i++) {
          var info = await videoinfo.getfileinfo(result.files[i].path.toString());
          if (info['duration'] != null) {
            tduration += double.parse(info['duration']) * 1000;
          }
          finalarg.add('-i');
          finalarg.add(result.files[i].path!);
          displayarg.add({'command': '-i', 'allowedit': false, 'iscommand': true});
          displayarg.add({'command': result.files[i].name, 'allowedit': false, 'iscommand': false});
        }
        setState(() {
          listlength = displayarg.length;
        });
      } else {
        Alert(
          style: Config.alertConfig,
          context: context,
          title: "No files selected",
          buttons: [
            DialogButton(
              highlightColor: const Color.fromRGBO(0, 0, 0, 0),
              splashColor: const Color.fromRGBO(0, 0, 0, 0),
              radius: const BorderRadius.all(Radius.circular(20)),
              color: Config.bbcolor,
              child: Text(
                "OK",
                style: TextStyle(color: Config.backgroundColor, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    }
  }

  String makesuggestion(String command) {
    List<String> filtered = [];
    if (command.contains('-') && command.length > 2) {
      for (String item in _commandslist) {
        if (item.contains(command)) {
          filtered.add(item);
        } else {
          continue;
        }
      }
      return filtered.isNotEmpty ? filtered.first : '';
    } else {
      return '';
    }
  }

  stol(command) {
    if (!editmode) {
      dinvcma = '"'.allMatches(command).length;
      if (command.isNotEmpty) {
        if (command.endsWith("'") && dinvcma % 2 == 0) {
          setState(() {
            tct.text = "${command.replaceAll("'", "\"")}''";
          });
        }
        if (command.endsWith(" ") && dinvcma % 2 == 0) {
          setState(() {
            if (command.trim() != '' && command.trim() != ' ') {
              finalarg.add(command.trim().replaceAll("\"", ""));
              if (command.toString().startsWith('-')) {
                displayarg.add({'command': command.trim(), 'allowedit': true, 'iscommand': true});
              } else {
                displayarg.add({'command': command.trim(), 'allowedit': true, 'iscommand': false});
              }

              listlength = displayarg.length;
              tct.text = '';
            }
            _contr.jumpTo(_contr.position.maxScrollExtent);
          });
        }
      }
    }
    setState(() {
      suggestiontext = makesuggestion(command);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool dtheme = MediaQuery.of(context).platformBrightness == Brightness.light ? true : false;
    Config.changeColor(dtheme);
    return Scaffold(
      backgroundColor: Config.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 225),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                controller: _contr,
                itemCount: listlength,
                itemBuilder: (BuildContext context, int index) => comwidget(index),
              ),
            ),
            Column(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                  decoration: BoxDecoration(
                    color: Config.tilesColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MaterialButton(
                        elevation: 0,
                        padding: const EdgeInsets.all(10),
                        color: Config.bbcolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onPressed: () => importmedia(),
                        child: Text(
                          'Import Media',
                          style: TextStyle(
                            color: Config.backgroundColor,
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: Config.backgroundColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Text(
                              suggestiontext,
                              style: TextStyle(
                                color: Config.textcolor.withOpacity(0.3),
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            TextField(
                              onTap: () {
                                setState(() {
                                  if (suggestiontext.isNotEmpty) {
                                    tct.text = suggestiontext;
                                    tct.selection = TextSelection.fromPosition(TextPosition(offset: tct.text.length));
                                  }
                                });
                              },
                              focusNode: _focus,
                              onEditingComplete: () {
                                String command = tct.text;
                                if (editmode) {
                                  setState(() {
                                    if (tct.text == '') {
                                      displayarg.removeAt(cindex);
                                      finalarg.removeAt(cindex - 1);
                                      listlength = displayarg.length;
                                    } else {
                                      displayarg[cindex]['command'] = tct.text;
                                      finalarg[cindex - 1] = tct.text.replaceAll("\"", "");
                                    }
                                    tct.text = '';
                                    cindex = -1;
                                    editmode = false;
                                    _contr.jumpTo(_contr.position.maxScrollExtent);
                                  });
                                } else {
                                  setState(() {
                                    _focus.unfocus();
                                    _focus1.requestFocus();
                                    if (command.trim() != '' && command.trim() != ' ') {
                                      finalarg.add(command.trim().replaceAll("\"", ""));
                                      if (command.toString().startsWith('-')) {
                                        displayarg
                                            .add({'command': command.trim(), 'allowedit': true, 'iscommand': true});
                                      } else {
                                        displayarg
                                            .add({'command': command.trim(), 'allowedit': true, 'iscommand': false});
                                      }
                                      listlength = displayarg.length;
                                      tct.text = '';
                                    }
                                    _contr.jumpTo(_contr.position.maxScrollExtent);
                                  });
                                }
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (command) => stol(command),
                              style: TextStyle(
                                  color: Config.textcolor,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              controller: tct,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: 'Enter your commands here',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              decoration: BoxDecoration(
                                color: Config.backgroundColor,
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: TextField(
                                focusNode: _focus1,
                                onChanged: (value) {},
                                style: TextStyle(
                                  color: Config.textcolor,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                controller: exn,
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: 'Output format',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            height: 50,
                            elevation: 0,
                            padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
                            color: Config.bbcolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            onPressed: () {
                              if (exn.text != '') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExportProgress(
                                      arguments: finalarg,
                                      duration: tduration.toString(),
                                      exten: exn.text.replaceAll('.', ''),
                                    ),
                                  ),
                                );
                              } else {
                                Alert(
                                  style: Config.alertConfig,
                                  context: context,
                                  title: 'Please enter the output format',
                                  buttons: [
                                    DialogButton(
                                      highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                                      splashColor: const Color.fromRGBO(0, 0, 0, 0),
                                      radius: const BorderRadius.all(Radius.circular(20)),
                                      color: Config.bbcolor,
                                      child: Text(
                                        "OK",
                                        style: TextStyle(color: Config.backgroundColor, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                            },
                            child: Text(
                              'Execute',
                              style: TextStyle(
                                color: Config.backgroundColor,
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: (MediaQuery.of(context).viewInsets.bottom > 125)
                            ? Divider(color: Config.textcolor.withOpacity(0.5))
                            : null,
                      ),
                      SizedBox(
                        child: (MediaQuery.of(context).viewInsets.bottom > 125)
                            ? Row(
                                children: [
                                  shortcutbutton('-'),
                                  shortcutbutton('='),
                                  shortcutbutton(':'),
                                  shortcutbutton(';'),
                                  shortcutbutton('"'),
                                  shortcutbutton('/'),
                                  shortcutbutton('('),
                                  shortcutbutton(')'),
                                  shortcutbutton('['),
                                  shortcutbutton(']'),
                                ],
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
