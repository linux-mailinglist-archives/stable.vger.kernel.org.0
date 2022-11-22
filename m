Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB70C6338F1
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 10:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiKVJsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 04:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233083AbiKVJsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 04:48:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E48633D;
        Tue, 22 Nov 2022 01:48:07 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM7SX5l005059;
        Tue, 22 Nov 2022 09:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : mime-version : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=NFAyZLaovr/F9jGI1O5jH8acNqLSRKi2iVgWNogMCMM=;
 b=MKDf1CqY+5vgoitedVZG9koxje4nuV7gN1eeMfSI8QOgtzX5gBzbpvY2H9MrERoUZZh4
 ZIRnZe1oW6qQ54JH3d+Q8lV4M+2uPz7DlMx384fQO4UP+fXFCpzle9arZEtyqpZVL/Yp
 a/lev6uXl8t1h95j9rpmtlBj2UV18mTRB0xtbPS8Vff053Py7t9+LceEVOd1jx3s35ar
 3MvApEg5ip8J38zrEEEQtpc3hnqjouk31sb6cS9dwS1Vh2hatK0kqkw8b6OxbhAom4Ne
 J0vFm7IRz3Ky1OUx/q5LP/wriPJB4hdjPVpaZpRoBlh0tdPZCkWw5lXSTWaWdtDQcPq3 qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0t2mu2vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 09:47:34 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AM9Zn6R013339;
        Tue, 22 Nov 2022 09:47:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0t2mu2um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 09:47:33 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AM9atqp003789;
        Tue, 22 Nov 2022 09:47:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3kxps8uwke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 09:47:30 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AM9m9Zp36569348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 09:48:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57E4A11C050;
        Tue, 22 Nov 2022 09:47:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDD3111C04C;
        Tue, 22 Nov 2022 09:47:27 +0000 (GMT)
Received: from localhost (unknown [9.43.65.119])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Nov 2022 09:47:27 +0000 (GMT)
Date:   Tue, 22 Nov 2022 15:17:26 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] powerpc/bpf/32: Fix Oops on tail call tests
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, KP Singh <kpsingh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>,
        Song Liu <song@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>
References: <8a0b9f7e4fe208a8b518c0c4310472f99d9fdb55.1668876211.git.christophe.leroy@csgroup.eu>
        <1669101940.sfs1m92svc.naveen@linux.ibm.com>
        <f333e28c-a4ff-62eb-4b75-ee301e5ea53f@csgroup.eu>
