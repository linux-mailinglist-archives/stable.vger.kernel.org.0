Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC11538A2D9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhETJqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:46:36 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:28400 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233751AbhETJoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 05:44:20 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K9fa7n003976;
        Thu, 20 May 2021 02:42:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=DAgyhIRVrBSoB2/6sf7dRqWXYiQ4YlaQLRPMacA9Xfo=;
 b=P5IuVXvZzMZhHKb79y761qAzqCq6/giimFGm0RilXK6P+uj270FzjQi99m/hHNjw/Xc+
 O8gSkk0hTmo+Nzkvybq31SayIDixPgPd3WP/worksE35aVSEDTKyqZNA0vcyed9eTukK
 TPixW+gj7EFum+JEA5iiOfa45MzGM2BgOOFPqzf2F6wdotvqSiSaKTfFBCUmZyS3jXWU
 MlcmpHlU1YqSV6uvu31eGf/F684cOfRuPVtWVi44Men+Y6DpyjpKtVytMHgAM0HYmoCM
 n8inEM3ISC8IHY6v0kTqbkS2oT8UoiuvgRX4AHCcaJjtkyTZRg7fmQ1MMtQKRUNhsZhC YA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by mx0a-0014ca01.pphosted.com with ESMTP id 38nn3p0236-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 May 2021 02:42:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=entyd1tQIHHwgDX0k38iVEaiW4OE+BKbduXVVD9T+WaqLS4pqcUNYnLff2oTh39M7MR/yKrjnoD5yI/jXUldow58O7TeW5weDT82NSIy7FAOrL4YBvLRpnCOdp/lLLBehm2BncZdCBa/ZWTvh8Sl2n5jY+PXqn3JeHi16gX/BkHdEpVh1f13IH5NV+hQOsX66DbXBRGx1pnfML319T/tgMiIpp/lWmLr6w6KtPltxrRY3h5yhJsDvS5VClmylIJBVk1rLBNMZohz1LU0wcpgtW2z6bgBSJpFbTGEPiSNb3iNJG92HVnKxceJGp/J/MTAh8Ut84+ADlKEDMeV6KOcnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAgyhIRVrBSoB2/6sf7dRqWXYiQ4YlaQLRPMacA9Xfo=;
 b=GfDFPOxXDiT8UjmK6c7C5Wc2XxyjmhUH7X9Ceb6Dt4gYpaMKxxKJt+CcTS7HIoSuc+y5EEeIODwpAcVCn+P+DaVJGB3ktPeYpFcYHqM4u6NYsEjqw+vA731Z+ytMGecdJB6jIeBtOjkpi3Ne2L4FUnjP11pC46AzaNc7dYIvF55WWUnunkwvW88hgHNS9OeFi/M8d7ZwmDf47yRCRZAyn38FCvr3uK7yw5SG9WZIts4026ewoc8Wa3LPLFm51a7VuZwQqWQMk06QI2pL7QYb4br/+U1TMgDNYSJ8EWs0gt5YA+thpcplGWnPhpIxQMNb9LzhpSYEswKku1Nz4eixwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=cadence.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=cadence.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAgyhIRVrBSoB2/6sf7dRqWXYiQ4YlaQLRPMacA9Xfo=;
 b=o8gECtp3gR7LH2ldGDu19WF90SqA6Yw+iuoqnfrXy8mJPUPZ9vK30uxxAzQOH/zmKawXG+klTW42yh6tbmKeIA2vduC8h5PbIyceo7U0Yo+TAJt4inZNW2j2Y/g5fD6AB6QnU5SNwkpMsyyWWe+Ncj7eVDXcgtbTx64qKRlTaQQ=
