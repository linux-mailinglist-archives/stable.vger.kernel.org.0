Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D4D5A0EC7
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 13:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241069AbiHYLND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 07:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiHYLNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 07:13:02 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C633AAE9EE
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 04:13:01 -0700 (PDT)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27P85gUe023938;
        Thu, 25 Aug 2022 04:12:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=gMl4nh8PX55hAi2jEnJ6InbgffKz9BWCzE8ymtNl2cs=;
 b=FSzDo/eYqds/GAnDFX67gKiHvkFLG8CGzVzA7Dc6YnsA1jWpCYc7fTGmoI5cQ/UEzN5X
 e+0iiggk2IXd8ymRfXVWhdXYYKqcfx1IGGeia0qU68YYKR2EEQMXEiFLU7BpO8Mc7xQD
 TxB9xTtmS04ygZfgQM+hNy+N9CVMGJbIQ5Eigo7Vxlh/0VqJ+6xMKyrqcI9hflqOdSdX
 HfP5zGiwCVUqbiCYOl+KV7m96bknVfpHtUZxjq3bV3+Ra9v4ojnsJUZYwPZ+BwGVeIGf
 /fVvisytVJYCDXmkKkR61w4j4UjIASEsKcvUJaB5sJIES+e+V4NF4t6O5FdVXwQhYnc0 mA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3j59t28f1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 04:12:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IlehJORRoIPRz3hudPWdIC94/Zj2tC8QVXmdA7DTe00cONrZ4JgnN1BY73DjuCYmg3pDGAr6XhfPl1p6v7KsqkW6nHLjW9LiJWBCTac1v+USsKATnBTSV82c5LU37Wt2050KWdvhAJ3yVB2V5H7TdrMN7KJqokpOgZPHmEtyaSUG2z9MIo2nF6bRaMDbxFBS6h7AHHw2QLJrA/8YXrShYlKKGXYzHqJAgCFMWDGKb78BeUafuyaLy30SVIxeFCcNnrjRAQXDOJKgFIZhP/5B1CiTN3ZoLRKjr1PywcJVFT1tsheTMTb7bCPebYFDmlxc5Iy6q4c6y5kweg0fiQZm3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gMl4nh8PX55hAi2jEnJ6InbgffKz9BWCzE8ymtNl2cs=;
 b=CvWloXtMaqbzBsAsWC/q3XIn4lGSzTq/VKBlUVpmK/N4PNNPRIlFeS02R8CT0OJPEVINyhtHH+VsgCsC+Tjimp/wgB2YkN/1JOxyTQMuvlRh2WQWOp+OfbFeswz21JXT5rcOXFmtd1MC18wYXkapVAYeDZ9lqXdCmwFK8lF76pSrpAM2PXkj195Mojfx5bIMcyUE870rPRUyHyniABn5Hh1+zw84GUd4lGc0GuQEdtGGqIqLWN29mP/tnD3Zp9lwjualvu/7MPwq9dNwjmlZgo6mZIm2sPXu5pcjyTIFgHc4m1MkN10q/RaK12rGzZz+/LdDnUO+y5ZNwPwIlSGsjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMl4nh8PX55hAi2jEnJ6InbgffKz9BWCzE8ymtNl2cs=;
 b=XI7yPpjJ1NHmA/MVFtcW1xP7lfptiSjuoEHXlfKadY2JEYQBgzeCOuT8ALcEx1ramhr3XsVpCFZKAgAPf/tkl9oP3PwXR91K+gC9YUn1nAJ+BIq2lWIxWi4VCjYjOfy8PeN3R3TUpd+85fpt/VmdmGULFpx816V0vS2gJPL9W2A=
