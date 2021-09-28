Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676EA41B2C8
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 17:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241471AbhI1PSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 11:18:39 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:24308 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241473AbhI1PSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 11:18:35 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SEbVuE013175;
        Tue, 28 Sep 2021 15:16:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=KU0zgooPe+pFzkZOEoR8cr5WimE66OGJbsyLhvfgSUc=;
 b=MYcWR9uTi17+DG8M/HqmdYhVPgbuowvHSfFnDmXuZ/+9tG0qgGLEvOuEr9KwcydrnAb8
 /Zzf7Q4R3jHdv6TWFQzFGUP8asyCFVLcgbFC/vhm/QPSISwAYAgsVdRBZLa8otD4Keow
 FJpEZejysJ9QOCwGKeSptQvI42OPk+A1rHAVIrQ0PZRVUfzVYEhpTAs0cu05kyX60UZo
 9s/bweRGOODt48s/Ud45k9cIUkUWTBcjQe3LWts2i7ISqpG88Gsra36Z/BTRrwlMlcgh
 d2zdozqiKbnQIFGiDcds2GPIw4h/FROn7HUG88J0dTs7LY+eSnaHfQSWkr5rRnBmgMgi JA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bc0qfr9a4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 15:16:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URoc7ieHsxZyySNqI5ShxAPyYAX5HkP+IrKKIGj68lRkkdmvJK1OIe+e6ZF4gIbn6weLQN7XXPxnBaNaFrMOSqDVgANeb0fUVc9+f+31TVKYBNytv1Fi1q4qTGV4bH8M1+cJixcUQThhvCeYM/JlmmWzMt4CwO+hkY2/Su+tnxbRcC1Wakx4/LeJlW9q/jJbUxveLh8vtW5Xj9kiQhy98podzdRP+dhTj5mNCh3+RvcYKukU/KekKSXSiz/tTW17XJqfQGIZje5ZhvAYCZBvDANQwHqkn8axlLd9CGL55uVJiUip3qRXfkFMCCjiVA/lzfxVh14vwzyqtLGaEl96Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KU0zgooPe+pFzkZOEoR8cr5WimE66OGJbsyLhvfgSUc=;
 b=lVqsjsolF0du8x+0w4mtvDEN51imhmAe9uQNlsPFaBx9mEPAwML+JWuo3ZqOM6hb2/tS/xa2mAAoU7ngMvJTPumR9veKQz4Ft6zyJc2MsafzYfMwQN6Guo0CHfd95H9+leVku+9f+VCC4u+7wfprqsLqILEjZnlmtP7wrGxEv8qHzIpl+yWhwClpcJmnSXDRwBxFIfCvOzwI+GVO6lkDzZ4jf6NBHP1+X74VpRHCXF7wOVE0ZLTs8uSXe+yCk3WB0jhVPwpxkaBlY++u0n+IixWqxVUwRJsB1p8bbQ31Nl8g3DHvN5hN71yoZ6Giph9bKChrNRMPrYoi4sr6AhHsEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3609.namprd11.prod.outlook.com (2603:10b6:5:140::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 15:16:46 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 15:16:46 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 4.14 2/3] usb: hso: fix error handling code of hso_create_net_device
