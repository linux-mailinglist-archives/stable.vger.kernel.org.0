Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD73C502D8B
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355750AbiDOQRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355280AbiDOQRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:17:12 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7E11D0C2
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:40 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FG1FUT001455
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=uRwaQwG9qlNg8RN3AkVhX+YzVm7u7NzPtTnE3gmHicI=;
 b=VUM6ISrVe2d6/q3QplP4w0DqcLmQ9UJo3vW66iVcBxormpVzPsyvmxunQEbyZ6UEMdtV
 aFs2roGNyIwJwHa2yFVWO7SpFsjpzmBVIuEH2DlLQxh7s/cTO4bWtn2RRfe5gcMHkCmU
 BZRcCaFYWU7Xqmw3tCg/DpeNQdJDP1nQukqoO9II7RR9kpeBNs4TIiXzcetFP61bLGta
 PxbVqwAlKh7BA/9VdD9OrENV8+41S8yGpXuiwuDaPbxk8YRJjkzWNkX2nev8txvq60LT
 DkNaXP2Ae0arX9jEP25iT7wLP7KyO+ulEhocZsrfg95Bi5ZylTPHtrJpT2TGjLd0iJ9M rw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jec5h6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jq4Dvs7lkQfTZbTYAB9HY3OQA3MjXsE+JBt1RXdjvrBf+v9iIaHEq+uOHmeepi4MsJ5aMwPmMnc7fn/n+dVqUV6AEoLD1drv0ESXOkA3Z9WpTy9AwxL1aM8EK9B1HDtay/1dzu8CTWTJh0xloPxI7CSYCa99KTb5dMYzOOzBzJDi8pPsAIOhs43W9Av8h76G/Ah9EwXvoRj60nZGCLVUpFttcIQ5aaL32/7QCTtghZxxhH8FlpSfw0/hxAdutCwleF6HlYZsJNUHLnR8lb1RHT2UBbF3OQ89TN1chqXlh20lkr44+FaLssKXdmlIvW3nUWmEfT6Gt2sEcvllaCBRVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRwaQwG9qlNg8RN3AkVhX+YzVm7u7NzPtTnE3gmHicI=;
 b=CLawfcVo/q9zV1qVWyj4sLP7Jmxvrk3keSgnlvxGwiTa4Clv66Kxwum/pHGZ9vK057MSdDCd/im5/T6DzCz6fGafuPcdeaBtBmqAkyfnwNzmJDXlH5C6z1vxw+TWH/g9xfz+6mSIDB4VQ5dDSL9I87ZPdNHwgRIhEBYVz0B8Vi3BEe4VvilUq165hPHhFOGtYbQ14MRuzBXnPQQSCIM0nT7qVc+x0nSsxRt5pGfvebKg87HAyI8Dw7bBKIl87BFNFFYlGPA0q3BKWCcaixmWHfGdQBF6cCBo3vQQZZiKHSY69DM9JuOdALA/6fZwDXCx12SCNjmcf8o3mT98ts+5kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3626.namprd11.prod.outlook.com (2603:10b6:5:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 16:14:38 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:14:38 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 1/8] ax25: add refcount in ax25_dev to avoid UAF bugs
