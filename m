Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621B15A0A0D
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 09:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiHYHW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 03:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbiHYHW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 03:22:26 -0400
X-Greylist: delayed 3579 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 Aug 2022 00:22:24 PDT
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5050698D14;
        Thu, 25 Aug 2022 00:22:24 -0700 (PDT)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OLK757022383;
        Wed, 24 Aug 2022 23:22:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=proofpoint;
 bh=ystNTJy53HVXHrgqBqpitzGvWrZter8/dKCKWhMSpLQ=;
 b=HBdKuvDlasnfpXYa7A+L5bc/cSnQOv1CINqkLdDDvRvCB1gIddUGlDTzgzQMBfeKhfN8
 RQX5ORHQuTCIPjVTEaf7e5yor5vb/Kza5qZu1ENNZT++tBSz8VBmdLK3au38Qld8iie0
 /2oJaAuR0UPoa0NmrUuXfg3kAFs53hstB1504E1IkWNO3feBY+qKLn0FnHFrbBy+92Ml
 cwaKx/medk8Ar99D55piQvTwf99KT0dIej0oZyc1oohhoozA9/Ocle0kEazUl6zcTig4
 axkPHpUjwnS4DIVeDgb3PHCYovCVkwvfGpLVd34PpAzY5SKcEZj2DEGy+qimEIw81GPZ pQ== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3j59t279e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 23:22:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KY0jJwF9PiCOqofo6TgjIS33jQC+Ga0+ffa96NxzUGmiv8RDJkySiWDjChX8cFqjdccLbWMTFyFcEQWUBXTYzGxejM+1xEmAhpL9562tyLgZaEYNsyd8xT8Suw3jmIVCBU2MKtxoqls81rDmEG3IxEq0RKLOtjEfLCk8tDByHM0LH7YSCZcOiAH47ALqjC1wjBzt7oyysSxZ261Ajsfej3lnYCG6yE8QEAHHR32xp5FM7292D4TEtFVVnlW8LmFspXWk/28cHYN9hok3r9m55lMJHDgPdj+JYfC36nsZQTYfE/BQKWkibpeQPSIWBm9RxkMjUT24+HSVtGRNpSFJPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ystNTJy53HVXHrgqBqpitzGvWrZter8/dKCKWhMSpLQ=;
 b=hM3pWZMEb97oJfNngVI75E8wDkBArGKfL8pGwXLsOboPj0/OCM9rjRCQ832sLfizNIJupCin4YfWHC8aX84refBZUxHvCAO0Pyf0DvxRISkKrn+GZ/6kC4wLV9XYHeFFAU7hMuBvh3toJ1e0l0I+icgbbpq6/NbTBqJrktUh2FHj+hjSveZkyINBz9FnQOhr9LFVPcMcOOB4m9AGtFxIAYN5Z/47NMZ2YoWu6VvTnwZKxqn+PRLzsAFQBIJSSTIinL5wPNXZmBBqxzJJr4Up+gL13tN2rS35Y6l5CJzylCTU7Te2xlhBr7EMpqK4fz1GyxY5FOsc5LfkXUHvsewTOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.148) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=cadence.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=cadence.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ystNTJy53HVXHrgqBqpitzGvWrZter8/dKCKWhMSpLQ=;
 b=LOqiLpNt4uZhBG/pWG2fIXEmH8Ee79ZeX0py5Qqto55Mwt0f0eq81pctzZQUkWj/mmXpmWHUKhaXZpzg6STyt2FMglQXMC8292lELgMz8Te2me4yJVdzh/zoWNVdsb6fPIlp478QoHHapjP/Dftq8+d9YFOGzwSqmtKUAkqWLrw=
Received: from BN0PR07CA0023.namprd07.prod.outlook.com (2603:10b6:408:141::6)
 by BYAPR07MB5335.namprd07.prod.outlook.com (2603:10b6:a03:6a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.20; Thu, 25 Aug
 2022 06:22:28 +0000
Received: from BN8NAM12FT068.eop-nam12.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::22) by BN0PR07CA0023.outlook.office365.com
 (2603:10b6:408:141::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21 via Frontend
 Transport; Thu, 25 Aug 2022 06:22:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.148)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.148 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.148; helo=sjmaillnx2.cadence.com; pr=C