Date:   Tue, 28 Sep 2021 18:15:43 +0300
Message-Id: <20210928151544.270412-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928151544.270412-1-ovidiu.panait@windriver.com>
References: <20210928151544.270412-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0019.eurprd05.prod.outlook.com
 (2603:10a6:800:92::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0019.eurprd05.prod.outlook.com (2603:10a6:800:92::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 15:16:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00031cd7-af78-4e9e-d615-08d98292fcc0
X-MS-TrafficTypeDiagnostic: DM6PR11MB3609:
X-Microsoft-Antispam-PRVS: <DM6PR11MB360964A2C6BD6986C039A95FFEA89@DM6PR11MB3609.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:457;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o5vYEgWhJl06+H6DR5XoU7QgKEanhXmFSoOrIoEbZch+S4GNAHhkySxaLesg/it7VXMhev6WxN5v3oqrJ+Y50vINP5YoDkPYGrAEmZyEihYs53fDja7JgSND5qwyQJ4f/GPYJlbU6j5fm+NBiFv0njRYXYl1iPIO837TzVWltdao736FeSH8HcyBGGc1cE/PA2WA33tcZdBFukzWKHH3gWzRhTRSKJ4lCGYn25b3sANHZuliMKLqqXJvwCdluXxGot8aDMW7z7W0tKMMb0G4P05WpUEevdYWGSZD0418ksuHIaZi5I2X3rFk2+HcDveL2B702kb5WuIiUVBsxK6qcTxBe18E7FD9uY34NCLyRNzRM1sGqwTQm9CbQhgmOo2z6uA0fY+QqJHwhPluA9e2dqh5lRxbXfeoSHvduH8JKGBXBDjQtphGhalODVsMtt/25hpfFFRwhQWsoFNFdDoXsMM7IsDvhPtYF9uLfJV8tQBYfbiU8wel7D6TRU6cF2K5xH55Ge/tBIYTCRxO1xw6P16RnK2eBwSNhhJ2YgROQOjCylVQkQCCJyk1f+uRlJw+DjCnxDvlPDwNVU2Ri1r5Txf7BCkigyfLTKPLssD/ZDMX7UKbVDyR/OIJYTG4JI3is6hxugb+rPFQv+U6XwXoYT39i4M/ioogqtvN2HNxMquZSsDRdE1EYW0R8/Kxv28pZBeyxuS9PonqGdel2pSSuclbETwuAbGrP8DPShKivTe/EmxkgkgY0Th+lC/obxUEaApBzJKyNO9q9scMt+PPRpZaxpHTSY9vCYI9h9C5VX4S4mWDz4ff7F4z35qjBz7E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(5660300002)(508600001)(4326008)(6486002)(2616005)(8676002)(956004)(38100700002)(66946007)(2906002)(38350700002)(966005)(86362001)(316002)(66556008)(66476007)(44832011)(26005)(6512007)(6666004)(52116002)(186003)(83380400001)(36756003)(6916009)(1076003)(6506007)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NX0G2YJ1PaValHHJE1aZIhUXgo5aJzb+Li6CQmzeUmOcl5AZ5sEcYR/c9f9W?=
 =?us-ascii?Q?M76o0Gwu8zF/9uWtD42rtFtEYfbkWE5tb0zetGd92RsoNh0l6jVRgzdZbHAj?=
 =?us-ascii?Q?T3EYROtqmRxUfTB+OS6O472BZRprxACBkP8fh1blJ1Bsc0wkVbm8+Vk6DXwo?=
 =?us-ascii?Q?vOY36mMnbvzgHojWQ+CiVukmuSG3dgWhI8Y67wte8SlB+jC1/fb4YFBnZB7/?=
 =?us-ascii?Q?KaBdp1pbQyheHIIhQHOx4+gObxx1h5JOUr1DIQ5L9bUorG8o3974h470vW56?=
 =?us-ascii?Q?V0ff2i+j1GYjLPRvjHbgepXe+cULb7Oq8WTBxby6MoEyOZtiewVMJXrKCr2D?=
 =?us-ascii?Q?M+XNoKgX3yN7XknHt0Dv+cRS3GHD+HPYaeFG7vr6mMSIOFuiLCF9jUj3WcpA?=
 =?us-ascii?Q?YDQhgAQhTk25VhQ+A9qAgZJcmO8kF0ttcnN7lQQpKNs+XKimtSn1c6HCGyYJ?=
 =?us-ascii?Q?WDJHRcxP4TgfiLB0TfrvYdMmdIkEZuylfmtCORJHXCorJO8YIQuIIMltZGP4?=
 =?us-ascii?Q?3+OCDG0fnduqMrf3NBLpXWLV6arxD/crENAji1rHIMvvEW4OXAwJTebtkLPT?=
 =?us-ascii?Q?VNjHnf+wQ9rlrLlC2pISpqgk2NfiX2AAI+a/HIaw8pvYZ2v1XvLXTHw+sSpK?=
 =?us-ascii?Q?Bv6zeNO2OpGAD77RYcm7oiMsnEtDTispzPJYHsOqoZIol60/S9PW4Q6zuXsw?=
 =?us-ascii?Q?figOwVdlUJpk5VDblxYQj2zcZNuY21t5rIz1kmgC7/vEaIzOdbFRaV4TgvX0?=
 =?us-ascii?Q?H6yiLoRjYq+Wqov8LwMAQLhtYSbqD+cmW78yixl5smwzfnU1wXp0lUjkT0tY?=
 =?us-ascii?Q?eUHQW0GECk3mwFjhAGI3u5TiRDYT0mU2o8ow2EC31WQyn1PXNjnNOUzDgpDH?=
 =?us-ascii?Q?olffcSpVSQhFtM6eE+ywS9YKrWQFT+P2i9iOvcd8JTmDvdoAZmEyt7yn8DwU?=
 =?us-ascii?Q?S4joPe4/YqTCpM/lCTNsJyYr+YlT/f2N60iKS5aIbKjXv8yxxhgM9H0lQKOw?=
 =?us-ascii?Q?rnLLlV9nCfKt//IsRLopWNNoKODj4KfSqJwKvwj6Z2TfWx59nh98GxmgcLsg?=
 =?us-ascii?Q?ul1yL72cHD7uMWVnJTpCZN2msBptJ7IvSuz3+PEpGQec56vPGxO1DUuN4EB5?=
 =?us-ascii?Q?4W80gJly83tma1N0mVRlrwuxvER+4zoQQD9sD4WSzDBfdx2cNOeRvk4Idh26?=
 =?us-ascii?Q?BbMAT8B7Nh7nNpioxk3HSDpg9sCavBo8vmOkjvCeZwAJPY/XPRh8addhf7ry?=
 =?us-ascii?Q?WG1bCXKBDM0VcnSUQaTl4IS1RMV3jiPi00zFNRYEHS+RdG9j8b4DzN7FDIZ0?=
 =?us-ascii?Q?4afvJvTY2DyN7O6wiXqZnQQE?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00031cd7-af78-4e9e-d615-08d98292fcc0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 15:16:46.8252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQDQoiOfw3Qadf4DVdObOvJukibw8P+3HAFLVluR6oASQiNrsu17NYcqqxd14iz/H1kXnwf2QCKAA1i78o+Cne0eYWaUxOWwuamfAup/UL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3609
X-Proofpoint-GUID: m_z-253xLMkDoIQh_-ZFAAW-nIWWoU_T
X-Proofpoint-ORIG-GUID: m_z-253xLMkDoIQh_-ZFAAW-nIWWoU_T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 mlxlogscore=989 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280088
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit a6ecfb39ba9d7316057cea823b196b734f6b18ca upstream.

The current error handling code of hso_create_net_device is
hso_free_net_device, no matter which errors lead to. For example,
WARNING in hso_free_net_device [1].

Fix this by refactoring the error handling code of
hso_create_net_device by handling different errors by different code.

[1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe

Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index eb2b87f186a5..a47a01057e50 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2510,7 +2510,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 			   hso_net_init);
 	if (!net) {
 		dev_err(&interface->dev, "Unable to create ethernet device\n");
-		goto exit;
+		goto err_hso_dev;
 	}
 
 	hso_net = netdev_priv(net);
@@ -2523,13 +2523,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 				      USB_DIR_IN);
 	if (!hso_net->in_endp) {
 		dev_err(&interface->dev, "Can't find BULK IN endpoint\n");
-		goto exit;
+		goto err_net;
 	}
 	hso_net->out_endp = hso_get_ep(interface, USB_ENDPOINT_XFER_BULK,
 				       USB_DIR_OUT);
 	if (!hso_net->out_endp) {
 		dev_err(&interface->dev, "Can't find BULK OUT endpoint\n");
-		goto exit;
+		goto err_net;
 	}
 	SET_NETDEV_DEV(net, &interface->dev);
 	SET_NETDEV_DEVTYPE(net, &hso_type);
@@ -2538,18 +2538,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
 		hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_urb_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 		hso_net->mux_bulk_rx_buf_pool[i] = kzalloc(MUX_BULK_RX_BUF_SIZE,
 							   GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_buf_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 	}
 	hso_net->mux_bulk_tx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_urb)
-		goto exit;
+		goto err_mux_bulk_rx;
 	hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_buf)
-		goto exit;
+		goto err_free_tx_urb;
 
 	add_net_device(hso_dev);
 
@@ -2557,7 +2557,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto exit;
+		goto err_free_tx_buf;
 	}
 
 	hso_log_port(hso_dev);
@@ -2565,8 +2565,21 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	hso_create_rfkill(hso_dev, interface);
 
 	return hso_dev;
-exit:
-	hso_free_net_device(hso_dev, true);
+
+err_free_tx_buf:
+	remove_net_device(hso_dev);
+	kfree(hso_net->mux_bulk_tx_buf);
+err_free_tx_urb:
+	usb_free_urb(hso_net->mux_bulk_tx_urb);
+err_mux_bulk_rx:
+	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
+		usb_free_urb(hso_net->mux_bulk_rx_urb_pool[i]);
+		kfree(hso_net->mux_bulk_rx_buf_pool[i]);
+	}
+err_net:
+	free_netdev(net);
+err_hso_dev:
+	kfree(hso_dev);
 	return NULL;
 }
 
-- 
2.25.1

