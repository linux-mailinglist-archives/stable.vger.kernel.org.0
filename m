Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885874F775F
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241787AbiDGHYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241717AbiDGHYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:24:19 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9AE3A5
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:22:20 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23776tSt022208;
        Thu, 7 Apr 2022 07:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=+qThbLw8bPq3+JItarcxVUI39Xt281yB54s48HuBMck=;
 b=g2lPxdoqTcRrsz7g+FITfQcylQe5Hv/5WErn0GcDptXy6dzOGaOwFCHQx9dSRsWH31NP
 ZHcWPVzEKeR0WQ/83gIoyCc2LIURH1gTPXFdsl6ZcGff4eAtflTOvFSg/bvHZVWRHp4/
 RZKUZO0UFzREZA6+77BxHSImI3X4Bo+lUfVPEU94u3Q2DT7osgexwBy7ii5RH1OaGe87
 /HWlvd1Tf6Q68NYBAMduJYWILREx+OUV/4c8FGfIrNaXN8y/JGQq1iNWa905HH6SHjvM
 tB7wIcRHL+9OUcRFgjHte+YdGSSD6rC6fwhZ7WHkL5EyZuuHmTgRDculFKI6v+OMIyX4 PQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6bq243fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 07:22:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wn6NB+x/RHhY/AZ7mvuETjwUEZsm7C+Jh7gyLd9NY2SOQlzTiRXZcZ5rmSluBFo02Fe2JwSoKf4uip6y1farqAbI5ktd16YS1INYnrZBzUXOxHjOZBZVQgJN4/rlJ1l4x2wh2reBuwDRe/gIyQlkzNINsYJr1wKYsxe8FWXqFzaF6Kg/rroGvDnCq0Dh9i+bkPz1Aac6e9ZUbgz+7ZiZapO5MN6K7aqhyx4k7tEICJBHUBUaoPdqPkQDrNN2PW59ZdK3HHzvQChb2K1nsaFsiqAQEW5itQqXLo77Ko94FPRGbOifNupQyz9EuMUd8JAfLQktczVk5VtLc1834CM6tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qThbLw8bPq3+JItarcxVUI39Xt281yB54s48HuBMck=;
 b=Vmxjc880YnlS6MT+OgWG/4KdME1Pyn4tAz5/PNfLmOxnTACftoHP8PQsdlDQFY6ippLy6h43vyzNBlDvOBiM7FrVMw37HHO/8nX1iHBtzbyV9VvU4cSUeE5V3+K+hmCd8SA649S1V6IyBtE5HXVRa7llwZfBvRXkPVGqR/3uewW3jjDCGzBjf2Oml0nM4nwHZMGWB5y+eeqM+WyHQp8j25v/gASpE3vcTRzVkts2yGehyD+TFJkJy0Y5O8ZH7AZHQtfkuXh96vaE5N1IXSAs2YCvGz4nrHr31C4JGLHACCtQ+lcpOmdebO3gHjeydgJjzhCmtLt5bJwfDJzA08L5GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 07:22:14 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf%6]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 07:22:13 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.10 5/5] selftests: cgroup: Test open-time cgroup namespace usage for migration checks
