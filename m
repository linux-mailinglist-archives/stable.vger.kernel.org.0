Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7D62A4A05
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgKCPjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:39:17 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:56503 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727470AbgKCPjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:39:17 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5EF331942E63;
        Tue,  3 Nov 2020 10:39:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:39:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Y+qWmH
        O4RE8SyMHjB2dq87Md8wQjMiuCnZA6q126i9c=; b=RHO2GDGx6DbTg6bFXBr+hC
        zy0nH80dCBYxv6Ycn5fQ2EJHmD79AhHn0gn6E3yoZHJRUmP+vZlbiRNRewc8KRtP
        a5uYkKQu7saJ9EUO3b9aT1TVqIjpCWVeQYHlCx4jkhRsHvmy19WS8mwBti/a4xb+
        WEVBEiTB0cc+icP2zIsRFg7J/SsIYW10eJHiDK5DIeKkR6Z8aUY8trMD+4fmxWIO
        ARMMyZhvTgDFUx4ZZOV5Ruv9vDp6GcMS4/ANVhGDnS8GnHmtRBd9rMHME9nUOKlS
        xHnQWKqfZlPRxPL0Y304we6w/1a2Rw9+qoPaZkHQ4yCFtm/6OsxfTnk5lfNNIPww
        ==
X-ME-Sender: <xms:pHmhX_b8YczUkWaJthR_HhRJsh77OuHSUk_s_cqAkXPV9-sYzPxQww>
    <xme:pHmhX-bUu92wIjSx-x7p2BmAzmplRj_iBHhA-4E3mMXbatWWsaWWwIy0yM-qhvRjx
    2FrjT4pOzVZtw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pHmhXx-iqNnymn84qp-VmkKMwTAcLNfS-HRoP_IXBYZ7e1cqo0TsaQ>
    <xmx:pHmhX1pN7MkPk7B9b39iNyGtBubBinUaizX5ewvIvbQgiyU0AGjEzA>
    <xmx:pHmhX6qPV95XxLrybtZ-d3psDuo6xCLGE9taidGamnH95zwtq8SxkQ>
    <xmx:pHmhX7eLwDPwgcfvmA9pm-HirkWV-UfWt2I7b8YMhLKU_XiiAfhAfg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E7CC43064684;
        Tue,  3 Nov 2020 10:39:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] perf python scripting: Fix printable strings in python3" failed to apply to 4.9-stable tree
To:     jolsa@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, hagen@jauu.net,
        mark.rutland@arm.com, mpetlan@redhat.com, namhyung@kernel.org,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:40:10 +0100
Message-ID: <1604418010206122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6fcd5ddc3b1467b3586972ef785d0d926ae4cdf4 Mon Sep 17 00:00:00 2001
From: Jiri Olsa <jolsa@kernel.org>
Date: Mon, 28 Sep 2020 22:11:35 +0200
Subject: [PATCH] perf python scripting: Fix printable strings in python3
 scripts

Hagen reported broken strings in python3 tracepoint scripts:

  make PYTHON=python3
  perf record -e sched:sched_switch -a -- sleep 5
  perf script --gen-script py
  perf script -s ./perf-script.py

  [..]
  sched__sched_switch      7 563231.759525792        0 swapper   prev_comm=bytearray(b'swapper/7\x00\x00\x00\x00\x00\x00\x00'), prev_pid=0, prev_prio=120, prev_state=, next_comm=bytearray(b'mutex-thread-co\x00'),

The problem is in the is_printable_array function that does not take the
zero byte into account and claim such string as not printable, so the
code will create byte array instead of string.

Committer testing:

After this fix:

sched__sched_switch 3 484522.497072626  1158680 kworker/3:0-eve  prev_comm=kworker/3:0, prev_pid=1158680, prev_prio=120, prev_state=I, next_comm=swapper/3, next_pid=0, next_prio=120
Sample: {addr=0, cpu=3, datasrc=84410401, datasrc_decode=N/A|SNP N/A|TLB N/A|LCK N/A, ip=18446744071841817196, period=1, phys_addr=0, pid=1158680, tid=1158680, time=484522497072626, transaction=0, values=[(0, 0)], weight=0}

sched__sched_switch 4 484522.497085610  1225814 perf             prev_comm=perf, prev_pid=1225814, prev_prio=120, prev_state=, next_comm=migration/4, next_pid=30, next_prio=0
Sample: {addr=0, cpu=4, datasrc=84410401, datasrc_decode=N/A|SNP N/A|TLB N/A|LCK N/A, ip=18446744071841817196, period=1, phys_addr=0, pid=1225814, tid=1225814, time=484522497085610, transaction=0, values=[(0, 0)], weight=0}

Fixes: 249de6e07458 ("perf script python: Fix string vs byte array resolving")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200928201135.3633850-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/print_binary.c b/tools/perf/util/print_binary.c
index 599a1543871d..13fdc51c61d9 100644
--- a/tools/perf/util/print_binary.c
+++ b/tools/perf/util/print_binary.c
@@ -50,7 +50,7 @@ int is_printable_array(char *p, unsigned int len)
 
 	len--;
 
-	for (i = 0; i < len; i++) {
+	for (i = 0; i < len && p[i]; i++) {
 		if (!isprint(p[i]) && !isspace(p[i]))
 			return 0;
 	}

