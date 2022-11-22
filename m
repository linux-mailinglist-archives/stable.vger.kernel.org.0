Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EF16335E0
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 08:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbiKVHed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 02:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiKVHec (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 02:34:32 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AB7167E6;
        Mon, 21 Nov 2022 23:34:30 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM4wKGE018385;
        Tue, 22 Nov 2022 07:34:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : mime-version : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=JE7lDSeWrLA7f3Xlsvy0NH2+XkJdFgMdiXv+BKAbd5g=;
 b=H+m6s+DA/aExZl+6DvUqr+lAU2342jCUjwd09wcAdtYtbvwW5v2p0yKVO6e0X6FlYGCJ
 /aWguq813druoyEhCmoSpVdWwZDsmCs7JrHP5Wyd0XYKuHS3dC6n5C9v7wd4/8eiycnq
 my2ZK7U8umoWkW3/KhKuw4/JZHo3wx+6mZ6EzuT4YdYOwtnAEdWexnC7rtzZV+qOcn/O
 MK1UfJ7/M1t28CgKdjkeZRRJwShroyAUAj4W3xscjkDtZ5EwLqcIf6G4NLr6NcFTVb4e
 eLxu1PKb0YrEtZUnD5IJy0KA31ZOPP4EQi5fYxN/LhGKs1T27zcQ6Y70lsQgWSDk1YsW 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0qv9b47n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 07:34:02 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AM7Hk8D019601;
        Tue, 22 Nov 2022 07:34:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0qv9b475-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 07:34:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AM7LVOk005638;
        Tue, 22 Nov 2022 07:34:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3kxps92sh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 07:33:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AM7XvKe197282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 07:33:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A813742045;
        Tue, 22 Nov 2022 07:33:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F09B4203F;
        Tue, 22 Nov 2022 07:33:56 +0000 (GMT)
Received: from localhost (unknown [9.43.65.119])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Nov 2022 07:33:56 +0000 (GMT)
Date:   Tue, 22 Nov 2022 13:03:55 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] powerpc/bpf/32: Fix Oops on tail call tests
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, KP Singh <kpsingh@kernel.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>,
        Song Liu <song@kernel.org>, stable@vger.kernel.org,
        Yonghong Song <yhs@fb.com>
