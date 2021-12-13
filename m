Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6065D472C2F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 13:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbhLMMU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 07:20:59 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:18888 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230050AbhLMMU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 07:20:56 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BDAhM0F009619;
        Mon, 13 Dec 2021 04:20:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=fJo3EHWuNJ5FQ7K8WTwxINXkXvtkUh3n9u6j52+Tb2g=;
 b=Ff2YYWjqdNmEB2WjiK7rBhuIvD3N6M5kjRAzLzEzDmTyQ8Nwt2/ucG9gIKfbC43+65Kk
 PEQ20jHa1CyabxycqetEdsL8BxZsxZd2P4fYKp9zKLQpM97wk0gFTftue6wbhewgS5Rs
 sGe7LQUCZDOEXPdW+g4xNCX9DDejGJHuRVMgdSkGWCT5C+YQQAPW0VmTRnB9QUW0gfsc
 aiQQdnOnWumTD7ovRyvilYrf/BAGvEmgtzU/mWFXkMlfRfIiGdjoQL8KyUW3C3wH/e3q
 xqvDynK9JDMRAwzWT9dBnCs6HddTy7w92SXUQMk8/spF1SwgpksSRY2P/NffF/hXjqS7 MA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3cwc9ruupu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Dec 2021 04:20:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddQf3nuEtqm2e8GbxoY/bgZxe5O6Rhj0L1o3Dpl7hcqJVhfb5PHcXPtsaUBjTc1F5fJB5q9wFen1h+jUvQfa+rl+75k9g6ZIRRxiMnSbFGzL8hcqb/S/LK7hAXSYbslfKU77wtmaVhcSn+Rs9loT0oxTCXN2cgf7bubZAX/Z47I/Mylofqj1QVt2QGD6+GLS7O2aP6iOF+epps0XmLlb8CG90Q7oP+Nv6lJciHJ4k6MWCIsCGHqy8rFpkUXJS0ojBpKip/B8FtvB2UX+AOsTJNgjXbwawo9jdHW5Y3YH8Esm/hs20mOD1wOwEX4CXukytTUJqGz8VyzPXcSWbigJpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJo3EHWuNJ5FQ7K8WTwxINXkXvtkUh3n9u6j52+Tb2g=;
 b=XNHCJ8pQJtYLW6Qform1rDjHKJl3FwR8PKLvjNy0IjPMM50xKgV2D8e2lJY9CDhnVEVuV6cYwentW9RUmtKxZJaEw0Ava91vty/2FbbvUt5s7icXDgUQfXnRvsbp80NE40+L8+NrUkViKI6NoDeR79DuLijb1jml1sxQupk5xNd1q7lxKWLD/slNvIDKKdtuVNuGlgiPGgmpyndw3qyKTmqgCsx4Y4xqmpD74di6IlwaUKdlhYi3kXsfVkt+094sPHDzIybaTMocvOEK+EoJv0SLc7bZhpkB7P3tqtsUCxDqXQHBh2cSXWTs6tu7gL9YXfVizVK4N8d2X1EnOgK3gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJo3EHWuNJ5FQ7K8WTwxINXkXvtkUh3n9u6j52+Tb2g=;
 b=e8oIAktOZaWxrJlfv9SYF3sdeiLI2vaIox1hHFG70lu/zPo/ljJsBxrq+mezMEIjYkzqW4VRLHTFtPOEBj+DHZlB82A4VIvN/k3kYMKKmpxbC1zf+AEg9yoDUeVXC1ZZe3IPlRC1xAL1g9KnCQ2yoGSNHjZC1almJ1FcAtHiwUE=
