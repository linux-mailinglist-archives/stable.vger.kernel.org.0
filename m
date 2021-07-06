Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0DF3BCD93
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhGFLWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233360AbhGFLUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7659D61CC9;
        Tue,  6 Jul 2021 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570248;
        bh=mXwlMuW0g/A827FHrU+Qjyu7yJ5jVBo9vfc3hkHvuwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKY944oMR4W6nM5tAM1ZWsNwiLWYkmsNt5EAd74VcxJfQZ44YTlVp8rKhRazcxnd2
         tkCI8bILRTOOnlIEmMdW3b4sS1zNSnGuz5UmZ2jTNaJrzIUZyDX9bRm8dK7TiwkOdp
         l7CQ7oKCn1hq4/OhQ82kVJcGULIruv4NZ3ByuoA5FNYDH42T+QV0hGImqAW+XnhD1H
         GzVoBjVJWh4pqXxSvA+UepIq+RLaOgcAHq4O3w37Ebf4QEhDsCmWkiOsF/uMEblWF0
         Qa1yvq4maDbNkjO2mi0cMumoMjnegowg4eAQq/3qqIrIWgWiOPFRxd9ODS+BWtwBJS
         xjNIjXuduOghw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logush Oliver <ollogush@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Bindu Ramamurthy <bindu.r@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 147/189] drm/amd/display: Fix edp_bootup_bl_level initialization issue
Date:   Tue,  6 Jul 2021 07:13:27 -0400
Message-Id: <20210706111409.2058071-147-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

