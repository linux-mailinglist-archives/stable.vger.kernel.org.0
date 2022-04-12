Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C3D4FCA29
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243878AbiDLAvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243250AbiDLAuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:50:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E86732061;
        Mon, 11 Apr 2022 17:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25FC7B819B5;
        Tue, 12 Apr 2022 00:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03CEC385A3;
        Tue, 12 Apr 2022 00:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724418;
        bh=tGzXzQhqgL+alx1Q6zWeqj7q4zL1AuwH2it+jAec/5w=;
        h=From:To:Cc:Subject:Date:From;
        b=FJqsObSSqdImu/Rbsb2PfiLEu0T71oUSnmXi2EP3/XpM1HK0z1W6rTHj6odggFLBU
         hnXurwctwugxyqOIXw4cIw1+3v7ke/wjd0TSKpWOgFTQ3WLRgTlrrSTiNC9umIMS/5
         99o46LVWiC0TvWUB3tIhMmCVJsqQ+C4ZmYyOP8+G0G66s1datUQ+yyw0DqJaoJ020I
         3HgdndBBxRuHhGC/v8UJDtVia/8Uw1nNCQExCrIlIgbhhgO8RJFV8NEnZz4GXNLRBt
         +1YRcN9qpc3YXeF4SuC2J3iJ8ImLqeG173ywVAUMDx0go7V0YS6nJ/0SWpCfVfpjIi
         ucHCoLtknXcrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 01/41] drm/amd: Add USBC connector ID
Date:   Mon, 11 Apr 2022 20:46:13 -0400
Message-Id: <20220412004656.350101-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit c5c948aa894a831f96fccd025e47186b1ee41615 ]

[Why&How] Add a dedicated AMDGPU specific ID for use with
newer ASICs that support USB-C output

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/ObjectID.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/ObjectID.h b/drivers/gpu/drm/amd/amdgpu/ObjectID.h
index 5b393622f592..a0f0a17e224f 100644
--- a/drivers/gpu/drm/amd/amdgpu/ObjectID.h
+++ b/drivers/gpu/drm/amd/amdgpu/ObjectID.h
@@ -119,6 +119,7 @@
 #define CONNECTOR_OBJECT_ID_eDP                   0x14
 #define CONNECTOR_OBJECT_ID_MXM                   0x15
 #define CONNECTOR_OBJECT_ID_LVDS_eDP              0x16
+#define CONNECTOR_OBJECT_ID_USBC                  0x17
 
 /* deleted */
 
-- 
2.35.1

