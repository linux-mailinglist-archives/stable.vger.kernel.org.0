Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4399504CB9
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 08:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiDRGgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 02:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbiDRGgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 02:36:11 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183E018E23
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 23:33:31 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23I6Ug8W028999
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=k0R+NSJx9JyOGPxgRNY86wftaYU18RtBkiglxchJDmE=;
 b=Cq6dzYTMfgc5K3Em7waRaZ6UkGtaqEy1VI5IcL7hvnorsPXAYHfuQUZd7QtByXaqCFlZ
 Ft41GbRaRNblJe5h9FAp2W+10vdrc0Q30GMa5cjK32f5AOYhLogt1u6IW4N8LI39jVUD
 Fe4JSt65TVk6Mr5+mOevMGDSDLrAbDjIKl0KQe3ig2rNek/TC+ummbqe5WRI0jFl/y65
 ++SCgif3Jvy6CIIEP/N+gbgLrasp0Pe0cbhUqKfGeVZgbsLDVu2qFp/KLljz21YMIq4y
 NGzREa8Ag8/9gv4V3OZuR8v7tJBl8oUMjTV9kPzISvOMPTtAWc9BRMDXhnvy2y+7RaaX yA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpj2s45r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XR31uRd6GuD6b2zHEzu6K+rBzv9Pe4yW2oF6Z/aXJRmaAeUzMbjIOfdYMq/KGnraLdwDPFJAF6rA37FFOa5cZ5ky49lBzc5kgRi6gNA9SD7JSRyLA3IUyAqtHC5PRlLWgtpOq9GJ9NqnG59wvyyYDcBrxUh/NVMX5Z/+qij4U6B7WqPzkXf3CrrzYO+uQKzCd4TOb/3H9KN04sEKFPH0hdBFsn1UuIsAHQtjryrob4r098/+V/ZzrVK8Gn/+c2+9GO/jHK3KmrjqX7jqubs8Ue/0ZInodlqKIJNQT7r1hAJt+hMTc3OeaSnnN1QxR8RG2vXDjnaSOineiHi1ommKLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k0R+NSJx9JyOGPxgRNY86wftaYU18RtBkiglxchJDmE=;
 b=lyslnGNbW+oelo2QHXIxCj0UKl9o+gFqoksitExx0y7uyIzuCs9JgAwviUwG9an1FN+cHIxZCkPXM7yTyVPNoUaQs2p1OaFAI1deDS6qvS9oqwzAkgtKil9SsyRDkkA+wL9yzWRcE9HpyCP9KT1yyupSuFMS5j3eF90yxMXXgU8sMPZ179mrqiANbLOzsQmzY+VgWYzMiaKPkwuuWaCW5sQo1Utx0sOX0sAhcc6DmKfhwiYuYp5BADz5VXpCtUYJPh+EVcccBVf8+Q+6wcCdkD2e6Vb6QDagxufxQr8yv+q5pHlM0jdGAOCbyfSmjomrjGUZyotwSQp8DZ1m3ze6uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:33:28 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:33:28 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 1/8] ax25: add refcount in ax25_dev to avoid UAF bugs
