Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2899E377DDC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhEJIR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:17:59 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:44057 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230415AbhEJIRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:17:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 299811940BC3;
        Mon, 10 May 2021 04:16:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 May 2021 04:16:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZLbTPt
        gLurwuktDySsGQZ2wal0Mw7oFg8td17SIRIro=; b=USgs3htNAm3o7ZWVf/JY+o
        M2j8cOm49w1FSpT7W9nnBB8MIRt6eJikzRUDKqVtbP5QKJFmv3zHbJn38Jqjmle/
        BzSMwuNiBf6k/vt6RMae/9IPgtRGQvQ03ltFOkFRxTAW9WZrjOdE0LXomQ/fKynJ
        ApNuGooepZIcGRqDQCxmFs0mlzJMLcNyROPi4CzSei7hYPZ5K35TIAqsatJSAAxw
        5Ict4f9PO/OaciLwSb9O7V7QmDYbIhAx6BiDjIaW+3mNtffFwGpAPqSmhszeeEOm
        Cxvvo6GCHRX7zo9fIYyHJVQ9WwXJkByZqt4dh+7KJm2s18FSKg93bltKhEb/EoJA
        ==
X-ME-Sender: <xms:6uuYYI9hubCrfgdCPz16RPQEnJsfVVtQfR58AI9jMAyfIPH7-KRGWg>
    <xme:6uuYYAsgXwZVeHEzqTU_RJBsl5lWaVfQEVO4ZXUIgBNNk7VsKIOvpZZl9-AX4_nvR
    hKXGtOGMkchAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:6-uYYODezjhJMyTHuz6RpiNaCcp5zAW2qoV-kgZt69POIAcz1WAn9A>
    <xmx:6-uYYIeRtQeHYqVrhUiVX9AI8ZHOzY2PjoLIwfuM2aUjO4hjIscoQQ>
    <xmx:6-uYYNMExt-w5avgGulx4dqQM_V4jPn9s__x7ybpNaQAGLlLFv1RcQ>
    <xmx:6-uYYL2mpMCcA3Tx_ghvCo00bNq0P0HrwSoch9hzLTzH1c9OSo4hQg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:16:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] media: venus: pm_helpers: Set opp clock name for v1" failed to apply to 5.11-stable tree
To:     stanimir.varbanov@linaro.org, bryan.odonoghue@linaro.org,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:16:41 +0200
Message-ID: <16206346010196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3215887167af7db9af9fa23d61321ebfbd6ed6d3 Mon Sep 17 00:00:00 2001
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Date: Thu, 25 Feb 2021 15:28:57 +0100
Subject: [PATCH] media: venus: pm_helpers: Set opp clock name for v1

The rate of the core clock is set through devm_pm_opp_set_rate and
to avoid errors from it we have to set the name of the clock via
dev_pm_opp_set_clkname.

Fixes: 9a538b83612c ("media: venus: core: Add support for opp tables/perf voting")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index e349d01422c5..95b4d40ff6a5 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -279,7 +279,22 @@ static int load_scale_v1(struct venus_inst *inst)
 
 static int core_get_v1(struct venus_core *core)
 {
-	return core_clks_get(core);
+	int ret;
+
+	ret = core_clks_get(core);
+	if (ret)
+		return ret;
+
+	core->opp_table = dev_pm_opp_set_clkname(core->dev, "core");
+	if (IS_ERR(core->opp_table))
+		return PTR_ERR(core->opp_table);
+
+	return 0;
+}
+
+static void core_put_v1(struct venus_core *core)
+{
+	dev_pm_opp_put_clkname(core->opp_table);
 }
 
 static int core_power_v1(struct venus_core *core, int on)
@@ -296,6 +311,7 @@ static int core_power_v1(struct venus_core *core, int on)
 
 static const struct venus_pm_ops pm_ops_v1 = {
 	.core_get = core_get_v1,
+	.core_put = core_put_v1,
 	.core_power = core_power_v1,
 	.load_scale = load_scale_v1,
 };
@@ -368,6 +384,7 @@ static int venc_power_v3(struct device *dev, int on)
 
 static const struct venus_pm_ops pm_ops_v3 = {
 	.core_get = core_get_v1,
+	.core_put = core_put_v1,
 	.core_power = core_power_v1,
 	.vdec_get = vdec_get_v3,
 	.vdec_power = vdec_power_v3,

