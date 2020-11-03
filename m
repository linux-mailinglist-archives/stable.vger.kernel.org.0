Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A6C2A4A59
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgKCPvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:51:15 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39321 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726690AbgKCPvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:51:14 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8A48B7BA;
        Tue,  3 Nov 2020 10:51:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:51:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TQfKq5
        MK4VAnYmbzOfSrLibvZFHSeFPD4nSCPrOWKQQ=; b=kAkG28Xur2VYJrAag4RX8v
        AjfYhIXNG269SKN7AGIaML5uspJlkez50pjARUI2U5djwiVdXyG8mlK5ClAfVaSI
        8ZmEzpquddxRzQjHPWQFxRxV2KY88DjFgX8CeKNCAroXgmL38TD3gKoirbt6U9nd
        wty71l1Lg4vmU8u976NsCxJOLxJciW4BfxiBPc3dWBYq4j1KZFi34cH2OYxnPnY6
        RTx/69vxAQI6cU2u6SFExF4lw4JCIFEku420va1e0XSZgk8f7nWF4zdcaVTFCCxf
        dp5yN+GEF0w92dAZVLat6n/joBQmI95KDQz3CS0ISAv5+12+ZFubdR5UHFiPeszA
        ==
X-ME-Sender: <xms:cHyhXxxRnAwEwBRYH12mrbgUETj9XW7qnzWuorxt891-u49iSgPTOw>
    <xme:cHyhXxTNMyWBNth85VS4uvF91mcfw2XlRpGmHuMWrpwBXoVuoZasOJ-QhRCirhnCZ
    syhP3TwOoWF7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:cHyhX7WhHr81g-zS8lDDOq8N56Sb5WY75LR_Xqoe91cTr4_qbybAVw>
    <xmx:cHyhXzjkEjPkCi5lOQtaxB8fBkFs309n5ZgQux5GyrmWXmqJNRNC3w>
    <xmx:cHyhXzBA-ef5GZI9vahxMQNxCgzDmcChVCspf5_OW4iR6WOUqTtlJw>
    <xmx:cXyhX2pg2JsewlQ6rLCH_0Jz8LSBmX4MLZ_2hWkFc8nAq2BWXUfvqY8mbog>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83AAE3064688;
        Tue,  3 Nov 2020 10:51:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/psp: Fix sysfs: cannot create duplicate filename" failed to apply to 5.9-stable tree
To:     andrey.grodzovsky@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:51:34 +0100
Message-ID: <1604418694231208@kroah.com>
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

From f1bcddffe46b349a82445a8d9efd5f5fcb72557f Mon Sep 17 00:00:00 2001
From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Date: Fri, 16 Oct 2020 10:50:44 -0400
Subject: [PATCH] drm/amd/psp: Fix sysfs: cannot create duplicate filename

psp sysfs not cleaned up on driver unload for sienna_cichlid

Fixes: ce87c98db428e7 ("drm/amdgpu: Include sienna_cichlid in USBC PD FW support.")
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index a9cae6d943c4..96a9699f87ba 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -208,7 +208,8 @@ static int psp_sw_fini(void *handle)
 		adev->psp.ta_fw = NULL;
 	}
 
-	if (adev->asic_type == CHIP_NAVI10)
+	if (adev->asic_type == CHIP_NAVI10 ||
+	    adev->asic_type == CHIP_SIENNA_CICHLID)
 		psp_sysfs_fini(adev);
 
 	return 0;

