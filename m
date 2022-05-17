Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B655C52A713
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 17:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350254AbiEQPkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 11:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiEQPkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 11:40:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16116227;
        Tue, 17 May 2022 08:40:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJAPh0WklXq+v/LAarD8w555ANK9Hwej803/O8FJToc4wVwnI1sGT3KvBi5J+pUXnqNI+4fiHVI/CDzroUHxbVtsV6G9j1ocSPkWBoeFiuXunWuaMQftUzxsII1Qse+lA4U06+bRmzuFZ/dDqiaInayguJyfxTMapBRhwptDvNYx3Z1kKNW7hbzYMt3A+M85W/QUkDYlTEiiNXci/ZVzsyy/AIVBZNEobIxPzzErfXIi8o2UYYX66kT0YVpIpvMhHEBQmeOSRpBkZqGPzJnk10G9vJpA0XhGyMCaf2o2pMCrCM9lpkJnAVu0X8RBy+RM4K/sPWABBCZlp94qf8J/+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h7gAzPWWU4oMYhf4M32YhM/V/NWfrvvwNw/pdjQOukU=;
 b=cG7pnxIMIteiRW/NVgf1EjS85DDYQGXrVK1hFghZkyTKuGVQO23GFyKtlVYu94EQUYTMjT7Uoj1pl50zx37MgjyFX5Z+euGuA8r05fkz8DVEA08sVEDqHgyVMUlKhjZHX2yZFR+HGcLBTHoDDA2mpvsDHKXHM7MXWdqOdYv1XiCFSORw9Wd2Tc8jh8bHRrzL9kIR2eVw3Yycq6RHbrr6wC892EBmWbXOkGuk4cVu6nfVHUrVU15RQzGLXbXSK3DUcgutKOocL88g5gl5xwISg4EtxOWhh4/4Jur8OdpDEGxK+jWqWv571E4Sv3uDBqmCzAVZ6lhkzt6U7UZVMFbJwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7gAzPWWU4oMYhf4M32YhM/V/NWfrvvwNw/pdjQOukU=;
 b=VQM/VXHACxZ4xhNnGoCK5aDxPsfTSaF0sPt6pJ2jH6IMuCJsBRfL3bRvDJghL4+WOyWUvDk09OY28JrjyxwxMIn64iLa6kBE5Hx/baHgMnCmBlUbRmloaxhXUsR2zc4D+M+WnnaZ6b3OqOmVq4bIHInQ9ttY3Pj70lCfS40593o=
Received: from DS7PR05CA0058.namprd05.prod.outlook.com (2603:10b6:8:2f::11) by
 DS7PR12MB6240.namprd12.prod.outlook.com (2603:10b6:8:94::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Tue, 17 May 2022 15:40:13 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::b5) by DS7PR05CA0058.outlook.office365.com
 (2603:10b6:8:2f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.5 via Frontend
 Transport; Tue, 17 May 2022 15:40:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 15:40:11 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 17 May
 2022 10:40:10 -0500
From:   John Allen <john.allen@amd.com>
To:     <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
CC:     <seanjc@google.com>, <Thomas.Lendacky@amd.com>,
        <Ashish.Kalra@amd.com>, <linux-kernel@vger.kernel.org>,
        <theflow@google.com>, <rientjes@google.com>, <pgonda@google.com>,
        John Allen <john.allen@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH v3] crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel memory leak
Date:   Tue, 17 May 2022 15:39:58 +0000
Message-ID: <20220517153958.262959-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24ebc712-09be-4716-bc18-08da381b87dd
X-MS-TrafficTypeDiagnostic: DS7PR12MB6240:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB62403EF21E1CAC1148E5AC5D9ACE9@DS7PR12MB6240.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oEPFHkTB9olhqxa+IZeiS6PTT0Gvf5JrPNKPFM4QLgvnN0H5tahGPkxwNp83P2zsHn900lUeSkjaNFnXCMPeUXkwvE1Uer5KxwrSyOEwuvwVa8GCQhT8f+L3nmtTG8jwdb+PkIypS+4HWHvVbqN7JY54mpw/seYJgiQkWDxv6Plsvgv4dPF8vQgq62dpHUTx3XKXNcdtKGCobgXHCIKL2EeekbRKQrvREA2DpLK2hQF+V4aGNghf0GjA/BCcW+A3QpIzUoX4zkJ/CCObE+ZGv8BjLoOcX1XbLCBkMTknZ6LYG1u2Qeh6She815szFjRc777hcGpRJVJXlpCt0QwL7GNdpRIekaV0R+zPQtTDvpCxcJ3UbFBy7gWve+3VHJa1gN7+vdSheJqGrKY9VHzuM9Y5hR3/ejUysFmqFW8im8YtObl13ADTJcwMovK60phLxzijbDfh2UTkztbzs9yTqIdM/kcmdIjJiTz54RInh9rikHOi6GWXrWy3Sn/h14X2jBM2lwLW05zg3ymWUFAWEl4oh73LaVD5Udlhx6rIg2or9jXu3LJ8l8urmAQ6lhsthNYEVuQ0/NvTqAoevjMqXJb1a8LdrsMVbFEpHqiNRDGA2INtHZkmT6Jr5iS9bVDn4eJrzduRWNS36YBlbEHC1Fs+0pwZgLH+Ory3OArv9woTbJcvVDkIChNiZ50FNv/RlUsdlkv7vTqZyHrLt4UgoQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(40460700003)(82310400005)(54906003)(110136005)(356005)(7696005)(316002)(81166007)(6666004)(186003)(8936002)(70206006)(508600001)(26005)(70586007)(44832011)(5660300002)(83380400001)(86362001)(36756003)(2906002)(36860700001)(1076003)(4326008)(47076005)(8676002)(16526019)(336012)(2616005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 15:40:11.9981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ebc712-09be-4716-bc18-08da381b87dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6240
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
memory with kmalloc to use kzalloc and memset the data buffer to zero in
sev_ioctl_do_platform_status.

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

