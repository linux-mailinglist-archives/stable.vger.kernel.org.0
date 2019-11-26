Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C61F109C6C
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 11:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfKZKlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 05:41:07 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60613 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727603AbfKZKlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 05:41:07 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 68560227AA;
        Tue, 26 Nov 2019 05:41:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 26 Nov 2019 05:41:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NBb6+J
        p86IInN5utlmBdqotvCJD2GlLm1UGmdbPJlo4=; b=lycWUGbs+tpUI2nF12ppBn
        50HUO5FkGnWsF1X8/v1dEwpV8Ek9qpdU0XEFhyIq7oiU2X7FBUgr/L7549qCLoJZ
        7xtE8jjGsjfGX8QgZYkdQJXqgQfKVWPolbdm4AzbpWijxe+8dypPnJ/6RCdZkbg1
        w0rue1K2Uzh//9Crzzwh7gR+T15S12w3fvX5DkJa413JLO/uLbR4KAtVaXId0Iw6
        vglK/ZP1lRamytn0RRsjyC3DQkiQRJMVGmCwec7jBiQ3xu33uIHvMZxiJb8dFlkv
        ZHY2IAHebWwf8AnmLg3Yvs91ET6eajvg4qxbVLIpEoHAJX+rfkQfdE1psNM+tAPQ
        ==
X-ME-Sender: <xms:QgHdXSFTtlJ8ooh6gL3Z1iC3QdrCQblB2ZTmCWVgcN9xHYL0OJIfpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeifedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeegrddvgedurddule
    egrdelieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:QgHdXU4HxA_TW0eP3jLJ3dRk9pyDt1_36QIzPdin20uVB9w-wEHytg>
    <xmx:QgHdXScXu6wPvwDTFRKY7vKnMQQRMzLmBmiOAkBH0SjxCOz5IJlgXA>
    <xmx:QgHdXX4eEEBNT-7J2Ye3Ei8oYeIctlsMbnXyG6jIvIjXtwr2IqehLg>
    <xmx:QgHdXemiQCSLjg0HyUtCUeuMv13BHckJS-iP4fvQfz1VwnVhztqcFQ>
Received: from localhost (unknown [84.241.194.96])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CA178005B;
        Tue, 26 Nov 2019 05:41:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt" failed to apply to 4.19-stable tree
To:     snitzer@redhat.com, vcaputo@pengaru.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 26 Nov 2019 11:41:03 +0100
Message-ID: <157476486318662@kroah.com>
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

From f612b2132db529feac4f965f28a1b9258ea7c22b Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 20 Nov 2019 17:27:39 -0500
Subject: [PATCH] Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt
 workqueues"

This reverts commit a1b89132dc4f61071bdeaab92ea958e0953380a1.

Revert required hand-patching due to subsequent changes that were
applied since commit a1b89132dc4f61071bdeaab92ea958e0953380a1.

Requires: ed0302e83098d ("dm crypt: make workqueue names device-specific")
Cc: stable@vger.kernel.org
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=199857
Reported-by: Vito Caputo <vcaputo@pengaru.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f87f6495652f..eb9782fc93fe 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2700,21 +2700,18 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	ret = -ENOMEM;
-	cc->io_queue = alloc_workqueue("kcryptd_io/%s",
-				       WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
-				       1, devname);
+	cc->io_queue = alloc_workqueue("kcryptd_io/%s", WQ_MEM_RECLAIM, 1, devname);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
 	}
 
 	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
-		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
+		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
 						  1, devname);
 	else
 		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
+						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
 						  num_online_cpus(), devname);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";