Received: from DM5PR19CA0060.namprd19.prod.outlook.com (2603:10b6:3:116::22)
 by BL0PR07MB4035.namprd07.prod.outlook.com (2603:10b6:207:49::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Mon, 13 Dec
 2021 12:20:39 +0000
Received: from DM6NAM12FT056.eop-nam12.prod.protection.outlook.com
 (2603:10b6:3:116:cafe::79) by DM5PR19CA0060.outlook.office365.com
 (2603:10b6:3:116::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13 via Frontend
 Transport; Mon, 13 Dec 2021 12:20:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 DM6NAM12FT056.mail.protection.outlook.com (10.13.179.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.7 via Frontend Transport; Mon, 13 Dec 2021 12:20:38 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 1BDCKbEA201702
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Mon, 13 Dec 2021 04:20:39 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 13 Dec 2021 13:20:25 +0100
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 13 Dec 2021 13:20:25 +0100
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 13 Dec 2021 13:20:25 +0100
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 1BDCKOQ1048902;
        Mon, 13 Dec 2021 13:20:24 +0100
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 1BDCKNp5048753;
        Mon, 13 Dec 2021 13:20:23 +0100
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pawell@cadence.com>,
        <jianhe@ambarella.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fix lack of spin_lock_irqsave/spin_lock_restore
Date:   Mon, 13 Dec 2021 13:20:01 +0100
Message-ID: <20211213122001.47370-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21b78f3c-1527-4337-2820-08d9be32f8fc
X-MS-TrafficTypeDiagnostic: BL0PR07MB4035:EE_
X-Microsoft-Antispam-PRVS: <BL0PR07MB4035ADD8235D790714166D8BDD749@BL0PR07MB4035.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lR+z0hRnybTPqxYMeEQGloHvTSyexUiNXjVTUWx9rYPvBQl0rwhhL5rDdcbRMVKVsHUwSWfHbJMN6itJZnJ6r7B9o4urC+v9DgbpLrr6awOKHlWtWZ4Z/cycy5WJg9BG4ZhCIau2KTxQ4PUd+Zy5a024PMtsiQ6grsHDy+rNjp8N2sOq4/nYbp5QqP5baRgA6sffY8YhfT0gThPYK44zQL4yR/aOAJdMYLsUkidlc6uGiwBhiNBfNE2p903KgEW7S37YgTxpkUnMKJfdvt7vvVf9y6n/mNTy9J2Dol3MQMTQlhZYLcEG2biqMu0EPlT+Y2zVi7wiP+aKXkMvCbaIog8mp9S5SPvGj/+eTqDCbqBkw5kqIQ1Gj3d3mOXXgosr1KlelOh9sOnt73rL1tWDlZdYfkP9sVxCvcIArRFh5OOJN8exkayAWKRcK4gPlE9b2QfGkBzz3U1A5yCbE8fdAZh2GQDxLcYU1Y3VpAH/6QMrCWiXYGY4SKZvq2rxqf2F3ptjg8fxaHERm7aGArbgvwsYdCSrjn21ToihMzUOm3MidfgXG8rk+G2iYYX7WT4R4l2svRYyputnTUPmk8h9oL3VlxKebk+dTEf8X2HnyOYiG/XYQqcAcFYq01bnVX6g0+E4Xlsdur/CWf4O6jRRVO2u3MbbZHmMdiKwvogqUmDAgpQSeTGKKIygkkLGLo0nyJzdTDHFwlWfSFBMWK8DmrezVUmncfG991g0eDRkOrnsjwjS7xqE2XLsqMl8VF0mx6wVQ4JOv9jtYYaOxQD8jbkgeoiiNBHy147cTZaFsQ9cUyvC10prSt04n+AmPv8LlkOWYcWBUI4/vyudTguqtg==
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(36092001)(46966006)(36840700001)(40470700001)(83380400001)(70206006)(426003)(54906003)(81166007)(356005)(336012)(508600001)(6916009)(86362001)(42186006)(1076003)(47076005)(8676002)(5660300002)(186003)(2906002)(70586007)(40460700001)(26005)(36860700001)(4326008)(6666004)(82310400004)(316002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 12:20:38.3615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b78f3c-1527-4337-2820-08d9be32f8fc
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT056.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR07MB4035
X-Proofpoint-ORIG-GUID: uD-fV9w9dZ6fvnqaCbFGkhP0TntAgTTm
X-Proofpoint-GUID: uD-fV9w9dZ6fvnqaCbFGkhP0TntAgTTm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_04,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 spamscore=0
 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=532 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112130079
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

Patch puts content of cdnsp_gadget_pullup function inside
spin_lock_irqsave and spin_lock_restore section.
This construction is required here to keep the data consistency,
otherwise some data can be changed e.g. from interrupt context.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Reported-by: Ken (Jian) He <jianhe@ambarella.com>
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-gadget.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index f6d231760a6a..d0c040556984 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1544,8 +1544,10 @@ static int cdnsp_gadget_pullup(struct usb_gadget *gadget, int is_on)
 {
 	struct cdnsp_device *pdev = gadget_to_cdnsp(gadget);
 	struct cdns *cdns = dev_get_drvdata(pdev->dev);
+	unsigned long flags;
 
 	trace_cdnsp_pullup(is_on);
+	spin_lock_irqsave(&pdev->lock, flags);
 
 	if (!is_on) {
 		cdnsp_reset_device(pdev);
@@ -1553,6 +1555,9 @@ static int cdnsp_gadget_pullup(struct usb_gadget *gadget, int is_on)
 	} else {
 		cdns_set_vbus(cdns);
 	}
+
+	spin_unlock_irqrestore(&pdev->lock, flags);
+
 	return 0;
 }
 
-- 
2.25.1

