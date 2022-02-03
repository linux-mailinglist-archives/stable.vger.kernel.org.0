Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7500F4A8D7B
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354195AbiBCUbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:31:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36082 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354170AbiBCUav (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:30:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA57C61AB6;
        Thu,  3 Feb 2022 20:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3510FC340E8;
        Thu,  3 Feb 2022 20:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920250;
        bh=ToFmY0CrD+Ebxp7v5ksgT6MOXOiIoKyIqZF3W1YhNiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHGWmg4rIpzOLJOs2IN8Bj74ouVS4ItidU0eVuxKa4uoWb4mLu0JJGpWtNMmLdFAR
         AJbH6oqBg5Pkp1fhSkPnrYDmSfvoa+CP6c1CCPs62DmFculxMzVWt5fAGjINjmmPnF
         SAwyJVgv3SN0o+rz9GNYo3IDwHGMYM+u9VG/1hBZ5t+RTEgRhslL60SSVzPezyw+gy
         GTTmP/LzqaHFrfSxdGefCIStZ0Lxus9MhE8yILPpluGWpBaVEv4Q9jAp3sX4o27+sf
         R/z7Km3y0UQhwY9Lk7MqYsy63BNd5h+HOXSCNJwfH+1Fk2uNcXmLZEkUtOHURjrGOt
         WdtythqNA518g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, mathieu.poirier@linaro.org,
        marcan@marcan.st
Subject: [PATCH AUTOSEL 5.16 24/52] arm64: Add Cortex-X2 CPU part definition
Date:   Thu,  3 Feb 2022 15:29:18 -0500
Message-Id: <20220203202947.2304-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 72bb9dcb6c33cfac80282713c2b4f2b254cd24d1 ]

Add the CPU Partnumbers for the new Arm designs.

Cc: Will Deacon <will@kernel.org>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/1642994138-25887-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 19b8441aa8f26..657eeb06c7847 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -74,6 +74,7 @@
 #define ARM_CPU_PART_NEOVERSE_N1	0xD0C
 #define ARM_CPU_PART_CORTEX_A77		0xD0D
 #define ARM_CPU_PART_CORTEX_A710	0xD47
+#define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 
 #define APM_CPU_PART_POTENZA		0x000
@@ -116,6 +117,7 @@
 #define MIDR_NEOVERSE_N1 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N1)
 #define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
+#define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
-- 
2.34.1

