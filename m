Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3A615D67B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 12:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgBNLWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 06:22:10 -0500
Received: from mail-eopbgr760053.outbound.protection.outlook.com ([40.107.76.53]:64198
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726220AbgBNLWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 06:22:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FU40JOPdOPc0MlvdEYTIJ8sGIR7a9fPPo8EeLE1L1enEm0n1yhobDfBlJ9RUQ3DSO9IZ4BXIsnITJKQ+GhRhzfBl7KNU/9FeZJ+JTObaCBbgGkAKvVtpGWGkXHWf4juSNX4IYDipBck/P/v3lbiCXP2LQRnZA8dfl9w1S4XB1ud3+y7iDNpHXO2nOM4bIeJ4HSH7zH6OaolLtM4whZyS1Lto8Tb0hUnbiPXjvOUFNAIm5zbmt7IQ1P2glshsML4Tj724P+3j3kKsPy5nuVzQCQ106miQP65aL2zwyb76Aoslj0yRj/a+hqQxbYUTCXVYB2dzbOW6SIqMfzvsG6mTIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zY19/0avlSS6S0KZf+EnZdIT4/vh8+FUGBBuZaw0HSI=;
 b=MT9o/rCN9yeNm4qWY4FhRXpZ6m0l4lhsvy9cpW1xPcY3TkMwEy6+JQfed/HuVGwsVTceL5cGd/yEP+Kz7pSz4jR/bB/CQy+W9Ns7nBYXehtit4py2WulnY/jl/55i9tBzAll7ZUvKxKGoT42O0m1OfXpGA7nouW6viAeveRgU3itBYquOwbechsiAHY/Z9X0wrK8EQ29L94HUMy9etq7Soy+afo4mcjb/ce4a2IhUq1BeTUUlE2o39Xd4KkQ5L0vIfoVuYXDsC2eA15gH+wPPqLt4eNrqWF9ZE1LQaIsNnblDFDTRFxD9VuFgsATVUB+p+ixAGA61HJE8s3tLQ8FNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zY19/0avlSS6S0KZf+EnZdIT4/vh8+FUGBBuZaw0HSI=;
 b=lwiy3bd/54jEHUcqyPDsoz5vm7AwTsiLW8tNfFaSvu9a00+1khCXvgsF/OQFtzMESu3TaCgiLEDAge1Q0liIngScLmXQYZdTUU8ZLwip9EFaVpnkVBgJPCEQ41xoJkWmHxQqPu2nZW5zdE87ri4b1BezE8dlQaiBjXZiFRvgCxw=
Received: from MWHPR02CA0006.namprd02.prod.outlook.com (2603:10b6:300:4b::16)
 by BY5PR02MB6833.namprd02.prod.outlook.com (2603:10b6:a03:206::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22; Fri, 14 Feb
 2020 11:22:07 +0000
Received: from BL2NAM02FT014.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::202) by MWHPR02CA0006.outlook.office365.com
 (2603:10b6:300:4b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend
 Transport; Fri, 14 Feb 2020 11:22:07 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT014.mail.protection.outlook.com (10.152.76.154) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2729.22
 via Frontend Transport; Fri, 14 Feb 2020 11:22:06 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <lakshmi.sai.krishna.potthuri@xilinx.com>)
        id 1j2Z2s-0005eB-EV; Fri, 14 Feb 2020 03:22:06 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp2.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <lakshmi.sai.krishna.potthuri@xilinx.com>)
        id 1j2Z2m-00051h-AC; Fri, 14 Feb 2020 03:22:00 -0800
