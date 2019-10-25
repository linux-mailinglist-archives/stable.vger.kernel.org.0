Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27DEFE4B6F
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 14:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfJYMpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 08:45:08 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:13182 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727890AbfJYMpI (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 25 Oct 2019 08:45:08 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9PCbfms006772;
        Fri, 25 Oct 2019 08:44:44 -0400
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2055.outbound.protection.outlook.com [104.47.49.55])
        by mx0a-00128a01.pphosted.com with ESMTP id 2vt9u0hhwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 25 Oct 2019 08:44:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmR7qO+bWUfnoDG4dxRcDDXyt/4ImQdEV1cQ6/vJwMQBJqA9TK7cposLMpvhj+T/96i1UDrnBSw6vuD2wGZEB6bC1IEXl87kYEgi83qnWIBonxuhD+zfzu8YptRtO2icwAHb+GLft4mMyLrGk+Ke2Qtc5N5KaOxYjgH5kSxK08qDOkxzROxv15ZVCc875ycZazxdngeOneDnz0V9IqVK0dJL9vBIgZVgmRwAITxwohLnGAsKczW5rT09EdVlTmi7l2lQIoXQRxnLXmT5RtgwDdrlE7AhAmaNc0j4EpEvS5ZSnlIcxGdl3FYeh1A/52MfTaVHAifWu7tGbIXvbVAsUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaoPVDDpWo/0uJqFDQf//ZyQvmvr0TF4dHWTmx/FVeQ=;
 b=JpKlfAsYDLwsn0/EtTSotqW2LxqGZ8fc1VOY2+2oWxnU3DOBRu3ahtafRNh5aKN6dzF4tEOtsvE1K25OwYcWChY2o/IjG97Ln/30Bb+0hwTyoa7qi27e6p0tA+toDBtvmvU18qt+rB29SIbWHAqIZe021ayB0u+JG8hJ0eik5UwLXBTmutlzsA+acDZFupWWmhQTzmVCvDCTxd6icpBk5QN8Az/CftCxnZFlUs8EgQLhxaSc4NOs1Gcvy1RhBKgcALzUx7rrga3WV7Ag2lLdSGICKGQu852qPaYsHjEnqfzZL5fCK55lP5J6YbG5bhROrZyNFFTULaPvy/MDczcfSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=metafoo.de smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaoPVDDpWo/0uJqFDQf//ZyQvmvr0TF4dHWTmx/FVeQ=;
 b=OrcFnaMagKSVo4l/+S+ov408/LTGa2X2gN92/cDLoCeVwFBUC4JYw2yXrvCNrcdRXXUA5JkDhl57EERB7cWPeq3CBjXFevpcjfqMzhcSp++3XCB+qyD6gqV0WNY2KjFoPz+/g/vhgE6CFpY92a7Njd8iMwvP/vcVDdL+pWgXbYs=
Received: from DM6PR03CA0040.namprd03.prod.outlook.com (2603:10b6:5:100::17)
 by CY4PR03MB2805.namprd03.prod.outlook.com (2603:10b6:903:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2387.22; Fri, 25 Oct
 2019 12:44:42 +0000
Received: from SN1NAM02FT022.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::205) by DM6PR03CA0040.outlook.office365.com
 (2603:10b6:5:100::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2387.22 via Frontend
 Transport; Fri, 25 Oct 2019 12:44:42 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT022.mail.protection.outlook.com (10.152.72.148) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2387.20
 via Frontend Transport; Fri, 25 Oct 2019 12:44:41 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x9PCiXKM020945
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 25 Oct 2019 05:44:33 -0700
Received: from nsa.sphairon.box (10.44.3.90) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 25 Oct
 2019 08:44:40 -0400
From:   =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
To:     <linux-iio@vger.kernel.org>
CC:     Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        <Stable@vger.kernel.org>
Subject: [PATCH 1/2] iio: adis16480: Fix scales factors
Date:   Fri, 25 Oct 2019 14:45:07 +0200
Message-ID: <20191025124508.166648-1-nuno.sa@analog.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.44.3.90]
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(39860400002)(346002)(199004)(189003)(70586007)(53416004)(6916009)(54906003)(106002)(6116002)(5820100001)(2870700001)(50466002)(14444005)(3846002)(8936002)(47776003)(316002)(186003)(16526019)(26005)(246002)(8676002)(23676004)(70206006)(356004)(6666004)(45776006)(7736002)(126002)(7636002)(486006)(476003)(86362001)(36756003)(1076003)(478600001)(5660300002)(4326008)(50226002)(2351001)(2906002)(426003)(2616005)(305945005)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2805;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3591173-9f54-4749-d938-08d759491b12
X-MS-TrafficTypeDiagnostic: CY4PR03MB2805:
X-Microsoft-Antispam-PRVS: <CY4PR03MB2805F526A58E4FD1A95FD0CA99650@CY4PR03MB2805.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02015246A9
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJB8HgR40LBbP+2Oie0YaLDK7FbWI7RYVOEv5af67zm048GZXEMuUNPZDEUPiw24fZW6E9hJtF48s9FjRHIn9XDN49rcYOSQDKsWbDoc5B+v1EyGDOrKfe5dKv1FKzHYSQ+adH0cZxg4O3ouk+CbJYxYbrbzXUVIRft/+ViLq9YZCUkb7LtnYTUfEb2O8er4/ETjmHkmGx9oeDib5XXbRRPRI8+7PmiPKtGINN8txTiWBGa/64v10tS6mj3w2q2fVC9c/cI7P686GWZLBKGVwC4L3f47043ELPUH27oEMMiCSCbnwopDrqfaIFc8yvAtmn9I9jrKojtMenCSvAvKTOdTeYxP34pvd9YzIIRXwd/ooQBJXFAXP+HA+P6Tl4nwiWTj2yZNwoNeEOB2Edqq97nT3PuBoNAL4H0vJMhrW6guHlTYkjjBu2J2L3S6bv9n
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2019 12:44:41.6738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3591173-9f54-4749-d938-08d759491b12
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2805
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-25_07:2019-10-25,2019-10-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxscore=0 phishscore=0 priorityscore=1501 adultscore=0
 suspectscore=1 bulkscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910250121
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes the scales for the gyroscope, accelerometer and
barometer. The pressure scale was just wrong. For the others, the scale
factors were not taking into account that a 32bit word is being read
from the device.

Fixes: 7abad1063deb ("iio: adis16480: Fix scale factors")
Fixes: 9fe09f1337ee ("iio: imu: adis16480: Add support for ADIS1649x family of devices")
Fixes: 49c4a18357c8 ("iio: imu: adis16480: Add support for ADIS16490")
Cc: <Stable@vger.kernel.org>

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
---
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

