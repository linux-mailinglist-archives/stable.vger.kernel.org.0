Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F60633786
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 09:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiKVIw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 03:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiKVIwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 03:52:25 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749473F046;
        Tue, 22 Nov 2022 00:52:23 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM8N202007667;
        Tue, 22 Nov 2022 00:52:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=wubufJjS6S6wxKFmEQPWgUzNepLb279a7lUhgILPVhQ=;
 b=W9u9/XE3q6cmeYS0ETqSMibX66KFYQ120m6ntuHx3kZ+oGADFZx+P2GPltZboW3PLzB3
 fidSoFaBZpKZzCzYClqNqmOFkzDlWxjTWuSvfNymJ31BQr4HI6R4LpbWneXRi3s0MOqx
 oixfjgbuntX0Qw55GtsTl+Ygl5T3C3LC6YBA4o5zWCkUUvLbdBC+rYTMa63jULGoaHGJ
 FDiGzt4Ph3GhPdNECwlbEaod5l5aB8aX8jCndCXoIp9BF29AKTtUllspr5MVRAZ0W1fb
 GqAGvAxnXYQDopExrChT1NGPTeigzJEoZAL4gyrjdXfUd3pPe98JGOT3drZETPdGe8H+ bQ== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3kxum3svvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 00:52:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMAnJ752480kgpm/WZ9DXXGalzsnj1L4AwpvcmHIE1wN8gWml0v9h+0huXJfjOi+FIausVlJDv0quUHGsrDS1kcFHh8ReXwd43X0IaGiGBJDPr6+cd4Wg5vhzFvAO3XpRj0ZBa+lkgfhhigYmKj/Yo6qZ21FiiUr3G2iXQKwwnNCt3sFzBM4C7n9gi+qBtUXyaBPYVnrWyzGMMIZJF8rqVdmBacJNMIuzvMUfIFwB4aeI2UolPj2iZ2dF1N+4UO08uAlRGFSMoGdiQ7FzudP/Sc7OsHAKsHARUWBLuHaYPD6bUq+MR9yCvMyUXNHQKY2paj5kn8X7YQKjTmDEjKa5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wubufJjS6S6wxKFmEQPWgUzNepLb279a7lUhgILPVhQ=;
 b=hIPFmdZhdajxzN446INCn9+/9EUVqLgvideI7+jAjI2uW7NcneI224+XESEUM+AyX9Wu6Z/bwzb3GM2UgO4nn0fpRkH5+9zxldpWjX0iE1BfthCr9g/b3eND3AjSFT43ZPTCh5wgwwOJVCAipz7m4kBR0tlkILMNXMxQ7nqh8vUyL2odvdE1LuQ98MrEM6uSrCFE5pAk1tAC20ROKfjnXZw9h2q+gLTXDw5MtP2lqfTvnIdmP/n5nRP8a1KTHVXbaA+yhe43yVTZhWD4a8FeGqPCxfnTzzI/yoKKc75R2sDfuTx5TLFr4T2dCuz81nYL/IUp1jVpHbJbeZnU/ZPZHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=cadence.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=cadence.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wubufJjS6S6wxKFmEQPWgUzNepLb279a7lUhgILPVhQ=;
 b=H87WeITPRHTIODVyt/jwsI8pIzIxooQc1i2j358EaFX3bsy5S8YJh9MoPf/VzhugI0bmgMWH1tek/bJHfDBEmyeHLgt3b8UYjNkRHgMaE7r7P9BghQ60CWJ70jO4MEJtH/NRWsBC625/bGi21MIZ9YCddAjp0DqRxyk9aqjIJXw=
