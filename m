Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5D25330B8
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 20:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbiEXSzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 14:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiEXSzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 14:55:35 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53605717A
        for <stable@vger.kernel.org>; Tue, 24 May 2022 11:55:34 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHW7bV004747;
        Tue, 24 May 2022 18:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=qVUnQXgfSLQYY+hQCR+CwL5zuoAOP4Ny9Eg20TwXmsI=;
 b=gR4rX+bgbe6H4juWpgg8MrGETcByTBH+Ap6baIttQSpfxtaW6CJezrZpnAQQl2RH106C
 0+qKf6i0u+kMra2RZajvKlO83CQl6lhL+FTfeDFLM5nqywH/4nqIArywVIDA9mHCjnWg
 NfFu0djZjz0FaSVDpIXFgNWm6SHNe8daD7yDYFgf+/6Bm+m4vrZnGtCLKfSksbOyvGvt
 eTq9rftKLLTny6MviigQCNOexKmvYD3BoCyXIU7kUez/Qt4BdXSZLNFC/SaBcFnnMnWS
 i/nmEQVBscJbovzm/lnBA0DH2AG2dDyExbWV/V4L0iXVRpJsMuWXJPEI3PbWjXBkm+1d tQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3g93ub01x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:55:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EB/Xdt3mVaq75VLJnHmGcrefDCI7q/3O2Hava1cg0BuX9dx/kIacJuMbz5Bh5oRmGzbaHZPuF37CyM+/FbCAZun4WkJpy3My+tD6ZcdkU/HvMzikzyAwbpQLkZ1Z04GRnYORrPwTcE7KktYfh3M0crZK0lkG9ZDBFXS70w4TbazSeGnqGOYU/TPbFdpS3xkTWpWTqMkBZvVpKmwFFX+HbKMI0wm/1qFxi17a6whsaMrRSLa5ll58d+AA22eVn0J6cB5BkLDldLQUaqxXF6a4dp8fu3It8c1wWJKmlMBCqktQsSc55VGq1ob4N5/CPCgb/Uk6gIocu2hVRGUJqX2xOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVUnQXgfSLQYY+hQCR+CwL5zuoAOP4Ny9Eg20TwXmsI=;
 b=Px+IjaDLNy0oc/SVue6Y2gJCKEz8JctB0k5DqTvd3jXyQ9Ki6bbfZkiDw6BC2gjPpYKSzp0HJJKSuU1lRtLlzHSIEG8t/ke4rMu1ePMGfYYeQqzb/4o97/YTf6Rqt5XZsSQS2fgt8Q3RRimzqaGRda833lxhIBbHkgLNRrVh7AFpb3p9C04x+FdUyDmBmFX/XgQHfgewfw/kNFw9uRYcdtXA+IXqppeMU/MJUKpmME4ckzYE2n71b6Sq6E4eQkugi8hrQl3hGrtPNgVFViG7eBubmOFpRXJC2Ff++bx9MG20Qtaa8LHC2uV1ZVCfL3vvrFs8sVQ7LEmp5RWfaI9k9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BN6PR11MB1252.namprd11.prod.outlook.com (2603:10b6:404:47::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Tue, 24 May
 2022 18:55:04 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::2c35:ad13:51c9:9c4d%5]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:55:04 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     edumazet@google.com, willemb@google.com, davem@davemloft.net,
        Jason@zx2c4.com, moshe.kol@mail.huji.ac.il,
        yossi.gilad@mail.huji.ac.il, aksecurity@gmail.com, w@1wt.eu,
        kuba@kernel.org
Subject: [PATCH 5.4 1/2] tcp: change source port randomizarion at connect() time
Date:   Tue, 24 May 2022 21:54:48 +0300
Message-Id: <20220524185449.23519-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0162.eurprd09.prod.outlook.com
 (2603:10a6:800:120::16) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 998fbf01-7d58-456f-9d65-08da3db6e99d
