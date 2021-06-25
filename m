Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004FE3B469C
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 17:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFYPaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 11:30:06 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:46278 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhFYPaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 11:30:05 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PFQqTE021331
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:27:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=u4ifWHlNx7DqztQSSpePZIABwiwUcK4QCRqHFFVmBkw=;
 b=Hx/E5qaTN/xooscdGrMoIB3rG3h9CFPV7TJMKlHttVXW1chyC3K25ZpHyCmzstCPHKro
 24Y57l3YrVQ4Zu8l/0f8MgYgdRxsmYT+Ml9U1tHM4EpG6kOIhVh4v1iaCHZDH91bCVSz
 w/cxjx4th7beQWr5vHt7J1tie+MyF17CUttY0JkNz/+c+/5bWCaFNlRzF0Gbh5cUNkNP
 OndNsvScpKW61OD5hod4AOEErbKBLaUN+agetTagwgMvcnb4oFwBGtuSQdQglTjvlvuz
 L1lOVU3AtqG1RDR0DiHp9GEy+AWf8674Gy2JgoorhwaRAhbRRJG/eKVXa76GikU7VT92 aQ== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by mx0a-0014ca01.pphosted.com with ESMTP id 39d22x3tex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:27:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVLeqhbGN7XkSrjO7V4CuIVfm8pD4zPlY+84tAsBajKY+ZV2/BtYGCDbI1ujFaOpDLAl3fAMBd2+loKnXpHC9itxhr7ez1JjYNjwHLKuLjJsP84Od3Dcw5rOEY30ip8N04e1fPsUI7r7WjP9D1i1u2DVUOtvrkcjTAfk6p2fcEc6ew1WJuDIW70x5f5jdcbDhNfzpN8vrhGYijNIYf25iROT/NsjM/5X3UpM8t9LAvJ5CmBn59elpmNeXqt1dsI4R0Z043uAFbvzE4ocefS1zJpBfH0ucUpz6n3fPVn5VJ20hBdxF4dyy9vZiDxvgUp1BkS1VGoRnh5VyRztLYDjvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4ifWHlNx7DqztQSSpePZIABwiwUcK4QCRqHFFVmBkw=;
 b=e+/fslTNZFOIHb4rxDPDhWlj3RNbSvZdWYX67RvC2ifR3HfQWBo1GbGER6SELsOXeuwM1l1ZJ/yCSrqQ+wsm0uxUd1WTtAFsXO9dxxvMCkVRX+CW/9qm7pbw/h9RzzaQw468vXLlQC25lZsHy5ZWOe7WORscIxYQbOyZfkVgohZ+yGanozldNZcRb3AHSGFbRXCQL7DFpG9IK0L6aT9W5en0HS3X4Wtp12fdynklUk15q+n4sH8s0K0LMOx9t95u222L16h1ldIIj87H9ipHt5oa9llmTmX1TJQJBgng8bsw2Ad1aIW34Bhd1K4NOHrnkPIs8fUW8y2yi/CCwg8MmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4ifWHlNx7DqztQSSpePZIABwiwUcK4QCRqHFFVmBkw=;
 b=CsThOrftA7qhFX4/52Tkk9XhGBzJQauVOxXgR9xnZfmsThJCKjIbh1743H44oU5Ef4dKT8WR5G8UrA4OtBQhSKh3+2qTkdrgD4f0CWOeTZmIehuTG9Eg/UwB/rn2V1PWt1lydfbF8Za6wDCio8G+qQ11cnkQkQBqZbhODhPqsUg=
