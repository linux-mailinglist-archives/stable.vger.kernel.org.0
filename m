Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6385379844
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 22:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhEJUYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 16:24:01 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:36057 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhEJUYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 16:24:01 -0400
Received: from leknes.fjasle.eu ([92.116.68.92]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MPXQi-1ltzwk0ole-00McrY; Mon, 10 May 2021 22:22:44 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id 7C9EF3C072; Mon, 10 May 2021 22:22:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
        t=1620678162; bh=JAuQAnklRtdHPaG9asZs85+x7KiZUwHbL9JK8786pwg=;
        h=From:To:Cc:Subject:Date:From;
        b=quAExRP9lxdl2GozAWR9SvILS0930L5/vvF0RzvvFFoX1rAOhsSJ8KwRKshOQ515a
         uybLJivOU3eJtU/PHPY4oc0qKocuNb8xWpMTlsQ9I/O7W1CruypzQpxl1c8hgTpwwI
         jFMp+3tEffltnrN7uY6PH2v34sHK0hhvMX2DYXeg=
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     stable@vger.kernel.org
Cc:     Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH 0/2] shebang fixes and explicit python3 switch for v4.9
Date:   Mon, 10 May 2021 22:22:19 +0200
Message-Id: <20210510202221.2601299-1-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:+XkJ2zmKNMHhTJbjLLiSxhX1flT4u9lXQZPc7AiUORYQOLlTlV8
 rkLHD5oO3TLp6h8bvvusy8vhVLc4J5e9mu/nuxjYKZnuNjfEbT0E0jcWUUY1MvmUGpwm84c
 Gbgx/Dk5yVanaeyNubUZ4juL7I6IkraLstVeZ3xLh4T+DJ2fYlFTgZdqRSknC2C9k/F9QL8
 23GerpHkEwFLMQ6qM8lXA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FRpjDg7vxwQ=:Ljoa54I+YEAOmjCy7K7N0k
 KmmGlvIxzKcKMSvmq/0DgLKICbrzN+VPHneIhAfMxzcGDPenpUUferYBOsZyvoIVI60RLfy3P
 DLwDQt/YAsJaaPoBJNxNx4zKNS5OTJrymTFYLjHpwJp6WPnr3gk58m+kIeiVPvxtqrcDrtGSq
 xzB6JblP54YCxEAxTetPSCFkoweaqqMZORV65Tbixiy7g6A413vvlP4rpyxZXZ4OQQV7VJuvf
 1tciVnOPrPOw+OMkKfj0uW5ecBbHd7OIMgI5CFj+cdckMpzzlw68qYMtIVzuDKOJJ++T+esKP
 mBTWy7NjU8Wu/m88I8oaty0lpjINZse00S3HG7y331GCTs+XUR3e7U9q2tTv2okipj9iQwTAA
 PM2z0mrKnlp0VeTXNpejWA9Xi1b5uKmcHfMMKgt1vithK8TjQ1gPqqNCiQhRoD4Rw4dg+8Je1
 dgdALz3KU6KiibngdKLgcC3EMqY+zpxboWFHdiUUqX6qeF+MdLLbn/IZY1w1asg1eVDbu67O8
 TZoXzjCUr7PQGGaE6NdcR8=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable maintainers,

please consider to apply two commits that fixup usability of scripts
from v4.9.y series on systems with newer user space.

  * commit c25ce589dca10d64dde139ae093abc258a32869c
    tweewide: Fix most Shebang lines

  * commit 51839e29cb5954470ea4db7236ef8c3d77a6e0bb
    scripts: switch explicitly to Python 3

The following two patches are backports to v4.9.

Thanks and kind regards,
Nicolas


Andy Shevchenko (1):
  scripts: switch explicitly to Python 3

Finn Behrens (1):
  tweewide: Fix most Shebang lines

 Documentation/filesystems/cifs/winucase_convert.pl              | 2 +-
 Documentation/sphinx/parse-headers.pl                           | 2 +-
 Documentation/target/tcm_mod_builder.py                         | 2 +-
 Documentation/trace/postprocess/decode_msr.py                   | 2 +-
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl  | 2 +-
 Documentation/trace/postprocess/trace-vmscan-postprocess.pl     | 2 +-
 arch/ia64/scripts/unwcheck.py                                   | 2 +-
 drivers/scsi/script_asm.pl                                      | 2 +-
 .../staging/vc04_services/interface/vchiq_arm/vchiq_genversion  | 2 +-
 lib/build_OID_registry                                          | 2 +-
 scripts/analyze_suspend.py                                      | 2 +-
 scripts/bloat-o-meter                                           | 2 +-
 scripts/bootgraph.pl                                            | 2 +-
 scripts/checkincludes.pl                                        | 2 +-
 scripts/checkpatch.pl                                           | 2 +-
 scripts/checkstack.pl                                           | 2 +-
 scripts/cleanfile                                               | 2 +-
 scripts/cleanpatch                                              | 2 +-
 scripts/config                                                  | 2 +-
 scripts/diffconfig                                              | 2 +-
 scripts/dtc/dt_to_config                                        | 2 +-
 scripts/export_report.pl                                        | 2 +-
 scripts/extract-module-sig.pl                                   | 2 +-
 scripts/extract-sys-certs.pl                                    | 2 +-
 scripts/extract_xc3028.pl                                       | 2 +-
 scripts/get_dvb_firmware                                        | 2 +-
 scripts/get_maintainer.pl                                       | 2 +-
 scripts/headers_check.pl                                        | 2 +-
 scripts/kconfig/streamline_config.pl                            | 2 +-
 scripts/kernel-doc                                              | 2 +-
 scripts/kernel-doc-xml-ref                                      | 2 +-
 scripts/markup_oops.pl                                          | 2 +-
 scripts/namespace.pl                                            | 2 +-
 scripts/profile2linkerlist.pl                                   | 2 +-
 scripts/recordmcount.pl                                         | 2 +-
 scripts/show_delta                                              | 2 +-
 scripts/stackdelta                                              | 2 +-
 scripts/tracing/draw_functrace.py                               | 2 +-
 tools/kvm/kvm_stat/kvm_stat                                     | 2 +-
 tools/perf/python/tracepoint.py                                 | 2 +-
 tools/perf/python/twatch.py                                     | 2 +-
 tools/perf/scripts/perl/rw-by-file.pl                           | 2 +-
 tools/perf/scripts/perl/rw-by-pid.pl                            | 2 +-
 tools/perf/scripts/perl/rwtop.pl                                | 2 +-
 tools/perf/scripts/perl/wakeup-latency.pl                       | 2 +-
 tools/perf/scripts/python/call-graph-from-postgresql.py         | 2 +-
 tools/perf/scripts/python/sched-migration.py                    | 2 +-
 tools/perf/util/setup.py                                        | 2 +-
 tools/testing/ktest/compare-ktest-sample.pl                     | 2 +-
 tools/testing/ktest/ktest.pl                                    | 2 +-
 50 files changed, 50 insertions(+), 50 deletions(-)

-- 
2.30.1

