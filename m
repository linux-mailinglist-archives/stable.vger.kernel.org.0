Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F1B109C6D
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 11:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfKZKlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 05:41:18 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55959 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727603AbfKZKlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 05:41:18 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2A96C221FD;
        Tue, 26 Nov 2019 05:41:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 26 Nov 2019 05:41:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Hsj1pf
        +1vAgFvkdOLHqUN1E84A5zOE9iZRZO2NNxCbE=; b=i9jIF+9pWTGb48/BYQHhkQ
        Wy8HNByRlhR9Dd/UNfAbKSaSIQZPRVMXTDR4wQsppxrznFkhd5za8+ooTeD4nO7K
        4Bpx1N3E6guC7V5sfRpEBvH1Mpa4clVFfhaLOA3s1pV5/Ty15oUQm7VYjRK6Tl6w
        V3DRhvKIYFVsGH3jZVYi6WOAzpAjnvJ8dSkN9ZJxYGIWZbNfv3cYB3tpUr+LaVvn
        Z2ZJ8ugUwHaWJ+0efj/j7T/7SIEpSxxvZueC5XSmbfjHUJHFplYcSHCvFIuyI1IE
        MX4C7gmzvZCObaVIV6V4bcdLOIf7t4FpJQhA3Zcixku34Fb+ZOzbLk8GdWvgDZrw
        ==
X-ME-Sender: <xms:TAHdXXXwAjUu1H9gABgm4dfvzXn5haex4nCzEZRTnCHCUyml9To_VQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeifedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeegrddvgedurddule
    egrdelieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:TAHdXVF2hADOphc0aqZ0DGQo52ekD6mdH5cwMOk6Jk4jW1YC69RUZg>
    <xmx:TAHdXWGQ4aWI1FBpbQggtvMxnvrbr9ByPLPSShuoXY3hYzrarv_z0A>
    <xmx:TAHdXfseXICzxFwW870uCFrNatyrvb2UUvJRqK2Lzd-Kbp4u_AAWcQ>
    <xmx:TAHdXXAnoQ0513P_ZJn2uQqEW93rW8r3BCdx5LYt1h2Q-pSdQ-PAWQ>
Received: from localhost (unknown [84.241.194.96])
        by mail.messagingengine.com (Postfix) with ESMTPA id 57CBE3060060;
        Tue, 26 Nov 2019 05:41:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "dm crypt: use WQ_HIGHPRI for the IO and crypt" failed to apply to 4.14-stable tree
To:     snitzer@redhat.com, vcaputo@pengaru.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 26 Nov 2019 11:41:04 +0100
Message-ID: <1574764864161192@kroah.com>
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

