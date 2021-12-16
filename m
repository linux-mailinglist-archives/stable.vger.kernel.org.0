Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4A0477D3B
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 21:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhLPUQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 15:16:31 -0500
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:37557
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233571AbhLPUQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 15:16:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HD1Z+CR2JeXewuDeiwXn/6H67WwHbjh24ZOC9nWBPzRo4uLwEyBF6P2uSMN3ZkU1Wp+J2fzCVeNQkq4rXmAlZOmEGttwWqYU3lSMRYesG7igRxKMpx/gHlUOgvUtsmZjB4O1vU+p7liQuf89GxUG3P+G0rS7XtTOjMktEoS4Te/qVColK28IKnGSbneLtHAbPL+jIAhNnKBaeJ6lIKzfOVWBEJEoq6qOiLm5AiVrFFCIXT4vu03s3t7OwzuS16yGSJR36DZr8eZzwBCNKyatkfB8YbXC9qgnjrQ6342NigR7FapR4ebVMsiTtzB8/wWhgYDxCbUuTg0DuFErfspNjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRg7X4W0k/09ArnQh5Ebbq3a699D2dWR5oc/Df3g+e4=;
 b=HzN1p0MAjXCz1Wxj93m3uKYu5+413tdIiA0wTuyyO38WpE3TJiTntnXkeWKJRwU55ULmueO3beZcPDjdp7mrDL9ih0fw4oiCZtLDxiYzXT0AKxRJeMAemF/bJfFIak6eoT/jW0mGssRZyh1BiEUpstMt1+iJqe3zVMqBxMUW5d8M+HfKy+Hak4PVJzPUgBT6UEwYWqigZPMBZjzQmvE1D/BeS7p/Uw8oLiryoFEpcXiRFk3Xjrm4Fh/sl5CifnoCrAS9Bgiwja+0SwzbhoqnHNYvns4VBC8orr+1pml0vYSan8MYDhD5Y2McGxmSYk2JOv32zC76acRmCBw3CewQdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRg7X4W0k/09ArnQh5Ebbq3a699D2dWR5oc/Df3g+e4=;
 b=IDfkD2fmsWh03MDPQCeekgIyeCb+ISwVgIsyeZgEqnVw9Fnrd/385WLf2NNjnCDMb5UcLNvc1Gc8aLbbVnSsl7i6dsuQxiN0rQsbm8ALpxhR8j0zajC15M2doOGCKyTiZGunb3XTk8CRhJvbNrojWdeoGgWZMo9G4yGi+8NWZJU=
