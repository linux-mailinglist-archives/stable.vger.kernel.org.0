Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1242237AEF4
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 20:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhEKS7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 14:59:45 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:57545 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhEKS7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 14:59:44 -0400
Received: from leknes.fjasle.eu ([92.116.95.191]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N1PPJ-1lV6De0CVv-012pVn; Tue, 11 May 2021 20:58:29 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id A55593C081; Tue, 11 May 2021 20:58:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
        t=1620759507; bh=WW3UgrWShpicErAAzEOO1ybbYXw/9hX6hEZyPBQzK5U=;
        h=From:To:Cc:Subject:Date:From;
        b=dmD/6bWAZiH/Q5LRxG1VPhGAcPQbdf5A9pzoFl3Xfr9vOMUyZahEqqfa0MDENPArP
         fFk+oyLkjKER4fNdgjv6G1kkcKJ/aDE0tgsDFxyxNVI8vbTUdrBDkkBCxSNRAUukXu
         8PwJ/VTlzkvt8/k6FHHG3HWpu8/iKV/mHujBHBfQ=
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     stable@vger.kernel.org
Cc:     Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH v2 0/2] shebang fixes and explicit python3 switch for v4.9
Date:   Tue, 11 May 2021 20:58:15 +0200
Message-Id: <20210511185817.2695437-1-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:WiQEbHAOdLmrGRftx4LozwjSgDs7kuuQHJqSo5iKubFPlweJRV7
 ECi+W+v8Mwq1RtK6LfcmvfeREiXAlQYGbKOuxSEyRS/e1IqRADIo5xvVyKQrLBz9mrG/7uy
 81ApH64r3szrT5aaOobMzoopfKbGBRTQYOyktgiJTjedgqqB//TeWOP94B17ad6Tr4MBjcg
 DoJAcR54sJyOyK2+cPkoA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4MW2xAZu2p8=:DMVluhmrpH73piwawU3Jnq
 8VSDbnrY7EEoaCMXjRpHNvHTY7L8IMMGoINL2m+6pm1Ld+2Lvn+GiK4/GJ11WNmz3jomy7vEA
 doDUW0VkhHo3AQSJn1PMkiDBDKopTJhchhkY7m0pry0I6NjwE1GwaxefcyngM8QDe5TKxt+ga
 rINoSn4b2vEO+gt2jcJLsE0beeQKrp0BzQzofXVJGM3Wjw5uraS51s/BH6fQ8rZiwLRZYUEn8
 QF+VfdbuzCqIyaR1A42hstBsRjRDn+Ai73euyWxiGYmXqG1DtyXcpiOZXwwY04Q/4Vd7fQ83x
 9tbzONMkQgi1GQb98g3aYNbQ90ajuiifaT5g+JPvAEbG+LQ6zj+FFSIRJjo4oC3G/6nB0dCnS
 suowBSAGDgMizzV734X56yk1dJG0uXlCRSZH+O4Z9d7JQP8sgOyK55GS9ihkCCOtfgbenpD+D
 nBUSCOJ5s2avPHR0jn6wZCmY1kunqHVFwgYDIPLROZER1RggA192Wb8Lny9yWM5NrFlt7+W3M
 2ABNKjNJorLMXxmrSPcVLA=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable maintainers,

please consider to apply two commits that fixup usability of scripts
from v4.9.y series on systems with newer user space.  

  * commit c25ce589dca10d64dde139ae093abc258a32869c (< v5.11-rc1)
    tweewide: Fix most Shebang lines

  * commit 51839e29cb5954470ea4db7236ef8c3d77a6e0bb (< v5.11-rc7)
    scripts: switch explicitly to Python 3

The following two patches are backports to v4.9.

Changes v1 -> v2:
  * undo adaption for shebang lines with arguments

Thanks and kind regards,
Nicolas


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
 tools/perf/scripts/python/call-graph-from-postgresql.py        | 2 +-
 tools/perf/scripts/python/sched-migration.py                   | 2 +-
 tools/perf/util/setup.py                                       | 2 +-
 tools/testing/ktest/compare-ktest-sample.pl                    | 2 +-
 28 files changed, 28 insertions(+), 28 deletions(-)

-- 
2.30.1