Received: from sjmaillnx2.cadence.com (158.140.1.148) by
 BN8NAM12FT068.mail.protection.outlook.com (10.13.182.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.3 via Frontend Transport; Thu, 25 Aug 2022 06:22:27 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 27P6MPfd025182
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 23:22:26 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu4.global.cadence.com (10.160.110.201) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 25 Aug 2022 08:22:13 +0200
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7
 via Frontend Transport; Thu, 25 Aug 2022 08:22:13 +0200
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 27P6MDSj005875;
        Thu, 25 Aug 2022 08:22:13 +0200
Received: (from pawell@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 27P6MDkF005874;
        Thu, 25 Aug 2022 08:22:13 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <felipe.balbi@linux.intel.com>, <rogerq@kernel.org>,
        <a-govindraju@ti.com>, <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdns3: fix incorrect handling TRB_SMM flag for ISOC transfer
Date:   Thu, 25 Aug 2022 08:22:07 +0200
Message-ID: <20220825062207.5824-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bb77efd-6940-40f2-88b4-08da86622eff
X-MS-TrafficTypeDiagnostic: BYAPR07MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IUuSYvFxgtvZDnZPOqyFAiGxUlqzrBD2gPBqmxKCgrdjkZ9SYls0LxWE7y80AyX/cP6HT6fFRlWNCmzTWTC5Ahbm2rDArzjDZqcLJ6pQJ1g73gXGjFw/RY9e3+oNhR1FF96Md7jyoawPqEElX4ghssGzFlYLfoGY5B4WEMTHv9hwYgxntaAKrbIFV6cafaPbpsVPo9/X44VqNpwcKhI/UqLFdjA3jLVs7VqVImfIDtS5PijBdRz4v2rPLKvfstqvxDAchOQwh6uaGyPerBuPaXWaIYVyZBzUV3T4WkfSLlBhQ4GAQFjorVU3vDdeYZoqIBl4i7jTUYfNFXuum7EvnDOiyBbVFAzIqgEkYDUrM/reucSJuODfbym27k/Hk4dNP7va33oMYbiEwffsK9mSYJTZ68PUWuJ5gOX773XZMaFtKPMIXq1Z/mj2GX19nht4iCWOoHQvN1qXSNKd9niFW5DNs1Kgz0KiNe6GlkUyALFpG/VfBK5rgdrpRzIV6r/oO0p748aJi8nLtpnrtDwVZlx6/Y+bRztCjJ5+iGkOI6/yXWOYPGCbOXYA1p/THuLAHGtNdOCjSi632e4gS+4tSDMQye85vFUx3UEd4+jWP/WUVAc+94nBe007H7uM4i2s0f0zKCV1OBfSLDtYBCwsxA8kEB5OZ9cNha/ATfdKxgC+BqBLR2DfgrFoCxDjzW4MLB1u7Il0CXr7AinlJAxqCCxDKxICoxMzbpBDkxYTkMMnOvSzuNpxOpVDjZ5zDd4XJu2OnshcjbbM6SqOcba93A==
X-Forefront-Antispam-Report: CIP:158.140.1.148;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx2.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(136003)(376002)(36092001)(46966006)(36840700001)(40470700004)(6916009)(5660300002)(42186006)(70206006)(2616005)(8936002)(316002)(70586007)(6666004)(86362001)(2906002)(54906003)(4326008)(83380400001)(8676002)(36756003)(26005)(336012)(186003)(356005)(47076005)(426003)(40480700001)(7636003)(82740400003)(40460700003)(36860700001)(1076003)(82310400005)(41300700001)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 06:22:27.8199
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb77efd-6940-40f2-88b4-08da86622eff
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.148];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM12FT068.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB5335
X-Proofpoint-GUID: fmLtIy_Kjl_yDH1beqh7a9bBCnbsPZm6
X-Proofpoint-ORIG-GUID: fmLtIy_Kjl_yDH1beqh7a9bBCnbsPZm6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_03,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0
 mlxlogscore=753 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250021
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The TRB_SMM flag indicates that DMA has completed the TD service with
this TRB. Usually it’s a last TRB in TD. In case of ISOC transfer for
bInterval > 1 each ISOC transfer contains more than one TD associated
with usb request (one TD per ITP). In such case the TRB_SMM flag will
be set in every TD and driver will recognize the end of transfer after
processing the first TD with TRB_SMM. In result driver stops updating
request->actual and returns incorrect actual length.
To fix this issue driver additionally must check TRB_CHAIN which is not
used for isochronous transfers.

Fixes: 249f0a25e8be ("usb: cdns3: gadget: handle sg list use case at completion correctly")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdns3-gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index fa8263951e63..a6618a922c61 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1529,7 +1529,8 @@ static void cdns3_transfer_completed(struct cdns3_device *priv_dev,
 						TRB_LEN(le32_to_cpu(trb->length));
 
 				if (priv_req->num_of_trb > 1 &&
-					le32_to_cpu(trb->control) & TRB_SMM)
+					le32_to_cpu(trb->control) & TRB_SMM &&
+					le32_to_cpu(trb->control) & TRB_CHAIN)
 					transfer_end = true;
 
 				cdns3_ep_inc_deq(priv_ep);
-- 
2.25.1

