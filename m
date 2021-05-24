Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B78038E40D
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 12:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhEXKcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 06:32:16 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:44829 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232445AbhEXKcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 06:32:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 05A7C19408FC;
        Mon, 24 May 2021 06:30:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 24 May 2021 06:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mXukFG
        g8CJ3Bvi619+pmuIabQsFe1J168jF/Pl8CEOU=; b=p6MWYRxeDYC1YjYLTR5prd
        hrbxXdige9uLt+brUn1/gWqbfeuIBEEMicoeBrNW4ORz5gh/1mHn/nYtX2U3PudL
        +4eChQwerUeo9lmL/ivh//M6DZK6L+Y1mta7+Nr4e/8B7M5WlWIowkSafer9ZoSY
        FKXhggxAIjM0tJTgDj2FiQ88F5kSDxBTjtzBxRqxLLBm4aB+eSwxwdGXDI9dNTQx
        /zw+vVSyY7J51norsYyh7srO6aYgjbrnBVeOYuGTnagwycH8SlPFE8tAXe2rKaV0
        y2ONo2ztzVI3E70SOd7SDaUKuLy3RklpvuzPqTG18PNCvFyuBJYmZ2ua2AVTRtOQ
        ==
X-ME-Sender: <xms:VoCrYOs6CdT6kn3M6drDqIgK9TOkyaGNe_96WIr6EtA0nDmf1nKZwg>
    <xme:VoCrYDdUd_Wn5jedPKbu74l1UQFfGvED6himbqr-W37J3Crbb6yQRM-J90TQVHyYL
    ZrMpNK23s0eRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VoCrYJydjAWe2diUt35PreGsjJL0xMyqMGugWsjvkZAfKRS5kV3Mvw>
    <xmx:VoCrYJOvLIuwIBaFM6eCcsWfvxDMNrw_qH7b_N5ofa-afxyljAlXiA>
    <xmx:VoCrYO-XjPkveGrWbXtqLKyA0Z0lRyt1gBnjhcHZ6tr4jDCMhcg9pw>
    <xmx:V4CrYAIU06DNnObI9k5g3tCPhQ57kI4C4FqJsiCqjSpFpMXtpLYadA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 06:30:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: meson-gx: make replace WARN_ONCE with dev_warn_once" failed to apply to 4.14-stable tree
To:     narmstrong@baylibre.com, christianshewitt@gmail.com,
        martin.blumenstingl@googlemail.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 12:30:34 +0200
Message-ID: <1621852234180115@kroah.com>
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

From cabb1bb60e88ccaaa122ba01862403cd44e8e8f8 Mon Sep 17 00:00:00 2001
From: Neil Armstrong <narmstrong@baylibre.com>
Date: Mon, 26 Apr 2021 19:55:58 +0200
Subject: [PATCH] mmc: meson-gx: make replace WARN_ONCE with dev_warn_once
 about scatterlist offset alignment

Some drivers like ath10k can sometimg give an sg buffer with an offset whose alignment
is not compatible with the Amlogic DMA descriptor engine requirements.

Simply replace with dev_warn_once() to inform user this should be fixed to avoid
degraded performance.

This should be ultimately fixed in ath10k, but since it's only a performance issue
the warning should be removed.

Fixes: 79ed05e329c3 ("mmc: meson-gx: add support for descriptor chain mode")
Cc: stable@vger.kernel.org
Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20210426175559.3110575-1-narmstrong@baylibre.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index b8b771b643cc..1c61f0f24c09 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -258,7 +258,9 @@ static void meson_mmc_get_transfer_mode(struct mmc_host *mmc,
 	for_each_sg(data->sg, sg, data->sg_len, i) {
 		/* check for 8 byte alignment */
 		if (sg->offset % 8) {
-			WARN_ONCE(1, "unaligned scatterlist buffer\n");
+			dev_warn_once(mmc_dev(mmc),
+				      "unaligned sg offset %u, disabling descriptor DMA for transfer\n",
+				      sg->offset);
 			return;
 		}
 	}

