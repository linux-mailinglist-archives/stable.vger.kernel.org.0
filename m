Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCF5629439
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 10:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbiKOJXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 04:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiKOJW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 04:22:59 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB4D38A8;
        Tue, 15 Nov 2022 01:22:55 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AF8Lm0O008797;
        Tue, 15 Nov 2022 01:22:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=P6X+7Sab9QN1u5n+9Sc9YCvUqJsG8CA8mVhBeJNw0iY=;
 b=YMjUN6lWJLciDqP38EDVhzsMJ0SENxWhbfyJYYFIT487N4WAw2NwATnyTzzFo2z6gwhd
 IJPgDQORHtIk77HvAmmuISOWD6zFUQ+tcjgor439DKPGLcM68muKq5ruyvbcG07PI7DD
 P3r9VvzWdlcz4/QUUtjeHVraft8K8WlNQDblCjkoxyRdQZpRO2d8hC4g/zV+pJXjY5M4
 3Z3/XrNMsDetOG1iQuP+XgTaMpWZgO9ltTrCNYWoVz7R+xn1K2/ow3IeAkp/Vlp3U8+h
 qcQ+akjmgerqCO4tDcOhY8TTebTCwav1jf3AfLXKt6ucQdaqyKCg6q7sPCCFD5ZmcCwh ZQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3kv76n86df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 01:22:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgxBij5/ribxLIEcUqS9XXDKBZUJw4k5V8gBHszaoZPjN+oWTeowwBfbWwbP4UOWzH12b5oo06pcAEOy4dXJQUwfbnygknLaZyJwp7Uz3Zwof1yD710EnJcWDUqorUaJmXsBWDr6GMyvvSxLhy5/O4X9kb0pPnuKRAOd7PgOwnPSVxNSHbJ2P1NCvkFjKGuKFY4TBR2+6j/nXMXxchHQ9bAw4oPx+hFUgGcwoszG07sbZ3UNnJMt+76slaevhcwlpwpJcE2w6ccp4IKjZQ5NP+aoqNBTbXsIWVi008/5NConM0rojEtFWKvL2cyp+xNuzGUFhWDDa2aP9rlFDPGIYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P6X+7Sab9QN1u5n+9Sc9YCvUqJsG8CA8mVhBeJNw0iY=;
 b=Efes+CPHDgL7ZmeYQEMXGkDX6/MdSbMO3fFsogjZNHRYbWXyWYdjm0smEvN1Z0R09GXnYOuKXFe6GB47eScuVOp86KQwb9O4bZMQSuoWoC+l1xNH0TstA6+EFYRdaHxpR4WlHpEEuPeMfe1f84PGfM/HCEdiOafNHW5jY9x131uut8yj7ivvV2t845c9XBJh2+LkZ7jMxIvFC7qn7HFhOlBgXqan+Jq4rl2OWyMuG05k5JKg0ZvZqI7/pwtcrB8IZLzTJ8YuPKFtjaxK7NkEccKJG+SveHdmiBIbWjXaJaR6aayaLC3yV9tYdo7HWKXyMt8H+DdeI68bE1fEcBvzew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=cadence.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=cadence.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6X+7Sab9QN1u5n+9Sc9YCvUqJsG8CA8mVhBeJNw0iY=;
 b=acMnJbd4RRENwlk3EUgPR/FGvhRl0tPT3EU6G2M6MtXq3wM1hdkjgdOHm491B5KnyAqDgDFqdjqI6vvtZ6CkELYYpYrWfujkpF4l6TRVxjNCK7qbxGOCVFdjjQZFxmf8TI2v201CbhzEf9vJRun41NigSge3R0N92sMVIzl/DKE=
