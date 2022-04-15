Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6292C502E6C
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 19:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343900AbiDORwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 13:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343748AbiDORwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 13:52:25 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846AA57B0A
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:49:56 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FHmi5F009434
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=rCqjqAN3rtQTRvUl8c8JQ5OiBXQj9289S1l+pBQUhxo=;
 b=mEWZpcEyjz05EosbmHQ08vHWKOls+e4MCmbNEww7BsJke1AkOo2/fXVnkgAiMqQeTf8t
 MMdcG6lCgpIsjw+p6qf/+fzI1+I2hsiVP0zdYadheoKzFHZ61bh+AD6IV+5v2pyOVz0/
 FzwmdQbmd5Rrl8m/Kj5TZrjfOc05NAviUO7B7PKlYB5GQ1D6XNgEepxd4OcIQGHUffTk
 I8Box+LfYxD1476eE4As25d5v3Rcfjt6ACKpBtWNLZmwJ1maCiGw4ZoicZC059Khm5cT
 UN0nuenPmFnwTqlAu9b1U4Wud7KdtVjeBMATZPRxTAQRZfR7mdMO9RvtpkkusBLE052e /Q== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb66evw4d-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:49:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdOPvQZvx49eajW5s1KzUs39E3G+KzJyGqGvfP6sRfELWsFPyTaxlMLdBmR5Zvb/qfty+11kdqZ64+b3Wi2Rxidcob/BsnO/sCghAmfyop7IFULZY5RTa3PL9PQrgSOr3F8qq1j9P+hJ17vXWqlB5mFAUUIzwg5Kg0KjdulPrwveHM6p5GtIqR0/jbE1gGJNo7Ua+rLSWT1I4z80WrnnzqvJKLIUt+WMDwly8kSq3WLauEi3YcPKJWf0KtoTcZ7cHdxZ+aPMSGT8obr4rwKYELwiJnXl8K8mn6mdNXrXUdeV3X3/2HKt3F3EjASX+aF/s9Vz3UkNQ4F0dsrf/a7Ehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCqjqAN3rtQTRvUl8c8JQ5OiBXQj9289S1l+pBQUhxo=;
 b=Ia2H9d8IAYsESELjQuhekix5qNxDi2l0uIBu73Fc/oTvgE8NWQNYvtZIa47NhsjIFiYqkjwyhecbVv/g3kziADy+FtnZjSDSbI2dkjXqtwwjgc//4sykALN25oU2h2xqH1TVsfNJfmYRRrrYjZFnYS6UFb6rL7O5B/AfoW1cwGuu6tK6sU9slfXxfR2XbAyP/k+jRreqpRQ9WcJI2XLRlsfsRoFP10cIjoVAXVjRnIQlQiSNang01sTR7AFQj1pSWc/X6ChpBcZodY9sCj+MITFv9bNPr8g830I+bLiPQL3E6ef9kGU+vWoEFjHxlOFyjQiK+s0w+uAMtncdC37GzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN6PR1101MB2290.namprd11.prod.outlook.com (2603:10b6:405:4e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 17:49:53 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 17:49:53 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 4/8] ax25: Fix refcount leaks caused by ax25_cb_del()