Received: from xsj-pvapsmtp01 (xsj-smtp1.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 01EBLxDk032268;
        Fri, 14 Feb 2020 03:21:59 -0800
Received: from [10.140.6.35] (helo=xhdsaipava40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <lakshmis@xhdsaipava40.xilinx.com>)
        id 1j2Z2l-000518-8I; Fri, 14 Feb 2020 03:21:59 -0800
Received: by xhdsaipava40.xilinx.com (Postfix, from userid 14964)
        id E31B413C0374; Fri, 14 Feb 2020 16:47:52 +0530 (IST)
From:   Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
To:     git-dev@xilinx.com
Cc:     michals@xilinx.com, Joel Stanley <joel@jms.id.au>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
Subject: [LINUX PATCH 2/7] Revert "jffs2: Fix possible null-pointer dereferences in jffs2_add_frag_to_fragtree()"
Date:   Fri, 14 Feb 2020 16:47:26 +0530
Message-Id: <1581679051-17534-3-git-send-email-lakshmi.sai.krishna.potthuri@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1581679051-17534-1-git-send-email-lakshmi.sai.krishna.potthuri@xilinx.com>
References: <1581679051-17534-1-git-send-email-lakshmi.sai.krishna.potthuri@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(376002)(346002)(136003)(396003)(189003)(199004)(36756003)(70206006)(6266002)(107886003)(6636002)(70586007)(6666004)(34206002)(356004)(4326008)(478600001)(81156014)(2906002)(336012)(8936002)(5660300002)(37006003)(42186006)(2616005)(81166006)(8676002)(186003)(54906003)(426003)(316002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR02MB6833;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7add642e-2550-468c-2306-08d7b1402028
X-MS-TrafficTypeDiagnostic: BY5PR02MB6833:
X-Microsoft-Antispam-PRVS: <BY5PR02MB68335B1B7C59E7024FC45AC5BD150@BY5PR02MB6833.namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-Forefront-PRVS: 03137AC81E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vx9W9byvkKeDTGlZ12D/cnlKz6vPfYP+CUdCbxBp5TFc8qsQV7bKmTL2jT/HJ0bfdcP9CRuVqOrpApskuDtfS5s1kF815ZFA5YjzTyw0zBEyyKnZyawe/uXELrU2wjvTPRGUOLr93zAJDh0+rhMHvt1Eigh+IVUZYsl+2/jO1WByA18tHe2XPRpj8QxvC9T73WtuQ+0b4d62fp8umb5e3IDLZ7cBSSQ3WXlGTyBZLdVHLpIsZfoJDYeq5k0t671ZlkUFg1b1jEBgNswdIHqfVXOZwyLmKnMLgQqsX63qQCMRZa0f4rTyScEj5a7E8+oTnVE600WL2L7E3XW07noOoAVxzlLjoNIrd06SMQu/5KtLtfqm5ZRoHTcjdbB8zV4W6ZKid3w8uNCvtENpQLYICmr2iwL96rvJagvzmSAAHautpTyf0+HSpQJe4Qbmwqxv
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 11:22:06.9997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7add642e-2550-468c-2306-08d7b1402028
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6833
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

This reverts commit f2538f999345405f7d2e1194c0c8efa4e11f7b3a. The patch
stopped JFFS2 from being able to mount an existing filesystem with the
following errors:

 jffs2: error: (77) jffs2_build_inode_fragtree: Add node to tree failed -22
 jffs2: error: (77) jffs2_do_read_inode_internal: Failed to build final fra=
gtree for inode #5377: error -22

Fixes: f2538f999345 ("jffs2: Fix possible null-pointer dereferences...")
Cc: stable@vger.kernel.org
Suggested-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.co=
m>
---
 fs/jffs2/nodelist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jffs2/nodelist.c b/fs/jffs2/nodelist.c
index 021a4a2190ee..b86c78d178c6 100644
--- a/fs/jffs2/nodelist.c
+++ b/fs/jffs2/nodelist.c
@@ -226,7 +226,7 @@ static int jffs2_add_frag_to_fragtree(struct jffs2_sb_i=
nfo *c, struct rb_root *r
                lastend =3D this->ofs + this->size;
        } else {
                dbg_fragtree2("lookup gave no frag\n");
-               return -EINVAL;
+               lastend =3D 0;
        }

        /* See if we ran off the end of the fragtree */
--
2.17.1

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
