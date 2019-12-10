Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D081184A2
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 11:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfLJKPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 05:15:41 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:48392 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbfLJKPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 05:15:41 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBAADLOY025730;
        Tue, 10 Dec 2019 02:15:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=hiRhBKQUbf+Gwxh5i0A9uYD615q9LAgbZGEwmtMTSJo=;
 b=sGXhH7/Lb4KMmd+gSQtdSO18KNRCiR/iiae49kxpiqjddqX+IOPtsjjrCihbs+U0CWqb
 GxTatQ86U5kNfvq+WuhDuV/vuwRzGOWn1hcM+lPWllURhdQGoMcmYeT7Oq0jCoLJM1MI
 4ifd/vxQQI2voV4haU7jDTsvJTXHH7F3cDd+DMd2wE5Sd864JkGm2hXD2j4rlBMh5aOj
 9jU12k8/3b59BkhFzuZooozazMctcnaNT11Tm45ZOql0F8W6LREIeZx2/t6tP7OOngzb
 egCfV6tE49QStkEj7MXS+R3VABZP+ajOe0aneGfcXFg1tBQrzyc9W+2BI+fKb3NRjzLB gw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2wra709bmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Dec 2019 02:15:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZJk05LDOQILTBYZGsi8f+F6InSXIy1rVU8j8BtaTljnWHlvo+x8aMwQAYOhpG5qCVdMoWoX4Owmad1UR1UgZkouLuESUDTacdkuMBL+iNRQjzyoEOeFRgFwOi/jG8bPhKDczXRNlH4rzBc8vZu9nzQ7Y0kX/+2UsGbSHoyfoUUj/XXlp1B5TKiOqZwlZ6p82bU7Vk7Ur0BY/nCerh7R1TbGxJLbiIGDfkWaIFmYtaFcWXALX+d/me3fkYqfzPC7WCDX8AZrvSFUag3YrE7pOqFIDGIa1AGWI+xnqhbXNZxnUsA+4aJPxZsv4V9zzS7Dhk/H3L11DVG1KAVCHGQeCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiRhBKQUbf+Gwxh5i0A9uYD615q9LAgbZGEwmtMTSJo=;
 b=CDb4Afj5CPgC8qzWe892pRUEaw2hhyhMrnbGijkJKBBsumQnaW0XiUiMMhvxRUqle2oOYucY5xXu6EFRIGsfvBKUbuBeJzSJKuPFpxAPlAG16V2oWo0MJYTUt2psR3/q33aBnrTHlQAbkWFUGyCFdRApfalSG1kgaCK95jdUj5NRKPR8+XTJKiDzUcGBxef4XsUC+8ziQkmM/YIe0FLWA2ALZrsgQw6HewzWB46inzkAaF7sz6a0ue1KZjyLeVKxtr0k3BQcOg3hEE0J5vhevLf9dv0sTAlFd3C4XNYW9TC/74vCwvUZpzE9YSo2eRo4gBmS9upPq2MRtUNZReWqTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.28) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=cadence.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=cadence.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiRhBKQUbf+Gwxh5i0A9uYD615q9LAgbZGEwmtMTSJo=;
 b=VxLIdOTVbOmaocyagjHba2pM7a4MtWg5QAq840g9zQPEMs8WTY1BQf9R1YBRZE87mbbyfmxOypRIZQq5+kZITw6HlJ3zgK2lgiEYNIdgo/vjk7LW+ywd98Ey6ZSvDUUzDnEJuI+tUIu0GnKsBWtGjluMVOhXFHEt9vzjw3IRBlg=
