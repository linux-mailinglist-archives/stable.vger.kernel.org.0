Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CCA509D9F
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388630AbiDUK2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388508AbiDUK1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:27:43 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A031D2A2
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:24:52 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L9s7K4014742;
        Thu, 21 Apr 2022 10:24:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=7TFmkyBCMnay/VfFqyyfgP1hiLmBDFebAUOgbIWPhlI=;
 b=EO04DWM2WpEEj8H2YjWgwKYXChKmw9Ou3ILBaGYdooU+aUL8kh+ICDSzHQd74dJk3rr4
 E2jVjNS8iPU0qqMtt/svL1sZFi+zIspnFvMURRBingf2r6WeEfsjutp9GxYhGI4sVxGX
 etIgS0SPY3blg3GD7nwxzpRl+pU8Y2n976BRbJTlYRGZ4tFJq1PjFAy20ej3f36FUYSe
 FMTY6TRYMpdEwIco47501oizaKqrJFx3g0K40MI7udv5sK0qfBjrvMtVMMjjgFMUNo/F
 eFESDeL/OizJvXXQfJQPfhcO3ZvGlm0edvxlycvuXYuoxaYpTcMUwzjekrrE38oInP8I Tg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpqn3qr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:24:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4cbNVf132MZ+x1uiJW2lRqOeRGIzLkjqdxRsJmEam5dKUA7j6cKnp+XSUlZTVjgwPOAfvaUDnzJRPGtHneG8d5JiMNTEtApfpnFcbfuDsWQps3pOPlJoLWg0E+vHE91F1cd/mRPuj17X8cKa3bmhd85j5xCVeLoXwlzBpdjtdybRfsfQmCUe7OyRgis3hbuqJ9NlgIUn0LnZ5bjBNOnt7sZ4NOfPU6nhoEs7U1PL3POJI21Y6tl4Y7gUKS9ogOVKHIXAUpa0zwJuPRa5wMxZU75TMXisCGQTjrOwXwGsz4VSW/tRzuyJF6qsMqAZvLfYiIhMJvra7///wZTDGRoSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TFmkyBCMnay/VfFqyyfgP1hiLmBDFebAUOgbIWPhlI=;
 b=kPdZqiO0vhswMwfn/fYu+AArYtq/xFCeRgijyRFMIh/2yH6NJL9tCVFqt87k/XS6neOko6qvKtfll18FYuSp+6tc0rs/3JEtvLGkFRxnNzX74IRtOkXsoYlOSgg3tkMcT/wk8Plqpa3iSfajOYWEJRJLBbicd2YThq5gC3iyMIxAugW99Zx4rjMmtdkLS7jPGNP/Eb7DYBLZHESCeFaX4QUaqBdJA0NO0NwUhFMouQ+QDlP8pv4V9wW+ikauGGSLa8OYrd71D0SW43aIaG5ZDNUyZO4uwkRVxGN/hBgvALe0HTdepgMAkc0ObP7VNwzJM4NnmkchsvZBRMKqyk/SFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 10:24:47 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:24:46 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/8] ax25: add refcount in ax25_dev to avoid UAF bugs
