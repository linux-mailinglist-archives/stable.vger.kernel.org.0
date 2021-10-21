Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD138435718
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhJUAY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhJUAYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39F91613DB;
        Thu, 21 Oct 2021 00:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775707;
        bh=NWmRiRW19PYgY4OfgDh+IoW5qa7oawkG0RlypOH1hM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHwj9xOnLm78YernklcpRbN1e8L+CBTZuzMgwY0Myy4Ddv7gxMMyHo5X+D4vkqKKw
         WQ+dvEOmINv55IMb2jquHgRjUdb5nZfaWyX1Veiv3m8hdgTK2wzMX2sdH59RtwMZoL
         QKMB6Ryiug5CM7yK8PkiCeh3pa5ZOkGuVv59YmnVXe/iua/jCPbmheikc7M4vJgCNZ
         7zx211e48nHkB/eueMENwUvAdKkHl81Lo0G4WXEhae6DnwaJLl3VAQ12QxgQP5p/3u
         U8no3W1dJpt2wJJDmNBfgW27u1myX8jj3DGvJQOvsf43+nbIE+1IYs/yRXQAYSMGzp
         X3Fppyfx5qNmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, bp@alien8.de, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 24/26] perf/x86/msr: Add Sapphire Rapids CPU support
Date:   Wed, 20 Oct 2021 20:20:21 -0400
Message-Id: <20211021002023.1128949-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 71920ea97d6d1d800ee8b51951dc3fda3f5dc698 ]

SMI_COUNT MSR is supported on Sapphire Rapids CPU.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/1633551137-192083-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/msr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index c853b28efa33..96c775abe31f 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -68,6 +68,7 @@ static bool test_intel(int idx, void *data)
 	case INTEL_FAM6_BROADWELL_D:
 	case INTEL_FAM6_BROADWELL_G:
 	case INTEL_FAM6_BROADWELL_X:
+	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 
 	case INTEL_FAM6_ATOM_SILVERMONT:
 	case INTEL_FAM6_ATOM_SILVERMONT_D:
-- 
2.33.0

