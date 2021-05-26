Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E408390F41
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 06:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhEZETO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 00:19:14 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:46415 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhEZETO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 00:19:14 -0400
Received: from leknes.fjasle.eu ([92.116.119.165]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N17pC-1lJWcV2QIs-012Wd5 for <stable@vger.kernel.org>; Wed, 26 May 2021
 06:17:37 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id A5E363C575; Wed, 26 May 2021 06:17:36 +0200 (CEST)
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     nicolas@fjasle.eu
Cc:     stable@vger.kernel.org
Subject: [PATCH 4.14 0/2] Allow builds and script usage on current systems
Date:   Wed, 26 May 2021 06:17:26 +0200
Message-Id: <20210526041728.4114392-1-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lAn9FrVJu1ObtQuizHYJg9+BxRpMbTz666WGJx9mkwGTktBpJU9
 OVwWhgHbRSdBQG1agEn7tOe4pTndksJ1i1GBFXCTAvvBkklVDI0AfTm5n80FjB2YbOMSJr0
 6BhWbDoiz0uWz3G1VYOVgl7/cp/BwtdMoyre6DZiHpIHBF0uexjO5iCDZ4jVB+rNEFQ9ikj
 aXvmmMwhGGIjFp7txrI5Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gYLKKK99HEA=:qDX/ziN7ziI1JpfVMTEmAj
 KB9DhdFh+5Ncj+tVEXEiV6GZJ5/pcbYRSJpyEXdJMYgbR4jcVgvSLBjCjjkpONIS+LhKTi1x1
 /8sivpmaR59hMJorqabxXMHeRqBkOdvxPOItqOEXoLcGZqoqfNt26SANVHGRQ8mj3Po7egeaZ
 Tfj7UpgPqCjN4BAg1QuUcVrHnp5iDkjJmTTheb8QZjlVjP3+XxMq3Y1Cx3uNhqijtHJWnapj6
 pVWEHQuMpGT1D3Z48m3NZBBy2ZGf0waZFTBlEK5rDw+de1RUCUSe8QLyPJCyZw5yBwo11eNDO
 fPMA8O7LOSO/YM9my7cwWAINneshtWMj6OM2T0/MiJDzaz7STTNHshPyxhGtzz7yaXXz/Q5Wu
 fIlrf2exXtEdMmrD9YfGN4AtsWFbWCyAX6eyLg/KiCMuHR/BOXYFXiZXaLKmoYQVWw4FzLylW
 fG7hEMQAsndpBq7XYU+c6ZfYb9drQLrfETAc/vGNvBAR/jt9hpGKziDNwT9KulaRPoLWO3Wbo
 gTRpXTJkuZCE5LiP01IxEc=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Current distributions start removing support for Python 2 (and thus
/usr/bin/python).  To still be able to build v4.14.y and to run
supplementary scripts fix shebang lines to use 'env' and switch
diffconfig and bloat-o-meter to Python 3 explicitly.

Python 3 availability should be given on v4.14 based distributions
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
 scripts/bloat-o-meter                                          | 2 +-
 scripts/config                                                 | 2 +-
 scripts/diffconfig                                             | 2 +-
 scripts/show_delta                                             | 2 +-
 scripts/sphinx-pre-install                                     | 2 +-
 scripts/tracing/draw_functrace.py                              | 2 +-
 tools/kvm/kvm_stat/kvm_stat                                    | 2 +-
 tools/perf/python/tracepoint.py                                | 2 +-
 tools/perf/python/twatch.py                                    | 2 +-
 tools/perf/scripts/python/call-graph-from-sql.py               | 2 +-
 tools/perf/scripts/python/sched-migration.py                   | 2 +-
 tools/perf/tests/attr.py                                       | 2 +-
 tools/perf/util/setup.py                                       | 2 +-
 tools/power/pm-graph/analyze_boot.py                           | 2 +-
 tools/power/pm-graph/analyze_suspend.py                        | 2 +-
 tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py     | 2 +-
 tools/testing/ktest/compare-ktest-sample.pl                    | 2 +-
 tools/testing/selftests/tc-testing/tdc_batch.py                | 2 +-
 24 files changed, 24 insertions(+), 24 deletions(-)

-- 
2.30.2

