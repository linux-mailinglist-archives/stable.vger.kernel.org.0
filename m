Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2C8288380
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731967AbgJIH3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 03:29:48 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:38453 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732006AbgJIH3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:29:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CEF5F1940B24;
        Fri,  9 Oct 2020 03:29:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 09 Oct 2020 03:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ctivqb
        HgoGWFsc8BvMt5barK9r998f/B4qnlzU/RpQo=; b=kVG5uQeQlHHFdJbIymIrbA
        oNXF2WuRIJTGnOsXwqc1A7UimsUkf6eStC13GUiLVQWHsnkmPH1HUq2lcTLImqy6
        1cIktdfG/uATbG9TgNiaCQzKKtllfcYlVr+Pxv9kTuxIjmZ8R+bNp5uB3W1tGK5i
        Zl7z2qO0E17+XB+qOwQly+Ny9fYK+L7LZ7CtcG+OiTVkPD6VD/egMJ7/13TkC7KK
        W+t8beODQ6D9y0XMg1I6wCAP3GgT4422mhIgoqh3ouiXBJwxRgMWwCdZ/Wp5GD37
        mLBwD0/9nptO0raYMJqebtjlbwr/EW+BN2uOAb+TngyrTs/0vWHj0Q5h0RcJ+0Ew
        ==
X-ME-Sender: <xms:ahGAX6ENJm7t9g06iHAukFVYJuhhgNj3c6DuXepcFporK1sfX91ZYg>
    <xme:ahGAX7WP1IxVwRO9R5nKPmFiLaMHDyuSj3Tv1kPTot9yLH6LDFFBBiEuJhRkQirWC
    RXzXsPWAc0u3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrhedtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ahGAX0Im2lcXrIEPvdzMu8OGc6GlC3jf3iRkgaCKeNH4JsSltaoo0g>
    <xmx:ahGAX0EC_Ss8aw5SU7VxJFxJaQk98WfzeKgW2uvyaZo5D3csO-bh3g>
    <xmx:ahGAXwUg8LiXAHTOBZ-4X2LxuY4MyB8Sg_7wlPYaXxI1D1J_s0K83A>
    <xmx:ahGAX5cJuX47Xl-4RzU62O4jfQ2DN-SVsG5v8Tc_zruesj_S53KkXg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 709CB328005D;
        Fri,  9 Oct 2020 03:29:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] vhost: Use vhost_get_used_size() in vhost_vring_set_addr()" failed to apply to 4.4-stable tree
To:     groug@kaod.org, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Oct 2020 09:30:34 +0200
Message-ID: <160222863425597@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

