Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1E844184A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbhKAJpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234073AbhKAJoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59725613AB;
        Mon,  1 Nov 2021 09:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758956;
        bh=RmgLSzd5z0bUGJsedzcOVjdV9/m3Yv1GbbKzfCaS6a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBlOZ1u9J3MUt2nrrnn3fCLpTz8nUzJ+d9UNK+7quITnZHPT+7gGofN0LK285XsVk
         cuIEdRxveA5l6TNlcPOm8OPrXFRqrAaCDwUG7vycoMidn3oiILvzkx/1qiBfu2cn9H
         9KnZ32QLTJzyxH2grdqGUb7jUGjeRHDLAl1EyZQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Othman <ahmad.othman@amd.com>,
        Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>,
        Nikola Cornij <nikola.cornij@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 053/125] drm/amd/display: Increase watermark latencies for DCN3.1
Date:   Mon,  1 Nov 2021 10:17:06 +0100
Message-Id: <20211101082543.204059478@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikola Cornij <nikola.cornij@amd.com>

commit dd8cb18906d97b2916fde42d32d915ae363c7e55 upstream.

[why]
The original latencies were causing underflow in some modes

[how]
Replace with the up-to-date watermark values based on new measurments

Reviewed-by: Ahmad Othman <ahmad.othman@amd.com>
Acked-by: Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>
Signed-off-by: Nikola Cornij <nikola.cornij@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c |   16 +++++------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
@@ -366,32 +366,32 @@ static struct wm_table lpddr5_wm_table =
 			.wm_inst = WM_A,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 5.32,
-			.sr_enter_plus_exit_time_us = 6.38,
+			.sr_exit_time_us = 11.5,
+			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.82,
-			.sr_enter_plus_exit_time_us = 11.196,
+			.sr_exit_time_us = 11.5,
+			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.89,
-			.sr_enter_plus_exit_time_us = 11.24,
+			.sr_exit_time_us = 11.5,
+			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.65333,
-			.sr_exit_time_us = 9.748,
-			.sr_enter_plus_exit_time_us = 11.102,
+			.sr_exit_time_us = 11.5,
+			.sr_enter_plus_exit_time_us = 14.5,
 			.valid = true,
 		},
 	}


