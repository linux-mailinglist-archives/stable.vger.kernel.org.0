Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A7941B219
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 16:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241247AbhI1OcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 10:32:05 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:47454 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241014AbhI1OcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 10:32:04 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SCb2K4008498;
        Tue, 28 Sep 2021 07:30:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=OlTWHq0DZa/+xGivPxTK2NAu22KQIaGCao5FkybEBoo=;
 b=fULffv2u0H6Hf5eI7c7vc4c6omIMcYkjNz9zGETPh9Y1ERCWKW3RZJFDCDmkJSQdKuTO
 ZIq1XO5qu0oYq6avQVkaprpMtimUXLdjWgRHkD9lydldn6ldBGe4G6ygPuNGWHmql4ES
 /heiUmFWIuOCvA0cLkTqDyNRYc4YTq1KaAgtVq2Jq1O7woJtKWXRDWUnjqMNtU8hZ55W
 V9ZlGkV/sJHLtOtWyhr0vfDuMSi2nP0HTCyA2rJ+jBJbHURGZKcVMu59PSSdxjwbj7MH
 bxiXT6pNxT12tMcqTEMNaunswevgj9dkz+vJFsLfpBQJINp8h0lYuZlC8VkdfTZ0GHeD Ag== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bbk6ygqdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 07:30:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ujz2I+HHnxJ2YneMrbzrZy/jk+5yrKbZvr/srCFD4WO+4r/BspNBpRM9mhNmZCNTyfo4mc7LTR+zGAC/GYbiSsnz8p9p2CoyRlo2ISJ8IupIwHFnntf2DomZPvpri3tINeLeVQQagys2QD60OSJ/r3o5Ik/bpsoTUUtE4o6NIwIdvepZcdsSqrCiHljMn77Bzm076lVZsi5B1/fnymbkwBB/pO+A3GXQMLq22445FiR3su5AdFFjlHexlmwCXm7hoRq9d0jRe6vwWCkR34CR34OYqyiQ6EQSD6d6fq9gM8FcQiggCRAaNNjOnDTF2xcUOBOFBvglmH6GSi9wDjb8Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OlTWHq0DZa/+xGivPxTK2NAu22KQIaGCao5FkybEBoo=;
 b=QirzBuWVpwRmuvOZG+Z+8ZGu3GSk0tgATV9u+svjwCg1Jl3d2W9zDkvPwWCbpJimiZLgp8UcGr9m/Q9KdG0ZQr+RUXi3IeTBSRXFX1Kb8FNwPjE6QD1/RwLklRigvhEjd6Qbx54mZGehCepUf6R0FqApwAaRj65NHQqdBgMjAn4h3oekU3gfnnCqS6CvFL9sPnd7tDXkR/GvsiL6uy65LQRm41KuRdbrxER1kQEXWBJL3Br1aiRHvT4wSDviajjg6bEaS3RJ3/kEdBjqG2yu5GhX+jDmftsbf7SJv7fNcb/SIHzG4qTTIai2KBWNitgsHkUfelmcOp8Ff9AOxtnvcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2345.namprd11.prod.outlook.com (2603:10b6:3:a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Tue, 28 Sep
 2021 14:30:20 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 14:30:20 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 4.19 2/3] usb: hso: fix error handling code of hso_create_net_device
