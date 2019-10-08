Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9F8CFFB5
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfJHRV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:21:28 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40601 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbfJHRV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:21:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AD4C021F48;
        Tue,  8 Oct 2019 13:21:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5GUHeK
        AI59FrQjZuepvOGiFf/lmrnFaZ4a3ElNPkVeA=; b=vZE1AjPWsc7SJ12Crj5Wh1
        HZIeE6IL6fxxQFSAXXo3ztYTDC/pUp+VDM5i31NXM+uXs6syw+FHFGEEy7c3LHSX
        DlYflKykuMOI+7MNx/OdRuRfHg3vw8ff65Xfsgu3RCSt1NtUIcGNhu63dl6DRbCt
        0/RHdOEx+qDJbp0/0OFnyXCA2qKJ/K6DvkfS93BuAeO1lARy0KB7upSn1b1CnQDv
        z50+r8iMjPgwY0xQCWF2NG32Q8/Uru4noqt7RCJE1FzV5VSA4TfKZtUbJMbqNfW1
        rw+PBy1U6w5Sucn1IexaSSTZwe2VwnVQZiMAGG7UdQnFMyvM3Fmq+8Ad5Lw2rH1Q
        ==
X-ME-Sender: <xms:lsWcXeVsjsG4jTB_hZJz50SoapcIZZnmKJg6uvqNwaxn-CjXw8V2LQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:lsWcXX_zs7SH6HD3-ak7vDImpR_NUdussBchPQfsNTLbqPlyfA07Dg>
    <xmx:lsWcXZs-eRHVkJxwshHgbA_cH89EzWL_upd8OqgGGuLCIJRT5uiPIA>
    <xmx:lsWcXf1SgxMAQrbQ7fvEsQzWe3Pt-XAXE9pe6CzW_rhaN0AGQ1U77A>
    <xmx:lsWcXcLmoFYd4aq1bM6i738lOMi4xkHciVn46Kw5uCuijfBfIZGdeA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D02E80060;
        Tue,  8 Oct 2019 13:21:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf stat: Fix a segmentation fault when using repeat forever" failed to apply to 4.14-stable tree
To:     srikar@linux.vnet.ibm.com, acme@redhat.com, jolsa@kernel.org,
        namhyung@kernel.org, naveen.n.rao@linux.vnet.ibm.com,
        ravi.bangoria@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:21:25 +0200
Message-ID: <157055528553188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 443f2d5ba13d65ccfd879460f77941875159d154 Mon Sep 17 00:00:00 2001
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Wed, 4 Sep 2019 15:17:38 +0530
Subject: [PATCH] perf stat: Fix a segmentation fault when using repeat forever

Observe a segmentation fault when 'perf stat' is asked to repeat forever
with the interval option.

Without fix:

  # perf stat -r 0 -I 5000 -e cycles -a sleep 10
  #           time             counts unit events
       5.000211692  3,13,89,82,34,157      cycles
      10.000380119  1,53,98,52,22,294      cycles
      10.040467280       17,16,79,265      cycles
  Segmentation fault

This problem was only observed when we use forever option aka -r 0 and
works with limited repeats. Calling print_counter with ts being set to
NULL, is not a correct option when interval is set. Hence avoid
print_counter(NULL,..)  if interval is set.

With fix:

  # perf stat -r 0 -I 5000 -e cycles -a sleep 10
   #           time             counts unit events
       5.019866622  3,15,14,43,08,697      cycles
      10.039865756  3,15,16,31,95,261      cycles
      10.059950628     1,26,05,47,158      cycles
       5.009902655  3,14,52,62,33,932      cycles
      10.019880228  3,14,52,22,89,154      cycles
      10.030543876       66,90,18,333      cycles
       5.009848281  3,14,51,98,25,437      cycles
      10.029854402  3,15,14,93,04,918      cycles
       5.009834177  3,14,51,95,92,316      cycles

Committer notes:

