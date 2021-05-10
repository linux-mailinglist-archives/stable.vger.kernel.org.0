Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128B6377EA0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhEJIxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:53:51 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:49171 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhEJIxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:53:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id DB64B1940231;
        Mon, 10 May 2021 04:52:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 May 2021 04:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XgmGXq
        Qg+VxWw9J2NaRiOrygC9/3ecyx3X6/JXyWVl8=; b=I88qeQgGPnwj7S3BuOX2yx
        ll3s8cJm7GBXHfn5rHEi+u0jiAK/qysWVBsozmEAsVL5dGhIt95aHO9J9XH5puZw
        T5XPyObBK1//Imuvh1n+xC4eFI+H6ctxh/QTUHm0zVv/4sGLyfMinzBdVl0xOiDB
        GgttcTUNdqrX3FcTdilk2IWkyuhzKZuUXOVpOYgVRwWKMICFaIWkD+6qv4r0V7xs
        m4mK1cGXH9HoNitmOGD+waG4cK42HEx4NLnmN62zeqRCqUUdwsF4Zq55shsl2vm4
        DIkzQsLwxUYMIC/yFm/h96LogLZhVTPsbkq6oANBHGeWQyXv16mQFxmVRdXlYFZw
        ==
X-ME-Sender: <xms:XfSYYIlqnf_c66HMJC3IGQ_MSnp1zRbt_zWNLJVlErT4qVLMlUJGfw>
    <xme:XfSYYH2O_48C6eC0Y9xEiRzAyBQPpVXGuV6TW5u4gfzM0tNWX1yNGHBD6-5YNibga
    nj8XQ_E7vOlPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:XfSYYGpRcKIyt61g8bAGgUq_noBWWCoeR62kao-nHnx0zrdz8Uj3_A>
    <xmx:XfSYYElSk1HRBSQIM6_hJub8nGhAldtV_NUgIo7aaHfzsANznlLDTg>
    <xmx:XfSYYG1jN32ff2Tqgsxo-P87BCbdFdSaJY3zJHhKmq8p6oo-cLf6-g>
    <xmx:XfSYYL9xqnVVo4iwlL3Tv84-lWaq2BgHqq1dEU-ZLWK2Ud-7Usx0YQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:52:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm integrity: fix missing goto in bitmap_flush_interval error" failed to apply to 4.19-stable tree
To:     tiantao6@hisilicon.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:52:42 +0200
Message-ID: <162063676224091@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 17e9e134a8efabbbf689a0904eee92bb5a868172 Mon Sep 17 00:00:00 2001
From: Tian Tao <tiantao6@hisilicon.com>
Date: Wed, 14 Apr 2021 09:43:44 +0800
Subject: [PATCH] dm integrity: fix missing goto in bitmap_flush_interval error
 handling

Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index fed8a7ccd7f9..6977422454a4 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4049,6 +4049,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			if (val >= (uint64_t)UINT_MAX * 1000 / HZ) {
 				r = -EINVAL;
 				ti->error = "Invalid bitmap_flush_interval argument";
+				goto bad;
 			}
 			ic->bitmap_flush_interval = msecs_to_jiffies(val);
 		} else if (!strncmp(opt_string, "internal_hash:", strlen("internal_hash:"))) {

