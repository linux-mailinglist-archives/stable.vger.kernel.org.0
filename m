Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC44B2B4B1E
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbgKPQ32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:29:28 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:54625 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730795AbgKPQ32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:29:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 074BF1943518;
        Mon, 16 Nov 2020 11:29:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 11:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fFE5Ri
        R3r/m0yWesuShoH2Dljon7haHwHxRY6PS48Bs=; b=lxTH0MtmEGvheV2a/+UpBb
        x1PHpvsE7Zm/w/OJy6mlvjhXhka1eT80LIJ2OkQJVEUS2osnL5xZnd02GBAXwwNJ
        3klHV/BditHZbZd5oJwFGb0dd8G2dEs9s4PSEBy78VSWKNa+3XAbvM0NKQaAuR6J
        /c5K+wIUwP4fmkp2F1s+8Qmz01h7cPpfLvkrArblBJtQZLdpetiVmM08sNguFf5b
        r0CEDMxyn43XKm31f/j2+ggYsWIIvKNvlzeiVF4AAqM+2/XQfckbcn8krGfPq5ik
        69eawm/ctVD0UJ6n3gnMsUuL/pD/WmwE/tXLbh+6eqVkLawLrSQ8LyTvXLF4gzRw
        ==
X-ME-Sender: <xms:5qiyX0rGxxbLBZnp7eKBYCsSrz_5jWAH3kX85l3Hs_wiTupF-uRjkw>
    <xme:5qiyX6oFZG_vSMAtdDT64aR-wzTFhCswyCSNDHJObv8CNKNt09fzvHNZTkUxnMoFX
    onKvF8mbhagiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:5qiyX5N9xea9lHMfLdlvM6MUxhRjX5RORWsvPT0j2GWB0r7i8HTz6g>
    <xmx:5qiyX771TzMk5FNlph-oTXVPnndcMd2uynqLzf05g0J85X7IOW6xFA>
    <xmx:5qiyXz4aQDsrQ2Su2LlsnNPGudH-IQ8rrlJ7WPe0y_eBcjEcjK4LgQ>
    <xmx:56iyXzHxUH0R9QWTjHESBIZ4_B2lQh7hxBNuej22Z3vbKgE6cMfs7g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 06AE13280059;
        Mon, 16 Nov 2020 11:29:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: renesas_sdhi_core: Add missing tmio_mmc_host_free() at" failed to apply to 4.4-stable tree
To:     yoshihiro.shimoda.uh@renesas.com,
        niklas.soderlund+renesas@ragnatech.se, ulf.hansson@linaro.org,
        wsa+renesas@sang-engineering.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 17:30:14 +0100
Message-ID: <1605544214124163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From e8973201d9b281375b5a8c66093de5679423021a Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Fri, 6 Nov 2020 18:25:30 +0900
Subject: [PATCH] mmc: renesas_sdhi_core: Add missing tmio_mmc_host_free() at
 remove
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The commit 94b110aff867 ("mmc: tmio: add tmio_mmc_host_alloc/free()")
added tmio_mmc_host_free(), but missed the function calling in
the sh_mobile_sdhi_remove() at that time. So, fix it. Otherwise,
we cannot rebind the sdhi/mmc devices when we use aliases of mmc.

Fixes: 94b110aff867 ("mmc: tmio: add tmio_mmc_host_alloc/free()")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1604654730-29914-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 414314151d0a..03c905a781a7 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -1160,6 +1160,7 @@ int renesas_sdhi_remove(struct platform_device *pdev)
 
 	tmio_mmc_host_remove(host);
 	renesas_sdhi_clk_disable(host);
+	tmio_mmc_host_free(host);
 
 	return 0;
 }

