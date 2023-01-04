Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8357B65D63C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjADOmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239716AbjADOmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:42:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB6B1EEE8
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:42:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A12736174F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959CCC433F2;
        Wed,  4 Jan 2023 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843333;
        bh=VcNB51tnePVfRXEXPen51D9pt7/+mffWlJScHg3J7gs=;
        h=Subject:To:Cc:From:Date:From;
        b=AIqb1aGv1YG0YXYIZtoZBQJ7FMdQtX2d3LtXn+Zm908e6voUCkcCqx96hIg6ughI6
         jq7It7zpeGq+/TaImm2iX3VuOdlbiqBR+8x+nmfuiGLMgoRH4w5DpzaK3xE+3aY/dd
         HVPQfBKCzja59/mmYRBl384VVKEaN0ljKIgc/eBs=
Subject: FAILED: patch "[PATCH] drm/amd/pm: add SMU IP v13.0.4 IF version define to V7" failed to apply to 6.0-stable tree
To:     tim.huang@amd.com, alexander.deucher@amd.com,
        mario.limonciello@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:42:04 +0100
Message-ID: <16728433242070@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

027bf0cee89a ("drm/amd/pm: add SMU IP v13.0.4 IF version define to V7")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 027bf0cee89a27325a9a4f2240c21dd5fb81e4fa Mon Sep 17 00:00:00 2001
From: Tim Huang <tim.huang@amd.com>
Date: Thu, 29 Sep 2022 15:06:47 +0800
Subject: [PATCH] drm/amd/pm: add SMU IP v13.0.4 IF version define to V7

The pmfw has changed the driver interface version, so keep same with the
fw.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index 9d62ea2af132..8f72202aea8e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -28,7 +28,7 @@
 #define SMU13_DRIVER_IF_VERSION_INV 0xFFFFFFFF
 #define SMU13_DRIVER_IF_VERSION_YELLOW_CARP 0x04
 #define SMU13_DRIVER_IF_VERSION_ALDE 0x08
-#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x05
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0 0x30
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x2C

