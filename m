Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47B34EAAD5
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 11:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiC2J44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 05:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiC2J4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 05:56:55 -0400
X-Greylist: delayed 3965 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Mar 2022 02:55:11 PDT
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6655436695;
        Tue, 29 Mar 2022 02:55:10 -0700 (PDT)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22T72QUY031968;
        Tue, 29 Mar 2022 01:48:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=SWhpFzUnkRodH+JmDivYirPlKYdcsvYlR6r6E7ZYC1Q=;
 b=sElTkT2p2MblEMVoJUwQflq+y2vfdIKtqQCCfv2ziNi6Z0yY1zVIf+IUGVauEuabDREP
 7p9huOw8+ZA30rkilLnRgiMEQo6U9/B+bLVuKscNQZf00d2rgz/ENbUlr5Nh3dosCRpg
 b6qNCAT591+wzIQQv/dcSZLplP58dOI6KvvRgesS/RSIQ7O8HP/93o85OvU2RRB53oYG
 XJRtx83anoRYEnePRp/mFlqpHNF/8fvnzz+ABR2ilvJvO+8LH6D3aIbytCCgED5dYu/W
 TQ63N9kfLVo+iMt98bVUBDLFq1oQDksNJHtWN3AQ0508IFBjQWQ62z0dccGwb6jU7HDC 4g== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3f1xe0d2ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 01:48:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBhrN+1CNigtVY1Rw5mfAal0thwhT4QSwyXg3u6PHjiRjB3GDEiI9JElmEuEv5ITwhcGlXjkZnNgaV3qBzDm1GWySold+h+JDvCP0nmpLC7Pcieo/f8tifHiL0xLfM/tS3ga5HEEZKl6TIdZ2XGGvWrFIJzhcQMSuKBXxWqdbMLF8vzZIctTCo35C5qo3IU8Q9DRkxGa4hxx5z9Q9wFktjiDMD36JrxRJ6TS1Fy90W1EC1H4GmxT62clJsQ/wu8HIHJaqyw1PG0OT6Az/nCgKqdvLtC0BUW/PZ51L9HbBoJWogYl+7rG5mFWsfCDLQnXqOjEAmYGFm3s/hPIiW9VCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWhpFzUnkRodH+JmDivYirPlKYdcsvYlR6r6E7ZYC1Q=;
 b=P16S54dutFMo4DSljGL/cnPVfoqJ42f/F3IEnuR5fNWaR+YOBlmf8uqNn8cVBzJ+xjSs1tfz8qhDSvb998bdEWN9yyVxvDj0bHXaI+GiBtsMvO3Rl0Swgde7ezTjUVvwhhOxDzebHikkGhZbB/d8PKVSi9Cj/Cf5YU71RHedDZiRYzPtOCylAf2ZmQUbukvqzi8G582c+2bQU7eQtChTenoWFl7TKYrsG0hp/Zt7ezCRF3Hhz4vmmX3XeQ49lmVMhws3bHW2JH0eydCqHcQN68T4qjxuWLTPEsQ/HJutYWhPfTkq6KMErdvGzmFyYyUEzPfZevgoRLyEDSRIjHZC0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.148) smtp.rcpttodomain=ti.com smtp.mailfrom=cadence.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=cadence.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWhpFzUnkRodH+JmDivYirPlKYdcsvYlR6r6E7ZYC1Q=;
 b=b25A42QiLJTq/2TB7VOVHQAcsWU5qz2tK1xPcIOf8t939jhMnRbGt4NNZmlVWRVNL5XNhFuBucppG2iAngGXUW7xmkSAJXL9Xofy6xWEtpkfa3iESRqITmc9usYTLItObxzIsTWYw6ytqNkMgv7xytOQcYOWYwW7HTwlBq1uFJE=
Received: from DM5PR11CA0007.namprd11.prod.outlook.com (2603:10b6:3:115::17)
 by BYAPR07MB5256.namprd07.prod.outlook.com (2603:10b6:a03:11::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Tue, 29 Mar
 2022 08:48:45 +0000
Received: from DM6NAM12FT022.eop-nam12.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::ee) by DM5PR11CA0007.outlook.office365.com
 (2603:10b6:3:115::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18 via Frontend
 Transport; Tue, 29 Mar 2022 08:48:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.148)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.148 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.148; helo=sjmaillnx2.cadence.com;
