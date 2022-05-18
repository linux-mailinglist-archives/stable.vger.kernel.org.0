Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F085652BEFE
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 18:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbiERPbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 11:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239366AbiERPbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 11:31:48 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A813ED3D;
        Wed, 18 May 2022 08:31:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KpVtJA5AdS9QkNL75Qa55fFR0wpu5MIdtI1qBvgEbFMxTXjDUjMQsuldJQmfBdoANoJIevmPOK+xBDSmHoUaLnbnabjZy+Ih2cD5zoJOmvp8l+O2NTnT9dmac39lacWTzcqOOIhL2YhZQpy8vRe/0Hl8EnlHyT28hbpo/uDtX6DKskoz4+dZLBnQ1gQD8mNoO2qg74tcx3BIyabkpQ5TWtWg26wYK4DRNK6B2bz4G/gas8ARcIwoEo17HU4RjfaWNSo7QluERvRXJJTHe6+6Sh31LUqPMliMc18kVqCy/h0eCxx21gGIaR8JSuWxupMZIWPdbS8dhNHu77/wBdhmaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4tRZtmej6m545e3SzXFSdqG8WcoSbfS5cExy37mYpW4=;
 b=O8oztLaHb8CLYTLlplRFmrapnzPPmn9aq1FZnQTP+q3LiC9eDORnoZYQctCaMv64pITeQ0aEPSKbH0Ifgakmpd6PUCyPcAsonQ/SDjNV3VIlHlgiaxy3qXGD6uBmNXnJO0SZkaWgxB5nc7Cpq1US9IZ4oHmJ3K30toOI1ekI3zZQnPClD71Vs2TcXvlc1nEgcABCt+b7GSqOQoiePCWDuygW8bLF6aErAU7X7bxy8z6x44Mt3JXXILBy6RG8hyyyD3ddP6AzzkCQmhuKxKjsR5LeWrFSVk88bGYlUo/viRRilCCetCujKAE8tJ958JYfkCDRZ2KJQoY1hHUlKhmZIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4tRZtmej6m545e3SzXFSdqG8WcoSbfS5cExy37mYpW4=;
 b=Ow9kN//QLpgQV/gMCIgndbuTaZTOGFqqc5tmSbEsEJ7WG9904dxrz8BURc5B2INM+7XJJjprsqj5SWJiJuXIf80XfdThOWk/Ami1fW7XFeF88U5kK9IDUK5/ieaJ4MjOIG5x+LHZ5vKnB8AK66TJpK3s+iMANNhSMcjHVYjnlAI=
Received: from MW2PR16CA0023.namprd16.prod.outlook.com (2603:10b6:907::36) by
 BL1PR12MB5898.namprd12.prod.outlook.com (2603:10b6:208:396::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.15; Wed, 18 May 2022 15:31:45 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::2a) by MW2PR16CA0023.outlook.office365.com
 (2603:10b6:907::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14 via Frontend
 Transport; Wed, 18 May 2022 15:31:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 15:31:44 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 10:31:42 -0500
From:   John Allen <john.allen@amd.com>
To:     <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
CC:     <seanjc@google.com>, <Thomas.Lendacky@amd.com>,
        <Ashish.Kalra@amd.com>, <linux-kernel@vger.kernel.org>,
        <theflow@google.com>, <rientjes@google.com>, <pgonda@google.com>,
        John Allen <john.allen@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH v4] crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel memory leak
