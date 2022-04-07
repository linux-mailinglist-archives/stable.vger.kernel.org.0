Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B964F775C
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238750AbiDGHYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241701AbiDGHYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:24:16 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEFBB8
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:22:17 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2376q9xw003626;
        Thu, 7 Apr 2022 07:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=HBdd7R/09yKfcRdnXb02KO1gHV8mCI/A9HMsu6Wuxes=;
 b=BkaGgylACEPii4l8b1Ro9sMHFWUJrR8PKOH9FVY+OON8B4/e0/4L9Zf4eKA91LySebpG
 oUhMZIDi1uA6Ic3oBMqnTCUNjIl6K83CZouxfdDMLemAoLyVveWPMet5k14m/yRERk/3
 3sVE6PXSqBVkFbTVcwq3/QlLjIrydyhwkEcC4SkpWvxPhuDg1r7wCaFk44ss9eg/dkJM
 r5BpJSRVXe/VXJJzmJMycJ/TyPHxa9LERCRxa99q/v3VmoqGDbJbl0j2KOoD/zsU1dRe
 OnJrl7MJcl0B+2Q61C1Zk7ZsdMflXTqc0ygy8c2/q6q+X86OpUWZLmejkuLUCTvjmfMf pA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6df8v1t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 07:22:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3kW1OP2yXzPr9zA1EQQnb9cidYlu9hvUoGgosQEnPtR0S27+sprzIUb9UeKrm6hJ1DSsRw11rfcs8yqLeAMnLepzlTtGLbykOx0PIbD9WKO55qLf9NYyOBLJtsWhjRmQgQzevUTCXuIUy6JM4JrvEglhHQ3vHGMq6Yq/z12hI1swv/Ho44fMiaAR3oy1PRPFNNbljbvJldy1/CNZ8ykIxFnIANJ4aPf0ms72brJnRWSDDZOIF+1CA2mz/J98DatzZ++w3GR7hkHUiYTmeQq+I53wyQu8rt5sBOrg4DFQyNMo4rcKFsMuJEErzZvtgaYzB+tlhn3NIfJwAMh6MtW+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBdd7R/09yKfcRdnXb02KO1gHV8mCI/A9HMsu6Wuxes=;
 b=grEvyOFN+elMPrqw5tuu4U0fh3k0S61g9xHGS7DZpqfw4Q8INMxg9D4Q2csHPFd3IErRPNV+EU7YEUy/gPH5XDdk+Yc8nq5GeB3+V97czUDdMRuSfUEzenFYc0j6UZp7cqym/5AXPDWnNLNR7g00UxH22tYEQB/aVBFlCyT7NJEPfYUOEA7sRobCdgv+dhDqL2jKBsXLXq78CaAlXdLxUhPeZbwuP2ayAeDLXFjNIayZWcjz1e2ZLQ6bLtxyG6buEkjMoICAfJxo/dOO3sxgypgsgC8giT+HY6aTWdLUIjPieqKq59vypOsiC22xhcxz4J1/l33mymQpxLq/Xi2P8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 07:22:05 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf%6]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 07:22:05 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.10 4/5] selftests: cgroup: Test open-time credential usage for migration checks