Received: from MW3PR06CA0008.namprd06.prod.outlook.com (2603:10b6:303:2a::13)
 by BN8PR07MB6403.namprd07.prod.outlook.com (2603:10b6:408:b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Fri, 25 Jun
 2021 15:27:38 +0000
Received: from MW2NAM12FT040.eop-nam12.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::34) by MW3PR06CA0008.outlook.office365.com
 (2603:10b6:303:2a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.21 via Frontend
 Transport; Fri, 25 Jun 2021 15:27:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 MW2NAM12FT040.mail.protection.outlook.com (10.13.180.228) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.8 via Frontend Transport; Fri, 25 Jun 2021 15:27:37 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 15PFRZ9c211073
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:27:36 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 25 Jun 2021 17:27:34 +0200
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 25 Jun 2021 17:27:34 +0200
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 15PFRYdP016856;
        Fri, 25 Jun 2021 17:27:34 +0200
Received: (from sparmar@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 15PFRYjg016855;
        Fri, 25 Jun 2021 17:27:34 +0200
From:   Sanket Parmar <sparmar@cadence.com>
To:     <sparmar@cadence.com>
CC:     <stable@vger.kernel.org.#.5.4>, <5.10@cadence.com>
Subject: [PATCH] usb: cdns3: Enable TDL_CHK only for OUT ep
Date:   Fri, 25 Jun 2021 17:27:34 +0200
Message-ID: <1624634854-16815-1-git-send-email-sparmar@cadence.com>
X-Mailer: git-send-email 2.4.5
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99079b40-b051-4fab-79b7-08d937edc348
X-MS-TrafficTypeDiagnostic: BN8PR07MB6403:
X-Microsoft-Antispam-PRVS: <BN8PR07MB640370E9C1EA7585AE6F10C1B0069@BN8PR07MB6403.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:299;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VJ8KIH3k5Rk1nOFGpm87Da6SM5ImgVamZg+t4vACrg8Aw/EGeHLrsnPwwAfFQCdswUV+pxVy6pIoJPCR5TL+Zg6Io4F8jYaNWvGzVNWsgke8SiG4hW0bke/3b0yHRyf3rJNaEcTf1cLLxxBlcUTnw71uxAI2nShcgPZp/UE9mEmKaVp6Iwa3MrC262KjEiWvNbjoUOns9Lz5x1ofDL6Z/J1DFyrykJEQj9nduReozZUzMlI9g+kY3pxUzChje4yTxhta8YxEdFFuGneIdCpX+KHgzHo6ZfJUX/M1hYkyaIEBV1QnzMxfmKnAPOopuxW0RBrSQtbayjvMuMD9ELb+wXndI1NG6YOd6MllGo0BL4B3WWyuy7RZvB9wHEGRLhKPRE4cihBLpColUXnjodAgJwvlwcTdThXzSpXzeZyfDLIot2B03YlsvZXZNg3u2EtLxDcnk85DTc+4zP0HhR0qK7BNfmcGx7ZMvSvaSAzLFXakbAJ0dZx7ULb1BLJnyEOx4APWqvBE3dWQRIjBtKEP0wVs3FtTQlAYJP4V1pbKE3BB/GApolcyq6f24+AJR5mqF01y9fsLIsIMxh4w4Ck+o0UOTDKyE/tWxssNoc+HZ97MRNMyuoOCXzpjNwy77hWlKH36/54xzwZB1S81aENKPGG6OERid9zvbXugY/GVqRijba7noPXoTLa2ROG0TLZigL0wmb/UdOx005zD9i86uA==
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(36092001)(36840700001)(46966006)(478600001)(7049001)(82740400003)(36756003)(2616005)(47076005)(70206006)(70586007)(86362001)(8676002)(37006003)(42186006)(316002)(426003)(356005)(2906002)(8936002)(81166007)(336012)(6862004)(36860700001)(107886003)(83380400001)(5660300002)(26005)(186003)(6200100001)(82310400003)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 15:27:37.2169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99079b40-b051-4fab-79b7-08d937edc348
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT040.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR07MB6403
X-Proofpoint-ORIG-GUID: mK895RQpEwO5DEap-ykT9gcgZhpp0RD0
X-Proofpoint-GUID: mK895RQpEwO5DEap-ykT9gcgZhpp0RD0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_05:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250090
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d6eef886903c ("usb: cdns3: Enable TDL_CHK only for OUT ep")
upstream.

ZLP gets stuck if TDL_CHK bit is set and TDL_FROM_TRB is used
as TDL source for IN endpoints. To fix it, TDL_CHK is only
enabled for OUT endpoints.

Cc: stable@vger.kernel.org # 5.4, 5.10
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reported-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Sanket Parmar <sparmar@cadence.com>
---
 drivers/usb/cdns3/gadget.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index f32f00c49571..c3bf54cc530f 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -1531,7 +1531,7 @@ void cdns3_configure_dmult(struct cdns3_device *priv_dev,
 		else
 			mask = BIT(priv_ep->num);
 
-		if (priv_ep->type != USB_ENDPOINT_XFER_ISOC) {
+		if (priv_ep->type != USB_ENDPOINT_XFER_ISOC  && !priv_ep->dir) {
 			cdns3_set_register_bit(&regs->tdl_from_trb, mask);
 			cdns3_set_register_bit(&regs->tdl_beh, mask);
 			cdns3_set_register_bit(&regs->tdl_beh2, mask);
@@ -1569,15 +1569,13 @@ void cdns3_ep_config(struct cdns3_endpoint *priv_ep)
 	case USB_ENDPOINT_XFER_INT:
 		ep_cfg = EP_CFG_EPTYPE(USB_ENDPOINT_XFER_INT);
 
-		if ((priv_dev->dev_ver == DEV_VER_V2 && !priv_ep->dir) ||
-		    priv_dev->dev_ver > DEV_VER_V2)
+		if (priv_dev->dev_ver >= DEV_VER_V2 && !priv_ep->dir)
 			ep_cfg |= EP_CFG_TDL_CHK;
 		break;
 	case USB_ENDPOINT_XFER_BULK:
 		ep_cfg = EP_CFG_EPTYPE(USB_ENDPOINT_XFER_BULK);
 
-		if ((priv_dev->dev_ver == DEV_VER_V2  && !priv_ep->dir) ||
-		    priv_dev->dev_ver > DEV_VER_V2)
+		if (priv_dev->dev_ver >= DEV_VER_V2 && !priv_ep->dir)
 			ep_cfg |= EP_CFG_TDL_CHK;
 		break;
 	default:
-- 
2.20.1

