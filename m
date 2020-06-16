Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404F31FAEA1
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgFPKwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:52:35 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:53241 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728435AbgFPKwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 06:52:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id ECCC119404E0;
        Tue, 16 Jun 2020 06:52:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 16 Jun 2020 06:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GSsSHq
        yEtZc3VaUzKAuc/t39hQsnb5Ko8QC1zL0PJ9M=; b=SxHK5jDWdkFaSZOXCr2gMZ
        GnDrunpnqDZAULQ9MXXCwf2Yp9Qh01HBiygmVE50Om/IvuvMYj98oVtIpWkNwHYD
        rY3rKY+BylqO66mnv1i6xBUsgeNQntBvv/S61dSPFUbc7ZOKRRf9gBkCwKFpPLZJ
        LFR3gpzpgvsc4grY3Wqy5snIkfHwq34eInBmG1xeaijpsBk4uQV3VU+dNn+Fv0ay
        gcc8YYKixk5oNmDgsTbIPKdM6oTh3aX4SoYHahcmGAoB9dKR6kNzhpXmND4j7VEw
        qMz8c0vJXqRZcKifB6AXU4DrPxuDjgLrobVhfZR3bmUISd2A8oc/c4hHWhrc6nGA
        ==
X-ME-Sender: <xms:cKToXl2hehk2nVsIxDBUPL1JgMPAPasBi8GL-xI0k7qeYI0igH7Ruw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejtddgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:cKToXsFe4rXgKdX4fdd6Yw-2vRbD_UXVdirNzZ7G8I6X2D9hXdFUqQ>
    <xmx:cKToXl4W0IGWU8jAN3X9iORpAeABxglB_lg5E7QE75ToLC0INUDxlA>
    <xmx:cKToXi1mPaFCkAxVe528oivsOQawD3yHmJTrfAEKFFzKmqWcZ382vQ>
    <xmx:cKToXkgXkzfQIL5tPMPjBijf4DBp85RTb8FZV_3PYVF-GgQpwR28jQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB7F13280067;
        Tue, 16 Jun 2020 06:52:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Revert "drm/amd/display: disable dcn20 abm feature for bring" failed to apply to 5.6-stable tree
To:     harry.wentland@amd.com, Anthony.Koo@amd.com, Michael.Chiu@amd.com,
        alexander.deucher@amd.com, amonakov@ispras.ru, hersenxs.wu@amd.com,
        nicholas.kazlauskas@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 16 Jun 2020 12:52:25 +0200
Message-ID: <1592304745222105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 14ed1c908a7a623cc0cbf0203f8201d1b7d31d16 Mon Sep 17 00:00:00 2001
From: Harry Wentland <harry.wentland@amd.com>
Date: Thu, 28 May 2020 09:44:44 -0400
Subject: [PATCH] Revert "drm/amd/display: disable dcn20 abm feature for bring
 up"

This reverts commit 96cb7cf13d8530099c256c053648ad576588c387.

This change was used for DCN2 bringup and is no longer desired.
In fact it breaks backlight on DCN2 systems.

Cc: Alexander Monakov <amonakov@ispras.ru>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Anthony Koo <Anthony.Koo@amd.com>
Cc: Michael Chiu <Michael.Chiu@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reported-and-tested-by: Alexander Monakov <amonakov@ispras.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d53c60b37cc6..f42e7e67ddba 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1356,7 +1356,7 @@ static int dm_late_init(void *handle)
 	unsigned int linear_lut[16];
 	int i;
 	struct dmcu *dmcu = NULL;
-	bool ret = false;
+	bool ret;
 
 	if (!adev->dm.fw_dmcu)
 		return detect_mst_link_for_all_connectors(adev->ddev);
@@ -1377,13 +1377,10 @@ static int dm_late_init(void *handle)
 	 */
 	params.min_abm_backlight = 0x28F;
 
-	/* todo will enable for navi10 */
-	if (adev->asic_type <= CHIP_RAVEN) {
-		ret = dmcu_load_iram(dmcu, params);
+	ret = dmcu_load_iram(dmcu, params);
 
-		if (!ret)
-			return -EINVAL;
-	}
+	if (!ret)
+		return -EINVAL;
 
 	return detect_mst_link_for_all_connectors(adev->ddev);
 }

