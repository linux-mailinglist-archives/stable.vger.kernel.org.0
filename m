Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4DF61E3EC
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiKFRFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiKFRFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:05:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BD610FD6;
        Sun,  6 Nov 2022 09:04:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05E8760C3F;
        Sun,  6 Nov 2022 17:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A8BC4347C;
        Sun,  6 Nov 2022 17:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754292;
        bh=XArU3TO7AQ2vdLMZAPZu9OOgf+sON8XbgI7gyApuQII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glYNFu3LoME3x4rn7zxIAUjy4AHOtWtQ14MeN6duWTCuCvkfYxOQel+bbBxfPHfsz
         XUJ81ZSaYW58jIWoPVKst52kThXOaB/MjuxDm8wsLVDbFrX/NuCo7lecicvosWB8h2
         qhQDswbbbSspLzHdLvCffJgUKlOw/ceT2LtwdhEdDJ8bPkWNj4fGRLeigT7+n8D0mD
         v2J2y0HRZUyY1euxZGo64Ew2/aC1V8P4yxRFTE+r+qaMCcpCIZXxTaTxaHCs3mgN2+
         ygHZFtavc+xIfxTxIB09l3grE+qL2MvNru2oL/sljigjLbiWgC4Ps7IkpmsoFNspDN
         YWmOOI21VmpjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gayatri Kammela <gayatri.kammela@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Box <david.e.box@intel.com>,
        Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 26/30] platform/x86/intel: pmc/core: Add Raptor Lake support to pmc core driver
Date:   Sun,  6 Nov 2022 12:03:38 -0500
Message-Id: <20221106170345.1579893-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
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

From: Gayatri Kammela <gayatri.kammela@linux.intel.com>

[ Upstream commit 555a68dd681b7437a2708001d465c85f6dfa6955 ]

Add Raptor Lake client parts (both RPL and RPL_S) support to pmc core
driver. Raptor Lake client parts reuse all the Alder Lake PCH IPs.

Cc: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Box <david.e.box@intel.com>
Acked-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@linux.intel.com>
Link: https://lore.kernel.org/r/20220912233307.409954-2-gayatri.kammela@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index a1fe1e0dcf4a..17ec5825d13d 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -1914,6 +1914,8 @@ static const struct x86_cpu_id intel_pmc_core_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N,		&tgl_reg_map),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&adl_reg_map),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,        &tgl_reg_map),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&adl_reg_map),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&adl_reg_map),
 	{}
 };
 
-- 
2.35.1

