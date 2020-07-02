Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED0C2117AA
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgGBBXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgGBBXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA65220748;
        Thu,  2 Jul 2020 01:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593652979;
        bh=sIUlAmhTnfBS1jKcMvo/2Rk0jPaABNfNX5aq1FKva4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCpinOjYC3wiFVmwlhuH2UxhMFpHc6q7++w0o/Er8FU8+SdAcCTv2wPzCbgPdN4JA
         qeR5stPayfF5fK8EhXDJvzmXfDx7QB1XPZE5w8KYCiGFeiSA30OAFtzA9FUVp4FrLE
         qo3SFst5M/JAAL2wmpEY/8AzuPgost0HkoHuuH7E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 04/53] perf/x86/rapl: Fix RAPL config variable bug
Date:   Wed,  1 Jul 2020 21:21:13 -0400
Message-Id: <20200702012202.2700645-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[ Upstream commit 16accae3d97f97d7f61c4ee5d0002bccdef59088 ]

This patch fixes a bug introduced by:

  fd3ae1e1587d6 ("perf/x86/rapl: Move RAPL support to common x86 code")

The Kconfig variable name was wrong. It was missing the CONFIG_ prefix.

Signed-off-by: Stephane Eranian <eraniangoogle.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20200528201614.250182-1-eranian@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/Makefile b/arch/x86/events/Makefile
index b418ef6878796..726e83c0a31a1 100644
--- a/arch/x86/events/Makefile
+++ b/arch/x86/events/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y					+= core.o probe.o
-obj-$(PERF_EVENTS_INTEL_RAPL)		+= rapl.o
+obj-$(CONFIG_PERF_EVENTS_INTEL_RAPL)	+= rapl.o
 obj-y					+= amd/
 obj-$(CONFIG_X86_LOCAL_APIC)            += msr.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel/
-- 
2.25.1

