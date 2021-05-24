Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CCB38E40C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 12:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhEXKcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 06:32:15 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:55047 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhEXKcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 06:32:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 541161940295;
        Mon, 24 May 2021 06:30:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 24 May 2021 06:30:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rVbmwH
        ZFYzLl/DMeWop9QFUFmgLaQar4MHdxa5qoKbk=; b=v2/Q3pIbIY4C9ZnP5B4Mt+
        5YLnntnCas4V7bk3rC4iJqX24dcEzH3X8DLmDwB2KRfGrHaOCpHGpWr4wiq28b+q
        jR1UefOIfHs4zYoREz90si2XF/ENnCyE40iu0i2mNha4XYEpJwSjAc9rkYMMQOjI
        Dlw27cEPhDkTv6rRfM533e7qjUSPpLFNBEpSUB8DXSXR8du0WZZz+W07XRHkOS7H
        vagptee5EiRNbpe/04GZIrTVkJbczfxVYbdOq+c82JH4WGHCLik49TtWazlPslxm
        PvaXDWGeNmW4WS9HMTWqNMNqMoMo4iXzoIZ9iZgCuEvbj0fKv8gCtNliH9KyOAhg
        ==
X-ME-Sender: <xms:VYCrYK8idtYdV9-ZRToTuG6DqlCHVkJMZjiZJahU779B8c-7_eunug>
    <xme:VYCrYKsawHZAdWCRvaYSYPh3vz8loqJyCVKOshDVP1hjz2Kdq6dH_RnACGoXbuExI
    bsrj0W65YRzMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VYCrYABVxf44kT92bFJ8E0kpHlaAozKdABuaWdp6xTBioqx4jQaZzQ>
    <xmx:VYCrYCedRmX1jJnM0lMF-VO4ITrs9izgHI_WAKpRDgwdvfWapUWjWg>
    <xmx:VYCrYPO3eX5DixY_O3q2abbd2jFXQczQ6mylEL8s_I03VdWRKgiWRw>
    <xmx:VYCrYIaw2iYaZr8dXdg3KRq-qCX8jbSChpGdNVcn1xWiRaZ0IiZydg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 06:30:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: meson-gx: make replace WARN_ONCE with dev_warn_once" failed to apply to 5.4-stable tree
To:     narmstrong@baylibre.com, christianshewitt@gmail.com,
        martin.blumenstingl@googlemail.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 12:30:33 +0200
Message-ID: <1621852233137243@kroah.com>
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

