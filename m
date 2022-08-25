Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7B25A0B27
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 10:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiHYIOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 04:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiHYIOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 04:14:47 -0400
X-Greylist: delayed 6762 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 Aug 2022 01:14:45 PDT
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C12F39E;
        Thu, 25 Aug 2022 01:14:44 -0700 (PDT)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OLllrM027600;
        Wed, 24 Aug 2022 23:21:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=MPCJ7IS+jzcgaa+pLgT/C2XQi5NBZPuJPsiWeRJu7R4=;
 b=pSpzyGnMmLe185HPBCvkBz3wFD4zpZTwHZ43Umcpt3l1NH2nsgVhDSws2cRZPUQW9z28
 iu2EuMS8mxamlEadhdnV2DBh7pp8QrgO5DGUxFULkW6E4vWs2sOanB4j/5oNmrTQ+D4K
 yKQvrSdL2QPNNAZECZj+4ioAKPv4PlLwaUa+kmeDJtG54fP6oqh8UMdCDE9J7SaE1bZr
 59Qjne91zgcM8/uuA2giymjkx2r8Kra2hhMVwPsGiXaFrYVw7hA0Dmcb25lcMDepIOTa
 7I0FD/rck+hQh3LAG+mJIYMc05jtY8aCL7FiC41K3eYAmZD48zeLwDnPvfrnbQ+SPVoY 6Q== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3j5a4yf6av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 23:21:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y66Ei7lSwbgPoMyBQVVRgmg9K8smkuVCoaswkNMA+KZxwroT3VCrjqjUHs99RH/9RJiDpdfPXmCj+WlytDrmhvJA3S2pJImI0vf4V9zqqfpq6l43kRZRGqJbxOv45nHRa5BURcl73nlK3a/CSgwm+wtrGaw6+pcJJLJI8NcV9VolkrzJD2ehNKQqGbVQT38tYjJxzFdYdRUmy7KSKz4F4thwsedaCqtP3VxpfchsaqW4Irpdo19tr0fVibnfNSpQ8XkCIJRkRHQlegr9I9n0o6V86SMo9M+Y+74VFsPFdsJU6YjA4ERyks62mVM6xjDY24T6lYg0ks8Xu79716CkjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPCJ7IS+jzcgaa+pLgT/C2XQi5NBZPuJPsiWeRJu7R4=;
 b=Vf2S6Zikvys8ZHowLXi0Mo+xu7Q/MWD0kBoTX7zRcdJC5Beh0msJBR5/GannZnu+/vM7Ql5GHACWWX/MmUV1/7SADelFN7eDBin4AhSWxWB1DPLIQEU9yTh0naqcnDKNFXuwpZRid63kFtCcwW8wL78ACLayLcVgWgKgSLAMGFJeNuS5ut2xN+Sqbqa62wFx1UMd/EbWxd418UCEuEL1MHJuqsAkTSB8ZUhs7u7icFU6TCa1FI8m8jWogKekktDxQilk3Gp+KkrNg3iYYKg4gAkMQxkaSo1ztefFVw7I14lD6XhMUmhJvZrEuw24XP3+4v11x5cwDkTYhqbmPoLRfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPCJ7IS+jzcgaa+pLgT/C2XQi5NBZPuJPsiWeRJu7R4=;
 b=jLBfaIVIoCki/SoX+8MBI8a5/9jte3iNVISV7nAiJ2WFZHFo+3pfNHxbJnefi9V/YBMCYyNRT5d0v6JQ38Ba2EIJAvyGnWblwxWtyhJPx2BcfNxbyVhAR/nJx26kdRbMbgnRpfp+Zd3jmbK4cFy8lA2nn/z7mKhDtYdcnSCNk+4=
