Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C02F46B6E9
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhLGJXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:23:07 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:46158 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229457AbhLGJXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 04:23:07 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B77pu4p018379;
        Tue, 7 Dec 2021 01:19:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=KADncB2crNlKpnY7Z/LpwbPgW4K6qyrWUEpbguS1eh0=;
 b=oseKQTQyzwbunR7JkVsdFWvEINUHHP1bcdldTZnJycy0ImF3o7gGtBK+lDa0/aMSQB32
 Q33CmeUTMMNJGIhC7rwCsyFMycC8Jmyz6z6eQr91e/QjfCJ1efHC0VJvVbVmLcxk5keA
 rGkguLXjA3qaZgj+Kpv9P8MTUAGPcZ+oUo0QnmU6tQHe2muhmDW2G9iGW+BBcQLCNhEe
 RKf8jUT2bGZZE+wpMPVN8IqIcqSTSIzNBjRI2DkR7o/k9RuRrfQtHNPmU+j2e9b6yGe4
 81eDStBspLuJPyxKmpp8g09H2VDqyB3xkjXB0NDNEvOWT+bUeNDU9HJtwbadahPH+ADa pQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3csbe4vy7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 01:19:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+E2bMbLtQSwVsjKeTe68HHuYPXcBTho/hUfgEQLziXkgm3mV2YOYBO58pkg6AjMFKkFxiA2D6vYX8CwGDkvXhHaO/JoywAQ+1vZMRRD6rIse58SPvsnRyyzscV3nG/22zLgmCS+iuH5eg1HS87H+mA+GpzSA4dbMgAnAoiysLOsHG9vq2MyF0L0SqzoZvIKCAJqINSHY6A+3lhQ1KuszzSjEMbr2O1yAvqH/7m8hNHoqylGOvpuFVUO7p419Z4j9bHRwPczkRNmzjPgypy1GdDRQYD8s3VSZJfmiyjfsNCODOwlSywgaTCXk4p6hs9B33OgBjUYQloLoy2uflDYzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KADncB2crNlKpnY7Z/LpwbPgW4K6qyrWUEpbguS1eh0=;
 b=WbruX+m8bQYYzOQ2AkfIacWAOchnBav1ffWwY0Y4kY+k0d4XEG4dzddLeQnjAQgHb1t2i2VWE4dupWCLvGrUksgbA2uHEvMz9hrP63yX5czuH82aFJjjvLOK4chhsYldCTwnE9b0iEhjbe+vEuJdVPekAn6QW7N1AuMNrT+l5/qixfYxgdL+6gbCI9GB4AKEtwVp9zGrknmlYu4yMe1M10OPGMtpaziKDbFGF3YgyEKNOXpMMbuDkibRMeaBronrRux81W4Ns49kBabI5MU1IaMD8kZrmza04e0hjxtyxd1rMSvoZ0kriJSC2qPvB1jvAwMPAcRBdGsXCTqySnCrGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KADncB2crNlKpnY7Z/LpwbPgW4K6qyrWUEpbguS1eh0=;
 b=BiOpE7ApHpdAOAfPiK0YJhdpUuBc4xRFJoeLYlzyA9lOc79jU3cEGstCLW5E6IvqksHxq19/21izfx39fNRvPnZxOqgt9eh79sOImXggVld4iqLkiRxXG21JzBmt9xyETLPkVye5EuD6Ljs28UCI9re4eAa6hqwxkkZ2sFo67IU=
