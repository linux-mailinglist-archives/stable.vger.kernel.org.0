Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C647049A9F9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323884AbiAYD3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3409738AbiAYA1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 19:27:19 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21F3C046E03;
        Mon, 24 Jan 2022 14:09:25 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id y17so3641053ilm.1;
        Mon, 24 Jan 2022 14:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d6HjppEWR1T8ZOcwdp+EOP/ztmmko1v8gQaGfPlFykA=;
        b=hGDljOFLASbsoMo+rcy/eXZrA59L6Zh/LlOQEBmL6YzOvLS2AjNgBfEei25hhxaxSL
         W3aSXsKTwJrIhbL4e4IWQeWpBFOO7JLb+bt/Jrpal9j/v5CfX2tR4iXme1k6g7HRAfKp
         8NbVw4XVbcceiUm8OkImUmbHVhdRh8oW5rlhzn5TgRs4v6hzH9nviJAFQ3VxMEy6C9ML
         JH5Ra4099xJ7v/JF/EC57bBk3zh0iEff8JTkQv63GL7ojY2VZpJuXSnaWyC4dSvhGv4k
         aOiUM5l33Met6VKn8K6CjMV2nFzcM3n0Ny45RCZXc3IeOSH2AiSzLDJK0uMDG7GWi/h6
         Pxmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d6HjppEWR1T8ZOcwdp+EOP/ztmmko1v8gQaGfPlFykA=;
        b=TNT+kznhYwjlSu2e8Nemp+qhzvEuN8Q7LhAUsJOS1rmcWnaN6FRz9OABqyZhdXyePm
         4TyOb3A9BTJfLr6HhGrWF9aHUa1OBR6vGWCDNJ7WhUM3GMd1vS/7ZU0syFIEfke5BIop
         EEbf/PRgFs+/MCzfeQrMB2mSprNRtwY6HlEU24f8ZLCtB4JI7cI+VRw8WTZRz6JYkVgX
         GQiy2p5oNtcrcA064ei0V0qrtXXwY+b6B5iLBzeLabs8l3gEHN/yKqRsDWQmg2+of6NN
         wCaYZbARFxaUbH32k02CKLBzdPHZhW2mL59ghRAch9rmljMitrWB4lOycURKa4gWQVS2
         p4XA==
X-Gm-Message-State: AOAM532thjKf2AFm/vtQXkHauycY6k2i/OoAryaqURaXInJt4D+eofEs
        f4EG6DRRBneOlAC4h+EE8bF3lZ/LNreRF7B8cbw=
X-Google-Smtp-Source: ABdhPJwdeoHnJR9W8Q6Dtox2JxDYbtjJrpqft3BvbegaPWgsRQNkibILgfHG2HkruRoKnslClqAvxANGNw0Kvdf3pVI=
X-Received: by 2002:a05:6e02:1749:: with SMTP id y9mr9274241ill.252.1643062164966;
 Mon, 24 Jan 2022 14:09:24 -0800 (PST)
MIME-Version: 1.0
References: <20220124184100.867127425@linuxfoundation.org> <29a0f562-af46-f4d0-182c-09c8d99e0a93@applied-asynchrony.com>
In-Reply-To: <29a0f562-af46-f4d0-182c-09c8d99e0a93@applied-asynchrony.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Jan 2022 14:09:13 -0800
Message-ID: <CAEf4BzaOHPD72jTsdJjUa6md2AyRp2LnArNKyrKCva6pWCdzaA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/846] 5.15.17-rc1 review
To:     =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux@roeck-us.net,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux- stable <stable@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 12:36 PM Holger Hoffst=C3=A4tte
<holger@applied-asynchrony.com> wrote:
>
> On 2022-01-24 19:31, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.17 release.
>
> Oh noes :(
>
>    DESCEND bpf/resolve_btfids
>    MKDIR     /tmp/linux-5.15.17/tools/bpf/resolve_btfids//libbpf
>    GEN     /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/bpf_helper_=
defs.h
>    MKDIR   /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/
>    CC      /tmp/linux-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/=
libbpf.o
> libbpf.c: In function 'bpf_object__elf_collect':
> libbpf.c:3038:31: error: invalid type argument of '->' (have 'GElf_Shdr' =
{aka 'Elf64_Shdr'})
>   3038 |                         if (sh->sh_type !=3D SHT_PROGBITS)
>        |                               ^~
> libbpf.c:3042:31: error: invalid type argument of '->' (have 'GElf_Shdr' =
{aka 'Elf64_Shdr'})
>   3042 |                         if (sh->sh_type !=3D SHT_PROGBITS)
>        |                               ^~
> make[4]: *** [/tmp/linux-5.15.17/tools/build/Makefile.build:97: /tmp/linu=
x-5.15.17/tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o] Error 1
> make[3]: *** [Makefile:158: /tmp/linux-5.15.17/tools/bpf/resolve_btfids/l=
ibbpf/staticobjs/libbpf-in.o] Error 2
> make[2]: *** [Makefile:44: /tmp/linux-5.15.17/tools/bpf/resolve_btfids//l=
ibbpf/libbpf.a] Error 2
> make[1]: *** [Makefile:72: bpf/resolve_btfids] Error 2
> make: *** [Makefile:1371: tools/bpf/resolve_btfids] Error 2
>
> Reverting "libbpf-validate-that-.btf-and-.btf.ext-sections-cont.patcht" a=
ka
> this one:
>
> > Andrii Nakryiko <andrii@kernel.org>
> >      libbpf: Validate that .BTF and .BTF.ext sections contain data
>
> makes it build & run fine. I looked for followups but couldn't find anyth=
ing that
> stood out, maybe the BPF folks (cc'ed) know what's missing/wrong.
>

That small fix depends on much bigger refactoring in ad23b7238474
("libbpf: Use Elf64-specific types explicitly for dealing with ELF").
I think this small fix can be dropped.

That's sort of a general rule with libbpf-related fixes, they are
usually not that critical to backport to stable, because most users
use/build libbpf from its Github mirror, which is always taken from
latest bpf-next. Libbpf is also not supposed to be used with untrusted
inputs (i.e., BPF object files) as BPF programs are loaded into the
kernel under root.


> cheers
> Holger
