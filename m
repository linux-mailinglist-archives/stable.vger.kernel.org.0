Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC1A6ADE79
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 13:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCGMPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 07:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjCGMO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 07:14:26 -0500
X-Greylist: delayed 3548 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Mar 2023 04:13:58 PST
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EBC574F7;
        Tue,  7 Mar 2023 04:13:58 -0800 (PST)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327AuefI014715;
        Tue, 7 Mar 2023 03:14:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=fERc8RWwMiP+NDVgv63jR70T8e65VOOHP0arhzoWfSM=;
 b=d4VGDu/Z/4EUK2EBJPWRmFjni6TnjAxKi4aVGIC7p9pYrXyvZCT+Qw2+/+OVoKD2FkX0
 +PyL7J//sclsVjDmLkyX6UZrN5xYd2R+sEGkJ/dx2Tz8WBj3MIjtd3KVTNRdzSP5m+KA
 +urY4UpYls/2CnosJNxze96LXwsUbqAoTnMrymaTMqKN/sJcq1MUoG3QmDuRi/0d3WKs
 mDNl0e1WRVtl6GbC6N0Iv5PAuva6DN9tfhOJ/BYG+6gIrUXdi5QHmsQIPUWRde/usbzJ
 YvGe7ylgBWj6g3RKo/YUL8jBGVQLHq7JrvmZMirsb+sWhqy8McJBdJjPfRInUnLo/b3W /Q== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3p43e1abj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 03:14:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fO5JvgZIcnHXJlCRWoXWpjlOSAefQgG5UiC11DTKAj1emSJdkOVp18eL2uSnGXR5Q3ZXrFtHDtDHe9/D/52VuKTGITlagfTZAhrUx934LGADyzOGhypHotra3HnOqtXSYl0ImdfLqV03r5Z/esZmQtmj+1ijH4bgoDL1wuNYIXfmuhUt2OWpoY6R1XDdcjOx/MrLD7ZtpxshdwbpqhdN6f7bNV+jT3LJfTPb1AuEZSTmBpkKL0DZCWxmCMwT+jJxhN/iZ8aVjnYdZsaZoLD1bZTX26kzkyNSLm5hvzy6XDkz63OCzQsrjhimQn9ipCQZ1iaGOk16v0ed1Tv8g06jQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fERc8RWwMiP+NDVgv63jR70T8e65VOOHP0arhzoWfSM=;
 b=FhRWGt12reaq3/vd0yLXpXKgy42it4YlZVvNH2beb3F+gD3Qd95Uf5v2hryaHUhYuqKJg4/iCUPISK8HF1GAkUToLXV5X80v3hpL9pL6Ib2HEgnSY6Re9hnhyjKBHZp+EW8ScgL157iVt3LBmgPI3FoSc76Y2shHjAeNx8oPFzPj+Tn+rzMgu7ofIMTZgQCidNhaXXZP4qTz00O91etK1rnqLCPVEdv2lMSASNGjNEYQYVxnT5jlePVVONBGejiSKE+hocII+rmd95TmEgIu6kPuQtYwUC3ZvWt07MaHmfZvU3sotfTuzVPGlRZOfQNXt5qEzDY/poZ/SFq9KlP8Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fERc8RWwMiP+NDVgv63jR70T8e65VOOHP0arhzoWfSM=;
 b=rD/z68vJxDe3us7xU+HWcryuxfYZhloLT4lwpXd7Juem8C5jhQqGKuwVBgvRjs/hRk4Yg3SwtFs05gOeQ+ZR15B7N/ndrIHvoYvDhpBstXkpKl1VtKA3293J29StuentFO7rpijjlx8YCqcovFjjLN2MI3FhEy1Fc9RbGGk/etc=
