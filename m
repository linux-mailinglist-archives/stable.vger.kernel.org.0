Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9B66D1B51
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 11:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjCaJHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 05:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjCaJGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 05:06:46 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEC21FD1A;
        Fri, 31 Mar 2023 02:06:24 -0700 (PDT)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V6qi78000864;
        Fri, 31 Mar 2023 02:06:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=vIp9Ev0lMVFELrGOwjeJWNdUx58OkSR+I0uEURRZWmU=;
 b=pRDIaaY2P6drnBS6e1agtQch5ShkDK7529+Jy27EKBoCnaE3p32gih3g1+tBJmZyHg5Y
 ZfkJaI71de8inG4Jn5oe9gNYrwabYVQ6PvvitmdHQClPeiqBtXgpsjvMMgouEYgoMooN
 G1PG5F+7CqPEf6pgx3y/ffvaCWJsBd7kQgyiqLdF0WSXFxdrMLtHWJjPvYaYYCyDZuK0
 whDa663NoeZln2wloKWKSA+xRTCyCxtzGs80NMWH1KKUepkEEvzuBmExWE7AJIo8LU8R
 A1lzO/v7W7g/1SPwGNb4Btf30M2OjHDHn4xTUy8istyQoIBKMnCOnRg4x6TdvLV+s3Uc xA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3pngsgkd6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 02:06:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiAonXxcRXF9g+5LduP81ZwS64IxAHw4OXyU1HN9Q0njL0hUKFKTgsDSOyCofZV3rPHok0TAcY05p3i2vsp1F9Wh8T3h1XRHKztQMgR87zpJMnepYkTN9hXjGf/QrqO0M1DaBZuEMv5duSrg0wCCbGUsjsFjSDk5PMm3o5+hA/q+5eRJfBMq6Opyx0JvVE1IXVkDM62dYkqOxa+YDcjOuDNy9OC86DWj0jjUD5Kwl7s9kuwu0hqUAEjebql2ryToUjY5IzQeND1ONlgIWiaAxxwaTKA54z060WX4m2np8uXwuHKdXrrRVvun1Xy3LsChdmt4OKNYjM2DpprYRboYrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vIp9Ev0lMVFELrGOwjeJWNdUx58OkSR+I0uEURRZWmU=;
 b=J2YS/Zuz4eTd7IwzJU91Lympn3cHEbKQ0dGlh+erqoJGkNMHmEtRHM5NN63wnMqRyYHELgZ3RpSAgouqqvmagm1IWaPIMoKI9BVp2wCUJ0HrZ7sMX9qVK56c4+/Oe+N3sVeay5HZc1UDnHO8EHyE6ouWaVWR5yVCzgIiSDGPZBhljEyd3wJxk3IsMf288LcCb5ooakj4gRZu338dvaWb43ihEzHsDUMvnm8v4IfgH8AyJQQSVYyqAmqOLnN8db1DD9eJDI9nyTs8xaGdNWBbEjtvKsJ1/uWnohjmIhWvg/OSx/BHQkZxyVIlsK6Mko/D3zYrij8Y4PB35PW6FJL8FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIp9Ev0lMVFELrGOwjeJWNdUx58OkSR+I0uEURRZWmU=;
 b=fLo7xPAN3Tvs0QXjnwwFLXTq5MEEkCc+nZt8092BFgCrgIJwo7uq/vnsQu0QMYG4oFdoP+fjDR9P59q+2VQ6l93M9XVjgn5rmaSnXPekZNoSsxZjJht1rmyr27tm50VDpTOzw9dD083jc47UlZvlw6lOEhLG3L6TsFN08lJx9KQ=
