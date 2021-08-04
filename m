Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D6E3E0656
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 19:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbhHDRKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 13:10:05 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:47218 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230161AbhHDRKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 13:10:04 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 174F5qhp001836;
        Wed, 4 Aug 2021 17:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=wsbf03oVhpdvc0vFYjS3L6pHDKYVXtNMXViwIjscEW8=;
 b=BIbv0s+j02QM/8Ph8VtCwaoojZEegec3zxgF14uLCLWoLlKHsCwOKOZ8g/sXIzZlp5YS
 ON8/Vzp+KGdT+JzdCXFPJEAwtzqT0lkaFOHIR9yp+zqm4KjV6uk3h8tdKg5w+yXYCMRZ
 Rycoq8Eeeb+k3Dd1dxdMaPCrJxAPNoPkCPKDmhyCuca5JWkVhsjS7hqxGhOf+d45/4dP
 78r0SzPsyxQ/CZ9+zjSECnp5FzkbBOq8Moj/oKQcS49aNGehFa6EO6sc6CDbCftKvPKS
 e+yhH1W9kSQ5CLw+UrZItkEkBOvAvU9ThZU+oxkS+tSZzDje62I9pECw0AAl7+EmDBXb Ew== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com ([104.47.57.173])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a7w718350-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 17:09:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1wZVWqJYSC7ALNR6Dl8phHbQAv5beHdvwrwjvpQntxo2VjAZq0zwz0BbAfZw7qF+ZeFmEBUwlcqHTj6UW083vyi6O9eaIMneLACFdozDrXow4meFqZZhoROsjCg6Gp8lKmkhu51SxgcL9tfneMgY11PQDCuAVA7dnnUGuw0IdTmtngfzPBwlhwtxX/AwV6zk/ozcG5rA5HhDKKByO2KWqRNxOZkPENcW+XsVyxjOYG/PvXX6XF2ZJI855d+beb99DwlgeZO2vaGmqzLDmFMETEPXX7T84UX1igVMTfmW359X1F31MCb/ND4hyT0R7K239moCi6KTV2022FtyKMtKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsbf03oVhpdvc0vFYjS3L6pHDKYVXtNMXViwIjscEW8=;
 b=PdryJ/xMXxW3KiLaWkrbUDdNVFNVmIMdgW21oVwU7KmH4SNBgpiMLF41z+mMtujy8CkfBITNopsgo+UfVzKdRKyJS3Wi4ktkRVsP1hdGR9C0qxvw/e2yDzUu/5al89GRq9pZMruSPG+flZFQe3iqHYLluqIV53MxP9JxbUAq5zMj58WmiXPJYiKuEO533fbfB4h3bl3SDh4v/4ACuFsontfZBm1wSdSPTKt1PgMgi2lgY+FXuJoXyAj+aI7oabg2+CHUx6Jhc1DKLLnXncUBCJioVc3PHjUPWSF9cQ5wfaJK/IcsvVjQC8p/Bks/v2W9f8b74X4VtBv+zOugBvR5cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1834.namprd11.prod.outlook.com (2603:10b6:3:113::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 17:09:38 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 17:09:38 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.10 4/6] bpf: Update selftests to reflect new error states
