Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6CB41AFBA
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 15:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbhI1NRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 09:17:38 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:57460 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240602AbhI1NRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 09:17:35 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SCOXjC012884;
        Tue, 28 Sep 2021 06:15:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=x2TOHmHEfVzxJBvAEdAXhzR3md9Hg+d24Wz+XZtsQ8A=;
 b=FkjEjo5jNH2k5PIxSR7RN9IEsAZabpQm8/t/EDcpaodPX1IjKMyCREPsuOjLNMOFRcIN
 eLA7xMiUp9udzwoqnIRFOoOOx5GWThVSkWqNMgEOw8jjXm5IsPYm3DdXAdvUBG6l2Zvw
 Cq78E78eJ9m2CwDbLJDXUxK7Cwj+n0oQjRM/0CH46/G+hVm8qKVdNSPyUyExhhxUfuN7
 V0OWBdMZceAvvbdC2ry5qd1PyFpZpiEp+VBX9tqkeWoImaFrZlZWjbiFe+qjwRgG5gh5
 3qEuZps7MPyJK7zW+lkfzKoSW+nMu4UoMnK01AQDI4Ggp289TSmRU6prs0Jyj6uqk6Mc 6Q== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bbhvd0qwq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 06:15:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTlxJYW4oAkq1ZSd/Gv/ugIlbaBlWAwy0JHBiWiIoaYF8kzL3jOy4LWVgbOAchOgGsj573tg4NmjZWzd7gUaHVbBvatsnza/sS49YOXhsHZAsbAj+Yn0FGBNU7Et2h+cV9uLQcGDSBgaN3lR3+XxXBCy7v92CVCORIVkzUlevSaK4G+mzVbuF+Kha5wnbT3ospDrK6dN2jJLX8zmqqYhasoJ2i6XuZZHgZaaeDyBUExx4UUpjrrCwNw4BJ1DAccYgD2otm8SnyqLMS3DSRYgFk0Gmg3Mh8cj4jlvQRYZNMmM4zb2QoIMPOO+RcrG6dDW1y1cznXrgVcsPIEL7PUijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=x2TOHmHEfVzxJBvAEdAXhzR3md9Hg+d24Wz+XZtsQ8A=;
 b=d7fpFf+iQYp7NSLhd9c32jQEeZ2ji8XX+bh6OpxN0rAeK/qPbCw3OY8dNrQsTrlpLFm/nLU0o6BzAXiVgum0ibdRjIUyrQx13HqAoczeAgPOotSCAQ4wxyRMI38Zfusk9koKe4RR4SzPYRY2njLm49gwAeK15VhkZaNwFEPEAp2BgjpsibS775Ztr0Kv2Wu0uD4r8Up8JU+15UXt4FQ7qlWJgt7kCYFMmC3G971Fs5szG2vcIjiQUzI+F1IFJorMfeubDGqnREJMd3uu0p8VfCguJ4LJczs3s1ZYS2LfYnUjMWGA1dHOLcYxSiB30rFP7Ll9XLZey4mHGMSxfUeqoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4561.namprd11.prod.outlook.com (2603:10b6:5:2ae::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 13:15:51 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 13:15:51 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 5.4 2/3] usb: hso: fix error handling code of hso_create_net_device
