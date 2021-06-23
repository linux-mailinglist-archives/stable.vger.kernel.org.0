Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FACC3B1453
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 09:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFWHGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 03:06:05 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:3544 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229775AbhFWHGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 03:06:05 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N6xZZ6002075;
        Wed, 23 Jun 2021 00:03:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=b1wph9qbVnYFz+/0mORGZKgtDEEwdrk+PbkgVpr0JBE=;
 b=cbH1UEGQVRAetOp4gR1JmO0Amo+GjWUakpSObpgeWRNvF6na0oJXRmgj+F7nLSe738vx
 a7fdQYHUpczG8AeHkoxVjDXpcngK0Y08otENqHl0aPrMTbXrnFs9OWiF7UwhHpnNHW/U
 Zn1Ag1186/yTA5oP2uA+WRMfq2Iu79hZBO0TBCQ2FXFK/0szQr1VbQr0hsOANq/1I4sK
 SmGNR4vbwtyNx5h7/rZrqlu5PO6YV+ZdVndFzQVFI5WQrdzlziCVcVnCNpI6KjZ3PUE8
 1DU6n6maP3LeHTuMB1y/TwWqPHoNV/exaFpdQMYBLle70RWrdjUxTXLacTs+qcvItJ4M ww== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0b-0014ca01.pphosted.com with ESMTP id 39atwmqnxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 00:03:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aE+LCzveanJ/u7XuqpnC07ukdlcoE9ZoGUyb+xBzzWFrrEIVriyoEqDQFB9gnPnpRJWaau3C++MBym54vBN+oUMNIHIhiXXJ13vuCfMY1fRqQ4QlIW5Vn5DOinWVPD1RN5d55otnAEhO5Hmz+ko73yFoupu0zA2zL4w8OA+N7869MNpjGGsrTh7IhJ5zSqRIhNMvDkXtTA8dkdMYUficwMYTPlUkW8g15sagdv9L+TRfnXZq5rl7drDwu1oEkFWPqTyTLkTRcWIbH2uZ53lEmQlULAiv05lttKkOxG2qBNG3jao8VHQ0+auDQ5DdmakBcbXbUB4F6w1DYa9CUJg5kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1wph9qbVnYFz+/0mORGZKgtDEEwdrk+PbkgVpr0JBE=;
 b=br1ZY+qjid48tEEgtUaGcpOx1Rz20K64V4pyhxH9I6EDs7rW9z1wFU7uXZm/NVtOIKVBOCE5DagWKhxGXYoQ7M2KOlwNcJmpfS3LvCQ2bX0ZtzI/vWA9ah+tzRVSbK52iyEpgl5TKjly7hOfuirLcHbuRML6Zvo3MSun6UEuDfRMcA4auRvy0fGGR7BU8HPr/JIrFS0whhe1nugbKemysnL5ZV6DBpts1lHcTN43PfJjAVIeYE8z1POR+pLTKaakcIp4I2ZU+AC1qffiqAYXbo4o80GVRwfvdLCBIXTWtUfGilTo9GApkWcsGj5D0l8ziLFZeHQMFSd2mORdTu3Rvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.148) smtp.rcpttodomain=ti.com smtp.mailfrom=cadence.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=cadence.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1wph9qbVnYFz+/0mORGZKgtDEEwdrk+PbkgVpr0JBE=;
 b=Euecb9Krgt518zCFOkA70Cx/thH0cYcbpnlqybCbVEIYs6GC8L5yVg8H2AwT/Z34rxkzvntP6VbdSnbtn6j6sBo1Pr/Q1m975ALTNN/CuY/bQXrh8LpLHyzwzF/R/ZFgG2sGr+uasXlh058k3rKqRhwPElyiNg9XJ5iUxvYbqbU=
Received: from MW4P223CA0005.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::10)
 by BYAPR07MB4421.namprd07.prod.outlook.com (2603:10b6:a02:cd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Wed, 23 Jun
 2021 07:03:39 +0000
Received: from MW2NAM12FT005.eop-nam12.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::61) by MW4P223CA0005.outlook.office365.com
 (2603:10b6:303:80::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend
 Transport; Wed, 23 Jun 2021 07:03:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.148)
 smtp.mailfrom=cadence.com; ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.148 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.148; helo=sjmaillnx2.cadence.com;
