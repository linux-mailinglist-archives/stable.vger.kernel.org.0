Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D71D6CC30A
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjC1Ouz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbjC1Oul (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:50:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3C2E381
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64823B80976
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9221C4339B;
        Tue, 28 Mar 2023 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015005;
        bh=54cBY40PFgIQNENk+a5ZkIQjbcAinJrxFV+hck1/Wb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgwaFFnA6JHIMAnPRFsMQL8n4LF6DHg1oHjBhsMNNUMSisMSvjb5RL6c05TjNvwf+
         bsD7e0LeU2xL/wvA08XbQTtZ20O6yBcbvSdABNsW3/yJfjEZsS54u5aKYvT5+3W7Qh
         yC4d1h8PyHuuZcr/e7Gvkqs600n83JPTUTCqmmEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 101/240] drm/amd/display: Set dcn32 caps.seamless_odm
Date:   Tue, 28 Mar 2023 16:41:04 +0200
Message-Id: <20230328142623.974274834@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit f9537b1fa7fb51c2162bc15ce469cbbf1ca0fbfe ]

[Why & How]
seamless_odm set was not picked up while
merging commit 2d017189e2b3 ("drm/amd/display:
Blank eDP on enable drv if odm enabled")

Fixes: 2d017189e2b3 ("drm/amd/display: Blank eDP on enable drv if odm enabled")
Reviewed-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index 252356a8160fa..6187aba1362b8 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -2186,6 +2186,7 @@ static bool dcn32_resource_construct(
 	dc->caps.edp_dsc_support = true;
 	dc->caps.extended_aux_timeout_support = true;
 	dc->caps.dmcub_support = true;
+	dc->caps.seamless_odm = true;
 
 	/* Color pipeline capabilities */
 	dc->caps.color.dpp.dcn_arch = 1;
-- 
2.39.2



