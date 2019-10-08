Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B786ACFFAF
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfJHRUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:20:44 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50685 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbfJHRUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:20:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B61EC21FBA;
        Tue,  8 Oct 2019 13:20:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:20:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZkySIt
        pyq71tHV2aCJpXgdkOBnaan3zeZfVoNIkA3iM=; b=IcJoiWRcKWkkDWvMOR+yv7
        0UnPzEE1VfWE2feJXuom636jOdL4Pjy1xep+2y9ISdgEqBFO9JS8/Os7D9c5frRl
        N90KqgZ5SG0IwiMApqfuWzBad5iQVWxalXfOiXIk8mBHOpw1FNHaBq4DolWkSppi
        8AjT/VzPfaO/8FZcEPYudVEmrT4+IUvuGwv4QaWX3Vpi+ghtPnhNRWDKnOtGzFUO
        LN087uGy+Vt0HZ2tywiDE42QDgZ4E0mT954QED8Bj5pBfTA0fuxqLtMtrnhH18kQ
        c0ycnwheTpfkUX77o60UKc7vz2xOogpqoaTC/d0FgjyQppTxiL5vYRN0SfJddNnQ
        ==
X-ME-Sender: <xms:a8WcXY9XNl2RcPJi93F_2em9KiISSWjiENCNVHFWfS764fSAiL1UmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:a8WcXU-3xt0FAUuMl0SAYLCDbV2LdwpTrps8ie4zkytCg3P5IfSobw>
    <xmx:a8WcXZDzyzYgN0QANWKKGF8CIUFLtXDclNwFSRuDK8gT8qRPtt569g>
    <xmx:a8WcXcwdaQlN_diT-6fnyY2hmJ-NKYMggn6Da_kuXoMFjMhkzGODeg>
    <xmx:a8WcXS16e_Tp0qwWpNiZLQWqgqtU_p4pbluFzOce8TndHjCBWYzkFg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46988D6005B;
        Tue,  8 Oct 2019 13:20:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf tools: Fix segfault in cpu_cache_level__read()" failed to apply to 4.9-stable tree
To:     jolsa@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, mpetlan@redhat.com,
        namhyung@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:20:33 +0200
Message-ID: <157055523366201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 0216234c2eed1367a318daeb9f4a97d8217412a0 Mon Sep 17 00:00:00 2001
From: Jiri Olsa <jolsa@kernel.org>
Date: Thu, 12 Sep 2019 12:52:35 +0200
Subject: [PATCH] perf tools: Fix segfault in cpu_cache_level__read()

We release wrong pointer on error path in cpu_cache_level__read
function, leading to segfault:

  (gdb) r record ls
  Starting program: /root/perf/tools/perf/perf record ls
  ...
  [ perf record: Woken up 1 times to write data ]
  double free or corruption (out)

  Thread 1 "perf" received signal SIGABRT, Aborted.
  0x00007ffff7463798 in raise () from /lib64/power9/libc.so.6
  (gdb) bt
  #0  0x00007ffff7463798 in raise () from /lib64/power9/libc.so.6
  #1  0x00007ffff7443bac in abort () from /lib64/power9/libc.so.6
  #2  0x00007ffff74af8bc in __libc_message () from /lib64/power9/libc.so.6
  #3  0x00007ffff74b92b8 in malloc_printerr () from /lib64/power9/libc.so.6
  #4  0x00007ffff74bb874 in _int_free () from /lib64/power9/libc.so.6
  #5  0x0000000010271260 in __zfree (ptr=0x7fffffffa0b0) at ../../lib/zalloc..
  #6  0x0000000010139340 in cpu_cache_level__read (cache=0x7fffffffa090, cac..
  #7  0x0000000010143c90 in build_caches (cntp=0x7fffffffa118, size=<optimiz..
  ...

Releasing the proper pointer.

Fixes: 720e98b5faf1 ("perf tools: Add perf data cache feature")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org: # v4.6+
Link: http://lore.kernel.org/lkml/20190912105235.10689-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5722ff717777..0167f9697172 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1073,7 +1073,7 @@ static int cpu_cache_level__read(struct cpu_cache_level *cache, u32 cpu, u16 lev
 
 	scnprintf(file, PATH_MAX, "%s/shared_cpu_list", path);
 	if (sysfs__read_str(file, &cache->map, &len)) {
-		zfree(&cache->map);
+		zfree(&cache->size);
 		zfree(&cache->type);
 		return -1;
 	}

