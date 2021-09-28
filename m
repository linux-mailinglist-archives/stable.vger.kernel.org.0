Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8ED41AFBE
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 15:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240835AbhI1NRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 09:17:39 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:58574 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240595AbhI1NRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 09:17:37 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SCOXjD012884;
        Tue, 28 Sep 2021 06:15:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=9oOqT+MMtIMy8vg18JyDShP4W0MgzXk1R86OzRG9XyU=;
 b=ny1u2A5+NHxuyAIDJNWVF8o7HicMG/w4EZcVpkhqEbgWm09thD+3fizb4iNFV3g0wnV6
 ikkTlxV5G3XwyQahUrNIW1Rarae1fKUJb8And9NjupwrJy4v3nMCaaySCyXHp5J8BB2h
 NvUX0pRCEm5+wiBax4IX0i1A79q6ZxMUXjM+pTC47C2PL3JNOQgIME+G7o33pKrpmZuw
 3GLXsSHqyk6+tonRE/6+nS7irynkPW9KLhrbq4tu6HXKOWzDGeUzrsFTUkqAgnZZwOc+
 JONEVmej146O/o+fxygxRXBdV8A5GBW0Sov7q0T02xpPUQUvQ9AyB1XCsiHBhFhE2XMv uA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bbhvd0qwq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 06:15:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/ZVr3MpQP3eJGioEmX/IRypatjtJIRFzyF2XJj5KRY+M+eZDh08tugxPhpx/+2rHaYMvv/ucg8URFrTEPjFxDpE20+AQKDbfvepRprkATqTMS638XNian/VqpFkttLzxtoYJoe2hOaB+0ULYQIRl9uJVSw6Qhqb+aWrSMyMNtKYFSOimpiBevb7o8cmkQQ5qwGPkDVqwMIi6IbdmUj9FhZFn2WTVlA5rxusTAhYRnOZ8R0r4CgGDNjETGkssM7X9MX7h1kXKCk2CF6zxF2wEqY8jYGWFU1gygCe4AZ0+9CJgEBp0Uhs9B+ehuTqESA5yL3jvxnv7ICL0t+tNQ5RqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9oOqT+MMtIMy8vg18JyDShP4W0MgzXk1R86OzRG9XyU=;
 b=a9dPg2RRQb7jgugiK3wqmSoZBIDOGK27mGRW0RX/IqWhYynkc5kwKYVBi940VIaG/uXy6T4B08+aRKi6ao57Xr7X8He2qkoOS1W9Yk84KsHEJPsq4FnDF7Mf2iRJLBLHHa5dwdDWP3jg5TXAFoGne7g9DjbEemlZrq0p0YxiEwlaR2dnX7Vzkikr/2pednQLBwL1nwgJtBoPvnwrrA8CHDjgn/95BY5Qog4Lwv1mzmqmLIb5OdQuOyT784dFzk3KOyIpGEtpbGG/QMx/PYiEMcnmLIjh6L/Rs7sf8fpzGrgy4Y8BbAL5EhceLis5FV4toBZ9lVKDQy/zD2f3a+UuVw==
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
 2021 13:15:52 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 13:15:52 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com
