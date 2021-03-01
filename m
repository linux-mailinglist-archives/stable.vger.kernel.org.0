Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52350327B88
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhCAKGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:06:41 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:39387 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231229AbhCAKGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:06:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9F1FC1940E42;
        Mon,  1 Mar 2021 05:05:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:05:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=T32hAT
        ttTOqXNRwpTgHFnwYCR3INeeWjU5nOeb1X1wQ=; b=HUPhmlLozTQaSFHwPqhsGa
        wu2CCaQC+UjPNGv2FLIHn7Vm6rVLc+H0yojvqTMzinyxbE/x3necyd8K6MKRPEKm
        EdN5VQz35TgnlhnOLJXlHJHjRSeR9xwBs5cRwRyjq33tio3E23cxiFM97s+DCz5k
        coZy2VPGZ2usptPPsUz5B4b9gqXHjAEUSD5l8xBBizbMWypfgLETPk711uq23aLo
        MBMWC0UpsehgygtcxAbLw7SzRHdGBFyXJufBvFkaSF3PjmwRUqcY8EXR9P40x6Yj
        aRCa3w9Bwio/kYDgRJhYfExbhomzXpOgG1bJ5BhzmCxnZsQAL3G4NLeQtwZDw5Eg
        ==
X-ME-Sender: <xms:XLw8YK6AAqPKyFO_1PZM4cPqhAYCUFBaCJTWIas1G-RQNZ-HF9nZzQ>
    <xme:XLw8YD46C3TyoGrHHg7ESCq9MarSdKhdXF3D9ajLtA3_V4BByciDO_hoohxnNFXEo
    B74K1Aplk_ICg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:XLw8YJfYo-vqzmDVNtg3R56iDeZn10ebSlxufCTmkxGIt7dC7cp7dA>
    <xmx:XLw8YHJOcmts4l_C5vPsqIhWRrqnibclfEd1XxMwM1YKyNJsjpZqPA>
    <xmx:XLw8YOKWgdvJEj9yHs6_q5V_m6z3G4qq_RfdmotNZbHOr0Hq45vnDg>
    <xmx:XLw8YAj2RRjk1a-LJyiBdWTqQgJE6WiglRkMSFpgDJqXBK5gTngmvg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 30E9C1080059;
        Mon,  1 Mar 2021 05:05:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu: add new device id for Renior" failed to apply to 5.11-stable tree
To:     mengbing.wang@amd.com, alexander.deucher@amd.com, ray.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:05:08 +0100
Message-ID: <1614593108203188@kroah.com>
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

From 278cdb6834901658a81a1e22f5799aa15dca5029 Mon Sep 17 00:00:00 2001
From: mengwang <mengbing.wang@amd.com>
Date: Wed, 12 Aug 2020 11:49:29 +0800
Subject: [PATCH] drm/amdgpu: add new device id for Renior

add DID 0x164C into pciidlist under CHIP_RENOIR family.

Signed-off-by: mengwang <mengbing.wang@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 6a402d8b5573..3f0f3ce2611c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1086,6 +1086,7 @@ static const struct pci_device_id pciidlist[] = {
 	/* Renoir */
 	{0x1002, 0x1636, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 	{0x1002, 0x1638, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
+	{0x1002, 0x164C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 
 	/* Navi12 */
 	{0x1002, 0x7360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI12},
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 9a25accd48a3..2396be16c28e 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1204,7 +1204,8 @@ static int soc15_common_early_init(void *handle)
 		break;
 	case CHIP_RENOIR:
 		adev->asic_funcs = &soc15_asic_funcs;
-		if (adev->pdev->device == 0x1636)
+		if ((adev->pdev->device == 0x1636) ||
+		    (adev->pdev->device == 0x164c))
 			adev->apu_flags |= AMD_APU_IS_RENOIR;
 		else
 			adev->apu_flags |= AMD_APU_IS_GREEN_SARDINE;

