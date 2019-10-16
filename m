Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE3FD9426
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 16:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404711AbfJPOnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 10:43:35 -0400
Received: from mx0a-00328301.pphosted.com ([148.163.145.46]:43832 "EHLO
        mx0a-00328301.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727291AbfJPOnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 10:43:35 -0400
Received: from pps.filterd (m0156134.ppops.net [127.0.0.1])
        by mx0a-00328301.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GEhXSN016092;
        Wed, 16 Oct 2019 07:43:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=invensense.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt1; bh=Oe+LcsYBJ2XqbtmjP9/DiKqwdex2bLIXpH2pkRxtpXs=;
 b=PIyXzkzNWIk9xLHJv1i8nNscMe4mNhiA22L3EDmllOoaVfZYSrTcVoPl358n2ttppUXs
 SJFG+vnpOrJL5YGClVbzcQRiBFz4qhKuJfwziHB42uksLs40G2EeEhyIRGVQkZfYfVm4
 +tN3zQlzT5dN5olEW195cG7KLhNJuKiHo4G36mEc5HcGuiAMJsgCHy3N1n2tP4JrCzYT
 koMdovwdXJK+UvK+8SSYZMkcxQI/MRdcXJ+2iWLxFeAjxMvtFN/xn0W2bIIQgJyBq0hP
 JbSQmCur678ZHHyC9Z2zGBFU/VAhKBzC8rqJn6SWE/3pQgvXNHCO4XO+HgFUCy54rdIL xw== 
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2053.outbound.protection.outlook.com [104.47.44.53])
        by mx0a-00328301.pphosted.com with ESMTP id 2vp26082xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Oct 2019 07:43:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpVopONIHKgsSpasRAhXKXgmo2Ia4qQHWa1NidtErAE02W1SclQPcR91ZHVNL6cqiSgr/ssa4rVjgcKb2Yrbh3jw/jCq6alxUmL0MGwJMdnNKKCNIMfS1FRevWb2pX2g6v1vkKy5iaRUmvW7csDSIEepxTi9mcv2rmPmO2/S+ZxueyatgndRAxsZD2d80Z6QLYB4/jjvj4e/vw8CXQPYNty6qGtsNyPwC11vcE/6oC3peVCwEFM6d7JkYYm9WZEsIDQKg6gL/5KghjiZnHKy25Z9AtfnODkhYtcQ99u0v9blwKZ+EO+Q7YswoZsCqKofIWim2X6O+aalwiY0uHavIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oe+LcsYBJ2XqbtmjP9/DiKqwdex2bLIXpH2pkRxtpXs=;
 b=htRBXzfunv8y1VFTeZ+xVnwo8kNigWltCt+7rtbkynhdOeLsRTQtY9ZKYbBZ2gSbmFoZ1iA8eG+WajfyJ903OxxQJD7V08RWPT6uuwc0aOY3bIvk+qkQeG6x5QyHjI/ixx3Q5syzUVsCDCf1g5ZMWO5q0B9uYVZt64bOyD0J46KnyLWkVDMjdzg5P3nceXgfzi+mGaNz+cuo3tEXg4N6syNSAKaNwz07UqPjXCqobEKCqXdcL28nH0oXrOmlsf+91aaPGyDLuWiaNyr/GIy7VPzJlNvCAirAoPSSEUQHzxfV9RQa3EX67OoPvBynouk7ww1o6FkQQyR1xtkDDaU3hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=invensense.com; dmarc=pass action=none
 header.from=invensense.com; dkim=pass header.d=invensense.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=invensense.onmicrosoft.com; s=selector2-invensense-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oe+LcsYBJ2XqbtmjP9/DiKqwdex2bLIXpH2pkRxtpXs=;
 b=IHKJQpu/uVXCJWKMk16cxMeHEG3sUTkiEt8LCu0IYkjDZAYnTU9p/9QObqWIUkK+KtwkuxGN/kh8Z2NOLr0iU2prTa0PJ+yK7HxMNlYN5m7LJ4EklPn/bupn28aHakKJVI+F0AAD+TxiBkDKD1BJUMIYMSWGZrxtwlguCvYYJTY=
