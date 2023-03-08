Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D26C6B07A0
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjCHNAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjCHM7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 07:59:55 -0500
X-Greylist: delayed 876 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Mar 2023 04:59:29 PST
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E94199D49;
        Wed,  8 Mar 2023 04:59:28 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3286oCa7021163;
        Wed, 8 Mar 2023 04:44:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=1ESZird53MGoPKqRTDEgy3S/nqgk1oP+Yt35N/pDWh0=;
 b=r3tCBZSZcVJpVs5XrYGnkJzajGqITQ/h5zWgXRBtCNKTLvPf1UEmGjq9gys3Z9qiI7kC
 ir+0EuJgjZhvx5rvDCLwVcD19u3VRREahK9JvzsaqYKVEjgmhW4Q/HYo1VaPykx8y5ZC
 tu3FYYrllJSDT+t7mXc482A+hVEb4/GBh2ap8YSVgP/qglAQw+iH0zCmbrJWjVYnlr0J
 kZYJ0S//qHLG/qS73+vmnTl0UynE5mRqG4Q/2SkiTWg546LGCvEEhX0AZ6WIoZvIBoLe
 h6f7kxYjIa9G2sAVnyuaX+P85SFnIMvMy3jBqDZJe75bUTg7oVF6wLp58qcz0jAu2BFK cg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3p6fep2c7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 04:44:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7tPLsHYYK9J+2UlCW8Sja1hXmgjpauibJK6wXFBD4N9I7Tmk6ODLg1+2FzgTXJPPRFhHRnAujRm+xMsuXBpc7a6QLDfbN/B9JrriS8sjWVIjUE0sItJJie+KNpT5dClMFDBoLavkZ2DHv/1S/nOaMHwqylWF34H620TtyaDQ7nN1lFOAxZpXjnXFoQJTsn8f6aeNXG+A7X4lZkeZr1vWep4DafbxAEEGe0MwyfHY0/AcVQ7EUlsdSpAfAk5y60ncdOvpOJDMCCWJdoj2i9PbHmXn3UJLQzBEhg1LvTisLYhFLvesR++NmciYolopUoQ7y3XciqhiK6II56rSdgrCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ESZird53MGoPKqRTDEgy3S/nqgk1oP+Yt35N/pDWh0=;
 b=ToWWAmdzyTMyNfEY9zK83tp5zVHb0PwA6+Mo12h/Ip3IVGdH4RTLAmGw/3IJBn92UEl9HCI2IW4qDO0nHbew/ywNxI2SESniSgEbPSbgAaMrpWCoFCEwszi3dBMwqyQ+iEsoG32+yuP4RBs7Iyu8lnzawxnkWPun88/KA4IlmXV+eeHDCwqjtQ+VRk/BhcpAzZluVh/qfNGMlg0EyJ83f9/RZlzoXfvlCJcZ3/SjYXMY/SrK7R3jsvnbNg8od4IaE2eT6kmmYGtHu9fkuIbpqHkqUmEkiCVD7NYh0DytvbO+HqrawwMOxQ0Vt0kNizS7QlYwufjscKtHJvFPOlFTSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.148) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ESZird53MGoPKqRTDEgy3S/nqgk1oP+Yt35N/pDWh0=;
 b=PWijfj4rSzoRlK2ap8nfutkicqRqOAdnsuAYSlpNIT6qUB3t5tfJ0NKuEvL4uYVCkiGZK1g5WyyFk+RNIc9EUIEPXayZryebeOMspGf8RgjmshOObTJkj8uQTAR74oMeLDu70blHzXK8zHCVA2ID91Elt2W5Q+Y9DrU+UGKibKo=
Received: from BN9PR03CA0170.namprd03.prod.outlook.com (2603:10b6:408:f4::25)
 by BYAPR07MB6213.namprd07.prod.outlook.com (2603:10b6:a03:11d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 12:44:36 +0000
Received: from BN8NAM12FT095.eop-nam12.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::1a) by BN9PR03CA0170.outlook.office365.com
 (2603:10b6:408:f4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 12:44:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.148)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.148 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.148; helo=sjmaillnx2.cadence.com; pr=C
