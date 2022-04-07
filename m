Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9C44F775D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiDGHYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238750AbiDGHYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:24:12 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A3DF2F
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:22:13 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2376hV5S007682;
        Thu, 7 Apr 2022 00:22:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=uD3XZhqdfija3vQEYommWogiK0CK6cZudSXFm4jHfg0=;
 b=tGoGS5pRfrPL4xdPcXdXrG1cwQBKB88WyZnNjizYoqScmSHKYYuL3bkMzYuCgP/P0Zph
 wZ4rN46RDuUfvUBA8jD+0jzviPKNz/Irrxz9mP7QQ1gIBRUSMySzzYH4khv3B7JpOwbJ
 FoNf0fPWFk7/PSNv5MxDln/AbkRznXOPmMCcgoPtMq5Hxtn8bUlz5OO8lNqo3ilwh4zZ
 eQbPWHFDMPhhhPp7xy8KGY8EqJHApwmhqYPdbGaLwjsiTpd0VNPzd/gsUjYZf+M+8KFE
 NiZJ7t6fHT1mYuH1qD1zfyMPWMrQ4Yob9iC6unDvb6mhJc7+C256M0KNCLakXmB7AECs yw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6p0jbrmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 00:22:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7sOufB7Ghf8uNIiuwbx0KR9E/rPSwPQV8gfkxfl7Shn9isincXlDCbK6b6njuaZRNhVdQd/ddelCchYPW3JYVLX4MgE75VNLvSixzBp9F45SQnSv2xEohLc5s+oqTrWAWS5LGt6UvLjzOuDiezHKEReC+9tAXxldHUMlwqeandGujxEiYzqV6/khR78Na/OTuNEQJtnkOcHyW3lKzvFwtY0C3pJkW0ljtq2dVcheD8SuJcPMCu8DWC/ewO2IjcWHTjJcpFfBQOLJqt4Gzplty38AmTSCY5ElKQAPwhhwE/zl9MXXFsxHs6ps4UX/b03o5mE/svqaMzIXud/amj+EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uD3XZhqdfija3vQEYommWogiK0CK6cZudSXFm4jHfg0=;
 b=LJ8313SAsv5eT81+0Naj6K/3+8J5X48fa5Ju1griaoecDaS6y6F0FjDkxnCZu9I5+auRxYSmTyUtgWS88n5T5r1xdwADsIOlucd1EPqqBVugQTEWA7u6nFQPJ5A4v/wks9QbBHMvqfjiR6NAYEIkHCCNTgTfYOW4S6KbNZB38I18oXEN7IE5KjuItZh3ttZNH455jXoTadlwaTvUjkcPGBhqInbmO4dCVuWQep9WChXrwLjrm5UYZp5U/1RI+ZSNcV1wvcpflB8bODtDgU00Dm0W/87j7O1OP7vy1WNKXLGK1BH5oB2Df0putGuwCmxonx9eSC6b/0taIA+HONErlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 07:22:01 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf%6]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 07:22:01 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.10 2/5] selftests/cgroup: Fix build on older distros
