Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94D35A0EC1
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 13:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiHYLLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 07:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbiHYLK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 07:10:59 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B25D9F0F9
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 04:10:57 -0700 (PDT)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27P8ZQrY022305;
        Thu, 25 Aug 2022 04:10:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=gMl4nh8PX55hAi2jEnJ6InbgffKz9BWCzE8ymtNl2cs=;
 b=qUj9vnT/K0hR3+IzAN1q/lgTLkrysATBvx2/QrD1wJ8BQzy9yfoD2pqQGCuN0yZmoBVO
 0p8j0WNZcQdI5OhPelCRoLFbvMJvv63xqQchIwEXAk0/cbdy5PN1TnPnBqKIhyL6N2/E
 gvVgRnRrMoXRpRukA7lGJsOAHJcshQ8aq4tgDSOd/nAPgdtbAQX9LsNTm5FTdRiWPPzT
 U+WTSxQ6OSCjAxRfoa8HeaAqjOPlBmKYLe9zpw6ZnEhwe5P3n1PYi9Q4FeSThsme2DF1
 d+WZzEKmKR7959pLps9AzzG6o7h5WCyerPwPaT7Al8brhs1TDTFXPGeM412JYkob9RJI 0g== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3j59t28ery-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 04:10:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RH6sOok+ZJ4v+IFzohT3fCKYJZwwBuT7r2APBXf8Q+VHICSVXMG4R7vmpLAhhmqgbr7Kb+qQfYV2vBwJb+cmMlM7NbrK8nfQoo+VMMHQWW6sfKsrzV7phwD+s1S4JkH5tt1jARS7rwCL33MsWLGaQa1HaABdygnKQICbRzN0CJaqKhNJMmCBeRA7cCyaO9QnvSZbFebGIztbNMIuZhcKGdwZgq5dgvDCCiNpUs2CjqaTWu+DbBqNrsm+oVUOrHFn/8WtpGkz1gm3zsf/oeYEBdehtnzG4mjXQPN+zYalZ/R3dIfpRc2MRiqrII4Ij3RZWx26nWvBnN8n1AWTck5aNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gMl4nh8PX55hAi2jEnJ6InbgffKz9BWCzE8ymtNl2cs=;
 b=fcSYbBCtGERJg7ZDjPnxmdkCO06swqUpQd873uYpd33ApwEugYoqSZ635WvbqHLpe5C1Vn9+lrny68N13e7/IDvzEkW4W9jIpcIFC/IJLPwvODkpdI7G5j5l1VBZ9yGGHb/OCLX49Cm+6vtfUDmoQ5atzCCleqlSy4exV0iNlXyT2H/AC+GD0zkQTDT9loNj9MXGptosLNzGhRNvC3+g1GPiAPH3eYztYHYJHwhQC61DGjrwRwaB4pCwRmKqqd8IAy6Yl7XJVVG3WiszQY9knu6NR/wVVbFWX/4t7VjwOSssr0u5PopwuycPHA0rcMQgufS1AA/jOowENME2o4r1bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.148) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMl4nh8PX55hAi2jEnJ6InbgffKz9BWCzE8ymtNl2cs=;
 b=dzyrCGg3YdXkAWIWUBiiHTPdrTJhLWXece7UJPASpgkKlcZep+ONlLFSnGbtyWwryqHdeUOhGTD3erIQEO/VntFfSoZkJeFMVF1hVhmpQlstYke4n7eVedeqEVphtcA2FfYp8pKSX56qw6YFBQDN4GZ1v8P08QnZJg5mSOeo1eo=
Received: from BN0PR04CA0045.namprd04.prod.outlook.com (2603:10b6:408:e8::20)
 by BN3PR07MB2642.namprd07.prod.outlook.com (2a01:111:e400:7bbb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Thu, 25 Aug
 2022 11:10:51 +0000
Received: from BN8NAM12FT112.eop-nam12.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::7) by BN0PR04CA0045.outlook.office365.com
 (2603:10b6:408:e8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.24 via Frontend
 Transport; Thu, 25 Aug 2022 11:10:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.148)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.148 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.148; helo=sjmaillnx2.cadence.com; pr=C
