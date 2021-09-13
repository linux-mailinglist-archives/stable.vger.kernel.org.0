Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A044F40977E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241480AbhIMPhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:38 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:5292 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233162AbhIMPhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:32 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWXVu015200;
        Mon, 13 Sep 2021 08:36:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=w1WxVnzVRN8wrhvPxtQ3W4l2TE2xJo1JXBSp5co0y6o=;
 b=WFiCBnCXCIj9oniWTWOc/LmBugsN2/tngYtWg0orJpOu+iMX9bQM0eQywWKpy3pfzWkb
 kq0UHDDwiX/YQ+8iZgbDQ3It5HTlaZmb3LL63WzhPL4JUqftQ2EzxEIGFjMSf4HUNTbj
 vYdLSCFuFjCsPj5KFvHVTg8rPAeLJFSlwkharl+aJwOOJ8guiqQWlc2p4J3AnTvGpGpu
 YcdjcyJ98hqYxkGLDkv+PWClum9dxmElMjPx0zF2kJVNAEdfGPeYOObBttgp/+6hQfhA
 jO8/yZjx8bLS/eRGxpgrZvyFReEilee6BZNZUiiNB3CaXCSELKpP6mOxFKFWJfNiXEfu hw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b1kfn0pm7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:36:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Um4L5W+SUbDsxkIH8GdAg3qUJ620fj00usD58WFTYYqw68sQcfJ5ZDNEZLSqV3kYGJeQmodQZYQHeYxTtajOv/qhynHzAeUiF9xOFdq2JY0V20IOugVpQbeq5iuouXcmu1U+oZ9cXRagpK5346v918l++6sUsuPxG7J7JTsgXdGHkafkh0+e0mfLzNVgD7covivQaYcuZ04oOAwSbWETgNSQaQF7dZiD8/oAP7dJCiRfJBW46uu4duJfEuZRVjUcbdKb4uguxiw0LWncxvvnc7/EfCPV/GK6wqbaZ/NRPUTJLpx/oP2JanPM0hezSwZvX5T5gwvmvctOTSNtYJ22Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=w1WxVnzVRN8wrhvPxtQ3W4l2TE2xJo1JXBSp5co0y6o=;
 b=V2EhwLtpeKxDQNAhew6TrauGqGiWneEzlS8poFT1Zxrw6MUAXMC+ihOabi9zWNqcqvKjrodsQMUdMcb5yeklS3CkBYSShJLZachphJMD+DIIZkK9JvU0Hi15vkbRMrcx8pIAq64COiOaH2aE2iBuefMd44/pkLH6UwZa05Np716YXwsPJsAZXJeASlzgbklVISGTcDxNVpDRjxOZ970EfrQ8lhMybyo7IRRnu9iUq5yxmyHzoO7GJ/bxRJRtjeWO4HZV92Z0wb1jRViHW2qoOi/augUvyasB4zi8NnzGTFEbWrECO60a9KEOoKiPaWir9hKbjLbZujVQ4ALdOHpHoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 15:36:04 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:36:04 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 07/13] selftests/bpf: Test variable offset stack access
