Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F09B2A4A13
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgKCPmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:42:02 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41267 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727470AbgKCPmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:42:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 887F939C;
        Tue,  3 Nov 2020 10:42:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:42:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=I9mnw5
        W8pz/H2p+qZHgvhzJIme3PzKw5R/IoogFkaOg=; b=nVfofhymZz0h/prLmNDuLI
        4fU1hiL9NrGvM0RWq6rC/HSTE/sX8U88bwEnfQYtTYL9RtRM06ixrKvhQ8+nNPP9
        cyi3KUO/AQhcJ0vZ8VSZme815NUHqGzzcDi3R6k7nEBOsmNYz7uDSGXpCJPTbZIa
        D1GTRSrRwotLev8nvVL0UlF+tJzvfVynB2a0xXC9Od9qBOgUqhO6eSpqT3SY7zFo
        1+Qul/2ha8mc/YG4vAZKUQreunD2zzFmvz17iTSUEkuUkQxYmnm/CBRBoeSroMRw
        Fo0PqcadYAQX+Ls5/tyu0Odv6yhW7bEkQL4Ey8P4ZotDoB33on/jOSTN2N6vnbjg
        ==
X-ME-Sender: <xms:SHqhXwJGtcQ61petI8DwH1LVzhr3yt69GQv1aAItu5XDph2a-hoRmQ>
    <xme:SHqhXwK34iukeBguDeXcNmcVo2HXRchNLynSQ7K1PgtSB-YP6Gk95x3NVI5Hywrvw
    9sfbi1sNN0vOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:SXqhXwsQLMniUUgDS7owIMFntEoqd5_HMHc6kAkjMkBA4ceYtfVwqw>
    <xmx:SXqhX9YiNNftdPWUtpox2Qq-QUE_cP6FvCatFghir5KzSCXx_ufsMQ>
    <xmx:SXqhX3bdCmbB4LcLeJq7PkL0kaEQxbxT8Du__9BRvagLCCA6Kiuqsg>
    <xmx:SXqhX4ADiZshnd3saROTnCPSsOeKTWgaDLE7iFASufY7GVpXTCscFCw3KW8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 945673280064;
        Tue,  3 Nov 2020 10:42:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu/swsmu: drop smu i2c bus on navi1x" failed to apply to 5.9-stable tree
To:     alexander.deucher@amd.com, evan.quan@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:42:55 +0100
Message-ID: <1604418175226173@kroah.com>
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

From 10105d0c9763f058f6a9a09f78397d5bf94dc94c Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Mon, 26 Oct 2020 17:30:28 -0400
Subject: [PATCH] drm/amdgpu/swsmu: drop smu i2c bus on navi1x

Stop registering the SMU i2c bus on navi1x.  This leads to instability
issues when userspace processes mess with the bus and also seems to
cause display stability issues in some cases.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1314
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1341
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index 8d8081c6bd38..9cf97744b67e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2534,29 +2534,6 @@ static const struct i2c_algorithm navi10_i2c_algo = {
 	.functionality = navi10_i2c_func,
 };
 
-static int navi10_i2c_control_init(struct smu_context *smu, struct i2c_adapter *control)
-{
-	struct amdgpu_device *adev = to_amdgpu_device(control);
-	int res;
-
-	control->owner = THIS_MODULE;
-	control->class = I2C_CLASS_SPD;
-	control->dev.parent = &adev->pdev->dev;
-	control->algo = &navi10_i2c_algo;
-	snprintf(control->name, sizeof(control->name), "AMDGPU SMU");
-
-	res = i2c_add_adapter(control);
-	if (res)
-		DRM_ERROR("Failed to register hw i2c, err: %d\n", res);
-
-	return res;
-}
-
-static void navi10_i2c_control_fini(struct smu_context *smu, struct i2c_adapter *control)
-{
-	i2c_del_adapter(control);
-}
-
 static ssize_t navi10_get_gpu_metrics(struct smu_context *smu,
 				      void **table)
 {
@@ -2687,8 +2664,6 @@ static const struct pptable_funcs navi10_ppt_funcs = {
 	.set_default_dpm_table = navi10_set_default_dpm_table,
 	.dpm_set_vcn_enable = navi10_dpm_set_vcn_enable,
 	.dpm_set_jpeg_enable = navi10_dpm_set_jpeg_enable,
-	.i2c_init = navi10_i2c_control_init,
-	.i2c_fini = navi10_i2c_control_fini,
 	.print_clk_levels = navi10_print_clk_levels,
 	.force_clk_levels = navi10_force_clk_levels,
 	.populate_umd_state_clk = navi10_populate_umd_state_clk,