Received: from sjmaillnx2.cadence.com (158.140.1.148) by
 BN8NAM12FT095.mail.protection.outlook.com (10.13.183.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.3 via Frontend Transport; Wed, 8 Mar 2023 12:44:35 +0000
Received: from maileu5.global.cadence.com (eudvw-maileu5.cadence.com [10.160.110.202])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 328CiXnW007547
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 04:44:34 -0800
Received: from maileu4.global.cadence.com (10.160.110.201) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 8 Mar 2023 13:44:33 +0100
Received: from eu-cn02.cadence.com (10.160.89.185) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.7
 via Frontend Transport; Wed, 8 Mar 2023 13:44:33 +0100
Received: from eu-cn02.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn02.cadence.com (8.14.7/8.14.7) with ESMTP id 328CiWpE311338;
        Wed, 8 Mar 2023 07:44:32 -0500
Received: (from pawell@localhost)
        by eu-cn02.cadence.com (8.14.7/8.14.7/Submit) id 328CiUQB311308;
        Wed, 8 Mar 2023 07:44:30 -0500
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rogerq@kernel.org>,
        <a-govindraju@ti.com>, <felipe.balbi@linux.intel.com>,
        <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdns3: Fix issue with using incorrect PCI device function
Date:   Wed, 8 Mar 2023 07:44:27 -0500
Message-ID: <20230308124427.311245-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu5.global.cadence.com
X-OrganizationHeadersPreserved: maileu5.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM12FT095:EE_|BYAPR07MB6213:EE_
X-MS-Office365-Filtering-Correlation-Id: 4241abf0-801b-4ba4-fa0a-08db1fd2df99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xytKET6dgZYXgqxL4HOQ4GtX/zomAhZF5AMxEeqVmbTX9fnSGurQarznLj8ZFyfd+hVFmh2TdjoYXuhhI6AB151+mrL5xPaMcBbyOzJUII5FTrnPkZyrlGpjkmqZbhOG3GMZc2/6jwhbvqpsIZdz2c44NLfU96kNtd3Ko8Xfn3/jBE64EhBGM8SPlKlTSS9KYu6fZqo218oQfB1dvinJZpxNUY8p0TSw8h23yPduHkHVUalI8lisoLqh08sGEjodk17gsRmxewD3eEwZozPiuL/Ut1X47XIfcKkG4HrZyymMC7zxZ5z5hKhFBNbIlOn5ROr8x3MUWRQYJR3soBpAYKJQEEMaQ4G5ELTkHNyCEZp8r8ge6FY1Y5SM96fBL93OmqEyMtKE+MwnxrgqzoY7ByNkIflCH0C79j5fBEv0vCeR6Gtp6wcCRqk0HVyTYgSOAPmcHKHnXeubDeL5i/Nby5MIXNUqX5IgeSqWgH9xSMzsBDA1lHOqDcrf1w3b2ijgETQnu4K5QwWSu0v3qU6YZxCfheA+y3J9coinvzQkWVn8QLCumk9SFhPHiHt5Ea+2AIxLFWDz+tjeZ+06g9HbRIT07WYuEbfNreixwC7t9OFwZbcUjvvMhxJ59iY/gRQRsZTshXAoB+KcKmm3NmHm4qEQdjudAIaXCfYSDzRMgh93MwfNNQUWW81kRImgBk77wmQGP9XgpYoIwQRC1sPhIw==
X-Forefront-Antispam-Report: CIP:158.140.1.148;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx2.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(136003)(39860400002)(36092001)(451199018)(40470700004)(36840700001)(46966006)(8936002)(54906003)(1076003)(26005)(6666004)(86362001)(186003)(82740400003)(356005)(7636003)(336012)(82310400005)(36756003)(426003)(47076005)(40460700003)(4744005)(40480700001)(5660300002)(478600001)(2906002)(2616005)(41300700001)(36860700001)(70586007)(8676002)(70206006)(4326008)(42186006)(316002)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 12:44:35.6341
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4241abf0-801b-4ba4-fa0a-08db1fd2df99
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.148];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM12FT095.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6213
X-Proofpoint-ORIG-GUID: heviUgBfy-mvUWjdnXo4WRUHtjDc4KnC
X-Proofpoint-GUID: heviUgBfy-mvUWjdnXo4WRUHtjDc4KnC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_08,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1011 phishscore=0 bulkscore=0
 mlxlogscore=678 impostorscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080109
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PCI based platform can have more than two PCI functions.
USBSS PCI Glue driver during initialization should
consider only DRD/HOST/DEVICE PCI functions and
all other should be ignored. This patch adds additional
condition which causes that only DRD and HOST/DEVICE
function will be accepted.

cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdns3-pci-wrap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/cdns3/cdns3-pci-wrap.c b/drivers/usb/cdns3/cdns3-pci-wrap.c
index deeea618ba33..1f6320d98a76 100644
--- a/drivers/usb/cdns3/cdns3-pci-wrap.c
+++ b/drivers/usb/cdns3/cdns3-pci-wrap.c
@@ -60,6 +60,11 @@ static struct pci_dev *cdns3_get_second_fun(struct pci_dev *pdev)
 			return NULL;
 	}
 
+	if (func->devfn != PCI_DEV_FN_HOST_DEVICE &&
+	    func->devfn != PCI_DEV_FN_OTG) {
+		return NULL;
+	}
+
 	return func;
 }
 
-- 
2.25.1

