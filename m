Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A68A502E6B
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 19:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343707AbiDORwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 13:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343970AbiDORwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 13:52:25 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8F857150
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:49:56 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FHmi5E009434
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=rvl1PV5RZMGN2YOBDHkM2/1hg0HvvN42RhgluyCBtTk=;
 b=rVpvfAOWWYLq4gJjGIrLUQ3IJfH2QFUZBqojgqARvUNfLORiXDFtet6zIA7KTUH9AGao
 h2goBmFJCt3Uiqyp8B6xyt1y+HQYo+8IUIoZ3dXAnrQRuXNORLomrbGfAKMMo3zjd2K/
 2FX90qx0APsS/64obdAatPD4mER0lQKWjiRobI1TyP7ofGQRElMttFgJCMphKE9Wbv7e
 Te/BEVRFdKocJOjG1lZT29KBDjHYeuRBL+aLe0c/QWSvmMXZ8w0GqTsPcU1CY+X3RdPp
 UHLCC3eYp0MIH2vkdwVEopqiTZ41kBm5K7IdjlEiy/UUmEmsKkcIa4F1aJUzNqtNvQfw /g== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb66evw4d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:49:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSdy7lQ3tV47sJkmKKwgOw89o5CtRFiSGUclI7smouSKEejiVCN5Xtydhhgc6apkYST3BcSqOrNuYprHEA3OZojcgPUYU2PzgCSNyX+EYU4OD+KvuydvYnML2tUXDvDKQojf95SIW3iEDyvIbLsgHE8Dhb8xzFr+kElT52cmS/BYGGmFGZYVaW9dva2irCEzWeY7Jk5v9hei4If2RXDCwgYJskk3MUKJXifAxg50vLvfJj6K08g2wtRfxtDYoWG6AFHETKpEzNcaj35khG0MJrWZMR9oA2g4zJNVcZ8p4ZqrRV/SUwQ8jriAW9K7RwXmDFRRA3DFN8gowOjXk7HDuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvl1PV5RZMGN2YOBDHkM2/1hg0HvvN42RhgluyCBtTk=;
 b=Q3TkVj7CrtG4gmzGaCQkY4Soh1JpoaHSbCVqY2/vSVW8lNucrbd6//J/MvKZJMuqqOVGE7bYqpojGx4SqczmiVt+PKASrk27qbxaaDsXN4Y+usoBsJ6/hgeP59N44t+CSYJ6XhXEyygqJ79G6U5wl1a2FAlI28u/R8okw5z+jftCrG9NEhnWBu273p6yo5R730htM0X8XUQfoSTjiTRX/y+v0V6D3jalSNX9o4Buwar4/delltioyjrjPkhqRW9R0dS9dLubGO/qPaOqQEs4PwNLnb1RPZvNZICHUnIFoD1K0D+fJKRCIcue3v1ejTpo7qctY0LuvQRTdYhpJNSwOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN6PR1101MB2290.namprd11.prod.outlook.com (2603:10b6:405:4e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 17:49:52 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 17:49:52 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 3/8] ax25: fix UAF bugs of net_device caused by rebinding operation
