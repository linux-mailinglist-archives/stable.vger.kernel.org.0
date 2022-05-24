Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AA35330BB
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240497AbiEXS4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240436AbiEXS4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:56:24 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCB4186D7
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:56:23 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHVRrc014304;
        Tue, 24 May 2022 18:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=CkSg1z9amO/uy/iOIE/0+C3MKRcDMrg2MJBdAElQQ1E=;
 b=dk86Aqk2fX1NXD9ud22hhOwoxo0DeSgrtgFE/aHLjeeONvqBndc6VMtGOpy/SQGLeVYv
 tHmnDQal308rt2UovPHiXTsIHGoNRIYEsxXekzJ1j8QDezNWtzyFui34wbHQjaRSp1Yx
 lIKLe63ModQL6cVKeGmnNe28IStw1+u/DGmHjcISI6rskwBGOk+Yt1/y2CDtCgAJPGQW
 Zyml5zi1AC65DP5ctEN3JjwFXFWqVwIcPum32Ql5aXB+DOiFUfbXaV3U/8LQJOtOB32r
 tl+ZmvjdhnTAjs1Km4CkZjRB0EPnwmGe9E+kFy5WpMNbSTw4RJcDEGJuci3qM+n9QenN sg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g93uar1yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:55:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IP3eP6SR9ehAkaEymLWdezk5gsW7cNczrYjzljJGqWWPHv1kHmdnXH5n+XX5wVJM4OVpZjlpKRu1sHoz9iBkvp5OU4Gl4av0Erhf1MWIc1u0Nn5TBfu8RdiMBx8Z0cdl95BcyYER5l7om1ZINT849xJX3E2gz6e8v5hknA+OTh4D8upMSNILfJlD+GCO7nwuUlgrXDQDLN6SILgtmdETCAKEBTBBY/fywjXwEZss1vELetq9v3naACeYKsRmp2AdRrclTSH/RROMuXwZwHpm6yzK5XIF0AMC9HaWxf4hj2U3XkbCRVaKIvlyD2azFlOnSa3Fsqdshbsil3rReDAcbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkSg1z9amO/uy/iOIE/0+C3MKRcDMrg2MJBdAElQQ1E=;
 b=ZtYFxad/t4abQoQ0kZ506e2uNqGEXpbIDvdjqaKwMD19fPCz9cxvL+lVrCndX/+GWqy5J6iVUMGTbxWI9MsSrTVTQgOzdkpDJkOki8UyoYLLFQQAsBLZkqpam9Gm0CfGMydI6WgrtD8RqV+ZalWVMRGS/b7oqEjyo5TIbW9FDxF69MgA/W0FZ/BMhdFcjTcheoDx8aGHBVj2SAQ4w3C1EK6BNlKaRzDazyIO5494n6B+qpUiLyHdRge9juVZhi6QZu+ystwPwlZMDIoX+NHrpJ0Xe7bL4c5HirDj7AB/aPSZbXh/A2r4OD915iymxFap7+7yjwMX5VlsNG23eLZiGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BN6PR11MB1252.namprd11.prod.outlook.com (2603:10b6:404:47::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Tue, 24 May
 2022 18:55:54 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:55:54 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     edumazet@google.com, willemb@google.com, davem@davemloft.net,
        Jason@zx2c4.com, moshe.kol@mail.huji.ac.il,
        yossi.gilad@mail.huji.ac.il, aksecurity@gmail.com, w@1wt.eu,
        kuba@kernel.org
Subject: [PATCH 4.14 1/2] tcp: change source port randomizarion at connect() time
Date:   Tue, 24 May 2022 21:55:38 +0300
Message-Id: <20220524185539.23950-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0030.eurprd08.prod.outlook.com
 (2603:10a6:803:104::43) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09349da4-6e36-48f2-7c4f-08da3db707bf
X-MS-TrafficTypeDiagnostic: BN6PR11MB1252:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB12529B4A0C2BBF92B11D1E20F2D79@BN6PR11MB1252.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXPuDkhLw6MlmZD2NVSpFjwbPwtnRMSYnfN2gJErhIT2p+K7fqPuOey7+8GAZWPXDne8QhGsan/P2bex8fvNe/lXkTTJ0JgZ8TF5zja4+HlGTpSYebULCKTV/WFBWPgI3i7g4/gn5VUvKNM9pskObt1MXgYVL/dTHchMD4vek/xtoi93pZrbDsWFDi5G8i8/La0Rnb03TRoMwvkxDB1bP5dBnk2ZW9Xwgujkg/zsHerPuDSgJkvoHgTAiUDX8mZPQ1GS+3qJP3Un997gbweWrnnmH7dxkCO66UhYwCdqaYNCrgBjDxI4vmYPJZzOrXvxZO/xg6Mm5mdVFGt8jcZk6RsYyPpMh90ZJsppMfaakIb9PIFn8WleDC0A7GzlGYW2yhSi/lvgeEPzf+Uoxm6nVAST6mchPfOYVWJUGtAp05X935oq5LiXiG/OM6fXuUVfdDeUPZzgljQLYBsu07gTCzpQ/JqQv+RLr+WAR6tIIYq/cMCNgY1GI/EJ/0OxaVssst6ypjsl/RVc4ZYAphXqeaFvJVFx/ESkZKdVVfr9rdeiEz5CKmg4eKsU3kGd54lLGQK/+mx4xHzoY/BbJmb1DlE4FW1Dy2EQG9c2rewda/yC7kEtcTv3WNzNisO5OwkCVGnQyCuKUbQNO9xAa05FYEphk6DppkeRxCGdsc7FB6ivRq8Ffo1kXY463b1q1gX+SZWZPnbmuKCZwoLoyvxz6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(66574015)(2616005)(1076003)(2906002)(38350700002)(316002)(186003)(38100700002)(83380400001)(52116002)(36756003)(44832011)(4326008)(26005)(5660300002)(7416002)(8676002)(8936002)(66476007)(66946007)(66556008)(508600001)(6506007)(6666004)(6512007)(6486002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AjWxxeyFQNmNPhUKoQgiVjFzULjrVtajskDkaNm6JN2z9sPKIJNpNz/uGHEl?=
 =?us-ascii?Q?/xXUEbnqqa+dUobm/u6UtbyFsu9rzQp9v9UY9pUkmwOsu4mSh7lL+evY+S3k?=
 =?us-ascii?Q?hwZrG4nv55mToVvRL9Y4BIIMOwb8Qmn+0mDNSGXC0QZsgU/UhpX8JzhZWF4V?=
 =?us-ascii?Q?RMIalQarCGE2aQuSINnHopwm/CAlXb5LW+7YYpZF8SEixVkGkq33hCBDn7XA?=
 =?us-ascii?Q?kSRdSWy/vVUWGUdSpQnDonJ8uwaeQu7johIgNZLK1q+VHYqFAj+O0vvX5OFO?=
 =?us-ascii?Q?x1IWThPZEpV+QKisw2x78yVd5FNf1f5xalokFWEo7A5uRECdOlSRS0Q6lQNO?=
 =?us-ascii?Q?oPySphnQnXrNhLG5mVbje2eK83Qz0Ye2C37gIHdd19vzevmEcYuYjmLqKYe6?=
 =?us-ascii?Q?LWWXqTQ7bmEj8ra4mhYAezP8l2xzBg32dbbFZ8ZrjCnrCU6bNjaT2AX9tH6n?=
 =?us-ascii?Q?wStmHxmpVhfpZm9pwjlzHsDlOcJJE3vnXKSOho1LHzKOx5Kg13RE5Lhu5nO9?=
 =?us-ascii?Q?nzxv/aACSiH2gEWMw4H5oo6eDGKWlg5aTlhvPc14YlFuFOj5my77N35t0eS5?=
 =?us-ascii?Q?aqV2QDoIEgNh/ofduFH8na7TEMTx2AOFyqnYSlpi4REbxY8tin93W0DCNMjh?=
 =?us-ascii?Q?7EwNpDlqGvgbsjUHRY6ofCWkPGw1TICSA2l5VwuZ2obOqlspk9nqj3eBKKki?=
 =?us-ascii?Q?aTP3YdryICGkXuG/778qelsuHzVVqK+LWLm0hS8DC2Mo6lvubWtpMdFlZslS?=
 =?us-ascii?Q?RgZ7z97g6EnhGqwed6Ej/d31YNFva4NriFyImbbp5/4hP2XrcNSqqhG/nWFJ?=
 =?us-ascii?Q?7w8XnUvMo7cM/mimlL2QvoWt7xuyJFQYnIhdUt1dovMBKLVBrg3Ri19GoHWb?=
 =?us-ascii?Q?XpDY1maaS1Wo0Bicu6fP6Eda2NtUKAuAmWhv1rkdqhQSFis4t9sFA/HwXCjR?=
 =?us-ascii?Q?vAr36v1oIoX2iK/wCGhK9sqtMZwrfqT5YcjuvpFDcGjNp0/g7GTX/rvOqGo+?=
 =?us-ascii?Q?JQ7pG7L1bmbJSMvrdBFasNMWkHdu4hNcwhRhz0yoj8+lwOTnrLkQ0QoQJj3Z?=
 =?us-ascii?Q?CE71R6E9VN29kSBOejUam0AWlBRmRmDxHih2YgetaLQK5fh083EV+xfxWYCd?=
 =?us-ascii?Q?bljw52wntpWuo/JNOsSWAgT34VLU3x6zzUKgB5a88m0TAjQa0l1GcE5ppBGe?=
 =?us-ascii?Q?01xQJyT06wj+gX3dAg83YyXu++4XrIGlU2eE9REMsxj/PA+pIGpafNZ3yhRt?=
 =?us-ascii?Q?H7EdYTn5qSirQlfhm0NLVFXVY+dYkzM+ATMu91dtOs7s8uUiNvRzvsuc7OHT?=
 =?us-ascii?Q?YeRgz7zfTHY46hs1Bj94ST4oZ798aWQm4vKnyhbM+ZvLb6FukqWAtz0pnuBZ?=
 =?us-ascii?Q?03M9H1/Wj8iGrz6OTLt2zpFifBcCeB5DyeQ9LXK55gSA8WNBmFL+FNyliEJi?=
 =?us-ascii?Q?7yVU0JZL0Du7f8CbQmqWbUrYWMiKVd6ADKlPkoLrahwVODdLOTsd6ioe2igN?=
 =?us-ascii?Q?srmBTa4ZosTEQRexUVQ6cRxSlKas8ToE6qvRQ0UgPTdKZwdEWOsF7rhWzoeR?=
 =?us-ascii?Q?7AM08cXr6OD6XRoqtVZlaSoPBfqBPH86njwPWuGSGUn5VZzIx+AhaISCxKLX?=
 =?us-ascii?Q?DrALOSxPl9GPcIaPbXdt6LKUaai7MQ9ifcNmU3w9REP67GUgTk/kAJr41Yfx?=
 =?us-ascii?Q?w3z3dV6j2YwvL+Ecc1s8Tdni+wM+mmsGbdTKD735+E3bJtzeIsQXJX0RykEw?=
 =?us-ascii?Q?pjmDW0LAFgO7KdLq1yTgMRtXiS4iBIa3JWHyo+sLOue8qs2Kq/Fo?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09349da4-6e36-48f2-7c4f-08da3db707bf
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 18:55:54.6051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K0uaeTFJH1KOtwMwCOh27y0sUV32RD3nIQr0SIBZIwZaMf3vMVRN5T7xV2iLwCdFsNRlQkLpTvJj+eIF6zMfw3/R5JplFwVwGPgPesCoOZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1252
X-Proofpoint-GUID: FTfWYs2anacN9bqBRuXmxU57LY5AgozH
X-Proofpoint-ORIG-GUID: FTfWYs2anacN9bqBRuXmxU57LY5AgozH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240093
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 190cc82489f46f9d88e73c81a47e14f80a791e1a upstream

RFC 6056 (Recommendations for Transport-Protocol Port Randomization)
provides good summary of why source selection needs extra care.

David Dworken reminded us that linux implements Algorithm 3
as described in RFC 6056 3.3.3

Quoting David :
   In the context of the web, this creates an interesting info leak where
   websites can count how many TCP connections a user's computer is
   establishing over time. For example, this allows a website to count
   exactly how many subresources a third party website loaded.
   This also allows:
   - Distinguishing between different users behind a VPN based on
       distinct source port ranges.
   - Tracking users over time across multiple networks.
   - Covert communication channels between different browsers/browser
       profiles running on the same computer
   - Tracking what applications are running on a computer based on
       the pattern of how fast source ports are getting incremented.

Section 3.3.4 describes an enhancement, that reduces
attackers ability to use the basic information currently
stored into the shared 'u32 hint'.

This change also decreases collision rate when
multiple applications need to connect() to
different destinations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: David Dworken <ddworken@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[SG: Adjusted context]
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 net/ipv4/inet_hashtables.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 1346e45cf8d1..0bc6549c38b1 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -587,6 +587,17 @@ void inet_unhash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet_unhash);
 
+/* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
+ * Note that we use 32bit integers (vs RFC 'short integers')
+ * because 2^16 is not a multiple of num_ephemeral and this
+ * property might be used by clever attacker.
+ * RFC claims using TABLE_LENGTH=10 buckets gives an improvement,
+ * we use 256 instead to really give more isolation and
+ * privacy, this only consumes 1 KB of kernel memory.
+ */
+#define INET_TABLE_PERTURB_SHIFT 8
+static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
+
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		struct sock *sk, u32 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
@@ -600,7 +611,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
 	int ret, i, low, high;
-	static u32 hint;
+	u32 index;
 
 	if (port) {
 		head = &hinfo->bhash[inet_bhashfn(net, port,
@@ -625,7 +636,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	offset = (hint + port_offset) % remaining;
+	net_get_random_once(table_perturb, sizeof(table_perturb));
+	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
+
+	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -678,7 +692,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 
 ok:
-	hint += i + 2;
+	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, port);
-- 
2.36.1

