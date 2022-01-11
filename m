Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48C048AA26
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 10:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349157AbiAKJJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 04:09:17 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:58770 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1349146AbiAKJJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 04:09:16 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20B7LpFm017740;
        Tue, 11 Jan 2022 01:09:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=OZ8BITtczWa1VeMH3Oxg7IrXdomuBywn0OtSlzXpYyI=;
 b=UrlqZYEPkrWNG+7QpNWABR8GL8FwsBVQNBq+8/gsI1idfLJIQkK1BLKSizYs3hSLhyQk
 6XUF2kUtoJBuKBDfGPGQR/8iFbhXCGgfp7IB4bW+i0swWHMubu9yylf1y8halHFfuecZ
 J0LEXcv9YpRn/xAecaCFVqxGsRKbc2JexK+kmA9vvu/nW41AMEP9LVtOiVVFNVMlMZFC
 19s1Eiwoce5SBSSIQ9oFpttfyT4UFOx9oGrgg3C0uAPeEtLU/uQA7CRRdRZFUcsRqXUo
 M9IMzRobADEvip8LL3QBd5OqLVjdLSjgbgfh+pcg3VEAPgurc/dvWrnmSK1fPhTuIn4J oA== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3dgkxpkebq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 01:09:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIRC5JqlWQF7poIk555KlxRN/pS47Jlqo474FHlC9MeP6qzhaD5o4r3sMj0RPurQlsNyiN6NVZV0XX/oDQskxtF8Cg3qlL1hGexnjAZmyewr5sU77c8ZBZqPMvTHaX/TOzpW0JQvTcngdve+DtPfYL99UoQT/DSIMz/spLksG476Vp8QN2nu9dtSeBuGckqkPKWqddqe4BziIgw67/9/hH6jAh7Iq6G/Mz5qgJowE7DyO1Bjz+aWBtQnvfJIiCOF7Q8tI/XXtkz+2ip/Ak43YXJh1VraNeDzByOdQyUXV7d5dh5iyDbnGl4/6p6lAMXqZ3T9IeZWfmGk5thOpLhNpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZ8BITtczWa1VeMH3Oxg7IrXdomuBywn0OtSlzXpYyI=;
 b=gZHTqM+G7v0PKdA3U0s0H5bmvS6zYVRZYza6JmIuU7ZLCmjseBHhkZYZnnztqKzdArtIPXxDb5+SKbpUrijke3eugvapo3Mm6mMaYGFLebLfJYC9rTu4FhpQW2a7prTmNVyHpUKjfsPq5tHeIUEk3v23QQs5qYJSJxuHEBT9TvUl+Pnw6zdH2S88E/VQ+lnIGwBmkBrUxw8Pfh85iPyQ3OWXgwRVmCIZZq/XMzEAgsnODHtfr4v9JmIJpSDWzblChxGiA9xcOf21lv5gV78yXEZzj8KELy9fm9wV0p/LL9xrnAfuBxdoZ1GX7AHX8xmmlTQNl9AviOHvKVUxs9bzQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=nxp.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZ8BITtczWa1VeMH3Oxg7IrXdomuBywn0OtSlzXpYyI=;
 b=lQNl4nvgOnP5OP+BK0Td8uh0TsyHVVPrDkQeNAzXqYkH6udAzSotuw0RvIxEFEBSF8lQTT1V77rs0nyszdkSgldBhcRY841pK4y3/7gUyFrseLIZh73OFAlnjSIDV6yzwryzlT/WCcSiAYCS0zDg7sF5GWa8sV0WXelY5sLu0cc=
