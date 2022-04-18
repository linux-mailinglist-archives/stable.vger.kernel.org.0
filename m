Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3F504CB2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 08:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236798AbiDRGgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 02:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbiDRGgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 02:36:12 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE9A19000
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 23:33:33 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23I6Ug8Z028999
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=bkcQI6No9xXOfGEpx+/ck0TnUzgT2+qdRZGGauUVc0M=;
 b=K+aOElD0IwOttI0UCYg0s6HaGmt4LiJdqytsoAbjfZjtD5uxkMXtk943amyl5Vf50AkC
 sh0PjOUfj4AN+aoS31vn/MiKxRaWZjZd8y8yvd8Wu3q7tAGwFQhElP7jw9va3AJ5pHVg
 X/KrwTVyOA9t73D4qLhy/Ss5m8Q7JYWqi/pGvL8p3cX/KxO+7/kPXN+IvzFKfu50re2z
 fDLBsOisAO0/Ru9Ur2rFOIUsOFJM/AFqstxUTqIY9a6EpSG3amSfr71FMP3QfcD7XZfk
 3/ynDib4IDIeBDISiweH4QlHB/ZtMBjf6N0SD8qfBGpB/EN41q/fDwF42XiDxYluHGt/ 7A== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpj2s45r-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erzFUkZg4b/3K5wgr5XJ33XDM4JTW42fnaDfjghINC+/jANfFe+FKzkKs8wPpJU2TYXEGNxThL7eUPtGBT3J/1Wg/IGyBEbhp1TK2Oyze9T63KMNw6fCGK6LMuxiCGWBVNgtfcRexwEG5zgoeg8CpHP5yMFpGUsxJShRtc5MDqClLwOwYLPfkej4f5+eVdSz/j5098toG7Mx8bT8q0FJBq/FPXlLBC7i+hg1Ol8J4iJRNpJ09s2Bqz1OZmV4+NADaps3fJtymZOYHiOp66Na66Cwo0UPeh/PPXADRrfzQ6V3C8C96Ad9funWZIru7lOZi/04ZNkaYOqwS8xu4+hzSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bkcQI6No9xXOfGEpx+/ck0TnUzgT2+qdRZGGauUVc0M=;
 b=COAq7Gu2bijQlagE1b21FAN1McICbpb6clPB3miS7yfsUAKXN9MJ4KT1/NT4vmtQxaSw+Wfy1863mFfhqfZJEaJU4lxrHNnSgRSTQUHWxZvZBqrypiWGbOGPCD1IpYRh6RpUZ4kdPp49RvnhudWswqbofmoubjdaNvp9/0HJI5/T17CHL5CLJKbgNBZmPjyZ0VJyeWShWqLFxsuslOWSpGd6MBU/cbvL4l9Zz0P4wRC1Y+4gn4VH2ZWQhYY0MQ7xiKwU5wM90dFuomysnxaVBMm/VkXsW7I0/B4fa0W3bAzF/yk3dJZ7eEMFw5ZZO0zJKzGEPpO1BN8yzQWCmk3mdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:33:31 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:33:30 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 4/8] ax25: Fix refcount leaks caused by ax25_cb_del()