Date:   Fri, 15 Apr 2022 20:49:29 +0300
Message-Id: <20220415174933.1076972-4-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: ad998358-968b-40a3-c633-08da1f0858af
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2290:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2290F648B2721BC1A51F6F6AFEEE9@BN6PR1101MB2290.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yygWSbP68JgjI06NhUpYogBwoDdJ8pqMHFHqBSzvJASklO07bf8yAGjkOjxb7nfj+aaLejvF/s5HKZMm/OUqcpoNlun+raHaAA0T13e8ig/UoboyY/kU2gv1mnFGAvkoyNy2XjGbOi2awlCIl1XpyGfeIJyYgoS+JT4pD7F2TJRA69+4UDk6AL4Cu0UMZolkkPuUOYc5Z23HPXK3A1Yc1g7hY1CzGStmjTzcuBUPV+MHz5AyET2zW0jTTi+nMu404zUj2u52pwycTEMy3WnpetcoLjQyR6wlNWeNVd+ElmFebQ9qNY4Ko21QicnkysDU0hodJaRHXKqlMwfbaiVucUgL3eJjDYqgCmCxpAtRJ6UDOpdUEbQiejFHMZh735SMgQi4/CLcw4WFrHMz0sw2A6bFAxutlxxWI9P/3HYgiNfaeqmc0kmHUzrZD3qwmvHhurMP1oC7vIBfeb1emH+nNHeUtruh/5P4i7j+/cc2XpZQrdcyhLT9Nto0acjMNJi91NibxGczjaxy3J4aveA2INBo5xV1B1viWDnvivQ9naXcr6vt/s6L2HOBKfd8cDg7Fv573s+zsboPvgzqqgQQTX1EYeXzo/iWgA0/PRDGRwvWPsnZyJmXTGXnpnTevookVlMS7LpdXgCclcFBlSAiXHxAi6rGyVIk9dy1q3j1idWLcjHgR1vfPecvN65O2/nGGhnIPewCDX5Jnqd26Y+zWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(38100700002)(6916009)(186003)(5660300002)(83380400001)(1076003)(26005)(66946007)(66556008)(8676002)(38350700002)(66476007)(6506007)(6666004)(52116002)(6512007)(508600001)(316002)(86362001)(2616005)(8936002)(44832011)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dw9kpLNeekqTsa6nYm0JtpluPlqhttbi76ur9p9p0zezCyhqrZHhqfHY1P4c?=
 =?us-ascii?Q?YxA1jL/wmLe/v0fmEAWpaKd2cq/ZYIzxT0l09jM/L3qN8DCPfMPO5OGm5A2a?=
 =?us-ascii?Q?RmwuVFIVzJKINiiHC7HP6u/D412JtNejmwZu8wN87wqSk+dpJzEULKK6G70U?=
 =?us-ascii?Q?/8UtHW2bmt5pksiQ+mw/IPhz1/Qtkr71hqtn2JsdWjTPJmwaxbahpsIQyOxl?=
 =?us-ascii?Q?n0BQzslLBzFafuSp89A2NBCzKgBCfoRF7tzpatNTgkps2BBHd8neUHwZKRpK?=
 =?us-ascii?Q?psl35QZUqXw1qKlHco4q6e9X1I5dzuAxHe1dLn1NYdOnbMwyWof4iXJpv+VR?=
 =?us-ascii?Q?kga82IXjlhzpRn+SKDVFljJhdHoTqN2lsezgl7MP1z3aStY79Tb25oikNz76?=
 =?us-ascii?Q?uUY+qnf4ewXLhBU/EIOvMMUBxgdGP5GmeW5tvA0F3mixtfiZfxG0SxWOJ2gD?=
 =?us-ascii?Q?V0giClM0YUkPXWztvaImYY2mDITliti4VV/1AvvJ4aDJc1P5m9Mi4XIBGNGq?=
 =?us-ascii?Q?yDpOxuReEEjMVGOgMJiZVqrUjMvWb2VDMK9EBpLdSp6YZUCgDIC20hwNy7qT?=
 =?us-ascii?Q?zR3kS5coJrdB1owu4xxI6cOCtDN31cxG4NKwhKCs6rc1lTwZQX8I8D9PEJ4Q?=
 =?us-ascii?Q?9UKVdbRvJoRuFH3X7S8o/33ACBAMrKZK/ed13wi+1LOGCa7JyjaC37yzBKYo?=
 =?us-ascii?Q?joyx+Au3f06PZdgE3XbSsckkUxdGEZXrADcI3tpoXz2SiIlKtuDcTIDjO9zV?=
 =?us-ascii?Q?YfNgn1Kw+TbeDvH4+crnp9JTVbbDIa4zijZ1mSGl/5LAf+MkGAJ9ZUhtvBdW?=
 =?us-ascii?Q?+wBOrzQ8ScMAxq7aKJs7uxxnlgOCg07AnBhKuxjtNAEUYsXb0YnslVpaEjOQ?=
 =?us-ascii?Q?EDbfGtC88Vm3hWQuolnLU1cVTCTPKxtoHBKcgaMyW+MgXnMNJqJXVOpuaSe/?=
 =?us-ascii?Q?D/S8xS8TQnFNNtMuvAkgb0i8KkW22kndazWkGFNEtVasraNmmpq9FxmAS2WA?=
 =?us-ascii?Q?+EEnpOMcyvIS/iqPAXoMD7B69uiVSn3uo01zOCeda3Lzxv+rjuNLoX7aAF2r?=
 =?us-ascii?Q?UEw4KI3GQuxYEcOs+3jUhu+Z0jRlEcIGs/BZw7jxgUjMqPhn5BLnrvsSmm2C?=
 =?us-ascii?Q?u3qk2xsDFb1nkcMvR/O2Btn0NqIFySdluSMCaGuKdMJC7oRyGb7yS/aHeTbx?=
 =?us-ascii?Q?0FAWkqCp0v9gMEWDBtbvyukVO6OEE0BAODuQycymgkVkXgFze8htKXvGvj06?=
 =?us-ascii?Q?E/Ln7TPs3XgvUgP5V9qWyRUrmPChj0JjyhmVKBhaHP6cy9eLiN3XH8uOnv1b?=
 =?us-ascii?Q?t0r8CRL47N1AQYroGKIB2XoNB24oNN0M/Gm79jam55TpR6vjzmxMGRMog0mD?=
 =?us-ascii?Q?na5q8JMPC4SpyUxAltodnjeW/sqOvplQPTH/B4BLNpYla+Lja+FHhYPGrq++?=
 =?us-ascii?Q?e5+167UosWs+QnyfYahg+m1PWk/9Sy8uSNxBbkE1j8hJJZgbCiYA495XPKSV?=
 =?us-ascii?Q?EOkgYL69lxAmF8vcGQ0cQt62WTaA+tEidclew6SqOrOHS27ucOpY9Q0NMjqX?=
 =?us-ascii?Q?p8BfoT9icTP2HRA9sBLi7Ysy+cBZ6h6TfR6tb0/KakpSnNE42+txhSWoqjSq?=
 =?us-ascii?Q?qd4q9osloX8qezRjQP8zecRfkPgCF4EJqP4rptHKDxWrkeYZRbtgp1WVt0DI?=
 =?us-ascii?Q?oZU1Ck4YYgt1cMeswGxAp+HlJtOdoBZ8+hezNErAWUV/vNZrOt/74FvV35jV?=
 =?us-ascii?Q?TCN74dBUaqk76pb/zEUX1lVM6qf3nY0=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad998358-968b-40a3-c633-08da1f0858af
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 17:49:53.6022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXt1KpYTrsNvKX09lVc7sS9+3Gm5Tu1O/bHt5nCO2Aj3cs3sJqrDo58RfI1svTa7ThidjIObAzxn+bPLHsY9cUt/HoR5dqdHZ+ICqOdv84k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2290
X-Proofpoint-GUID: LBrgNmltN6wfZSzw2kIbnUt57Gc7LjDL
X-Proofpoint-ORIG-GUID: LBrgNmltN6wfZSzw2kIbnUt57Gc7LjDL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=945 impostorscore=0 phishscore=0
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
[OP: backport to 5.10: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index de80989d672a..c2ac5a43c641 100644
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

