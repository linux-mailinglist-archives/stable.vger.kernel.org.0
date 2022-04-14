Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E1250094C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbiDNJJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241239AbiDNJJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:09:56 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836136E346
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:07:32 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8MBto008671;
        Thu, 14 Apr 2022 02:07:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=F4ImGJXtYgrdVcLXQWn07kiemCx40JhzeDnFviM5FwA=;
 b=Tqhwp70MJYoRRyngO/0x0+nxKM9Wymhh5a7tJDruZ3kkuTMAg5ViBIidYs34ILt0k9gR
 /dj+S+WkzBCqOETuWM4bXUSZCtNk7ARhsNaNezZcu2lGbx0sz4UMIIk2OCTGEAXLA6kp
 FMlCtWlUNr6/3vgHzfFZQh5LihZ8KsvFwta2qrwgATx8BIDMCraS9IzKRmEBJcixK3Z4
 aXUSvQLnNjqTowsWMaK7e2I1Ab6H8sht8CFoOnNptXfkiMBgI+/thqwF2dybVXc5Y8d5
 c7glc0bkDj85oiGNjFpUpA27X0tcgVhufd9YotyCMisoI2jftmMBX7AJHRMtXMPldb9z SQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfurtm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 02:07:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h76rff4D6YFeMv39oRIgIODni8+7PtsCGUyk2T5t1ev0Gos29ywaEv3Sm16RQuARX2+Iy83MAZx98JkCQfWg/2BtUIllxlr7bD6uTS7S2cScBQ0pmikZEVHILkA8g3SaFaXYR7dVyir1M6FFWbksWHGdEcrp4FTAe1VmOoShrDaNgDBcty8noRKnAIUn30R23hkGhGnFyF/2XhbyIi2eSZ6UnZjra/P+AccIHbToX2ZQGgXf5jYx1fvdch6CfjKJqNhQb3+CyH+ZKdcNbVuWUnV6XJXpmhzqJNQHJkl3qZvEfSYpaAU6r6qQ935HmEqR7yoZ6WvWJjVKhM0DCJhyVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F4ImGJXtYgrdVcLXQWn07kiemCx40JhzeDnFviM5FwA=;
 b=SiuMB27Z8Ly9QRsWsbllHizkNQZIe8dVkM4rtdqdnEq1SkJ+JX+qw7rhwM8mXmhx2NvVb9clwKc1yfzmpk7BG9/WhQ7qmQSbprYAC2SrqHsZ8GVwA+8wXHeH8/kYXN1XHd4bUsxuwQfxUMqwuBs8KqUDkxBO5ElXNaapckVGo0T0xVYqsKGicdAoryjUjdAxjcgFmN/ZbrIK7Sg5vE2rsMG3Cga00WE41n2rwWAQOeZUw4oDeBwbI0qMOu4dbaTTh+9tgl4eSRSLOLj3xdOogehlfX2qohEDS11G7MXoz5RI9M6TO9kuBEGfPDXjCctt5/+KSG+v+PjcGNYhdO8K6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BY5PR11MB4356.namprd11.prod.outlook.com (2603:10b6:a03:1bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 09:07:26 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:07:26 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.19 5/6] selftests: cgroup: Test open-time credential usage for migration checks