Date:   Thu,  7 Apr 2022 10:21:34 +0300
Message-Id: <20220407072135.32441-5-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: a4b52280-f48b-469f-11bd-08da18675183
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB33715CDFC6894DF9582950D7FEE69@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TV1vdWM0rpLw4qls4520FU+OmNsrWpshqHrKyMEirtMfgUQZVBci4ginxz0JAGEo335ySecr34i6fBWTvByJQ0LeS/Lqc9yceUUWMVoGWysr4jHcNMXDnxBgX+IInfJZXEfBT2o+KoAOYHTDBzB+X25vXgo5k5sfwPfciW4/2Wvf6LDOpAyqvo1C2p3In2QadTqjXGhVvkYPupURJiBQZcLbpnjw+Y1qg8TL/N2FUzwdCiJ5tOZV8uIYwbAhCJ2DcGVKGZ28jRE35KclIbF8EDqVmy9/IO3ldJyOGf79ECeswLoZA9USFu0J+CvkO/UGfa+EDGdvMbJGb2lPWnQisIkeHuh+Qi+4Rx3g7ZappIOfjxqVBKjn6j+X+47kLoqogHeZViNwRASpUbSBbst3koNgOaCTydv80w40z4M3dmLj416UCAGLlhNAHK6drYr3sRNG6HiXxknigyGy86CLCH29Bfr/SwzxMsXhf+VfcuW85tUyEADNMpTbjyXOehiyDysYb1+dFO9RdRcfGNOhlYeysFza6OhWog1DUOuybEeKuV4uIZJU5JmHkb/B9Z5/F4WqTazFD8lPM4NoJn9VjDssZqF0RjAyWG6VWZgCbR2MlCwkyG7C7mehDSCzjhFnVRaS9hvuZRTN2ggVSA90RyoVfP/9RQueBq+2nty3p+2JztXDXrl1/WbE2mN6Z80VpgDzNzbAAT0JVhWw7UtTQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(1076003)(66476007)(6512007)(66946007)(8676002)(44832011)(4326008)(38350700002)(38100700002)(5660300002)(6916009)(186003)(26005)(2616005)(316002)(2906002)(36756003)(508600001)(6486002)(6506007)(52116002)(8936002)(83380400001)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXg1WlR0NkROc2M4MnRYb3A2TXFPSjU4S3U3azQ3NE5BZGh5TVFieTE5Z3M3?=
 =?utf-8?B?U1lzR3FaQXZnMGoyRlJDVHhWcTVGUGlJS0o5Yi9JRUNJZGh2VGJRYU1TdFRZ?=
 =?utf-8?B?Q3lyUmJoNnNuRVlFZjNGVGI0eTNWbG9SRklpQnRicFdOb1RFS1VoTjhJWHVC?=
 =?utf-8?B?NnBJTkIzcjBXMWlEVUVuaVVydFZjVTZScjkyRURHZHNGak5nY21tYVZDQzZS?=
 =?utf-8?B?VWJRNVZxQ1kyMExpOUJJZ1huOG9Bam1STTV3ai9qQXprQkhkYkVURE51cXBM?=
 =?utf-8?B?QS9IQ0pFdmY0QldWUTUzUS9sUnRJNzBSV3ZxUjlBSnNrLysvbGhkTkR0NmNE?=
 =?utf-8?B?LzZGWmMybjJITUhMaTYyRW9kVU9yWWNpTHJjbUZIYnh6dXRleEVxYnc2QXRx?=
 =?utf-8?B?Zmp1U3FvOHZrbVRaQTNBa0lDbUxtS1R6d1hpSVoxVTZobm1ENnZqTC96dUdI?=
 =?utf-8?B?SFQ5akNtUGJkUG51ckhkUEltTk9nanZ2cHNKa292bUxIaG9FSEtQWk9GeXBY?=
 =?utf-8?B?czlIN2diN1dnZVNWUng0Q0ZaZm8yRUdFTzRTNnc2Wm1VOXE3bXFESDRsRHAw?=
 =?utf-8?B?WG92b3gva3RiOHVKdnkwYnVGZnVveU9YdkNVOVF5ZDUwRFhWcHZxekY3QWQv?=
 =?utf-8?B?MzRoalR3MVFydGdkME1ITkIxZDc3TmtqTlhndHBVVTNxSk83TEg4TGlMbDhW?=
 =?utf-8?B?c3FCeE4xMDVBc255SFVVb0luaklDbHpWd3RpbGI2VW1UTDdqSWI0b1FqZG96?=
 =?utf-8?B?N1JBZFh3NXNwRVQvS0YwdmY5VmhVdmY1NFVLRUxNRnR5YVN4d3RVRUlhU3dO?=
 =?utf-8?B?aWdrQVEweXEvdGtxOTZBaVBSNDVBblBuS2w0L25reTkzNjJTL0VmWENpVjg0?=
 =?utf-8?B?bDRjcTIxSzFFZ0QxQlJyd1BveWhIaDlEMkVaT1BZVllQNGdwK0l6dEoyQnhy?=
 =?utf-8?B?anNSdHI5MlUxUnpYTFd2Ui9Jc0FWenBDUVljWWh4WW5uVnZobnk4U3N0cGtE?=
 =?utf-8?B?ZmYvRzhZR0pNTkw0KzV1OHlEZS9TZm9lQTJTVWk5aDdvb1BKODJ6MGg0THFi?=
 =?utf-8?B?QmxyZ2lFbGcxa2p1QWJDUWFTTCtUNUxtaVNhQ0FKeVNuZmlFMWxIMUJyTld0?=
 =?utf-8?B?Qm4vbEl3d2JyeGlidDIrNVJLZTRGcklrbjFvRStNNnNVbmlSVVk1R0d1ZElH?=
 =?utf-8?B?eHpKZndkK3NkdUEzUWp5Z01pbGk5SFhzOG0wcGlYdVBHTlBnb3ZPMTcyVkg0?=
 =?utf-8?B?OFdVSjI0M3ltb2R2L2RVY3I1ZnhES2QxTzl6UmlPMkdHWi95UmdxcUdCYXY2?=
 =?utf-8?B?eUZmKzArbWxwWm5CTlh4SWY0RUFyempKdTYyejR5MzJUOVRGKzAxRDVob0Jp?=
 =?utf-8?B?SmlFZGEwOUZMeTFEdGRrQklBeEJDbEtPSk5JVTZuVDJHQVlIei9qRnpuWUVK?=
 =?utf-8?B?RzNUZDF1dHlUMjR6S0xMN2lveU9NRCtGRlFINzhMb2xUUVBMN0RFM1FZcU1x?=
 =?utf-8?B?Nk9pbVVRSWFsM0cyeUtxYzh1bkVKVGVJSm5FRElVTW03dDJiMXZGS0lReGxL?=
 =?utf-8?B?VGc0Vjg2RXQ2bVFwc3k3dHp6UXJ0THlCVmNMdTBFSnF5akxXdmU4bjNjUzQw?=
 =?utf-8?B?WE9URi9memMvTWRDZC9vYjZhcWtTTXg0K3F3dUFrL0RqS2ZrZHR4U2JFMGxK?=
 =?utf-8?B?eFBta2E4M3ozTkgvd0JNWnhOWGhGOTA1MkFjb3o2Um52NFJsZE9UazNWdVVG?=
 =?utf-8?B?MXZnNFUxSG1pS2ZKNVYrQzhOeitIdWIwcU9DNzBoSmVxQ0dmbW1jaTFnY2pq?=
 =?utf-8?B?K1ROYXMzUTg5MXJOOHZFT1pRTTJzczRwaWc4clF4dWJSYXFVZFBTamR0R3FP?=
 =?utf-8?B?UFo2MEx4QXdFTmExN041Mm5Ud0EwVUh2ZWF1MDRIMDJlZ3phcFg1R3psNFZz?=
 =?utf-8?B?UnZXTFZtS1dtRHQwMjVjVnpBRnJ4c3JCUE1pY0J0NEoreGRMejlFcjhlRkxX?=
 =?utf-8?B?Qml2YjJ0Z1ArdFdaNzZpMlliSnYzcENad01SMmwyS003OVdoeGxFRjFCOUg2?=
 =?utf-8?B?NjdmQlFkYmFqTXpsc2prUkdORVhHSkRaWjVTdVdINWV4a3dIbDVFeFFSdFdm?=
 =?utf-8?B?Q0dmMHBKbGh0NDFQTWg5MXBnSHpjNDFReCtnZHVhODF1bTU0amdKNnEzQks1?=
 =?utf-8?B?SjcxdUQ3TERzalZhd3l2eDk3bG9XaUNrN3h5bUwweWtISlpLRHRvc3V1MGxT?=
 =?utf-8?B?OXpKU08ydWdNcVMzZkp6ek5SdHF6V29KTXV2UVJqSURsejhLWmxjQldtb3R0?=
 =?utf-8?B?MkhiSTNsZGRrUU1TWXdLb1M3NUx1bzVhdVFWdU81OGwzVW9QTkpDdVRxbnBR?=
 =?utf-8?Q?nD/df4qarVx6CPBM=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b52280-f48b-469f-11bd-08da18675183
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:22:05.7088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: grp9EaATlAp/pMyvaIe2nTiH7iyJLWb+ZXwLfY0qnTq41p9yGRFbtzeKYuh15wY+wVwWDtMUxiF83OTn4e8SfTArKk/7cMdHGYhPCksN93Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-Proofpoint-GUID: OnUZp2jar2A1Wp1PwCpnrb5rkGHSVAoR
X-Proofpoint-ORIG-GUID: OnUZp2jar2A1Wp1PwCpnrb5rkGHSVAoR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=742 classifier=spam adjust=0 reason=mlx
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

