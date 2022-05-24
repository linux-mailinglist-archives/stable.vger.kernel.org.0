Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FE45330BA
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiEXS4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240505AbiEXS4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:56:00 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5845717A
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:55:59 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHVRrb014304;
        Tue, 24 May 2022 18:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=e1HWfCQ6fhqQHuhuJBUeV83l+V3zRDxAZCnJ0MUOhCg=;
 b=OJHmXfuXfcMmauwygZboz+PPA/9iALQP0AR9IrAbLpcjS79DN/DjYW1Gs7V/msFvsh94
 tpNDp4k5jm+q25rD0Te0ICDuB3DlEpAQTHdAs7QAqd3QiOs7cuxuVh/bl+vWfKafUseQ
 /e0wuSxmUXi0gdgB6DLThDK9kGC6RQ1IgNKTqcDbx0/CQG23F78d348DdF6aW7QXKtFx
 P4O9eiT2tIxM6a9ijDBB4+FWUhBTTSfWNMmDVc8kfO/nXEdgOkIS0aF3EtHCr4djhFp8
 J6XtQdboJYrQ+5RtfeillTkTOiy+0d4ceO50bafyr4XNpYFFzNr13DOUFCCYMM4ND0ll 5g== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g93uar1ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:55:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImajmbZzj+/ROe/GB9p83+QLOoDy9lOSeXxGpAqYvAuxJsBNI3ZErQcyJYOvJ7Mpzx7uzB/jXAid7yTxUITg6NhwaUL6R94L9XE2WqdW9wRi5Cq3MewhWaeRdvxJ/oF+tzyb/gAL35+N/jp+EInT1jUF90SpDxqUs6fdbVwTXTt3l+ekfZhziC2XDZgqzGDFamzz3cRo3v9z+ahAu3Uv2ebBl2J0LzxU8HzpNG6pUXkDL6TjfvPftSZ4wsMmKHWM4bIR+0LpYzwK6llLL4OdLzAvM9TjRv/7ldqhzttx112JHgUFWID7+XpB7gSPkHOdNIWiHNPbfo4nTDZaaZBtGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1HWfCQ6fhqQHuhuJBUeV83l+V3zRDxAZCnJ0MUOhCg=;
 b=CAZPxpTbHO/npo//GOXt7xqfgVcr3u7BibC3pjxhnoOLH742TgFnNYh/IX+1DLMc0kddcaZMEIX471zd3z0O2GIhH3I8AZ5y1KKc90a8/xKeohGFHCpwC9h7QWBnAYNm4/KKDMTQuMIgBfzK0/diwlqzsxQTnRLXpB3Afk8o/aLoNlSdcFuoen2nEpIsxAhkLzts92kgDWBeGsfMV1dWLB+HJ0jZFXbVKl/0t2WNmBshN4YusbJ+j7qa+s9mAagSPaj10PURkGWbFmCV9uKGMMGojKPq1X3NMyRk6hh2Vx3YvKAWFCJpizHOddzwKDa2xu8Lcc669fkkPd/bjbFcvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DM5PR11MB1819.namprd11.prod.outlook.com (2603:10b6:3:10a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Tue, 24 May
 2022 18:55:29 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:55:29 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     edumazet@google.com, willemb@google.com, davem@davemloft.net,
        Jason@zx2c4.com, moshe.kol@mail.huji.ac.il,
        yossi.gilad@mail.huji.ac.il, aksecurity@gmail.com, w@1wt.eu,
        kuba@kernel.org
Subject: [PATCH 4.19 1/2] tcp: change source port randomizarion at connect() time
Date:   Tue, 24 May 2022 21:55:14 +0300
Message-Id: <20220524185515.23617-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0072.eurprd09.prod.outlook.com
 (2603:10a6:802:29::16) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8019dd25-7ee8-4e90-7b9e-08da3db6f8a5
