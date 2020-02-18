Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0471631AC
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgBRUCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:02:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbgBRUCB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:02:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2013B24672;
        Tue, 18 Feb 2020 20:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056120;
        bh=yZYak2tDGAyXioyAn/oqvdhOUDgNJyA3joLyhTJ0PQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CS1G+i3PevSLGtcgKamBwVFbNvtqIdG3GIgnTJHndoS8LPCbq6c2DIvJDEAMuF25m
         4sHGtGXOziYvVBe5NcxrfvQejVAJUr5NiF7Ycc3WQYHQtl4eBkCb7mwFNeBIma+Uig
         L9uq5NXCUP/FMkq6S5ZZgf+PBRZP8l12lnduC67I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 43/80] drm/amdgpu: update smu_v11_0_pptable.h
Date:   Tue, 18 Feb 2020 20:55:04 +0100
Message-Id: <20200218190436.481284122@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit c1d66bc2e531b4ed3a9464b8e87144cc6b2fd63f upstream.

Update to the latest changes.

Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.5.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/inc/smu_v11_0_pptable.h |   46 ++++++++++++------
 1 file changed, 32 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/inc/smu_v11_0_pptable.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/smu_v11_0_pptable.h
@@ -39,21 +39,39 @@
 #define SMU_11_0_PP_OVERDRIVE_VERSION                   0x0800
 #define SMU_11_0_PP_POWERSAVINGCLOCK_VERSION            0x0100
 
+enum SMU_11_0_ODFEATURE_CAP {
+    SMU_11_0_ODCAP_GFXCLK_LIMITS = 0,
+    SMU_11_0_ODCAP_GFXCLK_CURVE,
+    SMU_11_0_ODCAP_UCLK_MAX,
+    SMU_11_0_ODCAP_POWER_LIMIT,
+    SMU_11_0_ODCAP_FAN_ACOUSTIC_LIMIT,
+    SMU_11_0_ODCAP_FAN_SPEED_MIN,
+    SMU_11_0_ODCAP_TEMPERATURE_FAN,
+    SMU_11_0_ODCAP_TEMPERATURE_SYSTEM,
+    SMU_11_0_ODCAP_MEMORY_TIMING_TUNE,
+    SMU_11_0_ODCAP_FAN_ZERO_RPM_CONTROL,
+    SMU_11_0_ODCAP_AUTO_UV_ENGINE,
+    SMU_11_0_ODCAP_AUTO_OC_ENGINE,
+    SMU_11_0_ODCAP_AUTO_OC_MEMORY,
+    SMU_11_0_ODCAP_FAN_CURVE,
+    SMU_11_0_ODCAP_COUNT,
+};
+
 enum SMU_11_0_ODFEATURE_ID {
-    SMU_11_0_ODFEATURE_GFXCLK_LIMITS        = 1 << 0,         //GFXCLK Limit feature
-    SMU_11_0_ODFEATURE_GFXCLK_CURVE         = 1 << 1,         //GFXCLK Curve feature
-    SMU_11_0_ODFEATURE_UCLK_MAX             = 1 << 2,         //UCLK Limit feature
-    SMU_11_0_ODFEATURE_POWER_LIMIT          = 1 << 3,         //Power Limit feature
-    SMU_11_0_ODFEATURE_FAN_ACOUSTIC_LIMIT   = 1 << 4,         //Fan Acoustic RPM feature
-    SMU_11_0_ODFEATURE_FAN_SPEED_MIN        = 1 << 5,         //Minimum Fan Speed feature
-    SMU_11_0_ODFEATURE_TEMPERATURE_FAN      = 1 << 6,         //Fan Target Temperature Limit feature
-    SMU_11_0_ODFEATURE_TEMPERATURE_SYSTEM   = 1 << 7,         //Operating Temperature Limit feature
-    SMU_11_0_ODFEATURE_MEMORY_TIMING_TUNE   = 1 << 8,         //AC Timing Tuning feature
-    SMU_11_0_ODFEATURE_FAN_ZERO_RPM_CONTROL = 1 << 9,         //Zero RPM feature
-    SMU_11_0_ODFEATURE_AUTO_UV_ENGINE       = 1 << 10,        //Auto Under Volt GFXCLK feature
-    SMU_11_0_ODFEATURE_AUTO_OC_ENGINE       = 1 << 11,        //Auto Over Clock GFXCLK feature
-    SMU_11_0_ODFEATURE_AUTO_OC_MEMORY       = 1 << 12,        //Auto Over Clock MCLK feature
-    SMU_11_0_ODFEATURE_FAN_CURVE            = 1 << 13,        //VICTOR TODO
+    SMU_11_0_ODFEATURE_GFXCLK_LIMITS        = 1 << SMU_11_0_ODCAP_GFXCLK_LIMITS,            //GFXCLK Limit feature
+    SMU_11_0_ODFEATURE_GFXCLK_CURVE         = 1 << SMU_11_0_ODCAP_GFXCLK_CURVE,             //GFXCLK Curve feature
+    SMU_11_0_ODFEATURE_UCLK_MAX             = 1 << SMU_11_0_ODCAP_UCLK_MAX,                 //UCLK Limit feature
+    SMU_11_0_ODFEATURE_POWER_LIMIT          = 1 << SMU_11_0_ODCAP_POWER_LIMIT,              //Power Limit feature
+    SMU_11_0_ODFEATURE_FAN_ACOUSTIC_LIMIT   = 1 << SMU_11_0_ODCAP_FAN_ACOUSTIC_LIMIT,       //Fan Acoustic RPM feature
+    SMU_11_0_ODFEATURE_FAN_SPEED_MIN        = 1 << SMU_11_0_ODCAP_FAN_SPEED_MIN,            //Minimum Fan Speed feature
+    SMU_11_0_ODFEATURE_TEMPERATURE_FAN      = 1 << SMU_11_0_ODCAP_TEMPERATURE_FAN,          //Fan Target Temperature Limit feature
+    SMU_11_0_ODFEATURE_TEMPERATURE_SYSTEM   = 1 << SMU_11_0_ODCAP_TEMPERATURE_SYSTEM,       //Operating Temperature Limit feature
+    SMU_11_0_ODFEATURE_MEMORY_TIMING_TUNE   = 1 << SMU_11_0_ODCAP_MEMORY_TIMING_TUNE,       //AC Timing Tuning feature
+    SMU_11_0_ODFEATURE_FAN_ZERO_RPM_CONTROL = 1 << SMU_11_0_ODCAP_FAN_ZERO_RPM_CONTROL,     //Zero RPM feature
+    SMU_11_0_ODFEATURE_AUTO_UV_ENGINE       = 1 << SMU_11_0_ODCAP_AUTO_UV_ENGINE,           //Auto Under Volt GFXCLK feature
+    SMU_11_0_ODFEATURE_AUTO_OC_ENGINE       = 1 << SMU_11_0_ODCAP_AUTO_OC_ENGINE,           //Auto Over Clock GFXCLK feature
+    SMU_11_0_ODFEATURE_AUTO_OC_MEMORY       = 1 << SMU_11_0_ODCAP_AUTO_OC_MEMORY,           //Auto Over Clock MCLK feature
+    SMU_11_0_ODFEATURE_FAN_CURVE            = 1 << SMU_11_0_ODCAP_FAN_CURVE,                //Fan Curve feature
     SMU_11_0_ODFEATURE_COUNT                = 14,
 };
 #define SMU_11_0_MAX_ODFEATURE    32          //Maximum Number of OD Features


