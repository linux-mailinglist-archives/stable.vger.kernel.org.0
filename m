Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBE2E7660
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 17:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391043AbfJ1Qdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 12:33:47 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:29552 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730952AbfJ1Qdr (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Oct 2019 12:33:47 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9SGS92K004431;
        Mon, 28 Oct 2019 12:33:25 -0400
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp2050.outbound.protection.outlook.com [104.47.48.50])
        by mx0a-00128a01.pphosted.com with ESMTP id 2vvg08cyp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Oct 2019 12:33:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYqQdUaTq1UXvNR0jDjYqi3bYMryrKZ5tRjSO+pNb0W2WEoLJ1PYpwlvMzb5aU/VP2xPYrf/Jq5T3+c0Y4dypqEzZrGEfYBV3dEkUXu47B3DJZYHxppon+BLE5kHK/8FT5I2Xw6l4qFP1D4mJ0n0bCZLoIUo3Z/yTaJBlDUg8WEUXVWDKSjrA9EJGHtL/7b9ImXH6hkXSlAl0bqqPmfmEfmS5kV6RpcsrZnxu+PNCwVrtkomtP1k8n9NhoRdqERVbym7cmm1Rhrc2iYFmCBb+kqsfhbvmWP4qH6jJejoHUESRc+aP1gtTDDTV0cgOY7p2zz2zKXAuYqiK4uPgp4yCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ae8t8hquwHN3HqSCnCX4pOWwr6v7+k5HC+Uw7LYhsps=;
 b=R60eq4Xi0CJqccrRPbwxy+aFoUfxpFNrrFyrp2Bb59Gp4MLSfsvph3RUYsJrPgCLymKCXJJl7TXfQMhS7mWTSOA1PZpU4DTIJoPVdMEqo4LspPXV/TbhmMY3loEvHsFoDo7D1pAGQpCNt0IgUQfaJpqMRAMkXMVIPB1XcUhIAiGPK6HrhEDsk8Hmuh+B/whranDmpXZBO06KDyD2EdU0kn9dertx95VRdaZIn/bGqf6jefB1xIg8oAps2y0J72e6zSbXK5QKnWsPsou2aIT4xUjknY7iJhv/m9GJK+nGKy0fkmEzSkFPn24uFCPbmqfjyX7ZBzxKAcl19zofzrYDJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=metafoo.de smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ae8t8hquwHN3HqSCnCX4pOWwr6v7+k5HC+Uw7LYhsps=;
 b=mDkPS/cBwJ7NdTYBCNSU/2jwvcIOlKBflghuz0TL9amQBu4S+24WrtJuX2CGCw3VKmeG8rWOSUe7qnMgze1715dQ/r5OkvH3BcjVNcZ1x3HrGmymri96r80NvlzY+hQUT25DiZH5OunssDUHC5hNFM+TDgj5rV0yFFP8dg8xsJw=
Received: from BY5PR03CA0001.namprd03.prod.outlook.com (2603:10b6:a03:1e0::11)
 by DM5PR03MB3324.namprd03.prod.outlook.com (2603:10b6:4:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2387.20; Mon, 28 Oct
 2019 16:33:23 +0000
Received: from BL2NAM02FT045.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::202) by BY5PR03CA0001.outlook.office365.com
 (2603:10b6:a03:1e0::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2387.20 via Frontend
 Transport; Mon, 28 Oct 2019 16:33:23 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT045.mail.protection.outlook.com (10.152.77.16) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2387.20
 via Frontend Transport; Mon, 28 Oct 2019 16:33:23 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x9SGXFOZ011724
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 28 Oct 2019 09:33:15 -0700
Received: from nsa.sphairon.box (10.44.3.90) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 28 Oct
 2019 12:33:22 -0400
From:   =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
To:     <linux-iio@vger.kernel.org>
CC:     Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        <Stable@vger.kernel.org>
Subject: [PATCH v2 2/2] iio: adis16480: Add debugfs_reg_access entry
Date:   Mon, 28 Oct 2019 17:33:49 +0100
Message-ID: <20191028163349.28866-2-nuno.sa@analog.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028163349.28866-1-nuno.sa@analog.com>
References: <20191028163349.28866-1-nuno.sa@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.44.3.90]
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(136003)(396003)(199004)(189003)(356004)(50466002)(4326008)(3846002)(4744005)(6116002)(50226002)(8936002)(6916009)(23676004)(7736002)(7636002)(305945005)(186003)(246002)(45776006)(76176011)(16526019)(86362001)(8676002)(26005)(446003)(11346002)(336012)(5660300002)(2906002)(2870700001)(70206006)(70586007)(54906003)(426003)(47776003)(53416004)(2351001)(478600001)(1076003)(36756003)(5820100001)(14444005)(5024004)(106002)(476003)(126002)(2616005)(316002)(6666004)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB3324;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c10c96a-1877-4fc9-fede-08d75bc48ce9
X-MS-TrafficTypeDiagnostic: DM5PR03MB3324:
X-Microsoft-Antispam-PRVS: <DM5PR03MB332401D1C13FAD89DE794E0199660@DM5PR03MB3324.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0204F0BDE2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqazfwLuDOLg23KebgCcWUI4nQhCSipkle9r1qeSIu8Azs/oeIBXLiv3MrbyuK0Kk5j0QeSoQC7K49UeeeNx0y/PDo3vh3RYlByM7ok9EW1dE2PHOJgaj+VFVdElSbWn34kC7NpOzGThOMi3UP59HsftnMEeQkWeB/6qPp4Z3duWWKqiv/O/BOr+8iDzoE78OylGKgdqDlxQPUlVB90nUm31fyEVix8qt+zJLsE2oxl8hU32GFV1+VAk274ijT8O7l6VxCsCXW3XrMPsPCfnEBXnuACKMQI0NftnwstOaI4GjzfBKt2k1qxq3JBu7ie83oatiXPTqG0ozfJXyylD9zq90wNDvHXDkNvDOdd+gZj5ySbXD9iKJvUYo98DcsxlixfPCT/jPrzku2zUJ0h+V72m4jw2U+0FmON0CggSqx+xo2+XmzFymo9QCHUn6Z0Z
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2019 16:33:23.1587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c10c96a-1877-4fc9-fede-08d75bc48ce9
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3324
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_06:2019-10-28,2019-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 suspectscore=1 mlxlogscore=966
 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910280162
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver is defining debugfs entries by calling
`adis16480_debugfs_init()`. However, those entries are attached to the
iio_dev debugfs entry which won't exist if no debugfs_reg_access
callback is provided.

Fixes: 2f3abe6cbb6c ("iio:imu: Add support for the ADIS16480 and similar IMUs")
Cc: <Stable@vger.kernel.org>

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
---
Changes in v2:
 * Add a Fixes tag and Cc stable.

 drivers/iio/imu/adis16480.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index 3b53bbb11bfb..94aa1c57e605 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -921,6 +921,7 @@ static const struct iio_info adis16480_info = {
 	.read_raw = &adis16480_read_raw,
 	.write_raw = &adis16480_write_raw,
 	.update_scan_mode = adis_update_scan_mode,
+	.debugfs_reg_access = adis_debugfs_reg_access,
 };
 
 static int adis16480_stop_device(struct iio_dev *indio_dev)
-- 
2.23.0

