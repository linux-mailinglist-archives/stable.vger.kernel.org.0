Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB88500950
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241460AbiDNJJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241171AbiDNJJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:09:58 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22D66D962
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:07:33 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8YR8b004932;
        Thu, 14 Apr 2022 02:07:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=C1X8PTZ/GQro3LpBk2bLzkaA3Z18hUG5W60tHzp8Ngs=;
 b=QARlTmhqPzT8MnPG+9Jp+n75hjHPCj2G0Y/nB7gn9JzqNx9UAuKb2qxsue/kP5fRAvI3
 b39hk6TSEn5JaLmGpEgQ6+OIB1k8tDdLOy6KeCVGSnGVeaBzI4tL3+q/Wjf0rRHo2Fz2
 j/TNsPKtPQqY95tOIWpYcr46aKNPNTJje967y86m8iYAbQJLmpFj47+TquiabdgPFmzj
 Fl47QfpmU4V3wHFUSgk5OMv8CzYUyfjt0R0QkYT36YQyKEmnpTrOwNrGiKewUswTIJLe
 TnETvURUFz4rc91yCIoyqZUfEHZ1JlnfUi6CU9tXoh6jDSGd9rS3epXSqHP4fmHHyZfg mg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfurtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 02:07:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ajcsg0hRNqyWtT3Phbn9BL6ASKvvs5vLZ/RnCDG4okv9wmpfiROysy+O+O5cIWMHlnbZ0lP06VS7wwYLl7rd+GBgdQns2rckHS7t+/L31GV/7wQThbmt6cr6sq5qJI3D/X0x2mO3/jpRyX9VuKmunELF8D6lPlsDLRX/A8wzW6Z481FozR0G5fCEZHIF1Vm5HKD6johNODiG8RE6oCa6oY+QNYB5ZaIF3tvxQyAK/goUksC1cSVXWX6pxp5yOglsV6EYTTZsU72yzFlDj12iHf0N87S1BIP7jO5PH5ug25b8SZnsAAixHtEoYKw6P47lPGPbb7GNb8E3PU94MeItww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1X8PTZ/GQro3LpBk2bLzkaA3Z18hUG5W60tHzp8Ngs=;
 b=HLgUXqAsYUspa0VMKe5R6Cos8NeJ6oejtMy21JxivEKD4meVoHZMWXKxejNfdu9IbXZwt2tn1gv80WvraUm9Ts3HQCRdulNIylu01E9YXp19tUDRIKDs72Q5H5lE0WreX85UgCX5UDDSFswe1hNkYqqoO3v0BY9mhGi09i2gO+VYfrhStZuJt63AX/h7/A0Lo0/TyVjWLzFKvFLmv1nmnqYNOzQ2z7uUHxaWqMZ2IJD2Nm72eBhYeyPyvhx2qmgEtNao7pXK2Vww/NO+QCrrlgs6hWM5jG3nnishMqdbKudxr/vRdG4JcLBqZ7tuDoV+9FdGsi0ylPogwxU3jYxhPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BY5PR11MB4356.namprd11.prod.outlook.com (2603:10b6:a03:1bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 09:07:27 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:07:27 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.19 6/6] selftests: cgroup: Test open-time cgroup namespace usage for migration checks
