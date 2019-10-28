Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9263E7662
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 17:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391044AbfJ1Qds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 12:33:48 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:62958 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730772AbfJ1Qds (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Oct 2019 12:33:48 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9SGS3Pv008703;
        Mon, 28 Oct 2019 12:33:24 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2050.outbound.protection.outlook.com [104.47.38.50])
        by mx0b-00128a01.pphosted.com with ESMTP id 2vvfwaddbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Oct 2019 12:33:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXNgrpr/WOi5YWNS8Lc8Biwjpw8yL4lOpGWq8v9HDdfhEd98qXicN0vZqc5PZrVo4BjfRQ/4kxnTumATwtEmn7cdhQv3uCOWbrAF/4hIN72LBHu0UULZEYChdWtd6t6YgZSoizvvPKhxLBKVLh4sp/B5w67I7NvNRweEeXCgO2rkNRT6b9Cj9pVtuEDEWzolcEXiXL+yhhsCvd2lfW7D6I5yIBTGi8NchZXbGo5/yAaESXRT3pvQOL0v0QGvLHbrCiP1X6sEqDDOqTcgUKNLfglYvqivWdA9NTGchmc/BTDh1q3qbI5zXTK5DxjEwDiDpXinJLuse0Xbo+av3oLInA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iObc/coGQXAPROVsLEDEUgjVqayMhZ2mNEgneG1I69o=;
 b=mx1XVzHPaCkNwRorCuUYUBzxn+kANAXNehxSAyNunZ1GH/MbAFlxqZMUVWhDLO26c/FBq1yhL0DMl5wXC38p/4po/utLlG6cJgGFfk8w1OStIGEgFZLcOi34cbh2zuMOo/2b0oXvxdBKyqwEzKEmw8GhvhSpcSEso6KMh5RWzRjdGffkszKjV37jxN4XgrL/4wOmWDyAldy3yichjgVTTWxWG4ABND6bQBMhSKfxhnOmFbtYPZCiiQEZkRiQjhL614x8cXYtMr89tWOLh0sahrSTFFSlkDZVc/eTtwrKe+x0fdFl5LbVcmU68HKJRbZI5WN+huY3ym6/9VhYmsx0xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=metafoo.de smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iObc/coGQXAPROVsLEDEUgjVqayMhZ2mNEgneG1I69o=;
 b=pdonVgPPIWSIhWGO3vbEfdp1rxDhTiiAYrAjOdkijwkxrZhc2XUMfFDAZ7rFebw7Nuh09xD3PD6dGjF/0qKtlMOqioCsosTSfWf0VPtF3+UeIh+65zwkjBnQ1cCvtz0D9E/hgGKX5BwiPI2hELC8yR6Zp6BSiayBVxoYUS6CYsc=