In-Reply-To: <f333e28c-a4ff-62eb-4b75-ee301e5ea53f@csgroup.eu>
MIME-Version: 1.0
User-Agent: astroid/4d6b06ad (https://github.com/astroidmail/astroid)
Message-Id: <1669108894.f58czzpqdm.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jHemxqz0CGp1WxzXj0t_JLVmJmXGJ5QV
X-Proofpoint-GUID: udMV-6y-Z86dG3q5UpnvMUfvpzVDnbiN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christophe Leroy wrote:
>=20
>=20
> Le 22/11/2022 =C3=A0 08:33, Naveen N. Rao a =C3=A9crit=C2=A0:
>> Christophe Leroy wrote:
>>>
>>> This is a tentative to write above the stack. The problem is encoutered
>>> with tests added by commit 38608ee7b690 ("bpf, tests: Add load store
>>> test case for tail call")
>>>
>>> This happens because tail call is done to a BPF prog with a different
>>> stack_depth. At the time being, the stack is kept as is when the caller
>>> tail calls its callee. But at exit, the callee restores the stack based
>>> on its own properties. Therefore here, at each run, r1 is erroneously
>>> increased by 32 - 16 =3D 16 bytes.
>>>
>>> This was done that way in order to pass the tail call count from caller
>>> to callee through the stack. As powerpc32 doesn't have a red zone in
>>> the stack, it was necessary the maintain the stack as is for the tail
>>> call. But it was not anticipated that the BPF frame size could be
>>> different.
>>>
>>> Let's take a new approach. Use register r0 to carry the tail call count
>>> during the tail call, and save it into the stack at function entry if
>>> required. That's a deviation from the ppc32 ABI, but after all the way
>>> tail calls are implemented is already not in accordance with the ABI.
>>=20
>> Can we pass the tail call count in r4 instead?
>=20
> It's a bit tricky.
>=20
> When entering the function through the normal entry point, the input=20
> parameter is a 32 bits pointer and is in r3.
> But at the begining of the function it gets moved to r4 and r3 is=20
> cleared because it becomes a 64 bits parameter.
>=20
> When using the tailcall entry point, it is already in r4, and until now=20
> r3 was containing garbage, with this patch r3 gets cleared as well.
>=20
> We could move the input pointer back into r3 for the tailcall as well,=20
> but it would mean unnecessary register move.
>=20
> Or we can use r3 for the tailcall counter.

Regarding zero'ing out r5, you're right -- we don't use the second=20
parameter for a tail call, so that should be fine.

Using r3 will be difficult since it is used when you come in first.
My suggestion was something like the below (untested). Using r5 might be=20
fine too.

- Naveen

--
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_c=
omp32.c
index 43f1c76d48cea9..6319283ce4ef01 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -113,24 +113,19 @@ void bpf_jit_build_prologue(u32 *image, struct codege=
n_context *ctx)
 {
 	int i;
=20
+	/* Initialize tail_call_cnt, to be skipped if we do tail calls. */
+	EMIT(PPC_RAW_LI(_R4, 0));
+
+#define BPF_TAILCALL_PROLOGUE_SIZE	4
+
+	if (ctx->seen & SEEN_TAILCALL)
+		EMIT(PPC_RAW_STW(_R4, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
+
 	/* First arg comes in as a 32 bits pointer. */
 	EMIT(PPC_RAW_MR(bpf_to_ppc(BPF_REG_1), _R3));
 	EMIT(PPC_RAW_LI(bpf_to_ppc(BPF_REG_1) - 1, 0));
 	EMIT(PPC_RAW_STWU(_R1, _R1, -BPF_PPC_STACKFRAME(ctx)));
=20
-	/*
-	 * Initialize tail_call_cnt in stack frame if we do tail calls.
-	 * Otherwise, put in NOPs so that it can be skipped when we are
-	 * invoked through a tail call.
-	 */
-	if (ctx->seen & SEEN_TAILCALL)
-		EMIT(PPC_RAW_STW(bpf_to_ppc(BPF_REG_1) - 1, _R1,
-				 bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
-	else
-		EMIT(PPC_RAW_NOP());
-
-#define BPF_TAILCALL_PROLOGUE_SIZE	16
-
 	/*
 	 * We need a stack frame, but we don't necessarily need to
 	 * save/restore LR unless we call other functions
@@ -170,24 +165,24 @@ static void bpf_jit_emit_common_epilogue(u32 *image, =
struct codegen_context *ctx
 	for (i =3D BPF_PPC_NVR_MIN; i <=3D 31; i++)
 		if (bpf_is_seen_register(ctx, i))
 			EMIT(PPC_RAW_LWZ(i, _R1, bpf_jit_stack_offsetof(ctx, i)));
-}
-
-void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx)
-{
-	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_0)));
-
-	bpf_jit_emit_common_epilogue(image, ctx);
-
-	/* Tear down our stack frame */
=20
 	if (ctx->seen & SEEN_FUNC)
 		EMIT(PPC_RAW_LWZ(_R0, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
=20
+	/* Tear down our stack frame */
 	EMIT(PPC_RAW_ADDI(_R1, _R1, BPF_PPC_STACKFRAME(ctx)));
=20
 	if (ctx->seen & SEEN_FUNC)
 		EMIT(PPC_RAW_MTLR(_R0));
=20
+}
+
+void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx)
+{
+	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_0)));
+
+	bpf_jit_emit_common_epilogue(image, ctx);
+
 	EMIT(PPC_RAW_BLR());
 }
=20
@@ -244,7 +239,6 @@ static int bpf_jit_emit_tail_call(u32 *image, struct co=
degen_context *ctx, u32 o
 	EMIT(PPC_RAW_RLWINM(_R3, b2p_index, 2, 0, 29));
 	EMIT(PPC_RAW_ADD(_R3, _R3, b2p_bpf_array));
 	EMIT(PPC_RAW_LWZ(_R3, _R3, offsetof(struct bpf_array, ptrs)));
-	EMIT(PPC_RAW_STW(_R0, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
=20
 	/*
 	 * if (prog =3D=3D NULL)
@@ -255,18 +249,11 @@ static int bpf_jit_emit_tail_call(u32 *image, struct =
codegen_context *ctx, u32 o
=20
 	/* goto *(prog->bpf_func + prologue_size); */
 	EMIT(PPC_RAW_LWZ(_R3, _R3, offsetof(struct bpf_prog, bpf_func)));
-
-	if (ctx->seen & SEEN_FUNC)
-		EMIT(PPC_RAW_LWZ(_R0, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
-
 	EMIT(PPC_RAW_ADDIC(_R3, _R3, BPF_TAILCALL_PROLOGUE_SIZE));
-
-	if (ctx->seen & SEEN_FUNC)
-		EMIT(PPC_RAW_MTLR(_R0));
-
 	EMIT(PPC_RAW_MTCTR(_R3));
=20
 	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_1)));
+	EMIT(PPC_RAW_MR(_R4, _R0));
=20
 	/* tear restore NVRs, ... */
 	bpf_jit_emit_common_epilogue(image, ctx);
