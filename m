Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FB94714E4
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 18:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhLKRTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Dec 2021 12:19:21 -0500
Received: from mail-sn1anam02on2070.outbound.protection.outlook.com ([40.107.96.70]:9920
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230343AbhLKRTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Dec 2021 12:19:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eg0FxGpuwYkd7HdaSETfzr4dHIXbhA1bpjsJfj5qwGIdsb9pqsFrzdVhMqhNwYfYo1ynMnOoyyXbwbRBuje98RCzrklkJZTNbHj+lrsXhZ7S1Ae20+a0Sxgj96gp5bGyThckJ7zEAj1aVDznG6oSgd9jTyiksV3m53RBNefNl6iLCEToYdR2Uxw7AmYSQlWcuy5jntjtQ9NXz5ps2xMIPRrLItdHtNxRP5CiSaAz/JZ2w96XSVWbXOLpMCL0nGeV5MrobxjY5ZlCN8RIe1HPI9+lmiBG9U3zlCdOe4TBwrfwV+YUvehEBv27QhEdzpL5NaSM0wOB77aQX40y4SBUUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9AZIqbkO6+yaQDsegpzyB1tjs5/9P0VfFT/4fkrfDY=;
 b=TRVNnRNWaoHk84LgelJjvxStyUDxnAPXRE8qVAWMb6EqAaQSLjAkrhWyPcpu4RkGdbk/VtNgLSc6bfSOYic+yL/nq46GXnZymwSn9pGxFFG1uZ//ncTyGq0im+KMogfVapFxY2sp5p6AFJu4SRx3y1bWChMrQfeyGroiM/P3xUjrbbZwaQX+6noxlVN8GmJyqRx46LNOei2/sIgvtYMAlMcu3rL9O3sy+xdqhXkHZGHfQjey53/ZZdU17wwApI4azrvhGh5+GUGUWWHh1kHw+5oSBBzrEfZCMXBvHeUvFsDgCNABcGI17Q989GrSwFsr0Qo6a5ko1QZppZbQHjdvqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9AZIqbkO6+yaQDsegpzyB1tjs5/9P0VfFT/4fkrfDY=;
 b=woSV9zRwu0jZr0F+cy6d5ZYotxWeKgdKx1zOWBDLaXNexPLq6wd+YSKMEMAx6B1g+j4PR5H0JtHhcKaVRpm/GpWoD7iYDlvPSCGnjd3kvKbYLj+QpnQYcZgOnc/DYjMoIqoQd4JY3s88b9GoogIjuS4rRhVepVA2La6EjVsJ9SQ=
Received: from BN6PR2001CA0002.namprd20.prod.outlook.com
 (2603:10b6:404:b4::12) by BN6PR12MB1602.namprd12.prod.outlook.com
 (2603:10b6:405:9::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Sat, 11 Dec
 2021 17:19:14 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::2f) by BN6PR2001CA0002.outlook.office365.com
 (2603:10b6:404:b4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Sat, 11 Dec 2021 17:19:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Sat, 11 Dec 2021 17:19:14 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Sat, 11 Dec
 2021 11:19:13 -0600
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted
Date:   Sat, 11 Dec 2021 11:19:00 -0600
Message-ID: <2e06a99ba4c4b1bc6663605414f7518e4c43d188.1639243140.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38c544d1-0b25-4541-2261-08d9bcca5aff
X-MS-TrafficTypeDiagnostic: BN6PR12MB1602:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB16024202378BB29584EA667EEC729@BN6PR12MB1602.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwCcXttoGTvYIL0dm2VSm94NSM0OVQZNLKczFv1+nOGFYLKHG7YSLXihvEXpHiMmUpM5fqdygo/zAtySAPsHe8HhQQpB3kK/HiGnd0mp+FW1EILQ3r16mbFO3VjEfa7EDz5C3xYvfAN5rs5Yeh3p3uwvFLdILq3dmfTBf1l1b18k/V5Pabr+rAYtM8+LHkVeEX1F9y21j7b/OOpW58sE0q2d9ZOj1dLZl9mhNIs2lHNtUGyUQz7w1iak8BDs+NwNvl/jMRzKrxJckr48sYenAb6+GQzb27+DX9qby+jTVrCefWiPf4KXQe+XWoiEUVy7wTNViKFM0zNEIMpIYUPftVx5Er8zCn6Mc3t2kVft6SgMSmqTvFNRYEqpM2djutslsgylofZlz8+I4rmmVD9MSwSMGcDWqchPkYJXPEfQ4RNA+efhY8pKjSBkSiq51XeaUOnKsdmbgUg1uEXwXiHUXZI3W0hEFUPtcBs+RyJgv9i27uygBvrRSFC5bOtM/5nBxxJgss9uZDxbLaLAroc+h2M/cIwBKPUJriSNUPyzS05F/YwQ7I7DTAl55Foj1ZJzpu+SNMG6v+s6syf3yIwQwFpjxRdxTlULCIxbzcaQpioIM5fBRh8qJaEJUpf0xHuwFcpw5Hffig4MouX1FlMlgC+YdDXpAOZTB1/YI6LLGJ7RcGuNYoCGd+JWvYcwDRAIeLh5mqz6g356+Xu9bQHnXzGKqHw5lBprvRsQNFH3OiSRuUFlSMkGRRZ+38Qc7Bx3TwccZXd6ACTQ7VPm8XjyrlVudF6Spwf1r7EQMaPr7sHLFWHENrLXSqmSIvP3ncv04Kt8ZfE51mjfOHYQ/JX19xO+CwNQbSTIvWrOKA2/XV6NTT4xC3NceRrPZpuIQJrp
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36756003)(81166007)(4326008)(356005)(7696005)(8676002)(8936002)(6916009)(86362001)(40460700001)(2906002)(82310400004)(36860700001)(316002)(2616005)(70206006)(70586007)(336012)(426003)(508600001)(6666004)(966005)(54906003)(83380400001)(47076005)(186003)(16526019)(5660300002)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2021 17:19:14.5257
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c544d1-0b25-4541-2261-08d9bcca5aff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1602
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1ff2fc02862d52e18fd3daabcfe840ec27e920a8 upstream
to be applied to 4.14, 4.19 and 5.4.

Reserving memory using efi_mem_reserve() calls into the x86
efi_arch_mem_reserve() function. This function will insert a new EFI
memory descriptor into the EFI memory map representing the area of
memory to be reserved and marking it as EFI runtime memory. As part
of adding this new entry, a new EFI memory map is allocated and mapped.
The mapping is where a problem can occur. This new memory map is mapped
using early_memremap() and generally mapped encrypted, unless the new
memory for the mapping happens to come from an area of memory that is
marked as EFI_BOOT_SERVICES_DATA memory. In this case, the new memory will
be mapped unencrypted. However, during replacement of the old memory map,
efi_mem_type() is disabled, so the new memory map will now be long-term
mapped encrypted (in efi.memmap), resulting in the map containing invalid
data and causing the kernel boot to crash.

Since it is known that the area will be mapped encrypted going forward,
explicitly map the new memory map as encrypted using early_memremap_prot().

Cc: <stable@vger.kernel.org> # 4.14.x
Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
Link: https://lore.kernel.org/all/ebf1eb2940405438a09d51d121ec0d02c8755558.1634752931.git.thomas.lendacky@amd.com/
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ardb: incorporate Kconfig fix by Arnd]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/Kconfig               | 1 +
 arch/x86/platform/efi/quirks.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c2a3ec3dd850..c6c71592f6e4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1990,6 +1990,7 @@ config EFI
 	depends on ACPI
 	select UCS2_STRING
 	select EFI_RUNTIME_WRAPPERS
+	select ARCH_USE_MEMREMAP_PROT
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index aefe845dff59..6ca88fbc009c 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -279,7 +279,8 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 		return;
 	}
 
-	new = early_memremap(new_phys, new_size);
+	new = early_memremap_prot(new_phys, new_size,
+				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
 	if (!new) {
 		pr_err("Failed to map new boot services memmap\n");
 		return;
-- 
2.33.1