Date:   Wed,  4 Aug 2021 20:09:15 +0300
Message-Id: <20210804170917.3842969-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
References: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0033.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::46) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1P190CA0033.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2b::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 17:09:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a0f1cc3-da8d-49d5-2573-08d9576aa43d
X-MS-TrafficTypeDiagnostic: DM5PR11MB1834:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1834DC09211846865B78F290FEF19@DM5PR11MB1834.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQOVu1xqpBM0WXXY6X2joyVl31WsdWTvMzhMY6R1XSYtVQ+q0LQnRwL9L2QNilBhaiSp8oMD4qQxzyYbY7CIZ0P+vN2CsZC0uabMG7f84jczh9ehN0Nsjz7n1CMUCcrggUt1GYEdsidgznPWg3pXezqvK3Uj+zLN9FJpgKFH3shU1SQguoiIGIwwIXxPRwTJubddpbNsGsnQ3tYkF6vAO82PgOao7uvHUZPveJcHSw3DxHp+3+47U+gnXeVIHM1K7I0DYH2Q5+EfwhtD8NauRJo3KbeRsyjyK2adrcRf+G+7OMtrSo10ANciRAKycrMkX/S3W9ZON7JpXYfvsfJmPThPwpcJ+Lec0xxcjh1A/4Rfq+BoutVxIPMYghazpS8nXxEZOtx+zDnw/huH+4T9K/7wrXmSwnagB2dsC54h8Gsi/NpyaJU078rXrlCgnNedk9Vzrax0Ukd06gEj8lNipo/sacDcuZLxKEAD3Tl7yHIViWWWFMeKzrDcA8RHc9d/ELTbxL3Tf44GziLAxw56k2DHEhtNrYoOwvqshwEt+1+/BGuSsy+uE7ZCGCZQWtlP480DnM4/h/h8zoKt04HhPGUAlIpV+4HNQ7z68xJ3JZcfpYuILXpdPya4tw4R/dI36irQhLFHYHIZaQYP2xcF+gFwHTT8vzWhx88Wu/VLuKDmzAZj8Dvch2wQnU7aZaGL1eelaktuWhYw1nwOh3v59g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(346002)(376002)(6666004)(38100700002)(316002)(6506007)(1076003)(86362001)(38350700002)(52116002)(83380400001)(478600001)(30864003)(44832011)(2906002)(5660300002)(8936002)(956004)(6486002)(2616005)(4326008)(6916009)(186003)(36756003)(66556008)(66476007)(8676002)(6512007)(66946007)(15650500001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/YeiJZ4v516obiplh+XIry68lW6sxgQ0BhPG2h88zje6Dkd8Q9I3XXfNHwc1?=
 =?us-ascii?Q?vFKdLmkj3cioRrUmi+p7BsjGqMHK3P1Sl6/ly1LEzDd4dOktqNeEnEhnEwck?=
 =?us-ascii?Q?TbwRmZyrbT/ztkvaeLgsE8op/lVPSCc/VSstRHBliszkDGcrBafXwWa6OWVm?=
 =?us-ascii?Q?pc/m4Qw9VQrJ53WZ/x6Zkw9pPLdyun3FK5ikT7bTSy+KEHq1iwyNCL6xzmho?=
 =?us-ascii?Q?w+EuHvO2kcWkYoDevIW3hUpPLhvQJDANES6VmB7qlPPWona3/1/Li0vOomGe?=
 =?us-ascii?Q?gle+auT6cD8jt2IZgaiwfwmpMDFaQ+e2eS1LtXTDpVEsXn62PqM0JEl5UwE8?=
 =?us-ascii?Q?MswfDqmR8G0PZVKBD6UxK2KvQpSrCynhKJMIowzSEnh2IlLIVCSpoj2nvvVy?=
 =?us-ascii?Q?Rb71YgJjWuoom7sF1d6pAgWZSSV8CH4nX3jPPtAduLSwoaAvWRLrCAU2XM1g?=
 =?us-ascii?Q?aMj1BInmNYc1tKtl3XX04ZQvFnC0IbGqv/0H6hjWR6zUkMR7Jz282Jr5vfPH?=
 =?us-ascii?Q?V/ZexPpV6GlY3Hv/1KzmLzTe9Lff8ZDtISDoiOa9WY8kQh51db8PLQW2y94Q?=
 =?us-ascii?Q?xjkQl5IeRg7lX6Va7LoXFOwr7jGvBn6lrUPgts1RVPP6WJzCJJYEswovK/fn?=
 =?us-ascii?Q?Pqi+zZXGTfmhiE138Zxkb08TCfvzbtHY7Eli+irFDhGLlHYDFCeh+7sG4igr?=
 =?us-ascii?Q?V/q8knOuadiXUbqtJkTZgm+B8oApKoVt7TLe1vgvrdb4voPLXQRtLHFOKkZ4?=
 =?us-ascii?Q?YnDkA42l7pB17dALx96lBQVFpzFJS4+7Ap8Poyu9JtYfEIddzfq5F7fx9Z/b?=
 =?us-ascii?Q?Bnf/ScJlY1Df7cfbRgJ1LinHS2QJdYKPdl6WnvAEeC6Z0jWh8/V+wkbrzs11?=
 =?us-ascii?Q?F+WgO13q6FBLzLxNDnj5oKyEbjp41G9Qs9hVhARCl3g1Iq06+obw0rlxt2yc?=
 =?us-ascii?Q?U85NeWYWlMl0DU4S8DgD+naSiSaUC/LOtwfzttI0GtR40NWaVggDPStBRRjZ?=
 =?us-ascii?Q?gHsRsGe04M3pt2g4oiMl4U5GDq7flKgvA9N0FnAogQBQzGKeEZcpWd+VzwIs?=
 =?us-ascii?Q?AGiOCXCXYviUcc/TNqMsT4dhaYfYSINMWeynPebJ8zbg420i2Mu7wpyKfaf5?=
 =?us-ascii?Q?DKBHCbkZgrfl/ZVNoY/7GyqXvUZYrl4rsyT/HgVN/7Gungb9zwYgRIotULSc?=
 =?us-ascii?Q?8+zI3+cRLb+O/cvKCsAYqAgO7BtZylBbDEA2rqwkiYgGpgYaTZoq0dHBR0pI?=
 =?us-ascii?Q?Wgt1Gmf+rrolo7bBDiI6gX7CAQnBb0DbpIIadtOEoPzcysGIlwClTmK/kLmW?=
 =?us-ascii?Q?5ZqckFzazGjJCUaaI79Sae0s?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a0f1cc3-da8d-49d5-2573-08d9576aa43d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 17:09:38.5635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aT2M24XVYnWDuLtinX0WDxEZ2BSQItSQTdc9+iqOUMbYBsG03sqK/bn7+aViOdqRD+PCrxhJhu/mL4rrpyHfqsMZfgdPVuQNeaZuM+VMIQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1834
X-Proofpoint-ORIG-GUID: F0STlddMLRUl9ls25vJyep8vjmwmQzul
X-Proofpoint-GUID: F0STlddMLRUl9ls25vJyep8vjmwmQzul
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-04_05,2021-08-04_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040098
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit d7a5091351756d0ae8e63134313c455624e36a13 upstream

Update various selftest error messages:

 * The 'Rx tried to sub from different maps, paths, or prohibited types'
   is reworked into more specific/differentiated error messages for better
   guidance.

 * The change into 'value -4294967168 makes map_value pointer be out of
   bounds' is due to moving the mixed bounds check into the speculation
   handling and thus occuring slightly later than above mentioned sanity
   check.

 * The change into 'math between map_value pointer and register with
   unbounded min value' is similarly due to register sanity check coming
   before the mixed bounds check.

 * The case of 'map access: known scalar += value_ptr from different maps'
   now loads fine given masks are the same from the different paths (despite
   max map value size being different).

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/verifier/bounds.c |  5 -----
 .../selftests/bpf/verifier/bounds_deduction.c | 21 ++++++++++---------
 .../bpf/verifier/bounds_mix_sign_unsign.c     | 13 ------------
 .../testing/selftests/bpf/verifier/map_ptr.c  |  4 ++--
 tools/testing/selftests/bpf/verifier/unpriv.c |  2 +-
 .../selftests/bpf/verifier/value_ptr_arith.c  |  6 ++----
 6 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index 57ed67b86074..8a1caf46ffbc 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -261,8 +261,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	/* not actually fully unbounded, but the bound is very high */
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root",
-	.result_unpriv = REJECT,
 	.errstr = "value -4294967168 makes map_value pointer be out of bounds",
 	.result = REJECT,
 },