Received: from sjmaillnx2.cadence.com (158.140.1.148) by
 BN8NAM12FT112.mail.protection.outlook.com (10.13.182.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.3 via Frontend Transport; Thu, 25 Aug 2022 11:10:50 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 27PBAmSW023187
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 04:10:49 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 25 Aug 2022 13:10:35 +0200
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Thu, 25 Aug 2022 13:10:35 +0200
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 27PBAYrM026296;
        Thu, 25 Aug 2022 13:10:34 +0200
Received: (from pawell@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 27PBAY22026294;
        Thu, 25 Aug 2022 13:10:34 +0200
From:   Pawel Laszczak <pawell@cadence.com>
CC:     <pawell@cadence.com>, <stable@vger.kernel.org>,
        Peter Chen <peter.chen@kernel.org>
Subject: [PATCH] usb: cdns3: Fix issue for clear halt endpoint
Date:   Thu, 25 Aug 2022 13:10:34 +0200
Message-ID: <20220825111034.26248-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9a09d74-9677-429d-029b-08da868a7860
X-MS-TrafficTypeDiagnostic: BN3PR07MB2642:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yvDAVmBQaEcrvjhdTceBhzIk0QIPS5YNTQtquyrRl2Aij6tlV3529n4X4gwHglR7k0UBzPR9VzHbqF7GWsDsvyKPOJRZQAuQqlWrgiCNObkw4oUg2mHsx+9dtPLAv3KOcDjTC2Vsh7t68osYAHa6naA28+U83QI/uEfTJfBIbbZOK++NgmcMu1QFgDbBwW4cHLG/pVkgNsiJG8aGEvYNqEjjrpj+enUXf35nxQcw0Im6uXs5sPXqFQpwvGO5b20B1DAhEMTni/H8UcT1G/0lupo7cmKNkrszLsKpvaD/KjDPxbbc+NjR7nj6rWXhJkc4odqt0vg2dqxXXtJkrHRLePygmGxPH25ChHJ1Xl/m+B1EBFre1/6G76Y3/q9Eik1BJ28qP2oHpeY+D1+br23C+iRGPnRYhUd1MeXKSb6AQlfGRl5pEP6DF3LqmQjzJTsXvRjPirXMIvuOw4DJ3eV62LxArRw/RNeuIJyWhWA5hC38eq+JjqHmmBJMAJkLAwPZpU8t6/tHQIiSCFFHqDopK2hCWCO5ApprbSBeHud7/pKKiQystjLhJ8eDlxiLnrAbZJxJEB4NGg7C7v65KSvCcXMa3NWsUkMX9TO0qkhag0RwDf8jkFnwp/4RMkKbwA6J5YLjgT1oBNZQpAR9ej4uWd6MN8ZYpr6p2uiQS/pzP0P1Su5Gmnvd96ign98I3W0sOU+hqOeZ3Kdydt/A7cO1QaCZRz/EvyqSd2fV+QnkKwUq8pEs1zoIeZ8edh/oGh62NNMmH/V6igANo/Hs0VHzUZFRaYq9NRiAR8blzzBcdOo=
X-Forefront-Antispam-Report: CIP:158.140.1.148;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx2.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(396003)(346002)(376002)(36092001)(36840700001)(40470700004)(46966006)(82310400005)(83380400001)(47076005)(2906002)(8676002)(426003)(70206006)(4326008)(5660300002)(70586007)(41300700001)(26005)(8936002)(109986005)(1076003)(336012)(186003)(2616005)(36756003)(478600001)(7636003)(356005)(86362001)(40480700001)(40460700003)(36860700001)(54906003)(42186006)(316002)(82740400003)(266003);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 11:10:50.8263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a09d74-9677-429d-029b-08da868a7860
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.148];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM12FT112.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR07MB2642
X-Proofpoint-GUID: UZiUjm-nFN_7Q4-9reZ3sJxiAVFDacRa
X-Proofpoint-ORIG-GUID: UZiUjm-nFN_7Q4-9reZ3sJxiAVFDacRa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0
 mlxlogscore=648 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250044
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b3fa25de31fb7e9afebe9599b8ff32eda13d7c94 upstream.

Path fixes bug which occurs during resetting endpoint in
__cdns3_gadget_ep_clear_halt function. During resetting endpoint
controller will change HW/DMA owned TRB. It set Abort flag in
trb->control and will change trb->length field. If driver want
to use the aborted trb it must update the changed field in
TRB.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/gadget.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 296f2ee1b680..4990f048d30f 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2166,6 +2166,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 	struct usb_request *request;
 	struct cdns3_request *priv_req;
 	struct cdns3_trb *trb = NULL;
+	struct cdns3_trb trb_tmp;
 	int ret;
 	int val;
 
@@ -2175,8 +2176,10 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 	if (request) {
 		priv_req = to_cdns3_request(request);
 		trb = priv_req->trb;
-		if (trb)
+		if (trb) {
+			trb_tmp = *trb;
 			trb->control = trb->control ^ TRB_CYCLE;
+		}
 	}
 
 	writel(EP_CMD_CSTALL | EP_CMD_EPRST, &priv_dev->regs->ep_cmd);
@@ -2191,7 +2194,8 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 
 	if (request) {
 		if (trb)
-			trb->control = trb->control ^ TRB_CYCLE;
+			*trb = trb_tmp;
+
 		cdns3_rearm_transfer(priv_ep, 1);
 	}
 
-- 
2.25.1

