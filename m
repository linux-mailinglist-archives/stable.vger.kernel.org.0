Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83598623BDC
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 07:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiKJGar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 01:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiKJGaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 01:30:46 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5572622518;
        Wed,  9 Nov 2022 22:30:43 -0800 (PST)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AA4BjlC018968;
        Wed, 9 Nov 2022 22:30:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=LWFneiuSG7M/iAOCncKkeIqVobntHZ69vlPzIrkyS+Y=;
 b=bGgYgLV3jWNuPXdWsneSTK0L1znzvWLkOh1s6l9XpYFdtZn/agg7w+FIeEREdEWmd4GU
 y1Y2qK9b/gfLKKiNyklaCQsls1lL+B/BgM2aOHOoysKkFDZJgUm7Jht7UHAgPs45nAa6
 z63lak08rYnE5NpWOPPgd9iyTFwWyxeYlWgbRredrowONMh8ccsDR4CBFV64zluZCWNF
 eNl0/D64Xe69QIPH1qPpGBItKFGsMF7vZXsjy0t8GvbiKM2JpJQx94ikVDArfF3mefBi
 KLz5clWdfzq8l9etrJlRRfTGjgi+ltX8/HVHHApE82brdsqK1ujVL0nH/H/eZQOZOvxG zw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3krs1xguh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 22:30:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OK5FR3GpDZ5aeW8csR4wJW6sTmbU7QWRCM/JZIFryEsk1lSsVdNAeL98SRkJHaKbfdTC+6swLfqNcRSXkjuQgncEfEG9H834vlmq5nhsBBQpya2AgxV8CXcA9AHtjGKsHt38m48t/dMxzGafD/yRTs4xvNfQgDrZcAxzL8sT5FEQBG663BWCJ8U2MKtQBvAArg3i0vi19UqjDPlGtalQXFY+mZg7tuy2SnJ/R5YLBVCkjwgI9Ur1gXEqB2CxLhu1SXUr4xGXNVmshIs+rrxAdnT6Z+03jDqlGQ0uzjkga/5t+PPA5eVcViNr6vU0nT1rQZxz3FmOWzaqsx6cZiX2Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWFneiuSG7M/iAOCncKkeIqVobntHZ69vlPzIrkyS+Y=;
 b=RmIHNu/IX3kbEPB0+dtX43Qtgbvf0C84xD0rZ3LzXiYg6gmcHDTul0JlDnCe3rmtxtNNULMXY8Q/Fs0G6wYfw0VfjjIE77pceqJEWXNKYbri2jlMyO2ebn6shSfdVdT90F+qXB+1P+6P8kdfYCnY9wGCFT4Y3pp5ydzJpcNIx8ebI+tt2APyx/bTl7wBm0ZIqsmTxg7sPCokD8C9VAS7E1KynX1NiiGxbg7KAnKp4HCXBMhT8cSjv1WaqoxLDpr/nNLLrJeIblrXDLKTc/vDOMIoxuku16st0NUqz407rWN6Ba2VtfoIi9ItomEHxeOBgFP0upwMu7cBBuHnTP+8pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=cadence.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=cadence.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWFneiuSG7M/iAOCncKkeIqVobntHZ69vlPzIrkyS+Y=;
 b=TtzFydzZvWlk5qxlfvbpTALWM32Pt9l3UzDyx4CD9tFGxoDLDcLGKvwGPj011iBLz22OltL2ejOXum9fQhNHQPoTwGdwEzA3DIVs55usC51aAidJxRNE65LkUjD3aGBsbRR5J4sxwdFURWpgCURjC4i+kMIjjNJ44UFGHeybtoc=
