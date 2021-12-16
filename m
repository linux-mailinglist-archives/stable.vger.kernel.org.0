Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66024477D37
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 21:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhLPUPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 15:15:43 -0500
Received: from mail-dm6nam10on2066.outbound.protection.outlook.com ([40.107.93.66]:48710
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241273AbhLPUPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 15:15:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTmU5et5rFUJp9O2XXyCHJ5Lxii63ya5Gy/dGLNHmVg8YQKH4rZVm2Rq9/K4uP8WslY9o8MwRggEXSUsItCxEBlZeMnLXu0ojUnWoF0fYXxrS949edN2BZIBoXg3Rc03IE4+ADnWqbXLAl6hWbc5zW9WoVH+OlTPSxYgsqjMunsyQP6tTpygRlJNrm4KBZlJODJVMQCg+LjeF3FL+4ViKRZ2hQMNdj3rRdfuQuhrGbDmbQaYUya8BTRKqBhRSYPuXGMc+DgGBnkn6vtIs+FAQXiPvKnVfPg3BydYyipkn7JtvUs4oq/v3ZbgXLw8G/gKWzTlSLbqgym7QAbXZwJokA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOezxM1qcNQp91UmFNn9IPsPfgqa2KZWKNdToYCdR1Q=;
 b=OwRf1U0oiuLZJCGG73El1rPry9oWryJDNOnGVqUphPkS1Miu/4ce3DdIN9Bim2cDca7NVQJhFujtywlwRtY5hDqyphHr+9GmO66WUpODGWAfgz1GtAiSpp88tdVB2kmMJWOWtBk9rmZobSQIZ3IlM7gAlJN6UoyDsTPmlJT+1a1ic/kqaP+o8uql5gkHaVDOxtH2XzrCD6JC6scQgkgf+RwTGLb5Du1QM7Mfe5nbS/5GnT3x/X/vZSReeTt2rIYUyxaqHw8dHXYrq8e0WqIiODmDwIfPeEJUBb0SOTAOvziomK7NzJ72lKFwD56ndLKdpHU91xlCjSLg6lmCdL4Elg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOezxM1qcNQp91UmFNn9IPsPfgqa2KZWKNdToYCdR1Q=;
 b=R8ipgD0nVBSMSjxUHufRXHlvnRtd8s1FR3Lw9WEf3szMD6CJCqLRTw2190MIcBXbAzvi/w03hWg0QzU/+bYsj8ai5Php9kIiAs6aYj/eBWqpsLXXu8lU70xNggLK0wWv130uXZHU1gITuADtetDz4ql+50HvL3NXGpWDl51nyvo=
Received: from DS7PR03CA0291.namprd03.prod.outlook.com (2603:10b6:5:3ad::26)
 by BYAPR12MB3095.namprd12.prod.outlook.com (2603:10b6:a03:a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Thu, 16 Dec
 2021 20:15:36 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::21) by DS7PR03CA0291.outlook.office365.com
 (2603:10b6:5:3ad::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17 via Frontend
 Transport; Thu, 16 Dec 2021 20:15:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 20:15:36 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 16 Dec
 2021 14:15:35 -0600
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/2] x86: Make ARCH_USE_MEMREMAP_PROT a generic Kconfig symbol
Date:   Thu, 16 Dec 2021 14:15:19 -0600
Message-ID: <20aa49e158bf5ad18df99febdac0a93790e1a746.1639685720.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84f77109-1e14-4238-05e2-08d9c0d0d25c
X-MS-TrafficTypeDiagnostic: BYAPR12MB3095:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3095BE33B3B1E18789261397EC779@BYAPR12MB3095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XazUDc9GkOGrrI/CS84g+Jj5LdCWir26ri5YM0RIWjSl+27kUyXNUDG+NDMDjsB3a8NwOnJQJDapOWamK2D4rgxF1VoJiZmP1+RABouF9YTPLxET5cYJnbDXzvbbLUYb5sPkTwpW3BZCfP3sPy1KgLiPr/Jh5ZMvVXpbJBHtJfMr5D4EjqgZtRAps41ZaSdKRKmNjDovHaV9UjCzVd4BCKx5PqR+7uN6DrVG1cOkbdGPUKGNeR+TTbWdFlCoJYcCpAtKllrRT/YJNjJW+djn+1wqlpDPBqnZA05YJhV3JvzKRg9r0nRP4Q4ashMTVGe6tMWrxG3eaiakD4xtjeU4es4owHyHq/1t6+cgOrs4+ZB4QJCP5ph561wyZV06Px3AUbaRj7LEeC0v7c0IqwmyQwTAyZ8+hWWFhOqTdiTKMMtRVap83mVuObkB+kVL/vbEjfPTaLhPpmHHL1Sp0GhwNtpfPDewrMpSt03hfAQwqDP/exGv5faQ1KydTJU1WeuV4puAv76sUobynsYhqJAE+ybSaUVWkbCkClQPxlZS/uNbN9PWXBy23tE3/rG2rgMSQrvIAnqT+JuRW71+rQud4qh3FKJFhvBN8yXxidWPujGlwrNcDIdZfDKgzKo97yKm1a/LMKrbQhUBNra7dK/jw3W3XP8vaC2auz+PNDlWlQ6NEgVI+lCQXsYOvnjcTNt8s0glKfughw1pnN+rokou+iOJFX9Jrk+lLWyVx06DE94gQr3VtHlasdk+mBCnYo4as78OCUbEDkJ834FAdrcPa5QrsWKFe7ZKw49veCl40bhw4OdVoqrasloWWayT5Zf2TWEeagjjEgnAsVpGwl9BDQzC9exw43BOW0MYb+8m2u+OewcQbq4FfMU74aswA98/X4SW0E2x6I98ceKqYG7KMg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(966005)(2616005)(81166007)(2906002)(82310400004)(83380400001)(8936002)(6666004)(40460700001)(86362001)(36756003)(356005)(508600001)(7696005)(186003)(70206006)(336012)(8676002)(6916009)(426003)(5660300002)(70586007)(4326008)(26005)(16526019)(54906003)(47076005)(316002)(36860700001)(41533002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 20:15:36.3518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f77109-1e14-4238-05e2-08d9c0d0d25c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3095
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit ce9084ba0d1d8030adee7038ace32f8d9d423d0f upstream
to be applied to 4.14.

Turn ARCH_USE_MEMREMAP_PROT into a generic Kconfig symbol, and fix the
dependency expression to reflect that AMD_MEM_ENCRYPT depends on it,
instead of the other way around. This will permit ARCH_USE_MEMREMAP_PROT
to be selected by other architectures.

Note that the encryption related early memremap routines in
arch/x86/mm/ioremap.c cannot be built for 32-bit x86 without triggering
the following warning:

     arch/x86//mm/ioremap.c: In function 'early_memremap_encrypted':
  >> arch/x86/include/asm/pgtable_types.h:193:27: warning: conversion from
                     'long long unsigned int' to 'long unsigned int' changes
                     value from '9223372036854776163' to '355' [-Woverflow]
      #define __PAGE_KERNEL_ENC (__PAGE_KERNEL | _PAGE_ENC)
                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
     arch/x86//mm/ioremap.c:713:46: note: in expansion of macro '__PAGE_KERNEL_ENC'
       return early_memremap_prot(phys_addr, size, __PAGE_KERNEL_ENC);

which essentially means they are 64-bit only anyway. However, we cannot
make them dependent on CONFIG_ARCH_HAS_MEM_ENCRYPT, since that is always
defined, even for i386 (and changing that results in a slew of build errors)

So instead, build those routines only if CONFIG_AMD_MEM_ENCRYPT is
defined.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Jones <pjones@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/20190202094119.13230-9-ard.biesheuvel@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/Kconfig          | 3 +++
 arch/x86/Kconfig      | 5 +----
 arch/x86/mm/ioremap.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 95567f683275..c2e73c01d7ad 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -980,4 +980,7 @@ config HAVE_ARCH_COMPILER_H
 	  linux/compiler-*.h in order to override macro definitions that those
 	  headers generally provide.
 
+config ARCH_USE_MEMREMAP_PROT
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 290254849f97..dc1a94c1ac3e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1449,6 +1449,7 @@ config ARCH_HAS_MEM_ENCRYPT
 config AMD_MEM_ENCRYPT
 	bool "AMD Secure Memory Encryption (SME) support"
 	depends on X86_64 && CPU_SUP_AMD
+	select ARCH_USE_MEMREMAP_PROT
 	---help---
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
@@ -1467,10 +1468,6 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
 	  If set to N, then the encryption of system memory can be
 	  activated with the mem_encrypt=on command line option.
 
-config ARCH_USE_MEMREMAP_PROT
-	def_bool y
-	depends on AMD_MEM_ENCRYPT
-
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 7bebdd0273d3..3faf9667cc40 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -626,7 +626,7 @@ bool phys_mem_access_encrypted(unsigned long phys_addr, unsigned long size)
 	return arch_memremap_can_ram_remap(phys_addr, size, 0);
 }
 
-#ifdef CONFIG_ARCH_USE_MEMREMAP_PROT
+#ifdef CONFIG_AMD_MEM_ENCRYPT
 /* Remap memory with encryption */
 void __init *early_memremap_encrypted(resource_size_t phys_addr,
 				      unsigned long size)
@@ -668,7 +668,7 @@ void __init *early_memremap_decrypted_wp(resource_size_t phys_addr,
 
 	return early_memremap_prot(phys_addr, size, __PAGE_KERNEL_NOENC_WP);
 }
-#endif	/* CONFIG_ARCH_USE_MEMREMAP_PROT */
+#endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
 static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
 
-- 
2.33.1

