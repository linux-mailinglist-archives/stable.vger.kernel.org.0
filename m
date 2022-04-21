Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2930C509DA8
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388379AbiDUK2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388545AbiDUK15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:27:57 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE471400A
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:25:07 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L900Ef031125;
        Thu, 21 Apr 2022 03:24:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=qQr9HHQNIFja6KIAaTZ0Q2+H/VPmBcp9Vdf5roZEAv8=;
 b=jXu3DMw19bTXTN7HGoWXS2O4Z99YZPcc4XSWRg9EMrWeJu/6Li1CmOVcfVkYPsGk/i0b
 PY/wvzxoqulqL++UfFqyrdhNx+OdsnD6+IKpFDq0cEsXaIKvciiZsJSnWlD2Zqo1vgKQ
 iqSIEuWagRVDkzbyhsVK+/IyOUcTqH+5R+zO+TmLqIN1HMdPLZYbtk5d+sFpXkaDTDc0
 8Mcs5FwbAbLoZ+mE8U2eEeo9OXz+Dx3dJ7NnE7KSnAA9DCxVUmCunS1o3CCYwKqWu2bS
 B+zAvTxhZWKMRVUOAuR/S3CP7ePCWaUc95IW8jmspy4K4uEESlUajDygLg+DIWACVkZM IQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fhmfc1wxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 03:24:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfDAx4eXp25Gcy1ppw23rub7m2ORJpzrMigdhGRT8at4o224K2Vc/KyGpLuh9a8lJEi7Q1sfk1zkuqwDrTbEeuH4Lba6fBpVvN+fexhbsDcCHOKLN28UvoUKgqYwiLX6IoQ8EQQc+XjHO6EujgRO07T7SEnszbagrU8XuS8QMg3wMxD2D95dIICX+Z5r1NTqchUfO5+6IWyTe91AC+TTTGnDbPpZ2eEjPUjPg0mlViiGTZ18uTFcedmLGTKCNDpiWRtv2zLaFTik2xSIg3XVqxU1ya7OMWX1y5YdrsOem+fDEm1r6FSSSRZsexEbe/Wyrxr1QFnSE5qLDYLGU7/dzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQr9HHQNIFja6KIAaTZ0Q2+H/VPmBcp9Vdf5roZEAv8=;
 b=BHBbEvdPRLXEjDgwgllTaf6g0I1WLy5xNoQYodls7BLm7CS1jiCO7F+yFz4M+GVNtauwlyZOZAnlQ7tRuON4PyVYXp3fgBwkMfRWjcqhURAOT1ePDkgDv+gPdREQA/PEHgpDjZ3crfH5Crp/5g91TqKrMfDA3txUXpO3g89tCLRuUtHZ4TArLSerDtBgDIjSsV12MEPiwdx5qD+LUYrYYviW6SNFWrkvj0+4CZ6g5yYQGt+n0JL0QMkOXihj3As/jKL951BrttXOiD+e/6FkakMQuPGoe6apc1Icj61eYzNKsfcCYH/A88PMflOZBR/HkfIsu2xNti93+VHpiHj3UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 10:24:51 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:24:51 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Thomas Osterried <thomas@osterried.de>,
        "David S . Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 4/8] ax25: Fix refcount leaks caused by ax25_cb_del()
