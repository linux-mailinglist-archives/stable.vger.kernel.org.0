Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F92127DF3
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfLTOaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:30:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727549AbfLTOaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 669A224680;
        Fri, 20 Dec 2019 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852210;
        bh=1+9B4pT/COanMs68Ai8xARKxLGeMVZb8EwEpf1LTB2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ese7gWie/Jim3KapJc0KZwVC1scZD04k50OiuRR2SD6Ymz+EcuingM1SbPZV5FuXc
         GcIP45NxI2YQgZVCUWcJdwD8ZwMQ2y9OQKEZDpfotVXyXRXkQi+faF/3mz47dwQi/a
         o1ITaeIkiNyCrmRI1WvXnqCt1m8pmIR1ia1/Wiwo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Yang <Eric.Yang2@amd.com>, Tony Cheng <Tony.Cheng@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 11/52] drm/amd/display: update dispclk and dppclk vco frequency
Date:   Fri, 20 Dec 2019 09:29:13 -0500
Message-Id: <20191220142954.9500-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Yang <Eric.Yang2@amd.com>

[ Upstream commit 44ce6c3dc8479bb3ed68df13b502b0901675e7d6 ]

Value obtained from DV is not allowing 8k60 CTA mode with DSC to
pass, after checking real value being used in hw, find out that
correct value is 3600, which will allow that mode.

Signed-off-by: Eric Yang <Eric.Yang2@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index de182185fe1f5..b0e5e64df2127 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -258,7 +258,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn2_1_soc = {
 	.vmm_page_size_bytes = 4096,
 	.dram_clock_change_latency_us = 23.84,
 	.return_bus_width_bytes = 64,
-	.dispclk_dppclk_vco_speed_mhz = 3550,
+	.dispclk_dppclk_vco_speed_mhz = 3600,
 	.xfc_bus_transport_time_us = 4,
 	.xfc_xbuf_latency_tolerance_us = 4,
 	.use_urgent_burst_bw = 1,
-- 
2.20.1