Date:   Thu, 14 Apr 2022 12:06:59 +0300
Message-Id: <20220414090700.2729576-6-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 437fb283-825b-46b5-5cb7-08da1df631db
X-MS-TrafficTypeDiagnostic: BY5PR11MB4356:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4356DF4400E34D84D07B485BFEEF9@BY5PR11MB4356.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mZjz8G8mpe7hf5wGyYQWFzJW4mJQU9xTq9mSyUKHsCZLkLppvrLEoR1hTGRJi+6xGmeIKaQIZH9C1AeP3AiB3PhnqykkOVJD6RXmemDt7IWiejLvNSt6dQIkJfDJnHfbW5AIQvxVgSEdC6ZTrFWRkXEZIpDm14j6/DUzzDl33aSc3/4lt8OuK4Fizev2tfrLnSqc6ZSWMgubL8P5TIqsRGi5eIMtT85S7a4q8lZ4758zG8zUMy0Zt2ummMSVklsSz3fTA6EWta5NBuV0UiANNZKADRNJu/hfNUzMyp7m1mwYMluXpUCNiAKlO69jdNPFkCfFO1ETjUAE0dMD4G45rtXIHE3p/EKzWmxzBnVL7OKhUaHtY9yOvC0zuBx71cm4Ts1lSluXfh0T1HAZxUUGyTBFwKTAw10QIsV3sSqBlqsfnE91s4WH4S01gLE2bWO7p3olLjppi7VTDiWUaRgS8hKskF1FF+h/SXFiinmz+Ef7Pi8RX1JffwvJS3YXZxnP2piaYfUxIzGQgugprA/dLFm4tMp3NryC1Zx/GpJ9t7XdL0m2nlviZsGaJkj/odGJTFbQ+ilkHM1mOdRMpCAFVlHMOgQ12Wpy/An+mSTPYydA4yyRGVqOmfIN7NVHTch2HuT0LRLa7Q52NzJLJjHW9WwXyM0jvhs39LJsdTGrAoU/CEh0rHAIJbhECiXBzk3WvCOwRhNlNyOPCJAIXkisEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(5660300002)(52116002)(1076003)(186003)(8936002)(6666004)(26005)(36756003)(2616005)(6506007)(6512007)(508600001)(44832011)(316002)(2906002)(6486002)(66556008)(66946007)(66476007)(38350700002)(38100700002)(8676002)(83380400001)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0xEZk9XaEY5aklwNC9tOWhYR3RFZ1FDSi9VeUtFUHNtMERLOWJFbUppUkhv?=
 =?utf-8?B?cXkwaTcrMTQ1dUtBUWI3Ry9ENU85OWVKKy9qS1pnUkZvS1U5aVJFbWJMdi9M?=
 =?utf-8?B?akxPa0U2Tk9DaGIvSjkrWFI0VVZ6K3JxOGZxV2UxYWlWTUhXZUhJd1k2OFFE?=
 =?utf-8?B?OEticzg4SU4xSFViTFdsdlJJcWpja0x1aGRpWDdnQ09jQkYwaU5QZlA5WVhX?=
 =?utf-8?B?dXdJQmdRdFU5MWxtZFc5eW0vSHlDWTc4OGpDc00wZmxaQWtiRXhuMGpJYkFP?=
 =?utf-8?B?bGFsZCs3NHRZRzZ1bEVFTkRmYmZnRW9od1hqS08rR2RMSWVsNnZBNHU1QTRQ?=
 =?utf-8?B?TjJvOFBFTUlxaUJvdHlXRTBzWE1VdlNnQndYei9qdUNBK2luUWkrRGFXbGlp?=
 =?utf-8?B?YU5TWStzS2RjNytiR3kzWFFhMGtxRm8wOXIyeERrU2IvUmR4cU8xNEV5cklD?=
 =?utf-8?B?cWtLdWZJemxNWlh2eWEweW1NMlNibDgzb3NXVWZwc0FIVUZ5R1pmaFR1WnA5?=
 =?utf-8?B?ell2ZlI3K1J5Z2l0T3N2NjZCVEgvTldyaVlYREREc1p4YWl1N3dVUjA4ektN?=
 =?utf-8?B?K1JrVXIwRUg5M09lVWo0NHhyTjN5am5mVTJac1piK2NRWTdNNlBQTmsrMFFv?=
 =?utf-8?B?OHJkb1ZRK0xYb3dwcjNSZUNFUFh3YVZxVU9TY1BNSU9JdjZsUGVQQklwaUpK?=
 =?utf-8?B?TnVnSmhpTGJlTko1ZmMyd1FJL0dVZDNRV2dnQlBQUlVWMUJrNUpUbVptTHpI?=
 =?utf-8?B?eDlVeWtvV2d6VVZLOXIvMi9zRWErUFlKZm9leGdLSGVIYkxtbzZEaFNDby9r?=
 =?utf-8?B?NE1yZE53OWk4OG01eUFESFltZ0NaVjhmTGppZE1QalBWQ2NXMUpzVEkvY1gx?=
 =?utf-8?B?Q01tWWpoM1ZTc0dFcThDYnNnQ0pUUjVoQTJEdlJESHpUVkx5dElBUHdsZUtT?=
 =?utf-8?B?MHhVQy9VQ1N3cGh0bVhDZlNTSjdSQU9zZ1RpY1hYYjF0WDY3MFl3VU4wQldk?=
 =?utf-8?B?YklqYjFlSG1Eb0ZyalZhYU05T2thSi9qNCtVR1NScFhCOGppb2JUV2VaeFE1?=
 =?utf-8?B?MWU0T1d3Vi9QeFc3RE0wZ2krYlp2VmJDWjRENHVrSzlzNk0xWjNXM0ZDYThM?=
 =?utf-8?B?cHpNVys3ME12ZGs1Z3htZFpUaVBoWENWL3dZS2cvWlpIZ3hxTGNIZjF3T0s5?=
 =?utf-8?B?bFV2OUtack12elZXWDllT29KVmxRUml4ZVd2ait2bkR1ZHJaYzV1N0FnU3Z3?=
 =?utf-8?B?UGRZK2ZzRmgyTldHTkUyU3FFMlhCVU9hbDZpYzZQcDJDRXNab3lqWmtiVno0?=
 =?utf-8?B?aWtHYjdzYU81dnhsTkgyQ1Q2QWU0d1ZJU2xKZ0dpcU5VeDVxenlJTU15MXdX?=
 =?utf-8?B?bDh3Um5KRFlTdDhqNU1UMk9JNVJXWHdpWCsrdS9YcUlwa2JVbU55SWRFaUg5?=
 =?utf-8?B?SXpDQW9kRUp0cVVaUW4ybjNzVnFtWmVJbjBwZmhsaUR5SnBmNGROTXhURDdH?=
 =?utf-8?B?bDJ2TU1jU3QzNXRWM2x4dG5vaTNZdFJtcVNCdUpPSEYvOEV1Ly9sVUJObFpC?=
 =?utf-8?B?b0ZMcEVoYi8wTytxY3J1d05INSt5OHV3NjA2bXN6Mi9lN013Tmg0SnF5RWNU?=
 =?utf-8?B?MHk2VUZzbDYvaEYzUXdSajhvTTBtSFVUaEttdjVtc2N4SGtsOUZiakVSUXJG?=
 =?utf-8?B?aTZycm9HR2VQQlRVQkNNRmxpTWxVekpRaWlYSjRiZ3BNZUU2NkprYmR5UWFh?=
 =?utf-8?B?QVJHc0pUUWxnYkxVQVVaVmxpV3I2YnBOYm03cWhxaUNURWNRazdEUGpCSzhs?=
 =?utf-8?B?dVBBUXp2c0ZLbmUrMk5KZDlBL0VTc1phOGFib0VqTTkxTjFqdy9FVmgxa0tw?=
 =?utf-8?B?TjUxWmFWYzhhbVA0WHAvT3hMamVZREc5ZFZsM25ESitMUmlXbnRTODJEaGJK?=
 =?utf-8?B?Q3ZNWGRaUkNKZktmeGZneEwya0haNGFZOCsxRHFZa3l5ZkI1dU83S09CeW5B?=
 =?utf-8?B?NFlZQm94R015alJTb0JINDFpc0Q5NkVSYkR1UWV0KzZpcTdLbEc2S2UrMm5X?=
 =?utf-8?B?bW9ybEN0bTNyVStpVEMybXlmM01SdzhuNFZFSXJheDBEQ1A1VTBmeU5ZZ3NN?=
 =?utf-8?B?RklLVjdRMURkaGd5enVnaENJV3RhKzhKOXo1R3E4MHQ5azk0T2xHOWhqM0sr?=
 =?utf-8?B?aVdpeTNUNXV6V0JIOTdndVE4QndDamhTVkhOUDF2SWVIRFRaNDNDcFVseC9E?=
 =?utf-8?B?YkFjeXM5MWgySWt6Q2g5UkhHMVZMRmFwanl0WGlIaXAvb3N5Tjhsa0JWbmhN?=
 =?utf-8?B?QWJTSFA0d0Q5cU5KV0JMSkZTRlNiV3RGNjAzaTc3d0I3SUpjNFM4ZjhtVEZH?=
 =?utf-8?Q?NUjXbcHzi+nkrL3o=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 437fb283-825b-46b5-5cb7-08da1df631db
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:07:26.3528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKBMLVG2QVkrRGHiTidsDSOA5AbX6PEFVRA89a4lSv4b6ObVC04hddR64XIrPeldwaTz57l+TztuLNJ3WRONmrAekSgrCqXeWyApRPdpm7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4356
X-Proofpoint-ORIG-GUID: TqJm8ZNdeZ78Owg6Z72yKbDB5Zg07rs0
X-Proofpoint-GUID: TqJm8ZNdeZ78Owg6Z72yKbDB5Zg07rs0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=600 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
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

commit 613e040e4dc285367bff0f8f75ea59839bc10947 upstream.

When a task is writing to an fd opened by a different task, the perm check
should use the credentials of the latter task. Add a test for it.

Tested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[OP: backport to v4.19: adjust context]
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

