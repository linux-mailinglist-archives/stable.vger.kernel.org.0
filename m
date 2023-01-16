Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6258C66C168
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjAPOLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbjAPOKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:10:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C04628869;
        Mon, 16 Jan 2023 06:04:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5DD260FE0;
        Mon, 16 Jan 2023 14:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF63C43396;
        Mon, 16 Jan 2023 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877858;
        bh=KqF83T1wi3gZrPovP8xbQHdxtpKzpwd8LW54Zyo/Hzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tosqiRAKM+HYMkZxMtz7At0sw33zYNVM1YtKUBe9gXVwOCa6qWvTEjMr4hZAep++f
         Uql/fmaYfMYSlxQjdOrqqnkzD64X3hbapjWpXCbfIQ/Jmp36FRkpMZozutgNUJwsDp
         HeCKEY8Zp3HoWrDJ4S02/pN+7nczTw6Ild1TRO4tBc/IjjzsFvdM0I6W1c1pGjDHdC
         unogiva6Zet5FKm08YEBxSzeYvJGFpuONqg1QrUtUZTatsdS4toRhhi4G8tgykw98y
         4ZYmKTBMqOT9zzAJqicxcy72s864AoV6xHKI7XfXUbQ2PEFF5EJ+t7j59e2cRSjdHF
         BZGiVvEVeoNVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/24] perf/x86/msr: Add Emerald Rapids
Date:   Mon, 16 Jan 2023 09:03:45 -0500
Message-Id: <20230116140359.115716-10-sashal@kernel.org>
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

[ Upstream commit 69ced4160969025821f2999ff92163ed26568f1c ]

The same as Sapphire Rapids, the SMI_COUNT MSR is also supported on
Emerald Rapids. Add Emerald Rapids model.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230106160449.3566477-3-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/msr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 96c775abe31f..d23b5523cdd3 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -69,6 +69,7 @@ static bool test_intel(int idx, void *data)
 	case INTEL_FAM6_BROADWELL_G:
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	case INTEL_FAM6_EMERALDRAPIDS_X:
 
 	case INTEL_FAM6_ATOM_SILVERMONT:
 	case INTEL_FAM6_ATOM_SILVERMONT_D:
-- 
2.35.1

