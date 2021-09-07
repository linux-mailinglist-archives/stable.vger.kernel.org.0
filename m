Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0B040236D
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 08:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhIGG2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 02:28:13 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:35064 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231429AbhIGG2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 02:28:12 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18766sWY007858;
        Mon, 6 Sep 2021 23:27:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=zCs8pELIzXM2rvTEermT6rMldBLdbthsqdovSdtQglA=;
 b=Ikp8i1sfMEW8vwaM0R4pG+7pb1McaYLEmwC6b8/PoW5H8VtLWdF9PXABFjjOHzxk3UCe
 IIb+Z1zzZQGTIidcBjlDN0nE65uIRtKZgedMvzjFGTO0T2vMA37QgoGBZsAilrdlF15h
 JYdrR/zY2i2YYC/FMmFz/ZScyGMwDUhKLnNXLnJ0UczqeSLS9rIQRBB3ihZc9zZVmVCb
 JjL0MWyCcGAfxZd4gKjzrpcmlRo2k8xLJfCB/3r6aGxFkYAO98fjM0gdPgbbMcDLBc2B
 AoC5qIwKllIDbipyoZavoNGdaG2qkX1qhLVeqUqblypNwcN+zj+SoPG9Y+N/m9ivdmm9 ow== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-0014ca01.pphosted.com with ESMTP id 3awq6a1bgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 23:27:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJul0+iwwylk/e7Vlia95feoyi+9g49YuV2V7H3oTKEzXD8t/fvBBf5hRTMnqtM8LE6SKuL64G334Cllm2/8ZHO8Jt6xTsOS23KeSN9L85CYqkYq3wacqKSlko5S15kYcJjpFktMV3q7TQBbwypwlCLcrIKMgPsJ28xrSmGrfjKFHJZR038thyuo266CVcVWx0YToDonrznD08jk69XSFec+9a1yC+zydRSBOwB4j2UGsDFrDtaZhM/wxF1YebK8yk39xyEVFKJVo0WYKYpTScYC+Rsb3OPSig2Yninh6pn5mOvSREffG2ep0kR8a1hmYPMGT0HX46dvqixxcdsPWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zCs8pELIzXM2rvTEermT6rMldBLdbthsqdovSdtQglA=;
 b=dudYQlDaHev4h1aAM+03BTwN8RGzzVQ6ZAjLmkJIUrTsmWYPsbR+YCS56qfzEg/54YgEYhH5IYoZzU/NCrVSsPFHby0dV8pmcUvCPKg7J0ZtgTi2o+17VSVftJgQwUUL5+Ij0KeuhzUZvJASFaF5yLfXtAgqSvNc2Uc6EGpr1Mb/MgkXc6SUqS7dR61K2cP9vycQFwtLyMLf0oH59pNb/WW60YAcJRqKKh0ifBmfW1xkS0omAz4X99+meXTTcVxhC2FHVS178JhPSaUPwNy2eLJOL7WrzqJ17miUz7UO7xBqQhF6UDMcyDdmgtQXocXbNDuRVnCC51+jie06anImKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 199.43.4.23) smtp.rcpttodomain=ti.com smtp.mailfrom=cadence.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=cadence.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCs8pELIzXM2rvTEermT6rMldBLdbthsqdovSdtQglA=;
 b=Zr8GEmgJEapA0huHRUkuRqZRjXJApnQm7+Hz3+qodZG7cQ87iIAwEhuJLrpygM7PtRrDJBgSaH2w+DkiAE6dpp5uJtCZL3/H0pGtRCv+Dt5gAk2qmbhpLq8H3r0eY1JWBtj/MTe8l78+vBZr3iJxCgFKD2fnhZC8PXH9sRjAvf8=
Received: from DM6PR03CA0062.namprd03.prod.outlook.com (2603:10b6:5:100::39)
 by CY4PR0701MB3697.namprd07.prod.outlook.com (2603:10b6:910:90::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 7 Sep
 2021 06:26:58 +0000
Received: from DM6NAM12FT005.eop-nam12.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::30) by DM6PR03CA0062.outlook.office365.com
 (2603:10b6:5:100::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend
 Transport; Tue, 7 Sep 2021 06:26:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 199.43.4.23)
 smtp.mailfrom=cadence.com; ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 199.43.4.23 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.43.4.23; helo=rmmaillnx1.cadence.com;
Received: from rmmaillnx1.cadence.com (199.43.4.23) by
 DM6NAM12FT005.mail.protection.outlook.com (10.13.178.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.6 via Frontend Transport; Tue, 7 Sep 2021 06:26:58 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 1876QtBl003586
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Sep 2021 02:26:56 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 7 Sep 2021 08:26:55 +0200
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 7 Sep 2021 08:26:42 +0200
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 7 Sep 2021 08:26:42 +0200
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 1876QgD6035274;
        Tue, 7 Sep 2021 08:26:42 +0200
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 1876Qe3w035272;
        Tue, 7 Sep 2021 08:26:40 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <pawell@cadence.com>, <rogerq@kernel.org>, <a-govindraju@ti.com>,
        <gregkh@linuxfoundation.org>, <felipe.balbi@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] usb: cdns3: fix race condition before setting doorbell