Received: from MW4PR04CA0233.namprd04.prod.outlook.com (2603:10b6:303:87::28)
 by SN6PR07MB7904.namprd07.prod.outlook.com (2603:10b6:805:12::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Thu, 10 Nov
 2022 06:30:35 +0000
Received: from MW2NAM12FT029.eop-nam12.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::2a) by MW4PR04CA0233.outlook.office365.com
 (2603:10b6:303:87::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.27 via Frontend
 Transport; Thu, 10 Nov 2022 06:30:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com; pr=C
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 MW2NAM12FT029.mail.protection.outlook.com (10.13.181.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.2 via Frontend Transport; Thu, 10 Nov 2022 06:30:35 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 2AA6UXK3005841
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 9 Nov 2022 22:30:34 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu4.global.cadence.com (10.160.110.201) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 10 Nov 2022 07:30:13 +0100
Received: from eu-cn01.cadence.com (10.160.89.184) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7
 via Frontend Transport; Thu, 10 Nov 2022 07:30:13 +0100
Received: from eu-cn01.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn01.cadence.com (8.14.7/8.14.7) with ESMTP id 2AA6UDTU370862;
        Thu, 10 Nov 2022 01:30:13 -0500
Received: (from pawell@localhost)
        by eu-cn01.cadence.com (8.14.7/8.14.7/Submit) id 2AA6UCZ7370763;
        Thu, 10 Nov 2022 01:30:12 -0500
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fix issue with Clear Feature Halt Endpoint
Date:   Thu, 10 Nov 2022 01:30:05 -0500
Message-ID: <20221110063005.370656-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2NAM12FT029:EE_|SN6PR07MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: fe2f72a5-44d7-4ee2-4093-08dac2e51338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EpzY6SULX0r2af6wOXM3MjQmdcxCbvb8ItK2ZfIXtYXGITbZF7CoO3F1+H3Fu4NsxMhtYLRSQD5nr20Kz2u+6zw6LPh8KkQeLjK7Nm/XbcfPrUn3CWHsn+d6BTWYyNG+GH37T7/iTmCquQlFzhR+/FcIfnN0QnEPDP/TXwRxP5aCuM4XhY4LtTUjoCkD/uRtJlHtHG6npMY65l+J9M/XSLn+J3ZNIoS/q92k3wweVoI61FTt2QxUJPQhXa48U7WmsVnG1bwsKQz2kine2mmrXFd76G4KS0qtErZMFbzJDaCJH08gknscYaHelcn7q11cN94LP3TrPuIpqPvsE3wM6KlQu8niJtog/E64UT22aZdj++aoYmP7xzkCys98Rz1q5Ww4n8LdwZrHhwiWPNaK7dGZIYYk4XZ4Wg96m/T+MGjJl7nJFuN6R708nOPAmaCVDPs6WY25BafcOzF2Xcmway8U53vmr5bMXffo//zKMb4E4dBPFhiZi/MvSYMIdS7NcCDHDbwNVMbQ+Oo59ATpX3/t/90lw1UU1c2hMVj9bamYj/0HydT6TRiNggJnq8jyelr53t5JqwSwtr1gPn1g8zuC9mJ2N5vDdp/Wc+FoOL+0LU1EynIZiJG/UrvnjnGze2/NWi9CkGG+c3oYGwK6Tpz5VhJK2KkB+MtOVkSvv8G5FNLv45v3wMupfC3wbWn0QtAfkJvWngRP+ZCuS5ayt3etnBcUmiKNHc2YgEvrVY/t16uzKhzANx2+PewdS+n3M9Gu0VrL0Lkn1iSG4AqjqQ==
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(376002)(36092001)(451199015)(36840700001)(46966006)(40470700004)(82310400005)(82740400003)(83380400001)(356005)(6666004)(316002)(42186006)(36860700001)(4326008)(7636003)(70586007)(8936002)(70206006)(26005)(54906003)(8676002)(41300700001)(478600001)(336012)(86362001)(186003)(36756003)(1076003)(6916009)(2616005)(40460700003)(47076005)(2906002)(5660300002)(426003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 06:30:35.1630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2f72a5-44d7-4ee2-4093-08dac2e51338
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT029.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR07MB7904
X-Proofpoint-GUID: FW0KzQaCPz-fbfGPRuoOiMoUGvcWPkry
X-Proofpoint-ORIG-GUID: FW0KzQaCPz-fbfGPRuoOiMoUGvcWPkry
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 impostorscore=0
 adultscore=0 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 mlxlogscore=667 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100047
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During handling Clear Halt Endpoint Feature request, driver invokes
Reset Endpoint command. Because this command has some issue with
transition endpoint from Running to Idle state the driver must
stop the endpoint by using Stop Endpoint command.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
Changelog:
v2:
- added comma in patch description

 drivers/usb/cdns3/cdnsp-gadget.c | 12 ++++--------
 drivers/usb/cdns3/cdnsp-ring.c   |  3 ++-
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index e2e7d16f43f4..0576f9b0e4aa 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -600,11 +600,11 @@ int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
 
 	trace_cdnsp_ep_halt(value ? "Set" : "Clear");
 
-	if (value) {
-		ret = cdnsp_cmd_stop_ep(pdev, pep);
-		if (ret)
-			return ret;
+	ret = cdnsp_cmd_stop_ep(pdev, pep);
+	if (ret)
+		return ret;
 
+	if (value) {
 		if (GET_EP_CTX_STATE(pep->out_ctx) == EP_STATE_STOPPED) {
 			cdnsp_queue_halt_endpoint(pdev, pep->idx);
 			cdnsp_ring_cmd_db(pdev);
@@ -613,10 +613,6 @@ int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
 
 		pep->ep_state |= EP_HALTED;
 	} else {
-		/*
-		 * In device mode driver can call reset endpoint command
-		 * from any endpoint state.
-		 */
 		cdnsp_queue_reset_ep(pdev, pep->idx);
 		cdnsp_ring_cmd_db(pdev);
 		ret = cdnsp_wait_for_cmd_compl(pdev);
diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 25e5e51cf5a2..aa79bce89d8a 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -2081,7 +2081,8 @@ int cdnsp_cmd_stop_ep(struct cdnsp_device *pdev, struct cdnsp_ep *pep)
 	u32 ep_state = GET_EP_CTX_STATE(pep->out_ctx);
 	int ret = 0;
 
-	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED) {
+	if (ep_state == EP_STATE_STOPPED || ep_state == EP_STATE_DISABLED ||
+	    ep_state == EP_STATE_HALTED) {
 		trace_cdnsp_ep_stopped_or_disabled(pep->out_ctx);
 		goto ep_stopped;
 	}
-- 
2.25.1