Received: from CO2PR05CA0005.namprd05.prod.outlook.com (2603:10b6:102:2::15)
 by MWHPR07MB2800.namprd07.prod.outlook.com (2603:10b6:300:1e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Thu, 20 May
 2021 09:42:54 +0000
Received: from MW2NAM12FT063.eop-nam12.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::b3) by CO2PR05CA0005.outlook.office365.com
 (2603:10b6:102:2::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend
 Transport; Thu, 20 May 2021 09:42:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; linuxfoundation.org; dkim=none (message not
 signed) header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 MW2NAM12FT063.mail.protection.outlook.com (10.13.181.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.11 via Frontend Transport; Thu, 20 May 2021 09:42:52 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 14K9goXR039432
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 02:42:51 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 20 May 2021 11:42:49 +0200
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 20 May 2021 11:42:49 +0200
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 14K9gnm8014856;
        Thu, 20 May 2021 11:42:49 +0200
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 14K9gm7L014855;
        Thu, 20 May 2021 11:42:48 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <kurahul@cadence.com>, Pawel Laszczak <pawell@cadence.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fix deadlock issue in cdnsp_thread_irq_handler
Date:   Thu, 20 May 2021 11:42:24 +0200
Message-ID: <20210520094224.14099-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cee5efb-ce0b-4e06-199e-08d91b73a364
X-MS-TrafficTypeDiagnostic: MWHPR07MB2800:
X-Microsoft-Antispam-PRVS: <MWHPR07MB2800CAAAD3D64BBDC7F672CCDD2A9@MWHPR07MB2800.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qU+pAuKPP/PHZtZqaR6s9Bf0dkdkgwAOvTYVmZOTSneKMFwegjJLVqHZSGj8XnbuA05ooINI/IRaZxGtiKJvz2tbYESaScjBbuKu96YMwuWVYHNBlUwBt/0ViD66wnTt22QoM1KNdSO5MjydLG/EAvWypcbXpgVUcwnZz6gJv1VrvgkwJ6bA5XCLqw53kXgyzohdGkmfYi2DLhMaZldP3nc22/AVRH6z6NcApE0+aeUIflG8TgPR16nVuc3AG9mpph0eZgDnH3IbpSvJHoIkc2psHIYuKRxNs1MQZ4xxTdw0sRPAAeMntsyEE8hP0HHyfRsuKEvMqA86k0VBD3d3knssLs4JitxktxKb/eVAXoIrZRHC01eeAxzDdENvJHjUO74QyEMdX41x46MuBJ3c6rhk4kv0J62tOo/1ZhRTMSryiCvJhtzCREoe3hpJHflOhEkwdwWcxUF9PJOoFCEUYO2WBm80nkEQwMM4bft2lYLH3rLPpxjFBrt3fF2Qe/JCQ2/6Myqw1GDc9Ar5PFpjZDeKoHKJ/D340LqXpMf850yl/0gHmqiISwOT30I2ixXeLKOQa91kXE895E8wDemMMFNgfWl4chj22FwCEV/rDXUqrZxl4jyDxb56ZVBCRZvAHr07deF8V86i9YC1bGCfUTIk09p6pH9dAOC6q1VnOkAvr8EDxCSy9BFr7YVAKGID66DRmi0JbLaKCZIady73mg==
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(36092001)(36840700001)(46966006)(82740400003)(83380400001)(86362001)(6916009)(186003)(82310400003)(36860700001)(81166007)(70586007)(356005)(70206006)(1076003)(47076005)(8936002)(8676002)(316002)(54906003)(478600001)(42186006)(5660300002)(336012)(426003)(36906005)(2906002)(6666004)(26005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 09:42:52.5541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cee5efb-ce0b-4e06-199e-08d91b73a364
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT063.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR07MB2800
X-Proofpoint-GUID: 6wqWCIVQCB7TwXcjfb_ZRvQuLPtZJhcn
X-Proofpoint-ORIG-GUID: 6wqWCIVQCB7TwXcjfb_ZRvQuLPtZJhcn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_01:2021-05-20,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1011
 suspectscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=626 priorityscore=1501 spamscore=0 mlxscore=0 impostorscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200072
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

Patch fixes the critical issue caused by deadlock which has been detected
during testing NCM class.

The root cause of issue is spin_lock/spin_unlock instruction instead
spin_lock_irqsave/spin_lock_irqrestore in cdnsp_thread_irq_handler
function.

Cc: stable@vger.kernel.org
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-ring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 5f0513c96c04..68972746e363 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1517,13 +1517,14 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
 {
 	struct cdnsp_device *pdev = (struct cdnsp_device *)data;
 	union cdnsp_trb *event_ring_deq;
+	unsigned long flags;
 	int counter = 0;
 
-	spin_lock(&pdev->lock);
+	spin_lock_irqsave(&pdev->lock, flags);
 
 	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
 		cdnsp_died(pdev);
-		spin_unlock(&pdev->lock);
+		spin_unlock_irqrestore(&pdev->lock, flags);
 		return IRQ_HANDLED;
 	}
 
@@ -1539,7 +1540,7 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
 
 	cdnsp_update_erst_dequeue(pdev, event_ring_deq, 1);
 
-	spin_unlock(&pdev->lock);
+	spin_unlock_irqrestore(&pdev->lock, flags);
 
 	return IRQ_HANDLED;
 }
-- 
2.25.1

