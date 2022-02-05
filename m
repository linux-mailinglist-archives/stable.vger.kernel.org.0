Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4244AA8FC
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 14:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346507AbiBENGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 08:06:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50046 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiBENGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 08:06:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F7E360EB7
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 13:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB86C340E8;
        Sat,  5 Feb 2022 13:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644066398;
        bh=dYIbzRXwZ7b07TMblJ/ioI4S5XnJNRU4KqJABWmff0s=;
        h=Subject:To:Cc:From:Date:From;
        b=IVCgUndewrb2t85Epls/JtY2xTjljrSIEdC+qAcHzW4/8KINqslJMBHVHDpXK3g0d
         gmgT89JFZ3w7JhD4ep87AoO3XaYWfCI51knDYOZzDUwANGBQbJEyQZfMLNGZCwVvAh
         UwZtyk62gmP+wV60uC5UATlw2XrSUl11rFrooIWo=
Subject: FAILED: patch "[PATCH] drm/amd/display: Update watermark values for DCN301" failed to apply to 5.10-stable tree
To:     agustin.gutierrez@amd.com, alexander.deucher@amd.com,
        zhan.liu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Feb 2022 14:06:35 +0100
Message-ID: <16440663957466@kroah.com>
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

From 2d8ae25d233767171942a9fba5fd8f4a620996be Mon Sep 17 00:00:00 2001
From: Agustin Gutierrez <agustin.gutierrez@amd.com>
Date: Fri, 28 Jan 2022 17:51:53 -0500
Subject: [PATCH] drm/amd/display: Update watermark values for DCN301

[Why]
There is underflow / visual corruption DCN301, for high
bandwidth MST DSC configurations such as 2x1440p144 or 2x4k60.

[How]
Use up-to-date watermark values for DCN301.

Reviewed-by: Zhan Liu <zhan.liu@amd.com>
Signed-off-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
index 48005def1164..bc4ddc36fe58 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
@@ -570,32 +570,32 @@ static struct wm_table lpddr5_wm_table = {
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 7.95,
-			.sr_enter_plus_exit_time_us = 9,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.82,
-			.sr_enter_plus_exit_time_us = 11.196,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.89,
-			.sr_enter_plus_exit_time_us = 11.24,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.748,
-			.sr_enter_plus_exit_time_us = 11.102,
+			.sr_exit_time_us = 13.5,
+			.sr_enter_plus_exit_time_us = 16.5,
 			.valid = true,
 		},
 	}

