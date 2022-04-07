Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CD94F774D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241739AbiDGHWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241678AbiDGHWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:22:05 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A5490FC7
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:20:04 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2376XnFc029443
        for <stable@vger.kernel.org>; Thu, 7 Apr 2022 07:20:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=+qThbLw8bPq3+JItarcxVUI39Xt281yB54s48HuBMck=;
 b=YKHmFx8quTm1e8L5mkSnyRGuWclmQa4+8T5/KgXLG5dAyCb51puNSaglVD4/Epvn5Jmg
 CGDrCiedUMpH3bsrL2fKD7fOxPQFqVQBbJjmRLKbT2KFOnWYg9NH5HR68/Py9r5krFK4
 6xc4K11rtYsWOoFOWJdjVbppyh471qkZ7XBypDNS1k3Jz5jlvJDI9VF97BC53wuKY+NB
 R2GfQn3qHgBM8UlU4l6OllbR2snteVmxT7/9MWMy+ZSOu35nq9nuy76xRPdWtYFuO1AS
 tvwVhXEzwssb35jneVKPMKT3r3YHBOEMeSo44aaI52rIn6zXCs/+2h+llTJIG2zFx223 hg== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6df8v1re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 07:20:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDIfdwCaNQW+sGVmVGK07t1C4WrIlWkoKDhWHh9F4jz0HpHiPD9AJ4Hy/yUvfiFOPSjOvJPQPzzHLMhl/BYgEnJ1dq6ybRAWGkuDwJpD5srYvc+vjcPrjYIFBxs69FqXUfjOq7IAKRMJzYxYNRGArx7lQq57TD/8n9+UL+ajLmOfgLKHqx9ftz/fbyBg6N+cy89C2Zne9cQGHpcZCfMx9MzMyRKkmcdSTkXxhT0dfteMjN/wno9qLPHsBPrYEG7pyFlkMGlwm9UeoKaCyuyJ5/9lF4xwa2LjNcUoiCJjE7/cHHWPPOWuxaI7rLvak3Qf3ZygN88WFOvdr8DazDGiOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qThbLw8bPq3+JItarcxVUI39Xt281yB54s48HuBMck=;
 b=CR+lFVrFZ8/qC500L0jZxjG9YpIjGxVPunwLamedAp8/dewecYsdCMkcpNWw1apw9UAUZW20YZMvZZQLWqWXlRDxK/4EOuwvk/le4pwRKAi4lQ7rJJPTy8KsFxByhAnoZJwtwyhb4cnPLnKx0oKs8U6veeTBHwGMoY30tXnzDHLZydt43Sd/mD2a6nqeu2ZYjLonKg99ixri/2paaBldKB8azQCb781usasIiXQZGZ21plUw47NK2ZH5RbM5pblQi3cg4jJMl5Qc2oBNqu+am6BT7Pz6Lj2qDhISVgiyfEHmLhnIjIBr863EhLv2150ZSfaaUmXh1xrZdbWGkJmDxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 07:20:01 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf%6]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 07:20:01 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 3/3] selftests: cgroup: Test open-time cgroup namespace usage for migration checks
