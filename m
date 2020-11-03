Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0892A4A45
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKCPqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:46:40 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48933 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgKCPqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:46:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DC532D4A;
        Tue,  3 Nov 2020 10:46:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:46:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HrhoCQ
        XSSZoLLjIm690a9IUr/oZ1z/X2PDWwbUsvJKA=; b=FtVOvI2cofw+k4M8qoZOuc
        GZQ1TKwcGdHx7ieLDOn9pSGm+Wpuj0fvqv2DvCbSrPOTU9+22G7or0anDYLE1Jqg
        OodFdAWDUhglZtzFypG0MmpWxLYsE/7L5hxmI43FIfjz0cSPv5NHczn0AM+aJCyz
        8xIBzCEpeZPFZO9zQiQL8nxHQJVlf3be/uUnrIyU6dXrYRhSHj4K/wZIS8+XTn6a
        m8AuI5bUUP+SDrMhXP7DlofLAyAtEY9bK1+b8qNAMTugTyFYKYBmROoCmpgi9luI
        FZC463s+IbPKmBO/umEz9nNsEo4UuD11seLvI1+mxhR+P5IosjfKdvXibwCgIHbg
        ==
X-ME-Sender: <xms:XnuhX5Zbse5Aqv9oCT-bhaHZg62iTUYsrnGJUZCUA-vtydJ0Q495UQ>
    <xme:XnuhXwbfCsQXY4fPlpxYr7ySqARxlkb-PaVBvrgVnEInXU_anyL4czuloRwE4cma-
    Yi9BoDyWUfhbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:XnuhX7-x6AEeavOwW2BSeEy5Y3EOzzmGX3dJSr4tT1oKCMSz48w73A>
    <xmx:XnuhX3q0vKIE_m374EADFEvKmGUWxfSQabN1wZZtxBGFce4uzQjwpg>
    <xmx:XnuhX0o4Oj1uG9DbzpP_J6AkARr4OShEz872FiD3T7kHvXWaNeB3gg>
    <xmx:XnuhXxAVZCX0yd9_4v9QmfsWmbe3TREGtiFFTVKV_WqdIQF2A_J3V2YdUPs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 062F63064680;
        Tue,  3 Nov 2020 10:46:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/pm: fix pp_dpm_fclk" failed to apply to 5.9-stable tree
To:     kenneth.feng@amd.com, Likun.Gao@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:47:31 +0100
Message-ID: <1604418451173206@kroah.com>
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

From 392d256fa26d943fb0a019fea4be80382780d3b1 Mon Sep 17 00:00:00 2001
From: Kenneth Feng <kenneth.feng@amd.com>
Date: Wed, 21 Oct 2020 16:15:47 +0800
Subject: [PATCH] drm/amd/pm: fix pp_dpm_fclk

fclk value is missing in pp_dpm_fclk. add this to correctly show the current value.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index d708b383f83b..9ca3d93b1c95 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -455,6 +455,9 @@ static int sienna_cichlid_get_smu_metrics_data(struct smu_context *smu,
 	case METRICS_CURR_DCEFCLK:
 		*value = metrics->CurrClock[PPCLK_DCEFCLK];
 		break;
+	case METRICS_CURR_FCLK:
+		*value = metrics->CurrClock[PPCLK_FCLK];
+		break;
 	case METRICS_AVERAGE_GFXCLK:
 		if (metrics->AverageGfxActivity <= SMU_11_0_7_GFX_BUSY_THRESHOLD)
 			*value = metrics->AverageGfxclkFrequencyPostDs;

