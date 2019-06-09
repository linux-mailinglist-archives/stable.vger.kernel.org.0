Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B2D3A4B1
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 12:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfFIKaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 06:30:30 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36307 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727853AbfFIKaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 06:30:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9B30021F48;
        Sun,  9 Jun 2019 06:30:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 06:30:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zf5p2E
        /y+IChb8QcepUs+8lrOH9MXHjKOAiGsnnBf4E=; b=nlUCUCDxQqbomkjb4eEVgS
        qc2RpoXWMobiiOKmeiU6InqobgNxPZH3RyeKHj0MHiYm9gqNU57TTiUp5NMW+3ny
        V7A/4kOJX00dCtEUkjW48XTul0KyNzB+gFQFTJM1EX10OZJPyTk0B+0xkiyp0hjy
        JskjU+qUknyCkZvjqk41haloiWsLC5a74NqYQJnrLpV5fS/fB24VgLn/n30PMSki
        AUZH14Sf4Z/3Oqi/tcqpuf7b8pBC/aAgLiO9XE9mA0RrD3yE9P/u4aeU6XmBiTKh
        T/1X/mLULahVJhSdkSpwqz3UOclEgevfd73+nP1KdPR9i5yFm/tftmExiQ0qF6eA
        ==
X-ME-Sender: <xms:xd_8XF9mFYC7EW3g2oSFLWWjSDiLNBqOxPcCQ21uK68ZhqL8bdPOfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:xd_8XFbATJGP3f14mN2RnhxImqWQ92FcnVVEKzHIkFJzu68HaRwWrA>
    <xmx:xd_8XNuBC1IZijNxbh9Q7c-bPCqxae7VOpSJZpXuAOeur_sFZeOWTg>
    <xmx:xd_8XKZTn7NBJe2K492JLkoRX-YMeM_nTyxSyzf2EQt9gxZcL3YoXA>
    <xmx:xd_8XIF_fOHrTEni_Pn-VtarIlp6d7FVOHU21zMoPDYmstIwNR2mFQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4CED8005C;
        Sun,  9 Jun 2019 06:30:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: Don't load DMCU for Raven 1 (v2)" failed to apply to 5.1-stable tree
To:     harry.wentland@amd.com, alexander.deucher@amd.com,
        nicholas.kazlauskas@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 12:30:26 +0200
Message-ID: <1560076226130132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c08e56c647ba8e4964ffc9e43360f16c9740337e Mon Sep 17 00:00:00 2001
From: Harry Wentland <harry.wentland@amd.com>
Date: Mon, 29 Apr 2019 09:39:15 -0400
Subject: [PATCH] drm/amd/display: Don't load DMCU for Raven 1 (v2)

[WHY]
Some early Raven boards had a bad SBIOS that doesn't play nicely with
the DMCU FW. We thought the issues were fixed by ignoring errors on DMCU
load but that doesn't seem to be the case. We've still seen reports of
users unable to boot their systems at all.

[HOW]
Disable DMCU load on Raven 1. Only load it for Raven 2 and Picasso.

v2: Fix ifdef (Alex)

Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 995f9df66142..bcb1a93c0b4c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -29,6 +29,7 @@
 #include "dm_services_types.h"
 #include "dc.h"
 #include "dc/inc/core_types.h"
+#include "dal_asic_id.h"
 
 #include "vid.h"
 #include "amdgpu.h"
@@ -640,7 +641,7 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 
 static int load_dmcu_fw(struct amdgpu_device *adev)
 {
-	const char *fw_name_dmcu;
+	const char *fw_name_dmcu = NULL;
 	int r;
 	const struct dmcu_firmware_header_v1_0 *hdr;
 
@@ -663,7 +664,14 @@ static int load_dmcu_fw(struct amdgpu_device *adev)
 	case CHIP_VEGA20:
 		return 0;
 	case CHIP_RAVEN:
-		fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
+#if defined(CONFIG_DRM_AMD_DC_DCN1_01)
+		if (ASICREV_IS_PICASSO(adev->external_rev_id))
+			fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
+		else if (ASICREV_IS_RAVEN2(adev->external_rev_id))
+			fw_name_dmcu = FIRMWARE_RAVEN_DMCU;
+		else
+#endif
+			return 0;
 		break;
 	default:
 		DRM_ERROR("Unsupported ASIC type: 0x%X\n", adev->asic_type);

