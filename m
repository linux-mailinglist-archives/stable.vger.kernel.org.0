Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CCB5900D9
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbiHKPq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbiHKPpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:45:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF9598D3C;
        Thu, 11 Aug 2022 08:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 26742CE2238;
        Thu, 11 Aug 2022 15:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB9CC433D7;
        Thu, 11 Aug 2022 15:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232388;
        bh=i16o/UpQOLnaNmb6qlvby7vOoR3dY23lMEGXDmWnHrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sm90RI0lo8u4ujfMpWnNVTlat5k0NHBmxg7i3s+CY/vfgqVHMrTmxjomjAj/IcCVD
         K9w3PRnOWE2jTeC4MQ5DPYF4vZ/hMHXRk3pX3QS0t5/pQKTJn9+Kvgtq67cZSbP2pI
         ZTPfsEaRU2HuQpvxgDmNadG8dx3uUIHBm7GgZxUlxiUMuHyeKntGoo1fyE20HFvFEN
         Kt1Fe6vtnn5CnDe5KnDxmp8178F4I69Oxq/MqoklrXAmqxm5q9EOClt6eOdS9dqgvU
         88W+mUiPl/XwEm1GsdttKu9FnxDWMZaV13jgOuOSPyNf2mxAwByn+kdWD8gexV6CYY
         GAw3QQ4hobGTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     lin cao <lin.cao@amd.com>, Jingwen Chen <Jingwen.Chen2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, lijo.lazar@amd.com, guchun.chen@amd.com,
        luben.tuikov@amd.com, sathishkumar.sundararaju@amd.com,
        danijel.slivka@amd.com, Mohammadzafar.ziya@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 075/105] drm/amdgpu: Call trace info was found in dmesg when loading amdgpu
Date:   Thu, 11 Aug 2022 11:27:59 -0400
Message-Id: <20220811152851.1520029-75-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: lin cao <lin.cao@amd.com>

[ Upstream commit 748262eb400e809aa13e3485f4983c3db3d0ebb3 ]

In the case of SRIOV, the register smnMp1_PMI_3_FIFO will get an invalid
value which will cause the "shift out of bound". In Ubuntu22.04, this
issue will be checked an related call trace will be reported in dmesg.

Signed-off-by: lin cao <lin.cao@amd.com>
Reviewed-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 78f3d9e722bb..4db7e32efd08 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -886,6 +886,7 @@ static void sienna_cichlid_stb_init(struct smu_context *smu);
 
 static int sienna_cichlid_init_smc_tables(struct smu_context *smu)
 {
+	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
 	ret = sienna_cichlid_tables_init(smu);
@@ -896,7 +897,8 @@ static int sienna_cichlid_init_smc_tables(struct smu_context *smu)
 	if (ret)
 		return ret;
 
-	sienna_cichlid_stb_init(smu);
+	if (!amdgpu_sriov_vf(adev))
+		sienna_cichlid_stb_init(smu);
 
 	return smu_v11_0_init_smc_tables(smu);
 }
-- 
2.35.1

