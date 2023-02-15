Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56843698645
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjBOUtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjBOUr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:47:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DDF43447;
        Wed, 15 Feb 2023 12:47:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBAF8B823B6;
        Wed, 15 Feb 2023 20:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC43DC433EF;
        Wed, 15 Feb 2023 20:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493994;
        bh=/dHB7S/tKDWgQrM6FbPgvEFxvU3XqnY7GE0MJ4coEJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOkzV6OJMp/MCffkAIr2cDNivoZsKhgyAkd+UCmV2Am9WV5pgskQdR5if5Az3QUxj
         mcD0JaUrpau3t280ZS1OgEngRF0QFUVDAujstaao16wsupCiui3vUmvZ8gVg4BoRcP
         ExDIkMPiJLKeWvYCjlenMsJfdr7LPxJGuZTTNVyVm6usEmaFZt1o/MLjg4v8oV/ljX
         C43yBwoYRRj5cvKONhqw+1JVSHplX/b++A2sTWAR2XI8PRdFOmOk7kjFgKzsUQJvVr
         BX54vsBkjGXyjAGEPn7g0cs33RfzEE3wuyrjzIpPuEw4AjF6cNG9S9yT1syTgpy+5i
         PK/GtRD7ghbow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>, roman.li@amd.com,
        yifan1.zhang@amd.com, Sasha Levin <sashal@kernel.org>,
        harry.wentland@amd.com, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        aurabindo.pillai@amd.com, stylon.wang@amd.com, Jerry.Zuo@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 24/24] drm/amd/display: disable S/G display on DCN 3.1.2/3
Date:   Wed, 15 Feb 2023 15:45:47 -0500
Message-Id: <20230215204547.2760761-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 077e9659581acab70f2dcc04b5bc799aca3a056b ]

Causes flickering or white screens in some configurations.
Disable it for now until we can fix the issue.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2352
Cc: roman.li@amd.com
Cc: yifan1.zhang@amd.com
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 988b1c947aefc..c026ba532b733 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1524,8 +1524,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 			break;
 		case IP_VERSION(2, 1, 0):
 		case IP_VERSION(3, 0, 1):
-		case IP_VERSION(3, 1, 2):
-		case IP_VERSION(3, 1, 3):
 		case IP_VERSION(3, 1, 6):
 			init_data.flags.gpu_vm_support = true;
 			break;
-- 
2.39.0

