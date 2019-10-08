Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D19CFFAC
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfJHRUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:20:35 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53423 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbfJHRUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:20:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 708BC21EAD;
        Tue,  8 Oct 2019 13:20:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:20:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VaznyI
        32H4GoS4/he4/K4W7gBj9MBO4LqpYODNqz3Qo=; b=v0F/wtJsGth6bM9kiWo20Z
        tFO8ocY5YrdKXPg0Z37E+w4+KWEG+F2jWLpFkXkcCgpiNF6Hp8MkZ5n5sqvS2b/z
        m2xfGOiWYKugfSxB0VK8kD8DUF7ztw1PABvxDvbuc0CnxyMgbeDi8/zwKm7EbXAw
        BzuT8KI6GPeY5UjsSfYRR4wN2ARI6IVmqy0fdBOiB3NYJT2VohjV+GOSnUdbMI4i
        N829baXnp0VZp4w6EIaOfkhS839MUvVJ02ooz3U3ho2Z5YFn9GQb1HXvEX/Q8lGV
        jXDgCjGSaJVft2+M5TjIFvh2mMB3cho16n3Xy0leOuFqfcUo+R+LMxKAlRZ5mpjA
        ==
X-ME-Sender: <xms:YcWcXWAVIYB1H_8HfSs0I_vE8QAqkim63HmS7hECgwzAW8F_WnfMzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:YcWcXUxP79yKSuKDZx69GjqKv9Tt5kiNAMfwK7qy4ZRJkzPJ7WsQ1Q>
    <xmx:YcWcXUn43dabFbOt0MCFPA3b_5V5NXgHSAEaHjwUDc1_RvxzfU0OlA>
    <xmx:YcWcXZFW3ymrZRooC8hbz_A9rA7HU0uGNpWWQRKEXxihzikjg87Wng>
    <xmx:YsWcXZohFl5JejsC5nzPQTPlXjL-VKClKzbo57SkkNG5NPt82wEr-A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1BD2B80066;
        Tue,  8 Oct 2019 13:20:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf tools: Fix segfault in cpu_cache_level__read()" failed to apply to 4.19-stable tree
To:     jolsa@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, mpetlan@redhat.com,
        namhyung@kernel.org, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:20:31 +0200
Message-ID: <1570555231157141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

