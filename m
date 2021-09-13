Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B78409784
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhIMPhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:45 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:40908 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229926AbhIMPhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:37 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWGwf016966;
        Mon, 13 Sep 2021 15:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=WNsFSyfgbY7j9WL7LmAOr2lR9R3fIemNDgddZ+uJTWc=;
 b=RidFtmy5sjV4mHMayDitft4CjViFBUxBVC71ylpkI6H1ryURhNyJ+QePDhDAqbw/pOcp
 m11PoTI1do6f06LIjk2PSIwvurx2wwMI8GJJ/oX0LgomWzN6AinDkdFJ3tz2YusnJ9RC
 s2WAz5T0KkfwbJQ4YAorBSPR6DkqkORAPNZEIFIlybowEvjThTgzQd5z/8FPgkqWt4K7
 HpjrK1nNGafcjlzaolOw2vk9NdbeyqPWKx4dtmiT8LfW6wMkPyDsFexppUz1r+9kKOut
 +WzyUfm6oJV4p7q5+y4PNAjs9AammSZpjNDFC3cjZ6eS9crA/u9p+/9dsEeXtFeMBVx/ LQ== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b26m1854b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 15:36:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4cKUs3+gSVdu3R7iafiKsqer0ML8+/QNdILm2Nxb0uq0vdNFZOTTK+ada6eLSkpv62i2V3gLwy9uOyuudr5qCbU2KxdpkUV6emfUWxpDUMX9VBQO+KdU32Rkl8uW9CitrCwgkS19rIOCt7QOVztLxtXjUxB50RQNNjRbQn7OSkSkN3cFBuvHNSjkXup4aMiTsX3MVRe11SwWA3YIWBfN8MHL2ySfyayh0IxVkXPzzcoGVoe/7yWJ4R5Xylmrcsa5SeEgBOCtformjPdBW8W9+eSkpZQxVPSbdEykiFe4BziblaY+zr+QDB3NkNbFAFVKaZjgOz6EMs2XsuU3oEMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WNsFSyfgbY7j9WL7LmAOr2lR9R3fIemNDgddZ+uJTWc=;
 b=fXBQHlOi0UJBq+FodKbaPYBwoBoYr2umqyEzk5KXucP2zf2RZSR6CXM3ea0y0yrfXFes6j+cBDXzWZ8L6nl0ytcma08X5fbGfyCAiwxroj8FXvegMWmVZ7JDBg2eBi4bCIf8l8QCnUPfttLMkMIMsi/n14dBtIXESc71g2Wo3Gdh2V44pEFmVo3vjn4hCPvmAMZrhE6BYFwvcBXdH7Dz8mecOxRYXkmXvuzswzJnYrwZKVhJCv6S1KyfNTCAgZMFxYCw70rMi4m6Rd5gs1yStQvswDIuaO/4cl5jP4sU0PIUMRsQYM84sv/mADQLJqN0T/hUNoylpGWc/c4Sdpor2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2201.namprd11.prod.outlook.com (2603:10b6:4:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Mon, 13 Sep
 2021 15:36:06 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:36:06 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 08/13] bpf: track spill/fill of constants
