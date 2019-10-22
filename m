Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9056E04A6
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 15:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbfJVNNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 09:13:14 -0400
Received: from mx0a-00328301.pphosted.com ([148.163.145.46]:7284 "EHLO
        mx0a-00328301.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730197AbfJVNNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 09:13:14 -0400
Received: from pps.filterd (m0156134.ppops.net [127.0.0.1])
        by mx0a-00328301.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9MDDDnB019388;
        Tue, 22 Oct 2019 06:13:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=invensense.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt1; bh=jW5MSdLvEh0dQ9xCGcO4QpBgVxzORXI9QKxDkG7RnpE=;
 b=ypfftb6ILOBIoKPMOqILR5uU47COe4CobjNfhFaeLTBqVC9IDrBWc+3TmwrmxA6LrNvu
 QSF9vfX90VXKNdILjmYcmwJoLH7AL3+t8wIa8bcE2YogIuUiDrWzEs9bTOreTwlQ4zDg
 y6ZZMzlDwqWYR7XEoNePW/o3eHCzuyISFIzHLPKFGrFfNqjIJAqyO3lcwgELiLZgNzob
 jn7vzI1dbdhxfMYzgUGqJAZHwPG7tXFGhpJ6g/ap7aEEHgpjHYGNDPUZjTMJKGwHQtsn
 UJCOpXSUjZtS2R4qwu1dna2iYeHtjrXlMXEB/5JoaxJQAps/0doocgPpyS42VTYdOf/O jg== 
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2058.outbound.protection.outlook.com [104.47.33.58])
        by mx0a-00328301.pphosted.com with ESMTP id 2vr99ss6cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 06:13:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWoAsK+/zO5rhbjh6swbzyZnRU1NEH8W28/Y0E574cSD9qIXZTpKcjt7+2ZRNwSA4hSseFUopkCibfs3xLXSEUCnOVkjVMIuA2C231lp/OXa97to7FsIIhKYvTpTI7JLW0KmydpI4VbAHxzRMOYh7TBi+/+LywUxoSpGBg237K7ldRjw4Not69Q0qyOseGRzC3Xp8CIZkS+BMn7ukyPSU7mItgN0RXnjzJDet1dvC7BxjGMlJZ6beVxq+K6ytyvYv5eguieONQEgrWcX2WS9sqx50QqSVu1zBtRhiYD4jelhiYb7BdSw5lQqXpzvf1iFOKCwOOSzEseBKAE3z6yqcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jW5MSdLvEh0dQ9xCGcO4QpBgVxzORXI9QKxDkG7RnpE=;
 b=ZKRGpcJfDgbPShooF/gj69aLenczriNOP44gLJ15P6ffv3QLrscWXXOO0qMsAWch+nvytPYteJCuI56StuukOtBuymYwPXKQeQ6sKjzCBeLD5vt5Zm4UFjS2UzR4dRRY2OyK28L0n1I3BYQhwInBWsidgV0WC5+vToJocSLyxzdueXZkx7QSTzQ7yXnEH/b0KyQttVDSjWFP7GcaL7RjeFnXYR9Tz6mtbzAcmMxBEX/KXOtjaNhziFp7SsoM9PTo8w63WhNI/UsBFHpayxboetY9n7H3k8uBwsX3zHYnCjnQFLhquzSc66RuOioWR56SxmyExjYTZEXKk7YoPt/1gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=invensense.com; dmarc=pass action=none
 header.from=invensense.com; dkim=pass header.d=invensense.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=invensense.onmicrosoft.com; s=selector2-invensense-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jW5MSdLvEh0dQ9xCGcO4QpBgVxzORXI9QKxDkG7RnpE=;
 b=Q5O6K5vkLV1f/jE3o8oLDQO6fbPFMNGsaapnLzPQEI52vUJ5QnSFqTlJKRII7X08oUeKhZofHkImIgUI9O8F6YmmgTToCZs8iFNREk3qNcRMYqzsmWqQ0y6ghvjq9OMyBcu25cx1YVtna6BUZFTNojgn8FfmbdczpIfm0AaVkkU=
