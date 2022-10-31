Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476F6613047
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJaGag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJaGaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:30:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F2E7646
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B09460FD8
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AE1C433D6;
        Mon, 31 Oct 2022 06:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667197833;
        bh=R8FXZQUNiy+HH4EiOjzghY5qu+RXHvZCErhPsbN160Q=;
        h=Subject:To:Cc:From:Date:From;
        b=w+a0l2vnEpiTgZAwtP7zL/nOg6KXi35i2UOMNZoCC9elCTnoOWLgjD+1p7Fk3zajN
         gsWzrOPxli7r0Jey8IIVjBNgjeO3jexXAg9Rb7CL/bp5qedLB3Bx1PgqXD+46mO/90
         b8v38b4++TV+Kf3HTlc8H2GVbaV6zgk5rs0mJdFA=
Subject: FAILED: patch "[PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x" failed to apply to 5.10-stable tree
To:     lijo.lazar@amd.com, alexander.deucher@amd.com, guchun.chen@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:31:21 +0100
Message-ID: <1667197881156209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d2c4c1569a7d ("drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x")
1d789535a036 ("drm/amdgpu: convert IP version array to include instances")
5c3720be7d46 ("drm/amdgpu: get VCN and SDMA instances from IP discovery table")
2cbc6f4259f6 ("drm/amd/display: fix error case handling")
75a07bcd1d30 ("drm/amdgpu/soc15: convert to IP version checking")
0b64a5a85229 ("drm/amdgpu/vcn2.5: convert to IP version checking")
96b8dd4423e7 ("drm/amdgpu/amdgpu_vcn: convert to IP version checking")
50638f7dbd0b ("drm/amdgpu/pm/amdgpu_smu: convert more IP version checking")
61b396b91196 ("drm/amdgpu/pm/smu_v13.0: convert IP version checking")
6b726a0a52cc ("drm/amdgpu/pm/smu_v11.0: update IP version checking")
1fcc208cd780 ("drm/amdgpu/psp_v13.0: convert to IP version checking")
e47868ea15cb ("drm/amdgpu/psp_v11.0: convert to IP version checking")
82d05736c47b ("drm/amdgpu/amdgpu_psp: convert to IP version checking")
9d0cb2c31891 ("drm/amdgpu/gfx9.0: convert to IP version checking")
24be2d70048b ("drm/amdgpu/hdp4.0: convert to IP version checking")
43bf00f21eaf ("drm/amdgpu/sdma4.0: convert to IP version checking")
559f591dab57 ("drm/amdgpu/display/dm: convert RAVEN to IP version checking")
d4c6e870bdd2 ("drm/amdgpu: add initial IP discovery support for vega based parts")
c08182f2483f ("drm/amdgpu/display/dm: convert to IP version checking")
3e67f4f2e22e ("drm/amdgpu/nv: convert to IP version checking")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d2c4c1569a7d7d5c8f75963bf2d62d7aeac30e2a Mon Sep 17 00:00:00 2001
From: Lijo Lazar <lijo.lazar@amd.com>
Date: Fri, 30 Sep 2022 10:43:08 +0530
Subject: [PATCH] drm/amdgpu: Remove ATC L2 access for MMHUB 2.1.x

MMHUB 2.1.x versions don't have ATCL2. Remove accesses to ATCL2 registers.

Since they are non-existing registers, read access will cause a
'Completer Abort' and gets reported when AER is enabled with the below patch.
Tagging with the patch so that this is backported along with it.

v2: squash in uninitialized warning fix (Nathan Chancellor)

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
index 4d304f22889e..998b5d17b271 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -32,8 +32,6 @@
 #include "gc/gc_10_1_0_offset.h"
 #include "soc15_common.h"
 
-#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid                      0x064d
-#define mmMM_ATC_L2_MISC_CG_Sienna_Cichlid_BASE_IDX             0
 #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid                       0x0070
 #define mmDAGB0_CNTL_MISC2_Sienna_Cichlid_BASE_IDX              0
 
@@ -574,7 +572,6 @@ static void mmhub_v2_0_update_medium_grain_clock_gating(struct amdgpu_device *ad
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
 		def1 = data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
 		break;
 	default:
@@ -608,8 +605,6 @@ static void mmhub_v2_0_update_medium_grain_clock_gating(struct amdgpu_device *ad
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		if (def != data)
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
 		if (def1 != data1)
 			WREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid, data1);
 		break;
@@ -634,8 +629,8 @@ static void mmhub_v2_0_update_medium_grain_light_sleep(struct amdgpu_device *ade
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
-		break;
+		/* There is no ATCL2 in MMHUB for 2.1.x */
+		return;
 	default:
 		def  = data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG);
 		break;
@@ -646,18 +641,8 @@ static void mmhub_v2_0_update_medium_grain_light_sleep(struct amdgpu_device *ade
 	else
 		data &= ~MM_ATC_L2_MISC_CG__MEM_LS_ENABLE_MASK;
 
-	if (def != data) {
-		switch (adev->ip_versions[MMHUB_HWIP][0]) {
-		case IP_VERSION(2, 1, 0):
-		case IP_VERSION(2, 1, 1):
-		case IP_VERSION(2, 1, 2):
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid, data);
-			break;
-		default:
-			WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
-			break;
-		}
-	}
+	if (def != data)
+		WREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG, data);
 }
 
 static int mmhub_v2_0_set_clockgating(struct amdgpu_device *adev,
@@ -695,7 +680,10 @@ static void mmhub_v2_0_get_clockgating(struct amdgpu_device *adev, u64 *flags)
 	case IP_VERSION(2, 1, 0):
 	case IP_VERSION(2, 1, 1):
 	case IP_VERSION(2, 1, 2):
-		data  = RREG32_SOC15(MMHUB, 0, mmMM_ATC_L2_MISC_CG_Sienna_Cichlid);
+		/* There is no ATCL2 in MMHUB for 2.1.x. Keep the status
+		 * based on DAGB
+		 */
+		data = MM_ATC_L2_MISC_CG__ENABLE_MASK;
 		data1 = RREG32_SOC15(MMHUB, 0, mmDAGB0_CNTL_MISC2_Sienna_Cichlid);
 		break;
 	default:

