Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388BB5A6977
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiH3RSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiH3RSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:18:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD0DD59B4;
        Tue, 30 Aug 2022 10:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFC3961777;
        Tue, 30 Aug 2022 17:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19438C433B5;
        Tue, 30 Aug 2022 17:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661879915;
        bh=rsBZ9omJFlXHM0Xnd/vfXJa6R/hMrsdX9ze4QNMC77g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzL9Y6BKyT76d1+fdRAWVThk1hNkIpLXZ5nbjrZlRYUhP1hLnRJYtchsjHDrigI5Z
         pxWtqogInrp2H7Q7Sn9cm7dJNLV3Em+E7JLcQKc5DNKOmTKihKcKkGHlAdyGZO1nHF
         U61bsQijNvO2yS58zM1gJLnJILDXs5Vk0cGB+SyejCGi3HcvV0fK09AZxqGnmmS79r
         43XnW1IrJSstb4zK9JKYNCJOvo4YQjOQXBzDOsMezK/Fb8k9tSVezfw7lKXlainYlC
         KB4Xu0IsGz2HFm2i5g+brWOa3dhSebZkRVSNtFEcSzLCUamRp3agTATRybZxqS+58z
         0sJh9z/4lZKKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sasha Levin <sashal@kernel.org>, emma@anholt.net,
        mripard@kernel.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 05/33] drm/vc4: hdmi: Depends on CONFIG_PM
Date:   Tue, 30 Aug 2022 13:17:56 -0400
Message-Id: <20220830171825.580603-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 72e2329e7c9bbe15e7a813670497ec9c6f919af3 ]

We already depend on runtime PM to get the power domains and clocks for
most of the devices supported by the vc4 driver, so let's just select it
to make sure it's there.

Link: https://lore.kernel.org/r/20220629123510.1915022-38-maxime@cerno.tech
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
(cherry picked from commit f1bc386b319e93e56453ae27e9e83817bb1f6f95)
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/Kconfig    | 1 +
 drivers/gpu/drm/vc4/vc4_hdmi.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/Kconfig b/drivers/gpu/drm/vc4/Kconfig
index 061be9a6619df..b0f3117102ca5 100644
--- a/drivers/gpu/drm/vc4/Kconfig
+++ b/drivers/gpu/drm/vc4/Kconfig
@@ -8,6 +8,7 @@ config DRM_VC4
 	depends on DRM
 	depends on SND && SND_SOC
 	depends on COMMON_CLK
+	depends on PM
 	select DRM_DISPLAY_HDMI_HELPER
 	select DRM_DISPLAY_HELPER
 	select DRM_KMS_HELPER
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 23ff6aa5e8f60..c5702f22fe1a8 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2875,7 +2875,7 @@ static int vc5_hdmi_init_resources(struct vc4_hdmi *vc4_hdmi)
 	return 0;
 }
 
-static int __maybe_unused vc4_hdmi_runtime_suspend(struct device *dev)
+static int vc4_hdmi_runtime_suspend(struct device *dev)
 {
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
 
-- 
2.35.1