Date:   Fri, 15 Apr 2022 20:49:28 +0300
Message-Id: <20220415174933.1076972-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
References: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0217.eurprd08.prod.outlook.com
 (2603:10a6:802:15::26) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db30d1a3-0032-405f-3e9d-08da1f085831
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2290:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2290F1FB5C8771A600BAC72AFEEE9@BN6PR1101MB2290.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Z4tVbobwvL0kpx3EtdWzAQOQ/9ZmNND/U9EExkLxAmAKioqO1QRN+hICIuJYBIQFlDvnD/BfFbtxd1uAMaxmtthKc7/FwzL5bExbtTdXCjewFUSED9MlBS+FHWVyeIEX8IPw2Qw3NZlOnHhQ+OqcBCf9Vstq0FbuDta9tRKul4zgRZl/3DzT1v5rhX0A2Bs+WBM5BkhdrWVvrXi3iyW7qUcsQnfMwX6YK3wOclVq34kK/OgAYrC0Puve4Zd8vlsxFvyMMyzhNUb7PauEQLYMX2Jk2hGSLEjdbs7AL0qVLFB+WWcl6CA4OZJlMsNrRW/A4fdzHmHJ0/IoomLXW3mhIVFq9sPw+ucZEqxbdL2bJGUujVOAthY4UqaNkV0nejy7AmJ/jI7iUUR5jgsi/dDiEU9blD0wPGVVXBXyVBaABe0qnIC4tYWjCvd+1oZ6ewI7PEWYuFhOhKr9sFjkg2NQ1A+anWhXi+DweZAtlSHRRKYVvfCbpF7FDf81AS+NtAHPEL7j6iTy/L+IpzDG1RBw9BXBl2zzYMKJPWBzMpNPhNbQitmo2vqp2VatJYTXAZK1YQ6PYJggtd9h3ofOQc8qmCDXYq4eYzWHovFmfB4fpxLiebwmhlldW2+duasYnkLVBb7YM4Y0unfQxVROBpT+ezwui0FDUebbtR0925MGf+TQiLBcV27YmOMS2QLQUn8i8bkBhIWExNrEmCDBi3TCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(38100700002)(6916009)(186003)(5660300002)(83380400001)(1076003)(26005)(66946007)(66556008)(8676002)(38350700002)(66476007)(6506007)(6666004)(52116002)(6512007)(508600001)(316002)(86362001)(2616005)(8936002)(44832011)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PAjqfHU+RFB0EztdabpmvMktSSkHkmt+2N7v3z6G6/WbnZQUER1t7BH/pXJW?=
 =?us-ascii?Q?Dn8toQ8UhD4VSuNOAvt8ks4M2565IsnKiUoaH7omgERxUYVKfX8kxEfn0SJV?=
 =?us-ascii?Q?jZlPBrnSY01Xo2bKP53iiVRYsCAXRTXLUz21F40TokqWVcTVfWQjHvXZdCwX?=
 =?us-ascii?Q?AT3BEGX2nRLgvFxWMfiiXS2W93mM5UnFm7I8S4HYpsBAruAwlKjH2dA/nNNz?=
 =?us-ascii?Q?wP1DH+baSDVxcwGPOkZ02NRdT/1ney0eq13xFSbRW+potRIvmDB7jdezrmox?=
 =?us-ascii?Q?b74Np7VPKwXNVBDzQuvlCjuQMMOII97Q1OEc9amqZXjmItjyr+BFmqzJ0Wdn?=
 =?us-ascii?Q?Au3cvLi9aaLf3oFTzvTFl769auOwqa1OJu5WLBrlE84KjnRcbptz993M/ipv?=
 =?us-ascii?Q?pv8JAh5fouR5M41H7kQqCVkJs9vtmb41l7A0WpXbX1y1CTlCx4jBXBk1nZcR?=
 =?us-ascii?Q?CDkNY3m14d8xPXncJbvPhZDGPFouP94E/JmauWSGsgbiZtmsR1FrXedZ+tqP?=
 =?us-ascii?Q?e5rofs6Hqqi1P8PVZr4IvqQT2NuSaeVWyJHBwQmxyRVxktnPhzJFxIjLFJTV?=
 =?us-ascii?Q?HqfOzYPABk0V8XfLb2sVzSAWQaU35cJqK+r5v/FU0hsXesV0m+Y/18sOa1yj?=
 =?us-ascii?Q?4Ns71GbTyeD3R8q1a4aVw1Lup5C9Q0JaxXPBnAJCcwR26TSh5OeFnRJeSj9l?=
 =?us-ascii?Q?4IqHL1kxWvaKJFR5CnovBLdv9BEqlL5MpzLiAt2ZBK3kj8jq591VHP9XW5Jk?=
 =?us-ascii?Q?n0/0CtW2L0e44GNJWoSlV+5wjcswH/TBk/NeGAZXdIQc4q+yA9Lbuwhta/+I?=
 =?us-ascii?Q?xz5V5+TW/N5XNS/oe6ka+oQUJpXhNdK6STphyHjh3CTVpzJK/yhhP9ydiVsR?=
 =?us-ascii?Q?oMS274syYooVqJnL8cMEaHMcTmBovBm+CpQbVwgDFtym9g/CuwOsr6uoOqzw?=
 =?us-ascii?Q?G0mOI4bUmQeGQEqxfK3ZrdhaXn3HypLPCfeJwKtsdeoNPqBbReTevjb84/we?=
 =?us-ascii?Q?e60zT9xz43ogDVL1AYEKyTjqLPADfkQgg1mA/VKeew/DbYkiKICotZB3virs?=
 =?us-ascii?Q?HEcoPVGOTCvnSV3B1Q5oV7h0VuSwrS6Nt5Lt/qYiF4rRpXdwavgEapsA3ZUi?=
 =?us-ascii?Q?RoGNTxJYhug2tVO9HIOK7A71KXkzOfYOZP+UIeU+34v59h8lQyaxk08pnnLF?=
 =?us-ascii?Q?MRpoiDX2xTl55GhxVpk9kJb2C4zmXIGDKygc1WexYMxT/co1URdszCWFSBLu?=
 =?us-ascii?Q?Rkx5fk2O5VnLDCGXu2/4OWqkFUME736B4zJAxERhHzi/5TWvQ/orm8ZLMZnA?=
 =?us-ascii?Q?BA8mrMJCMbFuwrHRLgwtDvctrb2dkilAuEJ0NUUyQg0mNtb5QWMiqVKVEQl1?=
 =?us-ascii?Q?pNSa9xE3o6qMgpFpx/jXjkbv3jezGtP3oocEl2308QMMihqzPg56wc6jzss5?=
 =?us-ascii?Q?2TZYREePzDgV2mRfS+JNMDVH1fUQSmzs+teoGVIcW/fpwJHQuJBqFeZMTk7Z?=
 =?us-ascii?Q?nYTWGXzU4QFSPFZqBnbrzU5+1Dqsa4i5J9B87qczgi+3NGiVAvAHsQD+MieE?=
 =?us-ascii?Q?pNAdB+wjgGNgqmEy6pPjQsKOCCOOdbGpOYrKxJaWQ1ODoImqVjC57HRuSkHS?=
 =?us-ascii?Q?oxaWj8f/mOuM8ESPMa3e6zugiqAr4655ZUwUk59Z7hP7sfkd67L3bc1FcokJ?=
 =?us-ascii?Q?47/Oe3IhuJ7CYnRD/712R/VGhyUp/ehvfP3thBdx55L57yM5WxhKOlVb2ryF?=
 =?us-ascii?Q?/vnyaB0KThNL+QSDuxx+I06884pUPRo=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db30d1a3-0032-405f-3e9d-08da1f085831
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 17:49:52.7730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pvy5elqvz+QBHHmMmR5nHqlDuytfAvUPUmWP0MZs/3YFO5HEVu3xBLf+rqXGvLfSBcUyMTwCCFkiTZbkL7U/ApBXxtCeASLflq8eOZZn3Fk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2290
X-Proofpoint-GUID: 8CckNggcoiyQ0kq7Ka5h64R27tyo5s8G
X-Proofpoint-ORIG-GUID: 8CckNggcoiyQ0kq7Ka5h64R27tyo5s8G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=596 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150100
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit feef318c855a361a1eccd880f33e88c460eb63b4 upstream.

