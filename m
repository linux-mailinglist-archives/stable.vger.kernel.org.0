Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FC838E40A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 12:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhEXKcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 06:32:06 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:34109 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232519AbhEXKcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 06:32:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0B7621940295;
        Mon, 24 May 2021 06:30:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 24 May 2021 06:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9lmr+M
        I9IXnfwBGaOPODVA3Y/eSSyRtWqj70J1NReS0=; b=G3L+Y1oKftsE9xvmJlUKJg
        Yk1iFZu7fhNn4nM/WQcIiKt0L9th7ZJ085/1suEz4uLr5O8kCUsuh2dF83apZVlh
        u2JqXMkeI8ciw2YDW7+tA8v2wM+wKXg/IS41ItIyE9bBSxU4MLHO4qOP7jFbSoBK
        SpOf7Cq9k8AmWfguexV+ddz8kU20llJ0GVhvPV798/Uo3LZjAYeuyyBVsXuqdNCx
        t+rFKqqs9ObfVCPFIpevMhREMgzhVg/DO7WaGylTb3RL38iw+5gw3wBhOeuZe1Wj
        jt7utsvapMG7xSH81u3ox2ODVIERZxAgOsY3gaQ/a56VtUAKsTcreVBtd8biAjzg
        ==
X-ME-Sender: <xms:SoCrYBT3SmzVm1hxw9tNusA5BQsVPndu1zTUxqeB0L-dLekSyjT6CA>
    <xme:SoCrYKxHTdxK7Vd36Fab8djVfmHncfxDoMKhYdz2OhPjYP-r4kSxPkuM3PUnWKvcz
    iEmkgCqbogrOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SoCrYG1kPG3YCSZMPwhuQ7ikFvyzyeP3U7K06VRwVKwu15sT0WplWg>
    <xmx:SoCrYJAcUCRt2B8bK7iL9jK4NADcHFGTc008i_dw3-WByORyBkc1kw>
    <xmx:SoCrYKhNyeDLWbaTSkFsSfaHtEwj0-QszQ5LW8yfC_YVOR5UCLHGrA>
    <xmx:S4CrYNtnQU-0lipy4nK1YzyL2qPO3bLqTjuxkxnXw_eXhnp32YO9_w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 06:30:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: meson-gx: make replace WARN_ONCE with dev_warn_once" failed to apply to 5.10-stable tree
To:     narmstrong@baylibre.com, christianshewitt@gmail.com,
        martin.blumenstingl@googlemail.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 12:30:32 +0200
Message-ID: <1621852232198223@kroah.com>
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