@@ -298,9 +296,6 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
-	/* not actually fully unbounded, but the bound is very high */
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds, pointer arithmetic with it prohibited for !root",
-	.result_unpriv = REJECT,
 	.errstr = "value -4294967168 makes map_value pointer be out of bounds",
 	.result = REJECT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/bounds_deduction.c b/tools/testing/selftests/bpf/verifier/bounds_deduction.c
index c162498a64fc..91869aea6d64 100644
--- a/tools/testing/selftests/bpf/verifier/bounds_deduction.c
+++ b/tools/testing/selftests/bpf/verifier/bounds_deduction.c
@@ -6,7 +6,7 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "R0 tried to subtract pointer from scalar",
 	.result = REJECT,
 },
@@ -21,7 +21,7 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.retval = 1,
@@ -34,22 +34,23 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "R0 tried to subtract pointer from scalar",
 	.result = REJECT,
 },
 {
 	"check deducing bounds from const, 4",
 	.insns = {
+		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
 		BPF_MOV64_IMM(BPF_REG_0, 0),
 		BPF_JMP_IMM(BPF_JSLE, BPF_REG_0, 0, 1),
 		BPF_EXIT_INSN(),
 		BPF_JMP_IMM(BPF_JSGE, BPF_REG_0, 0, 1),
 		BPF_EXIT_INSN(),
-		BPF_ALU64_REG(BPF_SUB, BPF_REG_1, BPF_REG_0),
+		BPF_ALU64_REG(BPF_SUB, BPF_REG_6, BPF_REG_0),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R6 has pointer with unsupported alu operation",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
@@ -61,7 +62,7 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "R0 tried to subtract pointer from scalar",
 	.result = REJECT,
 },
@@ -74,7 +75,7 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "R0 tried to subtract pointer from scalar",
 	.result = REJECT,
 },
