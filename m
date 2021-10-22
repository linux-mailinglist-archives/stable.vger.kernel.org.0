Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662ED437B47
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 19:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhJVREw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 13:04:52 -0400
Received: from mail-bn8nam08on2078.outbound.protection.outlook.com ([40.107.100.78]:64355
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233617AbhJVREv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Oct 2021 13:04:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQLt6ZV8u6oh2uvHdcyMien5Z5mBjlZ2GVKtJfes8ja5/BcrKC7r99nxta8Bboc+WvO8HBdVfuZZcp/ZMSAxyJudkekKv2jdFAbP6/VIihZCCCJNTFWppm54Uf4+5NGbmsbz6H5GiBVn7a4LFWzWha9IhHtE/mpF6pBQCiG+FEWaHOAXq5BOIEexxsvDeYpzkqgKHxZsCgET2RcrGgQMbLaJCJkWIafyhHx/FdCoo6tLJlZakke8oY9dnCFcDyLl6VRFSHWqXX3c1Qq+et54JV3M8rgi9IdEmgTec1/R0yqzcDZgLO1DwWCfGQa6C72H0pieYsKTxtGMzHv8FoKQsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4WDGXrqj2qGbXh9cXJ09sPgaoeiQTVGZbGOAr6U8/M=;
 b=eXDPYG7vxztCuEzC+87Lys0z6lkhTQTSWKvpDoQ0MPQK6NWQPfqmQSkYD7AOZvMkjXi/zGkBbnHjWxhSK6IieNfW+cOveW+d1oqxihbYM+Ph1LsIDNm60mXlDo8Aql+sYprkkVmYUEuHwB5YqgdjJgOBWlahdIk6m6EHgGd64mFLRSMdHVkX9nbaubt49Ri+ciu8NvfK4gNy0fztbwEhI5H2alefJAsaGRTagEpQidGjM5j27JxIDxpfJUX6Wflz2O3awU6EhhVIA+tcj+NT4GWA+N9LZ/HiXrERhsvnF8rwEnOy3kVBKPQJ7SrGtg5Xy2w96vImPxNN5Ic4O7oACw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4WDGXrqj2qGbXh9cXJ09sPgaoeiQTVGZbGOAr6U8/M=;
 b=ZTwymFBMATdszDpkDISgkBW1FckAVxXF/V8jPMjZNrM74m3nk1AxME7q4BYIctLcaYB9Mtil/JSA5Ci6I5ed3dZFz1uq+hgN1ElDnoaK8OdtiJmydsfSEdTrfNo6ASThoJn1fmAYaofAuYOllxb/sfLtoXWUjuvmt/ap7P5R5sk=
Received: from MW2PR16CA0008.namprd16.prod.outlook.com (2603:10b6:907::21) by
 DM5PR12MB1898.namprd12.prod.outlook.com (2603:10b6:3:10d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 17:02:29 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::65) by MW2PR16CA0008.outlook.office365.com
 (2603:10b6:907::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Fri, 22 Oct 2021 17:02:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 17:02:29 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 22 Oct
 2021 12:02:27 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-efi@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] x86/sme: Explicitly map new EFI memmap table as encrypted
Date:   Fri, 22 Oct 2021 12:02:15 -0500
Message-ID: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 958d5e6d-b045-457b-3e43-08d9957dbb48
X-MS-TrafficTypeDiagnostic: DM5PR12MB1898:
X-Microsoft-Antispam-PRVS: <DM5PR12MB18985DAAD5F0DF91D39A8DD3EC809@DM5PR12MB1898.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mPAp1QUhGWZqIfjkiqhnFV+lE769tckX1lm1I61sJJo55rPCmfAsvLI+6lgknQiZyoLhtf6jh4TBAvNsSiQoJ6RE7lvIT6FGF2d2ubEG1EZkWJFQFMaNFCKbO2pl1ajqNVe9wpmSL2It0TP5MSA5QGohd5syym8/mVKtYoQN037kdGrzw76DwRVYBKeTw+bfrOhaXqeKUyRy6fiP92/oxgqLbqxfzfHNkqXggCVpSM1B+cZUgam31DkDhhARB4u3xJwVA2ua4B9WfGwT0BgE/dNXtNBNOtS+uUgnivse4D6n1/H6FyVVf2w3jl9eE16nNDguBwJkQzyAex2XBub3DPA6QWppwsz6J98LnDx8j6brB0hQmwiMal8WboMtDmnILO14kcS9+RU6POk7e8hFTOjjJZUsNZKjkkuknHsi/QovWhlMzx+zNjsnzzAGkSsWeAynI6NfME07gwYKzVLdiebG3td6XHJB42KcC4A7Z4lfeBSW/q1Z+NjTQAOYgrjk/3exqEAySEmaXRkEB+JoFhvVRWFyokL06B+xQf/haiWv57XmdIwgAbtxdYLMLgPIitAahcouV9+FfAf3tCUvhO7890FQJT+G4zL+v2Y3S71pHNvoaAzQqz7h9D81CidW5aUoiZMaaV8skLD2IhZBKpgEovwlLjcPSWxUHwmXCLP+ufG8riGIFQtklF4tXDcPU8Gri7lbi0uo9ncnu3g5ej91bwtyXepaMT/bpcdq8BQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(16526019)(5660300002)(4326008)(7696005)(70586007)(356005)(26005)(186003)(8936002)(110136005)(8676002)(336012)(36860700001)(2616005)(54906003)(2906002)(508600001)(70206006)(81166007)(82310400003)(83380400001)(316002)(47076005)(7416002)(6666004)(36756003)(86362001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:02:29.3321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 958d5e6d-b045-457b-3e43-08d9957dbb48
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1898
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reserving memory using efi_mem_reserve() calls into the x86
efi_arch_mem_reserve() function. This function will insert a new EFI
memory descriptor into the EFI memory map representing the area of
memory to be reserved and marking it as EFI runtime memory.

As part of adding this new entry, a new EFI memory map is allocated and
mapped. The mapping is where a problem can occur. This new EFI memory map
is mapped using early_memremap(). If the allocated memory comes from an
area that is marked as EFI_BOOT_SERVICES_DATA memory in the current EFI
memory map, then it will be mapped unencrypted (see memremap_is_efi_data()
and the call to efi_mem_type()).

However, during replacement of the old EFI memory map with the new EFI
memory map, efi_mem_type() is disabled, resulting in the new EFI memory
map always being mapped encrypted in efi.memmap. This will cause a kernel
crash later in the boot.

Since it is known that the new EFI memory map will always be mapped
encrypted when efi_memmap_install() is called, explicitly map the new EFI
memory map as encrypted (using early_memremap_prot()) when inserting the
new memory map entry.

Cc: <stable@vger.kernel.org> # 4.14.x
Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

---
Changes for v2:
- Update/expand commit message to (hopefully) make it easier to read and
  understand
- Add a comment around the use of the early_memremap_prot() call
---
 arch/x86/platform/efi/quirks.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index b15ebfe40a73..14f8f20d727a 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -277,7 +277,19 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 		return;
 	}
 
-	new = early_memremap(data.phys_map, data.size);
+	/*
+	 * When SME is active, early_memremap() can map the memory unencrypted
+	 * if the allocation came from EFI_BOOT_SERVICES_DATA (see
+	 * memremap_is_efi_data() and the call to efi_mem_type()). However,
+	 * when efi_memmap_install() is called to replace the memory map,
+	 * efi_mem_type() is "disabled" and so the memory will always be mapped
+	 * encrypted. To avoid this possible mismatch between the mappings,
+	 * always map the newly allocated memmap memory as encrypted.
+	 *
+	 * When SME is not active, this behaves just like early_memremap().
+	 */
+	new = early_memremap_prot(data.phys_map, data.size,
+				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
 	if (!new) {
 		pr_err("Failed to map new boot services memmap\n");
 		return;
-- 
2.33.1