Date:   Mon, 18 Apr 2022 09:33:08 +0300
Message-Id: <20220418063312.1628871-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
References: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0042.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::19) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a835be9-001a-4fb1-6983-08da21055ad1
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2135:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2135571A5AFEA16085619461FEF39@CY4PR1101MB2135.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vD6GXHJMOFtw1WZ/5Bi+QdMn3oRoRshZT7aResLY1LJjCjd+OLW1/0E6rX49iNbXMQY6Nxt7WullgzKy/RRCin2TZkC3GWFBNKSdnTCReGo0jITXHLksuF26vF/q+h6F9wmGlcrXPT6A4GnKzoxkauNCrCP5bl3FzgXRt+jNy5DzyuD05nTjxIH+T1VAlpyAbi9x+jYVW54mrES1TCgm9WtpzdnztrbruMFVyZKl9o4g5Qr5Ku/BGFOcWlOjeUIvQ6g03It7r0e79U/ciNsqO8HCV0OPib/Oz9vfCrNGkwpeCkTyBEaE+LRxrDTFpSnJCkGHCxyldFZiAx708gr+/hLTB3w6PVyoyaCstzhDXWQDH46zt4Qs/8qlyPEVq1dipIdsWlcLbP6snKBT49Q8hnK08BCM2+aUfqXUJB16g7k5seyRM3U8ml3jt4JJ66GvKCfjHLa4o0SA/UqGceSh/8tvXXfqn25wV5t4ojcE1ETqrcVqTnWWkU3bOvBtMNK9+S4pJ/Q+R/vSbkxY/miUM2JyUlZsrSUu5NVKfeqXfB0Nh7kknxo+WDFL9joMwE3sONAwV7ltKGH3tXPy5UChGxz1mnfRDdqd8oB6VhuSJ5eUh4McVz/YQCHfPkAPwH/op64IWRdRCfJyEkGGiISiNwYa67p7Wb4mK3Aww8Le1RqepSd8HnMouuz2BLnmvhU5DvxeKoeqfclDLU+yk84W7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(5660300002)(316002)(36756003)(66946007)(8676002)(66556008)(86362001)(83380400001)(186003)(26005)(6506007)(2906002)(6666004)(1076003)(2616005)(52116002)(38100700002)(38350700002)(6512007)(6916009)(66476007)(8936002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RaOSLdYZRbNo7md1i1G7WeyaTFdl9Emicj6VAJuICKL9BAni6fg5oJME6Wu4?=
 =?us-ascii?Q?hWUdZX2nRUsmR97sn+8R83kij5IyvdW1dx/62PGYXcIw23gJ3cvsKYWyaMaL?=
 =?us-ascii?Q?qemZQSB/BylhQE+zxmFslPsjj2AkzN51G8XDpXFs1dcXzpS9DFYBOc7HL0Ws?=
 =?us-ascii?Q?uYVrg4r8VLR1pK3J+vmOxy8WL2ynK3f9QJo3VbAK6MWnMV86tsqwhNMfcXRx?=
 =?us-ascii?Q?vhSFwPdn1sj6E/y1s/TbYzE3HdZbcjFhTGeUD71ek9/oPTtaRlswjmv9KBXm?=
 =?us-ascii?Q?1/yxaXRDsMf4gXoJof4VDvTOJ1PdVGTr22mZPTjrhryacRSg5RrB71kb9PsW?=
 =?us-ascii?Q?/pJEMqmMBFiO6nrIFlncPglGbxbQvjAVDm6+RL0LJYQo1ixA14Dl0hmatvTL?=
 =?us-ascii?Q?uvl4p+Oib6PvHkfJxzTM9JzVeQzdG/em3Q9MuNYVWVJUQRF4Qare3TzYciVs?=
 =?us-ascii?Q?NRixQAo/N1++1sRNEaFyGkqKSko3zQob4nvCQrJix8s4fodJlguVVCAtfxWL?=
 =?us-ascii?Q?30byjiIhGxGFH2UD4awuYyr4LL5Dx2RTHDZljCSa0nN9KWnN5etM78tJHzS7?=
 =?us-ascii?Q?XETAIFQ8TuOidxFXKa6avtP5PmZxj5SMVmlWzGrl4AABg1q2daAEZxnwAbhe?=
 =?us-ascii?Q?hfiuABpnoKoT9to5Dv7+fxpPxz6dfGUScJGEksMhPYQ4y4dUkXyW1gA9yfXU?=
 =?us-ascii?Q?TIlzVe2vYx0K+ts8Px47dQsnbA0x/24Ie7b7cArNW/ZFYAaRwb/Y81MpdsFB?=
 =?us-ascii?Q?fu/rKyelWLoTRn3NA7lTwejTaUXrLQQBEwWTc7qrcfiiLNIPMfObJ8BEjL55?=
 =?us-ascii?Q?+xOzdla9+s59NNSha1UH8S2DEx0aWx3eI4NOutPblb5C4VAdcddKhEiDkgzy?=
 =?us-ascii?Q?XsmQBvidFJG/KEcUxit32pA1S+aal/Zk/4FHFobLI+Mcerihp3CyOLbCOVri?=
 =?us-ascii?Q?l1dZwDjtTiIZraGgsScLULSdu24CIOglGNlRSoCxNw6CF3D33+08X+KjXgKA?=
 =?us-ascii?Q?Gv81qRoVXQIpRlpcTSLNAVQBTnJQ/LHm7v9Ehg3xuycKVMSSLJcBSoL91nt2?=
 =?us-ascii?Q?Dofg693uYCrIgbJWwKZ4t7vGDzAPPYVihVxTP+MapruH6l2IsMtAhuAZOhzT?=
 =?us-ascii?Q?fMAHIpE52cxC4O5777yZ/8wFQV+x6SAFsBcexFFbUlkUHIuKt/0R5cLuzvdg?=
 =?us-ascii?Q?1DhkHSYXesECmZag+x3O2LW43D03HriiHhKf6H2BquMFIyCII4TffNW7+GbQ?=
 =?us-ascii?Q?/vYjU8PnZY28cdrPJmgffrY0LGIHtS2YPKNfa+wItpjEOgeG3YMLRZAAx1dc?=
 =?us-ascii?Q?O3hf1WayeKo114jDwLjIHLoPClo79NvSBNKfZcUV9Iy6bWc68xnZvsUWYRlA?=
 =?us-ascii?Q?3vsC1SboHiIfYU1j8fvremAmk0Osf1AbsP8yIngAktwyXDhNvM3lI1p0DiNI?=
 =?us-ascii?Q?cxNL90XFPoBDmxA4dbMEka23kyq828uJygY51bPAtb+xWmGm5AS1prEafXQ0?=
 =?us-ascii?Q?JcoKJSOzQUD4lZ9y2JypU5O0DavVGGsBYfVaJCoexNQZOg5wxu7FD+Qa7bk2?=
 =?us-ascii?Q?3AljWQB8/bLH/AgT6fh587gvHchznA8sfOD8yBj1Hjg7xRKuj1YsxBb0u8Hi?=
 =?us-ascii?Q?njL0M6CJBhXOYabzmzLN/OL0VMyTl5gTpTINPqIREqzFrdfspM8PTD/rLyXb?=
 =?us-ascii?Q?8khUS+Rqssht1iteAYIaj1KN0s+EXDCuT0vLChi2IlnFdOs85I6mfQjxEHWQ?=
 =?us-ascii?Q?y5kCLW/Qh08wUIVpNxJF/NOzQqmD/SI=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a835be9-001a-4fb1-6983-08da21055ad1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:33:30.9354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4R/qUvskpDfd8BqVV4EqqRpOIdAv+7rdCerO9Mm2YpyXV94Gt1lO4/nl4k7KDfFSvmn+vkNXgIiJg45ASKdXBhFVAfabpZRjJUJKdLyDSMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
X-Proofpoint-ORIG-GUID: RIHWP0RadObk16wzYAMq3SKDsw33grgF
X-Proofpoint-GUID: RIHWP0RadObk16wzYAMq3SKDsw33grgF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=944 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
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

commit 9fd75b66b8f68498454d685dc4ba13192ae069b0 upstream.

The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev to
avoid UAF bugs") and commit feef318c855a ("ax25: fix UAF bugs of
net_device caused by rebinding operation") increase the refcounts of
ax25_dev and net_device in ax25_bind() and decrease the matching refcounts
in ax25_kill_by_device() in order to prevent UAF bugs, but there are
reference count leaks.

The root cause of refcount leaks is shown below:

     (Thread 1)                      |      (Thread 2)
ax25_bind()                          |
 ...                                 |
 ax25_addr_ax25dev()                 |
  ax25_dev_hold()   //(1)            |
  ...                                |
 dev_hold_track()   //(2)            |
 ...                                 | ax25_destroy_socket()
                                     |  ax25_cb_del()
                                     |   ...
                                     |   hlist_del_init() //(3)
                                     |
                                     |
     (Thread 3)                      |
ax25_kill_by_device()                |
 ...                                 |
 ax25_for_each(s, &ax25_list) {      |
  if (s->ax25_dev == ax25_dev) //(4) |
   ...                               |

Firstly, we use ax25_bind() to increase the refcount of ax25_dev in
position (1) and increase the refcount of net_device in position (2).
Then, we use ax25_cb_del() invoked by ax25_destroy_socket() to delete
ax25_cb in hlist in position (3) before calling ax25_kill_by_device().
Finally, the decrements of refcounts in ax25_kill_by_device() will not
be executed, because no s->ax25_dev equals to ax25_dev in position (4).

This patch adds decrements of refcounts in ax25_release() and use
lock_sock() to do synchronization. If refcounts decrease in ax25_release(),
the decrements of refcounts in ax25_kill_by_device() will not be
executed and vice versa.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Fixes: 87563a043cef ("ax25: fix reference count leaks of ax25_dev")
Fixes: feef318c855a ("ax25: fix UAF bugs of net_device caused by rebinding operation")
Reported-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.4: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 3c923259a56f..0e36147f92f9 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -98,8 +98,10 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
-			dev_put(ax25_dev->dev);
-			ax25_dev_put(ax25_dev);
+			if (sk->sk_socket) {
+				dev_put(ax25_dev->dev);
+				ax25_dev_put(ax25_dev);
+			}
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
@@ -978,14 +980,20 @@ static int ax25_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	ax25_cb *ax25;
+	ax25_dev *ax25_dev;
 
 	if (sk == NULL)
 		return 0;
 
 	sock_hold(sk);
-	sock_orphan(sk);
 	lock_sock(sk);
+	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
+	ax25_dev = ax25->ax25_dev;
+	if (ax25_dev) {
+		dev_put(ax25_dev->dev);
+		ax25_dev_put(ax25_dev);
+	}
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
-- 
2.25.1

