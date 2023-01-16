Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EC366C0E5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjAPOF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjAPOEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:04:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA06B233CF;
        Mon, 16 Jan 2023 06:03:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DE60B80F3B;
        Mon, 16 Jan 2023 14:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91E6C433EF;
        Mon, 16 Jan 2023 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877786;
        bh=CxFJTOwhnwoEvXuU18UZZa1SEQyLrnvh1AQQJ8HUxEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IR6HtHLkrDCsHgZ4kuWBnttzGxe1V+1jb/a/oDbJtHZtrDpvXnu2gH9oXG4iS6nPz
         6fd8Q3llxDGpmLzaxbVyJPFtzkFLgHOzz4HNklPEbT/ovPMeEG0zQx0VKocIZ5XH9N
         t6kuT066+4mR9YSS+LuRMZg5ULlp2hA/eO89TGqIeeeGWnpjObth+sG6opKQ3RmXrm
         mEJTplsbdJuNFdg/GjonWaSwWe7DhsegvH3ypo274VDm/ZzB5w2a/mC0jXnhK5UIc3
         s17CEI/UoioJki8YaHLsnJek5VunLyul+sXYfACwgiCDSjmHhV+6vMQWWujwdcXJFs
         PsxwMBVm4z+7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 24/53] perf/x86/msr: Add Emerald Rapids
Date:   Mon, 16 Jan 2023 09:01:24 -0500
Message-Id: <20230116140154.114951-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
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
index 074150d28fa8..c65d8906cbcf 100644
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