The ax25_kill_by_device() will set s->ax25_dev = NULL and
call ax25_disconnect() to change states of ax25_cb and
sock, if we call ax25_bind() before ax25_kill_by_device().

However, if we call ax25_bind() again between the window of
ax25_kill_by_device() and ax25_dev_device_down(), the values
and states changed by ax25_kill_by_device() will be reassigned.

Finally, ax25_dev_device_down() will deallocate net_device.
If we dereference net_device in syscall functions such as
ax25_release(), ax25_sendmsg(), ax25_getsockopt(), ax25_getname()
and ax25_info_show(), a UAF bug will occur.

One of the possible race conditions is shown below:

      (USE)                   |      (FREE)
ax25_bind()                   |
                              |  ax25_kill_by_device()
ax25_bind()                   |
ax25_connect()                |    ...
                              |  ax25_dev_device_down()
                              |    ...
                              |    dev_put_track(dev, ...) //FREE
ax25_release()                |    ...
  ax25_send_control()         |
    alloc_skb()      //USE    |

the corresponding fail log is shown below:
===============================================================
BUG: KASAN: use-after-free in ax25_send_control+0x43/0x210
...
Call Trace:
  ...
  ax25_send_control+0x43/0x210
  ax25_release+0x2db/0x3b0
  __sock_release+0x6d/0x120
  sock_close+0xf/0x20
  __fput+0x11f/0x420
  ...
Allocated by task 1283:
  ...
  __kasan_kmalloc+0x81/0xa0
  alloc_netdev_mqs+0x5a/0x680
  mkiss_open+0x6c/0x380
  tty_ldisc_open+0x55/0x90
  ...
Freed by task 1969:
  ...
  kfree+0xa3/0x2c0
  device_release+0x54/0xe0
  kobject_put+0xa5/0x120
  tty_ldisc_kill+0x3e/0x80
  ...

In order to fix these UAF bugs caused by rebinding operation,
this patch adds dev_hold_track() into ax25_bind() and
corresponding dev_put_track() into ax25_kill_by_device().

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.10: adjust dev_put_track()->dev_put() and
dev_hold_track()->dev_hold()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index c1ea187f56e8..de80989d672a 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -98,6 +98,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			dev_put(ax25_dev->dev);
 			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
@@ -1122,8 +1123,10 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		}
 	}
 
-	if (ax25_dev != NULL)
+	if (ax25_dev) {
 		ax25_fillin_cb(ax25, ax25_dev);
+		dev_hold(ax25_dev->dev);
+	}
 
 done:
 	ax25_cb_add(ax25);
-- 
2.25.1

