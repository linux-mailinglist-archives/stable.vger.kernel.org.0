Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7223B1437
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 08:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFWG4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 02:56:52 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:15648 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229660AbhFWG4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 02:56:51 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N6jW8n014331
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 23:54:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=b1wph9qbVnYFz+/0mORGZKgtDEEwdrk+PbkgVpr0JBE=;
 b=dzuWJMNFmMlcZxcQy/rRvtlBTDf7XRKERiORXo6nISbmo1S8yBZuXphX7xEfttUBX7ks
 zarN/BYTRyM5vFCpeYWKPu4VsjuFmQnTIk2oi2EY56Btik+2hUPG7K6nQRe2PkUXKYKJ
 ZaFiEzZqYYMsDq5c+sdCW96m+rWAWf8gPO1t/3fuWFICO3S9uVV+/kfpBAK4IzC9dOmB
 6Q8zIZOrjm6DH4O+SUXv97Fnl0fVIW07OFvI7kucQU7Yc/0x6j4IoCDNbI10tYs+CEsX
 x5mB/j4MycEhAhadKNq2c7CL9SBRBOgcGzpMDOzRgVirV/oCkAKfxiBwVEOftNdawuGW Kw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0b-0014ca01.pphosted.com with ESMTP id 39atwmqmt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 23:54:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFkB6XgoTg5O7m9HKpCQlYUm7D1wtisKBRt4OLWkgKvI011wjiLwpGc38x/BghzNm7eOeWGyn21ik+iDmOm3FjMWCNuGiDFqULyh5lR8qNoNfV9lDq38mTBJJONFZEG3jAZkRNtZOQaVflINS/oy0U81ZCfqLHlbm36YoqOBmjqBzpPkXRKDMVs4MnN+DAH+E6sONoI9NEvWkAEkTJCqdjRniGaUmYVGczw5AeK6Q4TkrH2p5dVU40C62mvZKDVNgudQn8cntHta4PQHj7noliYg/3f0E7VonjQJbf7OHmgRXwL/oXDCuxRmsDeHDVw9qqhgmisKbDiHN2C2azueHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1wph9qbVnYFz+/0mORGZKgtDEEwdrk+PbkgVpr0JBE=;
 b=A5/+OcQ+RATDjKmTwoUvUiF9qc8kkqybTBdUy/rKS4lDFG7G/mBBElCCxkfh9tc8p2ia5JvqLOfPTieyg7Vd3ljYSrkb9t2izqJnWQPmriWgnRU01T4GJtzRHEQJMRzyu43g6DxnetqDthAAUbSShJPGTKQ90Syw4Y4+jxOiifzowlhmnbmVc43eRSRPp+WxcUxe2FX+tN9KloZ5bCHSz+xsMRn2riS+SpU2E9vV7pTNZAxUltDV7v4i6pSeCdDPi2OtFj1zlDospQPreGJ6s2qBLW4JARUtf1FlYM1pnuYk+aReCpEmF/9vpNmkQ0eJgEfQanOL1lea//IerdJtLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1wph9qbVnYFz+/0mORGZKgtDEEwdrk+PbkgVpr0JBE=;
 b=mmYff0zfLETwl3Uh47eooKPtmUI494FMNwXJ4DSy5WGmMHpVMspZIhLNCUwsBTqcZsF/BY2yph6OX/CkekjNQIwvVAcOgjgrYcKss4e1goX7zmFjGQZAE1Yc9C012KoM2NdaawI+FGDYDHkU3i/VPir6ZA5AvmRdynDA/YTTS7E=
