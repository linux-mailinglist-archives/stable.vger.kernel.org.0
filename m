Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51B7327B87
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhCAKGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:06:37 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:41419 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231964AbhCAKGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:06:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C01F11940E75;
        Mon,  1 Mar 2021 05:05:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:05:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JHxZeV
        Kh3ki5jnGztE19ozlYlbvneFfC8f9LyYVwlus=; b=v6crKiQKPYYfp6k/MYq5XA
        tOkcMQiZ0SQhifV0O06aDZRPQtx1hECejKXz98JB2gA3t5F5bJxHHhoOSnlzfbAJ
        cy9W9AR1JEq//tW/Bak/x9KI35taejmzHFTpji93Wmzod/FqxNFGyzh77xocL3tO
        aVOsJMwbU9hEdtWvqy4lqNnbyosEhNN/ymXNQachnvdgq5s6Ksttl5A0LH+27yMm
        dUU89bbj316doXhvF4fr04fxKrXI7Zx3rOC2IUblrQg6Beiai3FWXV74CcBwwOpM
        AJrqb390SuYyE4adAueIyaLYEGGGtTlCzS5myqnbFjKLQqV90jzGLWGuDC9uyJXA
        ==
X-ME-Sender: <xms:V7w8YKKPB34k_ANp0JhN50Lzg8OKoVDXEm6e0R4ve87Pm-sP5moO-Q>
    <xme:V7w8YCLQkaHW0B-_3GKopqT9tEa34UF1ZIxwLB8v8pMFscCvYtI1v2I1VZy3hsDu-
    49ba53MiQNB9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:V7w8YKuCzB7f4kX97xTf04V0MCPdIcpvgGDI47PEczyGuEZk2E8JhA>
    <xmx:V7w8YPawAN-4vmVsEfBMb-zej8RE45OqxD1WepHvHeBocoBi5UG1UQ>
    <xmx:V7w8YBYhVEWBGs54oH0VqSGJf0J-x9GuSRvn8ETj_2pyEpxZEpIOGw>
    <xmx:V7w8YAyl5KXo_on3-kTwY07zUbVbJKPPpSO_lW66_wIJJfQCYea-YA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6691A1080054;
        Mon,  1 Mar 2021 05:05:11 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu: add new device id for Renior" failed to apply to 5.10-stable tree
To:     mengbing.wang@amd.com, alexander.deucher@amd.com, ray.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:05:07 +0100
Message-ID: <16145931075812@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