Received: from sjmaillnx2.cadence.com (158.140.1.148) by
 DM6NAM12FT022.mail.protection.outlook.com (10.13.179.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.14 via Frontend Transport; Tue, 29 Mar 2022 08:48:44 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 22T8mgVU011932
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 01:48:43 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu4.global.cadence.com (10.160.110.201) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 29 Mar 2022 10:48:29 +0200
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Tue, 29 Mar 2022 10:48:29 +0200
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 22T8ki27004742;
        Tue, 29 Mar 2022 10:47:08 +0200
Received: (from pawell@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 22T8khSS004722;
        Tue, 29 Mar 2022 10:46:43 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <pawell@cadence.com>, <rogerq@kernel.org>, <a-govindraju@ti.com>,
        <gregkh@linuxfoundation.org>, <felipe.balbi@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] usb: cdns3: Fix issue for clear halt endpoint
Date:   Tue, 29 Mar 2022 10:46:05 +0200
Message-ID: <20220329084605.4022-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d82fcbf-d346-4dcf-33db-08da1160eec5
X-MS-TrafficTypeDiagnostic: BYAPR07MB5256:EE_
X-Microsoft-Antispam-PRVS: <BYAPR07MB52567AC2C017FC8921E3D097DD1E9@BYAPR07MB5256.namprd07.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hvFEVPkigG5VeqethYo5U4p4MFZBmSxUfG+CyPyveRtuFDuELSFANDNOSiCumHdy+K7FiDZxQiMQPXLgUZpHMdv/7YkI1A97Z9S+HT/OX9Pxul6ltsC34elfqA38jHoqbh/mVHQx7uPvbjKnR7KtrYdUjbBvuJ743QYW3QOqRzramSmf/YTxH3QKQ9bRchqkhYAf5TjkSx3NSg//wgJ4tgF/6D0LP1vmlDDZJM2Rl8oPUxYEMUHjPyUM3Uhp3793FCQ1/tQM5Je9ExraCe2IMiWoSyUuQbHmPo5qwfFdiJO2fjdTjk8C8FuwOpDFl25oGOUwmGkCxCsXzD0ex5LSDTMIb7dtyvO0BP4wxoekGZ3AnHPBwtg1LY6TH8HCcdsw6kFGikqhbKhSwxYhSQbHInL8tCaJ3oNyni8sQfDga3akttDCZKOWJL68VW/FZuKjEaRjP+afkeBGqTQTE/BuR2BorRfQ6TA+85a1LYBs032jNhkoo1qY+2NhGyg9ZkOJ/ll1RxO/kU+7x5vQpM1hIEDFoDvM+21J/z7DHzNNyKXBs1kpepDHakpcnfe+FWy/DPAlq1fbdC0u1a4W6cZv7TK2dx11vqKUCm3PatEejF0wyA9M6tqHAkPa/rKTGnU/6DC0dT4C7hPCXD/uOB4/dKP4Oao0xI9QtmzZQGPOTx8K9GwY6nzbVcm+3K6ECwtU
X-Forefront-Antispam-Report: CIP:158.140.1.148;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx2.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230001)(4636009)(36092001)(40470700004)(36840700001)(46966006)(5660300002)(36756003)(8936002)(2906002)(7636003)(40460700003)(356005)(1076003)(4326008)(83380400001)(82310400004)(70586007)(70206006)(8676002)(186003)(26005)(47076005)(2616005)(86362001)(336012)(426003)(36860700001)(508600001)(6666004)(6916009)(316002)(42186006)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 08:48:44.5842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d82fcbf-d346-4dcf-33db-08da1160eec5
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.148];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT022.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB5256
X-Proofpoint-ORIG-GUID: JiKTS29yMdY857qA8ty2hK-bVLoGSpBI
X-Proofpoint-GUID: JiKTS29yMdY857qA8ty2hK-bVLoGSpBI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-29_02,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1011 mlxlogscore=421
 impostorscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290052
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Path fixes bug which occurs during resetting endpoint in
__cdns3_gadget_ep_clear_halt function. During resetting endpoint
controller will change HW/DMA owned TRB. It set Abort flag in
trb->control and will change trb->length field. If driver want
to use the aborted trb it must update the changed field in
TRB.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdns3-gadget.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 80aaab159e58..3a9f0968fd24 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2682,6 +2682,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 	struct usb_request *request;
 	struct cdns3_request *priv_req;
 	struct cdns3_trb *trb = NULL;
+	struct cdns3_trb trb_tmp;
 	int ret;
 	int val;
 
@@ -2691,8 +2692,10 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 	if (request) {
 		priv_req = to_cdns3_request(request);
 		trb = priv_req->trb;
-		if (trb)
+		if (trb) {
+			trb_tmp = *trb;
 			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
+		}
 	}
 
 	writel(EP_CMD_CSTALL | EP_CMD_EPRST, &priv_dev->regs->ep_cmd);
@@ -2707,7 +2710,7 @@ int __cdns3_gadget_ep_clear_halt(struct cdns3_endpoint *priv_ep)
 
 	if (request) {
 		if (trb)
-			trb->control = trb->control ^ cpu_to_le32(TRB_CYCLE);
+			*trb = trb_tmp;
 
 		cdns3_rearm_transfer(priv_ep, 1);
 	}
-- 
2.25.1

