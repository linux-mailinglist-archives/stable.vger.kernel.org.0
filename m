Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7963547203D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 06:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhLMFHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 00:07:10 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:60088 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230008AbhLMFHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 00:07:10 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BD1w99m010062;
        Sun, 12 Dec 2021 21:06:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=XBMCMJiyiDGAeH7UqMSqHm2CRiL24MkWfGS6SwkQaQo=;
 b=HZH95OI1r52Ecc9SskRH8y0ReczQWJnlCW9ETylKCWqZ/snqk0yUu8SkVY+ZbnGFZh/M
 AjEPqLrYyPw8SY4XKrII79z79Pfq3w0fIXBNW8Qn5kspOt3xd3uxVgOwZ8czY++oHEHd
 X0YTfTf2bgRoGLyHplTKWbVy72SdSA4jiWjM3z9JMqWnwHjROAzmwENQjU4r9NvbFwUO
 1WtesD4q0hu00/vuhyB2zTOIUKBF3i+eG0z7t60B8h/U7Bax4jW2HvcsYQjEIstILnzk
 u48GV5RfahF+cxWfcIbsU7KVp/tjYW404WKZ5UhoXXz7WTseQIsmb6irbJfEvUNyGp7+ 9g== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3cwc3ujhdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Dec 2021 21:06:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkfyzA7mRYYFsrsHnTnwNNqEmBwwzTK3ygJudwwnF7+AipEEAesf6bPAa0W7gnBpN3L6+VQdYAgZh5JOr3DWAiOXFZXRfOW+rlHZhVWf2KKLKYIAuw7qY+rna5Pm3VuQ4wZ9v88f19854+dSO5ItjhwuCuYDhlF0mzkO+XKK3z0m+1OnlkI5961vEYgofh5oYfIpSfmvaf9yQlh0pHB2gPvYr8iqWHqARIhK/NtqdMF6hvpUVJCfpPTmhZd6h3L3E5DkrKABGIOCIcfqJpoYuKsspJudlRj6YJ69HXDi5QnMGVkJT2uBMIvA7PO0hBG7Y+RuBqsqxbKRJ0H24L3oZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBMCMJiyiDGAeH7UqMSqHm2CRiL24MkWfGS6SwkQaQo=;
 b=axfDMQKb0exmeNcF4s95RXZQSDuvbo+NtvQkfEKu1ed3TYEOfao4KEqtO+f3Yu2DPTPCCVp7Nx6GCqas8i4haN/YQGoUYxMx3k6XGXjiiUPjExp5Sry7dN9zDItKq7zmDQU/2npj1Yi6GFqm/vry2CwQsSGF10E2A9UgOeYa1byaFGPY8urGTCNqQe+fasDZ+VAyB2vfd8mGfvVresWvsVEqi0WaXShVFWISbqedMfu+AHZxE38eUHAXwzE8gHlaSeLm0Yabb0SM/S2aTVq4m9TBNqr+MOquH26Z14scaj+SYdlmvarel8Tg17JV4emcjmajJypLKkxb2KD32OCScQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=cadence.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=cadence.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBMCMJiyiDGAeH7UqMSqHm2CRiL24MkWfGS6SwkQaQo=;
 b=dqa32pL4GLyWIJbOveclddmyxJICr26D5jhCWVFGK8FJDkWSVFfUxQqZk5jZ5OkiQtABMLnbt6uU9sWdbnltZyg0H7uqVxcX6IRvNqludCvxwUSo1oh24qrhoTvJDlnRNGDfQma249eabVnGsElhI8AWcefZ7+oGdrlUB4YElxI=
