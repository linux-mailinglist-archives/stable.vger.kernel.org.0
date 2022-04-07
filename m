Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF63B4F774B
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241706AbiDGHWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241688AbiDGHWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:22:04 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6236C90FDD
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:20:01 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2376l7gL012838
        for <stable@vger.kernel.org>; Thu, 7 Apr 2022 07:20:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=HBdd7R/09yKfcRdnXb02KO1gHV8mCI/A9HMsu6Wuxes=;
 b=lNzVVbyh87vIvJDTesnggPmMiA9/p/2r1NGGJOBXURr6KjiTQQCtCrAWvxzmQDWClVZ7
 gFmVWslxv67boq7gY0kyNcQy0uv7vkv5oUjHYpUtLuKE/wTq9xumHtWU/BFJhy6VWy7w
 8ir/zw8AdDftkq20SiiZfdrMPHoz4j/UZ4Pkquw1ULAqhMYoDZxyTUr+Tb6stiBc61ms
 6pBK8cIGWbeQiWgfrnPXu+3rqI6cHjdH/GBefnqL6C0OlBgu80lENiqIjlFswdq6s5Ti
 V6N2iP4D63eOIse/k8LEuCbVlqJv0c9rTkjJKDHtjCien0sAT84fNfDDQu0jCl5heFFd ZA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6bq243dm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 07:20:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PyDR/RWWyhs9adtAK4/rAtd9niyRdXTXfahJkdZsvBRmhOhcfoZ8xbdDXau0YTdmWqYI++Q0M3uQIlftfGLxtdw0MlR2KKMRW85LYtjbIUAsYTaN/kATZorJovk0OfSddAdWrLgfc+vwMosr3PK1/R6JpCTQNYYZx894zbKeFybqnDFxpao/U56+jeBN2hYyPf9gb9/9TQmpVxzOoDaEMwNOm4LHV9qMVhavcaY8fgI/VbfrDEKwmzqqwxWwpev0+moH4UwXi+V1zac4/4wiofivk3oETCmuR2dsHIxRaIMCVZwlU3g/Por+LHoP9qfAgUqAkHjpn9q2vJ4wXl/EsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBdd7R/09yKfcRdnXb02KO1gHV8mCI/A9HMsu6Wuxes=;
 b=fOgJTS2wORZofK6MljwTaJInUgJmsnkNXwb4hCv1L/IW/W/8Gpjdtg/yCKoka1B8HzaKNttVIbrEhxJcKiDGKP7vGlARhI2IthruhGdwlICAwYK4NCNvzAq/2N2idMQnCCJgTvIiR/iWhJeBg7eqq1SxoYMq6hbAxVv1i2cMb1DgVNoC1qotyWpO/6/JKhzB+wWcrWnZokXWaiuP7XgDCDbnb9rVcdY153QiULAbrmD0EUTTAzLmsdnu+8EEQfParuOscfPVdeszzqLcgBXgtQhIJprRp/F9NLwxNWX/ZTXn9jONn8XtxnhfZFsq4ZWYYfxld5oMzKTIXS6ZE+cr8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 07:20:00 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf%6]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 07:20:00 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 2/3] selftests: cgroup: Test open-time credential usage for migration checks
