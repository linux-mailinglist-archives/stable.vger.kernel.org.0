Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC343288382
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731919AbgJIH34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 03:29:56 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:36931 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732006AbgJIH34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:29:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 496751940B1B;
        Fri,  9 Oct 2020 03:29:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 09 Oct 2020 03:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8U6Acp
        iJIiMYczxU/AQMCBYddSViVenKclt6/gJCOgI=; b=o75v5+dsEomuixC6ywo9gl
        JIuEDnt9ze0rLupQJiy+zunsW/aOGMAm1ATocWPw4n7TlG8xG8+8Ir3U4jpOPp6A
        LF0U6FtUJsA8/qGs6r7hRlr+sufDakFkmn88qyGrR0u9teGvXAr7EdXejlSD1MsD
        lGLuF6T7ctfpiiinAmZnFMbOVWtbVafa19uu1ZjeiDlNwPFL1E+00FlksYMW4S+s
        ctBxMNZZ8TI3yra2Q0REWH168RdT30AXA4Le2w1sf1Rq4D2WOjMTAY7boQuhTiDy
        kdgWjCLLwsjB0w9ZpVPFVsG8ogIRDPtjSUR30E3uIBhn+8TOvSlT4NS/J2QbGULw
        ==
X-ME-Sender: <xms:cxGAX3zr8lqcSdROMq6-Irm1pyoj3t3oYdmg5YCOgfvB5HgHvpJI7A>
    <xme:cxGAX_THRd_-w0owN5AyHeEqfTgi1uAYZqs5OZqk0nKC_pkHkkWZ962c1t6NB305z
    aLtksX1NGZERw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrhedtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:cxGAXxWzq6b3eQx4fHNok4rmQX-zxK_ipa_zb3uyCpghRLdpwuDd-Q>
    <xmx:cxGAXxiKP8zxYt-pIws3Z_mKrDAWfi8EIP2qpzxhrp3a1N99VTGQJw>
    <xmx:cxGAX5Agg2dQ-axtVCQHOdGD_-6rBNDW0q6XXYa80OuZmCeTHRisHw>
    <xmx:cxGAX8o9sjViUl-BKkyWhsI1HTcLI0v_wIsZYILvhbOq5IL8kig5tg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D834B3064683;
        Fri,  9 Oct 2020 03:29:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] vhost: Use vhost_get_used_size() in vhost_vring_set_addr()" failed to apply to 4.9-stable tree
To:     groug@kaod.org, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Oct 2020 09:30:34 +0200
Message-ID: <160222863457229@kroah.com>
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
 

