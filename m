Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745133B467E
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 17:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhFYPWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 11:22:33 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:31470 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229445AbhFYPWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 11:22:32 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PFJsHf004836
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:20:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=u4ifWHlNx7DqztQSSpePZIABwiwUcK4QCRqHFFVmBkw=;
 b=NjAD8SS7eLSEpoWLxHRiYfHaovgNewN2zw4lgPsQv7JubZGf5+QeT1yZMT+M07a+7W9l
 4knxHtuLRKZnvzAuzhZzlljh7CGGQPL5kbKDkAfXZA2b5oC7I2b4ac+NHFUbYfT3sc06
 n1z610t+/nxdwQMoa077MdnI340y1cNxoQ1mnOSvTnnm2o3WI+l2UWkgQRnwQDqq/AlC
 ZrZJxcm2fbFLJWAEwbZHSmczos9BOSkhuq4oHZkOI36HRcCin0fm9ZUnfX6qKyCIW5Zn
 JAauFa9KhbntV7AwPS4NZIF64G7i6GxsOvGgq6/u2XX89yfulpySMr9JKg1Gk8paCBYC 2w== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0b-0014ca01.pphosted.com with ESMTP id 39d23c3wn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:20:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Srm0A60wkmMZIFGsfo5Pn64vOXvW1Y1iR7et2M9M8Hc1U8SmY0cFnbS9HEA6YWD0JE6clu32xk7Ug8KmTWwGtJSG+37H1coyu/ZZNf1xS8XsTs1nv+qWBju/rTd6+Y3cNV6+B0iuI989aABwVshaK7MJwxt2ONBg8zD7lz2+O5HtTVbC7le6oq6yZdIxsXyKfKay/P+sVFd1Cq+WmB46vw3jGr14+PnuHC/9AtQa/zG/dfB5hjCuquAPPGTvYdJEOHU1cg81fKKxIFaP8t4xrK4jIo7zMp8z1HmglOKlV1SWKtcLNlzmHiB2lviLp0Shoop9A1CtpsKscYrWInT2AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4ifWHlNx7DqztQSSpePZIABwiwUcK4QCRqHFFVmBkw=;
 b=YWd6vAxSJF87l6nw7MSQlK7ZJWFhE7nt9onF1qNdb6e3403Ez0qSHttLx9dx3n+xTlsMI+K0tqbIrjkbqlMvkK8TrDedab9zxI881/xyYIhnk0mfo5bt9f3q45zHhdABeQXwxey7clJY5IL5ptu9pTxDkIEYoRb23IQYUCW/Pw/lSPnWccdkmih5dP0ros/qAvQkUc5s+qPxzyw8tYQAkQ3zrdgruNnFKEtnV+6L0SR2vCK0WO6SvqXv3qAVcZLbaMItBMmSQeywK4fev+uPjQriBArw2QMwH1oWVTUG+0rZMQy/DMKVgHf0hDN1jRXa0F2fcHVHIHcONaN0OyV2QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.148) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4ifWHlNx7DqztQSSpePZIABwiwUcK4QCRqHFFVmBkw=;
 b=R2dfYHoSRNAutz+M7/At0OAPwJkEHPxqFrCZWAOVMgHzkVvIj1V9VgDlupmivwCwsxd45wn22JX2hsZWc6OfGcWagop6fFD2dOO2If4FPNqP5g+sB8qG9YfnujASzG0A2yqfzUdbG5OoP+l5eqb58nRAaNObTlhAcbIjeT1GBOg=