Received: from MW4PR04CA0210.namprd04.prod.outlook.com (2603:10b6:303:86::35)
 by PH7PR07MB9467.namprd07.prod.outlook.com (2603:10b6:510:1ee::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 08:52:10 +0000
Received: from MW2NAM12FT016.eop-nam12.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::e7) by MW4PR04CA0210.outlook.office365.com
 (2603:10b6:303:86::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15 via Frontend
 Transport; Tue, 22 Nov 2022 08:52:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com; pr=C
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 MW2NAM12FT016.mail.protection.outlook.com (10.13.180.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.7 via Frontend Transport; Tue, 22 Nov 2022 08:52:10 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 2AM8q8cg017029
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 00:52:09 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu4.global.cadence.com (10.160.110.201) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 22 Nov 2022 09:51:54 +0100
Received: from eu-cn02.cadence.com (10.160.89.185) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7
 via Frontend Transport; Tue, 22 Nov 2022 09:51:54 +0100
Received: from eu-cn02.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn02.cadence.com (8.14.7/8.14.7) with ESMTP id 2AM8psi0332636;
        Tue, 22 Nov 2022 03:51:54 -0500
Received: (from pawell@localhost)
        by eu-cn02.cadence.com (8.14.7/8.14.7/Submit) id 2AM8prVU332628;
        Tue, 22 Nov 2022 03:51:53 -0500
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: fix lack of ZLP for ep0
Date:   Tue, 22 Nov 2022 03:51:38 -0500
Message-ID: <20221122085138.332434-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2NAM12FT016:EE_|PH7PR07MB9467:EE_
X-MS-Office365-Filtering-Correlation-Id: e1018370-e503-4152-b07b-08dacc66d79f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iW95AH8A/hAYSFSUyz4Cm2c3Sx2oyrdaHtW3y1+z97zafGssyuZlFr54o0I9dqUsVxgcJGaLKg5SLhT2axnvRQ5dPQiT/Hr+i8IP8GLelh2dZ4Ly10ckGk/Qq8TaWsL/oh2sJ3kCe0vZuyw7CW6CJyOuHg/KBiYHJ9gQ/cwHkwZm1EH+B68TzoiPsA6DAPHlhax8Th3gPNI8oby9vYbfWDsHdEjfxdJ+fqSO37KNuYl4Td9u4XIr+QVwFyGzRJ0Oek+G2lG1KoYFe3pkOJfN2Cmglmj64/N1XWrvc6ae9M/+l+ZudTy/MHTYOYAUdoca26LmVYcTW/IJ7oOjjM5Y3pci/5EStgFty1zc8S5jBTmGhW71iDCXXgMX3vpUYFXJX0QLpP5DGmOFPU+RB4QYeIrxmJ/Tf3/JV3ms115985aXlRG/y/ui2KaVU3uGpBBSNpVWDxHKQq8jg6JSrANfddx59I4POaohY29spkrz5E/hunjrMupbX3K4TSeEsvIEosFEg+d79eDeqLm54xqNJwJGTeZVq3eYxstWGo/H015zlv9RNRybun2Sp1WNkUxU9tNJsva1mhceEc4/BSqWSZ6DKsIf1J+cBTJIkBy/bTF0uB2GAaOpCphzuvynvaFjMmN/XGR2/6FrEpGQzzo1cNnyvm09SiywRWyYNYqpBXoKtJDO9TqEjAL3TqB/A7s3h5chRAEHG2/43lyKWLz1nw==
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(36092001)(451199015)(40470700004)(36840700001)(46966006)(82740400003)(2906002)(41300700001)(4326008)(8676002)(316002)(70586007)(6916009)(70206006)(82310400005)(42186006)(54906003)(36756003)(40480700001)(356005)(478600001)(6666004)(36860700001)(86362001)(5660300002)(8936002)(336012)(1076003)(186003)(426003)(47076005)(40460700003)(26005)(2616005)(7636003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 08:52:10.2175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1018370-e503-4152-b07b-08dacc66d79f
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT016.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR07MB9467
X-Proofpoint-ORIG-GUID: 0ii-VdUL8mZXvw2RVDcwxBeI_K_gYdyS
X-Proofpoint-GUID: 0ii-VdUL8mZXvw2RVDcwxBeI_K_gYdyS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 impostorscore=0
 adultscore=0 suspectscore=0 mlxlogscore=456 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220065
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch implements the handling of ZLP for control transfer.
To send the ZLP driver must prepare the extra TRB in TD with
length set to zero and TRB type to TRB_NORMAL.
The first TRB must have set TRB_CHAIN flag, TD_SIZE = 1
and TRB type to TRB_DATA.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-ring.c | 42 ++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 86e1141e150f..fa1fa9b2ff38 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -2006,10 +2006,11 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 
 int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 {
-	u32 field, length_field, remainder;
+	u32 field, length_field, zlp = 0;
 	struct cdnsp_ep *pep = preq->pep;
 	struct cdnsp_ring *ep_ring;
 	int num_trbs;
+	u32 maxp;
 	int ret;
 
 	ep_ring = cdnsp_request_to_transfer_ring(pdev, preq);
@@ -2019,26 +2020,33 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 	/* 1 TRB for data, 1 for status */
 	num_trbs = (pdev->three_stage_setup) ? 2 : 1;
 
+	maxp = usb_endpoint_maxp(pep->endpoint.desc);
+
+	if (preq->request.zero && preq->request.length &&
+	    (preq->request.length % maxp == 0)) {
+		num_trbs++;
+		zlp = 1;
+	}
+
 	ret = cdnsp_prepare_transfer(pdev, preq, num_trbs);
 	if (ret)
 		return ret;
 
 	/* If there's data, queue data TRBs */
-	if (pdev->ep0_expect_in)
-		field = TRB_TYPE(TRB_DATA) | TRB_IOC;
-	else
-		field = TRB_ISP | TRB_TYPE(TRB_DATA) | TRB_IOC;
-
 	if (preq->request.length > 0) {
-		remainder = cdnsp_td_remainder(pdev, 0, preq->request.length,
-					       preq->request.length, preq, 1, 0);
+		field = TRB_TYPE(TRB_DATA);
 
-		length_field = TRB_LEN(preq->request.length) |
-				TRB_TD_SIZE(remainder) | TRB_INTR_TARGET(0);
+		if (zlp)
+			field |= TRB_CHAIN;
+		else
+			field |= TRB_IOC | (pdev->ep0_expect_in ? 0 : TRB_ISP);
 
 		if (pdev->ep0_expect_in)
 			field |= TRB_DIR_IN;
 
+		length_field = TRB_LEN(preq->request.length) |
+			       TRB_TD_SIZE(zlp) | TRB_INTR_TARGET(0);
+
 		cdnsp_queue_trb(pdev, ep_ring, true,
 				lower_32_bits(preq->request.dma),
 				upper_32_bits(preq->request.dma), length_field,
@@ -2046,6 +2054,20 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 				TRB_SETUPID(pdev->setup_id) |
 				pdev->setup_speed);
 
+		if (zlp) {
+			field = TRB_TYPE(TRB_NORMAL) | TRB_IOC;
+
+			if (!pdev->ep0_expect_in)
+				field = TRB_ISP;
+
+			cdnsp_queue_trb(pdev, ep_ring, true,
+					lower_32_bits(preq->request.dma),
+					upper_32_bits(preq->request.dma), 0,
+					field | ep_ring->cycle_state |
+					TRB_SETUPID(pdev->setup_id) |
+					pdev->setup_speed);
+		}
+
 		pdev->ep0_stage = CDNSP_DATA_STAGE;
 	}
 
-- 
2.25.1