Date:   Thu,  7 Apr 2022 10:19:00 +0300
Message-Id: <20220407071901.32350-3-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5e8e94a8-f066-4e4b-e831-08da186706b2
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3371886838CD3C6ED7A886F4FEE69@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkDgRU+nSFNWXiWMcg0TF5B/ldsknZo6FVXkH2P6HxW3ctWng+QtJaF0cP/LlX83C3B1G3Ua8KN/kEpvV6TIqzhPwYOIhudve7VmDm+b2kblUxGF8IwedVl6FmGfhu8HkvdVpe1yE1jCUL/dgkcV2ncu85CS9arbc8Fw+02aGsA8yjXynHwWXgAO+U/8Sq60sQzkHXZKYIobiRfTU81/SqyyChXbsjNYIxTSDIKNOiLMEgTWN89RAuH6KWcChCMSaR0VQuw1formDITwcQacv6pgo9uHooFsaKU6HnQAmNO7A84mhez87I6HjH6oWHTkKliweaK7ENPE8PXqNE6ds8GqUupRxmroevKlAi4gYOnJC/kC+NYyZfMrsLXG8DV09R4IkOtIWZoENcJJor4QO+TqEQBo3DoJv6Uy5dapCqb/ppdQGOspSFW1Lw6xnx5wKHXcGGH2UdloK6H/VXR/3Jl/o8axMCamSMWjtjWp8nhxWHES68YlKfnQ5iCahKvDoihAj3pLy+K4wpL51ovFXRyGdphMdm+stEVGdipSaCJ1lCQMT9jkjg4L9PqFXSYC4nAzcgUyhHKm4i/jC+wY230SxFMiVNyso9RlyCQXOgBXBTTO35oomt3McOEcrccmgYSO3HkgPoEL08Gyn7jdwyzV1jJS14e5TG6hXrGOE+F3mKf8R5qrF2VUvAWoEB602026IgqqgKPnnCP4hK4yew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(1076003)(66476007)(6512007)(66946007)(8676002)(44832011)(38350700002)(38100700002)(5660300002)(6916009)(186003)(26005)(2616005)(316002)(2906002)(36756003)(508600001)(6486002)(6506007)(52116002)(8936002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzNLRmxVSWhzaERJayt2TWl2UHpjYkdocFk3WCtGcUlQQnpsbEw3UGwyT3RP?=
 =?utf-8?B?aHRDZksrKzJTUlBIN1lqQ3pSYmtSa3NiM3BnSHdlcm9RamI4ekMyMEpPQThV?=
 =?utf-8?B?Qnkza3U5QUxRK09LR21NeDlkOXV6eDFISElpdXNFNXF5Yk5zVkpNTm9WRG9M?=
 =?utf-8?B?VWtXZktIY2VzTlRuamN1Z2RuZmp3NDk4M3p5WkVkVXFWNEtZUVhtVlpmc3Zp?=
 =?utf-8?B?V0lxVGlMV3MyOG9Zc21kRkJTQzhYRk9UNCtJQmZNOS9sdlBiMmF0RXdwR0g2?=
 =?utf-8?B?ODA1N3l4QTVmMTMxdmt6UnVUNkIxNjFuaHFSTTJCQUdORmVGeUxTMzY0UkQ2?=
 =?utf-8?B?VmhsQTBsLzFqVWhBdnJHc2k5MXRPUmQrQ0dsN3BoN2NrcXl6QWl0cnBKUlVj?=
 =?utf-8?B?K3Z4VmtRaWY1SGxUMUp4TGwyV3NNVUVoenlVaG1xWFpSd05rZHB1Ym9lcUhB?=
 =?utf-8?B?UnNwMTFBc1llN2RiSlJ1cTRFckM1NDkySjdUclYxbE1pWVFPSVI4UUZKdkZK?=
 =?utf-8?B?cG5nSHdqaHhkUFQ5UFFaME1peFkvb2tiTkRNMmh1Zmp6VzIxRW4ralZrT2dt?=
 =?utf-8?B?anJhcUlDeGpRdTJSVlNmSE5hZWtrV1EyV1pDcEU4bDNKOXhhTVNIL2RFR0ZR?=
 =?utf-8?B?WFQ0S3A5Sk05c2tpTjFvVEttK3ZsSFE3MURtRW1Hckx6MVlRRnZwQmE2Tmho?=
 =?utf-8?B?bkRJM2laUkZWUWZDOUFkUTR4WEQ5MklIaGI3Y3NSVy8wa2VvcUU0ZTMvbEky?=
 =?utf-8?B?Vi9LT0RXMCtHMzZRUVFrQmVLaTAxaUVCdmpwbitYTGpyYVNmRXlnYldBdUNI?=
 =?utf-8?B?b3lnQXI0K1ovM1ZhY3Z3N3g4OHcvZjhicG5LK0lnWEhMY3hkM25vVzU2L1BS?=
 =?utf-8?B?SUZKRXhIZkxUVlprMnRyd0JmVW0zdWt4ZHdGTk1CS1JSUzl2ajA0c1pteEw3?=
 =?utf-8?B?LzZWMkhaMEJVeW9BajhjaDhMYUV5ajhRQzBTdkZJaitVdTJGMHVtczhpUFhT?=
 =?utf-8?B?OWwvSFdMb2pnSHY0aktYdTBxWlhpMHVDaVRyWTNEZ2duVU16MDU4Mk9jOEMy?=
 =?utf-8?B?b3A5VlhRYytYZHJYejREN3VHWHJzM2N6YVJaVFY5anJpSGF3M280dHR5OUNy?=
 =?utf-8?B?c2kvSStBQ2FNSi9pU042RmlWQmlkZjEzcEJZeDVrcnd6NzRtQnU5NEhRNldE?=
 =?utf-8?B?YjlwTG1RbG1OL214OU1oVTdLU0U3amVLZmY0enpObzNyTzFXQnVSUzZuU00z?=
 =?utf-8?B?TGVwR2tzNnhVbzd3OHdFc1ZRbGowTHFaZFJ1a3NuR2lyYTJ6UXFOdFFtSHIz?=
 =?utf-8?B?VjExa215cGt4ZGJZWVBrUGtnN3hDOVpKTmZtQzVET2J0M2RBYk9UVGRrSU1O?=
 =?utf-8?B?RzVvQW5rSWd0N3d0dWEyNDcrOEFCRE1kNGxyc0dwU3NIUytUMitCWmVWQjMr?=
 =?utf-8?B?L3dYWFhWbGdBa1JPQXVlWlNVdDk3dWpGUUZMK3UxSXZ6cGYzOGhGWXdnRUZj?=
 =?utf-8?B?RU5LVmQ4WXVlMGkxOTlRcFhxWUV0QlJMY3oxRElQQnlXbXlpdjMwRnJZd293?=
 =?utf-8?B?Y29yYzFxK25BS2x3RkFmK0JKTkFlZVhvQWJqdGR1MzRwNk5LbHBwRHdiNmZC?=
 =?utf-8?B?b1c1d2ZzaldJNVJwVGtVRy92anN2M1NDZUMvb09QcnhVejNKT2VKYlk5R3FS?=
 =?utf-8?B?YzE4aTY4M0J6YjNuSnhQSDJtQnhpNFhFKzBoZjZjSUVGdk4zRzB6QVdIcnlQ?=
 =?utf-8?B?Q0NvWjBXOGhJOHNNWi9XZFNxNUg3cXZoN2Y2U3dVb1RCVmE2WkJrNENBR2o4?=
 =?utf-8?B?aTVSSFRIVDFjYjE1QXpkbjRsVlhaaHZIQkVKbDkranBYeC9mZVQ1SkVlWE9p?=
 =?utf-8?B?VVplcEdGbmhxUEozY1VUT2QvV2N5ZCtkTGhpaDkzZjc4MEF6K2s3c2FuRnFD?=
 =?utf-8?B?UmM1OFRuSHhIKzM0U1AzY3RuM2pQSzNvUU91UStaTzNZMkJkY0F3RklPTHBC?=
 =?utf-8?B?QzVvVGhCMml4MjVocnBPNGJVZmlydHI5Z0hYM2ZvRlRwV0VoMm42cVFxS21o?=
 =?utf-8?B?VHEyZHlYa1I0d2ZQOHQ2Y2YrZmd0aEZ3TS9ZM21qZnU0aFFjUjNCdmVyaEU4?=
 =?utf-8?B?aUtmbURlQXhKQjArM3RJYzhDS0VkVnZFeFZJT1VFNXpubzI5NUhsRlBPM1lr?=
 =?utf-8?B?dEE1dkhobXA1S0VoNlhFZ0MyU0lFWjZ3TjA2Vm9QLzhCZ0lzK3BUVVJtTHpL?=
 =?utf-8?B?MmRKdDFHdkVBa0VjaTgvUHF5Kzc0NzI0QTJiTmZQc2hGNXBhMlBqcTNYUnVU?=
 =?utf-8?B?cWRneHlnKzV4S2tPQlBzT05taGhkWVNZWTZrS25SMzliRHJTRDdSZkdIUTU2?=
 =?utf-8?Q?urCJkXOQfVLKaJqA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8e94a8-f066-4e4b-e831-08da186706b2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:20:00.1932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Ct8CQktX1yVvM65TwBNckwwY15rMmoyerUBiaXhOA2mHLg5ubr3kQajpGZHLC4RE4qWAy845Lmp0B363DJex38FqEcPmPKddELFMYNULUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-Proofpoint-GUID: h_vJleO5FP5mgOwB7FASfyQA_DvJ2el6
X-Proofpoint-ORIG-GUID: h_vJleO5FP5mgOwB7FASfyQA_DvJ2el6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0 mlxlogscore=739
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

commit 613e040e4dc285367bff0f8f75ea59839bc10947 upstream.

When a task is writing to an fd opened by a different task, the perm check
should use the credentials of the latter task. Add a test for it.

Tested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/cgroup/test_core.c | 68 ++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 3df648c37876..01b766506973 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -674,6 +674,73 @@ static int test_cgcore_thread_migration(const char *root)
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
@@ -689,6 +756,7 @@ struct corecg_test {
 	T(test_cgcore_proc_migration),
 	T(test_cgcore_thread_migration),
 	T(test_cgcore_destroy),
+	T(test_cgcore_lesser_euid_open),
 };
 #undef T
 
-- 
2.25.1

