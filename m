Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0934834C7F8
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhC2IS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhC2IST (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBA7961964;
        Mon, 29 Mar 2021 08:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005889;
        bh=7Sc1OyOci1CHmpOtVP7j7g8RKp0UJBJvi7kFlrNny1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gu872omYUwdbA9UKZ61DqlNENdX2rsq8vGewNQwl3jgb3kQ/nmYs7kmje3NsS065D
         yjo7oJb2shYk3BTF4OvBZWnBVoesoMThUOKqfCQD7iXTXQDLZGtwFPflDjIKTZM9ey
         osACrW3UlosVqJwbHYEUxT6Fps6DEXogi3rD31O0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Sung Lee <sung.lee@amd.com>,
        Haonan Wang <Haonan.Wang2@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/221] drm/amd/display: Revert dram_clock_change_latency for DCN2.1
Date:   Mon, 29 Mar 2021 09:56:13 +0200
Message-Id: <20210329075630.584403283@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung Lee <sung.lee@amd.com>

[ Upstream commit b0075d114c33580f5c9fa9cee8e13d06db41471b ]

[WHY & HOW]
Using values provided by DF for latency may cause hangs in
multi display configurations. Revert change to previous value.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Haonan Wang <Haonan.Wang2@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index b5fe2a008bd4..7ed4d7c8734f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -295,7 +295,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn2_1_soc = {
 	.num_banks = 8,
 	.num_chans = 4,
 	.vmm_page_size_bytes = 4096,
-	.dram_clock_change_latency_us = 11.72,
+	.dram_clock_change_latency_us = 23.84,
 	.return_bus_width_bytes = 64,
 	.dispclk_dppclk_vco_speed_mhz = 3600,
 	.xfc_bus_transport_time_us = 4,
-- 
2.30.1