Date:   Thu,  7 Apr 2022 10:21:35 +0300
Message-Id: <20220407072135.32441-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407072135.32441-1-ovidiu.panait@windriver.com>
References: <20220407072135.32441-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:803:64::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d514fb39-7c5a-4682-e01b-08da186752aa
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3371901707489A429DA548D5FEE69@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Spmnf1VOiIkZqggZnQ4BfGLTWyIQmisow4Cw4RnfZKUYJ0IGKwlRRhoHE6b763TJOWuHsj04fn2UMzs1PFF07OO0PZ+/eI6v0FzgsjLbboXlyzafiPIOSJZCIfhlaZUFs0keo+KYOz4pUGQ9iWtwFLWRHX6k9CUYmoJAOQB35Q0RO2Dxi1DypgRidW5EPELUqARrhax2BV5BHDuPspeqvUaDI00Zsvq79NQz1qA4cRjrESG+w3aNRMPb9XIcQOqvrudIRWJvx2/Awez4zj/rv/6mdXMyBodgVdPPPV4yApAepMvHeAqcNc9cIAyGl+c+GrnB3IWoh3bjDLMu8j2/WN3QLrH67K/VNoMdvlP8Mh4f6kWSx4fxwOaeJps8CflFSCANT5Ogh9dtFJeGcTEt834tHD+p5YjToAuJ3YCu1QuGJ8Bg9TOzCnlDssr1yn0w9CWgOAdGkTRryZ/hEqWL0Eg4KDGdCw/JGXly5u6Emfj7GAgeCp3p8vNSqQ5ksQ64Zajx3dbtl9ug2IaptN3PGdrKtJBEP+AdEYG2xaCvbXj82Md0V7rQUM1btuDBxAC3npkta9SkN11opbrPJSxmzVBnaSnucsPT774EE6Vy7FxGqVgooVq/ErmRSlXDeszo2CjpqR4YwVgTO7qc5vMfmtfLKrsb0Bb5lKiQQruCAAmxz5O9x5ebbE5+l9FHOuGuGAFLjLsmV2k3fmNVS5nJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(1076003)(66476007)(6512007)(66946007)(8676002)(44832011)(4326008)(38350700002)(38100700002)(5660300002)(6916009)(186003)(26005)(2616005)(316002)(2906002)(36756003)(508600001)(6486002)(6506007)(52116002)(8936002)(83380400001)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXVDczA4Qm9jY0RuanR4WHU1NG16Y1BtMU5DK3ZiV0swZU5iOFR6OWRRZk95?=
 =?utf-8?B?cldKWWdxY1dNeFNseU96U3ZNenA0aTUzWjBYc3lxNWhnMDV1NU1YTTF4RGlS?=
 =?utf-8?B?eDR3eU1xcWczZ1VQQmRhZCtaeklyYmhkNGVUcXpzbDc1cUdxNk9YejBJRENS?=
 =?utf-8?B?R2FEVlBJQmpzVTBGdmZqc3RaTHpRZW5CUlp6akNnbmVEWHMzWHdxeEUvWEdR?=
 =?utf-8?B?d29HdU5sd2tCSnJ5bnVaRnJpQTVSM294RGdjMDBuUm9ENHZFemJjbEpVaUJt?=
 =?utf-8?B?cGRucjBTand4T2NPcXBDSmVOOFNKdGxUUEl5dVRNZmRwdXY1SEpweWpLajh3?=
 =?utf-8?B?d3hMS1hzaGxvQ01kNkIyNGZFRUQ5ajllY1l4TkdjVXczWDR1cFRqZ29tWDBS?=
 =?utf-8?B?eVpyaUwzOEtnQ1F3QTV1Tko3TEllWndyR1FCZFZ1YWRKZWNrRkZjMnZHY1Ur?=
 =?utf-8?B?Uk9kZlNmdU1wRG50R1VWODVqeHdQZVJlaXdnTHdaSk1BSHhiS0ViamxjVkc2?=
 =?utf-8?B?K0J0dWJodUdJS1NubVdqSnhZVDVFTTU1Z29yZC9VcVRzeUxSTllQWEVEc3Rq?=
 =?utf-8?B?TFYxZHhnV0VnWWlxbjJVaVorTTk0eFgvTUlhSlpEZ045WGVxUTRla0Y1MnZy?=
 =?utf-8?B?alJ1ZGRmVUJHeGtrRlJEUlMxSXRDam04K1lmbEpPZXZaWnpsekk5SzdiaFF1?=
 =?utf-8?B?a2FsUkxleDRFd0VGWDR4V2Iyb3BEVlIwQXd2MHBTeFJETlpBT0dsMTN4M2Jo?=
 =?utf-8?B?bkkrWmZPZ2QzNkNLRWFidXJKbXdqeHZaRERYaW1KOGNaMkxqTWp4NjlSeUZM?=
 =?utf-8?B?Z2QzTlg3cytsUm93Mk56Zmd0cC8xbERabXRrYjdsMmF1ZE15Mzg3V2xuKzJo?=
 =?utf-8?B?alphU2hXaTNRQW02c0ovbTZZUzZqV0h3UW4yK29GeHBxbitzUXVNRE1JanZD?=
 =?utf-8?B?WWkybjJnWGI0YW92SnROSUlZcllnSjcxYnNJYzNUeVpqVDVQRUp0cFZwVHJn?=
 =?utf-8?B?NDVFRW41UHo4QWwySUErWGk0bU12V1luM1NWZFhEd1NocTQ2V0RzZkNsb2Vw?=
 =?utf-8?B?Vk1Md0pCbWVCTU5JVUg1bFVyRXlLSjhLRml6aEx4YThWNXUvYWlxVVpwVTRF?=
 =?utf-8?B?N29aZDltWlEzWm9oMXlUQkRRUUwwNHBBaGlycER5MTVQZFUxQzRqRFIwd1NE?=
 =?utf-8?B?L1VaZmgya1EwOWE1cElyNDM5NGU3MUEvUjJrZHlkYzRjUmEwRFdpM0RQY056?=
 =?utf-8?B?STFLSVlFVWxDbjc3Wk8vTnBtMzJMRmJpT3gxRnk1Y2diTGU3RzIzNWxaWnRP?=
 =?utf-8?B?VUUzSlBqcVhaL3h6bG51TThZWmg0QmdTVnBZTkdKWVBpMnV6TFpwNzZQbkVK?=
 =?utf-8?B?bTJZZFJ6VkFRRUtQOU94NU55RUhUdTBFbkhISEVVN2JJT0VFdmNVQWhkL1BE?=
 =?utf-8?B?RnNiSVcwWVE5cTBMWk9RamtOOTMxL3Uxemg0QW5nTEhUcXZwaW5DMXhYY1g0?=
 =?utf-8?B?dVNKRmZVRm93a0Y5SVIvZkRVbG53c2EyaWk2YmRPWXI5b1pMNjB1eHdFSnU2?=
 =?utf-8?B?TzRYb2cxZUdiOFlJd1JyQUlCSzNSNFM1UHpodkFSRFpzNm10dUZ4WjVLTTBk?=
 =?utf-8?B?djhjUURLbWNrY2JiSmhsbUhZcWdtcGEzL3ZXWlQ1WHUycTZmenFrRmh4WTVW?=
 =?utf-8?B?VlkwaVY2OUJubTVIeVJ4NHlza2lLeHluWFljRWlsNXZBMFg1ZVcxV0p0REpV?=
 =?utf-8?B?YnJpMVcrcTlWc0t3THp0ZWpEZXBQN3ZDc0grOGU3dWNPYStPL21ENjdJRjVq?=
 =?utf-8?B?QWs1WlRNYkZFVklpNTB4NHZIa1lRRlN3d0JvbmNENTRhR2RIOEY5SGNxUkFB?=
 =?utf-8?B?YmRMaVhiYXZiZm5UaWQ3ZWYrbFFrNFoxSFBvaUgrT3FDQXJyNkp6cFZJemFK?=
 =?utf-8?B?ZDhQR1o0Z1UzY2o5RS9zRjFaZjhCRENiVmkzaGtQNWFPRDNNUEEvSGxCRWt1?=
 =?utf-8?B?aEhQeTBrUmUySm8yeWFCa01TR1RxRkRGQXFVVG92MjZCSFBmUlk5UEVVbURh?=
 =?utf-8?B?VUtKYzQ2VVNyb1V4cEZsTmdTRUZpVzRjY3BvNUR5VklrSVVMK2VqS2NIL2h3?=
 =?utf-8?B?em9EYm5MWVBWRUV4NnRYcDQydVVNdzZkanNKanNzSEdjMzJBRjZnVGJLdUtl?=
 =?utf-8?B?S1lPL3ltQ3pVYWgwaHo4L1BuR052TitwY05xODByM0dNaHQ4UGZYbjVObU1i?=
 =?utf-8?B?QnplaTA0ZGNvd21Qc25rUUNNUExOZ0ZEM3NSRHI3WHBOQ08zdkE0SktjMEVt?=
 =?utf-8?B?VEVmbkF0TFBWZXZXRWQ1WHNhZnA4MzR6LzRGRUUvbkswejd5TUtQdWNVS0Q5?=
 =?utf-8?Q?2rhaZ4P3nerUtlrg=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d514fb39-7c5a-4682-e01b-08da186752aa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:22:07.5849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l7s+iZuviIvClOMNbt6I0CMqKHVVnRlVvtCweGZcKcGvZBjnJdqTt4EhQJNMI0OLBlrHYTsxBcnbxIfgIsYF7yWalLa6FLosP+FRbahyvTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-Proofpoint-GUID: eqQF_FDxYqpzsdAR4XgpqQjow6YuvBft
