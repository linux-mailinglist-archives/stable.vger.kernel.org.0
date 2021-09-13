Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B3D40977C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242874AbhIMPhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:37 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:1050 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240371AbhIMPha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:30 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWk6v015226;
        Mon, 13 Sep 2021 08:36:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=MJmWH2i+LH7V6PPmPpaHOIec0aH3hfKddUHx3lmcZos=;
 b=bmMZ01bmLv0mXFraMKSfIk6OZt2U/DQdVQllwRXcc4qvxStzqh10D/BjsnlaoYNNrYzv
 c8TrW/4wKHco6BeXt3E3WNgWMkNHJLVqP/YfkPcYLXnghdJoK6C5CcuTuCHRljW3WYc5
 YXIAIs0rqTxSCJOz2dwn3gvROnEhT7+2naSsO5sho5n0KPqsK2kwcnCV48xSpg5JFdQc
 PYCy0zHMt4qzzS0PxB0ELDP/kUSMICuIEktXdi3hKCu4g3ZWSaptmQ/jTRZKZlvmXp6s
 DEDjybQ64PU/YGUScLC+KYFHMO35iyZ+xhXD9/I3P2ACap7SvsCU1rPdzLILsNmf+lp0 Kw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b1kfn0pm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:36:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEv3strqB7UWkIOn4q/yMiztVWzTCrIq+ag1kC9KFcN32Oz2lf3s2s+hjr1b2s5KYzIJsGyOZnGh/s8n/RHbRgxsCWIdfjUgIEJDUhixuWtJ4qfAu9jJjdUBGVSEejzDY8Qk44suZU/OvcXMNMOYPzYL+vztNilHY5u17AM4MoX8DljByoJGamqcH1Lp/6yCrJO4lQTzJKvoVg9N672wm23ifdP7EG4irva4sg5N0SHvWl0kjjLRmmLZdMCNhgxxEiHWIHRPmoXHVMhdIjXcAEWZ/LV6MSn4DijjGg9E1gWXOoRxFvwasYxrkV8+Geg7GNNY6PYykb4D3yIujVxMcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MJmWH2i+LH7V6PPmPpaHOIec0aH3hfKddUHx3lmcZos=;
 b=OKhlGAqz+sa8YtuZcKVp/mzcaKC7hKUQdKyhbifp3fR0XeX+MuZ73qymxYjUjyyR/9FvR45RftylawNe3Cs0zAq7fbfolFAcalE+dZod/Dmsdca/R5TuwH6JTTuTmauNGFQYrr1PvsE28wp+tWQsAPOlZJ0Nwdt+BnkHuuecfF21qySXAZ5O+bzpewb5ymebsNd7cFT+2D01Q4fg03d+0bKVLdey8Q6Ts/6JaNAmiUNEgBuXxt8Jh9tcCy3lc+GF4t8GRdeJXl/jGz14VYAqsKb3uOmTnvMtSO13owNp3AsjzNuYQFjDrLZtmwg9FWuvXSGbC5ZlRqHVnhkvSB1hsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 15:36:02 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:36:02 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 05/13] bpf: Reject indirect var_off stack access in unpriv mode
