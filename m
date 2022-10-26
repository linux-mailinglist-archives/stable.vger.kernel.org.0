Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11F660DE4D
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 11:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiJZJiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 05:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbiJZJiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 05:38:02 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F91BEAF4;
        Wed, 26 Oct 2022 02:37:31 -0700 (PDT)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q0SG1Q002302;
        Wed, 26 Oct 2022 02:37:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=G1cBCdwClRAfQNHEw6stJyXzDuc9Rv4hqoZ8Gl306AM=;
 b=ooO1vib10S2RKCRjVpTKOU4Owrc4x6lz0X/BwU0FVn+1tRXLw9fGPHOmpStDVcCSeZtK
 b4aX9YI6BiqhbfyFaiIzxzX9+F7x6fQXArsIxKx5s0IyWfyf1osnZmO7Brwdq8gys1PN
 nWNF6fxqYvGbh1G+DYAjW93naiAnTGpSyT3OrhnIg9EUte5Mwy1t0ttgCoXvEVGAKBtE
 P3TSoQ8bnXy0jye+DgVhmWWx5FyUX9YxhKZNvsH9CA52VGXu3i5cdp9rBxhvU3X17aWO
 ZTzaVO6QYsic16TdIZKHHmqsLBy0+jFLiUpSIO7NVyhU0v9DAeIP8SVj/HSz8XaDMfi9 mw== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3kcc42js07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 02:37:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoC7tH3ClLNXfSrWG98iJ0c9t4Qw/Fg923QJOoIYJnqxtmkWUKr38DLcakeTelRnYHs28ms4IGbEp68vdSNiXMucj1WRsguUfEoElYAqCWXKVukQsW8Z+YynP4rqiQqpzpW6sPx8InsQ1vmsF2bKuPrKArWTKfyewznmtqjxm2BP9+dPETJ5wAfpA3ayJYCegQpoebGwPdyDPLjqgjoeCQTH+15oJkS0K68Z28rjmrJHKRdz/pdFnD9zW9kmxead6hAAMCwshZjiP/UYNvnBX5uD1DilmBC8zMPiNtkWWhBbSA9bRsT+Pm3VbMpMD2/RG3mz9ds/ME/hZJlvhMQlxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1cBCdwClRAfQNHEw6stJyXzDuc9Rv4hqoZ8Gl306AM=;
 b=MZwySUER4/82cg8H1vmNqu56RdOUmj76Wt0I/Zx488rssPralXxUJWkb4S0FtGQ9n6FbkNmm1oZbhJ0J9YXrkN0zcQocfI/OpxTGADm95ASHRK0BBidTEa9XuhR0Hebw/078opIfmyUIPgB5Hs+8BmDcUO4wlj9DmS444T0Cu1U8GuJeUB5GAsaTa0If9IPEzCZVG8AmbjoXvqaHxZWnPA6LJxzdtR45rm67L4D8lJpaJBsX45CdNB98IQana0MW3cpd7QRj6YVIKHPWK00WuueLc0oTECCS2ghbUjsZ7CuFCNOKRquxLKrEKXL6dGSa4PFJW4z58Rvc4gASMnLrKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.148) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1cBCdwClRAfQNHEw6stJyXzDuc9Rv4hqoZ8Gl306AM=;
 b=MWiy0HAxE0hARL2u3MQXq39x4lkQ++SmNc/sKtYsFgIPDW3bplZOrHpLRN3id0FsZtkJ4xT8yilXAv/eX2gt7zHJfqm43w98vgGibg+0Bm/PdtLfwA/925rv8iXrPAU38bWwvdYplXWjX1V/DbGimxCI5vpG4BjS8nm78OUjNzc=
Received: from DM6PR21CA0008.namprd21.prod.outlook.com (2603:10b6:5:174::18)
 by MN2PR07MB5822.namprd07.prod.outlook.com (2603:10b6:208:106::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 26 Oct
 2022 09:37:18 +0000
Received: from DM6NAM12FT073.eop-nam12.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::46) by DM6PR21CA0008.outlook.office365.com
 (2603:10b6:5:174::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.8 via Frontend
 Transport; Wed, 26 Oct 2022 09:37:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.148)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.148 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.148; helo=sjmaillnx2.cadence.com; pr=C