Date:   Thu,  7 Apr 2022 10:21:32 +0300
Message-Id: <20220407072135.32441-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407072135.32441-1-ovidiu.panait@windriver.com>
References: <20220407072135.32441-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:803:64::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71d57ccf-966c-4e8f-43b0-08da18674ef3
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB337105E6E58496C7680B92DDFEE69@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p45ABSZWrWIk9QOMBeHBxqAY8CR9Sru1GM09S1otcsLDQrovtmRda0Sdt9Xogk8/MEvGpdoGX0+S4qO1liLkC+gDDFMUbqnCxEr/rfOQsC6hc7Ma6hLIn9qmmOO+peA2k+55wo85ETx6P8E+JUYtPVMZCcQE6zKJU8ImxU4CTs2RejFO4rcFbf/Y0JhGnktGAvEwqM8o88fXhyLZO+9SK4egFlVSiFMnxywPVLlxcZPmobtaOrn9qQ46/p1rzv/ENotrUDBdbMt7TlUVjbBNr8vpXaZbbBd9tpgKr0mOEacJbllXjR/AFS7pexHIFkvbGWeZXgFI52UgiETCWE9KpaM2YLIu7W4RsiNdVrE5Dmk6C2Tjz8G+5UJPfQ4N7D/FFMh96KNY4vUak9PY7O7Aw1nsLzSxP9K/+MChj6GnFBrIQ/o12u7nkLSGiHnIyXecUQQk6zaWDm5U3rlZovUZqlEzxKiMcqSIaJ7NvjHZhmtNVYerwXbWxAB/sBOHYBjpGALbCgDK6TUjMlLYo5jAlYp2rcTz3EyHDUU8UZ6iYIus7eoKtLhdhVmhvxN20vAXJZV+WSd9OOx4ysxMtWtHbJ6V3SlZHbsoUsHeF+C6u+P51CNuqCMlHRtedUpSw2dIuIQomkrRvOvU7hFaZLP8LDflPr2ErWG+miIwgQHD5QK/VqKz6Mg4Mpq/oaxdE/zQmCY+QyeMD7p1OyzRkjzTqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(1076003)(66476007)(6512007)(66946007)(8676002)(44832011)(4326008)(38350700002)(38100700002)(5660300002)(6916009)(186003)(26005)(2616005)(316002)(2906002)(36756003)(508600001)(6486002)(6506007)(52116002)(8936002)(83380400001)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MyGMD3gdXx4AwZhkjfvaGbSncaLKnHEIibUoYGSX44QeYBwvm4NqzKLhItz2?=
 =?us-ascii?Q?hE6lVd47eCghupntRAeVH07NQfNuIrIB++ULGOxehpQiRzTnLVSCeOCuH1N5?=
 =?us-ascii?Q?cYjtFGwLqAM1VrTbobGG+HmZd4vBm2oXBuR8/Dp1PcU1hfh2ma5Idh6XcrA0?=
 =?us-ascii?Q?MeBg6g8uh6ok0Hr9UqGY1fnsUPXz85qmc+ykM/HGt3dqpEQFZlMdKagqU5Fz?=
 =?us-ascii?Q?MviIS2erZesMHRr3M4KtDVhnj2jqLrWFAbtE4NHSFRVBgDa/7/zMRBollGQ8?=
 =?us-ascii?Q?DfYkyVKUH5/hlPBjr2ixKWnLD7VmIrLFPCR40H1vy3IPddq7a5K6beeXVEC0?=
 =?us-ascii?Q?1t0Temm6+wCcEm2W3vCBfYK86ARuD+r5H0oZwOgJbwYHFMmYo+wETW9NPH9S?=
 =?us-ascii?Q?2+C+P4X8/KWCwiuQ349GZfshGvVuku2IEmYRw0xfg8s/BZbk6rDDQJrv2fiI?=
 =?us-ascii?Q?wXp4YnZjajFqyMUKCP8uiY0BVgrIY1bA9m45ZEFRZWnDTy5NOoB1E/jZqfbZ?=
 =?us-ascii?Q?RK6tss7qN2QNkVZyW6iW0j4dXNRh1rSAggbrhqSTasPb8lsFTZjUWCqa2vMD?=
 =?us-ascii?Q?QoofoR5UKMN92xV/ssNEf7idlmNVIa2yRuRzTJ21P6ONDJDaVZD+snq8dKxD?=
 =?us-ascii?Q?Hr1LILKmMLBlqxwYJfy6GpiwKookb6OTgR07EjOtGDwsAI05S/hJeuDpDxTg?=
 =?us-ascii?Q?l5rFsz9BK+Ew1DbbAaOwRVv1JVKQ2g8l9Hnd2sXpz/GiOklErlwl9b2fgTia?=
 =?us-ascii?Q?iYKh4kogefgFCcWiyHxawtHQZ38pYlqg1e74qoMCt46ZKl17Ml5I8KRBwEyP?=
 =?us-ascii?Q?dTNOHLwrQilSV4Ows1YXHvsjdJxboPdMRpntuuDW0g6DbLMiL+6Qk4/QrClm?=
 =?us-ascii?Q?fqu9P/ByX2ahEfwZR6n/OjWUz6IKLoqb74INKMUHKdYvf9fHVCCrGS9yRtAa?=
 =?us-ascii?Q?DtmHrxJjjsJpOHyC0DEcZTg/33R+8BlrYVTZY30LzFjZ/G44oqBW9I7XGy86?=
 =?us-ascii?Q?1VN/WONKHse9FYBscqRd1IY4FuI220YUuPGrG5lbY5vcnQZrPFmnUkVinsfC?=
 =?us-ascii?Q?K8ER0kOyplmD7PqmnKnbnbhOSZ5G0xpw67hcuCiTfyJZwI2UF274L7o3/vLp?=
 =?us-ascii?Q?df9zhBnfSGNLTDCtvzKr3hexlvTNQbSo6QOGrHDgnriMuS6FWjQUymuV3KB1?=
 =?us-ascii?Q?OJHnxYG02vzGXEyo67HeBbX8CVPmIb1+3B6zNPhv9fZY0oMitxPvMoLwp/5h?=
 =?us-ascii?Q?Pnnwa66LqYYMSINAuuWmbTQwHkvF5cCfgdTPbbj1Cm0bKKJJMFDQ6om3ulfA?=
 =?us-ascii?Q?3ybJVkOFUzVaX0soYicwmQ5YPee+c5QyrfE+P6yerfro+LOmBoHb19ISy8j2?=
 =?us-ascii?Q?GheyWQoQqD4M1W4WJNj/qWqUQ0X6kXXHI9YxA3iETQOKzlcoNRCc2nZunagX?=
 =?us-ascii?Q?mJE+GzVPfE/PxLlCpS2u/pgM1DWni7o93nT3cRhhwP1qhoOkTFXFr6YGudd/?=
 =?us-ascii?Q?floS+CtS23o9aFWGEStYePh7vjcA1r+XBH4ZRJwBWnaePrj9iepgPl6s1Aph?=
 =?us-ascii?Q?b3N2jhh9mH9pKch4awfvISywSyF4Xcuz+uUBLoU6bbRzWyQtex8h0LhrmvG1?=
 =?us-ascii?Q?UmtJgFIAwbupq0q3D79I/B9/0b5Shr0G03Wkm2mLp+0PYe4zR0NSXrT3Uusf?=
 =?us-ascii?Q?TWLW2mkKIrtPHcl1Xgg+gXvRWkU9pPq+y1U1KZRrNoAQFOf1BuU3doxMMpkT?=
 =?us-ascii?Q?qEdcd4KyUhSXvpUv7fa8TjRBAHLEe5I=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d57ccf-966c-4e8f-43b0-08da18674ef3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:22:01.3797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KE5FembtZsBfgjXlWDQeAPNI7bRI2E498j9PoQt3ajkHONQVznQLrVYHWJY33FtwtUBU+GCQJBSlePMLkBgnBZnA975ljiDtqjOo/AyWOSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-Proofpoint-ORIG-GUID: UHSqd0VBMOIMFEAx_-z3V9rEtPT-Ffbz
