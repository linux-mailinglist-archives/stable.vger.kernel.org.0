Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41371409780
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240150AbhIMPhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:39 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:5398 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235024AbhIMPhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:32 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWXVt015200;
        Mon, 13 Sep 2021 08:36:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=wk4xcOGbwK6tJD1fK0yVlM6zOH6i+7y4uohjT7SbVH0=;
 b=KisdCxE09oggoiTi9n8ZWf9eRKgUpCo1tY62dDuT5/Y8WLZJIryi6bTx1Xo2AwKZE+w7
 pwVBuF0qL//P5BoXXk+4YpaaOwL5eVx3y62bihwUdSYPeklhyBgzbq7xR8uQZuHkVE51
 nAqsModKyI3cPueVanxsEwpEaV1CDn2YnVEVRYHqz3yoRkMsptFtLF/tbHdKKdeAMXpN
 1OYAZI1lguCFxC5z90VeHw/OPGc5Gzs0jWTVTngxechqDO+jcOLSV4iFUb5aXt+u5BKJ
 7diGjJU0LzJ0VUS3ogQGcQkTK/ZIg2F4vtlsCUSsbMbL/K7Kx1FHIUFbel9h7+q0wK/8 Cw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b1kfn0pm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:36:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqK9jNdv1bEjbyHaqth3CHGzo0YQ5ccekD/Upws/EvaPa3EzMQbIw1pWwCKNYToa4vBJ6wNiGpWWSG77OIG8/LtqV1yDV02ZSmLi7l5l4kk1E7OApwXSdjlre8CRSDDtN7Vt3JoK+kYskz0kvGUjJURNKVGp3EOhfFJHonb6ufgkaBBKOxKDOn07UZaquWQo038vuGj2GbV1cdJSrKedU+ZYBlXNGCsFP3DEjukRvlLBdNFUmvnraOC4yW4z2huEmy+0wWPlZWcGXQbAduWgH+vHyCxAQJtE9o0+UiF3D0Xim1Rk6pPpVl4FsV7Z3eQ+hRMG06fHz4RrkAmDSkwiDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wk4xcOGbwK6tJD1fK0yVlM6zOH6i+7y4uohjT7SbVH0=;
 b=KP8So6dR+lY8wxP79NokAF6QItJYDBPCXBACkEGGUS7e91nbUfhs+nNWsVTK6R8QLnXcUhKfaHmqKrn0xmC+fie+0cQ4wO/2QhUYaavetkA29+oPAf+Z+sxNe6SU/YJPquseX6DDkpbkLxBeeVn/0yKmIPAD60NPyzX27syf/vDMx8B9O3op0F9EnY121B7xPrKry8Ha4+xdJ2scRclFtUugd0KtF6eCw6Jvwlf134Du6UZYLhNeSaF6vEg4mPobH11k4DDMcFq813fuyfI16fE9VJLWnWTNnbLSPwZsJ8ZNDOl2QHGhTKpHWsq4ia1ly3VW+Ci+bet1RawWut1E6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 15:36:03 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:36:03 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 06/13] bpf: Sanity check max value for var_off stack access
