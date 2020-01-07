Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880551330F2
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgAGU4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:56:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgAGU4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:56:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CF862081E;
        Tue,  7 Jan 2020 20:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430579;
        bh=S4qaK4LSPhlFubINRDmXg3oVTW5c2uKHGKu+W2JMl1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qV1CjR5q2YIB0yA/RaDXL6fFlldGoqfeBf1KYO87Z4rrmUbNZCrjI1do6ItXM3Anc
         i0ML3J1vNLFfe1DvwAc2sp3SfiO49d/ME0+0ftbRuKGjFwVjNDiX5qIr/Q82kuobTI
         yJsSQo18FB35VKIH2OXji0SWzdXL93WexnkXlkeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Yang <Eric.Yang2@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/191] drm/amd/display: update dispclk and dppclk vco frequency
Date:   Tue,  7 Jan 2020 21:52:11 +0100
Message-Id: <20200107205333.613297948@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index de182185fe1f..b0e5e64df212 100644
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