X-Proofpoint-GUID: UHSqd0VBMOIMFEAx_-z3V9rEtPT-Ffbz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=627 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204070036
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sachin Sant <sachinp@linux.vnet.ibm.com>

commit c2e46f6b3e3551558d44c4dc518b9667cb0d5f8b upstream.

On older distros struct clone_args does not have a cgroup member,
leading to build errors:

 cgroup_util.c: In function 'clone_into_cgroup':
 cgroup_util.c:343:4: error: 'struct clone_args' has no member named 'cgroup'
 cgroup_util.c:346:33: error: invalid application of 'sizeof' to incomplete
  type 'struct clone_args'

But the selftests already have a locally defined version of the
structure which is up to date, called __clone_args.

So use __clone_args which fixes the error.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sachin Sant <sachinp@linux.vnet.ibm.com>>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 05853b0b8831..027014662fb2 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -337,13 +337,13 @@ pid_t clone_into_cgroup(int cgroup_fd)
 #ifdef CLONE_ARGS_SIZE_VER2
 	pid_t pid;
 
-	struct clone_args args = {
+	struct __clone_args args = {
 		.flags = CLONE_INTO_CGROUP,
 		.exit_signal = SIGCHLD,
 		.cgroup = cgroup_fd,
 	};
 
-	pid = sys_clone3(&args, sizeof(struct clone_args));
+	pid = sys_clone3(&args, sizeof(struct __clone_args));
 	/*
 	 * Verify that this is a genuine test failure:
 	 * ENOSYS -> clone3() not available
-- 
2.25.1

