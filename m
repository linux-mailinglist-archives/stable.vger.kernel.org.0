Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99145008A9
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 10:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240773AbiDNIr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 04:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241101AbiDNIrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 04:47:55 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E072C65D2A
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 01:45:30 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8MaLl026706;
        Thu, 14 Apr 2022 01:45:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=avI+e4IG/W4qivwSNqAeQJ3v1PZu8RFVCmgPYlZz/dg=;
 b=P9wnfM4oV8B4qRgU5tG3iY9tsnTJNu3qhOzvg/ypEPwF1VDCo/aT4PbT8ybzUTt67h0+
 VUFn/fMqDGKC+QZHzpX92/FzFOAE9CiiJ219leXg9WXX32F7L6O0h7QXbaiUzpZaLJaW
 3plokBX3k5gK2es974LfM7zpdu4+2SLHOLyb0AujRTv6Lw1YBlX6at65T9IGkbmgBwkk
 jMFkwVEs9HcE+iaWd4WRLq8QDMaIZhay5DRlNFWIB7YDH08D8xCCkmjWt78p89Piz30j
 yQjEn6uROOp6WFBlOLhsdJkDGobxcIGTOfPPDsvqoCQAAD8T71QYRV4nO/w3IBjm+v3T sw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jeb4j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 01:45:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsjGZoRcTD1puATFc9i78tquXkBO0O4D0KHHseI4cgxPfUxTcBDtjSCU48Uu3IKcFFnLlZ471Ho8HjforYtouZKp/30cY/Tc5+YNa55bdzKdg4QY96kRoBl0AJAUx2/TFfHY2FcJK/yb9y8TL1pk+Unae5aGPMaDWqS0Fw26HrtqxcszPs0HY8LPKnAukd0oAKNH35ZdAv8YvMxLLbDLoaCDG85dy9pqIV3dmUFgDOyiaqstzLhwYhyVNxeYIA0L3YjcBDV7ZIeLx+FuiOgpLdBdftcOj6eldiJtZE/vStKEXzjFlFjrvAkixWNEHDXMnyyvelt6gGYXeqXtdOZR2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avI+e4IG/W4qivwSNqAeQJ3v1PZu8RFVCmgPYlZz/dg=;
 b=m/FT9307MDf9MVQgmSl3IpIb6x06w4RfWbzZXPBqjSDYn1O20giClEM/yNMhT1spttOeE18g7rR46hgmTZoTsn/RU9ywJDpktc+P9RRTs5/R4AcpFd+VuwqK8vGvtZ7T2siRhj9GxVpdWs2oCQkS5TqOn+J5gK+FDgH5HPWAtgDwYz7dK+ZWPxtY+o5FNVXoMr5ftf6l+9jayNO9qyImC9y0935axztAmiKsPZmYlZzwMOMxnAQZfOREiAXtH2mvIdn68Rco5hglUiFEMQb7EZ6+RV0RBE6hA4QvnGF/hov/xVJf5w+XeuavH7aGhswj9D8ye+C5Vc7hJe2w/EBDEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR11MB1800.namprd11.prod.outlook.com (2603:10b6:903:120::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 08:45:20 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 08:45:20 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.4 6/6] selftests: cgroup: Test open-time cgroup namespace usage for migration checks
Date:   Thu, 14 Apr 2022 11:44:50 +0300
Message-Id: <20220414084450.2728917-7-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
References: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR08CA0034.eurprd08.prod.outlook.com
 (2603:10a6:803:104::47) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef40fc2e-71ca-4e4f-4097-08da1df31ba2