Date:   Mon, 13 Sep 2021 18:35:29 +0300
Message-Id: <20210913153537.2162465-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:36:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b11a0e7-8093-4ebf-154c-08d976cc312f
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:
X-Microsoft-Antispam-PRVS: <DM4PR11MB554954B96A1978C81A72F55DFED99@DM4PR11MB5549.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pwjjdO+8Ha2jYoV/+Sve290/GSPdEZyrdriIP+LUSTr0eAN2JG0v9MtzPn/jM6sAdBUMnLzteanhSCMMsAl/e3zLQTxsteUGAdp7z9l4DcOmbRh9iUpZv41CHJTxKyFOT3ib3zFUkVvS/aSbmAmyNJb/DpHk22u9jYAggGFFZNO5ZAe+tYSxavh/GCE98HlKZp3CFKOM6kGRGRNtL5y6b85P4srGRhDrWDEBGK2PnNV9RebbhEEk9QIfqeFi242ltCTNgoPDWMXhnEX0fAT9m9cyULbzYVk4reE/z4NR84CEEtvuphBaF8vzk+VYVEsjBottMZoc/QuKyTdk6CktP4EJ1mpon8axjgFK/o0WRF4BxqxR7vx1mlrCW9DUKcww9/I5XXSSVh9mUrBW3PgK7+/dQohn3Rz4dWq2cp+saY8HfvnuziFmO0O3NiLZqAPdq87FQbnj+Zf4Og2vLV7t7Zo0P8t22PNSlP1XaJNotWPBS6OMrfA+k0p+Eq8Ri4pnYfP1nwX7WifvKw4Li/bP5+AeGTVyBDrezO72wn1lv45/wSOSC8sH+LbxOaV+f2Gun08byRBfwFJcJezmucR1Q+q+kKELdtOoozj2ZGIxxYrSnOo3Gz8EqNxmKN8KzWrDwf0bkA/pi3JLqm1/HGGZ+vUbNc7g9pys2Cd+Uw1Ml9vQHdQjNv3yIz5H3mpSLKgZOJunuTCGk4d6fxtbyIytwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39850400004)(136003)(376002)(478600001)(26005)(83380400001)(186003)(38350700002)(2616005)(8936002)(38100700002)(44832011)(52116002)(8676002)(6916009)(5660300002)(6506007)(956004)(86362001)(316002)(36756003)(2906002)(4326008)(1076003)(66946007)(6666004)(66476007)(66556008)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zEFvVLJgrKJipZ55RmusMe2Txcr+1zpR31gBlZ9JPWqCrDEC7vphzBt9uWm7?=
 =?us-ascii?Q?9kQejd3H+mReZpRXqGSUBrd/ai8Y8ePIxT4xCtGa5V4FpqAv0fKNkPN5nl6X?=
 =?us-ascii?Q?gNUS+Po0bGX7eMmabcbOJprmfLv96iMPPZhpNYdlFD+xRxZIciKZh5Hnsl2k?=
 =?us-ascii?Q?6EVpFd622p11GFZRsBrUOj+EDfu27bxox9iqQ3dY05iqVM9qMHlLfDSvvn80?=
 =?us-ascii?Q?RFSSpVGzM52zy9oHPSgXSDQWywhUIhVLNDkLQxR4O0f5QU0XijUNR4SvABFn?=
 =?us-ascii?Q?Cp+JqHiZuXr5xnQ6t7iLHXzbBOPZmiNKuGXxUc4qWPnXR6yZPqFPWZRxn7sp?=
 =?us-ascii?Q?IORcPqmll6+1yRAPhmF8hm5rpE2h5SxPGYG673a2PsvwlpKJV7SzMGu2jQdL?=
 =?us-ascii?Q?YSlJ9DLrRj3SSCXoJ8QYWREhcnPMg9GIYIpkdq1NW0vLTKS0OdeluzprcyWp?=
 =?us-ascii?Q?IPWsikR+28rSnlnphrd9Vtr2h0SmR5Aa7a0jgjDrAtt6gMu/MxSg2XHHBAQJ?=
 =?us-ascii?Q?JL+O2l04qWadeQyX6nyNM+2Dqa7iXfxY2IeiqW0sYoe8ksv57UtCCVHiP/bm?=
 =?us-ascii?Q?OMun+ai0I89S3yw+iypSioXTGRUXOeTx+gkI0oOlijZP0GdthoLXT5FJO8mB?=
 =?us-ascii?Q?I/rKYV0pDrF14A+1riYnfq5SBkQr7mlec3P2PJLaGnobBxK1ERK9Sd8eB/8w?=
 =?us-ascii?Q?NRK1VyGfNRnHBIaATwWl9UYpgxZrxkVVU2tabzvW9V3iHDvrRPmirz3C/Akv?=
 =?us-ascii?Q?vKJLxQNThqhK+8I3YhzVxuIkPcCEAhamGHstaC8cbkag/49jiwXRdCmTbVSz?=
 =?us-ascii?Q?EUo3F4GRtCHU7O3CMnu2/j/n+Cjic28poajBGUzQ6gvoqPpUgks5gHqrhLoU?=
 =?us-ascii?Q?BFwIkXoA9KlHiJzzlB41r67r95nVe9GjDjd1SRPGbL9ebPLnEZoNgZu13Nba?=
 =?us-ascii?Q?aJQ4DHT17sxgfUp9830nx60iYa3GVA6i6QhcutGF5eUVDvpaiuFFbARKJaBk?=
 =?us-ascii?Q?JjBsnxpXHaFLZspPVrmVmKE5dbSri/z/obciAuHNLhnWKKW+QjJWxCHUThPd?=
 =?us-ascii?Q?JeX+WmhwLOAa/g5AtZgbTQwCBdibErIBTqBqRfbsl0kgnqQu676mOh0cmksW?=
 =?us-ascii?Q?rkCsb5s+6XJpDdd0bMY5X/lz3SbAedfL1DSt0grUDHY5JlLDdpEdTXRNX+MP?=
 =?us-ascii?Q?HPGksvN4T76ODh59+XEryN+EoPfmfzY+/i8E2Cq8ql4OlWNwamKVRMvvk9P3?=
 =?us-ascii?Q?P51vx6p+JJa0IVNraajFhpnEElQlC5J9nC+O3yawbEEthOviXQ73Ci/UgUVw?=
 =?us-ascii?Q?z3sWRNvtCQ+3y6ycB4Fes9ik?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b11a0e7-8093-4ebf-154c-08d976cc312f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:36:02.1674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ZI++CzBA0zgM6RA8TetQGjHKtIqKrJ3N4pXLzoK+2SM1TiVzCXuouDW97q5YazaUuF0DclvVNSM1RPR5AbDOq8+r8O6bMz3uRl7k+/D88o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5549
