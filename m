Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85E943573D
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhJUAZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhJUAYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 054E26135F;
        Thu, 21 Oct 2021 00:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775751;
        bh=rVjZnonIjs9iQhf+25GYEN+yAKjpStAF8+G+vHXsZYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9zmZfSBKOvaqevuKlZR551QG8590Pd2kpXl+6ozMFgFwQ5GeHCeBzoCe3RjHOx8q
         POg1YXgfRDoX2zBHkYKsLgPdRalQINPsNS5XL2oU3QJLC7lSkbWn0WYiRl3Hd4hgK1
         a0qk46xjj7fhLrt1flVyvX7E/0eT5OOJvZUsx1SAN/4MUaqoaDRqwnT6Yu2x0sYtRw
         7q+HtPtlb2kHuZoiukXYXAgCMWNgzwF0qq2r3sc2WSW/zIWH7MW5EPDplsFiWKRlHp
         hi8sLmZge0XrOvISVk84Zto6XkGEXI5ymUfebdgC7T7lqvjJGbVBoh12DP5OXcBfaw
         ncZzugY67xA1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, bp@alien8.de, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/14] perf/x86/msr: Add Sapphire Rapids CPU support
Date:   Wed, 20 Oct 2021 20:21:53 -0400
Message-Id: <20211021002155.1129292-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002155.1129292-1-sashal@kernel.org>
References: <20211021002155.1129292-1-sashal@kernel.org>
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
index 4be8f9cabd07..ca8ce64df2ce 100644
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