Did the 'git bisect' to find the cset introducing the problem to add the
Fixes tag below, and at that time the problem reproduced as:

  (gdb) run stat -r0 -I500 sleep 1
  <SNIP>
  Program received signal SIGSEGV, Segmentation fault.
  print_interval (prefix=prefix@entry=0x7fffffffc8d0 "", ts=ts@entry=0x0) at builtin-stat.c:866
  866		sprintf(prefix, "%6lu.%09lu%s", ts->tv_sec, ts->tv_nsec, csv_sep);
  (gdb) bt
  #0  print_interval (prefix=prefix@entry=0x7fffffffc8d0 "", ts=ts@entry=0x0) at builtin-stat.c:866
  #1  0x000000000041860a in print_counters (ts=ts@entry=0x0, argc=argc@entry=2, argv=argv@entry=0x7fffffffd640) at builtin-stat.c:938
  #2  0x0000000000419a7f in cmd_stat (argc=2, argv=0x7fffffffd640, prefix=<optimized out>) at builtin-stat.c:1411
  #3  0x000000000045c65a in run_builtin (p=p@entry=0x6291b8 <commands+216>, argc=argc@entry=5, argv=argv@entry=0x7fffffffd640) at perf.c:370
  #4  0x000000000045c893 in handle_internal_command (argc=5, argv=0x7fffffffd640) at perf.c:429
  #5  0x000000000045c8f1 in run_argv (argcp=argcp@entry=0x7fffffffd4ac, argv=argv@entry=0x7fffffffd4a0) at perf.c:473
  #6  0x000000000045cac9 in main (argc=<optimized out>, argv=<optimized out>) at perf.c:588
  (gdb)

Mostly the same as just before this patch:

  Program received signal SIGSEGV, Segmentation fault.
  0x00000000005874a7 in print_interval (config=0xa1f2a0 <stat_config>, evlist=0xbc9b90, prefix=0x7fffffffd1c0 "`", ts=0x0) at util/stat-display.c:964
  964		sprintf(prefix, "%6lu.%09lu%s", ts->tv_sec, ts->tv_nsec, config->csv_sep);
  (gdb) bt
  #0  0x00000000005874a7 in print_interval (config=0xa1f2a0 <stat_config>, evlist=0xbc9b90, prefix=0x7fffffffd1c0 "`", ts=0x0) at util/stat-display.c:964
  #1  0x0000000000588047 in perf_evlist__print_counters (evlist=0xbc9b90, config=0xa1f2a0 <stat_config>, _target=0xa1f0c0 <target>, ts=0x0, argc=2, argv=0x7fffffffd670)
      at util/stat-display.c:1172
  #2  0x000000000045390f in print_counters (ts=0x0, argc=2, argv=0x7fffffffd670) at builtin-stat.c:656
  #3  0x0000000000456bb5 in cmd_stat (argc=2, argv=0x7fffffffd670) at builtin-stat.c:1960
  #4  0x00000000004dd2e0 in run_builtin (p=0xa30e00 <commands+288>, argc=5, argv=0x7fffffffd670) at perf.c:310
  #5  0x00000000004dd54d in handle_internal_command (argc=5, argv=0x7fffffffd670) at perf.c:362
  #6  0x00000000004dd694 in run_argv (argcp=0x7fffffffd4cc, argv=0x7fffffffd4c0) at perf.c:406
  #7  0x00000000004dda11 in main (argc=5, argv=0x7fffffffd670) at perf.c:531
  (gdb)

Fixes: d4f63a4741a8 ("perf stat: Introduce print_counters function")
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org # v4.2+
Link: http://lore.kernel.org/lkml/20190904094738.9558-3-srikar@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index fa4b148ecfca..60cdd383af81 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1956,7 +1956,7 @@ int cmd_stat(int argc, const char **argv)
 			perf_evlist__reset_prev_raw_counts(evsel_list);
 
 		status = run_perf_stat(argc, argv, run_idx);
-		if (forever && status != -1) {
+		if (forever && status != -1 && !interval) {
 			print_counters(NULL, argc, argv);
 			perf_stat__reset_stats();
 		}

