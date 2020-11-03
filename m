Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1735B2A44A3
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgKCL5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 06:57:36 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:59337 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728202AbgKCL5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 06:57:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 438F1B58;
        Tue,  3 Nov 2020 06:57:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 06:57:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xvwvOn
        n1lSdEruafzESpqfi20Xy7X90tq4Vkl2iN0e4=; b=aPy2aFNRHjFkPcGSUsNaC1
        c0ln9HFeAT0hpbsSQDM8rzPTRL8CfjYucL63oAmgS9bi2fM5EXPBwpnDk12uWY2Q
        2Dkez7RYz2FKq2ibRs5kOnKVH/8VaXMOL9py49iznTdeYVZTHtE9IZFwdl060FYr
        cfDNiP8Ks+Rmz/faGlSk4AGnbFP2Ibb7IqFJ181PP2oaKqoBFiBJGMvhx1AIZEJ+
        trR4Npr8zlFuJFeayWkIjy6NbyiNk5no8yRXzb60fVV8lRdtGEoBoOuOgDLJSXsV
        wWhF5jecNpYyhyb9MlY01nCk4uDBJ2EzhVJeKoG8hgc5dzScgaY4Q/8U+N3PxrQw
        ==
X-ME-Sender: <xms:rkWhX9KzGyCCN3cn817-9o3RtuY3tU_68gDKcstBWIHsENZZ_DssJw>
    <xme:rkWhX5JY6LgUZEeQCMyCkJn0XofHgIolZZ96cBS7TkoJ8kQvMES5ggtAqGToKnycJ
    fOM5wKxfy58dQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:rkWhX1s6ebQEBTNdrVeONWBE1QCNgtFCZObu-ihXZ_QgC80jlwnKxQ>
    <xmx:rkWhX-YG07wAmQNWxYnxch9IOVuss7jLQEcHnQv_KwaaQ3I5e8jtdg>
    <xmx:rkWhX0ZYWAr1F8n62A-nEMdYuNbsACOptQ1K8onDxkUI4fdgH3uERQ>
    <xmx:rkWhX9AnU6uwUeVc1KCxRgb0GGGGL7WhOxOO8cosyGAnEis42jPNOHRkIgw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 167A03064674;
        Tue,  3 Nov 2020 06:57:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] leds: lm3697: Fix out-of-bound access" failed to apply to 5.9-stable tree
To:     ultracoolguy@tutanota.com, pavel@ucw.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 12:58:26 +0100
Message-ID: <160440470667193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 98d278ca00bd8f62c8bc98bd9e65372d16eb6956 Mon Sep 17 00:00:00 2001
From: Gabriel David <ultracoolguy@tutanota.com>
Date: Fri, 2 Oct 2020 18:27:00 -0400
Subject: [PATCH] leds: lm3697: Fix out-of-bound access

If both LED banks aren't used in device tree, an out-of-bounds
condition in lm3697_init occurs because of the for loop assuming that
all the banks are used.  Fix it by adding a variable that contains the
number of used banks.

Signed-off-by: Gabriel David <ultracoolguy@tutanota.com>
[removed extra rename, minor tweaks]
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: stable@kernel.org

diff --git a/drivers/leds/leds-lm3697.c b/drivers/leds/leds-lm3697.c
index 64c0794801e6..7d216cdb91a8 100644
--- a/drivers/leds/leds-lm3697.c
+++ b/drivers/leds/leds-lm3697.c
@@ -78,6 +78,7 @@ struct lm3697 {
 	struct mutex lock;
 
 	int bank_cfg;
+	int num_banks;
 
 	struct lm3697_led leds[];
 };
@@ -180,7 +181,7 @@ static int lm3697_init(struct lm3697 *priv)
 	if (ret)
 		dev_err(dev, "Cannot write OUTPUT config\n");
 
-	for (i = 0; i < LM3697_MAX_CONTROL_BANKS; i++) {
+	for (i = 0; i < priv->num_banks; i++) {
 		led = &priv->leds[i];
 		ret = ti_lmu_common_set_ramp(&led->lmu_data);
 		if (ret)
@@ -301,8 +302,8 @@ static int lm3697_probe(struct i2c_client *client,
 	int ret;
 
 	count = device_get_child_node_count(dev);
-	if (!count) {
-		dev_err(dev, "LEDs are not defined in device tree!");
+	if (!count || count > LM3697_MAX_CONTROL_BANKS) {
+		dev_err(dev, "Strange device tree!");
 		return -ENODEV;
 	}
 
@@ -315,6 +316,7 @@ static int lm3697_probe(struct i2c_client *client,
 
 	led->client = client;
 	led->dev = dev;
+	led->num_banks = count;
 	led->regmap = devm_regmap_init_i2c(client, &lm3697_regmap_config);
 	if (IS_ERR(led->regmap)) {
 		ret = PTR_ERR(led->regmap);

