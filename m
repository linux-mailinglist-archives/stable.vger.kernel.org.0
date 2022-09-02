Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346B85AB302
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbiIBOH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238915AbiIBOHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:07:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9032A963;
        Fri,  2 Sep 2022 06:35:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB689B829E6;
        Fri,  2 Sep 2022 12:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45928C433D6;
        Fri,  2 Sep 2022 12:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122173;
        bh=r1Y3OJV+YGLJqZpyhIjb0C5nbwFq/NU3LvJWzdODIdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssiC387961+zXn6RLnMOsWUzf5EHiEvN33j7nkRLj6BOaJEPkFqRnBfpLKMai9HVK
         dIe9cX07FPMlGp6i7audsh88VRPjGW+HibRGdIL8Gny10d3cNJOtbhmC801JacbGoE
         Zi2ztfnxRA5Ow1btMmaLGxzKm0ZT4NrfZzEtJxfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 36/72] drm/amd/display: Add a missing register field for HPO DP stream encoder
Date:   Fri,  2 Sep 2022 14:19:12 +0200
Message-Id: <20220902121405.973616576@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 37bc31f0e7da4fbad4664e64d906ae7b9009e550 ]

[Why&How]
Add the missing definition to set the register field
HBLANK_MINIMUM_SYMBOL_WIDTH

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.h b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.h
index 7c77c71591a08..82c3b3ac1f0d0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hpo_dp_stream_encoder.h
@@ -162,7 +162,8 @@
 	SE_SF(DP_SYM32_ENC0_DP_SYM32_ENC_SDP_AUDIO_CONTROL0, AIP_ENABLE, mask_sh),\
 	SE_SF(DP_SYM32_ENC0_DP_SYM32_ENC_SDP_AUDIO_CONTROL0, ACM_ENABLE, mask_sh),\
 	SE_SF(DP_SYM32_ENC0_DP_SYM32_ENC_VID_CRC_CONTROL, CRC_ENABLE, mask_sh),\
-	SE_SF(DP_SYM32_ENC0_DP_SYM32_ENC_VID_CRC_CONTROL, CRC_CONT_MODE_ENABLE, mask_sh)
+	SE_SF(DP_SYM32_ENC0_DP_SYM32_ENC_VID_CRC_CONTROL, CRC_CONT_MODE_ENABLE, mask_sh),\
+	SE_SF(DP_SYM32_ENC0_DP_SYM32_ENC_HBLANK_CONTROL, HBLANK_MINIMUM_SYMBOL_WIDTH, mask_sh)
 
 
 #define DCN3_1_HPO_DP_STREAM_ENC_REG_FIELD_LIST(type) \
-- 
2.35.1



