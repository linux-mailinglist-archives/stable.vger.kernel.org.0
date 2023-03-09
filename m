Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24F76B1B8D
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 07:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCIGbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 01:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCIGbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 01:31:23 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5BFCE958;
        Wed,  8 Mar 2023 22:31:19 -0800 (PST)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3294B8xX012130;
        Wed, 8 Mar 2023 22:31:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=u8z3OY6Y+miGb7XG1HkTK447NEAOfHgHDMhshaOaSXc=;
 b=pjEss/BptsOUixlYvYN96nIu0VuM9VUDmlD5nVTVogTZNY0kmCHxaqmghTJNsgPL+JEO
 fzgHPoKc9xUIjZQ6S986fa4jX95eTpZ6/w4E8Mm7w9MIZ/G5KzKPHOneKnNKNxyXha4u
 t5CP/U7tlktm4p6rF/p7fwEe7bWvyklazPE0S9Nm7xU338dvwvzvw+Z//prGMmKY8+kE
 hChAA/Lc+xDi8Y/VWZ4ffbymZhsWk6W3PT+qfz2L/0HvNNQMb5UlGalTDu3EGbWY02z0
 S8djo91sE+eGGlTq1rm9DlhR3j7pLeDjyESo6ZHHRvsZWvEyirJo7fyZdXnWrZSFa7Nk Qw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3p6ffwmjv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 22:31:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRtlbIZLZWm6oO5/1b50MRdPFzYL+MIfX4IYRphnlHtv8fFqNYwR3xhbNFJm/ancg4LCtIp2ZDN0lAmkNWD5JNEDdGeaU6BH52Vp+T5uPqZCMM8NeIV/52jRGx2tJmAyS9L7JVERd6TMuGowyhdLJ3xwx2Sk6IRnHgT/uses8BuGjxj1wCU+hetFpZtXA25cWVHOeODPgrTYdFy+WOo+WZu0g5Y+xkTR/l8UjW57Re76h6AITBpEdMN/cSMncvvzdRUE9GggsrCtJhz11xcpujIJGMcNF6YfoqfaTxuNcjV1dguf/y0oc4u2LilBcl+ue2DCzdCtSmeoSeDoC5daAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8z3OY6Y+miGb7XG1HkTK447NEAOfHgHDMhshaOaSXc=;
 b=NtNBgGAb1Z35pKwJAIn4aije3vUtw/Fmi8A8p2waljffGmuZxTAMIwmy+ek94Xaq8Tys8WHp4sG7VI4sZywY9qhckVlMOgXOI2/XFE2is8xZBZDGniU/z/CaMGPabCmM0jkuhVIrE9GHTALRGiCgJmLySkYUOOjji9yg9hZkdGmkI52NJ2k/zxMkNUBPMdLDnX2EF2yQRzuYUh87WzodHhp44gVs5KFljxpu7Wdej2yXqmxlMl91ZfHDbQdeiOSTlKROs9hmfekc/nhCO+nNMQH1k7eYd15UgdJ2683fORikwm4YXspiGcUZ21x/C725uT8P5C+KCjbw9xZAvnyjLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8z3OY6Y+miGb7XG1HkTK447NEAOfHgHDMhshaOaSXc=;
 b=xDJI9xrmP5J6j0kfo3QtcOSGRw4BhTaF9YHv2yghqfVg4Yog+HPE49G/oGcVeCIo+0i4nHBNoCgNd1i4SYGEd4ji92U4syJaX54lcKsw5if9N6LOot/zE7fCsa2m3F1EUhuzcT0haADHuXXtDMg09Pqc+wpksIxbFbZw2sDd3xE=
