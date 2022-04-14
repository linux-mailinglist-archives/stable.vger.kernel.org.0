Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D601E5008AD
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 10:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241086AbiDNIr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 04:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241050AbiDNIrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 04:47:55 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05EE19034
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 01:45:30 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E82A1P007385;
        Thu, 14 Apr 2022 01:45:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=60KGHCrzwDOZNNOfU9yLnRNkrwlJ46vE/7T/Htd3ltA=;
 b=A+bcbqEYU6cM/hdML7pEX1mLUnZ7mvCN3QrFrNPUJazifPaM0FuLcsw1bzaoImF8xX4N
 rRmEgDm3jDtM+iwmP4jLACapZvYZ6pU4+GJP25rcTRNUG9domYE1xZ3CD4SEO4LlMTs6
 N8HfCJNP6Q+YTXQLZlq3wc8ZqU2V2/q68JTzj8RpKG70YaMbFmb0YgMZ0NWlENHnLofz
 5eNeNGhX3HW7X+rLn43yxtMEieTRvlDkdpORvHf3QDETs+aRTbtlHLbRWSed1u61nwS1
 WwMeOutB+lPqYuU+T/3to/kTOs7MpMcjIIK8HE/JS2lxs46lt9czRvhztVHBRkQnxvB6 pA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jeb4j0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 01:45:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdqAQ8dKR8kl7nCcHne56fo4pBBB3va/c+vXmdHoLx728QL4Zq21OaPpykDjDuD2bRhwtdJMVB53J0bMTixWxYhp/g77qopvZiqKO6XKkrryRAu1rhxyo+AzvT8TsVG1+IJhtrIOA8AWSbi9q/fAI1aZyKldkT9hz125uW/FDv4Vt3AXWJyxGxj6gcH/ls74aTXbouRRIAv+hCimKUAE6pD3y45nCzuRHtDHtMSVUcRWpjprFvEe6dE85RVx+eG68TRGC0WKm4sEIdxSo5DEA7AC/RCEOXCSkIlzcnhhqm+ddyZ0TWGeTIYvFS+r6nC/gRN0Fnx3ELO4nMPvN2a1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60KGHCrzwDOZNNOfU9yLnRNkrwlJ46vE/7T/Htd3ltA=;
 b=YtTHH4GPFQz3juBAjaWjwQ2dsI5k1qo7iNgL9EU9rIcvYcRaVCMdfNXFPwi7cxTnKyi6UesSPbD9DG4g2Jc7unufWXYlas62hsrbmeORzBoRNj6cuZG/dQKkq/6gdX2+TiIoODHEhJIHs5JT2FYex+umpC4rirMjeII1hBzU3utORa/E36/uSYhTJQ/9nvjzEI1l9aTl3H7VAiGXf/DisgK6kkbPS6t+sQO3YkHKsHQVXWI+sGHU4jXV+Gm5RaCQBunNfuwxC0v6FJDkUsGlMPSaRqHFPs8yFzVMHOmAf+cV+efCTc+Yeh2HQtbzZpSfiIJhGUwodRW8PN/mzHGz+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR11MB1800.namprd11.prod.outlook.com (2603:10b6:903:120::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 08:45:19 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 08:45:19 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.4 5/6] selftests: cgroup: Test open-time credential usage for migration checks
