Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A43868301D
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbjAaPAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbjAaPAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:00:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5614746A2;
        Tue, 31 Jan 2023 07:00:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C041B81D46;
        Tue, 31 Jan 2023 15:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3BBC433A0;
        Tue, 31 Jan 2023 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177202;
        bh=p8RmVeg69ysW6Ii0taBAm09lr+ufhKRbNy8kHhcVErw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJnbAtvZZr2Ns8ZuzLaRP1K7ibOZUe7ipysB/9pNEtvenKEc4rpK6eaXqDSME2Rs0
         aJjEjs4unKxsNTrtJA3nDC5PGHencmwE3Dwry2GlqoZCOcRpxA6u/fD82aYXlsgds/
         MZ74ilAiGDy+B4LyQM3Hjx24GB4bWRzL8yCPGOF8NNyTMH5WU0tN0jlZS6XsTTA/VS
         jDJuf5dt86DvptCeHWcMMxGUGrgOXK2NiBU7Z61P3wbV9zTDgmrWSe6hZUivZ1ExL8
         b2wzY7F9AmpBkJi62XW0Zb0/53PW4DFLwHQMLteeoyHPGAzkZePD3prvmNZwHYJ5GG
         4SRUr1pZeHlZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/20] perf/x86/intel/cstate: Add Emerald Rapids
Date:   Tue, 31 Jan 2023 09:59:32 -0500
Message-Id: <20230131145946.1249850-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131145946.1249850-1-sashal@kernel.org>
References: <20230131145946.1249850-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 5a8a05f165fb18d37526062419774d9088c2a9b9 ]

From the perspective of Intel cstate residency counters,
Emerald Rapids is the same as the Sapphire Rapids and Ice Lake.
Add Emerald Rapids model.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230106160449.3566477-2-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/cstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index a2834bc93149..181ae3f47dfd 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -676,6 +676,7 @@ static const struct x86_cpu_id intel_cstates_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,		&icx_cstates),
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,		&icx_cstates),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&icx_cstates),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&icx_cstates),
 
 	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L,		&icl_cstates),
 	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		&icl_cstates),
-- 
2.39.0