Date:   Thu,  7 Apr 2022 10:19:01 +0300
Message-Id: <20220407071901.32350-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407071901.32350-1-ovidiu.panait@windriver.com>
References: <20220407071901.32350-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P194CA0041.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56eb6368-3e45-454d-4adb-08da18670782
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB33711CD2C2DF99B34D1879A5FEE69@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HIdxPskYswHeFbI/mXpAHO6Jxja1jLUASyRpVyafCRNfXtZF+H0VbbivqdIKJ2SyZEHfAw9p/93l9XtNjLwPfutFrfCx4QgpGOtWh1lhwWq5+E+RaqzMcEOpNXegUOSpwpaALgIs2Lld/7+m6Wemvo5KOaLJRah5GXIMhHV2+pE6D8YzESFinRcmoQrzf6TXTxPxJJNPi2pfy4WhSIv2euB5JXA4wr4pvv6SOJNeAxMhPGpXMn6NM4xGg840dSdzBsV91R1Ohuyegb7ff7rE1adw38ETbk+CxPk9JH6GF7eJ9WKXM9d/CPJyibOLXu/T3KJQUPq9GnT1TAF/u6LJacvkqDlo7a6mwwAzm1PgjKRLvo5piC5feOOKDBGuYfq3hmJXIq3o0/jybriDj81daX2DAawkH7104Ij3QYtLCUpATi1gSVrqiJAK/GHkYkN4EurC5H8yvyvbQIKG7xVJF4det8M9+N4k7am6zZV73nBwNfn8q1ockI3GSbJzt0WvVSDZgFmQgm24ouGLfSWlPEDvVG5CMYuFihI8n/uaq2odLfTNZX8L6yF5kvpTIplOuEqoNDAom/x772knjcX8Exhv5+jrlIJVFnmaJI+hmSIHOBzGfYcdQsIcXbA8VtGWjtH/Btu1HLw84DCwDJw3UUXTKZs7QWa/WiyuouJeL66bTzLCfy8krLD2Qf+NnNL8+nBWZnL61Is6/lIfm2R9iA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(1076003)(66476007)(6512007)(66946007)(8676002)(44832011)(38350700002)(38100700002)(5660300002)(6916009)(186003)(26005)(2616005)(316002)(2906002)(36756003)(508600001)(6486002)(6506007)(52116002)(8936002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THRvbUlweUdCeUNNeXltbVVLQW9NQjNpWUttQTRIY3B0TDQyM1pIekVSMlpR?=
 =?utf-8?B?UXF5Q0l0RHEvRC80eDk3bjFJc29HbGRXNXN2cDBkSktob0hxc2VsMXpDVlBL?=
 =?utf-8?B?N0tMUnlJS1hBaHBpQ1gydEJqWXdUVC8wUjViU3NZNG1KMWs4eEFVb0FPNmRF?=
 =?utf-8?B?dFMySzNkUWFLNVJKME1mejFQR3R2TkFGNnh6U2o2WStFbURSc21QS2wrTDgx?=
 =?utf-8?B?VzlZYnl4RFBVT2N6UnZTb0xWRkJOOWZXNWhGZUlnYjVsZGozamNUcUV4ZHM1?=
 =?utf-8?B?SmRMUG1kekdXb2M1SC9GbnZKY3h3MXBoQ2ZGbC94ZGdjNDNqOXZrM1lQeUNK?=
 =?utf-8?B?NnVzU1BFbGtBbzJPcFduMmRvYzBMd1ZReFBmS3c0WVpiTjFsa1F5bjNyS1lC?=
 =?utf-8?B?T2NtVnJZaGVTOEVqVXB2NzRka0xqUlBtWWxDdlBYZzcvaU4vMUl4YmtUa3hl?=
 =?utf-8?B?R25nd3dkWTJIbWsydXQrTEZ0bTVtc2NOUjdCcWdjWW4vRzd3WTRRVk5Od1Bw?=
 =?utf-8?B?NGpSY2pqTnhpWFFnMWJ2dGlhRExEQXJ4NDBJL2U2WnMra2p4TThTdWpGeXFX?=
 =?utf-8?B?T3cxT0JoTnhVNzFjTkxCTlIzV29wSWoybTBjbXBSQk9qT3FOMzBRTWE5S1ZL?=
 =?utf-8?B?aklieXpnbGFFS3BQenhwaG5ZM0hucy8xSlBWcTExVHhYMHRLbU1ERHU4UjVU?=
 =?utf-8?B?eXk2TXpzRGozV21tT3pDQ0ZoTlRNSytqUkkvTkhGWmJhQ2VEclNkbVBnZlE1?=
 =?utf-8?B?RWkxc2N4MHhiUGFEcjdWdlo0cnRFbEpmUmRSS0NxbjdXZmdrMFdBNCtsRjZU?=
 =?utf-8?B?SlQxeWxtR3RFbTRWWDNCVDYwdGtNY0lZcFk4aGM2eS9nSmZ4M01mdVpWRGxo?=
 =?utf-8?B?MjkyUW5BUm40WDhjeEphanhtK0N1Wm9ybUZLVzNxTEY5YUN5dHZoYjdoYzJU?=
 =?utf-8?B?UXRUMit6Sm9rOWNnY2E3WE1KUTdaTkVGWFFWT0kvcVF5b0ZSTE1NT0tkeEtC?=
 =?utf-8?B?VTV0V2pka1Z6VDkvZXBJUXZpVFpXdDgvZEJXejU1YU9aUEdoaFNsL2U2Unl5?=
 =?utf-8?B?M09Da0RtUUwwYXJ3YWl2QzB5NWtMWk1CMDc1UnljSjdlaDBqZWU5VHZLMFQ1?=
 =?utf-8?B?bFBVd0R4Q0FHVHBrL1U1bXErd24yTFpUY2xxMFN4ZC9aRFNLQjlPZVdjVnlP?=
 =?utf-8?B?a0lRaGFLY09kcHhFYzNhQjNNdWdKVGRVbkdWREUxcTRBY0xub2tlZ05xNlBp?=
 =?utf-8?B?QkNhaFRBcEtxVUszTnlkRzdnbGpkeGYwODJ6TlZQSFJ1VnB5bDVoV1M5SnN3?=
 =?utf-8?B?dlYvR241bGNHL2Y5cEJqWndUbVR5ZmlPT29tMEpwTFE5c3NXTTMvZ0h5Z0tu?=
 =?utf-8?B?Q01nM1lKUkE0Y0J4bzhsLzBmdlJDM0hrTHhyWVg0Vi9oVjlqVVhkZkxYeDhM?=
 =?utf-8?B?djFzcGUxSUNYT3NFTld3UXFaMFVqcUpYTkhTL0s4cDFBcldKMFlVVTZEMUVR?=
 =?utf-8?B?c3dIQm96K3dyamtMSWpOZE5KVE5vOWM1UGpTVmYzSTBiWmdKd3JBLzlyRlpO?=
 =?utf-8?B?a3pkREhsYlYrTCtVR1Z0SFFsaVRQMHVVbmlWRitZRjJFS2V2WVJ4dzRVQWNL?=
 =?utf-8?B?RUFlZHpueWdnYUJkSDJmMFIyeUV4OWR1dURvWjFYaVg1RWtnM1lrbXFMZk5h?=
 =?utf-8?B?V2JHNy9GdEJWZ0Z5Z3hEa21LT2tyN2ZQWFN5Z2VPcDFvMW4vc1BQbHl2czFT?=
 =?utf-8?B?MGVBWmpjNXpubUhIbmg4Vm1TWEJDM2pxU2MrbStTWjJFNmhDWEFjbnYrakRm?=
 =?utf-8?B?NHIyZzVLeDNaVUtTL2F6STNZdkR6VDlmWUt5aDdRM2s3YVVFam12VHNzTWNx?=
 =?utf-8?B?azdWU0d1MXcvMWhqVitVL3FGT3hJSGV0MWYvMXByRUZzOXViVmQ3UFlheVVM?=
 =?utf-8?B?Q1pXUVJadzJidFZ3T25sa2ZTako4c3dxZHFUaUNpelhzd0E5Y3h4OGpUcmtE?=
 =?utf-8?B?K1owSmMzQXBnMHVjUW0wU1FzYzd2NjE5Ym5peEVRM1ppYVBnTlRJSVE1NjRh?=
 =?utf-8?B?SmxBZC9yajZocTcrVlBnNGNhcDlOYUQzYml5RVpOTlF4RHFxaURSeWMzL2Ja?=
 =?utf-8?B?Q0p4S3dITG96cEpGSk9vVnlqUXU3SWtyeCtLcVdnMWltMlpaZ1FIWGpiNHVu?=
 =?utf-8?B?cEtvSEZNUnRwNlI5M3RHSVRpbUhNWUZjTnRBMlgwTklKc0hvNGVuR2N3aERj?=
 =?utf-8?B?aW93aHpMRlNVNDVqbVQzd29oOUN6ZlhrdkhZVjM0TVh1cVBGeVZkWGVpdFAz?=
 =?utf-8?B?YVJpUzBrc25MeXliWXNJUkxrRC9ocXJ0MEdYWTBpdlhrVkt0ckpQSGFWUHI1?=
 =?utf-8?Q?iW8wBlQjK/S+bdsE=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56eb6368-3e45-454d-4adb-08da18670782
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:20:01.5835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hChlV/OYcM5BrTDwMynOnXZYalsvbKr1qW+rrXogYS+Rhf2Tf70U1mOHq3T9pYreo094ViBmR2HuNqRxEdlTlKcCfzA6yTup4VcNIatNamM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-Proofpoint-GUID: 3gp0Y56GraRMi3a-aEKN3u-A84nQTELT
X-Proofpoint-ORIG-GUID: 3gp0Y56GraRMi3a-aEKN3u-A84nQTELT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=953 classifier=spam adjust=0 reason=mlx
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