Date:   Tue, 28 Sep 2021 16:15:22 +0300
Message-Id: <20210928131523.2314252-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
References: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0073.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0801CA0073.eurprd08.prod.outlook.com (2603:10a6:800:7d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Tue, 28 Sep 2021 13:15:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 102a3e97-d679-4f30-cfa0-08d982821857
X-MS-TrafficTypeDiagnostic: DM6PR11MB4561:
X-Microsoft-Antispam-PRVS: <DM6PR11MB456187BBB6DBBFF5A9FBF822FEA89@DM6PR11MB4561.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:457;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4U4YIxpUZ2TbTujaGKDQMgTwDNyop+VgAW71Z9MXNpdp1IPPe1lzVWA2Fl18B2KI1QthYNtlN2DF4w/5ckzuVL4/g1yySv3gatxHBuSYmKYeo8WFNM5Yfo8ezr/+GnmO5TE+1jHWMGqx176R0v2vMseKILJcxv986kM48OKwV0jZCuKwLLB7/RDCxHNNTQAmWS0R1rBBIN1WC19wiHLgnkN8REnGNEMf0e/iz7/oFasEiKf7Jhlb/xl7llPKQh3kFDKGk/Al/WBLL0GCcK6qkS6d7hEfBemTYqWKwPiAaNNCXZbDfsfNVVRfjSXDxlgqvpxtZgDRzld7fjx249tLBuQqIXshMpDU2mrQtBRfA11/2ML2yhPDw+/d4oxLRsTmmMhaFvLF1OB/97h7gG8AMWsnU8HfWLYEfbP0dzAeMTqe6C6Yukm/rbs0epmb/Q8/fHhuFVGVo/7UP5HBhiKxWNGFibdJrIETANBh8WpsTxlsKCWrTWTaPIBfo0L06ak7hmmV1q4HeHvSUHhm5bw17U1AJ04xnzGtm4R6/F2Qq0cE6nBB0omNmbQnFXzR5/lJ1xjKlgpeHOCFf9r6cTD4oaRBnI8Iw9QL/sWEQfpO5syUcyK9iGUCfvHB6xwbh9QzhM8ASwinOFNYXau0j5v5t5mYfwDZy7RtZI+2tlV1UJgz09yFrXYrVvUNd7vjg687nFfFzVXUurMD9X5kcEyyGq9JQWRFj/C9csH+iMM215udY0qGqbxzSfWQYdAMdnFLdtWeldokxXn8lMQrbMtXBCGWxOFE06pfVs9DRkOpwvQ3IMRULx61f9ZRRW9dX9B1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(2906002)(86362001)(66946007)(66556008)(8676002)(66476007)(26005)(5660300002)(6486002)(52116002)(6506007)(38350700002)(38100700002)(6916009)(44832011)(6666004)(186003)(8936002)(316002)(508600001)(6512007)(36756003)(83380400001)(4326008)(956004)(2616005)(966005)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HpFaBjGgmGQUIKYrbOErfH3xFw4ghJ6sGfYCMlFp/a2bv0nYHPMVEyjov1rV?=
 =?us-ascii?Q?RXHkvmdPxsUph5ljcg7pWP6Cx5d1Oc9SdahfhEAsJvo17c8X7wxYWz7Mpxh2?=
 =?us-ascii?Q?eCmncL2KTsWz2aCILtRHhV05DErRFBWPXlmy5d8hAHbxFnYIUo97sea0GPx8?=
 =?us-ascii?Q?zHbO5DwWcJJN4JvhU8ImgK9eJk2sYdjZnFEj4wtfRUF52/hoSe9RDmrFisJ3?=
 =?us-ascii?Q?e/3hSjbBId1nF+gy5UF3oqZW5xUVvvOv5/qK85CvyTVEO2uyy6sDtsZoyqgr?=
 =?us-ascii?Q?GaHmpySSOQdI/3nzvpILu6uyW7iBBq1PX8vHpn0L7QL7Toh2JwNymZZMEqml?=
 =?us-ascii?Q?oWpFT9qAoMh46xOfDK6gC8/JJ9tDQfahzwpErm3f6G+rjmFBWR+QNedC/16J?=
 =?us-ascii?Q?5xEcWpvKCgScelpqjTKUZY/TFtefqxB38DTIQc2OA987cdx2sVO/KY+5XN16?=
 =?us-ascii?Q?1lQSx4KFnWd6ily7qQgzfhplxIU8r6OdgYJxI/zFgkwJoLirNzV4VLRjQfbW?=
 =?us-ascii?Q?h/Clbad32t+7QW/NG8PinMcAQXaAOjoZ7rQeeRInG2hxxHmjxF+2jjgsLYVF?=
 =?us-ascii?Q?CWDmVWJBZQG6SWTXXKH549tqqADyFB+MG1dOiwDeYKYUhLHDkQZi1073s722?=
 =?us-ascii?Q?O845xBSjUQl9yTlMfR8sWgYwiizXPbXuB2hGAi4yY2DVcl2LXHzpSE9oWcGD?=
 =?us-ascii?Q?lh1nnNKlSYuJOiVa3TwwLNbgzsdgCQjGhWlTQUh6Rg9e7ZVBIRrB6bxR+Wx2?=
 =?us-ascii?Q?lg7ps5lWpetYAh25jycAvfUC0xlcHhpwnMSDoirhTsZcWbcXAgy+LFjK/Ku+?=
 =?us-ascii?Q?EzcBQfrjdmPEbNFcG/G0RKnVd9nZGCNy+vrctZup7gDqYtHaSql8AkP52JFi?=
 =?us-ascii?Q?qL0w1/8ei99II25uFgviB3EN1ty9Em257/De721Lzc1THaBArZg72m261I/q?=
 =?us-ascii?Q?FW56YM4XeQeMgo3tqUne0XKONi6q+Vo6mPkAKYAX+Q9Jc+LFN3qHpx1IlaG+?=
 =?us-ascii?Q?O52b9zZjZfgBhmj4BlObLHvKVpcf6QYHnjtomoabSWi2APh2khdabJCNfu1q?=
 =?us-ascii?Q?iK9ovCpEsyvOa3WpvaL/JTI9erIwMjh3G/LCU1c2Jkg0043xZeaB6V265atk?=
 =?us-ascii?Q?P4+Sfs+4YsN0c6Y9wafCeNnzsZCwBIc+JcfzEBqMA01YRuY0dgJ3AuqY18hw?=
 =?us-ascii?Q?RmlxIFf4uQ5RCi2132D5D5JxCgkwSwr+cdcaZ7Zuxus00aR/tkcmAGeWqbIy?=
 =?us-ascii?Q?3pVrZJXWMF0NjrYtm5Dz7crqauK9mR3N6p8WoyimF2L/sTNhD08aK6EPqRRh?=
 =?us-ascii?Q?iHJDq+uSiKOOWTfZxwEIdExD?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 102a3e97-d679-4f30-cfa0-08d982821857
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 13:15:51.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBdMrG58a1+KbF1O0mt9tlWr+Pa7OwUjoXiQ5AicwIZm3NeyY2Ul65s/I5Ela1MVVnemokD1IVwd1KqxNAiX6P7pgyEoG05/7omU1yDvQog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4561
X-Proofpoint-ORIG-GUID: 9PgebWO_M2Zl4G6jZkHLDEkJlAsP5PAL
X-Proofpoint-GUID: 9PgebWO_M2Zl4G6jZkHLDEkJlAsP5PAL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 mlxlogscore=989 lowpriorityscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280076
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
index fb8827dd5671..762f7a4db809 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2497,7 +2497,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 			   hso_net_init);
 	if (!net) {
 		dev_err(&interface->dev, "Unable to create ethernet device\n");
-		goto exit;
+		goto err_hso_dev;
 	}
 
 	hso_net = netdev_priv(net);
@@ -2510,13 +2510,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
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
@@ -2525,18 +2525,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
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
 
@@ -2544,7 +2544,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto exit;
+		goto err_free_tx_buf;
 	}
 
 	hso_log_port(hso_dev);
@@ -2552,8 +2552,21 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
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

