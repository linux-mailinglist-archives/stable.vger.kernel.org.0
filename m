Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6D06C31EB
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 13:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCUMnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 08:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCUMm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 08:42:59 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1184D604;
        Tue, 21 Mar 2023 05:41:56 -0700 (PDT)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LBV4rn002073;
        Tue, 21 Mar 2023 05:41:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=wjrhSD6+2YY7Vzj/uoXlDCjO2aBT3pSUDIHgedyM+Zw=;
 b=BLf9YT5wz2xiZV65Jn8hQA6gxCbV3sBf5AvIi7uYBbeMO607YrUaEM/3yotucvHEZ9LU
 JPj8W7IIBxFXQhLUKUKMSCsYPhVNqe1RzN73o7MHCfyWvDNtohKXKXx+Mzm5cFmhqB5E
 T0/CbuquJdoqEtLaAmmGVySN+JEu22X8vTuukQwfcYsAHwKQ77pjbBUuIqQM9Mt+CPw9
 KdP1vi2trWAAz1CK/Ydv5xnnDRevfhWNb4NOaWLLG+sINwEWxujfBMUDMLNra1TeabWh
 iSXKwyixfZ0uj70Zb8k7RY1wBZsdlxOaJZd/LSoys+Dsp4zOnyliHoMlIIV94xueF/ou 0g== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3pd8w2hnkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 05:41:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeMf9ur22uEBO0l3eSR44NxYu7qKD6o3PDRTrRzqYaZwwkoyeKKg48sl0HOvXeq38TPgog36wrgQKESLQfYeB7sqz4oHV1ixQl6x+myAl/nk/LxNYkCXQ6RQE2ek1zJ+1eAyUBwPXcgDm0SQdkfxogjXZBkwM6D8oQ4KLo6CasNEc1bXPrRKPcnwRLuCeXu2wlOZ9bXbchteGtO6nioiTwhyxfCPSoaIR9+usmu4sIHdvNCMpIw+mObEw3TBMD8JjMPb/pNkOZBgX/vFFn44rxlEsgERo/7DGoOrdu6brlUsu9UX1aooUzKQ5s6WTF2beR1LSiUOp9pKkMYwfRq63Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjrhSD6+2YY7Vzj/uoXlDCjO2aBT3pSUDIHgedyM+Zw=;
 b=dFGOIMwGn9vxI0qStJD8l1HyRM5Nf6gg5wADmDmTkcqqwsNZ+Lwa6r/qCQPxEOLHCu2mEaVCnuIjqbpuMIpNkvCVfNQYthOno0mPD7xmd0F114tYQNkkD9dziWxgSyF1hCwMXaUQ0bWEVEHWdNoHMTPGXnp1mgcWfB1BuF0rnsaBO5IbVr87w1r+XzU6fayWpfFh6V0gNL6BLzIDSI7cFpn+7fo0O0Yipl3c+QGckBcW+nijWEOUvxogn9St6npZARBLeusVQWgrM/KmWZDiZTPDiM1oKxfsw5GT1e0uMcm4+xHxSloP44tfa6N3EfdjPMGVRVc+3fVvI9p1ulPeRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjrhSD6+2YY7Vzj/uoXlDCjO2aBT3pSUDIHgedyM+Zw=;
 b=EqmbJ34QlbEzdb+/IDuyy7AZptQweG3Okt+203FMW5eA12inrE8SoDovOWWn/k/2nEYdLwvxMdDWOVZBdvpE02YiEWvP0UYXC0X88zS+6d0yG501ko9rUmOYj2XjttXJIdagtr81nxslrXAQkakW1LYrPmF40y5lgA5dNRRnkmg=
