Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE5A52891B
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 17:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiEPPn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 11:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiEPPn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 11:43:28 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2080.outbound.protection.outlook.com [40.107.102.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E58627B36;
        Mon, 16 May 2022 08:43:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mty+lUNqfTBPMZOpdl/1NrFTBFUgEK+jTefB+9ju4vTJ3TxpJPhNr0ziyk8rN9tDlEd13cAzSjlZoCYcY5mXARiqCxmu87yzC3P2jTcD6LH8blPfdA0k07ljsJDYgASreaCb34QX4Myz8qw5S+w6bmm6eQJEiuCsaYuWfXxD+UOrSK19ZqoTsyh/Xr89jYkFpOghKbZtSmFolOiyPv+GrJYzR/ZUPUNpVGB4GMymcssbxGUrbsJVSTu5H2b3IpQmD5Yf7SbS+KBiFPopbD9I+7h681wjUNaKjBLJOcvNwhJEL8GSIQ62ITXqrIN7qFcAVDo/s76C3vtm+3hqRjersQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15VtGGbBS5nl3iwtcwP+/U4Ufr095vW5YuD8o1dq8iY=;
 b=CvcdWFoUOsVqww4jSupPGGHNc+toB6xPrCzQ0YDNyE+qH9uRjm0fXK5nboWM6DgiXzIB4HHIzW8qVglpK5nTLvoA7hT3GB0SM9kcW6QZ20sDhgBddqQfv8pa/9lV2o//TW15v9Fy7A+IxrWbbnBWvL7rVyHo3tFlevUUB2FbRqoWzfrsP1K9WPx9DliVBPM1795nvMW5P8LNmDQYsxubk1zcguS06BCmIFtudxWcZ3+JIUk1GpQd2j7hVnRQWGxlPh2OZAK58bQM8WPwiEaZSDrbMP/iP21vwCZgJmCsYsJrg5Uu8xea65w+Yrd/q9D0KTc0w2PdLuEWp1B1kfPrlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15VtGGbBS5nl3iwtcwP+/U4Ufr095vW5YuD8o1dq8iY=;
 b=2TAcniildAuVjU3U5vdL1Mk6HzGQZg8U9Ak/jxHMVWXmLR9FyjDgaeuOAy9xADLMWuQumii3IasPz9sUWrT26KPua3N1g/m1MW1n+AgufaZYtid8bhtNrI+awgjWXqmHWcz+s+W5os/HdvDG8I3a96PlJO0PEgwqisb4lAPdzqo=
Received: from MW4P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::27)
 by MWHPR12MB1215.namprd12.prod.outlook.com (2603:10b6:300:d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Mon, 16 May
 2022 15:43:23 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::c0) by MW4P220CA0022.outlook.office365.com
 (2603:10b6:303:115::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18 via Frontend
 Transport; Mon, 16 May 2022 15:43:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Mon, 16 May 2022 15:43:23 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 10:43:21 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <joro@8bytes.org>, <Thomas.Lendacky@amd.com>,
        <bp@alien8.de>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <theflow@google.com>,
        <rientjes@google.com>, <pgonda@google.com>, <john.allen@amd.com>,
        <stable@vger.kernel.org>, <michael.roth@amd.com>
Subject: [PATCH v2] KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent kernel memory leak.
Date:   Mon, 16 May 2022 15:43:10 +0000
Message-ID: <20220516154310.3685678-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b66b5e14-295a-46e6-1855-08da3752cfab
X-MS-TrafficTypeDiagnostic: MWHPR12MB1215:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB12156A0E1A0D8F0D2A9C3B758ECF9@MWHPR12MB1215.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M0sdb4zJILGERGIiLMSF5tKB1IKgLdsfnIVcZBW5gNkhM9IkvUPRRiPtx4U6B5PseCStpuuajXItielTHptfFQutgPflnKZFsPZz9j4NiCzjKwXdHMeSellmePPDcwqlFKXKIM04i2wXjzXygB9SxX4XzKM+TyfOaWNW+mof8klUnwpmS02frASeqUimIblnSdWdX3+M4ioc0JgFRjeYV41IdP3kzJp3zv65mSymLM6ETjOk4uTz3dRCSnFDRv9GIf7O28s+BVrHbrzHBBTSwHftT7L4LeKkS/pWSxgkiD6YwrYBG5/GHPiJSsgGzCF5V3S/HPLusvVCMuE5yZdEQb9jbVO3du8Mqm0MhHpjqIWMxUqWx+ncyuYV2RKRzuzvskAaeoSk/EP0Lw8b8v+IWhURKNCWIct+VD8s/Ei4cicXnfh8OJKgMIXm5K1UKTy13ICLsB4qECCrR8kLhZMMMDYSpTQQfdH0scoW5Vu6KOshdFcMrFCP1mjLCPshR4MgVEDXf+zN9iMnNGoNeNgoUY4c7RMF3WtXBu4uZi/oRsUqjI1n2QHMY8TISPrDiQYTUrnzamGAlQl002XEPZLb4JU+/SSEh5Kp3PAK2XqbVDNS334WcedMAglBXy1VmXsgP6ACjPKex7SnIYJynlGdqe4ZMTMJJVXMrq/TMKFXz6Vh6vunSxNhJvjc+SU61dxUxpy6KSaXokpYC2WsDVjc1A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70586007)(8676002)(4326008)(70206006)(7696005)(6666004)(2616005)(36860700001)(47076005)(426003)(1076003)(86362001)(83380400001)(5660300002)(7416002)(8936002)(40460700003)(316002)(16526019)(186003)(36756003)(82310400005)(81166007)(336012)(26005)(508600001)(2906002)(6916009)(356005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 15:43:23.5414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b66b5e14-295a-46e6-1855-08da3752cfab
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

For some sev ioctl interfaces, the length parameter that is passed maybe
less than or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data
that PSP firmware returns. In this case, kmalloc will allocate memory
that is the size of the input rather than the size of the data.
Since PSP firmware doesn't fully overwrite the allocated buffer, these
sev ioctl interface may return uninitialized kernel slab memory.

Reported-by: Andy Nguyen <theflow@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Suggested-by: Peter Gonda <pgonda@google.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Fixes: eaf78265a4ab3 ("KVM: SVM: Move SEV code to separate file")
Fixes: 2c07ded06427d ("KVM: SVM: add support for SEV attestation command")
Fixes: 4cfdd47d6d95a ("KVM: SVM: Add KVM_SEV SEND_START command")
Fixes: d3d1af85e2c75 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
Fixes: eba04b20e4861 ("KVM: x86: Account a variety of miscellaneous allocations")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7c392873626f..4b7d490c0b63 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -688,7 +688,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (params.len > SEV_FW_BLOB_MAX_SIZE)
 			return -EINVAL;
 
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			return -ENOMEM;
 
@@ -808,7 +808,7 @@ static int __sev_dbg_decrypt_user(struct kvm *kvm, unsigned long paddr,
 	if (!IS_ALIGNED(dst_paddr, 16) ||
 	    !IS_ALIGNED(paddr,     16) ||
 	    !IS_ALIGNED(size,      16)) {
-		tpage = (void *)alloc_page(GFP_KERNEL);
+		tpage = (void *)alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!tpage)
 			return -ENOMEM;
 
@@ -1094,7 +1094,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (params.len > SEV_FW_BLOB_MAX_SIZE)
 			return -EINVAL;
 
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			return -ENOMEM;
 
@@ -1176,7 +1176,7 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	/* allocate the memory to hold the session data blob */
-	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
+	session_data = kzalloc(params.session_len, GFP_KERNEL_ACCOUNT);
 	if (!session_data)
 		return -ENOMEM;
 
@@ -1300,11 +1300,11 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* allocate memory for header and transport buffer */
 	ret = -ENOMEM;
-	hdr = kmalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
+	hdr = kzalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
 	if (!hdr)
 		goto e_unpin;
 
-	trans_data = kmalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
+	trans_data = kzalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
 	if (!trans_data)
 		goto e_free_hdr;
 
-- 
2.25.1