Subject: [PATCH 5.4 3/3] usb: hso: remove the bailout parameter
Date:   Tue, 28 Sep 2021 16:15:23 +0300
Message-Id: <20210928131523.2314252-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
References: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0073.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0801CA0073.eurprd08.prod.outlook.com (2603:10a6:800:7d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Tue, 28 Sep 2021 13:15:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 726f0cac-4d82-49dc-7443-08d9828218f9
X-MS-TrafficTypeDiagnostic: DM6PR11MB4561:
X-Microsoft-Antispam-PRVS: <DM6PR11MB45619F02A7D7C740BBE715BAFEA89@DM6PR11MB4561.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ayRKOvag9ovpL4Teydz/LvDA/Zz2uyQhY6i7RLvfg4g5Ss+4ViXBkMhXnKSRXjclWBc80jUzFf0k/bE+rZHwcT0YE4WVqVgQB4DNIsCtfXDI9yfe93PhyypcaZjQbV1oF6a72kIjZ7nUiQbffwCrHrFSiE4H8uRqg6yI5Y5RJhq7Q44B9Dmj9Jnxhx/FZMzY5uO6SiBfaXXOXjPsKNhnKZgO3UsdlCm1OCMZBNSkz8JepPOU0vnup4rK0hEIAeBxo5V9TE2iLezaMucTMxVY/ptjoRW/6/3IGa5fRA+HiRdWLoNUDYPlCLLuw1uYnYN1AXX6DsxI2+4a4ZGciW1bLDBeCebrX27SNmuqVV2MvPeFrXZNIr79fe3TI3SsUNCoIcWFuATj41fQDj+G/xhydhFcWFpmB3xCcuKTlPnuomzzHYowxGhCQ1NU5vGT2x+He+PREyb1Jw9RkI2bOF7SDdaf4Qn7y87Few+WTAOhdnOz4oeuHCHjzCRbkbqOa+b/h08JlkW2p4fzKZGTUhgl+BIoIGcWRzDOsImlmN6c3HaCNPI2HSK6UUov6fRw4dMeh3Cz/mvjtjSeNB3H7h0BgWjHsSHx3uUqIgkaD/vzW1o0xwQzpPbZIpX6xPWBvTfEunj9u9F7ReTHi+RW7c4CzlwK7cQBPJww+7LW+RGx2jbrgFuAcjD+ZuyoWfwWWWyFoPIYYB1Rcw3JvGwmtLXm9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(2906002)(86362001)(66946007)(66556008)(8676002)(66476007)(26005)(5660300002)(6486002)(52116002)(6506007)(38350700002)(38100700002)(6916009)(44832011)(6666004)(186003)(8936002)(316002)(508600001)(6512007)(36756003)(83380400001)(4326008)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?86+wVDEa0VrOgu7f4LARe4SuTKXyJiGWrWQniObQiAneImcQ+aJkjYmXpN4Q?=
 =?us-ascii?Q?6bIWSiCZw+QQ/KF5yAovoju7avwmgLKCbsh9q1V2H78Ybof73ddwpyu6/2ig?=
 =?us-ascii?Q?pKY4QcCumLjzF7XD4Hd1Md1po/fIFruGMe+yK6O0KGhBpQeT6ZEUHuRRqTND?=
 =?us-ascii?Q?0wnWabt3yx67h3cVDcFWdRGFl9hbTg8E37voqAdGcsaJqJuIJsLlpPYaVjSl?=
 =?us-ascii?Q?9GlsDUWmuvpmL2MJnpF9oa+/NG/Gq+5dPLl90pW4w/qZ/ahXDw6puLgdLRnA?=
 =?us-ascii?Q?yFmt1bcK31MbcM91OqleYTjyBxuHIuz77vlX0nqNUqVNFM7xT9oDms9OOZ2G?=
 =?us-ascii?Q?NMZdkHmqTwpvazvy/lNm6yW2rf+RrAaVh8ZGu8t3kfdBG4bFN8R6belF4AJk?=
 =?us-ascii?Q?MrzkGzeXfEJWrXsIYzxl9XSgb9TgeeI6rorqW5HCbVg8YY0OLRT0qvtlWWLa?=
 =?us-ascii?Q?oBOAs8/SAehTHMkoxIDxPBFa3yoZ8xjMl2PQLVJ5OiouKS9/6J76qq7ixDIT?=
 =?us-ascii?Q?S4JI//yGybOAf2Pi66iIb5y+AbaEYqFrm/BOzEwgSWpAm0OxMo7j6T1ap30g?=
 =?us-ascii?Q?vh4PVXkIc8NyOpWal4qeH3hubZXO2pqR+5Kq+UFrRY2/C4Mm7nUNnCEOv8L3?=
 =?us-ascii?Q?vAI7Ajb6pEkD8fSr7Jj0wuGsJ1mSD3ag8WxGoRs1jFuEGhtjPZ0p34fJxwjW?=
 =?us-ascii?Q?mpEa1Kbn/4zy3dsQLvfuHNTC/9UAfcj4XLXScU96OfErlOKT8rpQ+lV/nrZ+?=
 =?us-ascii?Q?EKsrBv8X7Tze+C0NRK128bwGqEW5ehhR3S7OB4sk1Cn0OyX2iVcmiNQUmBkh?=
 =?us-ascii?Q?T+0wIQYpxDym/x06DvzdqrtiAw1E5VySf1lr19PN6f49YCXiuHMnM6rnYlAr?=
 =?us-ascii?Q?9JpPQaNysAOo9ebD0GpFklAWmI3lC+MC8q//pIVB5PGsdEo52uNVRe29mzfc?=
 =?us-ascii?Q?UgWOZSNolG6MjkrHmvD2mhWlkCHIHcx4ngAGpPRsaTG/DbBUOHU41no/SFzj?=
 =?us-ascii?Q?eluQK5ovY08KwX86KVUeNjz7dacYX4VuvZWh3NYBNbvFSuxGiUL5zgOtFxYG?=
 =?us-ascii?Q?jUzkoNn0g1HoCrYo+LsQBMqSozh0YHcooDW2qbTv/0ywG5FyI+LVWFOI0RqN?=
 =?us-ascii?Q?kJ+/m0gSTKcHrJl9jPMojHJ41B0zhDEolgn2M1UVEXjlUdyWYKgGDqWvWfza?=
 =?us-ascii?Q?0vV8Fdrljk/Qu+StM0FOErgJ+aabEqxZszGN0KfB0oCBgyjjtGVMaDvsgezX?=
 =?us-ascii?Q?pJq0oVVU6ZOCeq4mfAB5Uq6HLklkHHy2UlnQi5AoKz6TRb9RD4lc0heB0YHI?=
 =?us-ascii?Q?dqoQOldsekUzKvP8Uj9CcLC4?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 726f0cac-4d82-49dc-7443-08d9828218f9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 13:15:52.7709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kOdyF6BLK/FHjvFbjrEdgWxktnpt54wRUuMjYkSXtmldupG9nR3syllLcLxkYjH0iqh76iUf3vUToBJ0rMrjAn3ChRr0nQ2fdhlOiOimPFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4561
X-Proofpoint-ORIG-GUID: bSBJyWMQKMfMF52UYf6Haa372Vzd5hOG
X-Proofpoint-GUID: bSBJyWMQKMfMF52UYf6Haa372Vzd5hOG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 mlxlogscore=689 lowpriorityscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280076
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit dcb713d53e2eadf42b878c12a471e74dc6ed3145 upstream.

There are two invocation sites of hso_free_net_device. After
refactoring hso_create_net_device, this parameter is useless.
Remove the bailout in the hso_free_net_device and change the invocation
sites of this function.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/net/usb/hso.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 762f7a4db809..95da2576a221 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2354,7 +2354,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
+static void hso_free_net_device(struct hso_device *hso_dev)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2377,7 +2377,7 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net && !bailout)
+	if (hso_net->net)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -3135,7 +3135,7 @@ static void hso_free_interface(struct usb_interface *interface)
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i], false);
+			hso_free_net_device(network_table[i]);
 		}
 	}
 }
-- 
2.25.1

