Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B9C502E6D
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 19:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343748AbiDORwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 13:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344030AbiDORw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 13:52:26 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD46159A7D
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:49:57 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FHjqLL031109
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:49:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=GSg9W/Dtc2IbowLx+AulMJ+8gEu6iQjY4YGv0pGM0Aw=;
 b=VgBCMOZUT/NJ12nihVhx3RJRnrHbZ/Dbx9fjtx7qHvYe/ZuXJDtJl0axEP5pjiPY0MVG
 wmpbO1H5o2ihAzhmt0n6258LUx/H3Ac2HgvKXuTVAkN4obPcZS1G9tg4wNfiGXxgpPi0
 KzOWOqinJ0ygp0afg8D05VunmDmZJZl4wMGDTuVvznv6wNzDlO4eV7FRvayEvIGu4gOs
 pZMQytHgyJQ3qyZydAkl2tJrzRduyTuoE1UC+OLuppRhjiTXTUqrzl6JHS90GuZFLFqu
 Ssef9YoXH9ehNIE01T+btSTDyZDHouGr6d97Pqx268Dlg/Rq5MQyTOfMrBlEsxwbCpLz 3g== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfvu71-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:49:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOtGszhdFSKXrUyGnF1Zao6eAUnsddY/qOXv2ARaEfOcDo/uGqy4J1Kh3AFhlvdGGoJdfQmdVComoUrT4Vn2R4sIMtlOHjjTM37zwYO8b1J/9B4aANUAHgeTT8ctMa7s3z6NDUxmVtbRG2tDjr1dMLqG50SCB72l86o/KGtpDNSFzBf2gPe+RrSNWGVdiB9+Ah7C2QhZjrS3u9yAGC45lvHF0CpHfpSAMmeAJUyCy0dcjgFewp7ybVIgdHoovzHOy6wLHNHMdgYXCV4vwqegw01uzN98Brus/sbqBMTLEtlPee5pBT2aE1VKGfUNUNbORTHR1YmgUohZct/Fq+513w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GSg9W/Dtc2IbowLx+AulMJ+8gEu6iQjY4YGv0pGM0Aw=;
 b=CTO8nGog8Gfm0YPc7EVKf91tAxvTuz/+r2S/uMPTv2L9ICWni1mseeaMdGM+5qb4BT0ibVzX48RV8ZLHgQBSw/9o8c9k29lSNB817K41n1c9n1UvOgKDLgjeyOZqfBT4RSc3Q1daP9q8ekLhhIaTgPlzyruLTNSMfw90GhB+chYL4gEGtLI3bHfBudzFFIEgipEs2bgqPd+BlaAo0BldqLdVyDsorZJ21F98V8s8uk4z1retdfm7PuYH3jdHn3J01VOHKfZswvqZblq2c34znTJObGMn9B3c5KjAAR/EbOiffQLxL8nwxc2znJTopril5sLaV4GSwVYWzN05VA4Jdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2697.namprd11.prod.outlook.com (2603:10b6:5:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 17:49:55 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 17:49:55 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 6/8] ax25: fix NPD bug in ax25_disconnect
