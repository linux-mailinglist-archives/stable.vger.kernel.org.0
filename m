Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD0610A1E1
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 17:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfKZQTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 11:19:52 -0500
Received: from mx0a-00328301.pphosted.com ([148.163.145.46]:60208 "EHLO
        mx0a-00328301.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726101AbfKZQTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 11:19:52 -0500
Received: from pps.filterd (m0156134.ppops.net [127.0.0.1])
        by mx0a-00328301.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQGBfBr009357;
        Tue, 26 Nov 2019 08:19:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=invensense.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=pfpt1;
 bh=+ndRgLfGy+YOow2PBv1QtiCFVRAkX0IrkeUcPKnklY8=;
 b=NBjMm5DQlfoLNgGrMJDc+imK4h6dCI0kCoEsWKpyqGEfttGEltSdX3oxbJzBYMXLehfX
 W2flmUhPHO/Z2RVaRmgLn/fExBk3XL8+Eld1oYFhkrhm4fhJqubai6iUK/4mKFvc7jCX
 dk+magy55pk4y4cDQGaM8ePCm2VUHf3qGbCo+WHn4XdY0DRk4fUY86Euo9rH5yPG00/s
 cApQNHMgDJIP5ywRtDx/GqKBXOraRG0MrH++a1Iu9MrN1OMcb7FYO6NccHHGf4ky1xhR
 aKQsqKgMEQZaqlwFv6/8tS0KZBW2/l0GX9wNRt13YklOPSXYTJiMxifcGKiD+uQ+gC41 Eg== 
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2050.outbound.protection.outlook.com [104.47.46.50])
        by mx0a-00328301.pphosted.com with ESMTP id 2wf14thmdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 08:19:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIx0k7QcUncfK7UxCCQfx26qg9XZa7U9Yyvy1KdXaCSsiXusejBJd4V5qYAmnLXhb08yluqquZysYy+nP8ue6Jfnfn9Xy0APIAdFF7kUN2Crej0ES2q2b4Gm4lS2b4nB0TCgol/KPP0+5Tkg5JrbhLvVuRDNRJxNJFJK8xzA6zQsDLfD5MGTnntY02uxV2/i1jNSS1YRObxMwFiNdDNA6L2b6ohz2iYzWzHKHT7cfwuh8FCNwom4kGCg2QsaTbn+ghdC6t6eUua1BHjXDp7k8OqgRXZ8ksS4hAGqCiYVDkhMZxuvp3BeJfxupAnJI+dGj2lc05i2PkAqpRbRig8uaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ndRgLfGy+YOow2PBv1QtiCFVRAkX0IrkeUcPKnklY8=;
 b=mLTIN50NgMnV8x60aNtPeizPpy9cbvj81oqQQbMkrgQc8xw3ahXGuLCPyYixYbEnkUwDTsD1UO50Zkkt8zwWkVDTZkjJY9GKZvVbTe/AXVuc9fbDykXHk9E6/mCkpaE3mmseF4YjhXEP0kh+8VO5n0f6zQYK+momjposSy+Uv7RI5ZM2WVRwC2czPYrc2BpOsZ6BcXvXDIuCLZ45WDcvra7fEKqp+k4W2uatFBVIH8XcUDTaPXR4H0ATLVdtXu0FF+ZBrQZrY/ti1fB8o1E5otfylrRA0ao/TVLvIexwB9u2rVSueVub7PPb53spUT+fwZnwXT1J4LT/vH7d2LPsxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=invensense.com; dmarc=pass action=none
 header.from=invensense.com; dkim=pass header.d=invensense.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=invensense.onmicrosoft.com; s=selector2-invensense-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ndRgLfGy+YOow2PBv1QtiCFVRAkX0IrkeUcPKnklY8=;
 b=dyayK0aTXn0eveZmQ/POR+RVECyHCZOVu6cAYQ0Lf7+pom0uVxsa2NKSW1L0YfzEdtF9rD7VMCUVAQQajI979ion6s0l+8K58wjtElVjkYS1xXwv/aJXzzBkzMgF6vf4tQNl+XFYBeqlBK/k/5NE6rsbUrNOdYV6O+PPZIWlOIU=
