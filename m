Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EFE395157
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 16:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhE3OqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 10:46:14 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:56823 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229580AbhE3OqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 10:46:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 40D9119401D2;
        Sun, 30 May 2021 10:44:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 30 May 2021 10:44:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=++yopl
        kNa1jsjtFDGgC6oq6Cl5lpYxXOGPavcTevipw=; b=wX/22nNmFC3IQ3ODPx8D9m
        9vj7yOFBafa7VYaSbW3J+Kl4D+D8+B8Ne3+IsuEbmS8VuSLUeTPOwyKWaLnaRju+
        O9lUKf2o/HE0ZRpV/CDiazjiBNQcBF06IjJaDL/T8ozM37WRM3tZLEGmkhGd3rju
        Whzt8JDu8W11OZ9NlBJdsuvaEXMnwcmH5WqO0bU1r8Qx5K792LElTFai6370hrO+
        tloPRlyr8OkBwpr5A082U0PamFj33L0jyZ+hiwrmRn+Xm1O1XSbC0tbihAuK3qJp
        TZRxORN4PImWMvinnZKTWZ9pgROk1SXTAfPEtsRUDGrawOGP88VVm4EsXgDWAVPw
        ==
X-ME-Sender: <xms:0qSzYEKOLY35IQNotS0wNOJNvaKcO_0CRJRUG9RL-wBbukKaekJe7Q>
    <xme:0qSzYEL6ArMfVEb7upsuLGihdk2Ysu_ySsHsdhtlFVlwlEfVb8Eky9K3j3bXDpDQ_
    GuLLYrJjaYPSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:0qSzYEsyVM1bf5T2_3p4P9z1Iln3b5YzY7g81W5iom7p_nfP599qOA>
    <xmx:0qSzYBY4EL5Z_EIrgqkMQTXFVTvu2YHVGJJQPgkA1XuDjxGxB0zkIA>
    <xmx:0qSzYLZp14PgGNexoa0XrFZUGo9jVRDdVu7G52WpmpdOLTAbFak2-Q>
    <xmx:06SzYMAtO8XOkw02cS_c_YBw4pDshgSfGLLIhnFEXZykeBaIAOyR1A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 10:44:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] i2c: mediatek: Disable i2c start_en and clear intr_stat" failed to apply to 5.4-stable tree
To:     qii.wang@mediatek.com, wsa@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 16:44:32 +0200
Message-ID: <162238587231164@kroah.com>
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

From fed1bd51a504eb96caa38b4f13ab138fc169ea75 Mon Sep 17 00:00:00 2001
From: Qii Wang <qii.wang@mediatek.com>
Date: Thu, 27 May 2021 20:04:04 +0800
Subject: [PATCH] i2c: mediatek: Disable i2c start_en and clear intr_stat
 brfore reset

The i2c controller driver do dma reset after transfer timeout,
but sometimes dma reset will trigger an unexpected DMA_ERR irq.
It will cause the i2c controller to continuously send interrupts
to the system and cause soft lock-up. So we need to disable i2c
start_en and clear intr_stat to stop i2c controller before dma
reset when transfer timeout.

Fixes: aafced673c06("i2c: mediatek: move dma reset before i2c reset")
Signed-off-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 5ddfa4e56ee2..4e9fb6b44436 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -479,6 +479,11 @@ static void mtk_i2c_clock_disable(struct mtk_i2c *i2c)
 static void mtk_i2c_init_hw(struct mtk_i2c *i2c)
 {
 	u16 control_reg;
+	u16 intr_stat_reg;
+
+	mtk_i2c_writew(i2c, I2C_CHN_CLR_FLAG, OFFSET_START);
+	intr_stat_reg = mtk_i2c_readw(i2c, OFFSET_INTR_STAT);
+	mtk_i2c_writew(i2c, intr_stat_reg, OFFSET_INTR_STAT);
 
 	if (i2c->dev_comp->apdma_sync) {
 		writel(I2C_DMA_WARM_RST, i2c->pdmabase + OFFSET_RST);

