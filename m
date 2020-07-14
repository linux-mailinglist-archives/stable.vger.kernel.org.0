Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCAD21FCC1
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgGNStE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729211AbgGNStC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:49:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 849FA22B3A;
        Tue, 14 Jul 2020 18:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752542;
        bh=sIUlAmhTnfBS1jKcMvo/2Rk0jPaABNfNX5aq1FKva4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTATgriZhG2jjxFo6okbU4OPLVxMphDJ/eB7J5KU3cnosdeX5m7/6/hoKedTSYnXu
         GuOBqzke/xmRpjrVMnoSQMLcP8Jn9izu98HDoyVkfQ0pVf9dJnYCgnhQxXA7t/NlEI
         7FfAxGPaf91kNKiODM+OUKrMUL4n7o7z9mWhLypk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/109] perf/x86/rapl: Fix RAPL config variable bug
Date:   Tue, 14 Jul 2020 20:43:09 +0200
Message-Id: <20200714184105.825183784@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