Date:   Thu, 14 Apr 2022 11:44:49 +0300
Message-Id: <20220414084450.2728917-6-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4438f7b3-20d5-4700-6186-08da1df31ade
X-MS-TrafficTypeDiagnostic: CY4PR11MB1800:EE_
X-Microsoft-Antispam-PRVS: <CY4PR11MB1800A37346C1A9DD54FF794EFEEF9@CY4PR11MB1800.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3WZu4rJihTSTelnoGiyaYCF+sXN7DqJ7s7HJBNXloR3tRuQPZkHIZAIDtmGRjdsBuwZZaAXDS/lISG9Kh2HXEXYjDyribslNG155jJKH69V2eCP0WX9/sYtnCHn4udeDq2FGGs3HY/1lRnrJtMzMpvPDfyu9ZLXxLxlXILa4RTBkKtrDBsPnr7gid4GgceyWFrirWvTP3wQFLQwaEog0fJgYXbLfzd9GOeGV2Gn+1xsTa856m8BRr3MQHfxbaKTFyespE/+0aq6aLBQOxCmEjM/q6ciBvuZVeUBWPitRJzh1Jy2tGN+b0x1IeLjrZfiI/YTx1XYi58XF0WclLBzg2nRXyq0QAKO314YEsZtW3irEwy9mfVjkCD40RYtnMKgAnKpHqEp6VSXYHgNChdGUK3O/GivpT0lyKGq+c1gFa2hS1KYhZso1jdwysOvCniYUyR2I0k3uK8KvdPKQ04UB/AKQsFiIZadFFwNJ7caklvkI+vY6Z/OA5whkf/C0QNZwQ7Oibz95tLLCHa8IsIKn8n6sSqwIEnrctXDOax7FWjOqD69af+JzvsH19JyN6Tb1Tb8dDs8EA/rQed6H1Xk3EaYhOisqvwPYXIu1NkiuFnrHqb4jkYur9y8arBy6fS5LWtF4qK/FXlVjkDef14Kk9sEVhF2/ofcLiMejT1xfKsZHRhT08TxglGjdqr8yKafw3fa+1uq0oClflw7t1qX3+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(6506007)(83380400001)(316002)(4326008)(66476007)(66556008)(66946007)(8676002)(6916009)(86362001)(2616005)(1076003)(36756003)(8936002)(26005)(186003)(52116002)(6512007)(2906002)(44832011)(6486002)(6666004)(508600001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nks0eTdOYS9NUEJYVDVTcGIvQ1pXYStxZnVDT1J0RnR3NXg1VGdvY0V6VmhT?=
 =?utf-8?B?ZHhjSWFzdnhGOWVVQzJuNEtmS3hvRGYwdnBRdnk2NVFqdml4YlE0QitKSTJF?=
 =?utf-8?B?eXdYMGthZnlHbDk4cTZlKzJPaDBROENkejM4M0I1ZjBwSzRlVEtVbVNGN0o1?=
 =?utf-8?B?R213L1JRcExQaHRMNDFXRUIrODMyTTRiVXhEYkh4citndzExTHY1clUrWFRH?=
 =?utf-8?B?ZG9rL2ZmM1hQcHZtRHdVTWZxUnNMVXkrempiTHllQ2ZJQzVoVjRUSGc4amFD?=
 =?utf-8?B?ajZaOUc0WUNCZGRDWGVMc3ZIcGZJaVcrMGMxUWdrUWVHckRYQ0l0VWFmQWtF?=
 =?utf-8?B?cFBPZll6aEUrWUtxZko4R2tVTGJIbThOYVplOENlNGZITkRVQXdEWG5BeCsz?=
 =?utf-8?B?NDNldEIrVjd3VkQzQ2FuOEpxelFSRThJZ0RYMUVHWjhBMkFkWEpJZndoS0w2?=
 =?utf-8?B?amVUeUNYU0xOcmZuMCt6NzVpVWV5OTN2a3cvNnBBZlNvWk9DSUx4RlBaTm9U?=
 =?utf-8?B?aGg3RUNORUlEVVdpaERqL0lvdk56SEdqbFMzWmtxN2tOVkJUWjFMcnlWTlRk?=
 =?utf-8?B?OXo1WUdrZzdkWDY2cHBiZzVwTGZNOGUycE5nemMzMFBuaW5rVjhQMlFZRktw?=
 =?utf-8?B?cWtSUjBqUEIwRzl0WXJ5OWFMd0pnMk9mdXdJT1BZZVZNMC8zTVZLMmtVRkxx?=
 =?utf-8?B?Q3haQkdBSDkwN3I4V3BwcDZ5VzJETS9wTTZsalBjdnZHblVCYnRER2kvN29H?=
 =?utf-8?B?NjZoaXlCVUpEWi90N0NVRGJaV0RocmN6WWJMKzZiV0RITDNNYlN0dWZNUWZi?=
 =?utf-8?B?Y1JLc0dDTTdLWkh3ZUpBV0RDdWtsS0x1RHhWeGZtTzQ1emNOblpISWdVcTN1?=
 =?utf-8?B?b1BabXJleXFkaVhvVkNDY1o3NWE2RUxycEsyWTByK2l1SmV5TkVrcnJoTXQ2?=
 =?utf-8?B?NFBDbEJ2VmE4aUNJZFEzeUNsYXJncnFzNWJsZWVQMHlEbEVCb0I5ZDQwMm0y?=
 =?utf-8?B?KzlzMUlSODM0NWdMT0F3Ty9kNGRWMXdzWUI3VFYwcjN4VTI5enI3ZHdWSUtz?=
 =?utf-8?B?SWNUNThkTDJtcEM5cW9PUHZORmMzNlBQendXTHVsM2UzcFg5QTFqMWxURGtv?=
 =?utf-8?B?b2pJeDFRN1pjdEgza01VQWRJc0kydk1OeWpoa1k3aGFOak5pV1lPVjI4WHN1?=
 =?utf-8?B?MXVQUzYxWExWNUpqZXJ5M2plWWtJc3dWUCtNaEIyclZRcENZM2FMdEFvUmdi?=
 =?utf-8?B?bXN4UXFxMTVnMkQ1SzhYVE9qekdocTJZcEUyT1FEc2M0aWp1UjNJV2MyUElX?=
 =?utf-8?B?UGNDV3FheWo0VllIOW9QaUZGd1pXdW1LZDVrck0wRTRlOW53bHFzdDhoMkVV?=
 =?utf-8?B?NUcxZC9peXpZajhCOVYwelJ3Mmk4TEt5TW9yb3FIU21uZ3NZWks4V2hjcytT?=
 =?utf-8?B?UnhBa2Z4TDBtalc1Ky9Ta3ZMZUE0SlZSUmFSTVpUek50RTlzSUxJUEJIVWJ6?=
 =?utf-8?B?cTJPYmNFY00xSzZ1cUhBbVdSRzhRS0JiU01vM2FNOVZNeDRqMGE2bi9vZmM5?=
 =?utf-8?B?YURwdU1KUnY4ZTc5QW5md21QYU1UNkF2MUZ1Y0VDVUZzaG1GTytkdGZqaTZQ?=
 =?utf-8?B?ME84OENLUkVxbE9ibytSMVFxSjdkbkpkRlZ3c2t4djZWZFUybXVNd1haVTNF?=
 =?utf-8?B?UWFzelFaRS91eUNnQXlCM2xueGVtNjQ3SUx3bHB5ZUJwUkR5bmJ6N2ErOFZy?=
 =?utf-8?B?dm0zUkNLL2hLamxFUnI3QUJPam5oNXNBRDN1VS9SNkNqREpBSUI5QW5Dbktv?=
 =?utf-8?B?QXNWSnVVNHhHU1RqcU5UY2N3OUQyUFp1WG10NUZvTEpLOXh2elZSckM2SEZC?=
 =?utf-8?B?SE8xL1FIcm9MTW9reTRWalNHOWdEMExoci8xalBEdC9KMGtMalY0QnhIVjRH?=
 =?utf-8?B?aWF6TERsZUg2SmRnVUs4cW1pMit6ZVU0TWNybjZxUk9IQ0tLTmN3QU5oRzZB?=
 =?utf-8?B?djkrTTRzRXAwZmRiOHJraFlTbi9KdHIvQWFYMVJucFBCblA1RE9EVkFGRG5i?=
 =?utf-8?B?eVo1MWN3bjNodWo4aUxnS0hCSEx3Rnl5RjFOcENtNkgvNDFIcDVnckVHOVBu?=
 =?utf-8?B?SEc3aE1SaWpFUkFVR1dMMGJWa2t3UTRUbnRqVENLL0Q0R0pmbTFqYUhpSkRm?=
 =?utf-8?B?a0hPL2NjU0NHbmY2NWhaaU5yemtodzlmR2J4L1lkUFloRWFVN2M1WTZFOXNQ?=
 =?utf-8?B?SUdIVTFpRlNJVlo3MmdTM0l3NnZ1b283OXFQMjlQcWNpdG1JcFo1R1p5UEhx?=
 =?utf-8?B?VTVNNFk3VTdCcDFsVTcvMVBBTzZ6M2FDL094MFNFS2JvWER0dGsrWlR2ZnRv?=
 =?utf-8?Q?PF4MusIPcm9xGPaE=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4438f7b3-20d5-4700-6186-08da1df31ade
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 08:45:19.3585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3v2MPaEoE8ORM3BiMzMjgiJYLCw5/krJ+WtqutbM9/k4xWvWLAZxqpiU/+CDUBokffJS4RuKTYi/N+jLfYTaooxQxAPRJWL63okRtFGkts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1800
X-Proofpoint-ORIG-GUID: Tvv9CSEWhuAbb3p9jAnumIDgjKlv3K5Z
X-Proofpoint-GUID: Tvv9CSEWhuAbb3p9jAnumIDgjKlv3K5Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=600
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

commit 613e040e4dc285367bff0f8f75ea59839bc10947 upstream.

When a task is writing to an fd opened by a different task, the perm check
should use the credentials of the latter task. Add a test for it.

Tested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[OP: backport to v5.4: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/cgroup/test_core.c | 68 ++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 79053a4f4783..1310d5696dbe 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -354,6 +354,73 @@ static int test_cgcore_internal_process_constraint(const char *root)
 	return ret;
 }
 
+/*
+ * cgroup migration permission check should be performed based on the
+ * credentials at the time of open instead of write.
+ */
+static int test_cgcore_lesser_euid_open(const char *root)
+{
+	const uid_t test_euid = 65534;	/* usually nobody, any !root is fine */
+	int ret = KSFT_FAIL;
+	char *cg_test_a = NULL, *cg_test_b = NULL;
+	char *cg_test_a_procs = NULL, *cg_test_b_procs = NULL;
+	int cg_test_b_procs_fd = -1;
+	uid_t saved_uid;
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
+	if (cg_enter_current(cg_test_a))
+		goto cleanup;
+
+	if (chown(cg_test_a_procs, test_euid, -1) ||
+	    chown(cg_test_b_procs, test_euid, -1))
+		goto cleanup;
+
+	saved_uid = geteuid();
+	if (seteuid(test_euid))
+		goto cleanup;
+
+	cg_test_b_procs_fd = open(cg_test_b_procs, O_RDWR);
+
+	if (seteuid(saved_uid))
+		goto cleanup;
+
+	if (cg_test_b_procs_fd < 0)
+		goto cleanup;
+
+	if (write(cg_test_b_procs_fd, "0", 1) >= 0 || errno != EACCES)
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
@@ -366,6 +433,7 @@ struct corecg_test {
 	T(test_cgcore_parent_becomes_threaded),
 	T(test_cgcore_invalid_domain),
 	T(test_cgcore_populated),
+	T(test_cgcore_lesser_euid_open),
 };
 #undef T
 
-- 
2.25.1

