Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD34A38E389
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 11:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhEXJw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 05:52:58 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:38037 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232536AbhEXJw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 05:52:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 029DF19405D6;
        Mon, 24 May 2021 05:51:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 24 May 2021 05:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UprfwP
        4/q5kptlN3GPKDUYvF9EyoYT/dvYF3xlfXEjU=; b=J/E5nALxBDH5CkIQW9zPTL
        9r249dJYRJo783qvHF5Ke73YwcT56mASHiH7xkhgVaUGmn9tPw2t6FGIXRrlzKkg
        a0hDuI4xj42YTWIlF9TROQV/aorVUf2XlfSE+UxLP+qUGoFkTEXn0Bw8SKL8FXVU
        yQN7Ij+coCHnwUzzYQcBDfftdhkHuGxSekFqiOZP814+9S+DJfAr+/ZWTgHjkppg
        8stzdCJmxcepg4TXmlBAvPMA6NYa9Vbjeq6u8Hbue6KQ3EtWTSFiavJyHugqos7g
        md1bbrlQc8V2/Eof9rlfVLNIbi8I6ZjozajkE1JbzJhgD6OSEsNua3u7WrYrZnFA
        ==
X-ME-Sender: <xms:IXerYHWy-hZ8UAjYxRg_juLMZoUUsot6J4t66k5RlLiOqh4mRo5J0g>
    <xme:IXerYPk15Ub_bDy3k2LPBgaLHAWPZ77MjcE09q-g4ArvUA3rR-NjfCwPO5VKQ8IuU
    dAnXh1IP11ZBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:IXerYDYJAsU1VrMyDsZezu-7O7IXjNY706e4yYRmeHd0vIf4W4c3uA>
    <xmx:IXerYCXcz0wrcQBpMJYPhPFT7bBxc1CxfmDKaAowMLN6ZV35mj7Vlg>
    <xmx:IXerYBm-qbhd8GaeqbHE7k4SStYWvZ9Z5mHJagsRXJJ7PsD4VYyRsQ>
    <xmx:IXerYBtnNuhx9Qkxdg6oY9ULeh7-De_l7tg8k0fdiIekJuMXKYDVrQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 05:51:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] uio_hv_generic: Fix another memory leak in error handling" failed to apply to 5.10-stable tree
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 11:51:20 +0200
Message-ID: <16218498801564@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