Received: from MW4PR04CA0048.namprd04.prod.outlook.com (2603:10b6:303:6a::23)
 by SJ0PR07MB9186.namprd07.prod.outlook.com (2603:10b6:a03:3e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 09:06:10 +0000
Received: from MW2NAM12FT071.eop-nam12.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::77) by MW4PR04CA0048.outlook.office365.com
 (2603:10b6:303:6a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Fri, 31 Mar 2023 09:06:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com; pr=C
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 MW2NAM12FT071.mail.protection.outlook.com (10.13.181.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.14 via Frontend Transport; Fri, 31 Mar 2023 09:06:10 +0000
Received: from maileu4.global.cadence.com (eudvw-maileu4.cadence.com [10.160.110.201])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 32V96603000543
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 02:06:07 -0700
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 31 Mar 2023 11:06:05 +0200
Received: from eu-cn02.cadence.com (10.160.89.185) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Fri, 31 Mar 2023 11:06:05 +0200
Received: from eu-cn02.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn02.cadence.com (8.14.7/8.14.7) with ESMTP id 32V9656b454847;
        Fri, 31 Mar 2023 05:06:05 -0400
Received: (from pawell@localhost)
        by eu-cn02.cadence.com (8.14.7/8.14.7/Submit) id 32V964C5454835;
        Fri, 31 Mar 2023 05:06:04 -0400
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fixes error: uninitialized symbol 'len'
Date:   Fri, 31 Mar 2023 05:06:00 -0400
Message-ID: <20230331090600.454674-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu4.global.cadence.com
X-OrganizationHeadersPreserved: maileu4.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2NAM12FT071:EE_|SJ0PR07MB9186:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fb4175a-e019-439b-22a6-08db31c72ba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Q9xWhQ7k5YymV+HpPOggANiWG6AsYhSaXhVNpj4zpbHaLSL31aIpN+0B9NQxwQb4WKDkmMEFkEiejzQ0rezmbkhfJLqAE9+ke65pHB21wgn1JGHOfQdqMiyDZC38rILLAXIzPXjHKm2krWtI4W4BxoriDdZi2liqDrc/DW85oFXUSzvdUqrHr1ABBBpNtZQFMCQzIoqJ+vezOM+BHLZcT+jNzPmlYMvTH2dJx8o8iUUhQNCDvEMZR19HRbT2m9o6qucd1u1W8TOao2LtnWHTyIIfpLHVjf5+DLjI+nHupVfYKekcRaA8jY8HNjCRCFG7sOJ94fvNYYH2l3vqfUPzkIeytNJWeTX0s55+CvnvDqHdZV87Ij6IRc/IxgEwQaP9G3SeMWRe08WOu5t7pOWrjuHK8VXX4QuzabIcMgmNg4s8wvUNd7ta/5KoZO/VhbYuQ6ASV5CIXoZltI4WAs4SZRVBzfH4eOqScJ2OAzVU3UlcsSN9/JXOltH+vpHSEasMDSUNlr10w7V76QxtkqGah4OZMp2NBiamxFCHuiReQ4GGV8PDcyaV+wjm0TT8M64bIE3EU5Ovppi6RIUKeIV52UZpt2qUfq5p9dRR/ZXTA7IxlebyuvWkjIiUSp8Bm+StHPHrs8aBAi6yoNNS2kAdgM3v9Uji00x0N5+Fb38QOfAy9CY51TtvqFo2cL1dabYz+C3Cn7OjLlbjImN+7t+Iw==
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(36092001)(451199021)(46966006)(40470700004)(36840700001)(47076005)(2616005)(336012)(1076003)(186003)(83380400001)(36860700001)(426003)(26005)(316002)(478600001)(42186006)(54906003)(6666004)(2906002)(82310400005)(356005)(40460700003)(8936002)(7636003)(8676002)(70586007)(40480700001)(36756003)(82740400003)(70206006)(41300700001)(4326008)(5660300002)(86362001)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 09:06:10.3083
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fb4175a-e019-439b-22a6-08db31c72ba5
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT071.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR07MB9186
X-Proofpoint-GUID: rXkctWpvP4ay04SKWU_0FQmR30mQ2A7k
X-Proofpoint-ORIG-GUID: rXkctWpvP4ay04SKWU_0FQmR30mQ2A7k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_04,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1015
 mlxlogscore=746 malwarescore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2303310075
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch 5bc38d33a5a1: "usb: cdnsp: Fixes issue with redundant
Status Stage" leads to the following Smatch static checker warning:

  drivers/usb/cdns3/cdnsp-ep0.c:470 cdnsp_setup_analyze()
  error: uninitialized symbol 'len'.

cc: <stable@vger.kernel.org>
Fixes: 5bc38d33a5a1 ("usb: cdnsp: Fixes issue with redundant Status Stage")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-ep0.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ep0.c b/drivers/usb/cdns3/cdnsp-ep0.c
index d63d5d92f255..f317d3c84781 100644
--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -414,7 +414,7 @@ static int cdnsp_ep0_std_request(struct cdnsp_device *pdev,
 void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 {
 	struct usb_ctrlrequest *ctrl = &pdev->setup;
-	int ret = 0;
+	int ret = -EINVAL;
 	u16 len;
 
 	trace_cdnsp_ctrl_req(ctrl);
@@ -424,7 +424,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 
 	if (pdev->gadget.state == USB_STATE_NOTATTACHED) {
 		dev_err(pdev->dev, "ERR: Setup detected in unattached state\n");
-		ret = -EINVAL;
 		goto out;
 	}
 
-- 
2.34.1