Received: from MWHPR08CA0040.namprd08.prod.outlook.com (2603:10b6:300:c0::14)
 by SN6PR07MB4270.namprd07.prod.outlook.com (2603:10b6:805:54::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Fri, 25 Jun
 2021 15:20:08 +0000
Received: from MW2NAM12FT044.eop-nam12.prod.protection.outlook.com
 (2603:10b6:300:c0:cafe::bb) by MWHPR08CA0040.outlook.office365.com
 (2603:10b6:300:c0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend
 Transport; Fri, 25 Jun 2021 15:20:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.148)
 smtp.mailfrom=cadence.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.148 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.148; helo=sjmaillnx2.cadence.com;
Received: from sjmaillnx2.cadence.com (158.140.1.148) by
 MW2NAM12FT044.mail.protection.outlook.com (10.13.180.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.8 via Frontend Transport; Fri, 25 Jun 2021 15:20:07 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 15PFK5wC017589
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:20:06 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 25 Jun 2021 17:20:05 +0200
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 25 Jun 2021 17:20:05 +0200
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 15PFK4RF015298;
        Fri, 25 Jun 2021 17:20:04 +0200
Received: (from sparmar@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 15PFK4o3015297;
        Fri, 25 Jun 2021 17:20:04 +0200
From:   Sanket Parmar <sparmar@cadence.com>
To:     <sparmar@cadence.com>
CC:     <stable@vger.kernel.org.#.5.4>, <5.10@cadence.com>
Subject: [PATCH] usb: cdns3: Enable TDL_CHK only for OUT ep
Date:   Fri, 25 Jun 2021 17:20:02 +0200
Message-ID: <1624634402-15255-1-git-send-email-sparmar@cadence.com>
X-Mailer: git-send-email 2.4.5
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e66b663-fab9-4fa2-9f67-08d937ecb754
X-MS-TrafficTypeDiagnostic: SN6PR07MB4270:
X-Microsoft-Antispam-PRVS: <SN6PR07MB42709650985706C5E3B0A1DAB0069@SN6PR07MB4270.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:299;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3I+cKLEA+GOKyQOqZHyXg6UE8IWvqGLAwKVKQxxxrZx8CF+hSa5c1r8hZ0Ap1iioSlbScKEZe7wgBeuT17zfj9yUN1s9XHY/WBAgVlhe/b6cTmrpNfdIMmnZoNDQ2TptjOaMm7Bmj/77DGPcTv2biW0cn3DJOARxvRJrXua1WFFZJy2YlLqcaEmCQVzT5UHqyIc7lro6cpt1y6c4J7Xlh8ldwCNCxy0JL9Tvoo4lv2LW5UUkGnRFUnlaW2zGpoOnw+g5GROC2yCJ75emMaWUt4diVHo7yqKCobxeCB0TOfRMUnioOCNPuzXLD8Mit2F4hsAeYQlFFF7ZRqttTYRhoaVZHxwZMwvrDQHq5vzyHmcGZohZJz/vVo7kewLaPFZDFqAAhBAER8jFG3LmrxfIRgwA+16vaxLGSXQrb+W7HvOfsK3FwAGngmiMTp0tb6rEnrC3R8vzqHiVVuUy30UZ8hrxgu4iiJ8RS9i25mnHDI9OuoZph4J202zUgbGhnrwDKIO3JQLAnmmI5385gZrVCB8wS1tePg9osibQNNxaUeJBxofBB0H/KCUmOFjeL1J0J/wjqORo1jZdv0fpiJgkii+cJPcmfMLdD+pV5AFJ9ZgeLhYkDQITS0Ua7opalMTASM05hm2Uooe39bPoZJ8mfivGTwICVckmKFEHFzDys95ol2jCEDBfiaKngYErOCOIzxQG8M2sGcBE77ySsAaf9zBYeKn9J/vH/zhG3TNtPY=
X-Forefront-Antispam-Report: CIP:158.140.1.148;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx2.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(36092001)(46966006)(36840700001)(42186006)(316002)(107886003)(4326008)(37006003)(2616005)(186003)(6862004)(356005)(82310400003)(2906002)(70586007)(36906005)(83380400001)(26005)(8936002)(5660300002)(36860700001)(36756003)(478600001)(6200100001)(7049001)(8676002)(86362001)(7636003)(426003)(47076005)(70206006)(336012)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 15:20:07.6532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e66b663-fab9-4fa2-9f67-08d937ecb754
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.148];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT044.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR07MB4270
X-Proofpoint-GUID: ZfkbOIeJsbx5APEInjeeTbLIBTNuoRHP
X-Proofpoint-ORIG-GUID: ZfkbOIeJsbx5APEInjeeTbLIBTNuoRHP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_05:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250089
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

