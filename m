Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9B2E3573
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgL1J0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:26:52 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:59515 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1J0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:26:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 814ED7C7;
        Mon, 28 Dec 2020 04:26:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:26:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BHpEIZ
        0l88s0vxY0LDa+HRJebqExMEjv5o7lvp6/FM0=; b=LOPUOsxnvBfVpkc+R4YHcA
        U9hjTPtAVj6oqlypLlzwohvO87WogZuMhOHo5WhUvPT90rNPy/vowZce8yMDfZ1V
        GLUTCes7LEHUHvq5rcTXd82rjM+MVABA205aA3wSfoxd3AZD9rva0t1q6A6PxJ4J
        tPuEPLu9mGgosZgSE1AuPNGQ8ApaAunSKuuDZl5lq8K89BjwsqD3N2BB+aobbE66
        dR8a5e9VJUIisxgYZiFUIwxIRJjP3UzLbrhSxMTM4k6M1ya1NalnR0b1tcwMX/i+
        7njNBc2KH+crUl7OqoHXfABp63lyqzvCEPgfDPzE1oSdlDQK1Nsj/qtNiNEmhpNw
        ==
X-ME-Sender: <xms:raTpXzbkZJtVaS8w88f_diXTCcM52l8pjkQqpYnAZ1blDskss6r2vg>
    <xme:raTpXybLu0xcrDKs4ZgZkKbg9cF0ac3qcqYAFlSt3oYdD1qHylkgS4VQjc9R-9rEG
    MqQXfde7YJISA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:raTpX1_74ZacV2WDMQjizeNViNNxDo-QVKsPjmc6FNG_aPTSr5HcZA>
    <xmx:raTpX5rNhqjFozowYrHnXkqlGHl9oMyMcShWypPNEGbDjY1VGbE-6w>
    <xmx:raTpX-qqWTCAqniU-LAUADVWhyquD_CIKoF2DyfhvC49tHbcsdYWZg>
    <xmx:rqTpXzAyrOs5ChAmapolFrSVNlILOxxKyOjsUT9kIw5FHGsa-hxgfccAiEw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 26AAA108005C;
        Mon, 28 Dec 2020 04:26:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/powernv/memtrace: Fix crashing the kernel when" failed to apply to 4.14-stable tree
To:     david@redhat.com, mpe@ellerman.id.au, osalvador@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:27:28 +0100
Message-ID: <1609147648105176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From d6718941a2767fb383e105d257d2105fe4f15f0e Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Wed, 11 Nov 2020 15:53:16 +0100
Subject: [PATCH] powerpc/powernv/memtrace: Fix crashing the kernel when
 enabling concurrently

It's very easy to crash the kernel right now by simply trying to
enable memtrace concurrently, hammering on the "enable" interface

loop.sh:
  #!/bin/bash

  dmesg --console-off

  while true; do
          echo 0x40000000 > /sys/kernel/debug/powerpc/memtrace/enable
  done

[root@localhost ~]# loop.sh &
[root@localhost ~]# loop.sh &

Resulting quickly in a kernel crash. Let's properly protect using a
mutex.

Fixes: 9d5171a8f248 ("powerpc/powernv: Enable removal of memory for in memory tracing")
Cc: stable@vger.kernel.org# v4.14+
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201111145322.15793-3-david@redhat.com

diff --git a/arch/powerpc/platforms/powernv/memtrace.c b/arch/powerpc/platforms/powernv/memtrace.c
index eea1f94482ff..0e42fe2d7b6a 100644
--- a/arch/powerpc/platforms/powernv/memtrace.c
+++ b/arch/powerpc/platforms/powernv/memtrace.c
@@ -30,6 +30,7 @@ struct memtrace_entry {
 	char name[16];
 };
 
+static DEFINE_MUTEX(memtrace_mutex);
 static u64 memtrace_size;
 
 static struct memtrace_entry *memtrace_array;
@@ -279,6 +280,7 @@ static int memtrace_online(void)
 
 static int memtrace_enable_set(void *data, u64 val)
 {
+	int rc = -EAGAIN;
 	u64 bytes;
 
 	/*
@@ -291,25 +293,31 @@ static int memtrace_enable_set(void *data, u64 val)
 		return -EINVAL;
 	}
 
+	mutex_lock(&memtrace_mutex);
+
 	/* Re-add/online previously removed/offlined memory */
 	if (memtrace_size) {
 		if (memtrace_online())
-			return -EAGAIN;
+			goto out_unlock;
 	}
 
-	if (!val)
-		return 0;
+	if (!val) {
+		rc = 0;
+		goto out_unlock;
+	}
 
 	/* Offline and remove memory */
 	if (memtrace_init_regions_runtime(val))
-		return -EINVAL;
+		goto out_unlock;
 
 	if (memtrace_init_debugfs())
-		return -EINVAL;
+		goto out_unlock;
 
 	memtrace_size = val;
-
-	return 0;
+	rc = 0;
+out_unlock:
+	mutex_unlock(&memtrace_mutex);
+	return rc;
 }
 
 static int memtrace_enable_get(void *data, u64 *val)