Received: from BN0PR10CA0008.namprd10.prod.outlook.com (2603:10b6:408:143::27)
 by BY5PR07MB6920.namprd07.prod.outlook.com (2603:10b6:a03:1e5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 15 Nov
 2022 09:22:42 +0000
Received: from BN8NAM12FT083.eop-nam12.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::91) by BN0PR10CA0008.outlook.office365.com
 (2603:10b6:408:143::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Tue, 15 Nov 2022 09:22:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com; pr=C
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 BN8NAM12FT083.mail.protection.outlook.com (10.13.182.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.6 via Frontend Transport; Tue, 15 Nov 2022 09:22:41 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 2AF9McOd190442
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=FAIL);
        Tue, 15 Nov 2022 01:22:39 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 15 Nov 2022 10:22:25 +0100
Received: from eu-cn01.cadence.com (10.160.89.184) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Tue, 15 Nov 2022 10:22:25 +0100
Received: from eu-cn01.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn01.cadence.com (8.14.7/8.14.7) with ESMTP id 2AF9MPFj421416;
        Tue, 15 Nov 2022 04:22:25 -0500
Received: (from pawell@localhost)
        by eu-cn01.cadence.com (8.14.7/8.14.7/Submit) id 2AF9MPxa421415;
        Tue, 15 Nov 2022 04:22:25 -0500
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH v3] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Date:   Tue, 15 Nov 2022 04:22:18 -0500
Message-ID: <20221115092218.421267-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM12FT083:EE_|BY5PR07MB6920:EE_
X-MS-Office365-Filtering-Correlation-Id: 65e4a367-0dc5-46b4-f094-08dac6eaf23f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MZenNbtMIMP9Z0qZ9WUmcAk/fx5ft00TB10JF7gpuQVo2hX+0KizkBdw1W/l9VnkpnoyRU2Z8qck3DEOoumozXgcw69C/KrFVOdR9pzP3cS2ZjLI/rGz5AV9kedg0HkOhMuqsi5XBi6IYDxLzenPj6VU0tYSlxJVZMYNP0pjdirXhzzktlGHIBpZ38yD40KhkRLecxTKDgJqsz4fL/Hw1eEY0lH+faN07hCb4ThQVIKMvecOAXQ1QNiJKuO2WW5W98gFy8xR1E15MyU8Ba2uGs2qOQJv3Q3DP0LQaOBURCSb+DIhbFAA9xIelSzF1uOQNu8uohZ/vrDQKfl/ZM0a+4mL72ImqWZwi90p6PimKUciYryl/rvvUYqpL8mhmV4RpQ2/GkizG+RSVOaq643HZ2hV1FpesBcKOqtLCXkyIX/g6ID1lnXvPPBkJx1rCC4TXy2Sa0/WRCP+yLiOXUQ9TtbFR85Rc20koYzgS4jOQzUdDWdUCYlbYrqCHdvGQGaKULAZI06YLpabPAOXsdbeCGJeeKDmpSRRu8KyxZUhG+79nlwzzejDazityQOUkrGlxVVh5VFgHQpxgAxKsDpvRA/0NC0Qf6YHGs1Lqg0Na413pRpHNmyvTEO/iLmwrPg/azcYaIKtpVuc6zEJ+8IJ9WivrO8H6OOlBafWWKWPz80khQxPq/ez2kG4d2X7eDEf8XPhwDcnMTefs/1VddZXacKIbBHe/Rtju7omiwV1NRWjYqPYSNk+gWh42QErK+/05bxH6ZPtybZhLqmNo9SuaId26563TwS/cRBYFZivAXjSIvcag/11ptvtP7x3FpE
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(36092001)(451199015)(40470700004)(46966006)(36840700001)(81166007)(82740400003)(36756003)(86362001)(356005)(40480700001)(40460700003)(186003)(426003)(26005)(1076003)(2616005)(6666004)(83380400001)(2906002)(36860700001)(336012)(8676002)(316002)(6916009)(70206006)(82310400005)(478600001)(54906003)(47076005)(4326008)(41300700001)(42186006)(70586007)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 09:22:41.2457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e4a367-0dc5-46b4-f094-08dac6eaf23f
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM12FT083.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6920
X-Proofpoint-ORIG-GUID: RaTrsu8B1PUSXWZRtyMQxiBuWgxNsqLk
X-Proofpoint-GUID: RaTrsu8B1PUSXWZRtyMQxiBuWgxNsqLk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_04,2022-11-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0
 mlxlogscore=570 mlxscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211150066
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch modifies the TD_SIZE in TRB before ZLP TRB.
The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
processing ZLP TRB by controller.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
v2:
- returned value for last TRB must be 0
v3:
- fix issue for request->length > 64KB

 drivers/usb/cdns3/cdnsp-ring.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 794e413800ae..86e1141e150f 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1763,10 +1763,15 @@ static u32 cdnsp_td_remainder(struct cdnsp_device *pdev,
 			      int trb_buff_len,
 			      unsigned int td_total_len,
 			      struct cdnsp_request *preq,
-			      bool more_trbs_coming)
+			      bool more_trbs_coming,
+			      bool zlp)
 {
 	u32 maxp, total_packet_count;
 
+	/* Before ZLP driver needs set TD_SIZE = 1. */
+	if (zlp)
+		return 1;
+
 	/* One TRB with a zero-length data packet. */
 	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
 	    trb_buff_len == td_total_len)
@@ -1960,7 +1965,8 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		/* Set the TRB length, TD size, and interrupter fields. */
 		remainder = cdnsp_td_remainder(pdev, enqd_len, trb_buff_len,
 					       full_len, preq,
-					       more_trbs_coming);
+					       more_trbs_coming,
+					       zero_len_trb);
 
 		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
 			TRB_INTR_TARGET(0);
@@ -2025,7 +2031,7 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 
 	if (preq->request.length > 0) {
 		remainder = cdnsp_td_remainder(pdev, 0, preq->request.length,
-					       preq->request.length, preq, 1);
+					       preq->request.length, preq, 1, 0);
 
 		length_field = TRB_LEN(preq->request.length) |
 				TRB_TD_SIZE(remainder) | TRB_INTR_TARGET(0);
@@ -2225,7 +2231,7 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
 		/* Set the TRB length, TD size, & interrupter fields. */
 		remainder = cdnsp_td_remainder(pdev, running_total,
 					       trb_buff_len, td_len, preq,
-					       more_trbs_coming);
+					       more_trbs_coming, 0);
 
 		length_field = TRB_LEN(trb_buff_len) | TRB_INTR_TARGET(0);
 
-- 
2.25.1

