Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86784509DA6
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiDUK2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388511AbiDUK1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:27:44 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03712AF
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:24:53 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L9o2Za007810;
        Thu, 21 Apr 2022 10:24:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=LL3kkhpqMZhLreqHfSwPZW+ZpZ0dJG7p2yj/VKmiuO4=;
 b=EgT7jXnzLahvfG1SkZFu9N9QEVNQ4fxXNQYpvKO7kNwGRs79+A1O85H1V7W262AhHTBC
 UTMzzrfSrodTfPu0M6bJRqC5cdFCDa2h7MpHsFDIV4GPZz9Gtwuc6z6265egiruFzl91
 QFZsOMsxrjRKpxN2x8L4+4+rV4cXOn/Q9q9i94w4a6dz6SvDXvWO5FpxyaMz3hSauNLk
 eNAZsQdj7lQ6hzjpAZbxpEeRZ9ZqqoWcJ0tc/DAZTAwD5zkll3vc5sPSjZxD2VDG2roh
 M0ZzkL86j1BaQA/se7LoMGocPCtIkq8puT2zpcuP4Ck5sykmqCaQLrtkACF4djZKOHYK iQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpqn3qr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:24:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ck99qzdiq/TRHI4icsehCWiq+h/aReczgKZ47ChcBV8fZwOBzT4v/C9ME5SYY/w5w969fNMkIFKdKdF6l8Ay8Ys0uBDtbEUgOAPjSs2cl6Ym2wZ8RWpp9ALq2e9P9ap7RpHnSt34kbowEogkRHFqiuCcttwMdaRsEsowyu8vEHBPdVwUt1/gdtgiBNNEAgnCpfFX6ZjO5v+u7dSmGVC54IM4NjCzLBqfN8NLSquza2AH22QIGOU2aob0g2GJL+TpEkqi7XdbhZkxbsuFU3RvhHpYvR/nlC5a32QWagU8/eGM1eOBaoQlSBCR3FvFT83lLl7GkqjfCRiZp0/RwmQgTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LL3kkhpqMZhLreqHfSwPZW+ZpZ0dJG7p2yj/VKmiuO4=;
 b=kAc0GwzCLyXREfxY0WbtcI7+4JTt1JCGjLOICat7LWWOmBUdJ3iyZFUI8PNswK0o33kVERaoPuofdfjKo5txv3UIJqpRfBQMBFaC6pRsaNsfx/s5XVBFAmEsTqt/w0ntECIlIGWA8EA2obj/69ftEiLeVcVAuaxCsD6qL0Xpsu2Qa+qNqD2CnBfgehE7Rq000JKGliUvrhlycTC6D0CW9rjZGR/XXzl5sPIGsbWYDWaKQxbcMvI/XhyR/raECcePPnZoRvZowsh+5ULl0DjC/77CVuTA0w443sUjk5+soRfM5WSSCsZgaAlXANW0n6m6ag9H5+igNBZGQgPb7YolVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 10:24:49 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:24:49 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 3/8] ax25: fix UAF bugs of net_device caused by rebinding operation
