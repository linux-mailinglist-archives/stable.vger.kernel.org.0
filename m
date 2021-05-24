Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF3338E40B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 12:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhEXKcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 06:32:15 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:36425 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232422AbhEXKcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 06:32:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id A0D3C19402DF;
        Mon, 24 May 2021 06:30:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 24 May 2021 06:30:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=APZ/ct
        /IfUX7JotbH6j90fZjjwtCzdFhTMRJ1WsVxeY=; b=gJ4S/Fz4tfZO4gREK0sQWf
        uO7pXL5aj4FvsDqouT7K0Ojz1Qkn/8bzCntHblsrVRmT+ThwH/lSS8A+l/OFJ7zj
        NX7EYHKY4h9L+sElYBOS895LXr/R/9QFRDL6BCkDdrYxZa9GgffbYtlT8KfnyzRf
        ig9tU5hKq40tWYssvBAh6tOc262FHfk5puWI4FKInkY6FwRcFca0xVi99kdYfBe9
        IUv7jdzY8xksIUmaAO7h1u6OQQoHn/Ggm5H8mJvdrZ1zFepMXs1n0eKN+UH71Sr2
        rxbblh6YfwebUR41jrCTrbWT7xQ7VcjyPs0ZubkyQnPgBST3laNl5LsTiuPlpTBw
        ==
X-ME-Sender: <xms:U4CrYFtqFDi1Rq1Jtnf0ymi76JMVgv-IiehjFqNkshTWdQnvmlyccw>
    <xme:U4CrYOcmGXZaUoNgkAEsclxGko8OG9wcJYKg26xl2sc9ze8qYgH0c59U0fWutoavF
    -E6SOKIhejXCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:U4CrYIxy_QdT1LH5J7H0bgyf9aNwkC8xv5K8yAVtcIwPLdQ19r-DOQ>
    <xmx:U4CrYMP5xmEpiC1lXL1rr4BzYt0PoArAcFw0dcSdqZKFNp0Ksgd0_w>
    <xmx:U4CrYF9OJfx5bFBgVr8qMFV5y-5exJCi0UredWv0hWKg1bwyQl2ULg>
    <xmx:U4CrYHIoAr6roJKTlCQkrAkKJaOlaJUj-jO9YE19iwBTFMSr1BlwBA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 06:30:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: meson-gx: make replace WARN_ONCE with dev_warn_once" failed to apply to 4.19-stable tree
To:     narmstrong@baylibre.com, christianshewitt@gmail.com,
        martin.blumenstingl@googlemail.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 12:30:33 +0200
Message-ID: <16218522338758@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

