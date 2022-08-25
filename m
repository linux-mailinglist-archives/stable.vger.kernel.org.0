Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D945A0624
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiHYBjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbiHYBic (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:38:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232709677A;
        Wed, 24 Aug 2022 18:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B92C461AC0;
        Thu, 25 Aug 2022 01:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95787C433C1;
        Thu, 25 Aug 2022 01:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391404;
        bh=0483u44QYXkp+KDrcmRw1N3EorprKlZ+mnKHLzhDhtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZM69TyyVwxoaIPrkWIXQIEuEMTMIgIEIcTt2si2eFWoEu+s48yORuAwrgF3Hpwfcd
         7cn7uCU8Tcj8w1cg38Y7DdYuUbxOKO9MLQm+l3knMw8v9VLziMXmJ3BqInT8NZtUsc
         OmkzP15ek5k3phy1GD1oyTHNlGuMwo22R5F6i9Ot/b1vUfyUmUVjg4nnQvP0frUvRP
         Gy3I9FI9ooX/oDpoV2VjxB/DssIBYejLN3d1HcR+30lVXDzijl1EZmvegjsBozh8bs
         Tlyo1umEUnsaCI80kPTfsswmM8wX3ldxudL2DjaZ+0TCS1ey55xnnbrAO6GPn0naJI
         pvMvZR0rAXN0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Philip.Yang@amd.com, Felix.Kuehling@amd.com, Stanley.Yang@amd.com,
        evan.quan@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 28/38] drm/amdgpu: Add decode_iv_ts helper for ih_v6 block
Date:   Wed, 24 Aug 2022 21:33:51 -0400
Message-Id: <20220825013401.22096-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
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

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit 1af9add1f1512b10d9ce44ec7137612bc81ff069 ]

Was missing.  Add it.

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c b/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
index 92dc60a9d209..085e613f3646 100644
--- a/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/ih_v6_0.c
@@ -727,6 +727,7 @@ static const struct amd_ip_funcs ih_v6_0_ip_funcs = {
 static const struct amdgpu_ih_funcs ih_v6_0_funcs = {
 	.get_wptr = ih_v6_0_get_wptr,
 	.decode_iv = amdgpu_ih_decode_iv_helper,
+	.decode_iv_ts = amdgpu_ih_decode_iv_ts_helper,
 	.set_rptr = ih_v6_0_set_rptr
 };
 
-- 
2.35.1

