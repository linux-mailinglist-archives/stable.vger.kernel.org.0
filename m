Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA06617E881
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgCITcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 15:32:48 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47413 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgCITcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 15:32:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 9002B21FEB;
        Mon,  9 Mar 2020 15:32:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 09 Mar 2020 15:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=J0ul29
        ax70fq35Etcx2wDIufIwu862NfRcdMg6gZWVM=; b=b67nyyEHsW7ryMwxQCYKg5
        YunLjEH2WsrOHan0CSseTbNp0R7f8Az4eAqrKOGwaTIZZTGLEkajEqKLIZiHWW4v
        vzDlINfQ8O4CnXmTjku8glmCx4y7T/8R0cD4C28aVutBOdhzctd5zpeOZ48bguzu
        IR+1bVDAnt3r9I9nwE8rqTQ19/l8xtoV8fSzdw5iPWmDJo0i+YJP7bm1u6/9+RsP
        JxGkSroFW73bVdjEUo66bP1a2QSYFf8GF5LdEzNhHJQmSQvVr0UUthEcjLfaXi0p
        7r35ZVa6m52gP/BAWa8Zc5etT2MESs9F0oOtGK0yTgTu4Sy3vMc3lDNWaybKUrzQ
        ==
X-ME-Sender: <xms:35lmXrUVmUQEjHcSSO-6Op7tzz2CosDF0hCJNK1ubdWrknUTBJW1Xg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:35lmXpvGv0PWYzJ3w-0l9aY3Wqa9niwZaUtkOo1t12uzO914LrCDCQ>
    <xmx:35lmXqEiVqBh9Hh1BM272Cx1M8VCMm9R-yaL4DuXZgw8EnBy-_hyEQ>
    <xmx:35lmXkJzkIK8ZnIfl3R047N2U8pL6Uvez9ecBvlivHxpsoxKp9CmAA>
    <xmx:35lmXs-6US8EU2t0V2OE_FcFJQnexwPyEYDM9f7hvzuxAt90UBdE7A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C354C3280065;
        Mon,  9 Mar 2020 15:32:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/powerplay: map mclk to fclk for COMBINATIONAL_BYPASS" failed to apply to 5.5-stable tree
To:     Prike.Liang@amd.com, alexander.deucher@amd.com, evan.quan@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Mar 2020 20:32:45 +0100
Message-ID: <158378236575229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ab65a371dd5f5cba6bd9a58a1a6d4115a71cc5c9 Mon Sep 17 00:00:00 2001
From: Prike Liang <Prike.Liang@amd.com>
Date: Wed, 4 Mar 2020 10:36:21 +0800
Subject: [PATCH] drm/amd/powerplay: map mclk to fclk for COMBINATIONAL_BYPASS
 case

When hit COMBINATIONAL_BYPASS the mclk will be bypass and can export
fclk frequency to user usage.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/powerplay/renoir_ppt.c b/drivers/gpu/drm/amd/powerplay/renoir_ppt.c
index 861e6410363b..568c041c2206 100644
--- a/drivers/gpu/drm/amd/powerplay/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/renoir_ppt.c
@@ -111,8 +111,8 @@ static struct smu_12_0_cmn2aisc_mapping renoir_clk_map[SMU_CLK_COUNT] = {
 	CLK_MAP(GFXCLK, CLOCK_GFXCLK),
 	CLK_MAP(SCLK,	CLOCK_GFXCLK),
 	CLK_MAP(SOCCLK, CLOCK_SOCCLK),
-	CLK_MAP(UCLK, CLOCK_UMCCLK),
-	CLK_MAP(MCLK, CLOCK_UMCCLK),
+	CLK_MAP(UCLK, CLOCK_FCLK),
+	CLK_MAP(MCLK, CLOCK_FCLK),
 };
 
 static struct smu_12_0_cmn2aisc_mapping renoir_table_map[SMU_TABLE_COUNT] = {
@@ -280,7 +280,7 @@ static int renoir_print_clk_levels(struct smu_context *smu,
 		break;
 	case SMU_MCLK:
 		count = NUM_MEMCLK_DPM_LEVELS;
-		cur_value = metrics.ClockFrequency[CLOCK_UMCCLK];
+		cur_value = metrics.ClockFrequency[CLOCK_FCLK];
 		break;
 	case SMU_DCEFCLK:
 		count = NUM_DCFCLK_DPM_LEVELS;

