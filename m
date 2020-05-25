Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914041E0FEF
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 15:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403901AbgEYNzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 09:55:53 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56197 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403805AbgEYNzw (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 25 May 2020 09:55:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 70FD51940A17;
        Mon, 25 May 2020 09:55:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 May 2020 09:55:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xi5tJA
        r6pchs3Qd98DMTiP0qmFKg8GjaHxb4UEDj/74=; b=sgzbZkyIZ9Er7hEI7hwdXS
        J+dfHvv7jRmzngfLVR9LE04OAMGo8MDN3HcuefPvPDy2Aj7JYza3EU/d5Cb/KAR/
        KUoBFO1WGeOvixNFTB8JuEjRMVWcHLOucKeRbjZa7bJQKmPoYWuHk6cyI/x06156
        W/w2Us/CUNlM8SwdcZaEu70xW6mY+QJnAbj1jt86mwWd5IRpLLAlP6LUF/NrC3n5
        I0uT+656AOIHHtkFsQTBAlwd1IpEnBLHMnSfqnAFr1g9v0GCPPVVPzV90xdWM9nl
        jQE+spgLLX0C4huydAAYIQaqKH6Owjsc05g/zrgXR3xzEMiDF+vXYZ17VlyowRJw
        ==
X-ME-Sender: <xms:Zs7LXoGDpWyy9DdSjSx-5h4Jtgx92FnEXpadzIeb5wKEfjvD6CY3Cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Zs7LXhUAgVdPYu7noT46u2B12mcX-CvONo-fGJdl3F_xq9YqWJZuDg>
    <xmx:Zs7LXiI_vGiZ2_E0CW_s8dzN3kYf_70Vvb0Icvjv40XOvxhsNaxNPA>
    <xmx:Zs7LXqHZGq1_R7eCfIDMH_SSk3i8Y3KwIcirA7uZ0N1KUHMfRaTMcw>
    <xmx:Z87LXpBAe-R0tCBPJ1kbLx3sMaw54wVMHfy15f8zaKI7IFWXEMm-IA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A717B3280059;
        Mon, 25 May 2020 09:55:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iio: sca3000: Remove an erroneous 'get_device()'" failed to apply to 4.4-stable tree
To:     christophe.jaillet@wanadoo.fr, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 15:55:49 +0200
Message-ID: <15904149492638@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 928edefbc18cd8433f7df235c6e09a9306e7d580 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Wed, 6 May 2020 05:52:06 +0200
Subject: [PATCH] iio: sca3000: Remove an erroneous 'get_device()'

This looks really unusual to have a 'get_device()' hidden in a 'dev_err()'
call.
Remove it.

While at it add a missing \n at the end of the message.

Fixes: 574fb258d636 ("Staging: IIO: VTI sca3000 series accelerometer driver (spi)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/accel/sca3000.c b/drivers/iio/accel/sca3000.c
index 66d768d971e1..6e429072e44a 100644
--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -980,7 +980,7 @@ static int sca3000_read_data(struct sca3000_state *st,
 	st->tx[0] = SCA3000_READ_REG(reg_address_high);
 	ret = spi_sync_transfer(st->us, xfer, ARRAY_SIZE(xfer));
 	if (ret) {
-		dev_err(get_device(&st->us->dev), "problem reading register");
+		dev_err(&st->us->dev, "problem reading register\n");
 		return ret;
 	}
 

