Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E6C4FB5A
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 13:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfFWLrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 07:47:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41461 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726538AbfFWLrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 07:47:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 34C1121B8C;
        Sun, 23 Jun 2019 07:47:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 07:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Nw+YDe
        UGJbZzLy0cJP47Q2Wq2HTMlmxfZjxa0t2wzVs=; b=CfJgMlfBHmP5iqbRac/Huz
        4zR4/JlXf0ZPYkgvkEc8b5GZh2OHdTN2UWurCjUDlDbWd+++lIyqwKLz32gaETx2
        DG4EB7BGJFJL6x2YleKBNFyi3TcrE102llq+wZc6al8GLZaNqn5HE/D3UpUUnslJ
        rawP+laaR6abqY045celO95S5uEWAEk3ZDKt30w+gnatitaVLlgtLs38gejKWW4o
        BRzbCJ6yax9Fod5V9IUiovLXpWwnhItXwSLBTB8qyDbP11bskqt2ose6E3VBWs8y
        iSeVTIiuPIt9AXtYRmbi5G6UVY7yWAvzYi5AsV6KkTXrS6pkhqGF82ZpGoMiaSNQ
        ==
X-ME-Sender: <xms:02YPXUiIcpN6UOnulWDYzzR6M6pXBXzFbZ4RVdYp74NFMastKjTj4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepudejvddruddtgedrvdegkedrgeegnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:02YPXYbpgV3mXTPVxirDZNfVsY4gRlY4fb7hmQPpl2A5gdMXPHasuA>
    <xmx:02YPXZ3UDhPgrY6KQ8DERAAs_dKPuzcG-Aa2-rimXMGdXTxXQ5JGBQ>
    <xmx:02YPXbzLQGVMWd7AJfYOjXWlFtVWCWoT9HeNUNU5_NhrBxDglhQC6Q>
    <xmx:1GYPXWq2H3wfJ4EejrVLBr7aFjLxqQppulVlEcJDug1S2GzdBeGqnA>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE6B080059;
        Sun, 23 Jun 2019 07:47:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: sdhi: disallow HS400 for M3-W ES1.2, RZ/G2M, and V3H" failed to apply to 4.19-stable tree
To:     wsa+renesas@sang-engineering.com, fabrizio.castro@bp.renesas.com,
        geert+renesas@glider.be, niklas.soderlund+renesas@ragnatech.se,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 13:47:29 +0200
Message-ID: <156129044989128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 97bf85b6ec9e6597ce81c79b26a28f7918fc4eaf Mon Sep 17 00:00:00 2001
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
Date: Thu, 6 Jun 2019 13:35:35 +0200
Subject: [PATCH] mmc: sdhi: disallow HS400 for M3-W ES1.2, RZ/G2M, and V3H
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Our HW engineers informed us that HS400 is not working on these SoC
revisions.

Fixes: 0f4e2054c971 ("mmc: renesas_sdhi: disable HS400 on H3 ES1.x and M3-W ES1.[012]")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index 5e9e36ed2107..5f8d57ac084f 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -620,11 +620,16 @@ static const struct renesas_sdhi_quirks sdhi_quirks_h3_es2 = {
 	.hs400_4taps = true,
 };
 
+static const struct renesas_sdhi_quirks sdhi_quirks_nohs400 = {
+	.hs400_disabled = true,
+};
+
 static const struct soc_device_attribute sdhi_quirks_match[]  = {
 	{ .soc_id = "r8a7795", .revision = "ES1.*", .data = &sdhi_quirks_h3_m3w_es1 },
 	{ .soc_id = "r8a7795", .revision = "ES2.0", .data = &sdhi_quirks_h3_es2 },
-	{ .soc_id = "r8a7796", .revision = "ES1.0", .data = &sdhi_quirks_h3_m3w_es1 },
-	{ .soc_id = "r8a7796", .revision = "ES1.1", .data = &sdhi_quirks_h3_m3w_es1 },
+	{ .soc_id = "r8a7796", .revision = "ES1.[012]", .data = &sdhi_quirks_h3_m3w_es1 },
+	{ .soc_id = "r8a774a1", .revision = "ES1.[012]", .data = &sdhi_quirks_h3_m3w_es1 },
+	{ .soc_id = "r8a77980", .data = &sdhi_quirks_nohs400 },
 	{ /* Sentinel. */ },
 };
 

