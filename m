Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBC93CA902
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241899AbhGOTFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239159AbhGOTCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:02:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF806613DD;
        Thu, 15 Jul 2021 18:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375541;
        bh=yQK+7EMPW+anCuBOtmGBLrgSUk/BCsTb+VKx6gKoMiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnxD3/8aQIGE834AehmNd0JM37HS2KsCyO3akBiSpdiabW/aBmlKyF+X2MlIZrcPZ
         2b5d1HWBInBO6+2E5x8QESBvTH/uFTLL52oXmj+7eEmrMd0CEmPaf1CXu8Q/1k02IT
         EDD2uUosdStqrDIJm94aEGMJTwCu3ecHJHYJx9D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logush Oliver <ollogush@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 114/242] drm/amd/display: Fix edp_bootup_bl_level initialization issue
Date:   Thu, 15 Jul 2021 20:37:56 +0200
Message-Id: <20210715182613.192400413@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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
index 9f9fda3118d1..500bcd0ecf4d 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -1944,7 +1944,7 @@ static enum bp_result get_integrated_info_v2_1(
 		info_v2_1->edp1_info.edp_pwr_down_bloff_to_vary_bloff;
 	info->edp1_info.edp_panel_bpc =
 		info_v2_1->edp1_info.edp_panel_bpc;
-	info->edp1_info.edp_bootup_bl_level =
+	info->edp1_info.edp_bootup_bl_level = info_v2_1->edp1_info.edp_bootup_bl_level;
 
 	info->edp2_info.edp_backlight_pwm_hz =
 	le16_to_cpu(info_v2_1->edp2_info.edp_backlight_pwm_hz);
-- 
2.30.2