Received: from BN9PR03CA0321.namprd03.prod.outlook.com (2603:10b6:408:112::26)
 by SN6PR07MB5502.namprd07.prod.outlook.com (2603:10b6:805:e7::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 06:21:48 +0000
Received: from BN8NAM12FT116.eop-nam12.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::24) by BN9PR03CA0321.outlook.office365.com
 (2603:10b6:408:112::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22 via Frontend
 Transport; Thu, 25 Aug 2022 06:21:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com; pr=C
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 BN8NAM12FT116.mail.protection.outlook.com (10.13.183.52) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.3 via Frontend Transport; Thu, 25 Aug 2022 06:21:46 +0000
Received: from maileu5.global.cadence.com (eudvw-maileu5.cadence.com [10.160.110.202])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 27P6Le7k179511
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 24 Aug 2022 23:21:41 -0700
Received: from maileu4.global.cadence.com (10.160.110.201) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 25 Aug 2022 08:21:41 +0200
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7
 via Frontend Transport; Thu, 25 Aug 2022 08:21:41 +0200
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 27P6Lf0w005811;
        Thu, 25 Aug 2022 08:21:41 +0200
Received: (from pawell@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 27P6LeMr005809;
        Thu, 25 Aug 2022 08:21:40 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <felipe.balbi@linux.intel.com>, <rogerq@kernel.org>,
        <a-govindraju@ti.com>, <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdns3: fix issue with rearming ISO OUT endpoint
Date:   Thu, 25 Aug 2022 08:21:37 +0200
Message-ID: <20220825062137.5766-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu5.global.cadence.com
X-OrganizationHeadersPreserved: maileu5.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe5d0e28-1058-494b-4805-08da86621645
X-MS-TrafficTypeDiagnostic: SN6PR07MB5502:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1rvAo23GPgRdQIdUQtS1WdAOViDczyYEu16846rr7D4V7zDS44B71WagLIOOUEM0kNBQFnEp9RfI0DFq0crLdvbutfX8c8imeiGdRdktgkHm3/fFboLImY6AVIg0X9pFWbD6cTcPrdvbgDHgtOb+AQkhLv4p6yjxJPEZfAzGlZqSqepERxS33g4Zfi1jHp6nNHZX9pUIJwSa0Yt5K3qO4XfbVK8+nCer8H50qPqWyGcDP0wRsYc22cu5pHWKmUt2K9ye+jN/hsqSAKhjVBVpBaNAy3Gih1DT3kXIR4tlB5KhPRM/rlVpsJUzZN9eecvr73ifnRu/kFRSXQXQjovVfm3CZWkpDOoPA5sNnvoFFpzSCWpdPrA55J85HtyN5uBNEaku1MC4BvZGocb19TX4h4tnmoaUKgpjnrXJMmjOi+4XhMVWcNTIwpbQcv2VXxNfw6r1mKnH7hrh3tk9iX3inD/xIMyyX49RC7CGUqh+25nZfFhFcAgNtD8AoqhixWIFP0PeSiGFA1Es2uip3epQkpawkLz95mynq077HBZDiFujBSEqXETm5gou3WaLkM9nrBp3+RpzvnJ+XMXu/Id82fz1VhRX7ArW9Ptp9+C986jRto9YoR+ecfWeKesbse2yvK+HMhkKKZitszBQDf50RYcfByKQsh+Mma8CcJAUrPSwqKcV9bWRaQv29Cvfa7Ld+WZRnfNk+hnxC9JC6y3IEN1/sWYZygogkHFaP4I5GcRh8WyN3DpqK4fYCylPiZJRCgQCfN0qw1TQQpNZyc9Esh9Y1wthRa5cOzZ9Kx2QuYEA3RmSbvl97Gxr/dL6qxh
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(396003)(346002)(136003)(36092001)(36840700001)(46966006)(40470700004)(81166007)(5660300002)(2616005)(1076003)(82740400003)(8936002)(426003)(356005)(47076005)(2906002)(6666004)(36756003)(36860700001)(82310400005)(478600001)(316002)(40460700003)(42186006)(6916009)(54906003)(26005)(70586007)(70206006)(41300700001)(4326008)(8676002)(83380400001)(40480700001)(186003)(336012)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 06:21:46.3340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5d0e28-1058-494b-4805-08da86621645
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM12FT116.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR07MB5502
X-Proofpoint-ORIG-GUID: KdUzinQyXK2D2UdGOiQ2CQgvAzLLOcR9
X-Proofpoint-GUID: KdUzinQyXK2D2UdGOiQ2CQgvAzLLOcR9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_03,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 bulkscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1011
 mlxlogscore=346 impostorscore=0 spamscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
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

ISO OUT endpoint is enabled during queuing first usb request
in transfer ring and disabled when TRBERR is reported by controller.
After TRBERR and before next transfer added to TR driver must again
reenable endpoint but does not.
To solve this issue during processing TRBERR event driver must
set the flag EP_UPDATE_EP_TRBADDR in priv_ep->flags field.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdns3-gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 682ceba25765..fa8263951e63 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1689,6 +1689,7 @@ static int cdns3_check_ep_interrupt_proceed(struct cdns3_endpoint *priv_ep)
 				ep_cfg &= ~EP_CFG_ENABLE;
 				writel(ep_cfg, &priv_dev->regs->ep_cfg);
 				priv_ep->flags &= ~EP_QUIRK_ISO_OUT_EN;
+				priv_ep->flags |= EP_UPDATE_EP_TRBADDR;
 			}
 			cdns3_transfer_completed(priv_dev, priv_ep);
 		} else if (!(priv_ep->flags & EP_STALLED) &&
-- 
2.25.1

