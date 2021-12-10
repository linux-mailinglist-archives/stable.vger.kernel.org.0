Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33584702E9
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 15:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241946AbhLJOkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 09:40:03 -0500
Received: from mail-mw2nam10on2079.outbound.protection.outlook.com ([40.107.94.79]:14721
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238575AbhLJOkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 09:40:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkPEnwpVyofyXmn8thLiU9fV2K+XOrBRPAI5M0YUGKxJ3ZqWUWgTfe9v+LVpOVQWcFqC35N8rR/0bYaUuJrlJ0zH92PLhFoSQXH7STm0o38KMdYYyBkKRCJCqYvU42Ipqz1Bgb57Os61YHIabIN0rrt77b/XSLfrcsR2s5Vz8Y9UXsOlk0MBuFD6p9vIsc1sEe2DW2wljM8Ns8G9+kXJh8s5TEoXKUBmzpzQk1VUeUqNZB7Ez5l/nebQY+7rhMp3kNFopPF5s7AGCCazFZoemVEauBcyViWIgMHgO/796XQAGgirdDb1ndouPkgMktuRf5xNhokXH2pcJ8X2RigkXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sn8euhzdbIQVvBBtIXFEuvHer7WBXytVkrqwNc191y0=;
 b=FSCocKmJ5d6AIcz9NBKGgQcKp0BpKxHlNNC/LppUO5DNDgnf+wVHGJLb5jZSQqF9AdZXQtNF1o0PLmOy2Lv1CtNRTWqu0lPF8EhMe2aAChREC3+jQLZKrNccoEl14waqV1vGy9mv4CKdVvxUCHb7MNCT3fTrcOQfmvnXi6G9q0cwM95aSCHd6D0kz8b6fcE8LyXdTEzJOy4k0KuohpMEr9nmNRkbYr7dhjjYFWQZ755ErH4X398j0028Rw2/9XeP07mYeXZ8i+pF20GQ74Xvo0JdwM/yb0VfXn9P5a/EEQEsY7VwjpBtgo4vKBYTIWcuDGfRnLQrYTY9/l2HdIzavg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sn8euhzdbIQVvBBtIXFEuvHer7WBXytVkrqwNc191y0=;
 b=Kt4AH/RIgWSHLolQF6fWhocEViLiO0oEP8/CfWtnq5voAEkk/K1x91gO+dk9IWQjOzyyo2ELlhLjYiYeIiiPr7B57KlSXkp4clrOCRFFC+L4MBZoQCsb6QXH9MttU/OwS97ep/a5DRu71nQKdnTvfBJA1ONtRLTRq6xnKmhLxu4=
Received: from DM5PR20CA0009.namprd20.prod.outlook.com (2603:10b6:3:93::19) by
 PH0PR12MB5418.namprd12.prod.outlook.com (2603:10b6:510:e5::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Fri, 10 Dec 2021 14:36:26 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:93:cafe::64) by DM5PR20CA0009.outlook.office365.com
 (2603:10b6:3:93::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Fri, 10 Dec 2021 14:36:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Fri, 10 Dec 2021 14:36:25 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 10 Dec
 2021 08:36:24 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        "open list:X86 PLATFORM DRIVERS" 
        <platform-driver-x86@vger.kernel.org>,
        "Shyam Sundar S K" <Shyam-sundar.S-k@amd.com>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] platform/x86: amd-pmc: only use callbacks for suspend
Date:   Fri, 10 Dec 2021 08:35:29 -0600
Message-ID: <20211210143529.10594-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb6a1f4d-bfdb-45df-0330-08d9bbea7214
X-MS-TrafficTypeDiagnostic: PH0PR12MB5418:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5418F19B1B0CC35002D04DFBE2719@PH0PR12MB5418.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b5YcOe6XyDpI4eu1lC2SNZyi/8janK60LX6YwjcZ6azPpQSohxUfbwn5GTzpSTHjbZhNwMogcwN0g1xS6BFk98eVe8F0GpgK281o9S4V8V2qA9692N3XUelUmRIpX6QkJE0+PELJG8S1gcNbnc9uEmVvqXNCq3gstRoyMmX4tePJfGih8R9artCkFQZFrFbQW9zlzmE4/AK2vqw0wl/3pl3qs5Dslo1b8UKp1mLFSKpK63BOfWpAy1w1zNbnwTvQg4Y6ywjGID/Fx92xC0slzjZPtjVATD7N12LhlZMqHQ+RYAcqXualAXLjw1T5vqrCqzeo8gj0SWIaDw2t7sgSDlzoIN3cyZH5Wr45+5K/oECbruNuWM1Hu1Bm+0rL5W+kCqk6j2K7nqP9hlibIsGIB90VMI9CMzV91tpUkQtbsUPfHCIm4KKepGYbNKy/z3GgHdNQGIQHX+gWxBPCsBHY5/bW6B+D3BAFyO07vPWaaCUw39cfknp+Wdw+Mnk3HjWOnbw7ZHUHnZg3QhxcriRuwalU4Q/Em3XXHS8106yllLSkNZi1tEVFaJkmgYKIZrNhmzeZL4lnyTwyHKd1upXIvbntu0PRAK5WMkJX9oj+jctpCFdxpsebimEFv4P5DINtYMTFoh3PsxB/FeyqFNqj44sl29sbfjw6qJ9Lkl+B8N9L++mxtUPerPBQOwVdxtBLPvrIUiyhUcBL8U6KIIytbVUR7IpJefbYv52SClopyOFgYRFViBj7Ywe+LcpD8pdaPQ94zU/ZX2USuSsXSwIDxL5l9KiN7hmLWVvaKfBjKdQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(5660300002)(8676002)(54906003)(356005)(186003)(16526019)(15650500001)(2616005)(7696005)(316002)(426003)(336012)(8936002)(36756003)(81166007)(508600001)(44832011)(26005)(4744005)(4326008)(110136005)(2906002)(82310400004)(40460700001)(70206006)(36860700001)(70586007)(1076003)(6636002)(47076005)(86362001)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 14:36:25.9188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6a1f4d-bfdb-45df-0330-08d9bbea7214
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5418
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This driver is intended to be used exclusively for suspend to idle
so callbacks to send OS_HINT during hibernate and S5 will set OS_HINT
at the wrong time leading to an undefined behavior.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/platform/x86/amd-pmc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index 841c44cd64c2..230593ae5d6d 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -508,7 +508,8 @@ static int __maybe_unused amd_pmc_resume(struct device *dev)
 }
 
 static const struct dev_pm_ops amd_pmc_pm_ops = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(amd_pmc_suspend, amd_pmc_resume)
+	.suspend_noirq = amd_pmc_suspend,
+	.resume_noirq = amd_pmc_resume,
 };
 
 static const struct pci_device_id pmc_pci_ids[] = {
-- 
2.25.1