X-MS-TrafficTypeDiagnostic: BN6PR11MB1252:EE_
X-Microsoft-Antispam-PRVS: <BN6PR11MB1252AF76A87001FAB797656EF2D79@BN6PR11MB1252.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Anmhvea/3flIix+ZQu5vT1Y6s54+UCqmVM7wbYT97pmWmYPu9mQzboK2gra5NA+TUbKXJ3g4bLjcHi7RmSf61wAqeanFDis2emO7v8UZDNgYgwpcrFXs4Z3IKY4w+whytfTMpSHWM0m/Myuor2wsbBNJipWPolE+/Z/wNu5gYYjOSffY7oBXkgRaGXJ+Zx4fbtbbT0g0WB5lO/wWOt/tZEzyniho2ZK85oER2gxBgkAmN5FpRiwecxI3DozEBsUFBBJWsEPPYuGiLXEl6ZKDUVHh9C5uLzNeskqauM5UsQ4zO6fJ2TwA8EyLB91WBKovY60D1fx6BDUuy8BVnU7Ui7DtUrvNYREzp4lJ26GakuP8asBThHVjeDkhcDO6taiJNQmUDT1g7McPGUf+9GC8FXlkEABdiZ5Vob2ueuP2XfrHQXXcAV0I+cVxG/KXW7JRtnek+7CVVgg5d1QnyG4KmE59uXhdHkvPvoWsytUGXYXVsBz1+r9VBfOiVO/Bh2tllYetfp+1OyBE5sWo71MvWvz7RskuhveMyvqBEQ5j68J+BvmXLkV9XEgpJVnyOLMGSif0bzMOTqm0FnC05BTrpCkFZm9+lSm2DIYsnNS3Cr+FqTqPqzsGTzmAvJjKn+3ftO5RPFNObrW5UyesILBwIoDaug45c53uR6NQgvsvetDzMWk7FxOOu+uViTfCwojrzhRHEOG4Q9r/UUgqFdGhwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(66574015)(2616005)(1076003)(2906002)(38350700002)(316002)(186003)(38100700002)(83380400001)(52116002)(36756003)(44832011)(4326008)(26005)(5660300002)(7416002)(8676002)(8936002)(66476007)(66946007)(66556008)(508600001)(6506007)(6666004)(6512007)(6486002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lko7n2j8t0AGPOA3/spboWubDBFgCOEDHQoQw4m3W5P+9F0DMiVTNwAqneKM?=
 =?us-ascii?Q?3BFpdsGVq2DWtWl/SHFcuNS19tUMHBlXYICFgND+4fUfqecbE2Vy+KbiRKQv?=
 =?us-ascii?Q?/ea04BpVTyy0uOYPG6up3s5wp1u2U/8rbULqGD5PlvS4Dp+9KfG9pwFWxye2?=
 =?us-ascii?Q?aWc1/jayoos5BG9gLFLXU1Qll51XnCFLvAwmOCaqUeLyrTPqkjUb98RM/pvy?=
 =?us-ascii?Q?qiCabyPbsX/Qx2W9TB4cYl1JcjTGMR/j1hW9NxhQYUZPIGVvBZv2nHJAhOoZ?=
 =?us-ascii?Q?0cVSAXua2JB2XwDDkPWiE2jZat3dfOmAoWreGHIP3qe9GR1wXUZtVn03c9rL?=
 =?us-ascii?Q?sKgp4eNEvey2XE64gwiUdR2lBfRTI3sQo75kPhPDM9y3FjlUjkDf7Xl+e8lN?=
 =?us-ascii?Q?cmTg9aUDvSP4NzJ6LTwE/KB+JFynQXOAqQDWUaEjC9EXdVinj+Z+7NNC2KKz?=
 =?us-ascii?Q?dEObFfAPvuBrQWLtIUDLqWSahI4pFXQhbq+ji0kpk0I49aTabO/hileigKeX?=
 =?us-ascii?Q?h49Jf8XducaqyuBrSXvG79ZDCiLQ8T5PR0/RowRUYd7LuiEgDEzHqYbfalp4?=
 =?us-ascii?Q?oN3XaE4gbi/Qlhm0Y+Kbwg8nNF9YqMVVPcwFd8Iuaqce+afURSnjb695SROr?=
 =?us-ascii?Q?7wYgkUU4hap1I76E0bIsAZQgMqnXUgsKlOVg1xkT3KIesPnlm0CTVg0aqMt6?=
 =?us-ascii?Q?1gyvmjPbaHpKCpiBhoIWdoN4roMR/aXRnZIFTIgYtCGDTZPUx7qn5Szd20Tv?=
 =?us-ascii?Q?vPP9ifacdWzolB/jBl59ZVOjTE6MAemZxycWUrV95f4VLT6MPecjl7U3yRUi?=
 =?us-ascii?Q?5spA3pkDbYaDS27546+Wdk/rJCaYyN2x+OusGuwe2DgL1wG3elFhAAPbn6u5?=
 =?us-ascii?Q?PZohawXNTmmyzu/MsAzzsaj2Ypk1NA3AEfKAh9oeuZ912skzMw45RW5RAfxh?=
 =?us-ascii?Q?+fm54c/zHNoAWYzrwF7uqP1u8GEGckhn5HbVdjBuP97R91qbYAbHqoF1jddx?=
 =?us-ascii?Q?1TXGFYXI5/TqOYsGTzdipMSyywswG5MLDVCRDDLCINXEoeoSP0wb1a3iWOLx?=
 =?us-ascii?Q?Z8VT115NQKjHIE1Rmnn5pbKXKdfnhZT/+BKGvyEwKATQ8a2R7pDbNSQC2EkM?=
 =?us-ascii?Q?T7jGQ/hrVmRdCdIvmcya/qEQFUPPsm7v6m9EDt1ytZtI5PUxQI7i08vnEEJq?=
 =?us-ascii?Q?38VY9PZbdjHuIOjtRJo7/Bs3/8LCvy81XmLnp0M/0e5St6DOWpjbNcw55Kfl?=
 =?us-ascii?Q?fFyCbBdOJ9J24yXvRQ9DTFeD8fSbCfwLFiwqYHVKLuNkFAmeF612bITSjtNz?=
 =?us-ascii?Q?QjIDMb0cdCaanQ0h07jsvhYKRZ8PzyXOx9Xt67cROL9drFjqTeueNzIvP2wD?=
 =?us-ascii?Q?d/MFL2FWT/JFkYW02whPC4h1xgPn/tpe+ZMHDhwDBYTgbyExwrSVyYs0SbaW?=
 =?us-ascii?Q?vTuR5asvSzhOAv7/Ijm1UaojDXknOP9jwMQhRSe2UT3xp6tLUcAAJRfUMtly?=
 =?us-ascii?Q?zzVtT+kEqbMKmDwZCGKnYi4GgR2YgNWb0yEvk490bEwt5LpOMhfaT/c++TY/?=
 =?us-ascii?Q?39ZXbVM9g3jx80cixVIPGqk1PpGWvD/IljbCGJQurfbDP8emwmcQkovNnuFS?=
 =?us-ascii?Q?EolbT0us2VKtj1jc43HJUbIZJweZW7hrflu7JOgySeGP44IXR3GllP8rBsef?=
 =?us-ascii?Q?8Zgb7QIy9MlVpQcAmjRy367kZefVb9WNYXqqv79yLytXfhu3xJ3o+6ox6P7+?=
 =?us-ascii?Q?JCMCHudBD6V3USezKC2SpCU4yaUbMlM=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 998fbf01-7d58-456f-9d65-08da3db6e99d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 18:55:04.0671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WG95qTLse71D3vaJhSxW37nP9fqiIy7z+XxEvGpaQCpec4Wz4X1NbMGAAMzpT92aPkK+vBCPRxrTdGLLYmSWqzZMO83mMH93s5qR3SwcRm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1252
X-Proofpoint-ORIG-GUID: RVRiMkQtzDdu_yMb1mfDY16PDnGX7L6W
X-Proofpoint-GUID: RVRiMkQtzDdu_yMb1mfDY16PDnGX7L6W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 net/ipv4/inet_hashtables.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index cbbeb0eea0c3..dbfcefc264d6 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -671,6 +671,17 @@ void inet_unhash(struct sock *sk)
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
@@ -684,8 +695,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	struct inet_bind_bucket *tb;
 	u32 remaining, offset;
 	int ret, i, low, high;
-	static u32 hint;
 	int l3mdev;
+	u32 index;
 
 	if (port) {
 		head = &hinfo->bhash[inet_bhashfn(net, port,
@@ -712,7 +723,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
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
@@ -766,7 +780,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 
 ok:
-	hint += i + 2;
+	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, port);
-- 
2.36.1