Received: from sjmaillnx2.cadence.com (158.140.1.148) by
 DM6NAM12FT073.mail.protection.outlook.com (10.13.179.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.12 via Frontend Transport; Wed, 26 Oct 2022 09:37:18 +0000
Received: from maileu5.global.cadence.com (eudvw-maileu5.cadence.com [10.160.110.202])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 29Q9bGkY013561
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 02:37:17 -0700
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 26 Oct 2022 11:37:15 +0200
Received: from eu-cn01.cadence.com (10.160.89.184) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Wed, 26 Oct 2022 11:37:15 +0200
Received: from eu-cn01.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn01.cadence.com (8.14.7/8.14.7) with ESMTP id 29Q9bFPk449928;
        Wed, 26 Oct 2022 05:37:15 -0400
Received: (from pawell@localhost)
        by eu-cn01.cadence.com (8.14.7/8.14.7/Submit) id 29Q9bF9E449925;
        Wed, 26 Oct 2022 05:37:15 -0400
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fix issue with Clear Feature Halt Endpoint
Date:   Wed, 26 Oct 2022 05:37:10 -0400
Message-ID: <20221026093710.449809-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu5.global.cadence.com
X-OrganizationHeadersPreserved: maileu5.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM12FT073:EE_|MN2PR07MB5822:EE_
X-MS-Office365-Filtering-Correlation-Id: 20cf906c-d901-418f-ed4b-08dab735ac99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SEcT2/gPVZ0cbuI7oaMdDksWWcPDQ4wwj6Lz63oWELRLP8eqXnmnQJE9fAVjvYKSqXhkLBN0R+4NPiC3TVsu6beVnHfJwFVt7JtLrRgrm0/1tsnPi/d+N2voDpKwGUUVvPna5qqSmCtnu2YV8fJXY0t4AJMoakcDTNf8GwJe2noQRMZGMkPmWCr5E2QWcEeWOXJXfzCQIM88T7lbIELyxifLmbwbfhkF5M+L8AGaoePwBASXY1v+7C7d4TTec4lftdhCioQk9PbBLS9cOPtg3JpWn/Qjzzt7AGJDUBkn64lDIOoV5Pola/I5uXuJe1xDzPhCSyb6K14I12o8WAGg9NrcwFEqNMLz7UtYhPPJd0RGJ7ts/EOxDU8MbbKdeigCrBBZO2ACh0VxJX9Pdwa/aqNdk68OF1P21DBJUGE8Ztgh676e+it3kCkGQFkl9VcpqlbSP5fLki4jPeNZigQILV8D1TsBZXJwy+VSD5mix5sYLLwJN2LVugQT6P+YDbrh1DX6CJEUnvw+l/YDDWiL1cw1F9csVf81kvjU/nqpjSp5x3vUrgVkAWRBu+eaS9aN0OZC7oDo6aywkP71i3PuCIwE7Biy/hoV2Dg0AroPzrFC+BS2s7u0xZHGKmZOcNoLtTntlQ6LNMJJ5cI3jqwYs1ybzhT9lAeB2tNtdD3mhcJSxF0jodrbE2qBMe7H+DDsN9GXK79ZioeNz3btQw7X4GaQLnG0JYtQ2b8xHtF45zLK+1k9P4gjB6S1K5n3HcUf9wPAQoWLatjVshh4DugIkw==
X-Forefront-Antispam-Report: CIP:158.140.1.148;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx2.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(36092001)(451199015)(40470700004)(46966006)(36840700001)(82740400003)(40460700003)(86362001)(7636003)(356005)(36756003)(316002)(54906003)(6916009)(42186006)(4326008)(70586007)(8676002)(70206006)(41300700001)(83380400001)(426003)(8936002)(5660300002)(478600001)(47076005)(2906002)(40480700001)(36860700001)(1076003)(186003)(6666004)(2616005)(336012)(26005)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 09:37:18.2171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20cf906c-d901-418f-ed4b-08dab735ac99
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.148];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT073.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB5822
X-Proofpoint-ORIG-GUID: Z0ZBkRAp_AJOEs8BQfXHC4IUz5JnLv3s
X-Proofpoint-GUID: Z0ZBkRAp_AJOEs8BQfXHC4IUz5JnLv3s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1015
 adultscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=470 mlxscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210260053
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During handling Clear Halt Endpoint Feature request driver invokes
Reset Endpoint command. Because this command has some issue with
transition endpoint from Running to Idle state the driver must
stop the endpoint by using Stop Endpoint command.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
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

