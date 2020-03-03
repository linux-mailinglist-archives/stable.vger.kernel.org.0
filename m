Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03680177FEB
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbgCCRxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731615AbgCCRxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:53:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D878620CC7;
        Tue,  3 Mar 2020 17:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258015;
        bh=nWKwmnt7V+VmRBijgT0w4CKnk9ky7pcdeZKE9vO47Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmRB0YC0UbM+a7ExGSqYoKo89W1FafPLpNZEKArpnpaQbmsF3GsH+YUXasje1ePvg
         1/+ZslN/WZV7qU0h4+tXbMaKf2CwhsTcjxMpjbKx4UNRBnTJbsYjmXHbf9d0IizGTf
         2sFmBjwkHp9L1OgQdq163NNKNbWYQhlyYaB9zD6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/152] perf/x86/msr: Add Tremont support
Date:   Tue,  3 Mar 2020 18:42:16 +0100
Message-Id: <20200303174306.748067715@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



