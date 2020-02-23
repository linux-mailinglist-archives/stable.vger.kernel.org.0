Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9398169547
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgBWChR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbgBWCVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:21:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BE122067D;
        Sun, 23 Feb 2020 02:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424503;
        bh=nWKwmnt7V+VmRBijgT0w4CKnk9ky7pcdeZKE9vO47Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqtX06NGgtr4eVNBxu5w9d7GXKvM/N3aLNhx+53gNfRQu6B9NAVsKC6ib2q70mYuW
         SkRwzpAqvGA1y+toGeXQ1vmNxdytC13jhj/y1pZNhDeOfaLqIM1Zbj2PLgHC6tAz9u
         OdIxNsrCDwdxQronnBcnBj0WZUENLmZXQu8wbLvA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 19/58] perf/x86/msr: Add Tremont support
Date:   Sat, 22 Feb 2020 21:20:40 -0500
Message-Id: <20200223022119.707-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 0aa0e0d6b34b89649e6b5882a7e025a0eb9bd832 ]

Tremont is Intel's successor to Goldmont Plus. SMI_COUNT MSR is also
supported.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: https://lkml.kernel.org/r/1580236279-35492-3-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/msr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 6f86650b3f77d..a949f6f55991d 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -75,8 +75,9 @@ static bool test_intel(int idx, void *data)
 
 	case INTEL_FAM6_ATOM_GOLDMONT:
 	case INTEL_FAM6_ATOM_GOLDMONT_D:
-
 	case INTEL_FAM6_ATOM_GOLDMONT_PLUS:
+	case INTEL_FAM6_ATOM_TREMONT_D:
+	case INTEL_FAM6_ATOM_TREMONT:
 
 	case INTEL_FAM6_XEON_PHI_KNL:
 	case INTEL_FAM6_XEON_PHI_KNM:
-- 
2.20.1