X-MS-TrafficTypeDiagnostic: DM5PR11MB1819:EE_
X-Microsoft-Antispam-PRVS: <DM5PR11MB181914FE467232149E8CD708F2D79@DM5PR11MB1819.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jpB/TBPjXCSqt2cmGMok8Et/jRzgdFFKw7nzzcchyFagPjS45MwHSDYfXF7OBAxPHZ5Dz+3Zi1UI7Tir5FojlbNIXLnAcqEYOBwIIwCF7S79fdRGrRqwJWDpEuO87nmMlkYm97rLWicmsAwmmiv45w+oXBK/4AMk33V2Dvk+j/kTjOF4X+Yl2oiHhUq88tKNSaJjVlf/qRsbzkyJLBOFyl2u8+NDOQP6H/rQ/Me0qnqVRRm2JfJ/V5ReuyAtq0YhGAOBGgFmt7NN5icwH5skZIQrT6YNgYcPA9dMrF4KWyRPWrmcZ3zWNuMuhlJI4+r09LWeWKq0tNHYGBwD6t6j9RUv9i1ytdCs0JSX6O7cMW1ILFa9D9jmwXaC0dUL/jSihE+WZCe3ZG4DHQv11bmYhkVrNSoSWifqbdmzV37Yix1IJlf4l32TWcMImAh5J4vgTojFsk2EYg7kkgeHZBhy2Q+wgA8Fc5xckbvfvhBbqeR3eZKUKhqEobVpnibZiptfgaLU5oMBTwJ9dafnw7QNfihyaRePJRavLw1QqcTU5R7k742QKvFnQZW+grdGb7Jhx3RVd7FiPhLJT7MTOyvEc/GNhHZMBUQUAIf0IpXgrWJ9yL9rEyGdHSnaeUut+Wf0QYwd4ivg9lwBXHKW+QhyG8+gqncMZk3S2+AVWaXflWavQNg9O4eWOsdABusd1zH47/1BZ4DBYZ+Suhc26CluxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6486002)(52116002)(83380400001)(86362001)(316002)(6916009)(508600001)(6512007)(66574015)(6666004)(26005)(6506007)(38100700002)(1076003)(36756003)(38350700002)(44832011)(2906002)(5660300002)(66476007)(66556008)(66946007)(8936002)(7416002)(8676002)(4326008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?izHoxZq0MSDMofvazJq89dyajfHIFL6DF1XY6Mpb4Jm6z0p3Duz9RUsl+Nxm?=
 =?us-ascii?Q?tPhD9N1j/Dm7PSIVCeTYUemDvOmpVIieH5Cp22x0MG4W/WCG58Fnrr+0T6Od?=
 =?us-ascii?Q?L9KchIej4fB6Q8LW4aAdMLBaY7f24CdGnpEbQsxsGLkVczB5dhXAj7msy2m9?=
 =?us-ascii?Q?lTpM72R2AOb3FvDQEF9+hp6CJU5gmiS99GzVwiDXpIYtgvp9Ku4HuZmUNsmA?=
 =?us-ascii?Q?z9LKJpmRKfH9I4mF4p8HiCLV6940OAZ/0eEnd3+LH4uE5Q6CpQjLiPWENa+X?=
 =?us-ascii?Q?D/Ulbz6zQ3pBxJDgUy8qqOoxo588PJPhts6tiXeBfSUp7WZu+a/xh9d/CFbL?=
 =?us-ascii?Q?/p2R1xneIyv1DaQGKVml06nWPO6md68OixcIXUo0r8ZDvWvYHCqLbfA/VIpe?=
 =?us-ascii?Q?EIvaItUx6OCaBTigHevHhl9Vuy8dRy9FHk0RYD33kNUmuAEHOmKkRBzmF4pf?=
 =?us-ascii?Q?WG5EE6Wyl9wZ8pYd5EMKcwifmBKR2tnTx+2P2WT6Mzu5AgSERoQKqCGptrMA?=
 =?us-ascii?Q?w/nBPiyzEhagJME98F9CYijlrD7GZYIXiz6meUEX220Fdxtgg3HTWfEc+ZOU?=
 =?us-ascii?Q?IcBcw1DGctWkgX4jH5JCip5FAVrLPvgmOSzDrn0iT60uX/jUQIAlDgcpaXyQ?=
 =?us-ascii?Q?T4IjKzs5KVjwhpili47HcKxNxYX5sRhcPvH8D6qyOhn+nKiNg2+u4nw/CBuR?=
 =?us-ascii?Q?i+rqpbagD+jAqDndvMiDLZytKKASExjV1eC9S0w/bHh8k2+5N6qS1UhemDQC?=
 =?us-ascii?Q?qXnarQWX+opkFRHgkSnaHRr8bTcEZdtnhQGoU/ztIl0TFUEG6jCnQS4rl4Zi?=
 =?us-ascii?Q?xTixvO4CRMnBFBTeU4Et70c1IgIGQPhbLGOodQCOgrJwSZ9Xy9J2U5ZLmt9D?=
 =?us-ascii?Q?Ve4X2K3P0fsfgWcYyxh80rhYHPeb+tSkirer7VseD2SJ7HBAVeIR8V2X7gVa?=
 =?us-ascii?Q?uoZJG9d7mjuLXSJ6gCR9V/cE3TjN7elAcZTuDSTSkT8qDVY1ucJHS3CZ1osh?=
 =?us-ascii?Q?H8LD+AP0dxX3LGNLwviXv2ed8HURzkrNoFZZz8inAJ0UvCZPhUw3H8+G5qGg?=
 =?us-ascii?Q?vodUkFh9Kw8O+t1sT3nsnNkboQZeNhzdZTwFKD7/i/MFskQrLIff3Pt7kYoR?=
 =?us-ascii?Q?q4OungVL5q3Lk/z87YAHUF45ZT5sNgy48rwZxSKjCJdz8HWy2tBtVmbWV1vx?=
 =?us-ascii?Q?hsktIcYWsbdKISO2fCaoCXinn3zXiuq/nmTWmGIg3FgTemmFudJL95/1os2U?=
 =?us-ascii?Q?MGFDKgPs1rIlNSbGHZgDmeNjNBi6HCBK3b0WPjwssErLT69bVEWUErhVE9dJ?=
 =?us-ascii?Q?jX3q3IJx2sLhx4qJE0GwkCQRFN5DZ7ETa+VzfbgE/Ox2rZynvubtuQn7Yuht?=
 =?us-ascii?Q?LLavVmjkaYYdNg2Xb+Iz8lDXsUsppXWons29j9bUZzN/8BRjI30+odkU1V/u?=
 =?us-ascii?Q?VlyFxTIRYlNMiUtFbcvpw1YtHMbGpQNs/Ko6XV1b72Axw7/q3qotRS8tZ4vP?=
 =?us-ascii?Q?pJqDmeY2pvSXcYG2ZNZibxW1J0MlDjtfmIKW+AzLkuThkZygFoTWzc/2sINo?=
 =?us-ascii?Q?e2UUVHFx4jua90Vm6XeEk/AjAgF/B7gM/UrnWSGQoNnfla5dRTDfbe+8VGLa?=
 =?us-ascii?Q?bbifPA9T5/i4CgofEAQg7oZrLakkgAO8VewNgLb5AFBcWy04W+1zCR4nHaym?=
 =?us-ascii?Q?3Lb3CCSMlVcykC84F1Uz+a2bsKszsc7TDYCZHmgo9uqCXWRTicunriKFMKhf?=
 =?us-ascii?Q?y48MEp1CKjdGyQ4zywVMa/KWQk1Wxz9a/fOBjVrvXkMRs2pCChyG?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8019dd25-7ee8-4e90-7b9e-08da3db6f8a5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 18:55:29.2689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VeknF3xb1v6Em+nwSMETI82Mv8ookqLnRL2FFsV9Kd0Z53mh6bvjN3GP/XqZx5RJrxmaANdYtxM9JV/Nc8SOZUSrk9J43CtvxX0Xr3j1wGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1819
X-Proofpoint-GUID: 4CfDwVL3ZpPXAFy2xz1S58H3QyK5RkHL
X-Proofpoint-ORIG-GUID: 4CfDwVL3ZpPXAFy2xz1S58H3QyK5RkHL
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
index c96a5871b49d..da9537ab3b98 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -714,6 +714,17 @@ void inet_unhash(struct sock *sk)
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
@@ -727,7 +738,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
 	int ret, i, low, high;
-	static u32 hint;
+	u32 index;
 
 	if (port) {
 		head = &hinfo->bhash[inet_bhashfn(net, port,
@@ -752,7 +763,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
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
@@ -805,7 +819,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 
 ok:
-	hint += i + 2;
+	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, port);
-- 
2.36.1

