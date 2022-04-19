Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB4F50771F
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbiDSSNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiDSSNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:13:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153F311A11;
        Tue, 19 Apr 2022 11:11:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A331960C34;
        Tue, 19 Apr 2022 18:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90ADC385A5;
        Tue, 19 Apr 2022 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391869;
        bh=6JIV9bAl3AlhOIFiWtU+aC2MWdNmcLlPqJm+dbFnVFU=;
        h=From:To:Cc:Subject:Date:From;
        b=s8kF+pghm1cBam+/lZcRDPVj2LBEEqGcOfk/4adNOM1KeBoju4pHJmwXz3kR/AW7M
         oB//ImPKLth4hNqnSLG8FyAzrlP2g2tTOm+t6QiwnaDXgYfAXvCIT493lZ2cb6YSJF
         UJkKUJPozMdKVhcLqktKUOsfuR1T8a3a+KPfCLsotRC6oG88CZf2ACay7GKlql2WJ5
         XLy/bdjq5p8NkhB0/ROMA7lPTOVFOVdAhMezG0TGRakFTFXFjTjQ2S0MS9klPBuOQV
         Oon2zDGsZqe7jefEhQ+f0zpE5Yd3JN2kvxOqM7NhBgeQvOL3q3ErNguyszwRR0t0jS
         zOU0QfS1GoVRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        quic_akhilpo@quicinc.com, angelogioacchino.delregno@collabora.com,
        bjorn.andersson@linaro.org, jonathan@marek.ca, nathan@kernel.org,
        vladimir.lypak@gmail.com, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 01/34] drm/msm/gpu: Rename runtime suspend/resume functions
Date:   Tue, 19 Apr 2022 14:10:28 -0400
Message-Id: <20220419181104.484667-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit f7eab1ddb9f8bc99206e3efa8d34ca1d2faca209 ]

Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20220310234611.424743-2-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index fb261930ad1c..b93de79000e1 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -601,7 +601,7 @@ static const struct of_device_id dt_match[] = {
 };
 
 #ifdef CONFIG_PM
-static int adreno_resume(struct device *dev)
+static int adreno_runtime_resume(struct device *dev)
 {
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 
@@ -617,7 +617,7 @@ static int active_submits(struct msm_gpu *gpu)
 	return active_submits;
 }
 
-static int adreno_suspend(struct device *dev)
+static int adreno_runtime_suspend(struct device *dev)
 {
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 	int remaining;
@@ -636,7 +636,7 @@ static int adreno_suspend(struct device *dev)
 
 static const struct dev_pm_ops adreno_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
-	SET_RUNTIME_PM_OPS(adreno_suspend, adreno_resume, NULL)
+	SET_RUNTIME_PM_OPS(adreno_runtime_suspend, adreno_runtime_resume, NULL)
 };
 
 static struct platform_driver adreno_driver = {
-- 
2.35.1