X-Proofpoint-ORIG-GUID: 0HGXyqVN2hZNOVP9SNtqwNGmsbx-9931
X-Proofpoint-GUID: 0HGXyqVN2hZNOVP9SNtqwNGmsbx-9931
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit 088ec26d9c2da9d879ab73e3f4117f9df6c566ee upstream.

Proper support of indirect stack access with variable offset in
unprivileged mode (!root) requires corresponding support in Spectre
masking for stack ALU in retrieve_ptr_limit().

There are no use-case for variable offset in unprivileged mode though so
make verifier reject such accesses for simplicity.

Pointer arithmetics is one (and only?) way to cause variable offset and
it's already rejected in unpriv mode so that verifier won't even get to
helper function whose argument contains variable offset, e.g.:

  0: (7a) *(u64 *)(r10 -16) = 0
  1: (7a) *(u64 *)(r10 -8) = 0
  2: (61) r2 = *(u32 *)(r1 +0)
  3: (57) r2 &= 4
  4: (17) r2 -= 16
  5: (0f) r2 += r10
  variable stack access var_off=(0xfffffffffffffff0; 0x4) off=-16 size=1R2
  stack pointer arithmetic goes out of range, prohibited for !root

Still it looks like a good idea to reject variable offset indirect stack
access for unprivileged mode in check_stack_boundary() explicitly.

Fixes: 2011fccfb61b ("bpf: Support variable offset stack access from helpers")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[OP: drop comment in retrieve_ptr_limit()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a5360b603e4c..d2f3bbff3175 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1811,6 +1811,19 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		if (err)
 			return err;
 	} else {
+		/* Variable offset is prohibited for unprivileged mode for
+		 * simplicity since it requires corresponding support in
+		 * Spectre masking for stack ALU.
+		 * See also retrieve_ptr_limit().
+		 */
+		if (!env->allow_ptr_leaks) {
+			char tn_buf[48];
+
+			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+			verbose(env, "R%d indirect variable offset stack access prohibited for !root, var_off=%s\n",
+				regno, tn_buf);
+			return -EACCES;
+		}
 		/* Only initialized buffer on stack is allowed to be accessed
 		 * with variable offset. With uninitialized buffer it's hard to
 		 * guarantee that whole memory is marked as initialized on
-- 
2.25.1

