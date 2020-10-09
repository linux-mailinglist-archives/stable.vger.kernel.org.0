Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF6C288384
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbgJIH37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 03:29:59 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:55877 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732006AbgJIH36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:29:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 124561940B26;
        Fri,  9 Oct 2020 03:29:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 09 Oct 2020 03:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gzFLDC
        f1bWBN9SWpDj/BZPfMKLIzZa5WDtAF9oPH4jo=; b=Ngj5/xvyZTB/WWzuI6QTk/
        KMEkJdBzZ6d2BhmkznaZzAyhMV3kskDR/BlBPAWn7gfQz6fDvffitoDR7/vhAGCX
        E8mMniA8Jd/LkVCv0RaebnGPbWOL2VDwyMhA17lPK7sNpv+Vrqp9fGThs51LESMI
        Bi0ABRu2vbDXI4JNNSB98ieLqF+oIviZEim2TshCoYcQkoUvMiJIEvaiQ/yXCBaP
        vzdxPt/pLG6P6VuwwPyUUsXZOjXVbGofwvrJjfeiftM/iJz16DpuG0E/R5CHHfOf
        k8nAcBDFngCG3Fx4ToMJDOXRG9MY6xQk6tnfEHAXInMUGGYzQeoBsovGVCFjkYoA
        ==
X-ME-Sender: <xms:dRGAXzp4RqFh_M_oqK01mwoL4kDO409OzzuWR3SbMfBED6kZLDbzsQ>
    <xme:dRGAX9poc2RjtbSafpKJbpWWUZT-7-f_zJh7WHsCWjOrvJ8gCi-HfJKCx1iAfjvHv
    3kQSfoXfQGLnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrhedtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dRGAXwPZryFxs-Ar7kATzeJpDv87g8YDcC3ZSkjHtqOh7Aol9hoeKg>
    <xmx:dRGAX26Ef0KTqcJMLM1n7sw5mR79RNX96J8M1gB_YWrKj5RJCsU3nQ>
    <xmx:dRGAXy778ZbdRJd72digvLD_W4oshk-03ogoc2-m-Cn_jICM2lxqZg>
    <xmx:dhGAX3jzL_LOTWeLCrpMMDx2nNw9xkzKXuDSGOT8fvBZIdqYTtcxYw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A78633064680;
        Fri,  9 Oct 2020 03:29:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] vhost: Use vhost_get_used_size() in vhost_vring_set_addr()" failed to apply to 4.14-stable tree
To:     groug@kaod.org, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Oct 2020 09:30:35 +0200
Message-ID: <160222863561194@kroah.com>
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

From 71878fa46c7e3b40fa7b3f1b6e4ba3f92f1ac359 Mon Sep 17 00:00:00 2001
From: Greg Kurz <groug@kaod.org>
Date: Sat, 3 Oct 2020 12:02:03 +0200
Subject: [PATCH] vhost: Use vhost_get_used_size() in vhost_vring_set_addr()

The open-coded computation of the used size doesn't take the event
into account when the VIRTIO_RING_F_EVENT_IDX feature is present.
Fix that by using vhost_get_used_size().

Fixes: 8ea8cf89e19a ("vhost: support event index")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kurz <groug@kaod.org>
Link: https://lore.kernel.org/r/160171932300.284610.11846106312938909461.stgit@bahia.lan
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c3b49975dc28..9d2c225fb518 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1519,8 +1519,7 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
 		/* Also validate log access for used ring if enabled. */
 		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
 			!log_access_ok(vq->log_base, a.log_guest_addr,
-				sizeof *vq->used +
-				vq->num * sizeof *vq->used->ring))
+				       vhost_get_used_size(vq, vq->num)))
 			return -EINVAL;
 	}
 