Received: from MW4PR04CA0315.namprd04.prod.outlook.com (2603:10b6:303:82::20)
 by DM6PR07MB5116.namprd07.prod.outlook.com (2603:10b6:5:4e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 12:41:08 +0000
Received: from MW2NAM12FT037.eop-nam12.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::c5) by MW4PR04CA0315.outlook.office365.com
 (2603:10b6:303:82::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Tue, 21 Mar 2023 12:41:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com; pr=C
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 MW2NAM12FT037.mail.protection.outlook.com (10.13.180.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.15 via Frontend Transport; Tue, 21 Mar 2023 12:41:07 +0000
Received: from maileu4.global.cadence.com (eudvw-maileu4.cadence.com [10.160.110.201])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 32LCf5OR023836
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 05:41:06 -0700
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 21 Mar 2023 13:41:04 +0100
Received: from eu-cn02.cadence.com (10.160.89.185) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Tue, 21 Mar 2023 13:41:04 +0100
Received: from eu-cn02.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn02.cadence.com (8.14.7/8.14.7) with ESMTP id 32LCf42j200688;
        Tue, 21 Mar 2023 08:41:04 -0400
Received: (from pawell@localhost)
        by eu-cn02.cadence.com (8.14.7/8.14.7/Submit) id 32LCf3mc200673;
        Tue, 21 Mar 2023 08:41:03 -0400
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] usb: cdnsp: Fixes issue with redundant Status Stage
Date:   Tue, 21 Mar 2023 08:40:53 -0400
Message-ID: <20230321124053.200483-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu4.global.cadence.com
X-OrganizationHeadersPreserved: maileu4.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2NAM12FT037:EE_|DM6PR07MB5116:EE_
X-MS-Office365-Filtering-Correlation-Id: 40e9091b-1e2c-4291-6d76-08db2a098aea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3mC4An+Ao5EuYDnild7v3Cm3LhSzge4Soir8vys5Tw9NW6D6xfjJ1W+CwEVUw8f+GgcBFNAZVLxffvNAyOcfe5ulguJTbGaxmbT7szjytC/FKlKVk/70ZReARLpwFLYkL65GFedsq7bSrlGtt7Jhbr8uFGNZrqNgJPVu+BZa/ps4hycuGZ77ybrtPTN5ZoMns5wJU9sw9R+etdjPhVWBet4yp9Dz49apI2hKFLKeAMNztT+1x7szlt3APIPLZQUQ/x6R9zY9jliF5dsjwWLG32uty6Mu3EL2+QnYie+1XQbkQ2n23pZYVwd3eYKgTztaB4xaZd4/rUih9JYxCEaan1fy4pLyaWcGS/0oUrfUkb9K5095sRkhGbhYmz+pIzUx/20xnRHd9+QQNFJvKEftplh0QD6PRAdymxvBm4B/juI0up+QZimaAxRr8QDPmmcPrPLJJPnzcZ7XqCs0xv278lrJvwAjhJod0nqcaOKRLc6roy3N+yzOy1NbSIL0myc85l1/S0n9hItnk96d9gvJTL3MWDqZjKGqan94Kf2umyro9Jil9GSfqIAN7afCr68H2YiZuwDtUVtvHxHE9qXnhbii7ng3UMjK/aodXJvxxbVC9TROtaF43rOhArSoTxNIIEgLKTRXC0e6CTNCBrX95s8NESGXxU0pDxEBxjqo9UxSg9fbxFGt65T5wNK1VUHXdnEFz68XeFflW3RFMQalDg==
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(396003)(346002)(36092001)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(186003)(6916009)(426003)(4326008)(70206006)(8676002)(26005)(47076005)(41300700001)(5660300002)(83380400001)(8936002)(70586007)(1076003)(42186006)(54906003)(336012)(316002)(2616005)(478600001)(2906002)(6666004)(40480700001)(356005)(36756003)(82310400005)(82740400003)(36860700001)(7636003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 12:41:07.6123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e9091b-1e2c-4291-6d76-08db2a098aea
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT037.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB5116
X-Proofpoint-ORIG-GUID: pPxaDx1OQaOI96mXs_lSw9l0QJYXfqEi
X-Proofpoint-GUID: pPxaDx1OQaOI96mXs_lSw9l0QJYXfqEi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_08,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1015
 malwarescore=0 adultscore=0 mlxlogscore=710 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303150002 definitions=main-2303210099
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In some cases, driver trees to send Status Stage twice.
The first one from upper layer of gadget usb subsystem and
second time from controller driver.
This patch fixes this issue and remove tricky handling of
SET_INTERFACE from controller driver which is no longer
needed.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>

---
Changelog:
v2:
- removed Smatch static checker warning

 drivers/usb/cdns3/cdnsp-ep0.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ep0.c b/drivers/usb/cdns3/cdnsp-ep0.c
index 9b8325f82499..f317d3c84781 100644
--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -403,20 +403,6 @@ static int cdnsp_ep0_std_request(struct cdnsp_device *pdev,
 	case USB_REQ_SET_ISOCH_DELAY:
 		ret = cdnsp_ep0_set_isoch_delay(pdev, ctrl);
 		break;
-	case USB_REQ_SET_INTERFACE:
-		/*
-		 * Add request into pending list to block sending status stage
-		 * by libcomposite.
-		 */
-		list_add_tail(&pdev->ep0_preq.list,
-			      &pdev->ep0_preq.pep->pending_list);
-
-		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
-		if (ret == -EBUSY)
-			ret = 0;
-
-		list_del(&pdev->ep0_preq.list);
-		break;
 	default:
 		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
 		break;
@@ -428,7 +414,7 @@ static int cdnsp_ep0_std_request(struct cdnsp_device *pdev,
 void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 {
 	struct usb_ctrlrequest *ctrl = &pdev->setup;
-	int ret = 0;
+	int ret = -EINVAL;
 	u16 len;
 
 	trace_cdnsp_ctrl_req(ctrl);
@@ -438,7 +424,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 
 	if (pdev->gadget.state == USB_STATE_NOTATTACHED) {
 		dev_err(pdev->dev, "ERR: Setup detected in unattached state\n");
-		ret = -EINVAL;
 		goto out;
 	}
 
@@ -474,9 +459,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 	else
 		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
 
-	if (!len)
-		pdev->ep0_stage = CDNSP_STATUS_STAGE;
-
 	if (ret == USB_GADGET_DELAYED_STATUS) {
 		trace_cdnsp_ep0_status_stage("delayed");
 		return;
@@ -484,6 +466,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 out:
 	if (ret < 0)
 		cdnsp_ep0_stall(pdev);
-	else if (pdev->ep0_stage == CDNSP_STATUS_STAGE)
+	else if (!len && pdev->ep0_stage != CDNSP_STATUS_STAGE)
 		cdnsp_status_stage(pdev);
 }
-- 
2.34.1