Date:   Tue, 28 Sep 2021 17:30:00 +0300
Message-Id: <20210928143001.202223-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928143001.202223-1-ovidiu.panait@windriver.com>
References: <20210928143001.202223-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0028.eurprd07.prod.outlook.com
 (2603:10a6:800:90::14) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0701CA0028.eurprd07.prod.outlook.com (2603:10a6:800:90::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9 via Frontend Transport; Tue, 28 Sep 2021 14:30:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a26453ab-b729-4640-ccb7-08d9828c7f93
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2345:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB2345886D6E630D343D2BB93CFEA89@DM5PR1101MB2345.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:457;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HbHdBYXU25DrHzrM3rhoYYcJSy9QpODjN4x8zv0KcWIOzZoEKWxukq+2Y8pZHKJ7T926SktZ9dAp7l8aVvracbCs07tDeTC7nil5O7k46ex9E8IHyRvVd74EwDul9wnjU1rzLMiq9/oN9a/9letFXGEFNL+hB4RHk5SkjnVjxheCpdML4s8x9k3gwkWUIcqydLILMIDRSX+0Df0Ew9SdDibw9orMOYrJPfh63cdqesF8frmkPT/chY/bZvJ955y/CUCKQ+2JRWtpI7bKFFQ0GM+0Ufrvo7t6DrxGopwDq+VoR1FJilQv/Y5nzjvMcDIlmB9lbpwxTHjwDGwOwf+zrmj8WnPTigK2Avrv5+1JFJ9/cNEXmMslAOuK6mIfahSjr8wD0pIUlqKKwNnDHHwo2T4bw6ww6/ywjvAe02Rwi14HWlwxugfse5WrxpN9//zjO3Y9qoPGMxXQfcKOhSxW80b42rJlfYCDOLH++dviF1S1K4YN53eTxZdUzyXzrJftq3HYfR31E8rK1JUlHOU4O5UA85/WSInLNWCcqhzix7idA7DzbGlbxbCVa/h/pUTkm8bRW2aQPd9e7UFDy63aXkBrfK3vT/P0YnbRJaaTOJIP+FOKa9xlT2CMzvjsL8WCXyerQremqWFhamwTdBeX3oHP3NFWqVWZdYigZuoMjGokqpyQ/nEPZzqeqzVcDD+Qa6T96gwHEdX8FgYV8hLZ6IPlgiw0wocJi8Ikz9SbE70NyUKTsqNo8zv+C79liNxl0PXJWN6ewiRaWJjNO0pbqEAMQP2Qp5KH6ykzJVyx+Gev9/Wh6UjUuTaYjeAhiONU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(966005)(956004)(6486002)(8936002)(1076003)(8676002)(508600001)(38350700002)(6666004)(38100700002)(86362001)(316002)(6512007)(83380400001)(66946007)(52116002)(36756003)(26005)(6916009)(2906002)(44832011)(5660300002)(6506007)(66476007)(66556008)(4326008)(186003)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NOhQDlqvGn8ILWpsHqyAHD5up3a9Hh/J3XzZMNY3b+NhfmyUKqIw+FIsRkDV?=
 =?us-ascii?Q?/8re4oBXi58teArj6dNr8JyEl34uU1B37OylhCVeI4Cmh45EZgahwkn85ze6?=
 =?us-ascii?Q?HF0blkgSRXZzMNEuCFxEG9YFfzO9D9CE+u7qHvpV69XfpyD0omL7spV8wL54?=
 =?us-ascii?Q?dTCn3YX+Ic8aa8om4jcYiUGr5ZnGUa2IjrPRVt9wewf4+qNsFNfDNNNNyPAF?=
 =?us-ascii?Q?9xZ08tsny9UUDt24DU6FA3jwRPAaagGgP9apkvbIW4WgSIrECqyH6q3WYo3Z?=
 =?us-ascii?Q?lQQLUmNBCa7d/8VlZfrBN6peosFL86K7HKCRyMmrEWIv7HWEbIVJy/b6yXxx?=
 =?us-ascii?Q?NcKG15pa/1SEJocfagqZAKLhZFw46WJwxHcO/9/jy1Dz1h+h3u+uKU99n9Tl?=
 =?us-ascii?Q?Q7F8KV3L1GPjcHb4p9C54JJvS9LKwOW5ax6RRSX5mxSaMrXKFTeceZnCrzBb?=
 =?us-ascii?Q?pQWf+qAqERuD+UoES6fw8ZtIfLGuDy0LHYEs2OE+uUx+YIu51OwfXstU1KBs?=
 =?us-ascii?Q?IKtuSHSic0x15WfCspYWIwVZK0TEIIDG/ZFVruUExl+iZcpPZqrmZUMiAmNA?=
 =?us-ascii?Q?GOwTwT7aWJiDFV3mLhho6EDGOdMXwcA2VLPZ0PyjGkGnQvbHijbmZv3SBUBs?=
 =?us-ascii?Q?iXgqC91IflX12F6szwfKMI6R58p8vILIzljwCbmZzgJp6MZQo4s/IdnUDI8n?=
 =?us-ascii?Q?TpROcoH32MisJ5Nbbpyze6/I81/5pgYGitFyE3zSbf8ybeIuPl04MtftRC/K?=
 =?us-ascii?Q?qegvdD+l6VxZRZztHaHDoY//7H2NZlSEPDwcjBaO9fO80/14przDZhQSSkoT?=
 =?us-ascii?Q?2O6PgXMnfmEN8pqXrdRGPAulmrXRnKh8FEifb5CI+LTgPoY+RqNQYm7JEL2p?=
 =?us-ascii?Q?trEdFJLuQPQTX1RI/CzAQEy0MDG7JYxKIYcuwxpj3GWzJEmtw1Ogi5h1TSQR?=
 =?us-ascii?Q?aaTUPY9PhNxkaSFAO7k3+CpRR8KF5uu5kk4iJkQ7Hiy6mOUM9sVCpxjk5V0p?=
 =?us-ascii?Q?WWUIP2xEyzhGu0vnc7JNMpJsxznIFt4wMWRuOdCFwPi85BRpOIIzYaOCy7YW?=
 =?us-ascii?Q?Jw0hJK2EuNQ2s/V+IvB9DJAts1fVO4eN4DkNoJauTW+STa8CiadEetRZKeoi?=
 =?us-ascii?Q?He9EKD7cKkxTaYrSHGUKVFDlAtW8aJhaxFQr1Ic9jFp5MIx+X8oYYl8PSpx/?=
 =?us-ascii?Q?J/Aj2kFay9p8h6Tz/MfD2t2MlsHdF8gmN968sMJDN2aJ1S9X6/oNsvqb/5+2?=
 =?us-ascii?Q?sv0zog3Uk8/CmH2gLhpqgqWo7uQw/6S5SIvupyHq5jK/0XTYLH5WME7SpkhI?=
 =?us-ascii?Q?G5BL7NsXerBiMOyHyhqDg1ot?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a26453ab-b729-4640-ccb7-08d9828c7f93
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 14:30:19.8325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 45dNDaQI8F/2LUKk8FzREHAAXno6WxvRvyIz3OMUwIa8Z7Hl8LTaEAQdilW4xQPJKRdlGtn7TSuBmi176V+y9cJBn5gM1Su28b8i3d8GeXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2345
X-Proofpoint-GUID: 7n4ehi13Jf4R4OlVSDkGpp9v1U7tTAlZ
X-Proofpoint-ORIG-GUID: 7n4ehi13Jf4R4OlVSDkGpp9v1U7tTAlZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=989 spamscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280083
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
index 0839da773e62..8f0d86f91c5c 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2511,7 +2511,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 			   hso_net_init);
 	if (!net) {
 		dev_err(&interface->dev, "Unable to create ethernet device\n");
-		goto exit;
+		goto err_hso_dev;
 	}
 
 	hso_net = netdev_priv(net);
@@ -2524,13 +2524,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
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
@@ -2539,18 +2539,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
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
 
@@ -2558,7 +2558,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto exit;
+		goto err_free_tx_buf;
 	}
 
 	hso_log_port(hso_dev);
@@ -2566,8 +2566,21 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
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