Received: from DM5PR04CA0068.namprd04.prod.outlook.com (2603:10b6:3:ef::30) by
 CY4PR07MB2790.namprd07.prod.outlook.com (2603:10b6:903:23::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Tue, 7 Dec 2021 09:19:22 +0000
Received: from DM6NAM12FT006.eop-nam12.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::59) by DM5PR04CA0068.outlook.office365.com
 (2603:10b6:3:ef::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Tue, 7 Dec 2021 09:19:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com;
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 DM6NAM12FT006.mail.protection.outlook.com (10.13.178.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.4 via Frontend Transport; Tue, 7 Dec 2021 09:19:22 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 1B79JIXn000388
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 01:19:19 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 7 Dec 2021 10:19:05 +0100
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 7 Dec 2021 10:19:05 +0100
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 7 Dec 2021 10:19:05 +0100
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 1B79J58A040322;
        Tue, 7 Dec 2021 10:19:05 +0100
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 1B79J43d040321;
        Tue, 7 Dec 2021 10:19:04 +0100
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pawell@cadence.com>,
        <jianhe@ambarella.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fix incorrect status for control request
Date:   Tue, 7 Dec 2021 10:18:38 +0100
Message-ID: <20211207091838.39572-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 376a99b3-7614-441e-31f6-08d9b962a800
X-MS-TrafficTypeDiagnostic: CY4PR07MB2790:EE_
X-Microsoft-Antispam-PRVS: <CY4PR07MB27904DDFCADE51D6C9513125DD6E9@CY4PR07MB2790.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05V0ZucISkT/438aG4hnRJa3mvntIJZ/d9/2liOkL4SGB+S+NbfmRnguZ9s8PAw8vgrFEWQldrs1lBPDAkTDdatddoBrbMPTtBBi820PDROLFL41KLxrdWjXi8kffNCA1GPJlFkhjFdRYOnKa8q7IHjnbNR4BSwh5FQzTvdPi95nuOU/KyHzqX6pKvF5sHMcjN8gpl81tt4BGT8LlKIBXp2EZ/hZTnh8d4CFr96btKb5EPfbCUB+v8NxUol9cVPXNVGjnYWM2Dp0BmWy3p08lzLJMwg8bAwH8bVU2XGgh/E9eor9jjXzqSQVRPryhVIcKt31olWpHsgdJ86y/sGDb8EguJO1AM02YLxwC8dBlJCiOpk5sU7MLIhrWwkkTB/I2XlSRtMlUi2jPx9RxxzXyBHXV70/LOsINyxnSRj3VU8ehYuhn/pn/ixsGsVQUeFCd3Vpk/vTm/yiPFzUzmkVP0tQckFW4466d4z0gcMzyTCfAvhgreftfKyFDgaFVgs8D/O3VW05XoPzqOZwLgnMbYWxCdWQnii+MvUZxmucARp0aUVuI5FUgX0SqjRgHsZrk2MD2UQErDgDX5v7cyACD8vF86ixQ7gjC+zy17EQHeedkQ2Bj+vEpSnf2J2yKWTsO8JsVxQgt/BRVO68tdV+m/DkPWTOb42y4p/P8tnhydPqRFveFLF/+BF3CJjRIoe2cs3554qQv7sAuZH+TDNL4ldR2VKNR7HHHyQ3dhGyNAGNZBSdzYVcYfDHQce2Fmv2WtQ+mr8e4OjUh665+3sBBisoz6LvG91cZXcmOVPYlRs=
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(4636009)(36092001)(46966006)(36840700001)(40470700001)(426003)(86362001)(8676002)(54906003)(70206006)(47076005)(6666004)(186003)(70586007)(6916009)(4326008)(336012)(8936002)(36860700001)(356005)(83380400001)(40460700001)(4744005)(2906002)(508600001)(26005)(42186006)(316002)(5660300002)(7636003)(82310400004)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 09:19:22.5217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 376a99b3-7614-441e-31f6-08d9b962a800
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT006.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR07MB2790
X-Proofpoint-ORIG-GUID: tCo6FhdJM-FTy5Y7TWYeOAoAvRgWFqm1
X-Proofpoint-GUID: tCo6FhdJM-FTy5Y7TWYeOAoAvRgWFqm1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=505 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112070055
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

Patch fixes incorrect status for control request.
Without this fix all usb_request objects were returned to upper drivers
with usb_reqest->status field set to -EINPROGRESS.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Reported-by: Ken (Jian) He <jianhe@ambarella.com>
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-ring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 1b1438457fb0..e8f5ecbb5c75 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1029,6 +1029,8 @@ static void cdnsp_process_ctrl_td(struct cdnsp_device *pdev,
 		return;
 	}
 
+	*status = 0;
+
 	cdnsp_finish_td(pdev, td, event, pep, status);
 }
 
-- 
2.25.1

