Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8198D477D3C
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 21:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhLPUQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 15:16:41 -0500
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:35457
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233571AbhLPUQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 15:16:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MClHVVEGUB67xwpTtpJUgr27S5kzmh3PFNfvTJvvnnn3XS5j9b1O+PoDttCHoiVJbcUCRSKkc5sQbnPTqc6y4APXjlMCSnS6oXwmrkvnhG2GdCIh2W3P/UKnYnAETrZg2giZLaWOabDl9PCGaw69Z8zYOwocRC0H3alo3xuEh7C/N5MoSzGjazcxleE3Z1Olk9b+UVqR2mEBt3B+UCFKNx6wf5bLhyMJZjPEe2O2uzcWPCiXyyAJWiUiAAbRTycVlN6PisFPe5cYpROaMBZoSPfRg9g94ocs69XtXhPw1Qs2l4B2nhlqBgYk+PoTNlGE+oZNQ7jqehlNv+o69Oqm6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbZxMspX7HlCogJdx+OGfFGDMsh4bFkTqzRKDLN27iQ=;
 b=VdcGywlJ2Q2AKKW/+htJmTuvTNx37YA6QirLCU8W8gMBRgWWKeeTaH5VP6FGP5t8JmKGUqwkL9wyKplhoMx+hJI3ma3MVwc8Xv+vh40dBLZZdtIncgTNzXaa3kjtUDxRjiGEs303pmgRxXyyVmEqa/6ji+Wxo57ubaLc20QrZa/xIEOvhGch2MwHgMTeH1LdyGn8S20Xtl04MuNktW/SalbYjmJUdxvEKDldvAcLI9FnyVnhXQ0Og0YFFRPEzN09pxLYf7YW3ypSn8D/Cbfrgxzqb1Uhhdt0GdNThjPaeNAOjw2NgwCi1w3ncJOhIbyjI26kDKpMvVBPh96XjFiM9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbZxMspX7HlCogJdx+OGfFGDMsh4bFkTqzRKDLN27iQ=;
 b=pLesI/Yn6uuaGKjIABlOk5a2fkhamJJ7cL5xJZdWsua31Tytyzehc4ZxKuTTZAkBmalKJ98yjuoZYdtxiPjazMzb4HVVupKij1AZ/FPprhDBpxu96DurLf1IjoGb+e6rrQYUxX93mnc7jy70TY1gS3LXMLRDnO5bx8xkIM1f5yY=
Received: from DS7PR03CA0171.namprd03.prod.outlook.com (2603:10b6:5:3b2::26)
 by BN7PR12MB2833.namprd12.prod.outlook.com (2603:10b6:408:27::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 20:16:36 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::56) by DS7PR03CA0171.outlook.office365.com
 (2603:10b6:5:3b2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16 via Frontend
 Transport; Thu, 16 Dec 2021 20:16:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 20:16:36 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 16 Dec
 2021 14:16:33 -0600
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/2] x86/sme: Explicitly map new EFI memmap table as encrypted
Date:   Thu, 16 Dec 2021 14:16:19 -0600
Message-ID: <a9eb090567c4f5b10644b27ef8a04c914e766d4b.1639685779.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <e08545b502f177e5905aeba45ef31fab3e933e3b.1639685779.git.thomas.lendacky@amd.com>
References: <e08545b502f177e5905aeba45ef31fab3e933e3b.1639685779.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ac74245-2af2-437a-064e-08d9c0d0f63f
X-MS-TrafficTypeDiagnostic: BN7PR12MB2833:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2833AC98328ADD0F13F0E7BAEC779@BN7PR12MB2833.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksW3KNX+kXHckSwMCpNxYj1Y1AA+MzLKQ6Cj0EOp4Y6aWG4Reryd0ewUC3QkcfWfPruv3NXeWiE2ciLxVE3YxmQWOGMqeDFwaH6sfTZdWHX3Ge8wLDTUDkAvSPOP+0wshLOY2MxOGKRd+iIpIqU9CclEwzlBjQAZckUhk4omq9HtnHAo4QnB/0RT4XS9Fxr1VNk9sf5RTaKQ2B8PqTnAqgpYcdDHexWh5x6KqszABLSzI5V891U7Z7nRVvVgJqbsU9TTSnhI+2J5oWuNpBD4zopKoS6BTEUXkk23Y3gW4TWwvYij6I3p1jtzj0NxHEUqklfjZ9MnE0Zfu6zbj5jHTPxw3rV0AWZTZGINmfSZc/2UAP2hA683c0nI4auwxWPN6pFLdhJMd/quhjwtxNSpTVo0Ybav2e7J+YG0rvSYy5rogyWjcr209ObcGoWVQdViNrdkguFcSSVzuDGLr/TYpq070F7YPc8Summ4l+R1r+wOhMmnWDLpjM0npYTj+VQnWT9HLggvHOaNT6lcEgDqYXRq/9KZTzjKKyjRkEpMssUmC5wLfGRXAaZEawysqb1toftSLSF7CK2qrdkJ8yM5OHfJo/r+prnGH7j3hSYW+OHyEn+VVbgPFQHNgk8qnYneKjEaY6PpFTpcZELSvH0Q/19pRNQJVMSC9xCAL/xGxBt9CvZSz1t3pCsaQr8C+W8IhwYS+/7LFbriMlJz9LI33t+GmI8dbcDbXXidKxYFl/cYloWowMkWHPM7vYDnels60sChbvcALNyGDNrPeidQxJ8vZPJu3baSiOQ/oly6Ed5uW8zcLrOWCe8u21o4nIXIx3i/eUREPNrneh0KBjOakiUhiPiqYdVLBEJGBlqTbmAFYf09bumPDwBds6nQ2bZI
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(356005)(186003)(7696005)(6666004)(6916009)(83380400001)(316002)(4326008)(47076005)(2616005)(36756003)(70586007)(426003)(81166007)(8676002)(70206006)(508600001)(336012)(2906002)(82310400004)(40460700001)(8936002)(54906003)(36860700001)(86362001)(26005)(5660300002)(966005)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 20:16:36.5910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac74245-2af2-437a-064e-08d9c0d0f63f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2833
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1ff2fc02862d52e18fd3daabcfe840ec27e920a8 upstream
to be applied to 4.19.

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
index 3bbd47a7d495..be4403a8e1b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1950,6 +1950,7 @@ config EFI
 	depends on ACPI
 	select UCS2_STRING
 	select EFI_RUNTIME_WRAPPERS
+	select ARCH_USE_MEMREMAP_PROT
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index c9873c9168ad..006eb09e9587 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -278,7 +278,8 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
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