Received: from MN2PR12MB3373.namprd12.prod.outlook.com (20.178.242.33) by
 MN2PR12MB3679.namprd12.prod.outlook.com (10.255.86.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 13:13:07 +0000
Received: from MN2PR12MB3373.namprd12.prod.outlook.com
 ([fe80::6848:adab:f1a6:ed5c]) by MN2PR12MB3373.namprd12.prod.outlook.com
 ([fe80::6848:adab:f1a6:ed5c%7]) with mapi id 15.20.2367.022; Tue, 22 Oct 2019
 13:13:07 +0000
From:   Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "jic23@kernel.org" <jic23@kernel.org>,
        Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
Subject: [PATCH 4.19] iio: imu: inv_mpu6050: fix no data on MPU6050
Thread-Topic: [PATCH 4.19] iio: imu: inv_mpu6050: fix no data on MPU6050
Thread-Index: AQHViNpx3RGe6yP7CkOnWZpOu/AU6w==
Date:   Tue, 22 Oct 2019 13:13:07 +0000
Message-ID: <20191022131239.13847-1-jmaneyrol@invensense.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0122.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::14) To MN2PR12MB3373.namprd12.prod.outlook.com
 (2603:10b6:208:c8::33)
x-originating-ip: [77.157.193.39]
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44824be6-bfc1-4079-b07c-08d756f19415
x-ms-traffictypediagnostic: MN2PR12MB3679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB3679A145A0A4834A587DBBE0C4680@MN2PR12MB3679.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(346002)(376002)(39850400004)(189003)(199004)(2351001)(305945005)(80792005)(7736002)(6436002)(54906003)(4326008)(6486002)(316002)(107886003)(52116002)(6916009)(102836004)(478600001)(2501003)(36756003)(386003)(6506007)(26005)(66066001)(14454004)(50226002)(186003)(71190400001)(8676002)(3846002)(256004)(14444005)(71200400001)(86362001)(81166006)(8936002)(486006)(2616005)(1730700003)(81156014)(25786009)(476003)(5660300002)(5640700003)(99286004)(66946007)(6512007)(66446008)(64756008)(2906002)(66556008)(6116002)(66476007)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3679;H:MN2PR12MB3373.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: invensense.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3rqVODDt1aKnn0rsf3vfEZckIaVuO07iVMXwXhYP9EhgFQPWHgwLaKdiZBr2+OZtd+ElW7DPdzLDsP1DZpEK8O9Mg7myansRRTHIVlacsa3hdkmHVVAsNLjyBfoF6Ztb2WElA/9EoQvQfwXzS9MuROlZdFfimFbOoczWNTBKQb4Fou/OwgBt22WHofrO98ZrorvsN4Oe9lMsocS7Y/zmz+VAZDMDeNaVo3zbOTUyh8DzD9sSsbEPor+nRJKabwsU6OS28/Th0uYilJkhyI50la471szqHKQxEqhK94L2HQCVLHalVZSDzeGZr3+gJR2NDoBU+LGBtAp1hyd4AmpsP0XPyY0aUfosDYeK+hzEXbBm02dALZfXfg81GfzNgVKYgFzvaxkjolQG09G+hptGf70QgCZAOEg72Kh4/yNAByBXEkzcQ24s/BFCP5U59CVV
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: invensense.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44824be6-bfc1-4079-b07c-08d756f19415
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 13:13:07.2078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 462b3b3b-e42b-47ea-801a-f1581aac892d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bo5ScVH5FOx1tMNouYyQe7FoVFW6SZHluKoi0p0P+AAU4s3TfzewNGn+KUocuEY6iBgQAaLfuNKjXD7ZZhNVvJTdoG5lfjfzoGoQvEKz3nY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3679
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-22_03:2019-10-22,2019-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 mlxlogscore=808 spamscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910220121
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some chips have a fifo overflow bit issue where the bit is always
set. The result is that every data is dropped.

Change fifo overflow management by checking fifo count against
a maximum value.

Add fifo size in chip hardware set of values.