Date:   Fri, 15 Apr 2022 20:49:31 +0300
Message-Id: <20220415174933.1076972-6-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: e24aea74-fcf8-4661-d5b2-08da1f0859ae
X-MS-TrafficTypeDiagnostic: DM6PR11MB2697:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB2697A17BB4F13EDBDDD07CBAFEEE9@DM6PR11MB2697.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xx9hOmGSXHWlYn3XyywStjKYYguOxiaKLfAgRLyLLX5bfetdaTwBBjNa3fWoZo/Ow6KtaOqhx6Z6sYHBPd1cIasKOJ1aKcc6/xZjVyK+WdkMYwb88h9/Olc6Mi0TETiTxLiw25GQBKhHDwEC0H8DCF2Q7oDybfMs0og2HLMJ97UcouAt8pbrLM3XywBmPhhbwNqJy9uZuBpYVu6gvLdAooiXMqWABzdkKmz9TSjt/3QVUdt0cRqp8Mb+vXnhKRtdUY3zpKzMLIrJhlpyudxxkS84NK/ZVlX/XzWMFIWm2lHuwiEXVD5CDWx+HZ4G00ZS3fiusZoICTWf/Z2AnxFtfSSqobU63/qr5fzAszcgrUyoVpITvozuiTW7y4LH9kthPUAwGJh7IsGbN7/dZwzEPEPYWhA9TntcPjyFQXFfsmwIxOK3iRJUiRNtRWZv14KOnzCqZkEFPsj4pTmjq3/CJ8thbm47hmW++wsQtUsh3Xk6u8uG7qRvp+awAHKPnrSXuzi510nQOM02bmUxvKnrA/QU1PFZ9Bdr5TE7gDBIdypOkfzY7qKS/eCbFUhAWn/qYM/FXuvV21Q0LM0YjrWM9X4jY6K9+3Ghr9e2HhO+t0NoTM/d7/6BG/H0r1FN21zckBuLqnKtimJbbDBtPgapTA7BbTNKqKfCING02y4SNV6B6U48UPMXf4Z4WhW/Mdk7poYjRMdWcuvma7rwPkIX9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6512007)(52116002)(6506007)(36756003)(6916009)(316002)(6486002)(86362001)(66946007)(508600001)(8676002)(66476007)(26005)(2906002)(5660300002)(66556008)(38350700002)(38100700002)(8936002)(44832011)(1076003)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BxJ0yWI6rzdl63OBl+ZomI8jyZdNYPEV2KUe9lj9MODqF2INMYMCq35TgoK6?=
 =?us-ascii?Q?u18iwrSS4va8lp0q+yEl6g+oAUn3mtjHMJQUGsd9ia7V+5kNm+hmaBrjxOR0?=
 =?us-ascii?Q?3FfPMzfVV82wfAwBq+vf+xMO6xu7/+pFr35ZW/SkGWax0M7rUixYG6jZ3BEQ?=
 =?us-ascii?Q?qURyvZlWs8201q4OpT/vx+u7sXMQQ1Ov8JiLQoRYL3OYsaWGdS5TrbxnSRH3?=
 =?us-ascii?Q?EyLZ0hLPO1nm4JU4JoiXOm1HfhcLKXkgX7d2Y4fHfBEamFewRqPI/tJFmoS4?=
 =?us-ascii?Q?Ga5Z7L4bWpLYthhtQhToOjrzDGLS7+f+wlJh2q0cKknTirnxi4A+y9pKh603?=
 =?us-ascii?Q?NQhH3uWG9D0EK/hfoFS7y2SAYZSUsf8FCfK357jLYhyuNH38wlhealRVomuo?=
 =?us-ascii?Q?uAVeqBe8e6SoBovxAzd4LIDtI60jidOnNM2etx5HpD71p17mdEBGWs8oO1hP?=
 =?us-ascii?Q?LoyHKQfp8vH9vLQDynIhg9JUd4woVrHsQaEhm2FEVbH+/+6JwFTUG3OJNLd4?=
 =?us-ascii?Q?BE0WlClUSZFyTFbIbpihWf92GkhJI0HBuOtOkFimdtwYnpk2DBoGO+/EzJOX?=
 =?us-ascii?Q?F+y76jo9T5JkyXiBBDB5HI8s5kc/PNmolZgCIDehrFHg96ZTC7aKX4yZdw3/?=
 =?us-ascii?Q?vtCnFc8i6zlpwZ6eqBK7svxdLlZk/621RyZl/rSh5ZXfbt0fKsnEmFWzoS2T?=
 =?us-ascii?Q?kl8lz/HYtwvKxaOL/VZIiAn8ulUKcYBWB1G/EmnB3dmNAYW7Br/03ZTRsbYY?=
 =?us-ascii?Q?UTswlAt+RLHJ2NQBJTQKiwIFR4F7bVwT18PvXQJNm0GTwl8aSmCQc7yBQoJD?=
 =?us-ascii?Q?EDDUWWIBu2CodT/iKa3qijvZSuq9FZd8YCFUFP/2tbDgiE03cTRJ6TmONOlL?=
 =?us-ascii?Q?vK+bwYbxS6/QXxxugie3Ox08PYBBy2a41q87YJN272afDaW+2CfADZ1mxHBn?=
 =?us-ascii?Q?PrnkmrRpgsH9Q0zvHyzZJI41pYu9QBjJJEXJlXvI4Rda6Sdk/Uxi44uGm6o6?=
 =?us-ascii?Q?xuFzGikHJMDklmyTDeRoOdXjPoEopbCXNEZdldvUtrREqyze2YgGhhl5LodD?=
 =?us-ascii?Q?RL0J/e6Vph0kkk7THp44XvJB1iD9Nyd/Gk+1+13L3TXe/UPOskKH+fhyWKIF?=
 =?us-ascii?Q?35F+mBj5740dclcv++j+qhxIN4Ziy/TEFGUN7sQfkQ/5kmJDZ8o8pPNG8meN?=
 =?us-ascii?Q?3GrgozUVp+kbRmJbWE3P1F3F9Uomr+ffAM/g7V13Qlei4u8NOInZ5LW/ozLo?=
 =?us-ascii?Q?4ybhPfix6s7oh4yGmJhDzklNeQCB4/E4CDK86gXYEnapn+kHToHUCva9/Cs3?=
 =?us-ascii?Q?IXSnHmd8xKcfOm6JlTVthytXdlmbOGCCNfFxaf3ZdYsLx8jSM48ToYY02+IS?=
 =?us-ascii?Q?Dgq8mLuEqRUoaOU92/B9KEMqH+6cpXhgxV9SAgL/onLKVbSXnDLhjVOrEZ43?=
 =?us-ascii?Q?wqVbppsXAfTLAkvll9zzSKWEETbA14GdSSUT6YLk8iiiOWIqem0DQdVhfwVf?=
 =?us-ascii?Q?iCBaC7rqo9h59jtq94hu86UPB0P7EcTsfLWS0eHSj2xl6m+P1vQ8/VMEMJ/8?=
 =?us-ascii?Q?eNjg6gf2n93WrkUwurJpA5nM/BkCYZapxBplJgRkQ2vzkir4Rv961fTGDm/a?=
 =?us-ascii?Q?SPqRRn2oIhGW5swe/Wj1M3H6N79/fGKsY287dm04oDvQe9PFbKtPrvPXmYj0?=
 =?us-ascii?Q?FUr4vhqQV/iZEyw/9ilEoJVtv6aXk6QV+URO3tBli/Q9w+ceKvbDXq/EyBlq?=
 =?us-ascii?Q?OI8v2SOkAE1jWzWsAKCgQJKKnmQzxEs=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e24aea74-fcf8-4661-d5b2-08da1f0859ae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 17:49:55.4625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+LZdrnVLQYzXK0e3brH2S0guHXAHIHI8mq5FwoBf00HEaMPmYW1gP6VXjABHWdT+PJaWGbFvAFzZx5RG7tpE4OrnO4ba/8mG9fkDe6aK+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2697
