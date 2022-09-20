Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302475BEB34
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 18:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiITQjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 12:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiITQjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 12:39:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0392DEA1
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 09:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 222FFB82A83
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 16:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8410BC433C1;
        Tue, 20 Sep 2022 16:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663691974;
        bh=yTuq8Ne4cLBXoCPG/lB8cOJ/0G7rO9c/wkr0NeWdq78=;
        h=Subject:To:Cc:From:Date:From;
        b=SCtp+KBra5a6W3QELfa8iwcRVl0QqTq7GcExbJvOkMDlijAuXgVPu6A16fGyOcGP+
         mf/4dHfFP5LklmUFJIGaM4z/E+oJI06mw/ILIbWYZlh42n34iA0DZqXHrSD/MynjD/
         7XQGWaghGpmwXFWbpnH8IvALdJBhJwaepn4XUK/I=
Subject: FAILED: patch "[PATCH] drm/amdgpu: Don't enable LTR if not supported" failed to apply to 5.10-stable tree
To:     lijo.lazar@amd.com, alexander.deucher@amd.com, wielkiegie@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 20 Sep 2022 18:39:32 +0200
Message-ID: <166369197214753@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6c2049066355 ("drm/amdgpu: Don't enable LTR if not supported")
2e54fe5d056e ("drm/amdgpu: Modify nbio block to fit for the unified ras block data and ops")
cace4bff750f ("drm/amdgpu: check df_funcs and its callback pointers")
8ab0d6f030ba ("drm/amdgpu: Rename to ras_*_enabled")
e509965e58ab ("drm/amdgpu: Move up ras_hw_supported")
acdae2169bae ("drm/amdgpu: Remove redundant ras->supported")
f50160cf0f98 ("drm/amdgpu: force enable gfx ras for vega20 ws")
1f6e8eb15311 ("drm/amdgpu: enable gfx ras in aldebran by default")
78871b6c8be3 ("drm/amdgpu: enable ras error count query and reset for HDP")
502f0e28042b ("drm/amdgpu: disable gfx ras by default in aldebaran")
19d0dfda4c75 ("drm/amdgpu: optimize gfx ras features flag clean")
9d015c0dae05 ("drm/amd/amdgpu: enable ASPM on vega")
6e36f23193cc ("drm/amdgpu: split nbio callbacks into ras and non-ras ones")
75f06251c921 ("drm/amdgpu: initialze ras caps per paltform config")
4a7ffbdb27d5 ("drm/amd/amdgpu: set MP1 state to UNLOAD before reload its FW for vega20/ALDEBARAN")
084e2640e516 ("drm/amdgpu: Fix check for RAS support")
1689fca0d62a ("drm/amd/pm: fix Navi1x runtime resume failure V2")
63f3067d8f8c ("drm/amd/pm: Use BACO reset arg 0 on XGMI configuration")
970fd1976434 ("drm/amdgpu: fix send ras disable cmd when asic not support ras")
b69d5c7e9502 ("drm/amdgpu: support query ecc cap for SIENNA_CICHLID")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6c20490663553cd7e07d8de8af482012329ab9d6 Mon Sep 17 00:00:00 2001
From: Lijo Lazar <lijo.lazar@amd.com>
Date: Thu, 8 Sep 2022 08:28:57 +0530
Subject: [PATCH] drm/amdgpu: Don't enable LTR if not supported

As per PCIE Base Spec r4.0 Section 6.18
'Software must not enable LTR in an Endpoint unless the Root Complex
and all intermediate Switches indicate support for LTR.'

This fixes the Unsupported Request error reported through AER during
ASPM enablement.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216455

The error was unnoticed before and got visible because of the commit
referenced below. This doesn't fix anything in the commit below, rather
fixes the issue in amdgpu exposed by the commit. The reference is only
to associate this commit with below one so that both go together.

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")

Reported-by: Gustaw Smolarczyk <wielkiegie@gmail.com>
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

Cc: stable@vger.kernel.org
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
index b465baa26762..aa761ff3a5fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -380,6 +380,7 @@ static void nbio_v2_3_enable_aspm(struct amdgpu_device *adev,
 		WREG32_PCIE(smnPCIE_LC_CNTL, data);
 }
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -401,9 +402,11 @@ static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -459,7 +462,10 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v2_3_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v2_3_program_ltr(adev);
 
 	def = data = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -483,6 +489,7 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 static void nbio_v2_3_apply_lc_spc_mode_wa(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
index f7f6ddebd3e4..37615a77287b 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
@@ -282,6 +282,7 @@ static void nbio_v6_1_init_registers(struct amdgpu_device *adev)
 			mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -303,9 +304,11 @@ static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -361,7 +364,10 @@ static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v6_1_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v6_1_program_ltr(adev);
 
 	def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -385,6 +391,7 @@ static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 const struct amdgpu_nbio_funcs nbio_v6_1_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
index 11848d1e238b..19455a725939 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -673,6 +673,7 @@ struct amdgpu_nbio_ras nbio_v7_4_ras = {
 };
 
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -694,9 +695,11 @@ static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	if (adev->ip_versions[NBIO_HWIP][0] == IP_VERSION(7, 4, 4))
@@ -755,7 +758,10 @@ static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v7_4_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v7_4_program_ltr(adev);
 
 	def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -779,6 +785,7 @@ static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 const struct amdgpu_nbio_funcs nbio_v7_4_funcs = {

