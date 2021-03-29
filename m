Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEA934C731
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhC2INL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231901AbhC2ILz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:11:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 473A16196D;
        Mon, 29 Mar 2021 08:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005514;
        bh=ycdKLRkXafHBSwEDjvdu5pheyZU7MTyYgWw4zPjDw9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2dIRgPTAt9cJSN0cDjlOc1/seRpuYo/DlJNJi5COOLyXfz4MCAE6dO6pwnOEK2kF
         UqAxbPKgNiy8/mjLuPv0ds/FODx6MHWRT4S3b8dV66jftHZfJMVUEkrqBjq102onYw
         q5OhU1RZGRu39yLa8CoeHawbprOWbaOugHqEX7Sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Sung Lee <sung.lee@amd.com>,
        Haonan Wang <Haonan.Wang2@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/111] drm/amd/display: Revert dram_clock_change_latency for DCN2.1
Date:   Mon, 29 Mar 2021 09:57:37 +0200
Message-Id: <20210329075616.150349243@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
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
index f63cbbee7b33..11a4c4029a90 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -257,7 +257,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn2_1_soc = {
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



