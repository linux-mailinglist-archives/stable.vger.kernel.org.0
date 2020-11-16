Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B692B4B1F
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbgKPQ3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:29:36 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:57913 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730795AbgKPQ3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:29:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6A91A19434C9;
        Mon, 16 Nov 2020 11:29:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 11:29:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VgpjFF
        eq0gvM5nySvsCgomcYungSiGc0HCgqqaoq3oI=; b=XT2w3fGI5K1b1Q7KLWi4Ah
        jf0+OeOOQWLrlMNW4CPWtYlzpKshut1V1V/lnZXlsrY5RLXymRNzu59K84eMPx9C
        5D+xPxlN4OCTLpxMLWn5hUsfVA43iXgh+jEgbG6JtN75FDlCYkjGVv22Bt9Z18O9
        xAseIbQcm2e4M0mYFWhURT3wUGZvwdIp0Ya/+jKaXO9B35nNm43A1HDAz1F4Mm72
        0tCyFthf3abnN4PQp3TImIAouZz7lc7vatIBOBAIjsMMFVUOV0obCcnIeRQKq9x+
        JV45lRPxsWSx9MK0ED4EWEZxDkLMPEu4SAFrb2Yx779I65bYEc5eGGUEuzVpExZA
        ==
X-ME-Sender: <xms:76iyX2Kq4yh6hsiN_1rjwZYNs3Q8Hj9j-05C3KGO95YSXeOPLyqdGA>
    <xme:76iyX-KzUUqvTIa82KbSoWPvI-XwBnkxW31OlLoGTPev3wqr5eWvNtXaoz23fYQZl
    37iWJL1M8AAJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:76iyX2v7HtT9lk3xh5eTmV13VQ9oeoTdoQ3TF6TTBQxljziB4Qo20w>
    <xmx:76iyX7aamvyvMdlnotBH71I1zv-Xa7smM8Xm0sIdGz3p5CG4EShyOQ>
    <xmx:76iyX9Yn3ySM2QRvxclCtizXiVqJ1f2SbGixzA3RLD3lKzVRPvh7OA>
    <xmx:76iyX8kZO8MiHP5nX1BQuLe1Eo-p5JmebKa6eBu97_3owXfwX6lstQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 097AD3064AA6;
        Mon, 16 Nov 2020 11:29:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: renesas_sdhi_core: Add missing tmio_mmc_host_free() at" failed to apply to 4.14-stable tree
To:     yoshihiro.shimoda.uh@renesas.com,
        niklas.soderlund+renesas@ragnatech.se, ulf.hansson@linaro.org,
        wsa+renesas@sang-engineering.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 17:30:15 +0100
Message-ID: <160554421531232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