Received: from MWHPR01CA0045.prod.exchangelabs.com (2603:10b6:300:101::31) by
 MWHPR07MB3054.namprd07.prod.outlook.com (2603:10b6:300:e8::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.11; Tue, 11 Jan 2022 09:08:45 +0000
Received: from MW2NAM12FT036.eop-nam12.prod.protection.outlook.com
 (2603:10b6:300:101:cafe::8f) by MWHPR01CA0045.outlook.office365.com
 (2603:10b6:300:101::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9 via Frontend
 Transport; Tue, 11 Jan 2022 09:08:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com;
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 MW2NAM12FT036.mail.protection.outlook.com (10.13.180.174) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.5 via Frontend Transport; Tue, 11 Jan 2022 09:08:45 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 20B98jrb029284
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 01:08:46 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 11 Jan 2022 10:08:44 +0100
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 11 Jan 2022 10:08:32 +0100
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 11 Jan 2022 10:08:31 +0100
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 20B98Uqt011879;
        Tue, 11 Jan 2022 10:08:30 +0100
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 20B98Ulo011878;
        Tue, 11 Jan 2022 10:08:30 +0100
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <a-govindraju@ti.com>, <frank.li@nxp.com>, <rogerq@kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pawell@cadence.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fix segmentation fault in cdns_lost_power function
Date:   Tue, 11 Jan 2022 10:07:37 +0100
Message-ID: <20220111090737.10345-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3670be1a-0b25-4dbf-fa90-08d9d4e1f89e
X-MS-TrafficTypeDiagnostic: MWHPR07MB3054:EE_
X-Microsoft-Antispam-PRVS: <MWHPR07MB305438CDC8025D82057550E1DD519@MWHPR07MB3054.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 85KBoSU+kTYqEE7iTffAZshZ9qm5f2Tnen94d5YN722h0bTYLNUpjCrmlI69eke8WbD/u70wJr6KCdfCBCPVgKR97BDciSfbkcACrznInt3Hjd+OV85NGrMUPvY7rVv2KHttdjre4L2KJbV+3vaPJFZZJlz3ZY56h2MkNm3iBpcMU2CCs6CnF0wYt5Vkfjzy7MJQj734D+owzsHQHJetMSGpTNBBvV/h0utSWlw44uHcbB0ZamdgDRP52FQJRj+COpQTnS+6Vf4UOX0RWzQK/waG/3HrNBZtNYRXZGNHRylt2yRsj1LR63zMCqPbtTD6WRO9cIti1LwDxTtXsoNDT43IkkuTQy2Ghqkpjk4TLzdhpA6OFIdl1YDj4Fs9YRgNOMPXGzxs+5U7KkYPmfmkAnUZO8+EnsAIB0MUe0CYOfdpZwxlMxB809kCW/hzDEgRblMPxFkXrk0zFwYCqtDxSfbMahg/cLRCxcmcYa2rsYaIs+LDTZGF81rJ4WliEhvzYfoUYSarBX1iz8MaSMDVzfyDQTlD7SexxFjuA6ijZCG72lujdAd6HY8J3OIGq3z/LOcGd1TS/mHFe/zQ/6eA4FUxqakW3lIFjCdFSYiwIadil6bFFGr0n8Lzulc9E24YM67wN49oF1rfdCMqQ+byCethEXBjRlt8cTZE8fBuZXsvne+ol3WXgsHANMnfMNC81MQeDYF+bYY7pinrv7AJvGEmBx0of+uByOtQxYYLw3UoHMhYU+j5dN3x3u5z0+cltscj5knZbliDxG/aDzex6LnSqgMoNtl6Te2WJAuK5x8=
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(4636009)(36092001)(46966006)(36840700001)(40470700002)(7636003)(4326008)(70206006)(70586007)(86362001)(2906002)(356005)(6916009)(40460700001)(426003)(82310400004)(508600001)(83380400001)(26005)(42186006)(54906003)(316002)(186003)(1076003)(336012)(5660300002)(47076005)(36860700001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 09:08:45.3065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3670be1a-0b25-4dbf-fa90-08d9d4e1f89e
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT036.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR07MB3054
X-Proofpoint-GUID: c6s7We3MKg7WDndgWGhVXBDPg0Zc_dFK
X-Proofpoint-ORIG-GUID: c6s7We3MKg7WDndgWGhVXBDPg0Zc_dFK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_03,2022-01-10_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 mlxlogscore=335 impostorscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110053
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

CDNSP driver read not initialized cdns->otg_v0_regs
which lead to segmentation fault. Patch fixes this issue.

Fixes: 2cf2581cd229 ("usb: cdns3: add power lost support for system resume")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/drd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/drd.c b/drivers/usb/cdns3/drd.c
index 55c73b1d8704..d00ff98dffab 100644
--- a/drivers/usb/cdns3/drd.c
+++ b/drivers/usb/cdns3/drd.c
@@ -483,11 +483,11 @@ int cdns_drd_exit(struct cdns *cdns)
 /* Indicate the cdns3 core was power lost before */
 bool cdns_power_is_lost(struct cdns *cdns)
 {
-	if (cdns->version == CDNS3_CONTROLLER_V1) {
-		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
+	if (cdns->version == CDNS3_CONTROLLER_V0) {
+		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
 			return true;
 	} else {
-		if (!(readl(&cdns->otg_v0_regs->simulate) & BIT(0)))
+		if (!(readl(&cdns->otg_v1_regs->simulate) & BIT(0)))
 			return true;
 	}
 	return false;
-- 
2.25.1