Received: from MWHPR04CA0026.namprd04.prod.outlook.com (2603:10b6:300:ee::12)
 by BYAPR07MB6373.namprd07.prod.outlook.com (2603:10b6:a03:126::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 13 Dec
 2021 05:06:56 +0000
Received: from MW2NAM12FT056.eop-nam12.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::1b) by MWHPR04CA0026.outlook.office365.com
 (2603:10b6:300:ee::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16 via Frontend
 Transport; Mon, 13 Dec 2021 05:06:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 MW2NAM12FT056.mail.protection.outlook.com (10.13.181.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.7 via Frontend Transport; Mon, 13 Dec 2021 05:06:54 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 1BD56sQ2177356
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Sun, 12 Dec 2021 21:06:55 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 13 Dec 2021 06:06:23 +0100
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 13 Dec 2021 06:06:23 +0100
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 1BD56NVL023033;
        Mon, 13 Dec 2021 06:06:23 +0100
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 1BD56Met023032;
        Mon, 13 Dec 2021 06:06:22 +0100
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pawell@cadence.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fix issue in cdnsp_log_ep trace event
Date:   Mon, 13 Dec 2021 06:06:09 +0100
Message-ID: <20211213050609.22640-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4c9afce-5906-400b-50c0-08d9bdf661c4
X-MS-TrafficTypeDiagnostic: BYAPR07MB6373:EE_
X-Microsoft-Antispam-PRVS: <BYAPR07MB63732D6D2D5F58348B9907ABDD749@BYAPR07MB6373.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:153;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4dH/Y5EhN35qIE3HApScz/Lh/m2kEd3nc90VY+8jdDNQaCGVEhUi0HYKmX1iKqoN0427f51TD4t6/vi7Nuwb9/dB49jBK3fa1Dm3Rx0DoDCzTldQqj1xbVHkByHRTHFqwNkeIvAujmRz/pzjAaIfoc+uCDQK4uRULwdQhVd0Mp1EqJjvRH5B0SUaU/MkIWDD7mLq/U3znRFS50H7S/ZVd13u7Kwfwx/LJNVrtXh04RF//pyD0JZXR0lIkc4ofi08BA3PizIDhyvwBiVdq0Y0U61pUNea/E3bhbUs6ndUjh5BgN3js31WxOjxqAue5LL6hjJy9HnQVpl0otuJWRRhgCvtIthhePO1Y9HnvdB/KD6C3QIin44E/HU2sN8tvMlxONa+s8KoP2ofLT2o4U0f7PbqDPrcQ92OFgDholIBqe1sIUWOO7rpXvgNOQz+vfI4PVG1AIVNOEJIOtjJfONGFWboJ9z/nrEW1uK3Tujynt69DT7OB6AEBO0ogItepcLjBpKsDi3nbSX362FLmSW3Bnw2KUx/WvDM5cR/5hOJmdXRvbEF9ytbJ4Sxxp8MXIO4ngLOUAXpNcEtw4Y4LFkEHYoizJeoqZ/Qs+HHh21drvXpwfy++WZPGg7Iw979aRWX6yPR/H5Truply9Xs3QkCn7YJ8v7hYDnjs1/WpEAedZxKBcenjyL/csp17vgXkvQEMfSYAumGGD7dyhMwokIfWo1m0ludH5pFKfP0KDlmKbb7LsXf4JswOExBtZzXq28xG5IPa/+rv/YPlHS2SSZCLt2S0s3PCpruzIRb9i4XHQ62UZn4gPQ6MWTdAuHYj46SIzZCfSfjGaucUl4YJr1DuA==
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(36092001)(46966006)(36840700001)(40470700001)(70206006)(26005)(426003)(6916009)(186003)(4326008)(336012)(40460700001)(508600001)(83380400001)(8676002)(81166007)(1076003)(70586007)(5660300002)(8936002)(86362001)(54906003)(316002)(36860700001)(47076005)(2906002)(6666004)(42186006)(356005)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 05:06:54.9027
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c9afce-5906-400b-50c0-08d9bdf661c4
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT056.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6373
X-Proofpoint-GUID: F19Tr9GJU572b3EVNmeJOzeDH4mZJnJb
X-Proofpoint-ORIG-GUID: F19Tr9GJU572b3EVNmeJOzeDH4mZJnJb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_01,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=479 priorityscore=1501
 mlxscore=0 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112130032
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

Patch fixes incorrect order of __entry->stream_id and __entry->state
parameters in TP_printk macro.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-trace.h b/drivers/usb/cdns3/cdnsp-trace.h
index 5aa88ca012de..13091df9934c 100644
--- a/drivers/usb/cdns3/cdnsp-trace.h
+++ b/drivers/usb/cdns3/cdnsp-trace.h
@@ -57,9 +57,9 @@ DECLARE_EVENT_CLASS(cdnsp_log_ep,
 		__entry->first_prime_det = pep->stream_info.first_prime_det;
 		__entry->drbls_count = pep->stream_info.drbls_count;
 	),
-	TP_printk("%s: SID: %08x ep state: %x stream: enabled: %d num  %d "
+	TP_printk("%s: SID: %08x, ep state: %x, stream: enabled: %d num %d "
 		  "tds %d, first prime: %d drbls %d",
-		  __get_str(name), __entry->state, __entry->stream_id,
+		  __get_str(name), __entry->stream_id, __entry->state,
 		  __entry->enabled, __entry->num_streams, __entry->td_count,
 		  __entry->first_prime_det, __entry->drbls_count)
 );
-- 
2.25.1

