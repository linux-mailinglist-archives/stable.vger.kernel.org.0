Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF69603AA4
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 09:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJSH2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 03:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiJSH2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 03:28:32 -0400
X-Greylist: delayed 4847 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Oct 2022 00:28:30 PDT
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88099642CD
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:28:30 -0700 (PDT)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IMi8wZ000854;
        Tue, 18 Oct 2022 23:07:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=s2ekU4f/QJNaEWAxUO2Ikff2uz+LVzXK0fqL3vVNnso=;
 b=PpMaZHgSiabMI3QHyy1WGBmd+KBWTNx+C2RkeEZ3CtvO4kWbYqRBVogCBogiHcLpVU/Y
 gu2A2gmIWrV6Zj5hPIH9ly3Ncc+PJ83aWJ3BBrQuqqBA7fC7XSmf/c+YWbWc2VxM/pht
 RR6eoP9tXHXOfJuThXSas0xqpt4w+5/xn+DcKNlzmskbRPFTD5ltnoXKaY4Ot8P3wtgF
 p4vpiqKrHyNxp565uRZadEORkvH6W/7P7z51MNue7XOs4C77n4WG/Ysi94X+iW28Ftxw
 SexOSjflrBxwEPJzqscOEGzaSYzcR9/hYIydj7uyza7Mbf7XtHHKty4Tgw8Yp9ayseFW dg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3k7rf1kqne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 23:07:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnOCL54uIcOJkqxzt2GeBkOdw4HtJzCgQSJKzt+A5WSSy67l7jjFD9Oi+knrNVRfTZ+ucOOCX44455puEXwr3DhEDPkiF3fYXOFMv0zvQt7laXmSOjHfcYPs6WjkuaMTVtl0Y5SKkK/EnQzODx0TPXduSlOjeUjL+XENlBFa4NHUJuwlAk4yPicxMwoa/uYsLI3c8s6zGEVJwZHxtBkmR/C2M4IuxbQTq9Ti1UqXNns4ykBaDp8E08GMzGdyuIymVSbYoyL6/ptkPPOp+r93JDiwm9flRgrTADsHLiUKRq7H2VgoeI0z7AlnOhrCcRtOCOCkNrVQzXvjTXVPiM98Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s2ekU4f/QJNaEWAxUO2Ikff2uz+LVzXK0fqL3vVNnso=;
 b=CKvrieZo7gXERM9mIZTq2qufzXdeJUwXwlV6315lM0ixFtWngE7uwLTW00rBeJ3rU/6oSn9wcc2/1MDz8cY6Immr6UFSn3YAedZbOwQ+9zCCBeXbmIBif0os18A3Cg+I/VrN3Vy+gICz1BuqFqw3Et1C4EnAPGoUj+974M4RcbK0X+IYWd9pk4Cf6+JXIbn5IE+zFwmZHFOTHp+EubSV9wuzsIHylCN7D9RuxaLTSwEvbJy/dpaB9J3TWM20p+4+HEiO3X0DjuBe6RCapqJjJwcr8jVkwtebwCMKs54x++v3eF8iZqoMwx+HYUAbNka6WKPNgBBfnoT+ELVJzfxj3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2ekU4f/QJNaEWAxUO2Ikff2uz+LVzXK0fqL3vVNnso=;
 b=0m/DKSJk3xecTiIEUCDSzIYjhfd7PgYwRkrJ5QMnCg1ULuKqqxpUVT4y0U9pcSQjvyS0uabppB1y1J2gj9Q3n8KxaXWFGDmftZt/iItSetivl4mnUwvfXg4cPfHMnGB9yb0zuT6FYXHLqG6IRgPehanPGgGugGFXYPcC7qw7Avs=
