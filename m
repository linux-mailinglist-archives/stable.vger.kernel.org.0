Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3712D15DDF1
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387601AbgBNQBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:01:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389061AbgBNQAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:00:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E3792086A;
        Fri, 14 Feb 2020 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696008;
        bh=pQXAymyow/dMd9ddSmCJOj/eaUwArnf4PFXihefFwlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWgzOmM3HiUsWnLuQk6eTBaNYCmCc/sHdBg571fNvZDWiHnixwTmRqtdinrmx3uU9
         jwO9q2qECw9f9aphooBzhQrO/UYwpep2ygIH4GcxI/AXjS4+IIYuTfUxEk9+3y3DE9
         f4jKeIFJYYc/iJodAaTrJ8lh4BojYptej3DVB1yo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 525/542] asm-generic/tlb: add missing CONFIG symbol
Date:   Fri, 14 Feb 2020 10:48:37 -0500
Message-Id: <20200214154854.6746-525-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 27796d03c9c4b2b937ed4cc2b10f21559ad5a8c9 ]

Without this the symbol will not actually end up in .config files.

Link: http://lkml.kernel.org/r/20200116064531.483522-6-aneesh.kumar@linux.ibm.com
Fixes: a30e32bd79e9 ("asm-generic/tlb: Provide generic tlb_flush() based on flush_tlb_mm()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 208aad1216300..5e907a954532e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -399,6 +399,9 @@ config HAVE_RCU_TABLE_FREE
 config HAVE_MMU_GATHER_PAGE_SIZE
 	bool
 
+config MMU_GATHER_NO_RANGE
+	bool
+
 config HAVE_MMU_GATHER_NO_GATHER
 	bool
 
-- 
2.20.1