Received: from MW4PR04CA0346.namprd04.prod.outlook.com (2603:10b6:303:8a::21)
 by CY4PR07MB3128.namprd07.prod.outlook.com (2603:10b6:903:d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Thu, 25 Aug
 2022 11:12:55 +0000
Received: from MW2NAM12FT096.eop-nam12.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::96) by MW4PR04CA0346.outlook.office365.com
 (2603:10b6:303:8a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Thu, 25 Aug 2022 11:12:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com; pr=C
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 MW2NAM12FT096.mail.protection.outlook.com (10.13.181.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.3 via Frontend Transport; Thu, 25 Aug 2022 11:12:54 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 27PBCmbe196349
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 04:12:49 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 25 Aug 2022 13:12:44 +0200
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Thu, 25 Aug 2022 13:12:44 +0200
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 27PBCisK029296;
        Thu, 25 Aug 2022 13:12:44 +0200
Received: (from pawell@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 27PBCiG7029295;
        Thu, 25 Aug 2022 13:12:44 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <stable@vger.kernel.org>
CC:     <pawell@cadence.com>, Peter Chen <peter.chen@kernel.org>
Subject: [PATCH] usb: cdns3: Fix issue for clear halt endpoint
Date:   Thu, 25 Aug 2022 13:12:35 +0200
Message-ID: <20220825111235.29250-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f02ab6c1-9aae-4b6a-43e5-08da868ac1d6
X-MS-TrafficTypeDiagnostic: CY4PR07MB3128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpF63N7wDvcO0V8y7jzeG1MllxqGSaTijR3RQjpqr7Y9BdRlNyF3Yz4SLSEwTcNPet8b29l3EuKp3tJ5zSTFKcAlT5XOBdEMK8OqC4VgM6maLzB1PpWbg5bL/8BecM2gg12jHbz/ALvk9Skm7Z/joyQdh3q54LoIfTND15ZGYeJV24TatUboG7aPU3Y0RJXgek8SKrn3sk35NvSc3G7qMucxfD/cCHbW85VFM8CqgLtYQNTISlbr3dxRCqYZpGB3lzSAQpRg3hJANRUnzTfUzS4Ar0/mxSbslqiu4fQy/ErCITQoNWyN5JgSq2/TO8DlhGJKX0ZbRGdAyVFHSce+g2t+J1oOBJozrAV2OEMUZlHkhnr7B12zY3Gugo/Exd/+saKyYrB2reS0t+0C1/4aFJhiOhboBb+ruC2aCAZd2owJPUC+K0feQANrQ/rrH76xdvKNBCwKcVrtah+9gfbJgJFUk0TZZBeNS6GqxokWuLQI/BXtwi8IVMykeVFSX9+GXL/uR2bEn8L8ar8eMTpVK8k2bgFd9+WP1isbLBg9U4/XmxKUJCDZN+wfJxhkTkC5UTRLHKSLOhvwTrVG6zS19qCxisI4+Wqk0rzShd+gljZtPapTjOUE0UA9jsLKAguHH8M3joQgQ4xZW5UOQasG6cT0HMWpUmxl2vYhZ7pWHBeBmvPvqDl8gtifNBvgZIDfRaijZR6ZL7nAU6fgDn4AgF8EhgnIwxJYLxZh+bwEl+siMK1XAXq22BSbcpPbO56C8OAE31V1Scz6eOh53RZLKgCeJGo3LE/o/NzldEoAUFOmNK22vDhfn2HfFmlc0a+v
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(36092001)(46966006)(40470700004)(36840700001)(40460700003)(8676002)(70586007)(426003)(36860700001)(356005)(82740400003)(2906002)(478600001)(8936002)(82310400005)(81166007)(4326008)(70206006)(186003)(336012)(40480700001)(6916009)(316002)(2616005)(54906003)(42186006)(1076003)(36756003)(41300700001)(83380400001)(47076005)(5660300002)(6666004)(26005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 11:12:54.1531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f02ab6c1-9aae-4b6a-43e5-08da868ac1d6
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT096.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR07MB3128
X-Proofpoint-GUID: um5PSGXhFLU-bBGuZW0eShN-NPiNbdrn
X-Proofpoint-ORIG-GUID: um5PSGXhFLU-bBGuZW0eShN-NPiNbdrn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0
 mlxlogscore=632 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250044
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

