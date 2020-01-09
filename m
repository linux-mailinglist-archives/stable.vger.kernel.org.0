Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370C113535C
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 07:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgAIGxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 01:53:15 -0500
Received: from mail-mw2nam12on2052.outbound.protection.outlook.com ([40.107.244.52]:47072
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726541AbgAIGxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 01:53:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpn74U+0d0cNm3BtK+BF8vN4MJm57fBHLBx8MIgCpXQMRVsg69c8cz0TFiFl64og8yMSibO05xsCx2CnccIQdEzlbs2bcQZCKuPCWG7SlcgwhYoW5gI00sR9wG3WHa7eW9EmqbK/1Jf4vzRn+kyWXqGBBleldqguWLD0JMTVSbPHX6o/w+DdHeMSEk9i7MUijiBTjjrXZW4tMUSHh7ZLvX99E1z5FS0Vy6/yg71arzJlGLtYaRiotTGTdSYrZL24kxUjkE6j+pwOGWXJRFLHVagjnbDVN5LNalpCK2UAfAvijlV4WabBpBdoKt9BlYxCv8w/V/XNjuj4sgIG9bxKFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgqbVKQf3zbQMZ/dyOw0CBIczd2pDXaNpnvfb5e6g9g=;
 b=HVFbI3093ji15H2t6LPBroEo7hY0QXFtNEZ3TuH+qjLTYVtBEte6GzffaoL2Tk06Jm0eqsojY9ZyPCjSOCLEQ3vAz1rNNtIfYlxSiJtSX4NrLW2LnlEi8BVNK17PnXa5qFf6aBlWfOm/4NJQr5Vs6kiSDI3O9WcpOweTxiuCe9iGfpfVwRv1GSBMuNYxtNCcBlKTFkPVT5BCfYX1x9TYSLtbtyzXw7umeB4GqqIqxCt3t9Td7gwZSpLnYQZ0biDERwMLvVFAJ2BxwIdwyKLxIgiZ+MgBYpEgMPUlJFTnqn+NgpAWhpFueT+46+Lqny2P90N1mhYMNfbKB3R8jYsCPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgqbVKQf3zbQMZ/dyOw0CBIczd2pDXaNpnvfb5e6g9g=;
 b=FOl7mLD3AJdZWJuqr/QNKhSdB6y8PHrudmJoErE5Fsd5S48D10eiAbRwAcA5iYBvJ9Ih0Ij+/TFh2FDOocbgVepYBzfl1uLY0R6ngHuwYFMH/zxfmhnWgCSudaV9wo6lGdJspTTdry5EPPqc3kWarDKGX85lnXVx5AEK9ykavPQ=
Received: from CH2PR02CA0017.namprd02.prod.outlook.com (2603:10b6:610:4e::27)
 by DM6PR02MB6444.namprd02.prod.outlook.com (2603:10b6:5:158::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9; Thu, 9 Jan
 2020 06:53:09 +0000
Received: from SN1NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::206) by CH2PR02CA0017.outlook.office365.com
 (2603:10b6:610:4e::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend
 Transport; Thu, 9 Jan 2020 06:53:09 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT060.mail.protection.outlook.com (10.152.72.192) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2623.9
 via Frontend Transport; Thu, 9 Jan 2020 06:53:09 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <naga.sureshkumar.relli@xilinx.com>)
        id 1ipRgr-0000Ty-1S
        for stable@vger.kernel.org; Wed, 08 Jan 2020 22:53:09 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <naga.sureshkumar.relli@xilinx.com>)
        id 1ipRgl-0005tX-Tj
        for stable@vger.kernel.org; Wed, 08 Jan 2020 22:53:03 -0800
Received: from [10.140.6.25] (helo=xhdnagasure40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <naga.sureshkumar.relli@xilinx.com>)
        id 1ipRgi-0005jV-Ko; Wed, 08 Jan 2020 22:53:01 -0800
From:   Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
To:     nagasure@xilinx.com
Cc:     stable@vger.kernel.org
Subject: [LINUX PATCH] ubifs: Fix wrong memory allocation
Date:   Wed,  8 Jan 2020 23:52:59 -0700
Message-Id: <20200109065259.4772-1-naga.sureshkumar.relli@xilinx.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(39860400002)(189003)(199004)(4326008)(81166006)(1076003)(36756003)(6636002)(478600001)(5660300002)(81156014)(8676002)(2906002)(70206006)(70586007)(8936002)(34206002)(9786002)(316002)(2616005)(426003)(186003)(103116003)(26005)(7696005)(356004)(37006003)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB6444;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5569d8da-ee8f-48a6-1f10-08d794d09681
X-MS-TrafficTypeDiagnostic: DM6PR02MB6444:
X-Microsoft-Antispam-PRVS: <DM6PR02MB64446341BFB2E2977EE7C013AF390@DM6PR02MB6444.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:176;
X-Forefront-PRVS: 02778BF158
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkDSMlmKzw43MC+DzURMe6Q/WapiRUSro1bWzVTk6/ETWvQ0VnbnGD3mjf/JpgunGVT3CHPrTxbC+leRT8O7gPRDcw5TnaRjpkS1h5bVuz5i8+0iUeXbFomrASjfnnSqUmz1m3Eru0Incxj2ZlxWkbfl8nuEj/zOP+3QmdKmEw5HVoVQ/mYwTYLPNDvFXOus32xX1iLQYKA/iYFVpigws3lmoYXGei19x8RH/Uzphd4q+99Mw644EMLXW90DoKoCwoJRcZqbF4GbOLGWbSwMxkwPBd+Uds9KPRPKQHGifwSGLc9NMgiNws7CgL/ya2F4y08PU2FvhdHFnqJBdsSf7XZl3UYEe28eXoIf2A3oJ0cJtdHweHdnsshyK5/4YDgWeLOKkZ4WvMM1mpkEop+r07gWp6pHWro65XEn508Fd3eGM8FeCj2jz78WRSFa+Npw
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 06:53:09.4256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5569d8da-ee8f-48a6-1f10-08d794d09681
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6444
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

In create_default_filesystem() when we allocate the idx node we must use
the idx_node_size we calculated just one line before, not tmp, which
contains completely other data.

Fixes: c4de6d7e4319 ("ubifs: Refactor create_default_filesystem()")
Cc: stable@vger.kernel.org # v4.20+
Reported-by: Naga Sureshkumar Relli <nagasure@xilinx.com>
Tested-by: Naga Sureshkumar Relli <nagasure@xilinx.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 fs/ubifs/sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index a551eb3e9b89..6681c18e52b8 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -161,7 +161,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 	sup = kzalloc(ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size), GFP_KERNEL);
 	mst = kzalloc(c->mst_node_alsz, GFP_KERNEL);
 	idx_node_size = ubifs_idx_node_sz(c, 1);
-	idx = kzalloc(ALIGN(tmp, c->min_io_size), GFP_KERNEL);
+	idx = kzalloc(ALIGN(idx_node_size, c->min_io_size), GFP_KERNEL);
 	ino = kzalloc(ALIGN(UBIFS_INO_NODE_SZ, c->min_io_size), GFP_KERNEL);
 	cs = kzalloc(ALIGN(UBIFS_CS_NODE_SZ, c->min_io_size), GFP_KERNEL);
 
-- 
2.17.1

