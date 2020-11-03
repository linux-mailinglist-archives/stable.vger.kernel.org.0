Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48ABC2A4A4E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgKCPra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:47:30 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:40523 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgKCPra (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:47:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 00BDF1941A46;
        Tue,  3 Nov 2020 10:47:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:47:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oGytRm
        rOlTbr5ft1KGw0vSrmZvk9ZX11Py5/7UJDqn0=; b=VBHqhRPtSNGaA+G3sQHDEn
        BcVk7itsVQBsErzae+BJiDwwShQppGpxOccuwhzMqY9McZ6lW8DT8Jv/4GtOooyE
        m4EH7CBrbnBq2LGJ6FVsBoOsEC2/W181sENnNa2K86yKlsSioNGdVBDzyM8vygJM
        mJoXwz5fZ50inLrZNuIKliaGQbsfzLBv9CkhH/jUgnKuRvh6l08oFGDxtb46+qq1
        4ss4BcH/qwgH2zfTW62pXFfOgVoq07H9TLHhHRfLX3BsIkaAFRY29azY0wS53he9
        tVTsskQ1toBS8kpR9reJfdtgenUE87B4P/TqRanPt34MQpG+DqK4kmsG1cMGyo9Q
        ==
X-ME-Sender: <xms:kHuhX3agtVYIrca7zoIcTCNZzLaWjcuYvvaBoQ0y3_z_wWmj3EDh8A>
    <xme:kHuhX2ZyPaJbGeApNtLw0f387WhveOeS9yxZ16-Df4Bx4DDQavV-Z0P7L36kz0hov
    1Nogj2OakY_OA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:kHuhX5-xWSrQEVemmtTxMPwC3a682g0G3ZGZYAXm39Hjj0nTGEOh-w>
    <xmx:kHuhX9rmPIM2ItM2yVACeD7KeeTSlDN7g4vcryacSTo_3TjP4aAvnQ>
    <xmx:kHuhXyrrkbHlacGNLWpPg5b8bGiVS4YOY2GI7aVbTwC75__Arhqb6w>
    <xmx:kHuhX51zu1QNnn9vzbLotXDAFq-O8FRXvnPyDlEnPgQ9qxFl4VBKKQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 921463064685;
        Tue,  3 Nov 2020 10:47:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/pm: fix pcie information for sienna cichlid" failed to apply to 5.9-stable tree
To:     Likun.Gao@amd.com, Hawking.Zhang@amd.com,
        alexander.deucher@amd.com, kenneth.feng@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:48:22 +0100
Message-ID: <16044185026144@kroah.com>
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

From 9a2f408f5406df567a3515f4cb5c2ce1bde64501 Mon Sep 17 00:00:00 2001
From: Likun Gao <Likun.Gao@amd.com>
Date: Tue, 20 Oct 2020 16:29:30 +0800
Subject: [PATCH] drm/amd/pm: fix pcie information for sienna cichlid

Fix the function used for sienna cichlid to get correct PCIE information
by pp_dpm_pcie.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index ca2abb2e5340..d708b383f83b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -962,8 +962,8 @@ static int sienna_cichlid_print_clk_levels(struct smu_context *smu,
 		}
 		break;
 	case SMU_PCIE:
-		gen_speed = smu_v11_0_get_current_pcie_link_speed(smu);
-		lane_width = smu_v11_0_get_current_pcie_link_width(smu);
+		gen_speed = smu_v11_0_get_current_pcie_link_speed_level(smu);
+		lane_width = smu_v11_0_get_current_pcie_link_width_level(smu);
 		for (i = 0; i < NUM_LINK_LEVELS; i++)
 			size += sprintf(buf + size, "%d: %s %s %dMhz %s\n", i,
 					(dpm_context->dpm_tables.pcie_table.pcie_gen[i] == 0) ? "2.5GT/s," :

