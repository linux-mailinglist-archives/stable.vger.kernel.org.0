Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD295637654
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 11:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiKXK04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 05:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKXK0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 05:26:53 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AF1C745;
        Thu, 24 Nov 2022 02:26:52 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO954h0008036;
        Thu, 24 Nov 2022 10:26:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : mime-version : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=h0OaRJdxPrOEvjS/JN+gFuwD0ahqFo+ShpVhiflB7sc=;
 b=R7SmWUVYN8xdq4fdRJtRVTCYFkcwAG3HLaXrOJAcbs7DJYKRTd7fnphTuCPl4InPbVRn
 SLAL1BBcRRhgM1ZrXKZi/qdhQgcXeDMpi9FYknG/h5dhF5KfuCPrrjHmPIhXYstVGUPk
 2Wsz5BX8l7heLSrzWQG/j5sMx3O5Tsc6AIwbGGc6TdHxbq1v7/w8iJGDd7phLgr6H9vf
 oxelAQDN12tWAsyv6rAifXQ2xmuuBDDEFqJmvDtIez2mmy0btERCKNzD734Kj5Qhieg1
 JHqu187yFMLQmw2feZVxO/YBPqxIhia/x8lnai2SMHl+Re0YeOfSAc4Rjxb4Rk/4znxY MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10w6np16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 10:26:23 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AOABepN021262;
        Thu, 24 Nov 2022 10:26:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10w6np0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 10:26:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AOALCnx002733;
        Thu, 24 Nov 2022 10:26:20 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3kxps8yyud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 10:26:20 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AOAQIKZ37618238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 10:26:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05CB2A404D;
        Thu, 24 Nov 2022 10:26:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 613BEA4040;
        Thu, 24 Nov 2022 10:26:17 +0000 (GMT)
Received: from localhost (unknown [9.43.36.53])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Nov 2022 10:26:17 +0000 (GMT)
Date:   Thu, 24 Nov 2022 15:56:15 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH v2] powerpc/bpf/32: Fix Oops on tail call tests
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
References: <757acccb7fbfc78efa42dcf3c974b46678198905.1669278887.git.christophe.leroy@csgroup.eu>
In-Reply-To: <757acccb7fbfc78efa42dcf3c974b46678198905.1669278887.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
User-Agent: astroid/4d6b06ad (https://github.com/astroidmail/astroid)
Message-Id: <1669285523.t5gbams47i.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7Et1NJoogkaVUd8SzfCTQ0cNFQr_Dw7B
X-Proofpoint-ORIG-GUID: MaI_DwSJSsWRn0AvUqHpwdA-DhJ90lHU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
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
> Let's take a new approach. Use register r4 to carry the tail call count
> during the tail call, and save it into the stack at function entry if
> required. This means the input parameter must be in r3, which is more
> correct as it is a 32 bits parameter, then tail call better match with
> normal BPF function entry, the down side being that we move that input
> parameter back and forth between r3 and r4. That can be optimised later.
>=20
> Doing that also has the advantage of maximising the common parts between
> tail calls and a normal function exit.
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
> Suggested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Fixes: 51c66ad849a7 ("powerpc/bpf: Implement extended BPF on PPC32")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com


Thanks,
Naveen
