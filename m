Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C81B378881
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhEJLVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237145AbhEJLL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A587D6186A;
        Mon, 10 May 2021 11:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644857;
        bh=Qyk2IEPJuLpo6zdXnrXDFwAdBeuuV8vcZB58RRXKzHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/qH25b+ukJVy2zNTMoTgWv7fTsZBApsH3PLRfaGLranZwoipfDPzgP86eTx8qN1g
         ZxH8NtNqfGPwxeP7h98v/48KQDPkKPLzV5Q/fXqz03ARpfFwLOipY3Fik7+lu7BKhR
         nfvOntrX20qkP5NUnGrkzKuZd0zlv5rPoPdwF93U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Aberback <joshua.aberback@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 252/384] drm/amd/display: Update DCN302 SR Exit Latency
Date:   Mon, 10 May 2021 12:20:41 +0200
Message-Id: <20210510102023.190475339@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joshua Aberback <joshua.aberback@amd.com>

[ Upstream commit 79f02534810c9557fb3217b538616dc42a1de3b9 ]

[Why&How]
Update SR Exit Latency to fix screen flickering caused due to OTG
underflow. This is the recommended value given by the hardware IP team.

Signed-off-by: Joshua Aberback <joshua.aberback@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c b/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c
index 4b659b63f75b..d03b1975e417 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c
@@ -164,7 +164,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn3_02_soc = {
 
 		.min_dcfclk = 500.0, /* TODO: set this to actual min DCFCLK */
 		.num_states = 1,
-		.sr_exit_time_us = 12,
+		.sr_exit_time_us = 15.5,
 		.sr_enter_plus_exit_time_us = 20,
 		.urgent_latency_us = 4.0,
 		.urgent_latency_pixel_data_only_us = 4.0,
-- 
2.30.2