Date:   Mon, 13 Sep 2021 18:35:30 +0300
Message-Id: <20210913153537.2162465-7-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:36:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b52fef0e-98aa-48de-c4a9-08d976cc31eb
X-MS-TrafficTypeDiagnostic: DM6PR11MB4657:
X-Microsoft-Antispam-PRVS: <DM6PR11MB4657F110A94DD8844E8769ACFED99@DM6PR11MB4657.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bsQLrXVszAwOqaiWexm0tfxq4hxr5SJfVv5+0iolD2G/bGFSRBniUtbx6V2NP3cBN0Ggng/U7GuHNzvrb8RuF6K6e4glRVgPd+bsTxf/q+j8/gO43nHY6aX9smUcHpPSLhooSeU9V0OXbjc3ARXTf/zRMDj/h5XXXjQCigFVb/D1lOT/mC19zjzFz1uPDONU0ZVtrkJltz7eAC93tz3k37mBhE64Vgt0hkt9WMVq108mZe1LJ6P6aM8KGk1DGOzJ57Z5VciNEEiRKB6eQwJB2kbOFnRNF62mJcIYaj6s3eM2P710cMD60E/67AWBBg2ZUt6nMNclGRAtTI0ucJlcz74HUlci1pYp+nJM347mlhdi5Z0YjCspcXNGJG4SC2FYUL4cjj6Jkmqr+rQl5gHCTy+de0Ijsh6Pzt3GjNa8MMKeoPkPtF1sUHvb1egyMGI7Jq0JT56sVaGp5O+ZI9D3aZj7pl1esEjCZyLMnGCvMkzhAkxsYJxqvvdM/oJp4fCHAFM3G7ESpsL+su8W3fJpy6uyIj3YMPONg0annTjv8GU5OLii0Kzt0EPjGzZKFYJMxsUFq/k1mmWMkl+xmj4HbDGhCyjLy/QEDNC/V4orZP2+SR/LSAb1PO34H2bkPTglpc32H+zIWoo+o9u0D544xapfuU3Axp7v1wVBZxk2MdYYwb3pDoV7ukYsEIZXR5jRgWFiGIDUlDTfGnNaRLi8AzicHmsPWLH5ZaNe4FULO0YjA/BejJkbYldxuR0SHYV0GVXP9aKXQffwWRCmzgPo3h/tm6I4whdrxX1H6ECkQV8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39850400004)(26005)(52116002)(478600001)(186003)(6506007)(1076003)(66556008)(66476007)(8676002)(86362001)(83380400001)(6666004)(38100700002)(44832011)(36756003)(8936002)(38350700002)(66946007)(6486002)(966005)(6512007)(6916009)(5660300002)(4326008)(956004)(316002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hxBN1gGgPB3RZH8ODCbRNew7JPh16X1IB/WOh2htwP8JYzlXvF7gxddbtTII?=
 =?us-ascii?Q?7sizYXUFiWwfbnvPN1aVy8kfrtxWr9ZmscnFITK8uerlcCbzgxWJFt+0Okr5?=
 =?us-ascii?Q?79Op3EqQLx+rK5JAUx1500VlBXNo+z/pqbZkag+ZGsEKmQHVEYvAto6vutuW?=
 =?us-ascii?Q?IJiYuDOOlS02rMZD+1tkb+DikZf/mx6OIzFq1wyDAElqYzFO9UPQNlQ+Lrsk?=
 =?us-ascii?Q?0kQG0JM6QE3miF4zy/hvgP8mFaM8+9bp1jq1Mhnvz91xwIRw/oPic6djIiDC?=
 =?us-ascii?Q?1m0Gt+0Xogh4KWttf2nh6IeotZC8qjPUwzejj8EwIRw1wr9AFnqpmiZWf3OK?=
 =?us-ascii?Q?lDBDCINQjuhxdAoiVGbfzZ+dX/Wkv1ZCNUT9pjxSjFxFh7LHtV9bDy56rGwI?=
 =?us-ascii?Q?ePiQtZagy/XqvLRjNv5tVr1Dh2Uw7wkL2aVXE8W7ayMnwD+qf2uOyUOAKgD/?=
 =?us-ascii?Q?KFZYfKFhA774SywxOu5B9QCPeRFhCPvXXRgPGYCMWRHe6hLCkBD0S1YhyRcO?=
 =?us-ascii?Q?+JauKCtEzqLJGZeyn2KOAo+LWgsQddPY4F9kwJJsCmNN/ZJiVdps+X3QR3/W?=
 =?us-ascii?Q?jp6IP9xnON2hsXTxJNabDdyfvGtNucCZRYtJoBuvzDYnVgQM4wAM46fuwxH9?=
 =?us-ascii?Q?1NbjFUo5DzIK7lJRy05KFpB9EOD0LfERlVbEKS4mqAqvcf/0Ju3siiYn5ajV?=
 =?us-ascii?Q?KzhWYQqK6x4xPZohUcaoTeUQVqpZroycsEbvkk2pKTfg3aZrtegezC076kpT?=
 =?us-ascii?Q?u7788JU07aPGndwIM6JPPlxsdgeb7APIFRzhNI09BhAwXAyT465Bq/TdvGzG?=
 =?us-ascii?Q?gg8Ns+VEzTVQJvAFzAVIbnhuSQ5wGR0amcTg4Wm1JNnyYEDFaCcG4bQlZGjM?=
 =?us-ascii?Q?0PXWFMxIL/fI+wcWkCgOnsf9CdrcC0GSBYGHT4wGEQ8/ctNSTnmduyxroG4W?=
 =?us-ascii?Q?0IXWsIEXU6yvpmw8EPaprxalNTwVKKpR+g2HCmOSs8TdGae63jY+4ka4QK7R?=
 =?us-ascii?Q?ndYMsBobrzBMz2Alr83l1lz1w8gO+uRKdkUY7kYUEZj61fjW3X62AjdNYS4j?=
 =?us-ascii?Q?lF/z1bbm541Tniw7HM+lJVhIwWKD9kMU+GtOQ1IZo1TcgYs0PHIgWQnV972N?=
 =?us-ascii?Q?54xRzlVRQN74ZElJ1bRe+RSMAF12zZFj2IlTLwLqSTrVZSZAaeIY5NaYK2sj?=
 =?us-ascii?Q?TG2hLKacAL/zgfUK2coHMbnKqBTfZhX8sXko28aPUImh49URi6VBTpJBeB8b?=
 =?us-ascii?Q?ChLGkgvZltGTjBE2FYrnbvbCgk7J8QjlDJ8p6FWSPTfZAQKXop6qhYAwMRqi?=
 =?us-ascii?Q?nnC3TIaeL7BHVtFo0gYbY/9m?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b52fef0e-98aa-48de-c4a9-08d976cc31eb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:36:03.4239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OADn2Mdk7jH+Nwy7Yo+jOKH+JECEpkJGrEbTnI4lk6mxYf5bjhcLd53ceAr7G68oYfWo+N7qTwT99wjUVttwCrfPfp2jYauy0zw/bcwHqNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4657
X-Proofpoint-ORIG-GUID: 2zo6GXyyh02gXt_8HNNeR309aA8dpMcV
X-Proofpoint-GUID: 2zo6GXyyh02gXt_8HNNeR309aA8dpMcV
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

commit 107c26a70ca81bfc33657366ad69d02fdc9efc9d upstream.

As discussed in [1] max value of variable offset has to be checked for
overflow on stack access otherwise verifier would accept code like this:

  0: (b7) r2 = 6
  1: (b7) r3 = 28
  2: (7a) *(u64 *)(r10 -16) = 0
  3: (7a) *(u64 *)(r10 -8) = 0
  4: (79) r4 = *(u64 *)(r1 +168)
  5: (c5) if r4 s< 0x0 goto pc+4
   R1=ctx(id=0,off=0,imm=0) R2=inv6 R3=inv28
   R4=inv(id=0,umax_value=9223372036854775807,var_off=(0x0;
   0x7fffffffffffffff)) R10=fp0,call_-1 fp-8=mmmmmmmm fp-16=mmmmmmmm
  6: (17) r4 -= 16
  7: (0f) r4 += r10
  8: (b7) r5 = 8
  9: (85) call bpf_getsockopt#57
  10: (b7) r0 = 0
  11: (95) exit

, where R4 obviosly has unbounded max value.

Fix it by checking that reg->smax_value is inside (-BPF_MAX_VAR_OFF;
BPF_MAX_VAR_OFF) range.

reg->smax_value is used instead of reg->umax_value because stack
pointers are calculated using negative offset from fp. This is opposite
to e.g. map access where offset must be non-negative and where
umax_value is used.

Also dedicated verbose logs are added for both min and max bound check
failures to have diagnostics consistent with variable offset handling in
check_map_access().

[1] https://marc.info/?l=linux-netdev&m=155433357510597&w=2

Fixes: 2011fccfb61b ("bpf: Support variable offset stack access from helpers")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d2f3bbff3175..3168f331258e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1833,16 +1833,28 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		if (meta && meta->raw_mode)
 			meta = NULL;
 
+		if (reg->smax_value >= BPF_MAX_VAR_OFF ||
+		    reg->smax_value <= -BPF_MAX_VAR_OFF) {
+			verbose(env, "R%d unbounded indirect variable offset stack access\n",
+				regno);
+			return -EACCES;
+		}
 		min_off = reg->smin_value + reg->off;
-		max_off = reg->umax_value + reg->off;
+		max_off = reg->smax_value + reg->off;
 		err = __check_stack_boundary(env, regno, min_off, access_size,
 					     zero_size_allowed);
-		if (err)
+		if (err) {
+			verbose(env, "R%d min value is outside of stack bound\n",
+				regno);
 			return err;
+		}
 		err = __check_stack_boundary(env, regno, max_off, access_size,
 					     zero_size_allowed);
-		if (err)
+		if (err) {
+			verbose(env, "R%d max value is outside of stack bound\n",
+				regno);
 			return err;
+		}
 	}
 
 	if (meta && meta->raw_mode) {
-- 
2.25.1

