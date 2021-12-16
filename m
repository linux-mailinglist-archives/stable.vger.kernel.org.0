Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C69B477D3A
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 21:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhLPUPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 15:15:51 -0500
Received: from mail-co1nam11on2047.outbound.protection.outlook.com ([40.107.220.47]:3744
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241281AbhLPUPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 15:15:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7JfBYP2LSW3G1a0qVwVRyGWE9dgl2UzF4HZnpWqtdxVwvilgjbyejyVMstrgo6mwcJEHfdg/ztqYcrB9cb0tM81yVzXjBQiE4SRPCwEvjnuo9UaP3KFzXA/x8BhDZkAwyEpMSXEVCpdtSVkU7Y/6NkNuUIIFCwEasaOBtc/KPfB1COPx38IAE+BfWaga2w4Lzo6dL9LJ3bzgx8yt+Kb+t60dd0cIHrVmF9XKXoQRfmUhekMfwAU/gHxV6jVdWe0YVVfPN2nE1knfAzriun7JW4wJ9hTEsaTND/zfvkXKxXedTZIPky3NCBH2OJKuQK1+PQDOJEOkXOs/10rvp1Bsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ts1IYf1P3QkMG6MI4b91cqdwvaqt0+ugAbvE9aksAaU=;
 b=L1jMMq62n36+s888V3TqEns0WVp3xsPRL9IjzRNlknwHUv/mE1jveIFzVwMOr6MtESKr14ZWWk7DOVk0fzvwyuVyiH3sANjVmalD4cixXS1MiakURWgfCeMmHE047GBN27U6eDDjs59CQGKqQ1eKoOdB8HyINXUSGm7saqEq5EgiPKmQRx7tbqO81riseo9VPfMiagEnAylNuBOCMlIMZMjQMEzXhtyJmZe80SHtO484W3E8Je3Julku9j0bFXwyY9TcNrG7mNtfFo/wcLgJD4HsHCs/vPXzqD2yRLt8peBeo70Y69SGMVpXJHqecjH4g08sfS4yc91+2MowiLstMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ts1IYf1P3QkMG6MI4b91cqdwvaqt0+ugAbvE9aksAaU=;
 b=tMtVh73VH7wFaX4O0hE/gr1sm0TI/Woo2NQkIEAGE6+UJkuSqZ/L0qfObZi+9oWH4AgeRHuWLuAgVGo6G7PZMa3T0y+lL4ZrLZiUKvZJinEhN2cv0G3KHkbZRmsgi6wcIlkjtSekqmMoi3my/QD1hAW4EdieqmxEV7SHoJDaTMI=
Received: from DS7PR03CA0272.namprd03.prod.outlook.com (2603:10b6:5:3ad::7) by
 CH2PR12MB4953.namprd12.prod.outlook.com (2603:10b6:610:36::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Thu, 16 Dec 2021 20:15:44 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::43) by DS7PR03CA0272.outlook.office365.com
 (2603:10b6:5:3ad::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15 via Frontend
 Transport; Thu, 16 Dec 2021 20:15:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 20:15:43 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 16 Dec
 2021 14:15:42 -0600
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/2] x86/sme: Explicitly map new EFI memmap table as encrypted
Date:   Thu, 16 Dec 2021 14:15:20 -0600
Message-ID: <9ec3287cf33d59463c14143de583ecb5016ee34e.1639685720.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20aa49e158bf5ad18df99febdac0a93790e1a746.1639685720.git.thomas.lendacky@amd.com>
References: <20aa49e158bf5ad18df99febdac0a93790e1a746.1639685720.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6e43227-2ee9-43fd-7f6b-08d9c0d0d6db
X-MS-TrafficTypeDiagnostic: CH2PR12MB4953:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB49539FA3C71D5D18490ADA7CEC779@CH2PR12MB4953.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QGuhL36SfAeyoXMQcDsbj24fYDYJMO3P4asE8VGSLbW+H3dQB+pBlW+aVZWlnvDzFzZBRO5qUIGnSKNHiz4yOVko38EeTmbJJ0mnZft7XZGXAcAA7YHwRjVrn2hUahBSqk3EmBwUgGcTWNc8DfuzWVGLYHWLME/N2cbl1f93G6fO5rFRFUUk+f+e4sKDydJoXGhRXE/249cEAvV6xKaPsM68ri80gQtAeZUNnkKMRZd4KM5BIHQDrd5qXO4NxBhfSrYDzY0LAvumMnUXuOAErZumDjFCHsWvpEnAX/yyrPY2OxlRHLX4V/dI4zMytBkZAjgXFUo6P72Jk5WgnuKbLzdZ9qSgPe/3C6wyZWKHkdRM+86a1Da2vB7Gz+KPSeMGYqcB0Ig1RA/h8QJmG2rSxOS+y+4HiTfw9UxzQmnPCwnNZ1L1SRs7j5kt6UH02iqzBdEoswngTZDUgZ6lQSCLanARodxVZJC75DmyAFOA5JowOLQOImK9J526UqJRERIxbKGSpYiWMKi8oOcLEMHL4lqau45WgSKlkQ9BlCIXuxyuwH/h25VjEk9VuY7FldE2L0Huv0V6M/Ee5pAd5rKz5tTUjDia8WXx1JBukezRmuAvUCMPXHNqz2Hkjw4FfWYboO0lQGenIXiT1lRxqqo3CPosCYtFAc8YEAolda/Pb/WuLZYNm5IYJqNnndBaUYCYTbXBgGfrbF1s0IOef2fO8aAZ5T9XNycsBHCeWUmhUAMR3Q6TeYjhdDId1R8DfxLOJh9NJ5FUgoIvCztnLifcj+8xQENF7vpLWL8H/UrD5yScEWfG3/rO5VjeAblUErD38e1PiNZPncnjzvjJAdEDq9imWqd5Y99wh6oXrZGh9aPke5C+b+vo1OUWxqHNejuu
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(83380400001)(7696005)(82310400004)(40460700001)(54906003)(6666004)(81166007)(426003)(86362001)(966005)(5660300002)(336012)(316002)(8676002)(6916009)(508600001)(36756003)(8936002)(2906002)(4326008)(47076005)(186003)(2616005)(70206006)(70586007)(356005)(36860700001)(26005)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 20:15:43.9294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e43227-2ee9-43fd-7f6b-08d9c0d0d6db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4953
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1ff2fc02862d52e18fd3daabcfe840ec27e920a8 upstream
to be applied to 4.14.

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
index dc1a94c1ac3e..6301a8d2b87e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1900,6 +1900,7 @@ config EFI
 	depends on ACPI
 	select UCS2_STRING
 	select EFI_RUNTIME_WRAPPERS
+	select ARCH_USE_MEMREMAP_PROT
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index cadd7fd290fa..2a4ad0606fa3 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -276,7 +276,8 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
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

