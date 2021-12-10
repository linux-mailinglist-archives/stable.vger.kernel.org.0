Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5719746FFDA
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbhLJLdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:33:52 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:7282 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240465AbhLJLdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 06:33:51 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BA8NIXM020832;
        Fri, 10 Dec 2021 03:30:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=KcIW/yPCbyFVGh37qcAU1DnzpWkJnlW/qPQ4qNK9FaY=;
 b=fb6L83ttn+4n2ODw3awe+q9DTaIyqVckyrtmBG+SB8XF6PLNPct9kDgdo+fzNqWalcB6
 +Ydo1BkZGLZOugcnN/Biav+KYJrmhldjm1jnGNwjJa5sEpVdX0QRl8/ik3QzMbXL1Mf0
 WEfX5wmw5veUFK947l/iy5lYGkY/eWB9hECZoIgeTriRTOwiasKB567nU4/5Be1VfjpZ
 FwvIrgEGWNtdb2Cybj3fC1h5ft5h+GR6mdVhbBjMoyoPoXEYNeuisLvXg98fmbb+zhpO
 KbeFYlCNIVFDgy1WFKBQ+T8i2ShVOolD7IiGrUO244Jt70/UZk8k+imrKgA9CHhuJvSi Hw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3cv3bc0p80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 03:30:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1a4ya4LApgrfQHMW3MH77vicuZezsqVuS50xfpBb/NIW+NAIFh5M8LTLF1aiYtgMblZSEz6sojylu00mOZPFIKwRVAjrayiWg3zTsOVLFAIPSNFWlYK9/LAYtmHkPyAnczBzIkEeASQ+Pw+i7pnDH7m3ZfqvqaUGcDmbdiby42XEhsTtYiKfO9l6pgFdRGWX9rS5tPObsI29QpKAyDAat6MmDOa2zlDmc8Prv0eUK50Ad+ANjxZ8vFlo4kuq54wDmLC78gXhNhLVZXN0g/6bQ01vDWMkvZn0JGBdgBAXSNysgEr8npcj6tPtQmZ4+CICejSz/sRZGb1QXVsif7DXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcIW/yPCbyFVGh37qcAU1DnzpWkJnlW/qPQ4qNK9FaY=;
 b=eCNxel6O9Vs6aJ84dVnsXLcVGcv0NdqV6WOoCWMNLl05XRBcT3ejoF7M8U62OMPiVPh/zXLl+vE+AiQIDk2aRYSBE69dGIi9CDp0eK0Ha5nZE3disrlP6sPu1p1Oc+o9qQQcfKbC3Q9aDwa9ZwWCn8FjbEFFkr1dnb2FOO4kTg3MdIjRBq3vrmQ9ktz5DGhLZTyfS+4n6xv3tHf59H7V/xMnMzTMqzENJUK3x9yJU4QsfT2ziavoNFjM35smW9g5g69pyfAkmUA5h3/sLS0rz8vzYq9CENz8YULPVjf8QfjnViAXBd31HvdBncdHxQIenYRz3sl9USGWB5eI2R1oLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 158.140.1.147) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=cadence.com; dmarc=temperror action=none
 header.from=cadence.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcIW/yPCbyFVGh37qcAU1DnzpWkJnlW/qPQ4qNK9FaY=;
 b=eEsVdvZn+P2reEmi9FfsgYeGFceID6xC0e4I6vZFbJScRmo6KJEX5GOpejJCj1MStXPek9S8he3RQi5h2thrtdlOjsHCCWpolAvjOwCKdvUXBRL/uHxkxCp1zOLchUMmDajDZPn2/AtvgB+mrzRKALDemE4x2NNldHuFGlSw9DA=
Received: from DM5PR21CA0041.namprd21.prod.outlook.com (2603:10b6:3:ed::27) by
 SJ0PR07MB8392.namprd07.prod.outlook.com (2603:10b6:a03:359::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.25; Fri, 10 Dec 2021 11:30:07 +0000
Received: from DM6NAM12FT014.eop-nam12.prod.protection.outlook.com
 (2603:10b6:3:ed:cafe::dc) by DM5PR21CA0041.outlook.office365.com
 (2603:10b6:3:ed::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.7 via Frontend
 Transport; Fri, 10 Dec 2021 11:30:07 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 158.140.1.147) smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=cadence.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of cadence.com: DNS Timeout)
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 DM6NAM12FT014.mail.protection.outlook.com (10.13.178.128) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.7 via Frontend Transport; Fri, 10 Dec 2021 11:30:05 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 1BABU5UA008867
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 03:30:06 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 10 Dec 2021 12:30:04 +0100
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 10 Dec 2021 12:30:04 +0100
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 10 Dec 2021 12:29:58 +0100
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 1BABTw2H001039;
        Fri, 10 Dec 2021 12:29:58 +0100
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 1BABTvf5001038;
        Fri, 10 Dec 2021 12:29:57 +0100
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pawell@cadence.com>,
        <jianhe@ambarella.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fix incorrect calling of cdnsp_died function
