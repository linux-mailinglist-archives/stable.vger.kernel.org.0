Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B27A6E4F11
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 19:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjDQRTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 13:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjDQRTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 13:19:20 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FC1C147
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 10:18:37 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f08b6a9f8aso231835e9.0
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 10:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681751901; x=1684343901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EwEUyZ1hv8C2cfjlNgeBtOKtK16Xrh+esjFWHHPRRb0=;
        b=lbnr6J2jneenWoGXcHHKbrHIJWCE7J59mq6GOymAdiHW4J8rbrJp1V/iw+kmGIbqVB
         XOROxum450K19zxRjwmeMG8pUrWGarSh29wH1f8ASCwm1rLZYOo2MKStJTUBaukxDavd
         rDZaig633iSxicv9wrQiotJqnYdSBmSBGG1dKiHH0y0N7sqC5OGypqDXLt1Y9VqvNr4l
         CtElPm5yVT3oj0I3xRobOxJoHLanQXoY72OebcqU8RLc7tkytmC4A2i3dOkJNxM+8sg1
         p2VkJP+XO6fBArBEoeOfDCHH46Jq3eOjW17LatDWkf3+SX8rcQL+7yMwBoXVtfu01nOa
         8n0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681751901; x=1684343901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EwEUyZ1hv8C2cfjlNgeBtOKtK16Xrh+esjFWHHPRRb0=;
        b=RmJPpdf/kZ1CTO7wrD/tUFlQyJmWlwUaJy2ty0wDKV3FgoVtHl57DTErnzbryrqfNh
         Gth19Xct8bW018d7cx3Ena3IiQLASbKG8smWGs4E5svfT3baoqe1LFNz4rXbXCDGq02T
         h5cGJamcMQFYUJkGObu0svHrYRK3EESKUtQI0sTXHrcBP3XaTQB3JF/0VohNX9zX63IO
         WXmKtIiuUBOOjrtdZaVT7U1P9GNhq6xJAiV10FZuvn8BS6iUxoi+i7Jkr+n14CwbdGPl
         Q12zvkPRsKS/htrOA92vud9MOvDxcAJgBsyZtzy2/XFu5YM+QJndk6rh9f4AIvQl9R/D
         KfUg==
X-Gm-Message-State: AAQBX9fu85viF1n20Aaw3NAGvW0y1zMgvfrczXaVNlt8zSrXCu1aM5eZ
        H3q4qyP/BgUZuHvdUSCx/lxu3ITgdYWIanXgvKyeDg==
X-Google-Smtp-Source: AKy350b7enRl0ByHp6ksDSKZ80A0ICKsu105uTsFcTC8eBxQHPrY3fGARG2RXOH9XJ/cVUvUgdKMxN+Ks+7k11OG1kc=
X-Received: by 2002:a05:600c:3492:b0:3f1:6f35:f677 with SMTP id
 a18-20020a05600c349200b003f16f35f677mr468016wmq.1.1681751900928; Mon, 17 Apr
 2023 10:18:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230417122943.2155502-1-anders.roxell@linaro.org>
In-Reply-To: <20230417122943.2155502-1-anders.roxell@linaro.org>
From:   Ian Rogers <irogers@google.com>
Date:   Mon, 17 Apr 2023 10:18:06 -0700
Message-ID: <CAP-5=fX=yftpSELUHmz3aCu6C4mknud8A_S4Q0UsdaagPLW5mA@mail.gmail.com>
Subject: Re: [backport PATCH 0/2] stable v5.15, v5.10 and v5.4: fix perf build errors
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     stable@vger.kernel.org, acme@redhat.com, andres@anarazel.de,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 17, 2023 at 5:30=E2=80=AFAM Anders Roxell <anders.roxell@linaro=
.org> wrote:
>
> Hi,
>
> I would like to see these patches backported. They are needed so perf
> can be cross compiled with gcc on v5.15, v5.10 and v5.4.

Thanks Anders, why not just use the latest perf for these kernels?
Perhaps this discussion is relevant:
https://lore.kernel.org/linux-perf-users/0b1c5f9af241327786a996a3ddd61602b5=
a15987.camel@decadent.org.uk/

Thanks,
Ian

> I built it with tuxmake [1] here are two example commandlines:
> tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12 --kconfig=
 defconfig perf
> tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-12 --kconfi=
g defconfig perf
>
> Tried to build perf with both gcc-11 and gcc-12.
>
> Patch 'tools perf: Fix compilation error with new binutils'
> and 'tools build: Add feature test for init_disassemble_info API changes'
> didn't apply cleanly, thats why I send these in a patchset.
>
> When apply 'tools build: Add feature test for
> init_disassemble_info API changes' to 5.4 it will be a minor merge
> conflict, do you want me to send this patch in two separate patches one
> for 5.4 and another for v5.10?
>
> The sha for these two patches in mainline are.
> cfd59ca91467 tools build: Add feature test for init_disassemble_info API =
changes
> 83aa0120487e tools perf: Fix compilation error with new binutils
>
> The above patches solves these:
> util/annotate.c: In function 'symbol__disassemble_bpf':
> util/annotate.c:1729:9: error: too few arguments to function 'init_disass=
emble_info'
>  1729 |         init_disassemble_info(&info, s,
>       |         ^~~~~~~~~~~~~~~~~~~~~
>
>
> Please apply these to v5.10 and v5.4
> a45b3d692623 tools include: add dis-asm-compat.h to handle version differ=
ences
> d08c84e01afa perf sched: Cast PTHREAD_STACK_MIN to int as it may turn int=
o sysconf(__SC_THREAD_STACK>
>
> The above patches solves these:
> /home/anders/src/kernel/stable-5.10/tools/include/linux/kernel.h:43:24: e=
rror: comparison of distinct pointer types lacks a cast [-Werror]
>    43 |         (void) (&_max1 =3D=3D &_max2);              \
>       |                        ^~
> builtin-sched.c:673:34: note: in expansion of macro 'max'
>   673 |                         (size_t) max(16 * 1024, PTHREAD_STACK_MIN=
));
>       |                                  ^~~
>
>
> Please apply these to v5.15, v5.10 and v5.4
> 8e8bf60a6754 perf build: Fixup disabling of -Wdeprecated-declarations for=
 the python scripting engine
> 4ee3c4da8b1b perf scripting python: Do not build fail on deprecation warn=
ings
> 63a4354ae75c perf scripting perl: Ignore some warnings to keep building w=
ith perl headers
>
> Build error that the above 3 patches solves are:
> /usr/lib/x86_64-linux-gnu/perl/5.36/CORE/handy.h:125:23: error: cast from=
 function call of type 'STRLEN' {aka 'long unsigned int'} to non-matching t=
ype '_Bool' [-Werror=3Dbad-function-cast]
>   125 | #define cBOOL(cbool) ((bool) (cbool))
>       |                       ^
>
> Cheers,
> Anders
> [1] https://tuxmake.org/
>
> Andres Freund (2):
>   tools perf: Fix compilation error with new binutils
>   tools build: Add feature test for init_disassemble_info API changes
>
>  tools/build/Makefile.feature                        |  1 +
>  tools/build/feature/Makefile                        |  4 ++++
>  tools/build/feature/test-all.c                      |  4 ++++
>  tools/build/feature/test-disassembler-init-styled.c | 13 +++++++++++++
>  tools/perf/Makefile.config                          |  8 ++++++++
>  tools/perf/util/annotate.c                          |  7 ++++---
>  6 files changed, 34 insertions(+), 3 deletions(-)
>  create mode 100644 tools/build/feature/test-disassembler-init-styled.c
>
> --
> 2.39.2
>