Received: from DM6PR03CA0037.namprd03.prod.outlook.com (2603:10b6:5:100::14)
 by DM5PR03MB3307.namprd03.prod.outlook.com (2603:10b6:4:43::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2387.20; Mon, 28 Oct
 2019 16:33:22 +0000
Received: from BL2NAM02FT064.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::207) by DM6PR03CA0037.outlook.office365.com
 (2603:10b6:5:100::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2387.20 via Frontend
 Transport; Mon, 28 Oct 2019 16:33:22 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT064.mail.protection.outlook.com (10.152.77.119) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2387.20
 via Frontend Transport; Mon, 28 Oct 2019 16:33:21 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x9SGXD6X011714
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 28 Oct 2019 09:33:14 -0700
Received: from nsa.sphairon.box (10.44.3.90) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 28 Oct
 2019 12:33:20 -0400
From:   =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
To:     <linux-iio@vger.kernel.org>
CC:     Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        <Stable@vger.kernel.org>
Subject: [PATCH v2 1/2] iio: adis16480: Fix scales factors
Date:   Mon, 28 Oct 2019 17:33:48 +0100
Message-ID: <20191028163349.28866-1-nuno.sa@analog.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.44.3.90]
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(376002)(396003)(199004)(189003)(53416004)(305945005)(6916009)(478600001)(5660300002)(36756003)(2870700001)(486006)(23676004)(2906002)(2351001)(7636002)(14444005)(26005)(186003)(4326008)(16526019)(7736002)(45776006)(126002)(2616005)(246002)(1076003)(356004)(106002)(426003)(54906003)(336012)(47776003)(50466002)(476003)(6116002)(3846002)(70206006)(70586007)(86362001)(6666004)(8936002)(8676002)(5820100001)(50226002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB3307;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4d3b022-7c3c-41d2-98e0-08d75bc48c1e
X-MS-TrafficTypeDiagnostic: DM5PR03MB3307:
X-Microsoft-Antispam-PRVS: <DM5PR03MB3307636DA1E99FA12DF9394B99660@DM5PR03MB3307.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0204F0BDE2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xCwpFsF6TK8HA+jjoxLtkRmy3fwAYaVNTpC4SYIG4ZP6wMwwPqZoBF1v3GeMYdeCPs/oYRnOrWs5XVfMfsnK2EjbIEqQLEJAG3MvzJqRTV7ZYej0xYClNJoCBieQ0xV6IgYA6iiZFYVsvzk7wkg22n4gedtoL2VuunReDZvrgNQRiLB8z4m3pwvVvnoAUPFv/KUhi4IjvOgQzxXhlBa7XOSx/+dc5oBh/rXzGVFQz+SZcT2YOrPvq/jH03Qkt4oTVMDZDdCb3kCw9Tjn+WDApG1zwSFavfnH91jg+iF43e4Yn9DR6IGbtp1LWiITOK0Nl/UBp9cwwY1UhXVTUCfsyMlqIPp7vu4dL43i2rBlS/CbK/td55dom4Vr8BrTHeEx7dbgJTqFKn/75CyylvfWf5VZBp5mpeMepYROj+9JAK+7GTbhDyNWi4qCgQJI3Lvi
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2019 16:33:21.8057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d3b022-7c3c-41d2-98e0-08d75bc48c1e
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3307
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-28_06:2019-10-28,2019-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 suspectscore=1 priorityscore=1501 bulkscore=0 adultscore=0 mlxscore=0
 clxscore=1015 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910280162
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes the scales for the gyroscope, accelerometer and
barometer. The pressure scale was just wrong. For the others, the scale
factors were not taking into account that a 32bit word is being read
from the device.

Fixes: 7abad1063deb ("iio: adis16480: Fix scale factors")
Fixes: 82e7a1b25017 ("iio: imu: adis16480: Add support for ADIS1649x family of devices")
Cc: <Stable@vger.kernel.org>

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
---
Changes in v2:
 * Correct the Fixes tag.

 drivers/iio/imu/adis16480.c | 77 ++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index b99d73887c9f..3b53bbb11bfb 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -620,9 +620,13 @@ static int adis16480_read_raw(struct iio_dev *indio_dev,
 			*val2 = (st->chip_info->temp_scale % 1000) * 1000;
 			return IIO_VAL_INT_PLUS_MICRO;
 		case IIO_PRESSURE:
-			*val = 0;
-			*val2 = 4000; /* 40ubar = 0.004 kPa */
-			return IIO_VAL_INT_PLUS_MICRO;
+			/*
+			 * max scale is 1310 mbar
+			 * max raw value is 32767 shifted for 32bits
+			 */
+			*val = 131; /* 1310mbar = 131 kPa */
+			*val2 = 32767 << 16;
+			return IIO_VAL_FRACTIONAL;
 		default:
 			return -EINVAL;
 		}
@@ -783,13 +787,14 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
 		/*
-		 * storing the value in rad/degree and the scale in degree
-		 * gives us the result in rad and better precession than
-		 * storing the scale directly in rad.
+		 * Typically we do IIO_RAD_TO_DEGREE in the denominator, which
+		 * is exactly the same as IIO_DEGREE_TO_RAD in numerator, since
+		 * it gives better approximation. However, in this case we
+		 * cannot do it since it would not fit in a 32bit variable.
 		 */
-		.gyro_max_val = IIO_RAD_TO_DEGREE(22887),
-		.gyro_max_scale = 300,
-		.accel_max_val = IIO_M_S_2_TO_G(21973),
+		.gyro_max_val = 22887 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(300),
+		.accel_max_val = IIO_M_S_2_TO_G(21973 << 16),
 		.accel_max_scale = 18,
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
@@ -799,9 +804,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16480] = {
 		.channels = adis16480_channels,
 		.num_channels = ARRAY_SIZE(adis16480_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(22500),
-		.gyro_max_scale = 450,
-		.accel_max_val = IIO_M_S_2_TO_G(12500),
+		.gyro_max_val = 22500 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(450),
+		.accel_max_val = IIO_M_S_2_TO_G(12500 << 16),
 		.accel_max_scale = 10,
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
@@ -811,9 +816,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16485] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(22500),
-		.gyro_max_scale = 450,
-		.accel_max_val = IIO_M_S_2_TO_G(20000),
+		.gyro_max_val = 22500 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(450),
+		.accel_max_val = IIO_M_S_2_TO_G(20000 << 16),
 		.accel_max_scale = 5,
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
@@ -823,9 +828,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16488] = {
 		.channels = adis16480_channels,
 		.num_channels = ARRAY_SIZE(adis16480_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(22500),
-		.gyro_max_scale = 450,
-		.accel_max_val = IIO_M_S_2_TO_G(22500),
+		.gyro_max_val = 22500 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(450),
+		.accel_max_val = IIO_M_S_2_TO_G(22500 << 16),
 		.accel_max_scale = 18,
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
@@ -835,9 +840,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16495_1] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(20000),
-		.gyro_max_scale = 125,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 20000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(125),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 8,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
@@ -848,9 +853,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16495_2] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(18000),
-		.gyro_max_scale = 450,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 18000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(450),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 8,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
@@ -861,9 +866,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16495_3] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(20000),
-		.gyro_max_scale = 2000,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 20000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(2000),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 8,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
@@ -874,9 +879,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16497_1] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(20000),
-		.gyro_max_scale = 125,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 20000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(125),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 40,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
@@ -887,9 +892,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16497_2] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(18000),
-		.gyro_max_scale = 450,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 18000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(450),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 40,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
@@ -900,9 +905,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16497_3] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(20000),
-		.gyro_max_scale = 2000,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 20000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(2000),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 40,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
-- 
2.23.0