@@ -88,7 +89,7 @@
 			    offsetof(struct __sk_buff, mark)),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R1 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "dereference of modified ctx ptr",
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
@@ -103,7 +104,7 @@
 			    offsetof(struct __sk_buff, mark)),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "dereference of modified ctx ptr",
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
@@ -116,7 +117,7 @@
 		BPF_ALU64_REG(BPF_SUB, BPF_REG_0, BPF_REG_1),
 		BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R0 tried to sub from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.errstr = "R0 tried to subtract pointer from scalar",
 	.result = REJECT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c b/tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c
index 9baca7a75c42..c2aa6f26738b 100644
--- a/tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c
+++ b/tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c
@@ -19,7 +19,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -43,7 +42,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -69,7 +67,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -94,7 +91,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -141,7 +137,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -210,7 +205,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -260,7 +254,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -287,7 +280,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -313,7 +305,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -342,7 +333,6 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R7 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -372,7 +362,6 @@
 	},
 	.fixup_map_hash_8b = { 4 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
 },
 {
@@ -400,7 +389,5 @@
 	},
 	.fixup_map_hash_8b = { 3 },
 	.errstr = "unbounded min value",
-	.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 	.result = REJECT,
-	.result_unpriv = REJECT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/map_ptr.c b/tools/testing/selftests/bpf/verifier/map_ptr.c
index 92a1dc8e1746..2f551cb24cf7 100644
--- a/tools/testing/selftests/bpf/verifier/map_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/map_ptr.c
@@ -75,7 +75,7 @@
 	},
 	.fixup_map_hash_16b = { 4 },
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 has pointer with unsupported alu operation",
 	.result = ACCEPT,
 },
 {
@@ -93,6 +93,6 @@
 	},
 	.fixup_map_hash_16b = { 4 },
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R0 has pointer with unsupported alu operation",
 	.result = ACCEPT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/unpriv.c b/tools/testing/selftests/bpf/verifier/unpriv.c
index c30afb09ab6a..c7854d784a5d 100644
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -504,7 +504,7 @@
 	BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, -8),
 	BPF_EXIT_INSN(),
 	},
-	.errstr_unpriv = "R1 tried to add from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index 3868fbea316f..7ae2859d495c 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -21,8 +21,6 @@
 	.fixup_map_hash_16b = { 5 },
 	.fixup_map_array_48b = { 8 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R1 tried to add from different maps",
 	.retval = 1,
 },
 {
@@ -122,7 +120,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different pointers or scalars",
+	.errstr_unpriv = "R2 tried to add from different maps, paths or scalars",
 	.retval = 0,
 },
 {
@@ -169,7 +167,7 @@
 	.fixup_map_array_48b = { 1 },
 	.result = ACCEPT,
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "R2 tried to add from different maps, paths, or prohibited types",
+	.errstr_unpriv = "R2 tried to add from different maps, paths or scalars",
 	.retval = 0,
 },
 {
-- 
2.25.1

