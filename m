Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB41528922
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 17:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245383AbiEPPqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 11:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbiEPPqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 11:46:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE12E71;
        Mon, 16 May 2022 08:46:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnKm0Zmr4T/w8VweVWrO5ZaWjzzsLL6kzzBQJ1pLR5CXnrkxoPHqrzMnlAdiMZ0AOCOpeSe1IfH/sJXzj//DFjlaQLaGe+5Qjx7eN/JMHu0MFa4aucT4KcbgXssTivJMmFrtVnK296U14KUukhFBMPTdzREPaZiz4fXbUw9Y6npLjd06YkVrgVINLaaRBZ/0kIVSaE4S0IosYhz1Zon9WJ1N2KYlSJxkdpSxaHL7v1X8G6nQwT3dY2ry0H+YxPNVpJ8S+FtFG0U4q8X+sRp/0nEgM4k5+4HY5SBdlpMH7gJhbFFWcGUZsKWbFCqtAqVlB/GzgFC5gWlboanJiQu+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dVyzjjWM2aOr78A/+nKv/zx3TsOLvDoTLWdvn88Nff8=;
 b=QV2JaguXZvM+kmXh9yR+2aGjX45f1WPT9Yx6K7ATHAMiBJzB8cBTa3khybQJ3LCfEeSC4dQUJAzW2qT3WHRB8ZdDqgQPz2oz0S0DetPOVCl6vmModsOALyx5k//eoCta6ZTGJhsyZmHmmi6vTQPuL8Y1G6J+fnKeIJQ1wv43aS1vgy/vHTFggUMjRXv0RKhjgQZNCmDnMhW541ruEzIN2omeLRNZK1GxqLnrweh5ebb3J8F6iYdsO/jRYkqdX/WG7bNKPfbgKratCK2k1Q46Rr6vU9F0u3nH12D0gDLIzp5Yq0RHV6Am6pXYTlNfBvJqUcV7w0wOOhjlr/MDASQriw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVyzjjWM2aOr78A/+nKv/zx3TsOLvDoTLWdvn88Nff8=;
 b=KMoiS7cFj5E4FYVBW99wkUmUUYo27PDHB8VAK+1w3/wrSpSCg7km5p3UUD5LHla/nBDvHs3N6ljQnPNZmGAOGbOwJUv9+FxiBjzNqdX7LXzRAp4NLqHqTP3i67TBJKvs0KqbF2U78vUru2oFsnaJT+JRCDBFkzAUfEwgSfBNmNs=
Received: from MW3PR05CA0013.namprd05.prod.outlook.com (2603:10b6:303:2b::18)
 by BL1PR12MB5947.namprd12.prod.outlook.com (2603:10b6:208:39a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 15:46:06 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::4a) by MW3PR05CA0013.outlook.office365.com
 (2603:10b6:303:2b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.5 via Frontend
 Transport; Mon, 16 May 2022 15:46:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Mon, 16 May 2022 15:46:04 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 16 May
 2022 10:46:03 -0500
From:   John Allen <john.allen@amd.com>
To:     <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
CC:     <seanjc@google.com>, <Thomas.Lendacky@amd.com>,
        <Ashish.Kalra@amd.com>, <linux-kernel@vger.kernel.org>,
        <theflow@google.com>, <rientjes@google.com>, <pgonda@google.com>,
        John Allen <john.allen@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent kernel memory leak
Date:   Mon, 16 May 2022 15:45:11 +0000
Message-ID: <20220516154512.259759-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2258ee79-9a73-41f9-d590-08da37532fcb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5947:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB594722E32374682C788AA8239ACF9@BL1PR12MB5947.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fCpaxKE4AxQxztgu+0NYsalp2CL1rscsCLjvORUX7/spHaDGQdPzG/np0wyQamxSSHBIkTPo8nYtKNlDCrKUk5Z1o0F4QPRbn85TPEBvK8Ymwj3P3zHhq4bafQQpSA7AzZ7W19A/BtPV0W1DXhr324XCwMUeSuIJQNDEeoDGQQkTkeHV2gV/flFy57io+mxCvfSCknmJkBlahdVpcgXs+xS+niYOJPzlcBgeZKAa6qyoH9evXe8monDHvFbpDgjVr3MQ3MXTnvoPKj6Dtaxhv/Ddx/sMY0AY0iy5Bdwztl/fAPD/eiaml7IBpkFinEvCo8Eps6ah7M+j4wgIc4C46QBauZo2/j3RYsSRuD0z9m+Fw+89tyjnWy6UkzU5KKUYM0PYnQ9eDS7HPpcF5YCePMrikmRwkzcZ69/bOVXMaxGBzf+gVhgRsbMjtv4LT7Rib7sGiZMBHCUjqXTme3Ad/A32XzbI4CmrYm6FCioQZqP5MQVtxtgPZpzwbBgwTJKk6G0p/KYfqrQiHmuNL4DlspUOrWg9hpUWRLK9DyVWeR4AM4J3lGv/T2jHWrM1blfOH4KqaQ9gpwlnvoXSSmUamLj94gYVGz4oji2RzwWhSEpR2uMUG6ZAOo32M9FSBPnc5uz6jePIOwkhK34qvzRxx3VwzC3oiik8sLxrfvo0APuUZiRU39R45El6l18xebDYYBnK0FThFW++GwLw8dUCrQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(81166007)(44832011)(8936002)(40460700003)(5660300002)(508600001)(83380400001)(316002)(2906002)(2616005)(426003)(336012)(110136005)(16526019)(36860700001)(26005)(54906003)(47076005)(186003)(1076003)(82310400005)(8676002)(36756003)(86362001)(4326008)(356005)(7696005)(6666004)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 15:46:04.7703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2258ee79-9a73-41f9-d590-08da37532fcb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5947
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
memory with kmalloc to use kzalloc.

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
---
 drivers/crypto/ccp/sev-dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6ab93dfd478a..e2298843ea8a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -604,7 +604,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	if (input.length > SEV_FW_BLOB_MAX_SIZE)
 		return -EFAULT;
 
-	blob = kmalloc(input.length, GFP_KERNEL);
+	blob = kzalloc(input.length, GFP_KERNEL);
 	if (!blob)
 		return -ENOMEM;
 
@@ -828,7 +828,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	input_address = (void __user *)input.address;
 
 	if (input.address && input.length) {
-		id_blob = kmalloc(input.length, GFP_KERNEL);
+		id_blob = kzalloc(input.length, GFP_KERNEL);
 		if (!id_blob)
 			return -ENOMEM;
 
@@ -947,14 +947,14 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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