Received: from MN2PR07CA0002.namprd07.prod.outlook.com (2603:10b6:208:1a0::12)
 by SN2PR07MB2686.namprd07.prod.outlook.com (2603:10b6:804:a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.17; Tue, 10 Dec
 2019 10:15:33 +0000
Received: from DM6NAM12FT031.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe59::208) by MN2PR07CA0002.outlook.office365.com
 (2603:10b6:208:1a0::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.13 via Frontend
 Transport; Tue, 10 Dec 2019 10:15:33 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.28; helo=sjmaillnx2.cadence.com;
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 DM6NAM12FT031.mail.protection.outlook.com (10.13.179.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18 via Frontend Transport; Tue, 10 Dec 2019 10:15:32 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id xBAAFTmU004194
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 10 Dec 2019 02:15:31 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 10 Dec 2019 11:15:29 +0100
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 10 Dec 2019 11:15:29 +0100
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id xBAAFTtc009284;
        Tue, 10 Dec 2019 11:15:29 +0100
Received: (from pgaj@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id xBAAFSgx009251;
        Tue, 10 Dec 2019 11:15:28 +0100
From:   =?UTF-8?q?Przemys=C5=82aw=20Gaj?= <pgaj@cadence.com>
To:     <bbrezillon@kernel.org>
CC:     <linux-i3c@lists.infradead.org>, <vitor.soares@synopsys.com>,
        <rafalc@cadence.com>, <stable@vger.kernel.org>,
        Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v4 1/6] i3c: master: make sure ->boardinfo is initialized in add_i3c_dev_locked()
Date:   Tue, 10 Dec 2019 11:14:57 +0100
Message-ID: <20191210101502.8401-2-pgaj@cadence.com>
X-Mailer: git-send-email 2.14.0
In-Reply-To: <20191210101502.8401-1-pgaj@cadence.com>
References: <20191210101502.8401-1-pgaj@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(346002)(189003)(199004)(36092001)(246002)(4326008)(2616005)(42186006)(107886003)(8936002)(26826003)(6916009)(478600001)(86362001)(316002)(36756003)(26005)(54906003)(76130400001)(186003)(1076003)(6666004)(336012)(426003)(356004)(5660300002)(70206006)(70586007)(2906002)(8676002)(7636002)(70780200001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2686;H:sjmaillnx2.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 548aa5de-52ef-4f81-01bd-08d77d59e423
X-MS-TrafficTypeDiagnostic: SN2PR07MB2686:
X-Microsoft-Antispam-PRVS: <SN2PR07MB2686DAC5F8494A9407731B1DC25B0@SN2PR07MB2686.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 02475B2A01
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+PgVZDGQe5FMjFpxzIum+dJqntE9Qbt5TLSuh0kqDeucgelNW24LqlcmHplcqkl3nBguVzWImuSHP4NtPwHI5/jC+JqZ+soqpVNC8WkuLadQ0gYoNDMfVp686yAVIa9wppMVB1vX+l0X8j3Vo/Ulm01Nym+SdB6tZCMbItOV5ByxVnzZcqSKVkdt8EUuQpRQ46QbgBsLxlfmMWH+whckQnVKnG+IY1DEAT/DazNc0rjSVNhtUR+Ae9Seuk2Tnx0iRfmR6APciwoeSCabshAX1Nc68rXkVnRBTFkLAxn/yiiGWdgQCCvcejEtQyRwo3clnD0SyiA7AHI3SgZG4/Bs+2JctWh3oVAUKyK/9BrUDX4TagEFb83qrXyCuUX1YPiKzcTXXsV/Qv9dUz8UA0FwZC5gOy6sp2QbC46H+yiBonCsApccFbHWv1VpeOqo/i/tT7+9Ao6A9jIlhygwgOxVLl4G2UzGEjkxJuSWY/zvv0p75N2xz1tMGzsDj+k7W51faDzgMdRe4u+pIPXj1/eSA==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2019 10:15:32.8214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 548aa5de-52ef-4f81-01bd-08d77d59e423
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2686
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_01:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=999
 suspectscore=1 malwarescore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1011 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100090
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitor Soares <vitor.soares@synopsys.com>

The newdev->boardinfo assignment was missing in
i3c_master_add_i3c_dev_locked() and hence the ->of_node info isn't
propagated to i3c_dev_desc.

Fix this by trying to initialize device i3c_dev_boardinfo if available.

Cc: <stable@vger.kernel.org>
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
Signed-off-by: Przemyslaw Gaj <pgaj@cadence.com>
---
Change in v4:
  - Remove addrstatus check, this will be sent as a separate patch

Change in v3:
  - None

Changes in v2:
  - Change commit message
  - Change i3c_master_search_i3c_boardinfo(newdev) to i3c_master_init_i3c_dev_boardinfo(newdev)
  - Add fixes, stable tags
---
 drivers/i3c/master.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 mode change 100644 => 100755 drivers/i3c/master.c

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 043691656245..5c06c41e6660
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1774,6 +1774,22 @@ i3c_master_search_i3c_dev_duplicate(struct i3c_dev_desc *refdev)
 	return NULL;
 }
 
+static void i3c_master_init_i3c_dev_boardinfo(struct i3c_dev_desc *dev)
+{
+	struct i3c_master_controller *master = i3c_dev_get_master(dev);
+	struct i3c_dev_boardinfo *boardinfo;
+
+	if (dev->boardinfo)
+		return;
+
+	list_for_each_entry(boardinfo, &master->boardinfo.i3c, node) {
+		if (dev->info.pid == boardinfo->pid) {
+			dev->boardinfo = boardinfo;
+			return;
+		}
+	}
+}
+
 /**
  * i3c_master_add_i3c_dev_locked() - add an I3C slave to the bus
  * @master: master used to send frames on the bus
@@ -1854,6 +1870,8 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
 	if (ret)
 		goto err_detach_dev;
 
+	i3c_master_init_i3c_dev_boardinfo(newdev);
+
 	/*
 	 * Depending on our previous state, the expected dynamic address might
 	 * differ:
-- 
2.14.0