Date:   Thu, 14 Apr 2022 12:07:00 +0300
Message-Id: <20220414090700.2729576-7-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
References: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0263.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cba8e59-d50c-43c2-24b5-08da1df6328e
X-MS-TrafficTypeDiagnostic: BY5PR11MB4356:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4356B0D891E6B8FA19EB6AD2FEEF9@BY5PR11MB4356.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1cpsRkIWxWp8X6pHNJaTFPS4rNld1eG//r+0jbLK058CHRb9PSDQON0DtMCb9sdnLB4A4QAbCeVUHPHnzhAfhJBXlYKNiCj0Uzn82ln5qM3I5bxWXod4QljQZ54cqDcz9XrZ2eaLO5rrJnd18JUE1jaY/wkg3g5PNJeJ21hW0FWX796B9ulsWx5zszOTnLibgWQNZqyGsNi8yGD9YcDL+xxKyrfum7okJ7Nt5waOFamHaXi00RKVg+oAjp+w1MHkxN2a0K4jtnHer2g88WVqHnK85BDrA7I9sdEROm/oW4P3rGMe3vPOCWVECvuXIlgRjRR1t/df//KwaqfytiEDoJEijup5wPkiDrOATYIJzaopXd3lbqNru2mTmyg2PtD5L+CfEuz61ZZO8HjXg8GWJs/gCueZT52gwTIRzacPNwrcvGAmphwl8H8+1wIMs+vc8+lM0INWDCoKiKf12nQrH9R8vPPIv0wJXTFrKgrqffeYaB1+1sLVtUuROuXGO2dZeuYMVEFCBE9Y80x0cJGmh4Kv7QnfdytubN81UmkP6s6abJZGyZovW9YQSIc27yVzs8yLgVisZFFo6XZh/FsEAGrCn5r2Sz9bhmkGFMuXVTI1OXXaAxWaUw8yU35em4R2Vqo9Lg8zjAmpEH+t+26tEmH1DFMaoy/QjlNtlVDPzvZUtluw0omLPLjFFfL5rCSiFd2G+JjBaJj9t9pta2sVCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(5660300002)(52116002)(1076003)(186003)(8936002)(6666004)(26005)(36756003)(2616005)(6506007)(6512007)(508600001)(44832011)(316002)(2906002)(6486002)(66556008)(66946007)(66476007)(38350700002)(38100700002)(8676002)(83380400001)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzJ2bWZ6RytxbGZDTkw2V1A4cGpEUXAzUmd6Uk5hOG9KU0p2RndwZXNiblh3?=
 =?utf-8?B?R2tHTFdmYXlUczM4bWRpYTB1N3RPSTd1QUpvaGJzaTc0S1B6bVRwWDZVZ2JF?=
 =?utf-8?B?K0p0NEZnZUJuazg1MHRHR2I1ZjZOYVJUQTNjL3RzYWJGTWxqankySEZnQm9G?=
 =?utf-8?B?NHJJbFhXUmd3S1BXOUZ0N0owS2dLK2lBQWhLNEFKLytwQWtEL21SVDBXWG5j?=
 =?utf-8?B?UlRuQW1NWXV2KzRZanJDaTZJUDBpdWowbm5hM0tvV0YxcE1IR096MXNEY1dv?=
 =?utf-8?B?QXVEZVl4NUN3VENXQm1pakpJcEhGQ0FldVZOMnJRWUIxSkVSL3d5YVUxZ0hn?=
 =?utf-8?B?a0F2RDJjY0VjT25QT3c5R2RBM21ZbFNQUENXQXZ0MEh2Nnc3Z2VHMkU0eXRB?=
 =?utf-8?B?QzR4ZUxHTGhWUXVYU0hTODVzRW1NUGZCSjdXN3psS3F4SXlCZUNkUmNDSzJ5?=
 =?utf-8?B?QWlVbTZmRmovNUw2bGdUOWhFR252OVRUeTBZS0U0Q0JSTk5Zc2U1YlJLV09r?=
 =?utf-8?B?dFdtMFh4NTh4YjdzR3A3OUhkaVdWSjJ5bWJPVVpiZERieVJZMmFLZ0RTZVR6?=
 =?utf-8?B?ZllwamkxdUtONlBIdnl1QUJoSXl1YkZ6cTlQSFE3bUF5MHI3RXo1SXBIVDNj?=
 =?utf-8?B?MTNrNG9EZ0phWFFzeVpxTExMS3BZN2xCU0hNT1pQdXZUOS9tbkJsZ3JEZTVq?=
 =?utf-8?B?cnA1Z3hxVm5tYmZ3cGF4VjdTbGU4NlFldm1kYU13NmxPZFVSNnUwbll3OW9H?=
 =?utf-8?B?RFhoWjJqTk5JdjZvUmVLODdWbUttMGh6a29LNmpMYmdnM1JtMlBLV3JmNUhH?=
 =?utf-8?B?VG5tY3Y0Zkx6RUR6K0FHY0YrSUNkMExHUjhCRFZIZ0o5dkFFcUpvL1J1QUdu?=
 =?utf-8?B?MFU3S2N3WGFENkM3QkZkeFVGQWtIMjZyTlpaNlVmdmk4QldSVDFpeExsSzVD?=
 =?utf-8?B?bXVkVzRULytibUFFVUxJRlVGcHlETDNjeVBKNWltaWplV2M1UG5FNEMwTjZM?=
 =?utf-8?B?cmpXRGZwV2g4cDljYjVkN0V0bzNDOXo5d0ZXMFlVdTNUSXZIR1FOZGhrdkYv?=
 =?utf-8?B?NkFTY3NBMjJqQWo3SmluVkJMK2p1UFFSdm9HSFZTM2M3ZlpIa3NGWERwRmdE?=
 =?utf-8?B?Q3NxSUdsVWtLL1J1U1phZ0hCSm94RXRiZVgzbVQ0K2k4cnN3ZGVsZnk1ZjNV?=
 =?utf-8?B?RXN1bjFUMXZ2eFdqeE5rYzBBRVRIaFFyM2tsTWk1aDhiVTdIZHZsdHRyb3Ey?=
 =?utf-8?B?dXpSZXFMbUNkOUxZb3pPVXRNUm85UExsTkYvUVpENUg3bnJSZHFGZGdQY1ZD?=
 =?utf-8?B?ajhZWDZLeVlvcGhtZVBZaVBtUnpFWW93MkJ6Q0l3R3BoY0lTeUlCVVdUb0Uy?=
 =?utf-8?B?ZlRnOFpaMForMFYvaTEvTmtEWExIMEFtOWtGOTVtZk5wL3RiTW4wNHFUR0Js?=
 =?utf-8?B?UGFnWVNrYlpWSjNPaExValFsVittbG9hdXA3Q29qLzFkTEV5ZG1CYjEvVnR5?=
 =?utf-8?B?TkJmR052OGQ5Z3VWZ2trOFlNeW5mbFF0WEFIdmdPVzlDQmhNZkNhS0JKS09q?=
 =?utf-8?B?eXlmclJOL0U2am81S1R3SDV2V1dPU1FUS2lFMW5YcmhtMUxkV0NYNWRrMGFP?=
 =?utf-8?B?dENmczlkbVdIRG12V2pHTUlKVTBlZ3ptOEhZUldtOEx1ZVVMSERBc0Rmbkor?=
 =?utf-8?B?NDN5Z0dRdE9lbStWL29iczhsNlRVS0dSdGVYVTZQRDdseU9TQkhlUVNTVkdy?=
 =?utf-8?B?cktZZGJyV2s5RVNDWTl6VHR0U09oSkdTR3dRTGgwUVFXR2E3Ym5WTFY1eE9S?=
 =?utf-8?B?Q2VwTzNrN1J4elR4VFkvTTNnOXlQeUhWVStRLzcwNUcrMFhLU2lGZ1Y0S29Q?=
 =?utf-8?B?NmFEOWZhNXNjdHM3MjRKY3lsLzB4Qi8vU2E4ejVUdE5hbVJnaXJMTHRKcm1E?=
 =?utf-8?B?SE02cHovSlp3Vm82Undxa3FBMjdpcXJyRU0yeEUya3hQclgvN1lTTGtjbVRm?=
 =?utf-8?B?eU12bFdZMVY3SGxnbXowSTYxelpZekU4WERUTmIrcGl5WnFsNzZ1c0pSYWkv?=
 =?utf-8?B?ZlRMMHJNN1p6RkRKSUVSaXY4YWxoNVhKcVpuVEovS0cvRk45N3pmNWpLT3Zm?=
 =?utf-8?B?TG05NTExbFg3RlMxNUd1bVpsa3BEc1pXc3k5L1Zpc01yb0cxWmJkZkR4NjZM?=
 =?utf-8?B?OFFOUXRmTTRZVDVTdzdUTi9kZEtBaXAxSFdMV21Tdm1mTUhXdGxVZktEUnly?=
 =?utf-8?B?TmtFOEc5Njlqb2dtZC9SOWtrVDR0Y0ZISkMvblJEek9jSE5rWmJUdlRUOHZs?=
 =?utf-8?B?RXlPakNibXRjZnlOSTY5ejNLTXNBTWhrekZFenA3Ynp3d1I3c09oNitxa1g0?=
 =?utf-8?Q?qrG+UBqXxsPJuXLg=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cba8e59-d50c-43c2-24b5-08da1df6328e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:07:27.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocYQL5cPFMACSCiu+T4fHVjGo8pT33gebxkklkU4ArdwDJRKGztqWfUUda7FglpxzTrs68HcEgqM9IVSroXL/V1tCMBiAO8fZjeMn/bp9BY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4356
X-Proofpoint-ORIG-GUID: 1sgy2E3qWrdimSl9-XzQyqM0GFRZsuH0
X-Proofpoint-GUID: 1sgy2E3qWrdimSl9-XzQyqM0GFRZsuH0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=922 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140051
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
[OP: backport to v4.19: adjust context, add wait.h and fcntl.h includes]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/cgroup/test_core.c | 99 ++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 1310d5696dbe..599234c5e496 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -1,8 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#define _GNU_SOURCE
 #include <linux/limits.h>
+#include <linux/sched.h>
 #include <sys/types.h>
+#include <sys/wait.h>
 #include <unistd.h>
+#include <fcntl.h>
+#include <sched.h>
 #include <stdio.h>
 #include <errno.h>
 
@@ -421,6 +426,99 @@ static int test_cgcore_lesser_euid_open(const char *root)
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
@@ -434,6 +532,7 @@ struct corecg_test {
 	T(test_cgcore_invalid_domain),
 	T(test_cgcore_populated),
 	T(test_cgcore_lesser_euid_open),
+	T(test_cgcore_lesser_ns_open),
 };
 #undef T
 
-- 
2.25.1