Received: from BN9PR03CA0915.namprd03.prod.outlook.com (2603:10b6:408:107::20)
 by CH0PR07MB8329.namprd07.prod.outlook.com (2603:10b6:610:c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 11:14:35 +0000
Received: from BN8NAM12FT105.eop-nam12.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::54) by BN9PR03CA0915.outlook.office365.com
 (2603:10b6:408:107::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Tue, 7 Mar 2023 11:14:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com; pr=C
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 BN8NAM12FT105.mail.protection.outlook.com (10.13.182.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.15 via Frontend Transport; Tue, 7 Mar 2023 11:14:34 +0000
Received: from maileu4.global.cadence.com (eudvw-maileu4.cadence.com [10.160.110.201])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 327BEV36017915
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Mar 2023 03:14:32 -0800
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 7 Mar 2023 12:14:30 +0100
Received: from eu-cn02.cadence.com (10.160.89.185) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Tue, 7 Mar 2023 12:14:30 +0100
Received: from eu-cn02.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn02.cadence.com (8.14.7/8.14.7) with ESMTP id 327BEUqs376208;
        Tue, 7 Mar 2023 06:14:30 -0500
Received: (from pawell@localhost)
        by eu-cn02.cadence.com (8.14.7/8.14.7/Submit) id 327BETPr376196;
        Tue, 7 Mar 2023 06:14:29 -0500
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pawell@cadence.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fixes issue with redundant Status Stage
Date:   Tue, 7 Mar 2023 06:14:20 -0500
Message-ID: <20230307111420.376056-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu4.global.cadence.com
X-OrganizationHeadersPreserved: maileu4.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM12FT105:EE_|CH0PR07MB8329:EE_
X-MS-Office365-Filtering-Correlation-Id: 839ae856-5fc0-419f-19da-08db1efd21da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rDweJ/fW8PXAdmqYqte0RrHU7hGXHZ1VKhMAYpi7bSUBsRETTjXhlfBhhhdRQlVBuZbCtt9/5ni4o0jqaM4bKe8IDxnIFhQ+0c63FFsrqNAhHQlPkF7aNdw9LJD+l9zo79lbDRy50/hG4/IoM/0V6l9X1RMsupB1Wpe5uOoYDpM19yPI8x3Bq7xVvrHij0pJJ10IvoC2U2A/yZ0hGRFfeQkljN/anCdwDwrggwARD/b6QwSuXSp3wvO37eSRMo92XzPYzL13wR+vlV7TQn+9k25PJVq1fGdUavfz3OJGQirbwzmn75jCTw+UMMcrrQY95DDNB/sqmUq4E1HBi0xTO5KhgeuFjyFtu3aScAQbIBgC9tJOTpUc+KEWHqDlp9lCfg2AWgcAC2FmO27NtVPmbuuzwshsHkBFEQItA2sfSLxo+uy0Ew7BbjRBnWzm9VHUyoSEjknfmANngzyNx/2dNjPg2uNouE3WJG2xebizONG5FsgDooJKdB4NYFku6rSRfOTtH8m+pS8QQWeC1i2Jf8zpVs9KDAcGxU0jeuY7Os4B1RePix+t7TLwLLRctyTDsmA1LkFtCFDV6q3Q1sdj3s0XRDjEj1hpV9BeKNr3WT2Xwxhzn+dpEwGrMmGvk25YsmsLTktu6rL4koZWayMiDBeF15u+JA/lAZUfSOLxxAGtB8VSu5QkZgmnhJdC8kvA/XokfrH3qrCwOlZ1ymfkpQ==
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(346002)(39860400002)(36092001)(451199018)(36840700001)(40470700004)(46966006)(41300700001)(70206006)(70586007)(2906002)(8676002)(6916009)(86362001)(4326008)(82310400005)(54906003)(36860700001)(42186006)(356005)(83380400001)(82740400003)(186003)(316002)(8936002)(7636003)(1076003)(26005)(478600001)(2616005)(36756003)(5660300002)(336012)(426003)(47076005)(40480700001)(6666004)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:14:34.4839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 839ae856-5fc0-419f-19da-08db1efd21da
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM12FT105.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR07MB8329
X-Proofpoint-GUID: lUzkVsaeL284cpsnfSqXHwdLzLPAlwnM
X-Proofpoint-ORIG-GUID: lUzkVsaeL284cpsnfSqXHwdLzLPAlwnM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_05,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 mlxlogscore=706 priorityscore=1501 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 impostorscore=0 spamscore=0
 adultscore=0 suspectscore=0 clxscore=1011 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070101
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In some cases, driver trees to send Status Stage twice.
The first one from upper layer of gadget usb subsystem and
second time from controller driver.
This patch fixes this issue and remove tricky handling of
SET_INTERFACE from controller driver which is no longer
needed.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-ep0.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ep0.c b/drivers/usb/cdns3/cdnsp-ep0.c
index 9b8325f82499..d63d5d92f255 100644
--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -403,20 +403,6 @@ static int cdnsp_ep0_std_request(struct cdnsp_device *pdev,
 	case USB_REQ_SET_ISOCH_DELAY:
 		ret = cdnsp_ep0_set_isoch_delay(pdev, ctrl);
 		break;
-	case USB_REQ_SET_INTERFACE:
-		/*
-		 * Add request into pending list to block sending status stage
-		 * by libcomposite.
-		 */
-		list_add_tail(&pdev->ep0_preq.list,
-			      &pdev->ep0_preq.pep->pending_list);
-
-		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
-		if (ret == -EBUSY)
-			ret = 0;
-
-		list_del(&pdev->ep0_preq.list);
-		break;
 	default:
 		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
 		break;
@@ -474,9 +460,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 	else
 		ret = cdnsp_ep0_delegate_req(pdev, ctrl);
 
-	if (!len)
-		pdev->ep0_stage = CDNSP_STATUS_STAGE;
-
 	if (ret == USB_GADGET_DELAYED_STATUS) {
 		trace_cdnsp_ep0_status_stage("delayed");
 		return;
@@ -484,6 +467,6 @@ void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 out:
 	if (ret < 0)
 		cdnsp_ep0_stall(pdev);
-	else if (pdev->ep0_stage == CDNSP_STATUS_STAGE)
+	else if (!len && pdev->ep0_stage != CDNSP_STATUS_STAGE)
 		cdnsp_status_stage(pdev);
 }
-- 
2.25.1