Date:   Wed, 18 May 2022 15:31:26 +0000
Message-ID: <20220518153126.265074-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bdec8bd-9b1b-41b4-d305-08da38e383a0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5898:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5898C7D1F3A6E86CA7CAFB2A9AD19@BL1PR12MB5898.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WcbnSykW1G1sB20/4uM+YCkCQvKt7r7oa0IEWZTsCESE6H3jE0vNenkz4lbNuKpJN6K5HvCGtmXuRxGmm7n3TQqDYuIKGjsHiL/KujGgS70NCecs8ebiV+8A+SMRiFWnnm0Onws5gXnHQlVzGgmYPoAVPFRDwMd/wSFIzCPYXsDekKcbsfyIrNQnzGRVNbc5+qbrQhiakElvCIMmUio4z2mD1uxQsGoFpYofrCrDCugpxP0LrBieT5pjF97msAKDkuZRDjQw16i2MuhZVnvhGNuIIL9fC9R0jDq3ocHJrZ+YneuxV99QiYihU0TQHDbML7My5ySlYee0efFYDZyU6BuLWlr/7P0bJB5k7JRKAddbO1QZkfkNNJqmy2FJXs0n+RPfUfyR64ZXkX/BqOX6TEIQU96rFUUTGJPyAx93P8CN2XGhNq7gHuocaarwMX5rnXqAyGD7dSP7G2rHWv75Q00H8v9BlBG0mW9HudEaSlS7vkr916zJkW++hYnY4IgrLrfkQBqp3KsBOeKevk7MKqAzivddNmOIoO9lOdqDXa1pLGdKMVoaLPyWt44PHKSP6fbrgsNtpLeaXl24Qw3XZGapNHdJtz7dXHvF6yDXj3WoGQ+54eTzO9uZex01JAjrIVVX+rg2QYwnq4TPW4+Rdv7bawNjjYVmRWsSkbbWCPatzvBZZQ+h0EDBvD4WdZdJDzdUVo8pygZUUBF9wdI+Qw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(6666004)(83380400001)(2906002)(4326008)(8676002)(70206006)(70586007)(7696005)(186003)(16526019)(47076005)(316002)(86362001)(36860700001)(8936002)(54906003)(336012)(40460700003)(82310400005)(426003)(5660300002)(26005)(81166007)(110136005)(356005)(1076003)(2616005)(508600001)(44832011)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 15:31:44.0777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bdec8bd-9b1b-41b4-d305-08da38e383a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5898
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For some sev ioctl interfaces, input may be passed that is less than or
equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
firmware returns. In this case, kmalloc will allocate memory that is the
size of the input rather than the size of the data. Since PSP firmware
doesn't fully overwrite the buffer, the sev ioctl interfaces with the
issue may return uninitialized slab memory.

Currently, all of the ioctl interfaces in the ccp driver are safe, but
to prevent future problems, change all ioctl interfaces that allocate
memory with kmalloc to use kzalloc and memset the data buffer to zero
in sev_ioctl_do_platform_status.

Fixes: 38103671aad3 ("crypto: ccp: Use the stack and common buffer for status commands")
Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl command")
Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
Cc: stable@vger.kernel.org
Reported-by: Andy Nguyen <theflow@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Suggested-by: Peter Gonda <pgonda@google.com>
Signed-off-by: John Allen <john.allen@amd.com>
---
v2:
  - Add fixes tags and CC stable@vger.kernel.org
v3:
  - memset data buffer to zero in sev_ioctl_do_platform_status
v4:
  - Add fixes tag for sev_ioctl_do_platform_status change
---
 drivers/crypto/ccp/sev-dev.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6ab93dfd478a..da143cc3a8f5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -551,6 +551,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 	struct sev_user_data_status data;
 	int ret;
 
+	memset(&data, 0, sizeof(data));
+
 	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
 	if (ret)
 		return ret;
@@ -604,7 +606,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	if (input.length > SEV_FW_BLOB_MAX_SIZE)
 		return -EFAULT;
 
-	blob = kmalloc(input.length, GFP_KERNEL);
+	blob = kzalloc(input.length, GFP_KERNEL);
 	if (!blob)
 		return -ENOMEM;
 
@@ -828,7 +830,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	input_address = (void __user *)input.address;
 
 	if (input.address && input.length) {
-		id_blob = kmalloc(input.length, GFP_KERNEL);
+		id_blob = kzalloc(input.length, GFP_KERNEL);
 		if (!id_blob)
 			return -ENOMEM;
 
@@ -947,14 +949,14 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
 		return -EFAULT;
 
-	pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
+	pdh_blob = kzalloc(input.pdh_cert_len, GFP_KERNEL);
 	if (!pdh_blob)
 		return -ENOMEM;
 
 	data.pdh_cert_address = __psp_pa(pdh_blob);
 	data.pdh_cert_len = input.pdh_cert_len;
 
-	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
+	cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
 	if (!cert_blob) {
 		ret = -ENOMEM;
 		goto e_free_pdh;
-- 
2.34.1

