Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E849B66C16B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjAPOLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbjAPOKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:10:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B67B2B097;
        Mon, 16 Jan 2023 06:04:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 312EAB80F91;
        Mon, 16 Jan 2023 14:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A04C4339C;
        Mon, 16 Jan 2023 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877859;
        bh=1WuCNP891T2A+p3sb0RDsrJqTKSkAYppNYlowYfi06Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uk2u4WJpAf9LQkx/Qzv0saem0t32mIhA0KeScLJ3wSRsOhx7Y8NiTKZMMq02+5CjB
         thhCbn8GTvSeqhQ7PM8hWwREYGJ4okU9F9di/taRkFPyIsjJtJPecN/plRSs5vQWuK
         0evRav0yFF6i1At12/g2UJvujCkL6dI++vMiwBfYPUqaINKNRNH/wAlQQ6LMLxW1ft
         TFRMooT+zaZhPDnUyWAd0nPnO3arNfaJLm/yo0os51gTdtqDauUCfDEl1ImOu/8P0n
         ujXGGp8VN7nCJG5k9k179+EaWTkippln8B3pSiOillrGPUwMD0hUTIJbRnGpKHhka/
         XoqnYdtBH/FTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/24] perf/x86/intel/uncore: Add Emerald Rapids
Date:   Mon, 16 Jan 2023 09:03:46 -0500
Message-Id: <20230116140359.115716-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140359.115716-1-sashal@kernel.org>
References: <20230116140359.115716-1-sashal@kernel.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 5268a2842066c227e6ccd94bac562f1e1000244f ]

From the perspective of the uncore PMU, the new Emerald Rapids is the
same as the Sapphire Rapids. The only difference is the event list,
which will be supported in the perf tool later.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230106160449.3566477-4-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index c72e368dd164..7e16c590f259 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1829,6 +1829,7 @@ static const struct x86_cpu_id intel_uncore_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&adl_uncore_init),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&adl_uncore_init),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&spr_uncore_init),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&spr_uncore_init),
 	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT_D,	&snr_uncore_init),
 	{},
 };
-- 
2.35.1