Received: from MN2PR12MB3373.namprd12.prod.outlook.com (20.178.242.33) by
 MN2PR12MB3678.namprd12.prod.outlook.com (10.255.239.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 14:43:29 +0000
Received: from MN2PR12MB3373.namprd12.prod.outlook.com
 ([fe80::6848:adab:f1a6:ed5c]) by MN2PR12MB3373.namprd12.prod.outlook.com
 ([fe80::6848:adab:f1a6:ed5c%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 14:43:29 +0000
From:   Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
To:     "jic23@kernel.org" <jic23@kernel.org>
CC:     "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Jean-Baptiste Maneyrol <JManeyrol@invensense.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] iio: imu: inv_mpu6050: fix no data on MPU6050
Thread-Topic: [PATCH] iio: imu: inv_mpu6050: fix no data on MPU6050
Thread-Index: AQHVhDASArllQyaXq0KVhUVGPYjiuQ==
Date:   Wed, 16 Oct 2019 14:43:28 +0000
Message-ID: <20191016144253.24554-1-jmaneyrol@invensense.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0363.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::15) To MN2PR12MB3373.namprd12.prod.outlook.com
 (2603:10b6:208:c8::33)
x-originating-ip: [77.157.193.39]
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c579ebb-8d84-471f-6adb-08d75247355c
x-ms-traffictypediagnostic: MN2PR12MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB3678A2D693FBC6E442D223E8C4920@MN2PR12MB3678.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39850400004)(396003)(376002)(136003)(366004)(189003)(199004)(99286004)(8936002)(52116002)(6512007)(54906003)(80792005)(26005)(7736002)(2351001)(186003)(25786009)(6486002)(2906002)(2501003)(6506007)(386003)(5640700003)(1076003)(50226002)(102836004)(4326008)(8676002)(14444005)(71190400001)(66556008)(316002)(256004)(71200400001)(81156014)(478600001)(6916009)(36756003)(6436002)(305945005)(64756008)(66446008)(66066001)(86362001)(66946007)(5660300002)(476003)(14454004)(486006)(6116002)(3846002)(66476007)(81166006)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3678;H:MN2PR12MB3373.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: invensense.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QReCYXGIo23PmitODy1esQTqvu41jKUe3Sn1KuDuxgNebfLy9JoU2AGiofDa2qBgdAyXXZfBPJTNApcdb/BcUc/NpeNqGB6ttgMttz6vJVVKxEsO2d9TgCev6SUrItC7m9ww1eehImkc7p990kBHL2wWLYiB41n5kWeXdkMvpZV2eehERO736e1QQDHxKFLGGRHBZF0zg5lHNFrtWZwM2VO0EZx76r120f8U2lZw6v+R1zbdXNpOZTt+/5lzkOn6xRuB9YNmPKkXmGj6X3gkBSPvpoOnNih4yka1msRmqg+hF4nUZapdGW0DjHODmdmX5UtiLBLxtSMc9hL4Z/7fCcXPnropc20f5I31v0DrsPY2FNU5jPAQI3dbj4EWWKVb/Ja6hFY8kkF9ncnS09sLn3TKSuc58w9RjIbjbEfz3FU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: invensense.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c579ebb-8d84-471f-6adb-08d75247355c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 14:43:29.0507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 462b3b3b-e42b-47ea-801a-f1581aac892d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bNKH2DKVNMqqGdh5J8zTufQA8y8noxaqL3ZFQfIFYX5FPAGMor6k/MHgxUsHJFEr8nlkWR01TI+/HF8ikWkFlsiWOS4gPL7xw2Q5kwRBtEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3678
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_06:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 phishscore=0
 bulkscore=0 clxscore=1011 mlxlogscore=854 spamscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910160127
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
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |  9 +++++++++
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |  2 ++
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c | 15 ++++++++++++---
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/i=
nv_mpu6050/inv_mpu_core.c
index 354030e9bed5..9f9acde229c8 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -116,54 +116,63 @@ static const struct inv_mpu6050_hw hw_info[] =3D {
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
 	{
 		.whoami =3D INV_ICM20602_WHOAMI_VALUE,
 		.name =3D "ICM20602",
 		.reg =3D &reg_set_icm20602,
 		.config =3D &chip_config_6050,
+		.fifo_size =3D 1008,
 	},
 };
=20
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/in=
v_mpu6050/inv_mpu_iio.h
index 52fcf45050a5..5f6bbe880d78 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -106,12 +106,14 @@ struct inv_mpu6050_chip_config {
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
index bbf68b474556..8d1b162e4f64 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -183,9 +183,6 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 			"failed to ack interrupt\n");
 		goto flush_fifo;
 	}
-	/* handle fifo overflow by reseting fifo */
-	if (int_status & INV_MPU6050_BIT_FIFO_OVERFLOW_INT)
-		goto flush_fifo;
 	if (!(int_status & INV_MPU6050_BIT_RAW_DATA_RDY_INT)) {
 		dev_warn(regmap_get_device(st->map),
 			"spurious interrupt with status 0x%x\n", int_status);
@@ -218,6 +215,18 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
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

