Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEC7473C3A
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 05:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhLNE4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 23:56:21 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:59464 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhLNE4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 23:56:20 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BE3qT46012753;
        Mon, 13 Dec 2021 20:56:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=0gcUtkOkAWukKkLJMpUijg1Vj0A9izAuEmCDjMeTcdU=;
 b=GQw4M55j6BOUZjrBrJcBINCDhIWD7tdyAbuoX9farwFUDsLpCIS8zOLzRrMVIKYK3CBG
 yjHYrLywPSSesdJfHwUU5u5nDeWUULI9xL3SIrNH0rGJroMAkZud4O+HMRndOcVr4KaX
 WE3dcNojdY8ahwx0p3Mtr/5j3H3rUj+jx8p2i/Go0mKTxfxkqnHTZMxV7EyTLxwJuuO4
 JIdaQVKwvMn6TCJVPQYP4qV/wUsdMf7yztEsbZheFnp+3dIMGeALgjdM/JyduMu9OTpA
 iQjQv+3Yrcu3neq47PkqEnDJgddHbX30n/pkQd+QzRYLoxpQxT0J+x7v83hgJgH4ne0X qw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3cx9r1aguk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 20:56:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNo6SK0t9FUAB+T9m5matKjeGnOpVwzg5JFQbNPCYQlub+z6QZ1Z9db8kTHOBmec4Jic5s5fKMD59TNe/rSkAKDmwzun+dDvFIbgV0fvF2nBn12JzGB1XV39Q1Fmb/hZeeBdz701dsA0QhdIvtLwdWEZZBnYibEi8Uvh8TBA943o9A9RXu/Kh2kX+LR/zCJ1P5uyFkf6OdUD0D6G93GlMBPG4trOEvG99HZEgpmPSlw6d2pNGdv5I6DVUEfZP0bK+/fp9tAoKZTT2Kjvxxa4Wq1rODEzmXknKCnkSiIShMu6+T8ndVJmXOUEF8al/WcHnjaq/fjUZyX+SqTlBJc8dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0gcUtkOkAWukKkLJMpUijg1Vj0A9izAuEmCDjMeTcdU=;
 b=fE9gCPIvUOCJE2Z1cE/gWCoS/oGBzmNF+V3uvKePQ3SJtvptb/rBL2NcCmrlAaONC49lT7Lj0oY08AaQD0wzRLuF7kneGKU3zSeXQp9wtPfvimhZQkh+sIakgj+o/ecQ98djcNXqcBkjCX5dVC6wVso1rehVShPDdngR4L+jLGjYidyWQ1q5Z/+s69C9SEo4ni6PDRPqxGjVCVywLFV8UJUgo1NHCfJKLBSc9FUuULW4pjuAfRjkPBNvUDVfq44b1tXTFVcI1bJwitrI1AZB6L6GwbtUbe/faR/vTMWe4AALmoXmcCXYc/ovBk1WHuUQqdqlWg0tQEpqwPJ56kx4sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.148) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gcUtkOkAWukKkLJMpUijg1Vj0A9izAuEmCDjMeTcdU=;
 b=oDaPdYpuecJx0SoENGLWC+cn1z/MJ2NmD9zHRADnnQoJmAh7yFQ6M23SRaz0epIX1jZ2QAw3vsAM1omZTTUKDglcme2osE5bgNyuoYw/5n9LMCKThZyFO0G17bZpMVEjfFe9NSutK7bdhctQOa335idUqVVw9q1JpVm+3YwYgHw=