Date:   Mon, 13 Sep 2021 18:35:32 +0300
Message-Id: <20210913153537.2162465-9-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:36:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02f070a7-87a7-454c-3d03-08d976cc335d
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2201:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB22015717B9C2E20941CDAAB8FED99@DM5PR1101MB2201.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJHpNUKX/VNoOoteKSML+D2SwpK3+I1DC/BhAIiWNSGcFO5RwvyfNlXRObtuSacn0dp9KHbcztzZ+FIfLT2lG9vbrlwrVeaSzJsQWDwZ9nMCD5acArCf54H4U6kLVSQVGKN+ja9IRz7EVcu3UAHm9UNKUO94ay8jwy7+h8JKRKwZlyvMBM1rvdUL7yuJ0r+V7Qolqp0OQIEsII9XV0zsPLob39HyswBk4HAgGN1sa+ZJFjUd3yAts9K/qPlxKUmcHtiCW41bYVztf0G7Xl9mZ4qLHshGBBqjwWRxGAKHO/T9oUkkCOUC0H4pqj3FLEgvxvXUhtdcGMY3Dc/5E19ZrDiPoFZlMVh4Lw8rPcqmwd0S9vcDXdRlWwKQG8scWn/xe3pUcVe2Jf/RpvZadKW2Jjr0pgevxbsVLZzFQabD6atSs6bCHh2jpgucEpZfU6J2XZdWDJAupyIzVYG0CtSsK66XZYyLaaLxN7U60MBraDYZDKfBLLyxqS+XaxtOOL4d83aQ4u0+ta7clli3+XR7Plmnb/fIYyRtGX1LTB30yb8YXdV/dF7bnV1BsMY6fgbmbqn2ZKJNoiE30e5NsGflTbQVeDtvc7b/Rimeu8GaZKjxeW45jPqJEHYv4hhP6x7DvXRx234TElMmRbQNqVVyknpq30LZkJzA5NefuRYq3iQI4Wj4JnePEIzxg+jZLbazZMsB0jpU/FJb/ROkZKpAnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(376002)(346002)(52116002)(6916009)(316002)(6486002)(38350700002)(6666004)(86362001)(5660300002)(2616005)(4326008)(8936002)(26005)(38100700002)(6512007)(6506007)(956004)(83380400001)(478600001)(1076003)(36756003)(186003)(44832011)(66476007)(2906002)(8676002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ijzzxHOT6+hWihnwFE57hSD1xobmdW6FXSAfTc8ClRGjwtK3V+wI/XiJmjLf?=
 =?us-ascii?Q?DvR38hxSWFiJvLf6yyWEuVNDL1WVlDK262JFnovxTfykhgHqZxpVRAonI+/R?=
 =?us-ascii?Q?/7Q5+9rpiiULy+S9wTaHRcSRtTamWa32D2OXKGAo3NBPwqUQkfMdBPIfdbLq?=
 =?us-ascii?Q?zTPN1IBbfpolM1eqTxRRqQcGKjsQnheIldTuAz/8I+v/yHCRHv5cDm9j8v10?=
 =?us-ascii?Q?273LSSGvIXeSsUa1E1TDj9iO16YaO5eCVz2c2xqi8/s/ozjBW0ZWxCaedJUd?=
 =?us-ascii?Q?sXTq29s63oPjkw21q9sifeA7mtqqxeuNixLQXNN1DRbIiNLL1ZpTN9fpDLrA?=
 =?us-ascii?Q?x/WVRUuAOPq7eN8ZHcy9pf1acHdU8G5J6kE4U/MKYSfCSq3vL12u7FKSOW3w?=
 =?us-ascii?Q?kog3tyRuTkYIGJzDvsa6TUIzDQYcJrfmJMsskUFelsBEzSE7DKobEJijW0KW?=
 =?us-ascii?Q?mHSOGJgF5dYpG3RNW5xXDEQYPDOlNRQ5fV1wT+meuJgj4pNaC/OrI8eRC5+2?=
 =?us-ascii?Q?nP4LaKTtprIM/aWs3Xfi01eGW3+2Id/oVEYIS5JP0BrF88N7OUzSit1c37uu?=
 =?us-ascii?Q?hPA0hnEMd7VdIo8U5Z6JAXpJn/ffsUxTidJ4ra7ykyuSEQARTV1hrSyLnMiV?=
 =?us-ascii?Q?sFZyQvq1YeFDda9/n4aXydu18Dtuwa3FS5mn1K5Zklxtfae+ccwjwZafpPaO?=
 =?us-ascii?Q?aGaS03n4BsXw7iIzAztrmrBGwi06yDEUIlo+x52PXVtM/DfW9jex3VTUTrYU?=
 =?us-ascii?Q?d38/JroUB7oEuM3qCRRw4gFZ/5wpU2fKlQB6zmdPU1cNt+tn3ZssvQKEXM6Z?=
 =?us-ascii?Q?fPbAllwutKoDkHAJyV+IlpSs20XyDvlg40jC8bvYQ9NgQko/zWhru3rIogz6?=
 =?us-ascii?Q?ZRZWwCHGqpEQk6nF019FkqiCHwOE36Rc5l9PgXnFd1sB3lzD8omqFjYKdGBN?=
 =?us-ascii?Q?+bMNv6nlhv8jtIGUrMf8l5v+X0vlAqmulqVT/q8eTwsfNAMnSVVg7qd+vMlu?=
 =?us-ascii?Q?17OLkdg5GGVUfzUk+jpzr+ORrkXaFU3Ri+I8xdXlpVtWNNN1Fccs5DkpA4oV?=
 =?us-ascii?Q?qEbrNJKtzxvLagKRldVkRHlwXVB1FU8LRTiGQHbhOgzZxLtI1RSpMJd9eGUU?=
 =?us-ascii?Q?OAzImFN7/D1e51vNNTDr8lcdc6rRnfHUO12V5gHydn/VzgR6GjaeWbz6pB+I?=
 =?us-ascii?Q?1gnXrMvdAUtFGfJlOX1WiGSqtD/j2NjzpBa/l1ozz3ujVBtegmXcJ1mQaCyL?=
 =?us-ascii?Q?T2gBLEPz+HrNO8657kHH0MhXVxL9aT8KQFM9OxIn29EoOpvgtRvXjRF1p4iL?=
 =?us-ascii?Q?UgHtMzI7IKdsFJfrGKWIRJXz?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f070a7-87a7-454c-3d03-08d976cc335d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:36:05.9667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +mRhuDTKdmr7Ff/sdKC+kM+u6CMQeOo3tna6Iu//VBWGf9LVg31gJFWOBsf/Z/JMNDDTZnmDjRoN/TZzvmimYuVkdsHmtuDPAuuW/KrWmu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2201
X-Proofpoint-GUID: VJ5Iw4rb49tQRFPNWD_mdA4qgSTBrRb4
X-Proofpoint-ORIG-GUID: VJ5Iw4rb49tQRFPNWD_mdA4qgSTBrRb4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit f7cf25b2026dc8441e0fa3a202c2aa8a56211e30 upstream.

Compilers often spill induction variables into the stack,
hence it is necessary for the verifier to track scalar values
of the registers through stack slots.

Also few bpf programs were incorrectly rejected in the past,
since the verifier was not able to track such constants while
they were used to compute offsets into packet headers.

Tracking constants through the stack significantly decreases
the chances of state pruning, since two different constants
are considered to be different by state equivalency.
End result that cilium tests suffer serious degradation in the number
of states processed and corresponding verification time increase.

                     before  after
bpf_lb-DLB_L3.o      1838    6441
bpf_lb-DLB_L4.o      3218    5908
bpf_lb-DUNKNOWN.o    1064    1064
bpf_lxc-DDROP_ALL.o  26935   93790
bpf_lxc-DUNKNOWN.o   34439   123886
bpf_netdev.o         9721    31413
bpf_overlay.o        6184    18561
bpf_lxc_jit.o        39389   359445

After further debugging turned out that cillium progs are
getting hurt by clang due to the same constant tracking issue.
Newer clang generates better code by spilling less to the stack.
Instead it keeps more constants in the registers which
hurts state pruning since the verifier already tracks constants
in the registers:
                  old clang  new clang
                         (no spill/fill tracking introduced by this patch)
bpf_lb-DLB_L3.o      1838    1923
bpf_lb-DLB_L4.o      3218    3077
bpf_lb-DUNKNOWN.o    1064    1062
bpf_lxc-DDROP_ALL.o  26935   166729
bpf_lxc-DUNKNOWN.o   34439   174607
bpf_netdev.o         9721    8407
bpf_overlay.o        6184    5420
bpf_lcx_jit.o        39389   39389

The final table is depressing:
                  old clang  old clang    new clang  new clang
                           const spill/fill        const spill/fill
bpf_lb-DLB_L3.o      1838    6441          1923      8128
bpf_lb-DLB_L4.o      3218    5908          3077      6707
bpf_lb-DUNKNOWN.o    1064    1064          1062      1062
bpf_lxc-DDROP_ALL.o  26935   93790         166729    380712
bpf_lxc-DUNKNOWN.o   34439   123886        174607    440652
bpf_netdev.o         9721    31413         8407      31904
bpf_overlay.o        6184    18561         5420      23569
bpf_lxc_jit.o        39389   359445        39389     359445

Tracking constants in the registers hurts state pruning already.
Adding tracking of constants through stack hurts pruning even more.
The later patch address this general constant tracking issue
with coarse/precise logic.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[OP: - drop verbose_linfo() calls, as the function is not implemented in 4.19
     - adjust mark_reg_read() calls to match the prototype in 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 86 +++++++++++++++++++++++++++++++------------
 1 file changed, 63 insertions(+), 23 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3168f331258e..ce051c0b9a54 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -963,6 +963,23 @@ static bool register_is_null(struct bpf_reg_state *reg)
 	return reg->type == SCALAR_VALUE && tnum_equals_const(reg->var_off, 0);
 }
 
+static bool register_is_const(struct bpf_reg_state *reg)
+{
+	return reg->type == SCALAR_VALUE && tnum_is_const(reg->var_off);
+}
+
+static void save_register_state(struct bpf_func_state *state,
+				int spi, struct bpf_reg_state *reg)
+{
+	int i;
+
+	state->stack[spi].spilled_ptr = *reg;
+	state->stack[spi].spilled_ptr.live |= REG_LIVE_WRITTEN;
+
+	for (i = 0; i < BPF_REG_SIZE; i++)
+		state->stack[spi].slot_type[i] = STACK_SPILL;
+}
+
 /* check_stack_read/write functions track spill/fill of registers,
  * stack boundary and alignment are checked in check_mem_access()
  */
@@ -972,7 +989,7 @@ static int check_stack_write(struct bpf_verifier_env *env,
 {
 	struct bpf_func_state *cur; /* state of the current function */
 	int i, slot = -off - 1, spi = slot / BPF_REG_SIZE, err;
-	enum bpf_reg_type type;
+	struct bpf_reg_state *reg = NULL;
 
 	err = realloc_func_state(state, round_up(slot + 1, BPF_REG_SIZE),
 				 true);
@@ -989,27 +1006,36 @@ static int check_stack_write(struct bpf_verifier_env *env,
 	}
 
 	cur = env->cur_state->frame[env->cur_state->curframe];
-	if (value_regno >= 0 &&
-	    is_spillable_regtype((type = cur->regs[value_regno].type))) {
+	if (value_regno >= 0)
+		reg = &cur->regs[value_regno];
 
+	if (reg && size == BPF_REG_SIZE && register_is_const(reg) &&
+	    !register_is_null(reg) && env->allow_ptr_leaks) {
+		save_register_state(state, spi, reg);
+	} else if (reg && is_spillable_regtype(reg->type)) {
 		/* register containing pointer is being spilled into stack */
 		if (size != BPF_REG_SIZE) {
 			verbose(env, "invalid size of register spill\n");
 			return -EACCES;
 		}
 
-		if (state != cur && type == PTR_TO_STACK) {
+		if (state != cur && reg->type == PTR_TO_STACK) {
 			verbose(env, "cannot spill pointers to stack into stack frame of the caller\n");
 			return -EINVAL;
 		}
 
-		/* save register state */
-		state->stack[spi].spilled_ptr = cur->regs[value_regno];
-		state->stack[spi].spilled_ptr.live |= REG_LIVE_WRITTEN;
+		if (!env->allow_ptr_leaks) {
+			bool sanitize = false;
 
-		for (i = 0; i < BPF_REG_SIZE; i++) {
-			if (state->stack[spi].slot_type[i] == STACK_MISC &&
-			    !env->allow_ptr_leaks) {
+			if (state->stack[spi].slot_type[0] == STACK_SPILL &&
+			    register_is_const(&state->stack[spi].spilled_ptr))
+				sanitize = true;
+			for (i = 0; i < BPF_REG_SIZE; i++)
+				if (state->stack[spi].slot_type[i] == STACK_MISC) {
+					sanitize = true;
+					break;
+				}
+			if (sanitize) {
 				int *poff = &env->insn_aux_data[insn_idx].sanitize_stack_off;
 				int soff = (-spi - 1) * BPF_REG_SIZE;
 
@@ -1032,8 +1058,8 @@ static int check_stack_write(struct bpf_verifier_env *env,
 				}
 				*poff = soff;
 			}
-			state->stack[spi].slot_type[i] = STACK_SPILL;
 		}
+		save_register_state(state, spi, reg);
 	} else {
 		u8 type = STACK_MISC;
 
@@ -1056,8 +1082,7 @@ static int check_stack_write(struct bpf_verifier_env *env,
 			state->stack[spi].spilled_ptr.live |= REG_LIVE_WRITTEN;
 
 		/* when we zero initialize stack slots mark them as such */
-		if (value_regno >= 0 &&
-		    register_is_null(&cur->regs[value_regno]))
+		if (reg && register_is_null(reg))
 			type = STACK_ZERO;
 
 		/* Mark slots affected by this stack write. */
@@ -1075,6 +1100,7 @@ static int check_stack_read(struct bpf_verifier_env *env,
 	struct bpf_verifier_state *vstate = env->cur_state;
 	struct bpf_func_state *state = vstate->frame[vstate->curframe];
 	int i, slot = -off - 1, spi = slot / BPF_REG_SIZE;
+	struct bpf_reg_state *reg;
 	u8 *stype;
 
 	if (reg_state->allocated_stack <= slot) {
@@ -1083,11 +1109,20 @@ static int check_stack_read(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 	stype = reg_state->stack[spi].slot_type;
+	reg = &reg_state->stack[spi].spilled_ptr;
 
 	if (stype[0] == STACK_SPILL) {
 		if (size != BPF_REG_SIZE) {
-			verbose(env, "invalid size of register spill\n");
-			return -EACCES;
+			if (reg->type != SCALAR_VALUE) {
+				verbose(env, "invalid size of register fill\n");
+				return -EACCES;
+			}
+			if (value_regno >= 0) {
+				mark_reg_unknown(env, state->regs, value_regno);
+				state->regs[value_regno].live |= REG_LIVE_WRITTEN;
+			}
+			mark_reg_read(env, reg, reg->parent);
+			return 0;
 		}
 		for (i = 1; i < BPF_REG_SIZE; i++) {
 			if (stype[(slot - i) % BPF_REG_SIZE] != STACK_SPILL) {
@@ -1098,16 +1133,14 @@ static int check_stack_read(struct bpf_verifier_env *env,
 
 		if (value_regno >= 0) {
 			/* restore register state from stack */
-			state->regs[value_regno] = reg_state->stack[spi].spilled_ptr;
+			state->regs[value_regno] = *reg;
 			/* mark reg as written since spilled pointer state likely
 			 * has its liveness marks cleared by is_state_visited()
 			 * which resets stack/reg liveness for state transitions
 			 */
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
 		}
-		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
-			      reg_state->stack[spi].spilled_ptr.parent);
-		return 0;
+		mark_reg_read(env, reg, reg->parent);
 	} else {
 		int zeros = 0;
 
@@ -1122,8 +1155,7 @@ static int check_stack_read(struct bpf_verifier_env *env,
 				off, i, size);
 			return -EACCES;
 		}
-		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
-			      reg_state->stack[spi].spilled_ptr.parent);
+		mark_reg_read(env, reg, reg->parent);
 		if (value_regno >= 0) {
 			if (zeros == size) {
 				/* any size read into register is zero extended,
@@ -1136,8 +1168,8 @@ static int check_stack_read(struct bpf_verifier_env *env,
 			}
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
 		}
-		return 0;
 	}
+	return 0;
 }
 
 static int check_stack_access(struct bpf_verifier_env *env,
@@ -1790,7 +1822,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 {
 	struct bpf_reg_state *reg = cur_regs(env) + regno;
 	struct bpf_func_state *state = func(env, reg);
-	int err, min_off, max_off, i, slot, spi;
+	int err, min_off, max_off, i, j, slot, spi;
 
 	if (reg->type != PTR_TO_STACK) {
 		/* Allow zero-byte read from NULL, regardless of pointer type */
@@ -1878,6 +1910,14 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 			*stype = STACK_MISC;
 			goto mark;
 		}
+		if (state->stack[spi].slot_type[0] == STACK_SPILL &&
+		    state->stack[spi].spilled_ptr.type == SCALAR_VALUE) {
+			__mark_reg_unknown(&state->stack[spi].spilled_ptr);
+			for (j = 0; j < BPF_REG_SIZE; j++)
+				state->stack[spi].slot_type[j] = STACK_MISC;
+			goto mark;
+		}
+
 err:
 		if (tnum_is_const(reg->var_off)) {
 			verbose(env, "invalid indirect read from stack off %d+%d size %d\n",
-- 
2.25.1

