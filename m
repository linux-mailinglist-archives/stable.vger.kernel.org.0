Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE69462227
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 21:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhK2U3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 15:29:38 -0500
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:17865
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235604AbhK2U0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 15:26:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1u+UxyE/5Vgkgk1OTGpTNpGYY0u7tNrr2OiND2ooYL1yOtyKb1ka9kpVe0GHnB68PEJQuHmQjh6Kpt5F5htKIDZOWTpfWvGTqT6xJ2YgxB6vL7itXchVHqaOY47Y5eWadjAarMUj8VirsH8FKlc1rfW4R1dBdtJWt4jwInymjNvcxnwq8bVRMLLFTAQavs5RIxLmWJWvOGBcDLhsQnMzfSZ3CYRxM2nJr5cCdmKlb+ZhG+iME474T5Fhrwpc+Hn8pcAPq263O7cyD53+M6LV8jSVUCiFFEGt0Z0s93Ext0v/e+SuTLCNd/kh0vkiLv8LjVPzezfFw0So4TXaQi6hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4KpTwdMijh6Yv2VmyXXOVKy1RdwztxNfksgrK594vk=;
 b=mINsfiVRgGEIp75M5NZDGSjX91BrMllOitcrKwwcaKk8XG+cvvBZYCxXG2AckVL6bo8hU8iT7W7TGRt2ceN/fYH5DuFZi74M8wCLgOHX2hMiRMF/mBCSE+jTMByGv+k9t8Lf71u73oru2+NzJnq4nThEhPT/EAYPfAfB+oaLyoCNEqkYjb9GSUuJbJkOCRrmUTe05VW7YxCn03R+HiZjcnujjbSvbklX+Oa8gqaOx1mqRQZ5pGeWDbkYUcIIBBuX3xoqDVMu9CRXara7wx/404Oj27sSRDIUiQxsZnPRqTW/NSDtV1gXXxiQz9xjJyzyCH5Jvg3zhM4npyaAyM8WUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=xilinx.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4KpTwdMijh6Yv2VmyXXOVKy1RdwztxNfksgrK594vk=;
 b=HkJqW2/z7W8IloQUgCM+Iw4MZOf5AAPBzk4ckJxJ2wvkdsm1tLqG5qnYy4klG1sASL5fQCT/MSBnCTkwvK4t7TSgT7j5QAZytE2GeIZ96uDP0AVRUdSK1j15P+asosinPuiZQPZ3Il+XcI2ezFKDssVYWJbpM8QjB32GMJo+5OI=
Received: from BN9PR03CA0031.namprd03.prod.outlook.com (2603:10b6:408:fb::6)
 by BL0PR02MB5635.namprd02.prod.outlook.com (2603:10b6:208:82::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 29 Nov
 2021 20:23:18 +0000
Received: from BN1NAM02FT064.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::19) by BN9PR03CA0031.outlook.office365.com
 (2603:10b6:408:fb::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Mon, 29 Nov 2021 20:23:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT064.mail.protection.outlook.com (10.13.2.170) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4734.20 via Frontend Transport; Mon, 29 Nov 2021 20:23:18 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 29 Nov 2021 12:23:14 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 29 Nov 2021 12:23:14 -0800
Envelope-to: gregkh@linuxfoundation.org,
 jacmet@sunsite.dk,
 linux-kernel@vger.kernel.org,
 linux-serial@vger.kernel.org,
 stable@vger.kernel.org
Received: from [172.19.72.93] (port=50376 helo=xsj-xw9400.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <lizhi.hou@xilinx.com>)
        id 1mrnBC-00047h-4c; Mon, 29 Nov 2021 12:23:14 -0800
Received: by xsj-xw9400.xilinx.com (Postfix, from userid 21952)
        id 0F675600ACD; Mon, 29 Nov 2021 12:23:14 -0800 (PST)
From:   Lizhi Hou <lizhi.hou@xilinx.com>
To:     <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <jacmet@sunsite.dk>
CC:     Lizhi Hou <lizhi.hou@xilinx.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/1] tty: serial: uartlite: allow 64 bit address
Date:   Mon, 29 Nov 2021 12:23:02 -0800
Message-ID: <20211129202302.1319033-1-lizhi.hou@xilinx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0020cc3f-8520-42d8-9e8a-08d9b37614ed
X-MS-TrafficTypeDiagnostic: BL0PR02MB5635:
X-Microsoft-Antispam-PRVS: <BL0PR02MB5635F7E89E943CB9302C2003A1669@BL0PR02MB5635.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lI1rt1qXD5ba/C167cdKKGHY2KUJf4yAVKadudfB/+NdcPhV3lbU+6+ijHkhZW+38RUnRVMH1o7nRN3xn/q9NFR2QgIMDq6hzcoy3V49xIrTYWfOchjh5Zmxr0nE2/2lHBc2DYL0bzdgF/ndGaVGo6q3cwhiAqnzQb7iV0Y8lLFAnZVw2GmPP2Vz3wdgjh4oUYrt4S+fZ+O+8pFDe0pqOFwWansWqr9EeDTdRMKLVevq4P4GPc7Gh5tJ8yElD4OR50KtyAJ2NCTCQOu74st65NYUYW/nyjt7fOtQGN3ZLN05VBFMZYnmAfXFEATMDH1ytmxqEsnRZ7H3zV2uBmoaC0AxqpKxUm2cWVK51vPQDDO06BA9xCQVlhKq8bcFHFSxkH3McpbPSJIrmtXdqeeDVEFNds6FpDMgIN2ab9RBVVolaCLftc51kD5dNehOsNkTFHasNgJG6m/m92PdaLo5C6+htQJUCdNyKnYjY2qul89oSkdIGJzwkFKgRClkprwQlgcKsrn+JZ3elv3HPl25Empv4f+ZzVH/sStVyfJyKH0C+le/z3Go8ow7czQNOOVqyGGeIKQCwU7EXBZBl3myD7FMlUWjX7VMQ81H4lIrUUYbvnMZDGHDNyhjjSuJyOPHrXj5f9JJSJA3zfgCLYeW5+0BPyKsjttEb31m/rIjaIoSSWOmcrefaBBt67WD0O/zQgofNVQAzDEjVJc65EpCZw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(46966006)(36840700001)(42186006)(316002)(5660300002)(356005)(8936002)(70206006)(83380400001)(8676002)(7636003)(47076005)(54906003)(1076003)(26005)(4326008)(2616005)(336012)(426003)(6266002)(70586007)(508600001)(2906002)(36756003)(186003)(6666004)(82310400004)(44832011)(110136005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 20:23:18.6776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0020cc3f-8520-42d8-9e8a-08d9b37614ed
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT064.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB5635
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The base address of uartlite registers could be 64 bit address which is from
device resource. When ulite_probe() calls ulite_assign(), this 64 bit
address is casted to 32-bit. The fix is to replace "u32" type with
"phys_addr_t" type for the base address in ulite_assign() argument list.

Fixes: 8fa7b6100693 ("[POWERPC] Uartlite: Separate the bus binding from the driver proper")

Signed-off-by: Lizhi Hou <lizhi.hou@xilinx.com>
---
 drivers/tty/serial/uartlite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index d3d9566e5dbd..e1fa52d31474 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -626,7 +626,7 @@ static struct uart_driver ulite_uart_driver = {
  *
  * Returns: 0 on success, <0 otherwise
  */
-static int ulite_assign(struct device *dev, int id, u32 base, int irq,
+static int ulite_assign(struct device *dev, int id, phys_addr_t base, int irq,
 			struct uartlite_data *pdata)
 {
 	struct uart_port *port;
-- 
2.27.0

