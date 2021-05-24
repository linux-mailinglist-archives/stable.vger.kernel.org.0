Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F7638E388
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 11:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhEXJww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 05:52:52 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60393 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232536AbhEXJwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 05:52:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9CB3C19405D6;
        Mon, 24 May 2021 05:51:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 24 May 2021 05:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=F20WK3
        +bhXRpJa7dUHGYco0lPE54c6MCFmBAJ05PI8o=; b=o5bCUPyv7KcjNq6e3zsgK7
        qA3KQU+gmyAUDofmXFvvZRK1nXmu77ftH+xNobLDO5yArTP74RsbsKMgrFPB3c1+
        +A66VQLR37+MGlyjh/L9XrpzIAsQund8vsw1/B4t5xvLwT9LxMbKpCDqilpDKi1/
        LEaGE7kZT1OexQmkaTlFLza+2DkHKfQ6T+lm0QwgBtUN4TfMePkGNB8cbazctGHv
        dh88GKN74i482Yhy5LoobcLGj8UPvPgD7jsyOi5+54qDFDQ4JVNEEJmiIBWTwo0+
        8f2TdNbympLy4npHb7kAytlnUVE22z6PuvTB7yKvow4EvWHkaslr5stUNYbrV/Cw
        ==
X-ME-Sender: <xms:GnerYNpRp6xvFrwrOdQvWBjHTwfE5gO_PWaHBHms0dsqQdd2W5MnQA>
    <xme:GnerYPrRtZ88zJ_JlTVsOeqtmBXz6YMZM9HRtNWMPzT1SCsuzzaWRLUtCDoeKIvL-
    yP7LAacu6_0VA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:GnerYKNb6bA-JBzCt-8GVysd5QvqQ2U0twllGmO26eYHV0RNkfx9RA>
    <xmx:GnerYI7i1xQrB9XiunEUCXZz4e_Wj-Requ_B7SWELjOj7m8v5pf04Q>
    <xmx:GnerYM7OohDoJ650TY4wRrigUlySUajxTYp5Lh-fW56WDutlQcSVlw>
    <xmx:GnerYKRxZ9FWJiCMZAfhNzX19wPiOl4cQVH3b-NoCA5lfqkcYCgihQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 05:51:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] uio_hv_generic: Fix another memory leak in error handling" failed to apply to 5.4-stable tree
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 11:51:20 +0200
Message-ID: <162184988025597@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0b0226be3a52dadd965644bc52a807961c2c26df Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 9 May 2021 09:13:12 +0200
Subject: [PATCH] uio_hv_generic: Fix another memory leak in error handling
 paths

Memory allocated by 'vmbus_alloc_ring()' at the beginning of the probe
function is never freed in the error handling path.

Add the missing 'vmbus_free_ring()' call.

Note that it is already freed in the .remove function.

Fixes: cdfa835c6e5e ("uio_hv_generic: defer opening vmbus until first use")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/0d86027b8eeed8e6360bc3d52bcdb328ff9bdca1.1620544055.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index eebc399f2cc7..652fe2547587 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -291,7 +291,7 @@ hv_uio_probe(struct hv_device *dev,
 	pdata->recv_buf = vzalloc(RECV_BUFFER_SIZE);
 	if (pdata->recv_buf == NULL) {
 		ret = -ENOMEM;
-		goto fail_close;
+		goto fail_free_ring;
 	}
 
 	ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
@@ -351,6 +351,8 @@ hv_uio_probe(struct hv_device *dev,
 
 fail_close:
 	hv_uio_cleanup(dev, pdata);
+fail_free_ring:
+	vmbus_free_ring(dev->channel);
 
 	return ret;
 }