Received: from sjmaillnx2.cadence.com (158.140.1.148) by
 MW2NAM12FT005.mail.protection.outlook.com (10.13.180.72) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.10 via Frontend Transport; Wed, 23 Jun 2021 07:03:39 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 15N73at4014388
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 00:03:37 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Jun 2021 09:03:36 +0200
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 23 Jun 2021 09:03:36 +0200
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 15N73ZJb047602;
        Wed, 23 Jun 2021 09:03:35 +0200
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 15N73YV1047601;
        Wed, 23 Jun 2021 09:03:34 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <rogerq@kernel.org>, <a-govindraju@ti.com>,
        <gregkh@linuxfoundation.org>, <felipe.balbi@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <kurahul@cadence.com>, <sparmar@cadence.com>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdns3: Fixed incorrect gadget state
Date:   Wed, 23 Jun 2021 09:02:47 +0200
Message-ID: <20210623070247.46151-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4746d020-1207-405a-fd46-08d936150740
X-MS-TrafficTypeDiagnostic: BYAPR07MB4421:
X-Microsoft-Antispam-PRVS: <BYAPR07MB44218F27F9A339757026F1E6DD089@BYAPR07MB4421.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhHrFPhodmV9QIKZcd6P5hyPhNPy1eg69XGBLfXQVD2VLWx+EHmy6eg4sDUim5qNg21UtQCQoDMwc3XtHUhY1RncBpNGRTufBWctG5xtda7bZpbol+I3SHIeYVArV7jlOX5n9XLWCWZ7mUr6rgK7sldDkyt7ch/5RzKIsjzwdK5lhpOCcqDKU6JkO4PTcyBgvtteqevRxZi9fc4suza1GSO8yZpbxaJgjeq93eM2ERTCD/5W2F4qoU+OuspggaLbE89vLzV7yDJ75ZpACNcVjNJEn1mOaShqDsk3lZcz7wz6tHPpAq0DbQZpXfOZ98mrrJChTTOoqu+2Ohf+XZIMaskODgn4EwoBJN6LfqPrZXBKXu8DsikfylveZO+OPmvixXEiheQRZT29Ik01am0kIaN1c0u3N3dwPtdX+YK8L/SI6cGRs8Fw+GRbJRur+xpoKnyqPQnAoCWLlg9eWWgDYNJoxME8CD6d89XODxiTAd5DA03TPQh8uwg6M7BKbMXGiB7blL3GtB3nFc9DsByeVeYgsH24LcKj8O1lGxCI3cvYdTuFPJdhi3bjaKkBCgbQhP8CvsqTXajXLU3OUQE8mt2qAro8r9mVaOpHL3CLSmZWTq0TsPW8TJY28AVkPaKDKLzWRFt7ypvDRiqOzWn4sYC81WwDPIZ/xY8AbofE36IRTn/ARk7KVWgbvRS8ketK
X-Forefront-Antispam-Report: CIP:158.140.1.148;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx2.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(36092001)(36840700001)(46966006)(47076005)(8676002)(8936002)(42186006)(316002)(36906005)(336012)(54906003)(36860700001)(83380400001)(478600001)(186003)(426003)(26005)(1076003)(82740400003)(6916009)(2906002)(70206006)(86362001)(4326008)(356005)(6666004)(5660300002)(7636003)(82310400003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 07:03:39.2918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4746d020-1207-405a-fd46-08d936150740
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.148];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT005.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB4421
X-Proofpoint-GUID: U7LeBa_1k7nXSsNerInqTtS_lLgeFkpc
X-Proofpoint-ORIG-GUID: U7LeBa_1k7nXSsNerInqTtS_lLgeFkpc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_02:2021-06-22,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 suspectscore=0 mlxlogscore=710 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0 clxscore=1011
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106230041
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