Received: from BN6PR18CA0023.namprd18.prod.outlook.com (2603:10b6:404:121::33)
 by BN8PR07MB6084.namprd07.prod.outlook.com (2603:10b6:408:95::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 06:54:32 +0000
Received: from BN8NAM12FT041.eop-nam12.prod.protection.outlook.com
 (2603:10b6:404:121:cafe::e) by BN6PR18CA0023.outlook.office365.com
 (2603:10b6:404:121::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend
 Transport; Wed, 23 Jun 2021 06:54:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 BN8NAM12FT041.mail.protection.outlook.com (10.13.182.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.10 via Frontend Transport; Wed, 23 Jun 2021 06:54:30 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 15N6sRub024145
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 23:54:29 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Jun 2021 08:54:27 +0200
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 23 Jun 2021 08:54:27 +0200
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 15N6sQiR031110;
        Wed, 23 Jun 2021 08:54:26 +0200
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 15N6sQtw031109;
        Wed, 23 Jun 2021 08:54:26 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <pawell@cadence.com>
CC:     <stable@vger.kernel.org>
Subject: [PATCH] usb: cdns3: Fixed incorrect gadget state
Date:   Wed, 23 Jun 2021 08:54:26 +0200
Message-ID: <20210623065426.30638-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a678890-8b84-42ec-854f-08d93613bffb
X-MS-TrafficTypeDiagnostic: BN8PR07MB6084:
X-Microsoft-Antispam-PRVS: <BN8PR07MB608488CB68A5A2D82E9025CFDD089@BN8PR07MB6084.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8zos7R0R+14cTBhNJwGHBNJfA4GY5Q8hXANo8F8C7rgkm2mNyKLXz+BozNsHzFiUwdQEYULi6ZJ63E6dnvrKDkVjvJb0FIwHDXQ0PLvrev6TDdgQzZXj49tIGLLS7dKyc0xhvlvL9Utabv9tjaRnJomCi8lCrxOmHRUeFe+TB0lUnUwGMMsc+k2PybM73WptzGiby9oUWiA/Pk7wfA8XQ5a0TK1RxcIO+vmEnY2bdNJJfBm5GoQa+Spf5MRiUsIzIQJRYEBmMGSe41QyoXpDbQilVQ+9X9zHeMk/Q4nHPVtLa2xKWmpjvcxF0lPvnFm90VDtst3mqcJz34+COO+IiQzJE0WZQcQV82ueltLDcw54ba7Ty0Jg8bMQU9waBJr7lo3bQOU537DWFxX+1jgzS30/pXrf3ehggaFSLJDtLWf/A8gU/djXfgEQ2ZuvyRb9JQB81tzDBk1KBr+aCzAdybN76ph5A48DQwqVPR0Dc0wDmfvSa/2ylxnW67RAgrg83DkOdJp8U/6MMGlLdR+ApeiXZGebHOle3K3KnShh3tQTJDrkjFgoNvj6isgGMck0D512vYT6/iKY6jMS2rdyZAQeh84I3r+uwJUR7cpCRkTD0oBeVVTqbFYE3sNj4SIMvCkPNw3kKPwdg0BdUweSUgGwz/Xh3Am5DMoVKvLrP+jL5THAeXe7qaXp+3szHz9qxZ6sh8BfIGofU69VhcsYeQ==
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(36092001)(36840700001)(46966006)(82740400003)(4326008)(86362001)(6862004)(81166007)(8676002)(186003)(8936002)(36860700001)(5660300002)(26005)(426003)(70586007)(70206006)(336012)(1076003)(82310400003)(42186006)(83380400001)(47076005)(2906002)(316002)(478600001)(6200100001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 06:54:30.1287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a678890-8b84-42ec-854f-08d93613bffb
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM12FT041.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR07MB6084
X-Proofpoint-GUID: QHUyNmELxAZjVZXZVaHySdnwDJi7O6ES
X-Proofpoint-ORIG-GUID: QHUyNmELxAZjVZXZVaHySdnwDJi7O6ES
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_02:2021-06-22,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 suspectscore=0 mlxlogscore=836 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0 clxscore=1011
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106230039
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

For delayed status phase, the usb_gadget->state was set
to USB_STATE_ADDRESS and it has never been updated to
USB_STATE_CONFIGURED.
Patch updates the gadget state to correct USB_STATE_CONFIGURED.
As a result of this bug the controller was not able to enter to
Test Mode while using MSC function.

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdns3-ep0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/cdns3/cdns3-ep0.c b/drivers/usb/cdns3/cdns3-ep0.c
index 9a17802275d5..ec5bfd8944c3 100644
--- a/drivers/usb/cdns3/cdns3-ep0.c
+++ b/drivers/usb/cdns3/cdns3-ep0.c
@@ -731,6 +731,7 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
 		request->actual = 0;
 		priv_dev->status_completion_no_call = true;
 		priv_dev->pending_status_request = request;
+		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_CONFIGURED);
 		spin_unlock_irqrestore(&priv_dev->lock, flags);
 
 		/*
-- 
2.25.1

