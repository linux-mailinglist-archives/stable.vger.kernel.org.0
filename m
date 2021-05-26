Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC2C390F42
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 06:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhEZET1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 00:19:27 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:59621 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhEZET0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 00:19:26 -0400
Received: from leknes.fjasle.eu ([92.116.119.165]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MUGuZ-1lunFR3J4t-00RGqP for <stable@vger.kernel.org>; Wed, 26 May 2021
 06:17:54 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id 2AA3C3C575; Wed, 26 May 2021 06:17:54 +0200 (CEST)
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     nicolas@fjasle.eu
Cc:     stable@vger.kernel.org
Subject: [PATCH 4.9 0/2] Allow builds and script usage on current systems
Date:   Wed, 26 May 2021 06:17:50 +0200
Message-Id: <20210526041752.4114476-1-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:gNZTe4rZxeQYVolyJ8NWgfdE65x23+d6SAeKItjEeDpXL0cdR9A
 TTWc3TvvRQzoN0+XLJsjEoCX0tz2BSz1KJVuMNoR51d108SD5DYG3HWjkCQRjddlnyg3gS/
 4g2tV03gfRwSF8yP1pf+sMNzftskPaW+9hxqMFBODlR2gkywgeP6zc31kV7Kl/C0l9NNtsH
 h3+0CfbQS6z6VgHznP3vw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:N0OSq2sOLw0=:E641rTpPKDYBr+H5MU9RFb
 1BxvWtPaCQynAdS78f22CXQS+un2xXUtkY6KBU5C8NyBwiIg28DD/I8S6Hpr6dOHEkju/2jDY
 PaQ2PSyXqQJqAhNYPyLgdvkaSL5mOaP+Uzrr0CSrfKc2r7pyD5fG50pIzW8VhJuqB+zuFWL0R
 NIMyGKKWIbT1duL8k+9kd9DzakbDLZ07fkv9Pl1uDQoeek0uQex54W2YZ7WBhIQrPpWyB7iH6
 fgeF4PqoLQnQeMrLBRsYz+g9aZSq3zY7bzw01RzIjdQHxjkrrFrj7CY56GljzjgvTC3nL4dsL
 sDCXHPR+H7rpkrKUi7rWor/ryIMD8+O/lbx9TXlBudfmeKl8VtcvsY0HMn3QCtUK5PJmDyw5H
 EISf7QFwqq8I+3yFTKgyZoX4VAg7skUDSWU6VtEwDmUzj13wJGoeapJzW5+Nctbn9Jx8Nlv4R
 z2+Va8W9cE9/1ZOaM/2m+14k/HmwYT7182icEXpGi+mGOxkMg8HEkirfIfNQavKFlm0L11mot
 c1PcUeIk+hEhOpFpCUzVLM=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Current distributions start removing support for Python 2 (and thus
/usr/bin/python).  To still be able to build v4.9.y and to run
supplementary scripts fix shebang lines to use 'env' and switch
diffconfig and bloat-o-meter to Python 3 explicitly.

Python 3 availability should be given on v4.9 based distributions
(for comparison: Debian jessie 8 (est. 2013) shipped a 3.16 kernel and
Python 3).

Both upstream commits are originally included in v5.11 and re-applied on
v5.10, v5.4 and v4.19.


Andy Shevchenko (1):
  scripts: switch explicitly to Python 3

Finn Behrens (1):
  tweewide: Fix most Shebang lines

 Documentation/sphinx/parse-headers.pl                          | 2 +-
 Documentation/target/tcm_mod_builder.py                        | 2 +-
 Documentation/trace/postprocess/decode_msr.py                  | 2 +-
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl | 2 +-
 Documentation/trace/postprocess/trace-vmscan-postprocess.pl    | 2 +-
 arch/ia64/scripts/unwcheck.py                                  | 2 +-
 scripts/analyze_suspend.py                                     | 2 +-
 scripts/bloat-o-meter                                          | 2 +-
 scripts/bootgraph.pl                                           | 2 +-
 scripts/checkincludes.pl                                       | 2 +-
 scripts/checkstack.pl                                          | 2 +-
 scripts/config                                                 | 2 +-
 scripts/diffconfig                                             | 2 +-
 scripts/dtc/dt_to_config                                       | 2 +-
 scripts/extract_xc3028.pl                                      | 2 +-
 scripts/get_dvb_firmware                                       | 2 +-
 scripts/markup_oops.pl                                         | 2 +-
 scripts/profile2linkerlist.pl                                  | 2 +-
 scripts/show_delta                                             | 2 +-
 scripts/stackdelta                                             | 2 +-
 scripts/tracing/draw_functrace.py                              | 2 +-
 tools/kvm/kvm_stat/kvm_stat                                    | 2 +-
 tools/perf/python/tracepoint.py                                | 2 +-
 tools/perf/python/twatch.py                                    | 2 +-
 tools/perf/scripts/python/sched-migration.py                   | 2 +-
 tools/perf/util/setup.py                                       | 2 +-
 tools/testing/ktest/compare-ktest-sample.pl                    | 2 +-
 27 files changed, 27 insertions(+), 27 deletions(-)

-- 
2.30.2