X-Proofpoint-ORIG-GUID: MYu3Bt2QxnHxNeeNQ1km7CuQmKHPqHqc
X-Proofpoint-GUID: MYu3Bt2QxnHxNeeNQ1km7CuQmKHPqHqc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=883 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150100
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

commit 7ec02f5ac8a5be5a3f20611731243dc5e1d9ba10 upstream.

The ax25_disconnect() in ax25_kill_by_device() is not
protected by any locks, thus there is a race condition
between ax25_disconnect() and ax25_destroy_socket().
when ax25->sk is assigned as NULL by ax25_destroy_socket(),
a NULL pointer dereference bug will occur if site (1) or (2)
dereferences ax25->sk.

ax25_kill_by_device()                | ax25_release()
  ax25_disconnect()                  |   ax25_destroy_socket()
    ...                              |
    if(ax25->sk != NULL)             |     ...
      ...                            |     ax25->sk = NULL;
      bh_lock_sock(ax25->sk); //(1)  |     ...
      ...                            |
      bh_unlock_sock(ax25->sk); //(2)|

This patch moves ax25_disconnect() into lock_sock(), which can
synchronize with ax25_destroy_socket() in ax25_release().

Fail log:
===============================================================
BUG: kernel NULL pointer dereference, address: 0000000000000088
...
RIP: 0010:_raw_spin_lock+0x7e/0xd0
...
Call Trace:
ax25_disconnect+0xf6/0x220
ax25_device_event+0x187/0x250
raw_notifier_call_chain+0x5e/0x70
dev_close_many+0x17d/0x230
rollback_registered_many+0x1f1/0x950
unregister_netdevice_queue+0x133/0x200
unregister_netdev+0x13/0x20
...

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.10: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index f6594dcd36a2..b1e36d48b07c 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -102,8 +102,8 @@ static void ax25_kill_by_device(struct net_device *dev)
 				dev_put(ax25_dev->dev);
 				ax25_dev_put(ax25_dev);
 			}
-			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
+			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
 			/* The entry could have been deleted from the
-- 
2.25.1