Fixes: f5057e7b2dba ("iio: imu: inv_mpu6050: better fifo overflow handling"=
)
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |  8 ++++++++
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |  2 ++
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c | 15 ++++++++++++---
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/i=
nv_mpu6050/inv_mpu_core.c
index d80ef468508a..59b1040ee4c7 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -96,48 +96,56 @@ static const struct inv_mpu6050_hw hw_info[] =3D {
 		.name =3D "MPU6050",
 		.reg =3D &reg_set_6050,
 		.config =3D &chip_config_6050,
+		.fifo_size =3D 1024,
 	},
 	{
 		.whoami =3D INV_MPU6500_WHOAMI_VALUE,
 		.name =3D "MPU6500",
 		.reg =3D &reg_set_6500,
 		.config =3D &chip_config_6050,
+		.fifo_size =3D 512,
 	},
 	{
 		.whoami =3D INV_MPU6515_WHOAMI_VALUE,
 		.name =3D "MPU6515",
 		.reg =3D &reg_set_6500,
 		.config =3D &chip_config_6050,
+		.fifo_size =3D 512,
 	},
 	{
 		.whoami =3D INV_MPU6000_WHOAMI_VALUE,
 		.name =3D "MPU6000",
 		.reg =3D &reg_set_6050,
 		.config =3D &chip_config_6050,
+		.fifo_size =3D 1024,
 	},
 	{
 		.whoami =3D INV_MPU9150_WHOAMI_VALUE,
 		.name =3D "MPU9150",
 		.reg =3D &reg_set_6050,
 		.config =3D &chip_config_6050,
+		.fifo_size =3D 1024,
 	},
 	{
 		.whoami =3D INV_MPU9250_WHOAMI_VALUE,
 		.name =3D "MPU9250",
 		.reg =3D &reg_set_6500,
 		.config =3D &chip_config_6050,
+		.fifo_size =3D 512,
 	},
 	{
 		.whoami =3D INV_MPU9255_WHOAMI_VALUE,
 		.name =3D "MPU9255",
 		.reg =3D &reg_set_6500,
 		.config =3D &chip_config_6050,
+		.fifo_size =3D 512,
 	},
 	{
 		.whoami =3D INV_ICM20608_WHOAMI_VALUE,
 		.name =3D "ICM20608",
 		.reg =3D &reg_set_6500,
 		.config =3D &chip_config_6050,
+		.fifo_size =3D 512,
 	},
 };
=20
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/in=
v_mpu6050/inv_mpu_iio.h
index e69a59659dbc..07c6214f3222 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -105,12 +105,14 @@ struct inv_mpu6050_chip_config {
  *  @name:      name of the chip.
  *  @reg:   register map of the chip.
  *  @config:    configuration of the chip.
+ *  @fifo_size:	size of the FIFO in bytes.
  */
 struct inv_mpu6050_hw {
 	u8 whoami;
 	u8 *name;
 	const struct inv_mpu6050_reg_map *reg;
 	const struct inv_mpu6050_chip_config *config;
+	size_t fifo_size;
 };
=20
 /*
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c b/drivers/iio/imu/i=
nv_mpu6050/inv_mpu_ring.c
index 548e042f7b5b..4f9c2765aa23 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -188,9 +188,6 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 			"failed to ack interrupt\n");
 		goto flush_fifo;
 	}
-	/* handle fifo overflow by reseting fifo */
-	if (int_status & INV_MPU6050_BIT_FIFO_OVERFLOW_INT)
-		goto flush_fifo;
 	if (!(int_status & INV_MPU6050_BIT_RAW_DATA_RDY_INT)) {
 		dev_warn(regmap_get_device(st->map),
 			"spurious interrupt with status 0x%x\n", int_status);
@@ -216,6 +213,18 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 	if (result)
 		goto end_session;
 	fifo_count =3D get_unaligned_be16(&data[0]);
+
+	/*
+	 * Handle fifo overflow by resetting fifo.
+	 * Reset if there is only 3 data set free remaining to mitigate
+	 * possible delay between reading fifo count and fifo data.
+	 */
+	nb =3D 3 * bytes_per_datum;
+	if (fifo_count >=3D st->hw->fifo_size - nb) {
+		dev_warn(regmap_get_device(st->map), "fifo overflow reset\n");
+		goto flush_fifo;
+	}
+
 	/* compute and process all complete datum */
 	nb =3D fifo_count / bytes_per_datum;
 	inv_mpu6050_update_period(st, pf->timestamp, nb);
--=20
2.17.1