Date:   Thu, 21 Apr 2022 13:24:17 +0300
Message-Id: <20220421102422.1206656-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
References: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0092.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14afe604-1238-450f-7a08-08da23812a61
X-MS-TrafficTypeDiagnostic: SN6PR11MB2640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB2640B300BC77D703234FB237FEF49@SN6PR11MB2640.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1//9P90BRSXM5fgBYNUParnGUi5/RTtbur0fX0bInfkQ927FeRNH7ljnA4ViDXURj687lDUpvXdmsadii1sUPW9VMwzVkiyBqLbnl71NxzlW3LOhxMhv0Y8lfozhG4iGCUHs/grIgOxBz8gSLiPbzV4/uE58SAKByiq9UPAEhBKH3oLm0Y4KcsSbJ5vCbQwMnSfe69I4EzvHEybH888ub1YxYhjJkVs8TH8TgFZ2pDathwPDoVK+q7hfGddGJWTH/mTZNDCRhNUNusLbMwKHacvowfsX9d38frSUJQpLiX7rFSeO66E1Tqi72jcgEhSrdK2/WG2o+F/36vQXPduykN/l8qJ5arP/rFALnW13YVp8TW1ihWjq5jVDvnrNAm3xbFASPyY1PIIdmvWwESZzvTWcbUtIlQghsvewiFbboSl/F6UBwmYN8dXKiArsLcZT5ZDo3htHkEXmLkWjxwKtarL0m2F8CRQ86X2l+mIYQAPCQXzpJdmyvAVd7Nef+iWyJIdYrZ+54LsSGXcGlQ4ES2+f9xNU+aOg9nFkE3+KIwkwF9rbxsiLxQHpym6dteIFG7o8pnRcpZUf9O+oqNnGvMGIj4rEcobKTTLkCv4TeNu/fTsLYLxiRr6OB93Ah+X0L3v26YHJPup+2G+6DaToTLwvswAAVzhpDl8YDo5dA9dDJ1UAOQnrdtIfxSN2mYmjP35FbKatq79Ryv1Ss/YY7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(66946007)(36756003)(83380400001)(8676002)(44832011)(2906002)(4326008)(6916009)(5660300002)(6486002)(6512007)(8936002)(107886003)(66476007)(508600001)(6666004)(66556008)(86362001)(54906003)(1076003)(2616005)(186003)(26005)(52116002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?toWm0yXNxG/dcDiiBzji5MkCFbEq6fBhRb9rOHBbAYhDalJBHda3KWxMde9n?=
 =?us-ascii?Q?VDCQK496ljJBkL4XPfTJv/t1r22gE7JgfasYO3jWYqAUoEEUzYDa21cxs+3v?=
 =?us-ascii?Q?poSy908Ca8Lyd1MP7l7aYgSF5YHXy4raqz2zgyhNFArhfy7o/QtK6cjwvBWi?=
 =?us-ascii?Q?6WQ/tKs32KJGMgfkBeLO/rr/EvaMyM1dwEAJC5RL8WahHPFTntePYB2ly78+?=
 =?us-ascii?Q?5ntUUx8pMxgzJTZI5q7IYFg/An3Gs7FiKU/nm6ESBXhv6kBCu0q4qOK/K3u1?=
 =?us-ascii?Q?9WQ8l9YJWONaVWFTiPwgKii89eJNlBOwgQmdeV7pjLP2Ptzflo2+hiTAHL2m?=
 =?us-ascii?Q?N2zJvKuxOyau+RkvEv+f5TTtuxDm0X4ULCF0n0DdK35QQ/cvJ88XdnT8Acfd?=
 =?us-ascii?Q?4fOFctvGRONPyH2WmCg8ZZguYU2kbdFppDorCuBj/Vxz+5l+sPMCJRK3/5RG?=
 =?us-ascii?Q?dJbTnBQXFedecNhr2pLvVRccQcXFfwatf2Qf9P8F+rszO0RJ5KsTCz3i37ss?=
 =?us-ascii?Q?u9WjFt/4rinvlqUOP3ZYLZoVdm99k+tcvsb5GmXQ3pVh4zLFtGvVYQd4+95j?=
 =?us-ascii?Q?qdk6n39nyT6xyhBwWjhO7O9yCrcTR/YIHl/eKPE0rqJp0PrpNfYbVKs1HNVB?=
 =?us-ascii?Q?HVQQahy1xVCeGG1dgW483yb+rhDoiRiKgN+wEg35zLw6sgyA8nSt+l75+SGH?=
 =?us-ascii?Q?gVr54SdyvDS6tVEj4nQHMqIpD/qJflSlHl1Wsx0WSo+Cd4rLwLpQoIlFkXBk?=
 =?us-ascii?Q?ersZ5oGCbYt8uplRmdhDd+jnsDKb6INUnqKyf3Ov4sdgQ9DHd3i29svxlefO?=
 =?us-ascii?Q?R2DeYXSUJPP/j3s/IpNz70ljt5+kggKZDCIozx5Q+yc4o4p2PFNY3agDVF9C?=
 =?us-ascii?Q?ehlxo7urlLCOIJaiaE4HKBRqiVax+AaYgGfUcoOgWhL55eJp+3sO9bokl017?=
 =?us-ascii?Q?8NkqKpW5vhTjgu22Q61YzMXH4Y/cfurrNViGcQjgYBsHdZN0piKFEx+z+i4V?=
 =?us-ascii?Q?a92zaDHtYiQEajWKAfjxPVFZbryPi6FToh2uTflPL5MpZSbgryw51BlTJJe/?=
 =?us-ascii?Q?7U9YQejwLvwISIqw5khXyA710of/k8kVJgSTewl8ro6j+EzMpQxhD6znfnWj?=
 =?us-ascii?Q?zhKW6aokwURNFoXg5kOS5UFPpArAFYoWjYTsCUwbF8fzBY5gjbkgc4kgDs0Y?=
 =?us-ascii?Q?UxKcxvYfobT3Q5OD8yZtVN8pBDIqkywDdwIDS7cbMWhyqpXH06VigdYDRdl3?=
 =?us-ascii?Q?38awwyuGq0mtF1ftfymPZQe+5trsJoDWAEO6GxY9j3JQ5Swa3yhGiuxTACMy?=
 =?us-ascii?Q?NzCYYzh5aRotvc2QVsqeb6y/BH19TeTrmYgDYiMnHkKmAZscOeSeDGR60Ryb?=
 =?us-ascii?Q?kQFql3jegJEYhgIGCh4GyUTK4/2RWdZwW1lMAh7zL5lzRWqNHR1dIJp6nSko?=
 =?us-ascii?Q?wi85GUzRVRqVkq+DPN0Qbxlwl88we/rWhF+JcqRdwt2sYRWnuFVReZ2u/1d/?=
 =?us-ascii?Q?nHZ/X2tdhCzFj2yqcIqgffhx9rl9Nght6bl8zDrjtbKE3ZTDOjInrU0/QgdU?=
 =?us-ascii?Q?T6gYrs0ruGQfdrLmWkQQQZDTU/L1cMrFC12GDaY6vSH9aIr3SId/Z1y+sgjt?=
 =?us-ascii?Q?MFukbuXnxQmSpG0IwigUkSr3sfx/mVhirNOW/pln+/cQXMTjMZtkIRFIx3Ah?=
 =?us-ascii?Q?iUBjdHzkRwVADOJ3RvVcnAOTfbNjpGAAebM4ihh7NhmmPFW3D2y/IPrL05aC?=
 =?us-ascii?Q?bLJmbZirObqr0dicvncGCvEDdwg1KUo=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14afe604-1238-450f-7a08-08da23812a61
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:24:49.5912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Hf6VYgVemSGecPKX8jx3WTdHaBxlzUREXrN73f9RS39M1Wk8nKHdeQ5VxqPSLm4i3iAARE02l4RO8HRyhoNAPdaOfgghHcgwyw7Ltdd+lk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2640
X-Proofpoint-GUID: h6l_QjUarR-c22uX9SSpFi8JXHKdDBH8
X-Proofpoint-ORIG-GUID: h6l_QjUarR-c22uX9SSpFi8JXHKdDBH8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 suspectscore=0 mlxlogscore=598 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210057
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
[OP: backport to 4.19: adjust dev_put_track()->dev_put() and
dev_hold_track()->dev_hold()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index f605549fd25a..d5cfbeee4777 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -101,6 +101,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			dev_put(ax25_dev->dev);
 			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
@@ -1125,8 +1126,10 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
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