Received: from MN2PR12MB3373.namprd12.prod.outlook.com (20.178.242.33) by
 MN2PR12MB3230.namprd12.prod.outlook.com (20.179.84.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Tue, 26 Nov 2019 16:19:47 +0000
Received: from MN2PR12MB3373.namprd12.prod.outlook.com
 ([fe80::95a9:35cd:3e40:8ed3]) by MN2PR12MB3373.namprd12.prod.outlook.com
 ([fe80::95a9:35cd:3e40:8ed3%3]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 16:19:46 +0000
From:   Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
To:     jic23@kernel.org
Cc:     linux-iio@vger.kernel.org,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] iio: imu: inv_mpu6050: fix temperature reporting using bad unit
Date:   Tue, 26 Nov 2019 17:19:12 +0100
Message-Id: <20191126161912.24683-1-jmaneyrol@invensense.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0056.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::20) To MN2PR12MB3373.namprd12.prod.outlook.com
 (2603:10b6:208:c8::33)
MIME-Version: 1.0
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [77.157.193.39]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7efdad38-1e48-4cf9-ccec-08d7728c742d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3230:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB32305CAA044C0F169E48E26BC4450@MN2PR12MB3230.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0233768B38
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(376002)(136003)(366004)(39850400004)(346002)(396003)(189003)(199004)(50226002)(478600001)(305945005)(7736002)(6916009)(52116002)(2616005)(6666004)(36756003)(2906002)(25786009)(86362001)(81166006)(66946007)(50466002)(47776003)(16586007)(4326008)(51416003)(66476007)(8936002)(6436002)(6486002)(1076003)(8676002)(48376002)(14454004)(80792005)(99286004)(2351001)(386003)(6506007)(66066001)(316002)(6116002)(26005)(3846002)(186003)(6512007)(5660300002)(66556008)(81156014)(2361001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3230;H:MN2PR12MB3373.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: invensense.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2hruaan0yvnlr6WDGTcpuD0EWIe4G3PQcElRl6UIOQ3atAB5wzMBlezXfv1FlWG4QOMlwbzAML+Uy3aBFfJKwup1nGClpvSStN+S8a1P0LMFnylzirKJyF4+bQ0yddZOj+N5UOeoVe+BEUDLcAtUjcdVq3/O/O0cPT+5lhnoRf4YwjgBb13udzzgHVaTbrx30/3jai0iUQt+rHQPDJi4FRiWDmsgyBVbZcwxzPNgLOy6PWBfy2aMxsJ48erj0A+QW4pkg/Dysz9FHybyqVPbt2V0RylpsiHpNo/y1F8d3jPFcexNimZylkbyByFdnijvqdXeeP2ABAluZ703E21dl8zjWoIGYmpJXwTiTnrDy5Ob6zU6v1vFn6R94bJ7u6nt3ad/6E9bc1hRbcbgaTHvTVtR2nBi+TA3/WRAm4ray6HR661JUJzcum2PHtZYSxqQ
X-OriginatorOrg: invensense.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7efdad38-1e48-4cf9-ccec-08d7728c742d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2019 16:19:46.9059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 462b3b3b-e42b-47ea-801a-f1581aac892d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iO8MiKut49F8KExAmr9cz8JpRP66q22C5gonmSkTWa7wrS2XMja4WiLAJy5ajDJImxhrGc5OlQAJo36Kp0aNKsGBh16CCnDizHWSsTWtEak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3230
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_04:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911260138
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Temperature should be reported in milli-degrees, not degrees. Fix
scale and offset values to use the correct unit.

Fixes: 1615fe41a195 ("iio: imu: mpu6050: Fix FIFO layout for ICM20602")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 23 +++++++++++-----------
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  | 16 +++++++++++----
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index 23c0557891a0..268240644adf 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -117,6 +117,7 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
 		.fifo_size = 1024,
+		.temp = {INV_MPU6050_TEMP_OFFSET, INV_MPU6050_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU6500_WHOAMI_VALUE,
@@ -124,6 +125,7 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 		.fifo_size = 512,
+		.temp = {INV_MPU6500_TEMP_OFFSET, INV_MPU6500_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU6515_WHOAMI_VALUE,
@@ -131,6 +133,7 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 		.fifo_size = 512,
+		.temp = {INV_MPU6500_TEMP_OFFSET, INV_MPU6500_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU6000_WHOAMI_VALUE,
@@ -138,6 +141,7 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
 		.fifo_size = 1024,
+		.temp = {INV_MPU6050_TEMP_OFFSET, INV_MPU6050_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU9150_WHOAMI_VALUE,
@@ -145,6 +149,7 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
 		.fifo_size = 1024,
+		.temp = {INV_MPU6050_TEMP_OFFSET, INV_MPU6050_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU9250_WHOAMI_VALUE,
@@ -152,6 +157,7 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 		.fifo_size = 512,
+		.temp = {INV_MPU6500_TEMP_OFFSET, INV_MPU6500_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_MPU9255_WHOAMI_VALUE,
@@ -159,6 +165,7 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 		.fifo_size = 512,
+		.temp = {INV_MPU6500_TEMP_OFFSET, INV_MPU6500_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_ICM20608_WHOAMI_VALUE,
@@ -166,6 +173,7 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
 		.fifo_size = 512,
+		.temp = {INV_ICM20608_TEMP_OFFSET, INV_ICM20608_TEMP_SCALE},
 	},
 	{
 		.whoami = INV_ICM20602_WHOAMI_VALUE,
@@ -173,6 +181,7 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.reg = &reg_set_icm20602,
 		.config = &chip_config_6050,
 		.fifo_size = 1008,
+		.temp = {INV_ICM20608_TEMP_OFFSET, INV_ICM20608_TEMP_SCALE},
 	},
 };
 
@@ -481,12 +490,8 @@ inv_mpu6050_read_raw(struct iio_dev *indio_dev,
 
 			return IIO_VAL_INT_PLUS_MICRO;
 		case IIO_TEMP:
-			*val = 0;
-			if (st->chip_type == INV_ICM20602)
-				*val2 = INV_ICM20602_TEMP_SCALE;
-			else
-				*val2 = INV_MPU6050_TEMP_SCALE;
-
+			*val = st->hw->temp.scale / 1000000;
+			*val2 = st->hw->temp.scale % 1000000;
 			return IIO_VAL_INT_PLUS_MICRO;
 		case IIO_MAGN:
 			return inv_mpu_magn_get_scale(st, chan, val, val2);
@@ -496,11 +501,7 @@ inv_mpu6050_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_OFFSET:
 		switch (chan->type) {
 		case IIO_TEMP:
-			if (st->chip_type == INV_ICM20602)
-				*val = INV_ICM20602_TEMP_OFFSET;
-			else
-				*val = INV_MPU6050_TEMP_OFFSET;
-
+			*val = st->hw->temp.offset;
 			return IIO_VAL_INT;
 		default:
 			return -EINVAL;
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
index f1fb7b6bdab1..b096e010d4ee 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -107,6 +107,7 @@ struct inv_mpu6050_chip_config {
  *  @reg:   register map of the chip.
  *  @config:    configuration of the chip.
  *  @fifo_size:	size of the FIFO in bytes.
+ *  @temp:	offset and scale to apply to raw temperature.
  */
 struct inv_mpu6050_hw {
 	u8 whoami;
@@ -114,6 +115,10 @@ struct inv_mpu6050_hw {
 	const struct inv_mpu6050_reg_map *reg;
 	const struct inv_mpu6050_chip_config *config;
 	size_t fifo_size;
+	struct {
+		int offset;
+		int scale;
+	} temp;
 };
 
 /*
@@ -279,16 +284,19 @@ struct inv_mpu6050_state {
 #define INV_MPU6050_REG_UP_TIME_MIN          5000
 #define INV_MPU6050_REG_UP_TIME_MAX          10000
 
-#define INV_MPU6050_TEMP_OFFSET	             12421
-#define INV_MPU6050_TEMP_SCALE               2941
+#define INV_MPU6050_TEMP_OFFSET	             12420
+#define INV_MPU6050_TEMP_SCALE               2941176
 #define INV_MPU6050_MAX_GYRO_FS_PARAM        3
 #define INV_MPU6050_MAX_ACCL_FS_PARAM        3
 #define INV_MPU6050_THREE_AXIS               3
 #define INV_MPU6050_GYRO_CONFIG_FSR_SHIFT    3
 #define INV_MPU6050_ACCL_CONFIG_FSR_SHIFT    3
 
-#define INV_ICM20602_TEMP_OFFSET	     8170
-#define INV_ICM20602_TEMP_SCALE		     3060
+#define INV_MPU6500_TEMP_OFFSET              7011
+#define INV_MPU6500_TEMP_SCALE               2995178
+
+#define INV_ICM20608_TEMP_OFFSET	     8170
+#define INV_ICM20608_TEMP_SCALE		     3059976
 
 /* 6 + 6 + 7 (for MPU9x50) = 19 round up to 24 and plus 8 */
 #define INV_MPU6050_OUTPUT_DATA_SIZE         32
-- 
2.17.1