Received: from DM6PR05CA0039.namprd05.prod.outlook.com (2603:10b6:5:335::8) by
 BN7PR07MB5091.namprd07.prod.outlook.com (2603:10b6:408:25::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.33; Wed, 19 Oct 2022 06:07:30 +0000
Received: from DM6NAM12FT057.eop-nam12.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::10) by DM6PR05CA0039.outlook.office365.com
 (2603:10b6:5:335::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.11 via Frontend
 Transport; Wed, 19 Oct 2022 06:07:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com; pr=C
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 DM6NAM12FT057.mail.protection.outlook.com (10.13.178.73) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.11 via Frontend Transport; Wed, 19 Oct 2022 06:07:28 +0000
Received: from maileu5.global.cadence.com (eudvw-maileu5.cadence.com [10.160.110.202])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 29J67Qp5133987
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Tue, 18 Oct 2022 23:07:27 -0700
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 19 Oct 2022 08:07:25 +0200
Received: from eu-cn01.cadence.com (10.160.89.184) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Wed, 19 Oct 2022 08:07:25 +0200
Received: from eu-cn01.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn01.cadence.com (8.14.7/8.14.7) with ESMTP id 29J67Pxk161237;
        Wed, 19 Oct 2022 02:07:25 -0400
Received: (from pawell@localhost)
        by eu-cn01.cadence.com (8.14.7/8.14.7/Submit) id 29J67Oun161236;
        Wed, 19 Oct 2022 02:07:24 -0400
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Date:   Wed, 19 Oct 2022 02:07:17 -0400
Message-ID: <1666159637-161135-1-git-send-email-pawell@cadence.com>
X-Mailer: git-send-email 2.4.5
MIME-Version: 1.0
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu5.global.cadence.com
X-OrganizationHeadersPreserved: maileu5.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM12FT057:EE_|BN7PR07MB5091:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ed6c74c-dd65-48fa-572d-08dab1983396
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FKqLeH/38hFHBSBSiNj4yNdlp/q0UwmO1F7m1dJc7PedX0vjT2sBN2xd7vVIG3nGMZ+2cwKCWjMY9DxQN9x9TZSI4LpSSutYvzBb1w0cIId9oO2S5TlK5MV41vC3ijD5f++pCUZO4a2fPWHayEUZCfxr01iHhSgVvE7YuksnHxjQcLm/64rwdsUnvUj9GtC4Z+Q0UoTEXvZmJNfjYkla9R2ipg+7cS/TvvmXmwBhlah34Ooi2sEWJeGpNY4AsHOJ7g/tjnt7s00xTP7fadfeBvjBAnJklGFlKVmbL4dXJVO2II5oGZTaQSnof+V8w+hrjgsPZFw2pvdPvMoPj4mL6NTsqLz9flEcUsgCnP9odIqHhOzqWpAq1H9h7ZcqCPSqDP4nhSPO4hTSLnfYhvA3pblCZVs8XbrcsSjjchjKyvir7IV9XRsTTtX5XIQwTL7H32MTXmxYoaN7+GweYVS9KbIpXFl8O4UVDAKbeSOB3qR4atXIuK22hrP01ZlYgj9l1ZyVop/QZF7PEt82nSw6sfGpsHoqc93SFg2523Koow0rCyd+n2JtOhb0nGVHaWItBpsUre4/HP/8Nop9Z4bIkwW8mVh/5DlGu0IV/Q8TGNpnz+98Y6bzXmSLWGnTfUddS1RZL0pa7aXmIOkI/hONn8JgQNB0Nf8x+CS5qDrag3MM3p9JZm86ZiG0CH0uuOx28gUq5Z/MWXFv+X06/DI7X6bwC/NR16Kp8Vi8BTUkpNjKgXk9b0Ms6ND90/Vll+YIo8YK3wbPGWwT+YV7BRERrQ9HM4+xZ9KSxUNsZ/0f+quRU+/0bW6iqfCxDodvbtuh
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(346002)(36092001)(451199015)(36840700001)(46966006)(40470700004)(5660300002)(2906002)(8676002)(4326008)(8936002)(336012)(2616005)(41300700001)(40460700003)(356005)(81166007)(86362001)(82740400003)(26005)(54906003)(6916009)(82310400005)(36756003)(6666004)(478600001)(36860700001)(47076005)(70586007)(70206006)(42186006)(316002)(186003)(40480700001)(426003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 06:07:28.3888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed6c74c-dd65-48fa-572d-08dab1983396
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT057.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR07MB5091
X-Proofpoint-ORIG-GUID: L4dSBQesf5cjdNbPipFvKuYuTFVz6a_0
X-Proofpoint-GUID: L4dSBQesf5cjdNbPipFvKuYuTFVz6a_0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_02,2022-10-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 impostorscore=0
 adultscore=0 spamscore=0 bulkscore=0 clxscore=1011 priorityscore=1501
 phishscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=426 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190033
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch modifies the TD_SIZE in TRB before ZLP TRB.
The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
processing ZLP TRB by controller.

Cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-ring.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 794e413800ae..4809d0e894bb 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1765,18 +1765,19 @@ static u32 cdnsp_td_remainder(struct cdnsp_device *pdev,
 			      struct cdnsp_request *preq,
 			      bool more_trbs_coming)
 {
-	u32 maxp, total_packet_count;
-
-	/* One TRB with a zero-length data packet. */
-	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
-	    trb_buff_len == td_total_len)
-		return 0;
+	u32 maxp, total_packet_count, remainder;
 
 	maxp = usb_endpoint_maxp(preq->pep->endpoint.desc);
 	total_packet_count = DIV_ROUND_UP(td_total_len, maxp);
 
 	/* Queuing functions don't count the current TRB into transferred. */
-	return (total_packet_count - ((transferred + trb_buff_len) / maxp));
+	remainder = (total_packet_count - ((transferred + trb_buff_len) / maxp));
+
+	/* Before ZLP driver needs set TD_SIZE=1. */
+	if (!remainder && more_trbs_coming)
+		remainder = 1;
+
+	return remainder;
 }
 
 static int cdnsp_align_td(struct cdnsp_device *pdev,
-- 
2.25.1