X-MS-TrafficTypeDiagnostic: CY4PR11MB1800:EE_
X-Microsoft-Antispam-PRVS: <CY4PR11MB18001132365C4B50C88DC26FFEEF9@CY4PR11MB1800.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EPYUWYG8yNjjCy/gZXrv3xmnFZi63/hhLmqSg1eaFJpFKvKUJXa/VB4Y8wsjyzHMwPTTaXuk781ms4rNg0ssKxOK3+ybeTLUlxcopBE1NPm+0UdeA8D0g/KR0hsUDgyqYrqLuFYvVEg9+sCbw7ktpSxUeMxlFkIdrIKv1769k1Y4/15KNnxF4NHcXfIe1SxhedRpOBC81F6nf4bVtUgKHWDZdbmDp0xKuS2FqrHhGZdM7evvVwX9ozX0SqSMRTuU8sjcj2xMpJ0KVPh4MS7p10msftRhQ/6vS/q0Eyw7BoYaTVOwX19KOhppV+vT4USLb7ux6DKUS3QR6UZW8OsUZPJL7JNr9AvK8LSwNqOchqZ1N6BlZQEcQW7KLqTAx8AFqbhvpQx8hQL3NKyUeRmeaYUzKAXnnBYz210aNfFqk51QFjNVeZx6+Mzoqaoo0BrghyVSuf0lw+64dUbVpLmPCNjp6bjSCzhPWmvOly5yqIGuHz4Vsv4BGG1kyln8xY1x1Lzkxhm2HB16qn8vT7ew6E6OCWkEUz8HGdbn5aHNIU6lnz3IhluRrl5mQyDRaxj0/2aVc+I+QGwVTdgKDdRgGv/U1utyyQTGmA+VPGFD0SIgZpnXEv5FbwopzUtphkmiiswjAnfPBDiqhHG+Any+/5yHcykkwntJU2Wv7HrbsbW/YplQOwQCg4fWYTlfVJknb1C6h3S1SQmRG8N4m5f9ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6506007)(83380400001)(316002)(4326008)(66476007)(66556008)(66946007)(8676002)(6916009)(86362001)(2616005)(1076003)(36756003)(8936002)(26005)(186003)(52116002)(6512007)(2906002)(44832011)(6486002)(6666004)(508600001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWJpRDVYb1Q4T3RhL0ZaeHppbTdQUHMwYnJ0RlBUNyt5dm40aHR2eWtGOTgx?=
 =?utf-8?B?eVNpcVVBSnNDbDlQVzRzY0tXeHZUSUhBOXV6RlR2TExrdmRZdG9vV2FnaVk5?=
 =?utf-8?B?MGUyMERuV2VPUG1ZRnQ4RnlEOUtPc0N1dHdkUHNXSXNBajZoeXVjWkFHNDRF?=
 =?utf-8?B?U1JVL3B0djlrY1U0dzFLREMybkp1ZEpWaHNhUjVZZ21tbmtCV0FkVVVnVUpQ?=
 =?utf-8?B?OGJhVGt0RVh5ekdaaTUzS1dHWXY2a1lPVWoxaGFIRStjZUg3MzIrS0pxVUd4?=
 =?utf-8?B?UTErSUF2ZTNnaVZjU2JJdGNwSThBN1RwQWJnZzhkdjh0Y2FoSmVuMk5kR3dV?=
 =?utf-8?B?SVMrRHhlemo1UWorUytURHljakh3OUF0WUMxWjcxaUx3WjNVclhmUkVMQ05F?=
 =?utf-8?B?Q3pZSUE1azZGRFYrRWxiNU9TVHJycXBRTkJnd2FsZ01ObC9HM3lPUzdzbmQ1?=
 =?utf-8?B?ZVZrQWhXWXcxSEJKZGNFRWlXU2N0ZTNqRGhic0g4TS84cUNjQkxZY0xienJp?=
 =?utf-8?B?b0IvRjNGcm9KdHlOLzdabmVJS0VNNGdvOWpaUVJwMkpkNzQ2cTJ1OWxtM2Y2?=
 =?utf-8?B?ZWJMS0N1akQ0WWJJMVZNWUhwUUNDUXpjNHNrRTBsQmVzSlJRb3V2QUZ2Nlgy?=
 =?utf-8?B?Qmtja0VWZ3Z5cUh5b3ZwVkNVZ0lRdWJLS2ZrL3I4TFBXT3BSSmo1QktzOS8r?=
 =?utf-8?B?eE9pOGR1VGlIZ0RRdWZvWHVja0lFNkhDWmpNMFlEcmhTV3FZQ25oaE9VVE5S?=
 =?utf-8?B?Z1ZOVHU1Z0ZDN2JCSWdWV1JqWVJuREo0VEQ5NFJJZVVQZlhPTHlmS1c4TnNZ?=
 =?utf-8?B?NTJUck9hb3lObzFOd2tEaytqNEkyVlM3Q2tUTTE0TTNhRGY5bDVpWjk2Sndr?=
 =?utf-8?B?Q2NwK1ZLemYyV2NCT0VUTEI3aUFxeWZtZVJiNHN6aG9LcERrWnE4Nk92M0V5?=
 =?utf-8?B?bjVsTEZybWRHajNUTnFLRVFKSXlscDR6dnpNbkh5ZGovMFpCWlMzcHRLdmx3?=
 =?utf-8?B?c1pMeDdkYWdTRE9TUnZKM3J6bEZyUE1VYWlUYmFzZzlKQW83ZVNGbmRUc3ZQ?=
 =?utf-8?B?YVlRb0dLcXNnL2JqSWFnL1IwVFVZWVQ2UjFBbUMzK1BIWUZKZ01LWHB2MHJY?=
 =?utf-8?B?MjIvQXZ4SmRKcFRrYmIyQTB2SDY1SGZROFJBZmp4Q1VBVUp0OTVUZlR3aGw1?=
 =?utf-8?B?TWE4Mmt3WHhnZFRRSGdhTWNkK0o5K2hrNHc1VmhvaU1DTXNaSXFKdzd6ajNv?=
 =?utf-8?B?c0paTXp4NmRuL1ZGN08wUkV2TVUrdER5dEpoU3hsazROQ25jYytTUnZYMUtW?=
 =?utf-8?B?VVlwaTlUV2pBNTZVQVR6dXFIUGs2N0F3RXFEcS8ra2IwRlI3cXI0K1BRN29y?=
 =?utf-8?B?N0lOUW5QK21SYTJVOHhiUG5FVFhKYngrNmpIWEJaOGw0MlZjNjZTRkVkUGtI?=
 =?utf-8?B?bWs0SDk0Z1JtYTJpc295YUUzZXhCck9uUHd1ZmI0blFUUU1yM1orWEFRdnhn?=
 =?utf-8?B?a3NtLy9PMVkydkIxZzhpRGpaanFXNjUxVVplTE8zaW1Yait4ci9yaU1rN2dZ?=
 =?utf-8?B?cTlHK1pWVXY5dDFPUlB6cGZDOUthSWY0MG5WVFBsT3gzQll3aWhjUzJTcjZu?=
 =?utf-8?B?STljajVOMHlpOEtCeENpVjFQR3V6ZVBlVkt2YjJ2UWQwcUgyWHF4OXZPOWkw?=
 =?utf-8?B?U2JnV1g0SVo5aVFURGRxT2xkVkdueUI1ZmdpR2RUWlFkb25rTEFIb3BhNEt4?=
 =?utf-8?B?VWZUYWxUcXBGWFVsNTdDZUxiTjRJb1V4STZCQ1JsYWtrOUtmeDVKY2NKeHZQ?=
 =?utf-8?B?dVJ0MnJ0cXRLczN2VHBYb2tNQXRnTGtudHlGN2JZdTJIMVNqVzFCK2VEYWNu?=
 =?utf-8?B?TUp3RnU1VkUwMUdLTGtqelh1TnROcDEvK3dsMGZZVDhnWnpESWpvLzZlZXlF?=
 =?utf-8?B?S3U2Nkh6WnNlaWMwQ280WE9OYzQ3N0tMQ3FjYjRYSkJoOURTNXMyVXEvNTJX?=
 =?utf-8?B?dzZDbExHczJHeWplT0x3N0dDb1UwT3BkVFdrMGM4aDB6VDI1RmRyd2pwajdO?=
 =?utf-8?B?QVRiZDQxU2VoaWFOamQ1TitjaWp0a3ZZZk9kdy9aRmxHUmZmbUdMWXlzRjdW?=
 =?utf-8?B?WXZmL09WcGxqRTdGckl1cUhBOVJmWi83cFJFdVlzNTdJYkN4WGdwL0xxdjZ3?=
 =?utf-8?B?UVpDZDhIalFYK094WFh0MmIyRTVaam1uMi8vNDdiWUlaejRSaUdQZks1ZFov?=
 =?utf-8?B?eEZ6aDJZVE5ncXZaTFUzblZSN1dUdFhoekFLODV4WGQxZ251RnJPLzA4YzBz?=
 =?utf-8?B?ZkNIWXdUY3NvR3VYdE95YjArNWZhK1pWenRBKzIwYUxpYWdtcFluYnNXVXhi?=
 =?utf-8?Q?Eal7aJc3SAi6w7Mk=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef40fc2e-71ca-4e4f-4097-08da1df31ba2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 08:45:20.5316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lwKD5uLYRReCiVBb6e56Q9SgIMBfDVUXmEfLlAHV+gaMH2bzxCSexzb19W0Wx6li1MrYKlV9j0ESqLhODD+znF3+IdMbsWcoEbz5eWKX1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1800
X-Proofpoint-ORIG-GUID: tVKyIYEKEPd4Z41BT55zHnWNrTWdvFXs
X-Proofpoint-GUID: tVKyIYEKEPd4Z41BT55zHnWNrTWdvFXs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=922
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140048
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
[OP: backport to v5.4: adjust context, add wait.h and fcntl.h includes]
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

