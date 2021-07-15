Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B954B3CAA83
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241835AbhGOTN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243399AbhGOTLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0DED613E7;
        Thu, 15 Jul 2021 19:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376122;
        bh=mXwlMuW0g/A827FHrU+Qjyu7yJ5jVBo9vfc3hkHvuwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftOw4fzojVulSE/ZD//bITwwXiH4OAHriQGkygD8gfA96fTWpN1IdOrU9z/WaYSlW
         vMLlI5DH2nUdcup458fF2A39SM0fK12Fo9+XMgnbb6WPsD/rjF2LNpUWcXtgEJ80yP
         dAXqTtr9exR0fH2fd9AvrZTCXmVEbI6OYcHjvxag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logush Oliver <ollogush@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 136/266] drm/amd/display: Fix edp_bootup_bl_level initialization issue
Date:   Thu, 15 Jul 2021 20:38:11 +0200
Message-Id: <20210715182637.789248039@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logush Oliver <ollogush@amd.com>

[ Upstream commit eeb90e26ed05dd44553d557057bf35f08f853af8 ]

[why]
Updating the file to fix the missing line

Signed-off-by: Logush Oliver <ollogush@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Bindu Ramamurthy <bindu.r@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index d79f4fe06c47..4812a72f8aad 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -2131,7 +2131,7 @@ static enum bp_result get_integrated_info_v2_1(
 		info_v2_1->edp1_info.edp_pwr_down_bloff_to_vary_bloff;
 	info->edp1_info.edp_panel_bpc =
 		info_v2_1->edp1_info.edp_panel_bpc;
-	info->edp1_info.edp_bootup_bl_level =
+	info->edp1_info.edp_bootup_bl_level = info_v2_1->edp1_info.edp_bootup_bl_level;
 
 	info->edp2_info.edp_backlight_pwm_hz =
 	le16_to_cpu(info_v2_1->edp2_info.edp_backlight_pwm_hz);
-- 
2.30.2