References: <8a0b9f7e4fe208a8b518c0c4310472f99d9fdb55.1668876211.git.christophe.leroy@csgroup.eu>
In-Reply-To: <8a0b9f7e4fe208a8b518c0c4310472f99d9fdb55.1668876211.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
User-Agent: astroid/4d6b06ad (https://github.com/astroidmail/astroid)
Message-Id: <1669101940.sfs1m92svc.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fQrGerqpgPsjfkMmWU2Lre4OBnJxC84y
X-Proofpoint-ORIG-GUID: 4L8S1LhMs-RGDzC34kcwCaOgDvnfwecW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christophe Leroy wrote:
> test_bpf tail call tests end up as:
>=20
>   test_bpf: #0 Tail call leaf jited:1 85 PASS
>   test_bpf: #1 Tail call 2 jited:1 111 PASS
>   test_bpf: #2 Tail call 3 jited:1 145 PASS
>   test_bpf: #3 Tail call 4 jited:1 170 PASS
>   test_bpf: #4 Tail call load/store leaf jited:1 190 PASS
>   test_bpf: #5 Tail call load/store jited:1
>   BUG: Unable to handle kernel data access on write at 0xf1b4e000
>   Faulting instruction address: 0xbe86b710
>   Oops: Kernel access of bad area, sig: 11 [#1]
>   BE PAGE_SIZE=3D4K MMU=3DHash PowerMac
>   Modules linked in: test_bpf(+)
>   CPU: 0 PID: 97 Comm: insmod Not tainted 6.1.0-rc4+ #195
>   Hardware name: PowerMac3,1 750CL 0x87210 PowerMac
>   NIP:  be86b710 LR: be857e88 CTR: be86b704
>   REGS: f1b4df20 TRAP: 0300   Not tainted  (6.1.0-rc4+)
>   MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 28008242  XER: 00000000
>   DAR: f1b4e000 DSISR: 42000000
>   GPR00: 00000001 f1b4dfe0 c11d2280 00000000 00000000 00000000 00000002 0=
0000000
>   GPR08: f1b4e000 be86b704 f1b4e000 00000000 00000000 100d816a f2440000 f=
e73baa8
>   GPR16: f2458000 00000000 c1941ae4 f1fe2248 00000045 c0de0000 f2458030 0=
0000000
>   GPR24: 000003e8 0000000f f2458000 f1b4dc90 3e584b46 00000000 f24466a0 c=
1941a00
>   NIP [be86b710] 0xbe86b710
>   LR [be857e88] __run_one+0xec/0x264 [test_bpf]
>   Call Trace:
>   [f1b4dfe0] [00000002] 0x2 (unreliable)
>   Instruction dump:
>   XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>   XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>   ---[ end trace 0000000000000000 ]---
>=20
> This is a tentative to write above the stack. The problem is encoutered
> with tests added by commit 38608ee7b690 ("bpf, tests: Add load store
> test case for tail call")
>=20
> This happens because tail call is done to a BPF prog with a different
> stack_depth. At the time being, the stack is kept as is when the caller
> tail calls its callee. But at exit, the callee restores the stack based
> on its own properties. Therefore here, at each run, r1 is erroneously
> increased by 32 - 16 =3D 16 bytes.
>=20
> This was done that way in order to pass the tail call count from caller
> to callee through the stack. As powerpc32 doesn't have a red zone in
> the stack, it was necessary the maintain the stack as is for the tail
> call. But it was not anticipated that the BPF frame size could be
> different.
>=20
> Let's take a new approach. Use register r0 to carry the tail call count
> during the tail call, and save it into the stack at function entry if
> required. That's a deviation from the ppc32 ABI, but after all the way
> tail calls are implemented is already not in accordance with the ABI.

Can we pass the tail call count in r4 instead?

>=20
> With the fix, tail call tests are now successfull:
>=20
>   test_bpf: #0 Tail call leaf jited:1 53 PASS
>   test_bpf: #1 Tail call 2 jited:1 115 PASS
>   test_bpf: #2 Tail call 3 jited:1 154 PASS
>   test_bpf: #3 Tail call 4 jited:1 165 PASS
>   test_bpf: #4 Tail call load/store leaf jited:1 101 PASS
>   test_bpf: #5 Tail call load/store jited:1 141 PASS
>   test_bpf: #6 Tail call error path, max count reached jited:1 994 PASS
>   test_bpf: #7 Tail call count preserved across function calls jited:1 14=
0975 PASS
>   test_bpf: #8 Tail call error path, NULL target jited:1 110 PASS
>   test_bpf: #9 Tail call error path, index out of range jited:1 69 PASS
>   test_bpf: test_tail_calls: Summary: 10 PASSED, 0 FAILED, [10/10 JIT'ed]
>=20
> Fixes: 51c66ad849a7 ("powerpc/bpf: Implement extended BPF on PPC32")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
>  arch/powerpc/net/bpf_jit_comp32.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
>=20
> diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit=
_comp32.c
> index 43f1c76d48ce..97e75b8181ca 100644
> --- a/arch/powerpc/net/bpf_jit_comp32.c
> +++ b/arch/powerpc/net/bpf_jit_comp32.c
> @@ -115,21 +115,19 @@ void bpf_jit_build_prologue(u32 *image, struct code=
gen_context *ctx)
> =20
>  	/* First arg comes in as a 32 bits pointer. */
>  	EMIT(PPC_RAW_MR(bpf_to_ppc(BPF_REG_1), _R3));
> -	EMIT(PPC_RAW_LI(bpf_to_ppc(BPF_REG_1) - 1, 0));
> +	EMIT(PPC_RAW_LI(_R0, 0));
> +
> +#define BPF_TAILCALL_PROLOGUE_SIZE	8
> +
>  	EMIT(PPC_RAW_STWU(_R1, _R1, -BPF_PPC_STACKFRAME(ctx)));
> =20
>  	/*
> -	 * Initialize tail_call_cnt in stack frame if we do tail calls.
> -	 * Otherwise, put in NOPs so that it can be skipped when we are
> -	 * invoked through a tail call.
> +	 * Save tail_call_cnt in stack frame if we do tail calls.
>  	 */
>  	if (ctx->seen & SEEN_TAILCALL)
> -		EMIT(PPC_RAW_STW(bpf_to_ppc(BPF_REG_1) - 1, _R1,
> -				 bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
> -	else
> -		EMIT(PPC_RAW_NOP());
> +		EMIT(PPC_RAW_STW(_R0, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
> =20
> -#define BPF_TAILCALL_PROLOGUE_SIZE	16
> +	EMIT(PPC_RAW_LI(bpf_to_ppc(BPF_REG_1) - 1, 0));
> =20
>  	/*
>  	 * We need a stack frame, but we don't necessarily need to
> @@ -244,7 +242,6 @@ static int bpf_jit_emit_tail_call(u32 *image, struct =
codegen_context *ctx, u32 o
>  	EMIT(PPC_RAW_RLWINM(_R3, b2p_index, 2, 0, 29));
>  	EMIT(PPC_RAW_ADD(_R3, _R3, b2p_bpf_array));
>  	EMIT(PPC_RAW_LWZ(_R3, _R3, offsetof(struct bpf_array, ptrs)));
> -	EMIT(PPC_RAW_STW(_R0, _R1, bpf_jit_stack_offsetof(ctx, BPF_PPC_TC)));
> =20
>  	/*
>  	 * if (prog =3D=3D NULL)
> @@ -257,20 +254,20 @@ static int bpf_jit_emit_tail_call(u32 *image, struc=
t codegen_context *ctx, u32 o
>  	EMIT(PPC_RAW_LWZ(_R3, _R3, offsetof(struct bpf_prog, bpf_func)));
> =20
>  	if (ctx->seen & SEEN_FUNC)
> -		EMIT(PPC_RAW_LWZ(_R0, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
> +		EMIT(PPC_RAW_LWZ(_R5, _R1, BPF_PPC_STACKFRAME(ctx) + PPC_LR_STKOFF));
> =20
>  	EMIT(PPC_RAW_ADDIC(_R3, _R3, BPF_TAILCALL_PROLOGUE_SIZE));
> =20
>  	if (ctx->seen & SEEN_FUNC)
> -		EMIT(PPC_RAW_MTLR(_R0));
> +		EMIT(PPC_RAW_MTLR(_R5));

Should we explicitly zero-out _R5 after this?

You can move the above PPC_RAW_LWZ() and PPC_RAW_MTLR() instructions, as=20
well as the ADDI below for r1 into bpf_jit_emit_common_epilogue() and=20
not have to repeat those here.

- Naveen

> =20
>  	EMIT(PPC_RAW_MTCTR(_R3));
> =20
> -	EMIT(PPC_RAW_MR(_R3, bpf_to_ppc(BPF_REG_1)));
> -
>  	/* tear restore NVRs, ... */
>  	bpf_jit_emit_common_epilogue(image, ctx);
> =20
> +	EMIT(PPC_RAW_ADDI(_R1, _R1, BPF_PPC_STACKFRAME(ctx)));
> +
>  	EMIT(PPC_RAW_BCTR());
> =20
>  	/* out: */
> --=20
> 2.38.1
>=20
>=20
