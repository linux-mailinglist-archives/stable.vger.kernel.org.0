Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71465C3E0B
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732103AbfJAREY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 13:04:24 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:38887 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730661AbfJAREX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 13:04:23 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4DC51645;
        Tue,  1 Oct 2019 13:04:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 01 Oct 2019 13:04:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8VdQAM
        0VMJt0xJkfajhCLaJkgNlDf80giDA3p57T1dE=; b=H7VdXiJIzPooWNii5zs7Jw
        4BKPrd24UoETWqfuMPIABKwm/CRAy1eCTIffiiNa36nXyVlOTBKuS322+zsR/Hc/
        LPl0DlUmrNAF80dB1yJLBI1RJDoPhbhGssU+n5BDLN719NBgKteZ3pSuSttVpXzQ
        u5NMFchE9rN0+vybAwG02LEXpMaEayGoP/QZVsfhCUfbZ53NhVzM4vblJINzsh3r
        +PmpKoSb8EpZ9iX+hSK8Cw7lKiZtWxV1HKPVxTNLV2e+yGD92kN7XgJC0Vf4xw9X
        p47fxOt6aMklWoT8Er6X+17/HmuVgEkT7JNn4m4qxkD1Ae+DQjeH8Nk1dvz0HZfQ
        ==
X-ME-Sender: <xms:FYeTXeSdR6KrdbnltsCn3p3Rqc8CQaUEJsQs5sE73iL5L-1Yjw85oQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeggddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:FYeTXdEsE-HkgpFf-FMrMAi09CTHUgBHXU4Zq2pTQXfhWbjC2AHYvQ>
    <xmx:FYeTXYOaX55vujwJKQeSIxlk_H5KvRpj3u0TZ3AZhcBGrySyVF1MRA>
    <xmx:FYeTXRmcEvopzNqRcU3scPH7jnamazyEClH_bpD28LavFsO2swzTsw>
    <xmx:FYeTXUs3rlNCxFDnzJaCUP_LwhxKHZ_WgDZq3qIO7ooFGdl4MzyOGg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4AA4D80061;
        Tue,  1 Oct 2019 13:04:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] printk: Do not lose last line in kmsg buffer dump" failed to apply to 4.9-stable tree
To:     vincent.whitchurch@axis.com, pmladek@suse.com,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 01 Oct 2019 19:04:11 +0200
Message-ID: <1569949451853@kroah.com>
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

From c9dccacfccc72c32692eedff4a27a4b0833a2afd Mon Sep 17 00:00:00 2001
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Date: Thu, 11 Jul 2019 16:29:37 +0200
Subject: [PATCH] printk: Do not lose last line in kmsg buffer dump

kmsg_dump_get_buffer() is supposed to select all the youngest log
messages which fit into the provided buffer.  It determines the correct
start index by using msg_print_text() with a NULL buffer to calculate
the size of each entry.  However, when performing the actual writes,
msg_print_text() only writes the entry to the buffer if the written len
is lesser than the size of the buffer.  So if the lengths of the
selected youngest log messages happen to precisely fill up the provided
buffer, the last log message is not included.

We don't want to modify msg_print_text() to fill up the buffer and start
returning a length which is equal to the size of the buffer, since
callers of its other users, such as kmsg_dump_get_line(), depend upon
the current behaviour.

Instead, fix kmsg_dump_get_buffer() to compensate for this.

For example, with the following two final prints:

[    6.427502] AAAAAAAAAAAAA
[    6.427769] BBBBBBBB12345

A dump of a 64-byte buffer filled by kmsg_dump_get_buffer(), before this
patch:

 00000000: 3c 30 3e 5b 20 20 20 20 36 2e 35 32 32 31 39 37  <0>[    6.522197
 00000010: 5d 20 41 41 41 41 41 41 41 41 41 41 41 41 41 0a  ] AAAAAAAAAAAAA.
 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

After this patch:

 00000000: 3c 30 3e 5b 20 20 20 20 36 2e 34 35 36 36 37 38  <0>[    6.456678
 00000010: 5d 20 42 42 42 42 42 42 42 42 31 32 33 34 35 0a  ] BBBBBBBB12345.
 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

Link: http://lkml.kernel.org/r/20190711142937.4083-1-vincent.whitchurch@axis.com
Fixes: e2ae715d66bf4bec ("kmsg - kmsg_dump() use iterator to receive log buffer content")
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # v3.5+
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1888f6a3b694..424abf802f02 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3274,7 +3274,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	/* move first record forward until length fits into the buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
-	while (l > size && seq < dumper->next_seq) {
+	while (l >= size && seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
 		l -= msg_print_text(msg, true, time, NULL, 0);

