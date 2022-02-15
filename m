Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373EF4B7276
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240234AbiBOPcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:32:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240503AbiBOPbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:31:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953361111BC;
        Tue, 15 Feb 2022 07:29:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31C4061532;
        Tue, 15 Feb 2022 15:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A43C340EB;
        Tue, 15 Feb 2022 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938969;
        bh=v3MER1/Z/1nChzKsMsoSuaIlZ25Q0/0JMr6nMx6ik68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DyVf+T2Rvujrb09HnxwgSn0D9YM7PkkWj6RVyiNPhRLd+UktrJ9IxyFbIpZrCNLK1
         GSlm3qre6LNkzMUwXWODk+jhx373D7bUb9AIDybJagcW4eAQodacc8D70jyD6VeV6G
         JDjIRq0HQ5zkt8OM277blQ+SGjagnbWn5RzyHNFn95QEDWQfBpkiCfCB7tdFnjIMsM
         FpX+PUHwocR+FdbM+q094xq2VWlBL9RP7D4QWMASAn2khiVroaxp3rqZ5nQYaH3mXO
         ZyVSWi1tZPDRuEnmWh1//pMqVKfNkFgsMPjMxfxI1tBLyesKTEod9zYLWj/rXG87g+
         H7dUfQ/t6uA3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        nicholas.kazlauskas@amd.com, aaron.liu@amd.com,
        Xiaomeng.Hou@amd.com, aric.cyr@amd.com, isabbasso@riseup.net,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 28/33] display/amd: decrease message verbosity about watermarks table failure
Date:   Tue, 15 Feb 2022 10:28:26 -0500
Message-Id: <20220215152831.580780-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 03ad3093c7c069d6ab4403730009ebafeea9ee37 ]

A number of BIOS versions have a problem with the watermarks table not
being configured properly.  This manifests as a very scary looking warning
during resume from s0i3.  This should be harmless in most cases and is well
understood, so decrease the assertion to a clearer warning about the problem.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
index 162ae71861247..21d2cbc3cbb20 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
@@ -120,7 +120,11 @@ int dcn31_smu_send_msg_with_param(
 	result = dcn31_smu_wait_for_response(clk_mgr, 10, 200000);
 
 	if (result == VBIOSSMC_Result_Failed) {
-		ASSERT(0);
+		if (msg_id == VBIOSSMC_MSG_TransferTableDram2Smu &&
+		    param == TABLE_WATERMARKS)
+			DC_LOG_WARNING("Watermarks table not configured properly by SMU");
+		else
+			ASSERT(0);
 		REG_WRITE(MP1_SMN_C2PMSG_91, VBIOSSMC_Result_OK);
 		return -1;
 	}
-- 
2.34.1