Date:   Fri, 15 Apr 2022 19:14:15 +0300
Message-Id: <20220415161422.1016735-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
References: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0009.eurprd02.prod.outlook.com
 (2603:10a6:803:14::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30f8966a-6e4d-4ee8-679e-08da1efb09ff
X-MS-TrafficTypeDiagnostic: DM6PR11MB3626:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB362693B41E2861D3F86CA750FEEE9@DM6PR11MB3626.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ekiMXol2/OnLF/kldrcBFZXCk7TEZuDWx0Wows9jLD6PElTFMQ5G36kFcg3pYoXjvwGZ4F6RVbyrb+ghyg9FDg+rd5EzTuYGAA0s4/zvDVRylz8FHo/jmCb2iLgNRMotpZCQu2b5rql1Y8ierfJHEnjsUDPgW8KjPiFud2BYidXqWdH4KM0GwiuNyQJZ8cAaidUo3u5PxsSvYlMPb5CKizlN0zcalSxzpzo2ZC5j3DlbEty4IuKBFlovIp3wwtJaPxUMO6sTyujwHi6TEA+3WiMoWCmKJ8r668aAWKJIiRDzhkEADDc137g2rWmrjuN64gEHLQt5N862SxfQNWLNCkDZIHRfJ+IzU+NpTCC36nxajqcgYkrN7pVZlzYmmsKLosGfoCt9c198+fPIe3mplh7dZSFqLjLEgN7OdTFA6cre3WP6m4q3gdzq5vtx/lMmc0MYpqLdSCd4XhcZyWzoRDUMfg+fbx+qlKVr/8f2O18z+MdMnPhHD8M2CQyQq+5GnNZV7hNNu8wX1VBc438sraNDTwrE8AEprYYp9K+JUMPQ3JRXNLdSyDovGFcER1cEhXw6iQBJ9DvtXFc9D78yK3J9BcP6n/YNU1g5a+HkWTuGyymv6IYQPjFEvDozdAO9tpNrtmmW2WSs68Hr/UOpb0DDE3O5oucMxpvbJ1flAsEN5Krbh+q7gyAr2efsb0RB4sTR+eFOnE1Ej5zExnotg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(38350700002)(1076003)(6506007)(26005)(186003)(2616005)(6916009)(52116002)(6666004)(508600001)(6486002)(6512007)(316002)(66556008)(66476007)(66946007)(8676002)(83380400001)(36756003)(2906002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V9HZwkXL4gKbHigJ4XI7+zwhrCVFM2vuCsM+kVLFDqmK5KoHge3pW7/vByRB?=
 =?us-ascii?Q?IJJTDwLKEqNY3mEgd48n0TUP8LAO2fMeChNdYLOQdMiuU4WrFN1pzd7sq+x3?=
 =?us-ascii?Q?1shRm1JU42cW6fDB/2K0OrNXoXIfG5BMKact277e02oCM/Hj8NsfU6akBZPk?=
 =?us-ascii?Q?PIfvAf1+liHN2HVWs+PwbIXxDCF3Xz2tDea+3gzgD52FbCaoZ6Ot5+A2MWs/?=
 =?us-ascii?Q?6bRvoHyOn3gxZagyYBvdJmTFKcKQ2Ob9+qD+GSEHS5Dd0ykQi748LoN/P8BD?=
 =?us-ascii?Q?2osS1KVe6d4bqahc1QCCocMrgDyg9RCkV3kMqx63U12+fFZxYbuA2xJn9hd2?=
 =?us-ascii?Q?XdfhO6zctfwS7pYBWes0X/bQ3yAx2MClrOj/3MvUulAujCXVRXfpd4Lbh4JC?=
 =?us-ascii?Q?lKyK6T41bB3Wu7htqPi+XIncqlR9OWkEoeSDnE1GRlbrSyI74+mvPZyQoQXu?=
 =?us-ascii?Q?e1mTkZw836dwQUwj0nhXMB90LtM1oxI8cvLoKhipd1lKT0x54mIfEPQD9/Qm?=
 =?us-ascii?Q?JmZcN2eoIEovEZ/CZpLEqeuoO/xbLqZ+mmaHcEZrpp7gu+DEexmFbVQQs+2j?=
 =?us-ascii?Q?CXmNOh48aux5uE5jlZ63PK6RHI50NGMxlQWHkUOdiYF3OvW0x+eANF2NgvcH?=
 =?us-ascii?Q?6bKZSWeIdD95EZ7M/UUvdxtRWDSn+9Uzo1WlY3BJNDE0JpTBRQivYxdi6yP6?=
 =?us-ascii?Q?9FFLar/MgCfdXMGVUbaEYJZGgAKZI7J5NPSnFY6Z5hPlGzN2Zjp9R45cZmcs?=
 =?us-ascii?Q?KA8OCSW6UojmoFngieFILiuTZHwX7mGMOnsm3YZBtFKlOBNUQywzOSymY7Mr?=
 =?us-ascii?Q?vwD1QR/0P4QWAHkYPLSh+1VmLIRHn2QdlBLu7pK+oFFChEyzrCkZ1SqXletJ?=
 =?us-ascii?Q?HCZhdHJ04Fs7cpJTdFsZdEwC7e6Yq1k2kjHNdKB7dDhv7qTVRghoS7lXbOwt?=
 =?us-ascii?Q?1Lzuc/aX3V1f8P1m0f3Sfcdlw1Ihk2WAJ6dm/80YcAlia6gKO/2Xm2fAUpox?=
 =?us-ascii?Q?R/Pp0Kd6J/SJQC3M+3ZK7tALgeKG4kc7xeyecXo2XIQ602XjCndp6eVZ+Jvp?=
 =?us-ascii?Q?Kfp9BNqiEyRXV4lJIJUuf6Pakbb3IU3YGxL5UAkXn9TtkamXgo0FeLCdPRLB?=
 =?us-ascii?Q?9Nm6wrk2XAvWNv6YLv8pVUZiPZC/n+0aGFnqpYHPo/09nlZ++AaqZRGrvxsB?=
 =?us-ascii?Q?Zp3DAnkk8ra+YL9MT+G6krFTjEPL1jtodFLiZxrl8VsHwbMCY19nBVjADlYW?=
 =?us-ascii?Q?UEPzyjTz8BZvKcNZluv5A9sbyGRxfWfoIxKMf6xGDlnUzFNn+Q1XuvuecGqV?=
 =?us-ascii?Q?xglrcKy2jlkThm2Xt0IdgML34ShYuouSpPh6NUob7I0na/poUUTV1n/hc5iO?=
 =?us-ascii?Q?bLzRFPwGjQPWMeoY5S8NrfDSeeanaWTIuhs8DrHp+/eO9rFvgjkOJPhahPd2?=
 =?us-ascii?Q?EbWhPA0js8/Bz5gbVqsl/0tysOSJEdqyATf8+Nut2sepAzP1sYyaZWAgg/j6?=
 =?us-ascii?Q?y8944ugZKZzNvP/AALANFq44P306qQpLZREm7VU0jDIH+NbzDdGt6ptwQpNf?=
 =?us-ascii?Q?QWJVdzfKggGVLxPmdz+V3xVK5BMZvei/V9b8xc7XMYDHp4JXMYPhI9XaebpR?=
 =?us-ascii?Q?ZTa9lL6g4wBa4klLROdFvJqo/eLTxm3NHjrEtDbMGaH08+xTfCN9mGcbcEHm?=
 =?us-ascii?Q?eqG6c0zzEhUqzd+9gB0t4+RjRrDNhVWohV0vMgdmOmkJQRbhzec2gdqFU4Dq?=
 =?us-ascii?Q?nRurzf14w1G8BoKQP3YRRnHEacZrsfY=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f8966a-6e4d-4ee8-679e-08da1efb09ff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:14:38.0798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhwOYhQRLjhSxZWhSENajem/0bt8H1jdXFOjJcXPIEDD7jEfIvWUw3lkUsRF/2qZbVJ16JdS1lx4jV9GXAJXX4131wOr/6f7feXXfjS/u6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3626
X-Proofpoint-ORIG-GUID: mipDCClUDE7DNlhu_JAC4UK6ryYgysbz
X-Proofpoint-GUID: mipDCClUDE7DNlhu_JAC4UK6ryYgysbz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=812
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150092
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

commit d01ffb9eee4af165d83b08dd73ebdf9fe94a519b upstream.

If we dereference ax25_dev after we call kfree(ax25_dev) in
ax25_dev_device_down(), it will lead to concurrency UAF bugs.
There are eight syscall functions suffer from UAF bugs, include
ax25_bind(), ax25_release(), ax25_connect(), ax25_ioctl(),
ax25_getname(), ax25_sendmsg(), ax25_getsockopt() and
ax25_info_show().

One of the concurrency UAF can be shown as below:

  (USE)                       |    (FREE)
                              |  ax25_device_event
                              |    ax25_dev_device_down
ax25_bind                     |    ...
  ...                         |      kfree(ax25_dev)
  ax25_fillin_cb()            |    ...
    ax25_fillin_cb_from_dev() |
  ...                         |

The root cause of UAF bugs is that kfree(ax25_dev) in
ax25_dev_device_down() is not protected by any locks.
When ax25_dev, which there are still pointers point to,
is released, the concurrency UAF bug will happen.

This patch introduces refcount into ax25_dev in order to
guarantee that there are no pointers point to it when ax25_dev
is released.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.15: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/net/ax25.h    | 10 ++++++++++
 net/ax25/af_ax25.c    |  2 ++
 net/ax25/ax25_dev.c   | 12 ++++++++++--
 net/ax25/ax25_route.c |  3 +++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 8b7eb46ad72d..d81bfb674906 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -236,6 +236,7 @@ typedef struct ax25_dev {
 #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
 	ax25_dama_info		dama;
 #endif
+	refcount_t		refcount;
 } ax25_dev;
 
 typedef struct ax25_cb {
@@ -290,6 +291,15 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
 	}
 }
 
+#define ax25_dev_hold(__ax25_dev) \
+	refcount_inc(&((__ax25_dev)->refcount))
+
+static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)
+{
+	if (refcount_dec_and_test(&ax25_dev->refcount)) {
+		kfree(ax25_dev);
+	}
+}
 static inline __be16 ax25_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
 	skb->dev      = dev;
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 735f29512163..954196ef7788 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -98,6 +98,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
@@ -446,6 +447,7 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	  }
 
 out_put:
+	ax25_dev_put(ax25_dev);
 	ax25_cb_put(ax25);
 	return ret;
 
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 4ac2e0847652..2c845ff1d036 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -37,6 +37,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
 	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
 		if (ax25cmp(addr, (ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
+			ax25_dev_hold(ax25_dev);
 		}
 	spin_unlock_bh(&ax25_dev_lock);
 
@@ -56,6 +57,7 @@ void ax25_dev_device_up(struct net_device *dev)
 		return;
 	}
 
+	refcount_set(&ax25_dev->refcount, 1);
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
 	dev_hold(dev);
@@ -83,6 +85,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
+	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
 
 	ax25_register_dev_sysctl(ax25_dev);
@@ -112,20 +115,22 @@ void ax25_dev_device_down(struct net_device *dev)
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
+		ax25_dev_put(ax25_dev);
 		spin_unlock_bh(&ax25_dev_lock);
 		dev->ax25_ptr = NULL;
 		dev_put(dev);
-		kfree(ax25_dev);
+		ax25_dev_put(ax25_dev);
 		return;
 	}
 
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
+			ax25_dev_put(ax25_dev);
 			spin_unlock_bh(&ax25_dev_lock);
 			dev->ax25_ptr = NULL;
 			dev_put(dev);
-			kfree(ax25_dev);
+			ax25_dev_put(ax25_dev);
 			return;
 		}
 
@@ -133,6 +138,7 @@ void ax25_dev_device_down(struct net_device *dev)
 	}
 	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
+	ax25_dev_put(ax25_dev);
 }
 
 int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
@@ -149,6 +155,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 		if (ax25_dev->forward != NULL)
 			return -EINVAL;
 		ax25_dev->forward = fwd_dev->dev;
+		ax25_dev_put(fwd_dev);
 		break;
 
 	case SIOCAX25DELFWD:
@@ -161,6 +168,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 		return -EINVAL;
 	}
 
+	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index d0b2e094bd55..1e32693833e5 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -116,6 +116,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
+	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
@@ -172,6 +173,7 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 			}
 		}
 	}
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 
 	return 0;
@@ -214,6 +216,7 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	}
 
 out:
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 	return err;
 }
-- 
2.25.1