Date:   Mon, 18 Apr 2022 09:33:05 +0300
Message-Id: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0042.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::19) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb8e1cbd-6ff9-4c39-6cf8-08da21055958
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2135:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2135EB8A325AE71E46F9AAA0FEF39@CY4PR1101MB2135.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XaTLDcipB6Q3PXM/LvdtmLhRuBsIkpaAcCVB9GyMBOvyZMCTRSbo+SM4jEmHyGzZ3frWTYMemZ3rMTLHuZag/ET5gMasaJ6S6jdsJT8U6pQ9qXEmm9rRuzWkBQj2i6CiKwhDu+QoTi4YeYQy877qv29YUEsHhyI9cJraIolONVQ1JUSvjx4yFAyGZ/NUye8/uavvG92HTy2E7hk7M0zhacCoKcM3q1M+Rfszz3FbClGngVOA6lYHUYz9zeDaGQnQRj83dCcqjWHPcnzmeIGlOcAlOWMN2rlilkJuY0yRk/RERax5p3AoRamfZwxHr9TSuck+p83qIfQdS4LSguZ7OnHSMbBMXBi/d6xkzAOUM6PJnpGowvFFuFYjgRj0TsaygVbnp4YHjdv0e3aHlSq6X+HQphV8+y+cZkNY3K7GhE293om9y/t/ujZuD7ZOCUPd3MSnn44Pcl9iT0TcLlvsola99m2sqq/54wKOUC0i6FsH0yYHfa+Ehlbi5wjt1sV5Pf0qi6u9Xk7KOMDg7OM2Pnm/W4SgHkbpU3hDCod9+M96MpqzOHahR/38/Yk9UV1KYpgWQo13oKD7xFQrA+tdE2vO8J5q6ZO2AZu12AA3fiMhmTLG/o/V6QLkiq4Ln2E4Cei7G2/tG5HgsP66x3sM7CstHufRdmy+wX65eDbWWb1HCCzvRf0oh1pEQcU4Bw1oJVxPTQj+Ig2+lpBN1R2VhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(5660300002)(316002)(36756003)(66946007)(8676002)(66556008)(86362001)(83380400001)(186003)(26005)(6506007)(2906002)(6666004)(1076003)(2616005)(52116002)(38100700002)(38350700002)(6512007)(6916009)(66476007)(8936002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YNFt/DAeAsL7/hiGg96ZsWQ3t/JqzWcA3gBjigiskVcMJkjQIH8gsEwceVW4?=
 =?us-ascii?Q?51cNsj64hg4hfprBSZRtsfu05spONsselcNi7cL2dPE4aB75CGahNWX947+W?=
 =?us-ascii?Q?hLUSkGgJf2D/2ikMeP6iDfjG9jy4MeYAWm6M/V5XA2ArqXHEkTOJJx24Kjem?=
 =?us-ascii?Q?m0zxikFbBegG1uwzMc858yp/iSCzUUn/66HssMuRSECBYOp0bFJhN3uWKGTl?=
 =?us-ascii?Q?fp5P9EsTRcpT1Q+X6rZoQiro+Oa5tR3ZNLv5YjEK5FNiAtb6ErJ4BhkjekIF?=
 =?us-ascii?Q?73F3ng8BD2+GREGNp9ViFq8AYqPNvmlcYhe1S2q+VXr5E2jHvbZ9lyGSzeQI?=
 =?us-ascii?Q?I02U9wXWs4vWXjywUjXMR4+BaY1yO6c5WwPdMsYCmrFaAbowDhfW3D3q0Ylb?=
 =?us-ascii?Q?uUnnioHBHKlViQmD1EObF1NpGYSST5W8oa6eosWo4M/2Hn9YrdQu1lFHVZQ1?=
 =?us-ascii?Q?7LVkfyqXLADrkv0awnth2IWtrgb1NkmrDsVhvzl3sKTpReoWb9YvwHa4LDfE?=
 =?us-ascii?Q?c8SOkVTLPfF9eZAt9pX5KAb0ry2tSzdgsJN101U/YRvj9YQbT77FgaRjFAOU?=
 =?us-ascii?Q?FUVOLorxat2pewo9w+11XBIjTQn2Qv0x1XArKYNiv+HZtPLnW8+AnbcY2XOv?=
 =?us-ascii?Q?qzsQ3p+Gdrc6ar0J09n3HUzk2J5e+HhSyDJuJ+IWp5MRAFfqySDmc1zB6PoA?=
 =?us-ascii?Q?Silh0W1NT4x5bAHvQVjFGE5zLBhO5Wq+MgvyAiYD0Nj0aVXR3tAGysiTYi/j?=
 =?us-ascii?Q?zrWIIreQ32f/uAZbP5ta3II8yfEGOVaH3u3wFs2m5yMTUDBPrxSI8T6G1Y1x?=
 =?us-ascii?Q?j0ut0B3kzRpyrURwEV6jm0oVKiEpXVad+pAwt7ZhZ5dFKDlGTm98c4N3JLiA?=
 =?us-ascii?Q?WWdmLHzwUCw8ti9IlzSVYI6ZfNtsboo0AH9Lnr0TDEBMCwSsLfGiwNsLT9XX?=
 =?us-ascii?Q?gyPMZQfr98Rf2aFCHTxG/eXQ6Mx9WxEGPmKcGZABwpcRUI+dB5dctK3eKrq1?=
 =?us-ascii?Q?ab891vSyyx/G73aGFQCs5/xnM0XzbWscuq77GFeHQhu8B0EA5wR2GTaIz56w?=
 =?us-ascii?Q?1PiD5kp8sphIWUkXO6hPcRk4iE520qkwj5VShdAQlx8Tkxw4f9WGWNFlOP9D?=
 =?us-ascii?Q?ct1tx6v6vvqjuN46u9MsRg9B/iS6Jq+IMF4c6cr544xkV2zONBW6qkgfBmf5?=
 =?us-ascii?Q?//93TEzwQv14FgadX9d/F/OsyOpvayApWxpnlz0+XcWGLb2oL7regzJAwPo3?=
 =?us-ascii?Q?0Hu7JVabXfsQqW2g8sM4Euz6Bxrmg/XdyOIslRYHaplxiuf1jwxDlYyTFj2H?=
 =?us-ascii?Q?K1vKkCnwUpH8EPH9ohhqH1JlErWbBXukc4RtU2waIcaJ/H73jL93tG9qWcTC?=
 =?us-ascii?Q?8m/d4m9cfnxAIaSewpBIs+HNTepDeG+KFgwPVt0bk0E+EINrKQqc7pclcofI?=
 =?us-ascii?Q?r2wGQ7kOcNYv35y3xNDDHO1BU4SnMUnESzHLiDeczJbu4NMXcWcS6nBQ9Pyv?=
 =?us-ascii?Q?LHnvBkLOESlx8SFPoDu3DE36tkbEOhiumqkQRz7nQ5zAiSSIz/b/yypjjv/V?=
 =?us-ascii?Q?Lqb7eysUqPzx1P8atE6SFDsahNkqoAxL9VpLlrh/4KP/7fBsuzIMtb7NAAbN?=
 =?us-ascii?Q?xqeqH30F0UoGRqY2CQWmbPEBOkv9zRct9U/lkYTLuwAOh7V5J0TgNSktdqpS?=
 =?us-ascii?Q?sxR8lO7srTuviel7Dn9IYYiVHPyNJv5ByS4XYD+0tMrBu2dg4tH20sjBef9q?=
 =?us-ascii?Q?71KUgO120Z/4SJ3xsyuxlLP/i4DnE0I=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb8e1cbd-6ff9-4c39-6cf8-08da21055958
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:33:28.5272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJn6whlAtRR7w6AhtLpUi9ZhyN346Xybg7cM5Lm2DkKaurkhZVNiDdm80T+l0iJbstCOJTv7x9q7JfZu3Akgi1+J91Ynkpxe7EEvCjq2JKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
X-Proofpoint-ORIG-GUID: 625q_tkl6J9li59mL7FFY9j_0tVsEiI2
X-Proofpoint-GUID: 625q_tkl6J9li59mL7FFY9j_0tVsEiI2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=783 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180037
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
[OP: backport to 5.4: adjusted context]
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
index 093b73c454d2..211a997784e1 100644
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
index b40e0bce67ea..ed8cf2983f8a 100644
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