Date:   Fri, 10 Dec 2021 12:29:45 +0100
Message-ID: <20211210112945.660-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0caf07e-3540-474c-6e62-08d9bbd06a37
X-MS-TrafficTypeDiagnostic: SJ0PR07MB8392:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR07MB8392322F0CDAB05B6AF21796DD719@SJ0PR07MB8392.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NjhrT+Craud9N63qUgTDVtuBpC5Y+XqmcjrLuykuQNQIniAWEbaSaswbZElYVOY5bxD2gP1Q/F62cJoAE7z2yF8SU5aXx1xXvT4ZZoilVXVSunvLt6XfWoXXkOtyOpdYzNkaY6VS2T8TMlfM/rSAR7zP4sut/Tk+7e/I3xoldNmMTdpKBJEICzSz2b8pRmnAAmokBakuI7C4Zp3wzUtSVB2oKn8KE97MImaeup2l0EiAEwatb1hBe8pU5cSeQi3KFIuaovCAnupaP48JJzprgJIQGmWNI9Fi3p3+c/6bO5gcVXWm5JGVujBzTBprlC5CmLHriLOZca+vp4D/vS8a1aeIue2KKhwQ+1z4UKIltrzeW32SP/HNuy8WB4k0umv2+HymYmxPAQeMOFNeHVu8xnouZFPfSIKwBGoT48s7aJEDhMgljYwPe0kl7J4odMP7k2dvDS7PQIZaqeAWat0q4BtrdLRpBxO+/HSgBXJcgHqsLF/4VJ4WrxpQAUQLZCxc+8ZxVt0OpkoUMkMyrTAZ89ZMQyLN5HwIlqV2cCkVbkqXnu3SL8ORNBejdktJhvDDO1O9I5RrKe6ZM/e+nepZdvhD1lNak3sMgJZceCs+/zc7GlfjZZmJsB0LE8VrRO2pGI3hbAUGxl96rEsl9Nlz/EiOV/zW/k/UG0JybceW+iLiV7vfPg5FGR9F5OCe2IYa2leV/l06miPA1yeOfRxU1MjuJS12U+lnRba+fVlFcmZ4/fWY/S1G5jc1/EOhC7ATwzaaHW7tw7mAj26jeirb0j32IQE+zcByM5rROWxNuQ8=
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(4636009)(36092001)(36840700001)(46966006)(40470700001)(5660300002)(508600001)(7636003)(63350400001)(86362001)(36860700001)(54906003)(426003)(6666004)(8676002)(336012)(186003)(2906002)(70206006)(4326008)(356005)(47076005)(8936002)(1076003)(63370400001)(6916009)(40460700001)(42186006)(83380400001)(82310400004)(316002)(70586007)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 11:30:05.8307
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0caf07e-3540-474c-6e62-08d9bbd06a37
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT014.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR07MB8392
X-Proofpoint-GUID: 9Ewz4Xdxr9TRRPpCzuu3ctqPbyYqmGUs
X-Proofpoint-ORIG-GUID: 9Ewz4Xdxr9TRRPpCzuu3ctqPbyYqmGUs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_03,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=63 mlxlogscore=-22
 impostorscore=0 mlxscore=63 suspectscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 phishscore=0 spamscore=63 lowpriorityscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100063
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

Patch restrict calling of cdnsp_died function during removing modules
or software disconnect.
This function was called because after transition controller to HALT
state the driver starts handling the deferred interrupt.
In this case such interrupt can be simple ignored.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-ring.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index e8f5ecbb5c75..e45c3d6e1536 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1525,7 +1525,14 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
 	spin_lock_irqsave(&pdev->lock, flags);
 
 	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
-		cdnsp_died(pdev);
+		/*
+		 * While removing or stopping driver there may still be deferred
+		 * not handled interrupt which should not be treated as error.
+		 * Driver should simply ignore it.
+		 */
+		if (pdev->gadget_driver)
+			cdnsp_died(pdev);
+
 		spin_unlock_irqrestore(&pdev->lock, flags);
 		return IRQ_HANDLED;
 	}
-- 
2.25.1