Received: from BN0PR02CA0016.namprd02.prod.outlook.com (2603:10b6:408:e4::21)
 by MN2PR07MB6174.namprd07.prod.outlook.com (2603:10b6:208:110::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Thu, 9 Mar
 2023 06:31:07 +0000
Received: from BN8NAM12FT042.eop-nam12.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::4) by BN0PR02CA0016.outlook.office365.com
 (2603:10b6:408:e4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Thu, 9 Mar 2023 06:31:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com; pr=C
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 BN8NAM12FT042.mail.protection.outlook.com (10.13.182.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.3 via Frontend Transport; Thu, 9 Mar 2023 06:31:05 +0000
Received: from maileu5.global.cadence.com (eudvw-maileu5.cadence.com [10.160.110.202])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 3296V1f8210032
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 8 Mar 2023 22:31:03 -0800
Received: from maileu4.global.cadence.com (10.160.110.201) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Mar 2023 07:31:00 +0100
Received: from eu-cn02.cadence.com (10.160.89.185) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7
 via Frontend Transport; Thu, 9 Mar 2023 07:31:00 +0100
Received: from eu-cn02.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn02.cadence.com (8.14.7/8.14.7) with ESMTP id 3296V0ER299577;
        Thu, 9 Mar 2023 01:31:00 -0500
Received: (from pawell@localhost)
        by eu-cn02.cadence.com (8.14.7/8.14.7/Submit) id 3296UxOZ299563;
        Thu, 9 Mar 2023 01:30:59 -0500
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pawell@cadence.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: changes PCI Device ID to fix conflict with CNDS3 driver
Date:   Thu, 9 Mar 2023 01:30:48 -0500
Message-ID: <20230309063048.299378-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu5.global.cadence.com
X-OrganizationHeadersPreserved: maileu5.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM12FT042:EE_|MN2PR07MB6174:EE_
X-MS-Office365-Filtering-Correlation-Id: 9458b12f-f28f-45f2-0184-08db2067dcbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZNmjS84gXlYEQdYI9q1OcGpPNZSzYYNUs6PB4aORZ+/+pbG66JEK+SAH1PXtXKU5Y0oB0NVbRFaNlZmPvC8gEPsHHI0n3FSwno2moCroLqO9M8kf/uPiO9PDtt/GQsP+YOs6RTa00+fwv562XpoICEmpIGpkxcrRu5Y3P/+d7Q7V2dba2uHMGuBcHfTBHEayRYUQu4UrDS8S953c5SNLBASavhVRFbUDXF1ETcEPgdQM6MU8VcY3LHlbx9DuaQLFP/nrLdmiLzYhpfay1VVoWxaXy1gMkJApmL75mQFERQF4WbiaDKWT2Zielpvt/Ju25x+af9+VpUeGoBHMPLItzLbsq7KKLq7ZMVgoHgA8isajGnMjw06MGKpgbaLeEkgtSxFZ6TY2Rhuhg4P821FLrTdrnmCXaUN3eX86IzlowXO0zj4USE0TI8HLoMcclTdrho8WASooNXBq/wLcqRYfmbO6wTGIwBvmAL6eQpZj+eTrcakW+u8mXmQiJNVyJTIXjPjV17P8zluWaeHv+1JBqW3xmuBHBCzzUNvnJAHc/6aEXL3VVDOA4+8haDQA62kJUuZboo63VFUgm34gZ4ZLAhtlcsC+sMoyM8qXDyvsS62Qcuihses466A1ZsM2p+1isUGtsxT3aDIo2uY3S3NcOz8vS1ilr/XQ8gdF1HgVrF3QYaPWnpWBbhNstYxFxpED2tnUAAmRPDwp6bvwegolPs8eMJLvCXNRShsUqxUU4Mlp5PU5x76A2LtdCHA7LtNF
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(136003)(36092001)(451199018)(40470700004)(46966006)(36840700001)(8676002)(82310400005)(4326008)(70586007)(6916009)(6666004)(70206006)(356005)(2906002)(26005)(1076003)(186003)(8936002)(336012)(40480700001)(36756003)(426003)(2616005)(47076005)(81166007)(41300700001)(5660300002)(83380400001)(36860700001)(82740400003)(54906003)(478600001)(86362001)(40460700003)(316002)(42186006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 06:31:05.8654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9458b12f-f28f-45f2-0184-08db2067dcbe
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM12FT042.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6174
X-Proofpoint-GUID: XuawggpevoVkw0Y9BN1L2YkP8fw1s0Ku
X-Proofpoint-ORIG-GUID: XuawggpevoVkw0Y9BN1L2YkP8fw1s0Ku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_03,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxlogscore=886 clxscore=1015 phishscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303090050
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch changes CDNS_DEVICE_ID in USBSSP PCI Glue driver to remove
the conflict with Cadence USBSS driver.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-pci.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-pci.c b/drivers/usb/cdns3/cdnsp-pci.c
index efd54ed918b9..7b151f5af3cc 100644
--- a/drivers/usb/cdns3/cdnsp-pci.c
+++ b/drivers/usb/cdns3/cdnsp-pci.c
@@ -29,30 +29,23 @@
 #define PLAT_DRIVER_NAME	"cdns-usbssp"
 
 #define CDNS_VENDOR_ID		0x17cd
-#define CDNS_DEVICE_ID		0x0100
+#define CDNS_DEVICE_ID		0x0200
+#define CDNS_DRD_ID		0x0100
 #define CDNS_DRD_IF		(PCI_CLASS_SERIAL_USB << 8 | 0x80)
 
 static struct pci_dev *cdnsp_get_second_fun(struct pci_dev *pdev)
 {
-	struct pci_dev *func;
-
 	/*
 	 * Gets the second function.
-	 * It's little tricky, but this platform has two function.
-	 * The fist keeps resources for Host/Device while the second
-	 * keeps resources for DRD/OTG.
+	 * Platform has two function. The fist keeps resources for
+	 * Host/Device while the secon keeps resources for DRD/OTG.
 	 */
-	func = pci_get_device(pdev->vendor, pdev->device, NULL);
-	if (!func)
-		return NULL;
+	if (pdev->device == CDNS_DEVICE_ID)
+		return  pci_get_device(pdev->vendor, CDNS_DRD_ID, NULL);
+	else if (pdev->device == CDNS_DRD_ID)
+		return pci_get_device(pdev->vendor, CDNS_DEVICE_ID, NULL);
 
-	if (func->devfn == pdev->devfn) {
-		func = pci_get_device(pdev->vendor, pdev->device, func);
-		if (!func)
-			return NULL;
-	}
-
-	return func;
+	return NULL;
 }
 
 static int cdnsp_pci_probe(struct pci_dev *pdev,
@@ -230,6 +223,8 @@ static const struct pci_device_id cdnsp_pci_ids[] = {
 	  PCI_CLASS_SERIAL_USB_DEVICE, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_CDNS, CDNS_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  CDNS_DRD_IF, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_CDNS, CDNS_DRD_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  CDNS_DRD_IF, PCI_ANY_ID },
 	{ 0, }
 };
 
-- 
2.25.1