Received: from DS7PR03CA0167.namprd03.prod.outlook.com (2603:10b6:5:3b2::22)
 by CY4PR12MB1511.namprd12.prod.outlook.com (2603:10b6:910:4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 20:16:27 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::3e) by DS7PR03CA0167.outlook.office365.com
 (2603:10b6:5:3b2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16 via Frontend
 Transport; Thu, 16 Dec 2021 20:16:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 20:16:27 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 16 Dec
 2021 14:16:25 -0600
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/2] x86: Make ARCH_USE_MEMREMAP_PROT a generic Kconfig symbol
Date:   Thu, 16 Dec 2021 14:16:18 -0600
Message-ID: <e08545b502f177e5905aeba45ef31fab3e933e3b.1639685779.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1c83884-a06e-4341-95b9-08d9c0d0f088
X-MS-TrafficTypeDiagnostic: CY4PR12MB1511:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1511730282AEBBCB3112063BEC779@CY4PR12MB1511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjDtDMHUhblksXMGAjYdmpUSNN1YkyTRusRCG53csCBebJZ07T96ZYAi6fg0xwEpXIXyI0syUMkrMLUN5Ep0OfUiUk8IHAUcr/9lW0ufuaa294nPXGwxV0wXKsnCEZ4okGT+XUAch3hsHKnaKBU7PSrZmd6XdRmi82F2BSwXkBhDVZgrOBwOHSGmHmbD4RuZqiK7raVOfd2WPCd1mtscdwTv16v6Eu5T90FKSu+OqQW2P9/SISJrPkuXg7f3gOusXwWnublr4G4UZ5bv7iurl/vgjEH0ZAhzteEa8KcJgJbc0/qy7eikKjZ1KFmGHZag/faj/IBU2+KsUeZtzG7ySTAzRrUbBCG+GY0bNcFPersvy3KkAiNF3JZW0QioHeUs2w0UpwPO0MSrhiNuKS1ALvmj51VYtks8hSrUSoSrpR/C0tuGfpIedFfTT8tGsT6OLs739dsDFinOTraGYl5lPV0zgsd8oUeeCyMbyhq2dnaJNVV/YI2e67bihouOsmOobR1190AuhGtEdSMOok9ZaUp06otWCANXqP97XBLoGwD8ezP9FvlXf9HBedxEErQsA3JkvcAg5YbUF+V5sbNb+7/K/pSC+OZAufmmiepaXpWf1TzgFBRJtIL1aWEd4deOVEHgXIHku/zzLjt6pshxz/omJUOrUo/wET27T9uhEdA4ED0oj404bh7KugN4J+duNyy+RjERQLsUs3xqjGmCGKrx6zJz2bCf0PJXP9oiuq9ReRDbG/8ACJrNp+2qYwtlQdKYo/1FhTZSCz6nN6TJyimBMwPMfL35NqfqWl7p7gJg2Q1Fel/j8IynUd1opnBPNe5j7knlrZYfqz1eZS0M26495lHP7pZ9Pr3JQBLaWnYST98F38D0eAH2yTZEaX9+0mfrUIU7wJyFVAD0cNbFRQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(54906003)(8676002)(4326008)(36860700001)(356005)(426003)(8936002)(2616005)(47076005)(508600001)(966005)(81166007)(6916009)(70586007)(40460700001)(316002)(26005)(86362001)(186003)(2906002)(82310400004)(70206006)(16526019)(7696005)(5660300002)(336012)(36756003)(83380400001)(6666004)(41533002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 20:16:27.0068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c83884-a06e-4341-95b9-08d9c0d0f088
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1511
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit ce9084ba0d1d8030adee7038ace32f8d9d423d0f upstream
to be applied to 4.19.

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
index e3a030f7a722..dd71b34fe4f5 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -870,6 +870,9 @@ config HAVE_ARCH_PREL32_RELOCATIONS
 	  architectures, and don't require runtime relocation on relocatable
 	  kernels.
 
+config ARCH_USE_MEMREMAP_PROT
+	bool
+
 source "kernel/gcov/Kconfig"
 
 source "scripts/gcc-plugins/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6348b0964e9c..3bbd47a7d495 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1489,6 +1489,7 @@ config AMD_MEM_ENCRYPT
 	bool "AMD Secure Memory Encryption (SME) support"
 	depends on X86_64 && CPU_SUP_AMD
 	select DYNAMIC_PHYSICAL_MASK
+	select ARCH_USE_MEMREMAP_PROT
 	---help---
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
@@ -1507,10 +1508,6 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
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
index c63a545ec199..adc77904fc3e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -697,7 +697,7 @@ bool phys_mem_access_encrypted(unsigned long phys_addr, unsigned long size)
 	return arch_memremap_can_ram_remap(phys_addr, size, 0);
 }
 
-#ifdef CONFIG_ARCH_USE_MEMREMAP_PROT
+#ifdef CONFIG_AMD_MEM_ENCRYPT
 /* Remap memory with encryption */
 void __init *early_memremap_encrypted(resource_size_t phys_addr,
 				      unsigned long size)
@@ -739,7 +739,7 @@ void __init *early_memremap_decrypted_wp(resource_size_t phys_addr,
 
 	return early_memremap_prot(phys_addr, size, __PAGE_KERNEL_NOENC_WP);
 }
-#endif	/* CONFIG_ARCH_USE_MEMREMAP_PROT */
+#endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
 static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
 
-- 
2.33.1

