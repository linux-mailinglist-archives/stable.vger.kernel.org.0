Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498565597EB
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 12:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiFXKeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 06:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiFXKeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 06:34:15 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3E97C532
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 03:34:13 -0700 (PDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B78F23F0B8
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 10:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1656066851;
        bh=m+hLmhjFMD/AVIUGEN2FBoEu3LJoKdrevWfuYmtLwEY=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=GgGVZ0tqf1FVOzdTAMgeRsK8KmYDK/6Z589WfiJoRsfEVHLfkQFf1GQgIOkijM2Rz
         a34rF146tG16yFLCst1DFlSkU49tqHcs0N2Ofb2I6XTod/0Pz6p6Kdx7SMX0d3iuNZ
         5JIiONjZUHZaNYkR6OHC9lKm2jpjEHOAjK1Sr8fyC07BwK+dzGpk57QCFvNf82CRUu
         Aiay9jft3ou4kaJ0R40TQWSTeA61IXmLztx/iRl7Y4m4PFmyGqM2GTDWG7cvEBY7r4
         gEthp9skHeRtpJ5CLIhqLwLKzXKS03LsJDOLKKLt1X+2SQ9uDKvlfM65DYcC7DDmsd
         B0T6OdKaYWtDA==
Received: by mail-pg1-f197.google.com with SMTP id l189-20020a6388c6000000b0040d40295743so915478pgd.15
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 03:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m+hLmhjFMD/AVIUGEN2FBoEu3LJoKdrevWfuYmtLwEY=;
        b=aCFMYlyNwdnsWxx/pd2sRwBkybk7GalPHXGDJ/cDpnYT4ijGQeJjStFycHQyPGVMtX
         x8JhO7t/FmekAqCTlaM0/4/Q1FyQf5RkhsYZFcJ3d7DFMjpFW/sRUpya6x6eI2XSjxQu
         5TLuMgW+8QokjEIGmuJVZiIYYVLfnsn6sBfBju2AKWC57QldfsOCQGvg3+suIKAA7SUj
         fUdT4BpWZ7T7DnAKuxF6lK7uDx1GTttEHZCQ4Lb/Tc64ssbKzfDmzXGKVt4IM7huXPRy
         zxtXYvzAMHP4l6osSKCyvU+c+R1aM7cEYnAjph17YRTpWIIIFRXnDgen41nxD/SkKtMf
         d82g==
X-Gm-Message-State: AJIora+1Jfvv0eckbABKn73nKTEKm+nQWfbWHavwZsyf8DJxGAEwOsgW
        1k7DIDXZ6yOeXqYUmwmzFfXToMgD6nayOW1egSw9QXJQOQtiJ/ciI6xjZ4C0FOQCpfD21GPFEkU
        4tb4lw1XqTFyfv4pgLMMVdwqhK/E2EDBJhJTUmjPLNRZpVcgb
X-Received: by 2002:a17:903:1249:b0:168:e059:59c1 with SMTP id u9-20020a170903124900b00168e05959c1mr43557678plh.0.1656066850023;
        Fri, 24 Jun 2022 03:34:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uiqS0wfZEm4V2eQ6Yh+ZVZJcCBVYzQrD/cYHLJHdmLi/l4zqZ1ktGhSgR5dP3LxmHovdqOJHwdkDGnVVyZ5TU=
X-Received: by 2002:a17:903:1249:b0:168:e059:59c1 with SMTP id
 u9-20020a170903124900b00168e05959c1mr43557654plh.0.1656066849686; Fri, 24 Jun
 2022 03:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220429104052.345760505@linuxfoundation.org> <20220429104053.296096344@linuxfoundation.org>
In-Reply-To: <20220429104053.296096344@linuxfoundation.org>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Fri, 24 Jun 2022 18:33:57 +0800
Message-ID: <CAMy_GT9YbgqsoLbCDqhHpXNW6EejgK+YaE4YPxpxcmer+qn-1g@mail.gmail.com>
Subject: Re: [PATCH 5.15 33/33] selftests/bpf: Add test for reg2btf_ids out of
 bounds access
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 29, 2022 at 6:47 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> commit 13c6a37d409db9abc9c0bfc6d0a2f07bf0fff60e upstream.
>
> This test tries to pass a PTR_TO_BTF_ID_OR_NULL to the release function,
> which would trigger a out of bounds access without the fix in commit
> 45ce4b4f9009 ("bpf: Fix crash due to out of bounds access into reg2btf_id=
s.")
> but after the fix, it should only index using base_type(reg->type),
> which should be less than __BPF_REG_TYPE_MAX, and also not permit any
> type flags to be set for the reg->type.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Link: https://lore.kernel.org/bpf/20220220023138.2224652-1-memxor@gmail.c=
om
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  tools/testing/selftests/bpf/verifier/calls.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> --- a/tools/testing/selftests/bpf/verifier/calls.c
> +++ b/tools/testing/selftests/bpf/verifier/calls.c
> @@ -108,6 +108,25 @@
>         .errstr =3D "R0 min value is outside of the allowed memory range"=
,
>  },
>  {
> +       "calls: trigger reg2btf_ids[reg->type] for reg->type > __BPF_REG_=
TYPE_MAX",
> +       .insns =3D {
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
> +       BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
> +       BPF_EXIT_INSN(),
> +       },
> +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> +       .result =3D REJECT,
> +       .errstr =3D "arg#0 pointer type STRUCT prog_test_ref_kfunc must p=
oint",
> +       .fixup_kfunc_btf_id =3D {
> +               { "bpf_kfunc_call_test_acquire", 3 },
> +               { "bpf_kfunc_call_test_release", 5 },
> +       },
> +},
> +{
>         "calls: overlapping caller/callee",
>         .insns =3D {
>         BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 0),
>
>

Hello Greg,

When I tried to build the bpf selftest from 5.15.49 source tree on a
Ubuntu Jammy instance running with 5.15.49-051549-generic, I got the
following error message:

In file included from
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/tests.h:21,
                 from test_verifier.c:432:
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:124:10:
error: =E2=80=98struct bpf_test=E2=80=99 has no member named =E2=80=98fixup=
_kfunc_btf_id=E2=80=99
  124 |         .fixup_kfunc_btf_id =3D {
      |          ^~~~~~~~~~~~~~~~~~
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:124:9:
warning: braces around scalar initializer
  124 |         .fixup_kfunc_btf_id =3D {
      |         ^
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:124:9:
note: (near initialization for =E2=80=98tests[150].errstr_unpriv=E2=80=99)
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:125:17:
warning: braces around scalar initializer
  125 |                 { "bpf_kfunc_call_test_acquire", 3 },
      |                 ^
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:125:17:
note: (near initialization for =E2=80=98tests[150].errstr_unpriv=E2=80=99)
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:125:50:
warning: excess elements in scalar initializer
  125 |                 { "bpf_kfunc_call_test_acquire", 3 },
      |                                                  ^
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:125:50:
note: (near initialization for =E2=80=98tests[150].errstr_unpriv=E2=80=99)
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:17:
warning: braces around scalar initializer
  126 |                 { "bpf_kfunc_call_test_release", 5 },
      |                 ^
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:17:
note: (near initialization for =E2=80=98tests[150].errstr_unpriv=E2=80=99)
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:50:
warning: excess elements in scalar initializer
  126 |                 { "bpf_kfunc_call_test_release", 5 },
      |                                                  ^
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:50:
note: (near initialization for =E2=80=98tests[150].errstr_unpriv=E2=80=99)
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:17:
warning: excess elements in scalar initializer
  126 |                 { "bpf_kfunc_call_test_release", 5 },
      |                 ^
/home/ubuntu/linux/tools/testing/selftests/bpf/verifier/calls.c:126:17:
note: (near initialization for =E2=80=98tests[150].errstr_unpriv=E2=80=99)
make: *** [Makefile:508:
/home/ubuntu/linux/tools/testing/selftests/bpf/test_verifier] Error 1

Which is introduced by this commit f59e6886c "selftests/bpf: Add test
for reg2btf_ids out of bounds access" on 5.15. With this commit
reverted, there will be another error in progs/timer_crash.c like in
5.10 [1]:

progs/timer_crash.c:8:19: error: field has incomplete type 'struct bpf_time=
r'
        struct bpf_timer timer;
                         ^
/home/ubuntu/linux/tools/testing/selftests/bpf/tools/include/bpf/bpf_helper=
_defs.h:39:8:
note: forward declaration of 'struct bpf_timer'
struct bpf_timer;
       ^
1 error generated.

Maybe commit "selftests/bpf: Add test for bpf_timer overwriting crash"
should be reverted on 5.15 as well.
Thanks

[1] https://www.spinics.net/lists/stable/msg542618.html