Received: from MWHPR10CA0049.namprd10.prod.outlook.com (2603:10b6:300:2c::11)
 by BN7PR07MB5363.namprd07.prod.outlook.com (2603:10b6:408:2e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Tue, 14 Dec
 2021 04:56:04 +0000
Received: from MW2NAM12FT018.eop-nam12.prod.protection.outlook.com
 (2603:10b6:300:2c:cafe::f5) by MWHPR10CA0049.outlook.office365.com
 (2603:10b6:300:2c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17 via Frontend
 Transport; Tue, 14 Dec 2021 04:56:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.148)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.148 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.148; helo=sjmaillnx2.cadence.com;
Received: from sjmaillnx2.cadence.com (158.140.1.148) by
 MW2NAM12FT018.mail.protection.outlook.com (10.13.180.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.7 via Frontend Transport; Tue, 14 Dec 2021 04:56:04 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 1BE4u4OE011402
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 20:56:05 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu4.global.cadence.com (10.160.110.201) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 14 Dec 2021 05:55:51 +0100
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 14 Dec 2021 05:55:39 +0100
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 14 Dec 2021 05:55:38 +0100
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 1BE4tcCb027175;
        Tue, 14 Dec 2021 05:55:38 +0100
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 1BE4tb25027174;
        Tue, 14 Dec 2021 05:55:37 +0100
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pawell@cadence.com>,
        <jianhe@ambarella.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] usb: cdnsp: Fix lack of spin_lock_irqsave/spin_lock_restore
Date:   Tue, 14 Dec 2021 05:55:27 +0100
Message-ID: <20211214045527.26823-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54c75538-0640-4bf0-4779-08d9bebe0867
X-MS-TrafficTypeDiagnostic: BN7PR07MB5363:EE_
X-Microsoft-Antispam-PRVS: <BN7PR07MB5363894991AF00BBA33C2969DD759@BN7PR07MB5363.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RIm/GHIK9TDOKu4V2wpf+Qv+XrZzi+AcgRFpMahfqg9VsUwG/WIBeCJm5HBfsXCyU59PCRWIiKHlOn0+0oL/MBG3swxvgs2pIxkkXB1toWEBk/lBOkCpqw1qqsp4V1iVFdtUfBvMGXA3EcCkgAhrPw0yyB06HHU7mUzBA0/U3xh+ofU6ORQSFjQaFstFPevF7DkL/HHeBrzTEvku00+V9xYOXXrnpYxYbVvPfJOIWqAzEIgPNBelVQmFmiSnJi3AJCare8iJxiFRgwCRnWUtJtXY6rsJVLWKh/kvSqN144bPUFp+crZBeGnDSss1CLD2rkcyiLfTdRMmOTmX97oOugWKnAWECYgEQFKqSHvNqV8b6Cn17Tm2z1lZi2JLV9yt5Ykd/bsTOCEEAd7Ml5E8wRk6fXXU5sJYhcT15JhkNJPph+fHxOcEf8LRADqPGrQrIzmxUvcNKZr9S4hBSUvmDEnk1Fbb7zRnNBrmEkZOrBu7jzoAvaadZgUewwdnVcjVHa+gsoXEZ6yqvMKjZErzafl+UG5CMemxmhFyAc51dDgNgLyhYFMjtUUn6E/afX0uBOPH2fP7YE26Eye1K/lnJgpVu17Om6AbLCcLNmO7rzQYW1V3J8W6s21/AQ+oHpa9mFAt0P3r+WBCXEIBAJGAiuoW7PMZsO2I+4uVK39EVod3B360wNxv/zqX9BZwoN/B1g4f73NjLY12YETTZMpsOzVxll6auGbaA7/v0A+6DEWaXX5RZ9rtE2XOqUy2fntqGW8XJ7R180HCSAdwiwTWMVwD66aYJKLKS6eBl0AOrgw=
X-Forefront-Antispam-Report: CIP:158.140.1.148;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx2.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(4636009)(36092001)(46966006)(36840700001)(40470700001)(356005)(8676002)(26005)(47076005)(70206006)(70586007)(6666004)(8936002)(4326008)(426003)(7636003)(6916009)(316002)(54906003)(40460700001)(86362001)(336012)(42186006)(82310400004)(5660300002)(36860700001)(186003)(2906002)(83380400001)(508600001)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 04:56:04.3060
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c75538-0640-4bf0-4779-08d9bebe0867
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.148];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT018.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR07MB5363
X-Proofpoint-GUID: yJ7QZtB54QxmHHUfJMmygb5LSRh51TbU
X-Proofpoint-ORIG-GUID: yJ7QZtB54QxmHHUfJMmygb5LSRh51TbU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_01,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=460 clxscore=1015
 suspectscore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140026
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

Patch puts content of cdnsp_gadget_pullup function inside
spin_lock_irqsave and spin_lock_restore section.
This construction is required here to keep the data consistency,
otherwise some data can be changed e.g. from interrupt context.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Reported-by: Ken (Jian) He <jianhe@ambarella.com>
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
--

Changelog:
v2:
- added disable_irq/enable_irq as sugester by Peter Chen

 drivers/usb/cdns3/cdnsp-gadget.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index f6d231760a6a..e07a65b980af 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1544,15 +1544,27 @@ static int cdnsp_gadget_pullup(struct usb_gadget *gadget, int is_on)
 {
 	struct cdnsp_device *pdev = gadget_to_cdnsp(gadget);
 	struct cdns *cdns = dev_get_drvdata(pdev->dev);
+	unsigned long flags;
 
 	trace_cdnsp_pullup(is_on);
 
+	/*
+	 * Disable events handling while controller is being
+	 * enabled/disabled.
+	 */
+	disable_irq(cdns->dev_irq);
+	spin_lock_irqsave(&pdev->lock, flags);
+
 	if (!is_on) {
 		cdnsp_reset_device(pdev);
 		cdns_clear_vbus(cdns);
 	} else {
 		cdns_set_vbus(cdns);
 	}
+
+	spin_unlock_irqrestore(&pdev->lock, flags);
+	enable_irq(cdns->dev_irq);
+
 	return 0;
 }
 
-- 
2.25.1