Date:   Tue, 7 Sep 2021 08:26:19 +0200
Message-ID: <20210907062619.34622-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8536f0ba-d0ee-4994-21be-08d971c87ee5
X-MS-TrafficTypeDiagnostic: CY4PR0701MB3697:
X-Microsoft-Antispam-PRVS: <CY4PR0701MB369719D72645672BC2DA6548DDD39@CY4PR0701MB3697.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6mc7W2k9PFiPq479DcKRdXSODgy1rpfM99V/GP6RLeXsc2ucsWFJ3wm9SZOWbkTTPHRYPUo5xyN9p1xt88kCtBs3VH6Qb/7s77NRgYZsv8TBODGRDRaX5kDHL9Vcm1OqFRv+tcRWgIAVVqZomEHoxrN9IfU2gDrm28U/65UQOT69RPstApfphW4JCyAvuULFUBDMI8SeMtYJ4nParlqoInyzUAeHfMYtAqL8D2RF6bSbiSvbxW4ejiCp4ALcnqrVSKXhQafeZxDbZm44pXsRoU/iOJBfKTYPu8hhUbVDPREzKILlXtsHPp2t5vPTr/52f+1CS4rmqUA5/JXWb1VJ6rucwSbqM3PHm8s+a3Pbd8gS0ChW8X4lLsvz3uctVJQJoMcQGvTYBTXhXAEWILHgVaijb+fA4Y8zd8zkveJQkbu6LUDDlY4+cm1ImFtpHBZw6Z60lilamKi8bttjlnENuqg9h2lQsJNTfY7Gwz8l+T1MKa0I764ccCSU5DrQKjFmLSPOR2zK1L+32T/tQBpElHiVTk/h1CmNixrCiwzKvuY2Gn4JFrJsN9o/WZJJWGWw8C0jY+U72BNCBUZ0PTkdaHMn1Xdsi+G3t1OzdKxNyTxEJtYRBgM0phbvzzm9cXJLn3Huq5HKjxmIa36v1O4sQJ7qzTlSjsOnn+7ieKw9T/wPqeUKH/fC8qNvVcpox8tHYTfH6YZirY6OYgHSHkX4El64LWMmDxDuAlRdZUkcdngz6i9ufHe5AYGKz4FZoZxBr7TT2tWb55peyMRqK1fb6w==
X-Forefront-Antispam-Report: CIP:199.43.4.23;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:rmmaillnx1.cadence.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(36092001)(46966006)(36840700001)(42186006)(82740400003)(54906003)(4326008)(8676002)(81166007)(356005)(316002)(36906005)(2906002)(86362001)(47076005)(1076003)(6916009)(426003)(70586007)(36860700001)(478600001)(336012)(6666004)(70206006)(26005)(5660300002)(82310400003)(186003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 06:26:58.4826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8536f0ba-d0ee-4994-21be-08d971c87ee5
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.23];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT005.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0701MB3697
X-Proofpoint-GUID: qotqagHM0jSSMQwMFtuaHhuIRUAoXJp9
X-Proofpoint-ORIG-GUID: qotqagHM0jSSMQwMFtuaHhuIRUAoXJp9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-07_02,2021-09-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 clxscore=1011 impostorscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=701
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070042
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

For DEV_VER_V3 version there exist race condition between clearing
ep_sts.EP_STS_TRBERR and setting ep_cmd.EP_CMD_DRDY bit.
Setting EP_CMD_DRDY will be ignored by controller when
EP_STS_TRBERR is set. So, between these two instructions we have
a small time gap in which the EP_STSS_TRBERR can be set. In such case
the transfer will not start after setting doorbell.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org> # 5.12.x
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdns3-gadget.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 80aaab159e58..e9769fab21ea 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1100,6 +1100,19 @@ static int cdns3_ep_run_stream_transfer(struct cdns3_endpoint *priv_ep,
 	return 0;
 }
 
+static void cdns3_rearm_drdy_if_needed(struct cdns3_endpoint *priv_ep)
+{
+	struct cdns3_device *priv_dev = priv_ep->cdns3_dev;
+
+	if (priv_dev->dev_ver < DEV_VER_V3)
+		return;
+
+	if (readl(&priv_dev->regs->ep_sts) & EP_STS_TRBERR) {
+		writel(EP_STS_TRBERR, &priv_dev->regs->ep_sts);
+		writel(EP_CMD_DRDY, &priv_dev->regs->ep_cmd);
+	}
+}
+
 /**
  * cdns3_ep_run_transfer - start transfer on no-default endpoint hardware
  * @priv_ep: endpoint object
@@ -1351,6 +1364,7 @@ static int cdns3_ep_run_transfer(struct cdns3_endpoint *priv_ep,
 		/*clearing TRBERR and EP_STS_DESCMIS before seting DRDY*/
 		writel(EP_STS_TRBERR | EP_STS_DESCMIS, &priv_dev->regs->ep_sts);
 		writel(EP_CMD_DRDY, &priv_dev->regs->ep_cmd);
+		cdns3_rearm_drdy_if_needed(priv_ep);
 		trace_cdns3_doorbell_epx(priv_ep->name,
 					 readl(&priv_dev->regs->ep_traddr));
 	}
-- 
2.25.1