X-Proofpoint-ORIG-GUID: eqQF_FDxYqpzsdAR4XgpqQjow6YuvBft
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0 mlxlogscore=956
 priorityscore=1501 malwarescore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070036
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

From: Tejun Heo <tj@kernel.org>

commit bf35a7879f1dfb0d050fe779168bcf25c7de66f5 upstream.

When a task is writing to an fd opened by a different task, the perm check
should use the cgroup namespace of the latter task. Add a test for it.

Tested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/cgroup/test_core.c | 97 ++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 01b766506973..600123503063 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -1,11 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#define _GNU_SOURCE
 #include <linux/limits.h>
+#include <linux/sched.h>
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <sched.h>
 #include <stdio.h>
 #include <errno.h>
 #include <signal.h>
@@ -741,6 +744,99 @@ static int test_cgcore_lesser_euid_open(const char *root)
 	return ret;
 }
 
+struct lesser_ns_open_thread_arg {
+	const char	*path;
+	int		fd;
+	int		err;
+};
+
+static int lesser_ns_open_thread_fn(void *arg)
+{
+	struct lesser_ns_open_thread_arg *targ = arg;
+
+	targ->fd = open(targ->path, O_RDWR);
+	targ->err = errno;
+	return 0;
+}
+
+/*
+ * cgroup migration permission check should be performed based on the cgroup
+ * namespace at the time of open instead of write.
+ */
+static int test_cgcore_lesser_ns_open(const char *root)
+{
+	static char stack[65536];
+	const uid_t test_euid = 65534;	/* usually nobody, any !root is fine */
+	int ret = KSFT_FAIL;
+	char *cg_test_a = NULL, *cg_test_b = NULL;
+	char *cg_test_a_procs = NULL, *cg_test_b_procs = NULL;
+	int cg_test_b_procs_fd = -1;
+	struct lesser_ns_open_thread_arg targ = { .fd = -1 };
+	pid_t pid;
+	int status;
+
+	cg_test_a = cg_name(root, "cg_test_a");
+	cg_test_b = cg_name(root, "cg_test_b");
+
+	if (!cg_test_a || !cg_test_b)
+		goto cleanup;
+
+	cg_test_a_procs = cg_name(cg_test_a, "cgroup.procs");
+	cg_test_b_procs = cg_name(cg_test_b, "cgroup.procs");
+
+	if (!cg_test_a_procs || !cg_test_b_procs)
+		goto cleanup;
+
+	if (cg_create(cg_test_a) || cg_create(cg_test_b))
+		goto cleanup;
+
+	if (cg_enter_current(cg_test_b))
+		goto cleanup;
+
+	if (chown(cg_test_a_procs, test_euid, -1) ||
+	    chown(cg_test_b_procs, test_euid, -1))
+		goto cleanup;
+
+	targ.path = cg_test_b_procs;
+	pid = clone(lesser_ns_open_thread_fn, stack + sizeof(stack),
+		    CLONE_NEWCGROUP | CLONE_FILES | CLONE_VM | SIGCHLD,
+		    &targ);
+	if (pid < 0)
+		goto cleanup;
+
+	if (waitpid(pid, &status, 0) < 0)
+		goto cleanup;
+
+	if (!WIFEXITED(status))
+		goto cleanup;
+
+	cg_test_b_procs_fd = targ.fd;
+	if (cg_test_b_procs_fd < 0)
+		goto cleanup;
+
+	if (cg_enter_current(cg_test_a))
+		goto cleanup;
+
+	if ((status = write(cg_test_b_procs_fd, "0", 1)) >= 0 || errno != ENOENT)
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_enter_current(root);
+	if (cg_test_b_procs_fd >= 0)
+		close(cg_test_b_procs_fd);
+	if (cg_test_b)
+		cg_destroy(cg_test_b);
+	if (cg_test_a)
+		cg_destroy(cg_test_a);
+	free(cg_test_b_procs);
+	free(cg_test_a_procs);
+	free(cg_test_b);
+	free(cg_test_a);
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct corecg_test {
 	int (*fn)(const char *root);
@@ -757,6 +853,7 @@ struct corecg_test {
 	T(test_cgcore_thread_migration),
 	T(test_cgcore_destroy),
 	T(test_cgcore_lesser_euid_open),
+	T(test_cgcore_lesser_ns_open),
 };
 #undef T
 
-- 
2.25.1