Date:   Thu, 21 Apr 2022 13:24:15 +0300
Message-Id: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0092.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b038a923-6aaa-43f9-dfa8-08da238128b5
X-MS-TrafficTypeDiagnostic: SN6PR11MB2640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB2640A5C48CB47D52E4D7D8D4FEF49@SN6PR11MB2640.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +qrx7+qevgvTNslYY/DlVuvdThSbaWiNtfEpzNGh7bu91i6noj8BbarbaDgcxy5eVO+WXcvRIFM3SKcgCuJz2s/UtVKt+GKqmqj04yge1AeEPq9GQjjJJxEJhG4bymaM8R9G6uYtujxCWTClAAQAmFdc3a9K3K9ehDWbn46NIlQNi6SnyM88a8UDoAoHc9X63wQLYDz/hzjFBeMkVamEMF/YY2v6ZVrN4MxnghOYOhL2cTzfw7BvxA11BaKnRqSnd15QLbkykaN77tEcLwFkLnI+fT8morvZK6TDHPAOxGFc1TKP0Bm1palIGzUuVaZnu4LwRHMs6PPsTbRG9g90giPaWZWjaDfxRn3QjsORmVuvVdDtdv8kgjvaqJ/eIMJvrlHxndYDSC8j/TJDxKdh7JwTOkKvtysvAxP+1P1TsyC7dBD9zw5McObZiue5gvHc3T9tK3MqJ+aV7mHiNBAX/v9nBmLU0KF0+uanCTo33jYWSWLO4nx1xxRAiEFz/zwAabwEiwYDE3C91Cg2ec9U5yH0fObw/QcyLCfhQD2tGT7bkuD83Q/d+HHvBrZl3SdOWMpDfG7hp3fI5G0yLUOUeE+6lpLjR88WcS4S2cAYFmCUqSYgf86aO4189k9/CRNZCt5fvSKvfkTLNzLR0hP6CTmvB4x1diEQMGAvW1RK6v7d9hWcq0I3zwaH7RkxVNR8uxHDo/4K+ACwesRKY0zaXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(66946007)(36756003)(83380400001)(8676002)(44832011)(2906002)(4326008)(6916009)(5660300002)(6486002)(6512007)(8936002)(107886003)(66476007)(508600001)(6666004)(66556008)(86362001)(54906003)(1076003)(2616005)(186003)(26005)(52116002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/eN+YdvL5rtHHioR+pRNwAYgJRe5H7nfT8Lw25gC6DXulaDlIrr+n4op1qCy?=
 =?us-ascii?Q?6Bw/B4sGwn4Zx7Z0fS6/AjQuKhHRjoRquv0aRRnunN/txD5R7v900P/Xrkdp?=
 =?us-ascii?Q?U/AetQDr8dKOLIXZLHp4Hbpw60GOxn/FFkDNs+HxLRF6m+n8WjQaOxO5zUZS?=
 =?us-ascii?Q?Y6AcA9uudGPb/3Q7Tv2YtzwFenaK0V7MyWyq4+DS+fNN5wwVI8Z6PplKKMG8?=
 =?us-ascii?Q?nS4yZ5nWSD2trPMklnKm0/v5Iqr0ZatmPqk6KhThIrl9FM7/EpcivSkuLpqC?=
 =?us-ascii?Q?w6E61adY16+gXq/0+OQ9kzSIquCMeTJO8ExLZ5eiZDDwlFAfXla2nVkO2vMv?=
 =?us-ascii?Q?AiwPTgJgfN79SbPUl1J4stf8hbF4Mn1UuRFrNhAs0odiWZfagSdtIAQh1GXZ?=
 =?us-ascii?Q?hiIJqFBIptvyPbjvo4wBOn2LwPLGcyQSq5d8QOT0XDH4a0uXB1ihE+pKMTcq?=
 =?us-ascii?Q?OSwr+IKTuJ8Wz7fzT6qEyDdzUp4Pv2FF8osF6V3wP/8qz5O/ERK8SPSxc5ws?=
 =?us-ascii?Q?QFg1WOV8QgAB299p+ds6G1ibEf3G0q9ilG69NFKdj1t5cf1y0qoBQhxWQjOH?=
 =?us-ascii?Q?dzIubNGIPW+HFRcBMTqxcGtmTeJLq7jsxsaajcjiV18RG3LHLrP/MT2BP/h7?=
 =?us-ascii?Q?0oPDWvqYMiR1cXwJBORuhe0r5aX2pLlVxCT89ctGoVxYxjFArVahdL7ZM5AR?=
 =?us-ascii?Q?GYDmdCsxPRDWmuocedO/lk2YIieBkoNsYM5blteFKLMRs1uyhzxGonAiy5K5?=
 =?us-ascii?Q?J13VCE1aFdUiDWMFjG/tVTgVs+uqrc4+WxVYFSFltcTisQM59fLiJJ+qaRGD?=
 =?us-ascii?Q?nNMinUL3oM1sCzZkGE6WiJWPmwC+32N2Jhh2n+rgZv/wQkdmU/hnZnPCFg3z?=
 =?us-ascii?Q?/0R3ZG8dK3qVppm2ZitHBcHvz6+uX+5VYN7JG31uQI8vGSsqt5ZYgAZuXQb2?=
 =?us-ascii?Q?zVbi/CCd/32gdlYvEdI28gB8LAm/rtqr4Jrq/r5VoGJvZ4/qXnNUSqh9SN9d?=
 =?us-ascii?Q?YjWc/FFMi+3JLsII/gO324cRxza5/b8Rvww1O4DI3Rhc7a+LTW8efsqw/g9Z?=
 =?us-ascii?Q?7MgR+WMsfnyhPgpMH1k2CPSf1s7wXEeCwckInMNx5epCG7lMTPGGKZ7n0wv5?=
 =?us-ascii?Q?z6XyDNaKlPwhBqsRY5m0+Su0ZDR28JWVhIErOGligYxTu2NYPMzv8/II++kE?=
 =?us-ascii?Q?y/b4A+YNQrqLfXtv58Qp7jW6RMdehRmYHMEpHntO6sVthX41Ki2NvkFCOd/K?=
 =?us-ascii?Q?dVofGiKAcsb0rsadOQIXeo4zmm+fhnSjX/AVc46k90VrQa/rzjmFIOVcSHJv?=
 =?us-ascii?Q?/EHRzhx4PUlAUbyXxO5Gi5Gu+JgcxOqdBqkjdapj8G7rz0cjFfTeLXLf6adI?=
 =?us-ascii?Q?9rxFdnHtPzDGDF+EMwKmhe7E/6SJzsgCMz41kY0kqwnymkalr0bUrPj1RWsu?=
 =?us-ascii?Q?Iyqqmqp1fBvnPGTMQqVqnId2y7ReZm9HE2zCoiWe54xTnW3SzJZt8TrRHptw?=
 =?us-ascii?Q?p2ABAXMJo4oYMhxOIcBy7BuU0JLCX/ZzZwAjWUsO9pdJEDOPLBPmewUXMn7a?=
 =?us-ascii?Q?XtzSL9lGp6u+vdxOKnFbyydT6VAXjnNKW1sUhXtu1LnBO0qQSJy8mC0hJ/om?=
 =?us-ascii?Q?lCv5iydf2I791woiNcsoiTW2yxyokbkuO2Jz8kpHosLCi3tx7E3uInpoXoHn?=
 =?us-ascii?Q?w0dg7O6VMG2Pr9bBNMmnlYJ41VwpznPzm/Np2wiYI7FVn1vqJ4W+xROe4rZ3?=
 =?us-ascii?Q?vP1Tdc2vc+01vq4ayQ9D8vYSHSN2Sig=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b038a923-6aaa-43f9-dfa8-08da238128b5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:24:46.8201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dYWv3tUeGoyWSD03deO2kivFATWwaeX3ZnaTDG7+K+YvIo0z5rJHTnWo2gXRTs3dCBvFi9gHDwqdX8IEEhfDLSwBjr5aPJZTcoLS61XDPKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2640
X-Proofpoint-GUID: ibvJXNVFFTIZDD3vmrORKS05laUZCjh4
X-Proofpoint-ORIG-GUID: ibvJXNVFFTIZDD3vmrORKS05laUZCjh4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1011 suspectscore=0 mlxlogscore=785 adultscore=0
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
[OP: backport to 4.19: adjusted context]
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
index 3170b43b9f89..56776e2997a5 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -101,6 +101,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
@@ -449,6 +450,7 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	  }
 
 out_put:
+	ax25_dev_put(ax25_dev);
 	ax25_cb_put(ax25);
 	return ret;
 
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index d92195cd7834..76d105390706 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -40,6 +40,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
 	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
 		if (ax25cmp(addr, (ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
+			ax25_dev_hold(ax25_dev);
 		}
 	spin_unlock_bh(&ax25_dev_lock);
 
@@ -59,6 +60,7 @@ void ax25_dev_device_up(struct net_device *dev)
 		return;
 	}
 
+	refcount_set(&ax25_dev->refcount, 1);
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
 	dev_hold(dev);
@@ -86,6 +88,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
+	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
 
 	ax25_register_dev_sysctl(ax25_dev);
@@ -115,20 +118,22 @@ void ax25_dev_device_down(struct net_device *dev)
 
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
 
@@ -136,6 +141,7 @@ void ax25_dev_device_down(struct net_device *dev)
 	}
 	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
+	ax25_dev_put(ax25_dev);
 }
 
 int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
@@ -152,6 +158,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 		if (ax25_dev->forward != NULL)
 			return -EINVAL;
 		ax25_dev->forward = fwd_dev->dev;
+		ax25_dev_put(fwd_dev);
 		break;
 
 	case SIOCAX25DELFWD:
@@ -164,6 +171,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 		return -EINVAL;
 	}
 
+	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 66d54fc11831..cd380767245c 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -119,6 +119,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
+	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
@@ -175,6 +176,7 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 			}
 		}
 	}
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 
 	return 0;
@@ -217,6 +219,7 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	}
 
 out:
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 	return err;
 }
-- 
2.25.1