Date:   Thu, 21 Apr 2022 13:24:18 +0300
Message-Id: <20220421102422.1206656-4-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0f25ce1f-0114-4861-fd92-08da23812b3c
X-MS-TrafficTypeDiagnostic: SN6PR11MB2640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB264042FF25E8978E8AB952BFFEF49@SN6PR11MB2640.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tLIe/NfwHyvOs6rHuxq5qjQ33rbdkqAc9Oqnd13UTgjQ7xnf1OrUZ+Wu1K18+3NSIba8U44vxX+j37CYAEAlPOS2hIjjGPszZVrvIfGR4OdqnIOWWn0GENbhaa61Puvry3qM99Q5AHOZKWPXF3DkTPgfo/2vWtZrp7+0bhz/1vhC16WJ4dEgKShNRf1xvKKPs62X0qndxZdpBz0rToeJdd4vWtwGcoxW2vzPe3ujqiEzjioKnFxBE30aBqBLY0/IfLIolRDDKe09FG9AMbv+TzUS7c8U28ADtbHKSIIX6mlqW8KxX96tBPNSQKcX6ZiSgK6NXBK3/QJkVcLuOgGYOrr/w0RmIjTjBAPWSiDEgf85yxGlz+1hG1oq8qOoOzGFB6mLLBtjdUrorQ10jmpCRyIr4asTEHQ7fq7RCX83TlAB8LXrD5RMusM1NVdfGTyg0MUWutINJSEGmq2RitdTHQaPuXG6cG5bypV1OqQvUJrG5DrhKu7VdlLqjMU7u+TQ5lF2ouViGQ1h6WCW6lyznrhtt3asjWWbzUscm7G7UityGy0xSUlvv75rQi6Jk+M3VqDZft67EFn8wHnbtBQnjrX2t2+eu6I9IcDsimTRrOzVcuaq4Vv9c+dwEftIVYEnXe9PqKSg6PeE+udBdFK2kVX5b1NBEx5rsfq6DyXUXtNPIPC+Ca41qwHcTNHgPusBtOACojExb2anG4XRx6Da4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(66946007)(36756003)(83380400001)(8676002)(44832011)(2906002)(4326008)(6916009)(5660300002)(6486002)(6512007)(8936002)(107886003)(66476007)(508600001)(6666004)(66556008)(86362001)(54906003)(1076003)(2616005)(186003)(26005)(52116002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eL4pbjn3B/WPp42vLBb0PB1ExsnKD9Vq/iTxbkEq9NzrLkpLgQY5oT+U2+rV?=
 =?us-ascii?Q?TUTNK+dXdQ/JIJsPxF1miB9h5l1opqV9iQZucCFR6DfnH8T02w5x1ZDHvSff?=
 =?us-ascii?Q?cjdIIhJRMnOxq5aP4zL8wasLVHpfDjwHQjFCKEwAwxCzlIsttSjtkJKlPSXa?=
 =?us-ascii?Q?d06dGW6vNWEWH1M605soc1L5XQEriVwFxCdIqueCPuluKcwhw4M44bartHc/?=
 =?us-ascii?Q?AA9GrV1Xnf167K/+41A9yKqnrNltjR3UVY9Q51XpiKyHLfqpu5BWf+GLeVIb?=
 =?us-ascii?Q?Qj0Dk60zdOU/6pbA45KsWTOdQHi3VfAUfeVARNdl7IEmT5UQ7XuexREDaUnj?=
 =?us-ascii?Q?16VZfIqbae6WmI0a77jrgaJxyH+B0jBsYmovTD87BKxmxteWBF81acnvQGIs?=
 =?us-ascii?Q?U/TCHRqIs0cUAbO2Z0/rlpeaEvucvSuP7JqGKlm1YnbiF9NgZSHm0PFka4Fb?=
 =?us-ascii?Q?RmJYRic3JFs3Fs8d4digkgO4jzwMG4Gu0ZA8kgI/nla/a29ZJEELdhAcQouj?=
 =?us-ascii?Q?X4v26DPlHQpgU7xCbLuefeYESZ0utninZESMZjIJ+0UNa12nzahCu1gwklFW?=
 =?us-ascii?Q?3Qtu3COOMRSLSW6lcsKyalISdbYmJp1XzrwFogmXIj9DusMGPwC5vg6b+ilO?=
 =?us-ascii?Q?yReF4DrII4vSZVn9p9+q0I6unNdCyR3IeV/19XMmim3UWadfl8Y3DSZbWxFl?=
 =?us-ascii?Q?OCsX5BgdljWpUrAQJqcxK35dBgHLP+PQadDgSzH7qHhj4La8jQn39uL9MRag?=
 =?us-ascii?Q?CEz0/ctcc2rCIolDLGL7JsZpJTIyZWknPeOK01tXydAgJVJzXTU16etjNvpK?=
 =?us-ascii?Q?bLYSJDYOUCcsyBdba8KBc0ElriKpKPnQ83RJsu42kCXFcPN33zU5ZZ6J3ct8?=
 =?us-ascii?Q?RjUNNlcFi7uMcA9OMjsKJTcUiOpEOpQ6dXEDaJ/rD7YwrdkYOidv05fv/eIe?=
 =?us-ascii?Q?tUGKGMjPiCo6jIWQAU1P7VUtJuD9p3te37+bAxAlcRL+artuhDucABN1A4ix?=
 =?us-ascii?Q?okLIUxV/guuWD/uFmLmXxoJ19w2MvfCUhq+mKOv2hU2dFlRv6+oqzOrsst0v?=
 =?us-ascii?Q?JpMoXhWoxqNg+exY+Y43OWe9NVj+EcC8e7scE9klQRPkQwBhmQ12D406SINA?=
 =?us-ascii?Q?b32myC9EmeYqTbRGn/RDuHRIklr4j4h7LzexG30SXEH/hbED8kCMky0LhGdX?=
 =?us-ascii?Q?99vAOAxp+/GuEoqNL1AIdpdGe5FB9cCJjK1fjpWsLwdRzkzIF1TqwanCFeUk?=
 =?us-ascii?Q?Z9cOPgn4wluCPA9s0q42RriWg301C+G6Eqo650woWtb1pKe13sdtwWJYAPkJ?=
 =?us-ascii?Q?X/WLmjdCUSOPyHVZsw+5QjxledwHFez+EBSoxd/PP1WycIPX6Q0ONH03eLlL?=
 =?us-ascii?Q?hAZ3EZP33ctg+f5YoTTTRfNORBeTROGUtg9kbaCEmMhsjK1XSEuLAvGiBThx?=
 =?us-ascii?Q?Rajoip4BcUV9BYs+aq2b2avV50xofmp4Bxtb9fw6Xnm1Odu6I9fQpXZsllVv?=
 =?us-ascii?Q?vEO0CE3skXu5mSYkHnpgU3U9Ha0iBE18iXe5d5hRB7dYi7bCPrfdnw/bj34j?=
 =?us-ascii?Q?l1L3Fm36y4CP8JasdDOpZJvIgArcmcd/8Cne7GYdsynbYeoXVCSsHfmM1+6Z?=
 =?us-ascii?Q?LAlrW6WtFc5Kkmd41fGcurxpvbpMg8jeuVIZIHcrpQexgqFq4oOPUrBYnmqb?=
 =?us-ascii?Q?7/N4QWigHmEkYqEY9Td8ctItcHJf1pYheOgkMSWGlxPnmzK6Tynvcs+H4CHB?=
 =?us-ascii?Q?1TogqmzbCfEYd0LHQrjT8wgAwuUaHdo=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f25ce1f-0114-4861-fd92-08da23812b3c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:24:51.0923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8mbLXMQ0rzCfBeNhVaVaJpCngs8XzApBH8KGryPF182JtdWpe0DLmKFkLp9TpOMmlMQDSwOf3zHDYxdCkVI143f5xDoATkSc4AYSgGOjdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2640
X-Proofpoint-GUID: 2zm3jhk8aQmYEaTP-qx4QPvgLdt6VE6v
X-Proofpoint-ORIG-GUID: 2zm3jhk8aQmYEaTP-qx4QPvgLdt6VE6v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=947 suspectscore=0
 malwarescore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210057
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
[OP: backport to 4.19: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index d5cfbeee4777..4c41c91227b2 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -101,8 +101,10 @@ static void ax25_kill_by_device(struct net_device *dev)
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
@@ -981,14 +983,20 @@ static int ax25_release(struct socket *sock)
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