Date:   Mon, 13 Sep 2021 18:35:31 +0300
Message-Id: <20210913153537.2162465-8-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:36:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91289e02-1e06-42a0-80d2-08d976cc32a4
X-MS-TrafficTypeDiagnostic: DM6PR11MB4657:
X-Microsoft-Antispam-PRVS: <DM6PR11MB46572E038AE4BA205C8217D6FED99@DM6PR11MB4657.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:139;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IrVkyid1m+hlqDuxgA56t6l7KrcOvIZ4SlWLw8ptp7hNZmFkQmCgs9r34GDyqmUIizoEOoU2Kkb2QHzqn+hrgCNBG+zFrBF0U1/HrUBnvRWVrYWV/afNfn5q35T6vG/SjxWszyZ5KdqqHFx0jwxIrxXEcRMCmMVTCCXgfg3ciNE3WfdQquIhbF7uYe5hQhtAUs4F3JpbPZpVCpC5Kap/PXgwDAoTcqpaid2HDSa6N74p3iLVAJVyXkdCkdmXEj72HLtYbCSQx/V1OugnvjBd6ftEpizqdx1wrI6/D4xdYHDKemIRq6CXvz+JJs8EL+f6ZKgkobdqWUeUWikCNeQYgUp7aVPTtGTUH5Dti5PHXEI6LIpuTrH4sssaLr6IzNdc85j8VxEWe8AcLirTAhN9QyLc4frD2Xy+b4lx/ve9W24TvEZijX7knhx0ROFnAWv/gSLQRavA1HQQ0zt4zSNOiLxKLnnVjlFpCAyzyT0twZvRhO0No9ZbLPSTuV5cXSquF1mB6EuUXZImH7QfzhBBiFQmUj9+79ty7kWwLe1Tg6dSXTmgHyTDwfV/hJxpogct3yQ3m4eL+6eyccvtVFPT960hr8gEORwhjt/iy5+wpIwHQSkZye+8Ak1z6TqCS9L5reJ2SPquRyNCdLtBH6x0qeSV+PyWO2G3XXMJT2cASIcUfHLqXl4LoS/18u3+mWmb66sBGXVyyMzQrdY21Uln6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39850400004)(26005)(52116002)(478600001)(186003)(6506007)(1076003)(66556008)(66476007)(8676002)(86362001)(83380400001)(6666004)(38100700002)(44832011)(36756003)(8936002)(38350700002)(66946007)(6486002)(6512007)(6916009)(5660300002)(4326008)(956004)(316002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Ojp+BhuZK2+SwfsmvWjFwy4t9hisLkD9GuKbKawDi+eJSHAZnGtIMPxd4oD?=
 =?us-ascii?Q?nJzZkO24+/bXIoxrdCyuWZavinqJUinmc4jzeurSo7+faH3Z8iijk1VvlfFC?=
 =?us-ascii?Q?E7g6/frrTmzGqndzYELkccnJdQB+1soAbulQzPwDpYkiu8KCcZKlMeVpe5pA?=
 =?us-ascii?Q?fbKz8epufFBDhf4HEGXqvJeSWwMDPsWv6d2IeBQ02z+W08c3dIgT2Axq5nuZ?=
 =?us-ascii?Q?z3FnGzDUCSHty4w4avia7oOdrTFdglGivaX/6ffljoUCzBv+k9SgdOPBcNap?=
 =?us-ascii?Q?7SQVcQKNPAiSnXZxQ3TMqebVHdcLtJXTS25ZzSNsK+Kpp45XnzUFMaBDBfLx?=
 =?us-ascii?Q?1sDg3cCD4lf8M82tJRr1k1HiIzGky/IZ+7oankdBqYoPHWqF1kz0gRr3Y8sl?=
 =?us-ascii?Q?Nk52+n3/KQ7QZyi/6alPchlvunW6dOqbK7ek/uMqjCRNVB3Zq9g4tUVMhH7R?=
 =?us-ascii?Q?it0NPqXQBuc0CX2LHKf/mYfegjFY5NJSAo4FCFbYlRigl+4gRu7IeuGCQ7Xu?=
 =?us-ascii?Q?lud4fQeotnuz8clPGgeUCkTFGsOHdrqpfL3r6g0w5WNpo4Cwhd0lFMZElXMB?=
 =?us-ascii?Q?Ja9KNq1L3YM/nF6qtdE8qgkbgMw59gkemgamE9Ofi0M+xusbDKZ7R/4Jbnma?=
 =?us-ascii?Q?UwpesBnolKU5SCo5rc2cbjI4toyjqfJy+bYmQp0JPIg5jAZm0//sNn3t4L9O?=
 =?us-ascii?Q?Q6T/hri/Dt4i0jnbJCWx3+/kXsZ3MBtFJytRnLi2TWHSsp48+dqX48T69SjP?=
 =?us-ascii?Q?nuJuBtbdN2w+c63dCwJTmHMFbwr9CD9cn7P6awlmfurtcRv38eshXD1ImEXi?=
 =?us-ascii?Q?bxlnMvY//G2BrbfYYTw89APBLvEhupxtmRXrJx/4ypmm5Hrdr9c74+/27c2M?=
 =?us-ascii?Q?MC8tfxw3lAGyoVop2YHp1n3Y5Qwa8wrIb3IVIgV+Iy7kg8/8gKwbvI7mLrrs?=
 =?us-ascii?Q?JxE7yPOdS1DSxNVF8l4R13UJHzxZ/+1vovmJAhSPcX6B2/vRyjAzYmErKtsu?=
 =?us-ascii?Q?vCpbRlSrywnWW/1B7w2absv4sphIqqxa4XtHfON9euSbP8XCU4Xu9y+Cjk/9?=
 =?us-ascii?Q?MPlHQSBFUHO2xKM78l1HXdbuElrGWMtWETYePb+lOtDF9xh3sga/5UKU4Lk0?=
 =?us-ascii?Q?ZBLmmOaLIyUhOea2FP4rsSREp6QAI39OCDK2MxLPgM/UFsR996sloeBv6ZvS?=
 =?us-ascii?Q?qh+bUYT8Ldkro2yhnrk+Gs1IrmCwdqr7+elHV/XIiJbvXRu+l1M7XQmAaXZU?=
 =?us-ascii?Q?Uc15vc1h1NbnJw8nV44/mVi4EE4SHiO4L0OrFiBFqccnHe2c8rUs9XbjfQIZ?=
 =?us-ascii?Q?JH8zacuBPFsMwzQLx7YgGC2g?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91289e02-1e06-42a0-80d2-08d976cc32a4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:36:04.6097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rpN5zDDvWTVwYEsTjXeNxDLixt0cDD3mcOjIRLuF/4gKu5PKSqi19NKLuk/muTARtZZxFjLbTNUJWGNV88D0URaKcXeF8YmqlIrcx9L2wVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4657
X-Proofpoint-ORIG-GUID: ygx_0Wvk_95wVMZbj164wYNpncNkjtCC
X-Proofpoint-GUID: ygx_0Wvk_95wVMZbj164wYNpncNkjtCC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit 8ff80e96e3ccea5ff0a890d4f18997e0344dbec2 upstream.

Test different scenarios of indirect variable-offset stack access: out of
bound access (>0), min_off below initialized part of the stack,
max_off+size above initialized part of the stack, initialized stack.

Example of output:
  ...
  #856/p indirect variable-offset stack access, out of bound OK
  #857/p indirect variable-offset stack access, max_off+size > max_initialized OK
  #858/p indirect variable-offset stack access, min_off < min_initialized OK
  #859/p indirect variable-offset stack access, ok OK
  ...

Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 79 ++++++++++++++++++++-
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 6b9ed915c6b0..1ded69b9fd77 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -8495,7 +8495,7 @@ static struct bpf_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_LWT_IN,
 	},
 	{
-		"indirect variable-offset stack access",
+		"indirect variable-offset stack access, out of bound",
 		.insns = {
 			/* Fill the top 8 bytes of the stack */
 			BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
@@ -8516,10 +8516,85 @@ static struct bpf_test tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.fixup_map1 = { 5 },
-		.errstr = "variable stack read R2",
+		.errstr = "invalid stack type R2 var_off",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_LWT_IN,
 	},
+	{
+		"indirect variable-offset stack access, max_off+size > max_initialized",
+		.insns = {
+		/* Fill only the second from top 8 bytes of the stack. */
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -16, 0),
+		/* Get an unknown value. */
+		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+		/* Make it small and 4-byte aligned. */
+		BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 4),
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 16),
+		/* Add it to fp.  We now have either fp-12 or fp-16, but we don't know
+		 * which. fp-12 size 8 is partially uninitialized stack.
+		 */
+		BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+		/* Dereference it indirectly. */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+		},
+		.fixup_map1 = { 5 },
+		.errstr = "invalid indirect read from stack var_off",
+		.result = REJECT,
+		.prog_type = BPF_PROG_TYPE_LWT_IN,
+	},
+	{
+		"indirect variable-offset stack access, min_off < min_initialized",
+		.insns = {
+		/* Fill only the top 8 bytes of the stack. */
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+		/* Get an unknown value */
+		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+		/* Make it small and 4-byte aligned. */
+		BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 4),
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 16),
+		/* Add it to fp.  We now have either fp-12 or fp-16, but we don't know
+		 * which. fp-16 size 8 is partially uninitialized stack.
+		 */
+		BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+		/* Dereference it indirectly. */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+		},
+		.fixup_map1 = { 5 },
+		.errstr = "invalid indirect read from stack var_off",
+		.result = REJECT,
+		.prog_type = BPF_PROG_TYPE_LWT_IN,
+	},
+	{
+		"indirect variable-offset stack access, ok",
+		.insns = {
+		/* Fill the top 16 bytes of the stack. */
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -16, 0),
+		BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+		/* Get an unknown value. */
+		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+		/* Make it small and 4-byte aligned. */
+		BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 4),
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 16),
+		/* Add it to fp.  We now have either fp-12 or fp-16, we don't know
+		 * which, but either way it points to initialized stack.
+		 */
+		BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+		/* Dereference it indirectly. */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+		},
+		.fixup_map1 = { 6 },
+		.result = ACCEPT,
+		.prog_type = BPF_PROG_TYPE_LWT_IN,
+	},
 	{
 		"direct stack access with 32-bit wraparound. test1",
 		.insns = {
-- 
2.25.1

