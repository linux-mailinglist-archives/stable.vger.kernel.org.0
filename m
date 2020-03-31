Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3AB19A25E
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 01:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbgCaXTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 19:19:11 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35790 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729647AbgCaXTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 19:19:11 -0400
Received: by mail-lj1-f195.google.com with SMTP id k21so23863507ljh.2
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 16:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DNZLvGPKS7ifGuavc6HxXaBrmBaYInXs47Z6xKmXacc=;
        b=VOIY9W9yz7aKp8dPnogI0Y+SRXVPfbBixuGZxyza7lb4oloPNrQYB3RHynO7AIh3LS
         1fv7jv3qUfyUt67cnhH5Ql1JTxuZHfpuZi6iueB3w0e+PKBfIg3FP2EFd2YbVEgdJBWF
         A/Dsu42vzRwa63ALNlmrOa1zpmk1EKCy5qbAGGBaW/TNdqYW3hLwyDjxM+6b5uPzARPA
         20TDwJpuyiRXupt8Heso9aokoomFq+0knjX6E+1s7/ck2sZ1fLi752RZ6nXMaaZR/KSU
         5hdmVJq46CEJIxbar0uPv5bznP7FdsoK3DQR1F1nWZvA4DM4YWJWWjd4I38PJE1EjooG
         8tSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DNZLvGPKS7ifGuavc6HxXaBrmBaYInXs47Z6xKmXacc=;
        b=K2Wa28Z4p6j31d4KMW0ya879mhdVlCRwqYZ4izy/PeNlP8Q4Wwl0CCB1NYqH7ekI6u
         lyzL40RIIcbnzgnjP+3qIfGNnotfZBKkcvkkmQYtP/oaDKD4mgCfI6DZv53TG+FGJttB
         60Je4ICWydUhiEGp8TEocmP5n2spRD2GWF85VTkVmT3hQeFEpNWVIxYojkP2ZJHGSWsw
         beAh9agkfSPZSEGUTgYloa2A62lSEg0SPHF2JjkzHQsZF5edvA0VQQSVYlTT+lZ/fOZS
         Pi/w30NJirQojpqVn8X3cFIpY2q7BGQSHcqZPonwu/h332ySPKMqEQ55cnuXSpZols8A
         pXrQ==
X-Gm-Message-State: AGi0PuaI/YFFfmvwk6PyNUV3vSh+xasEK11uYaXxDEeEwVIc+AWmwUQC
        Fr8xDKhD6hx0XKHuc2vuZFZlWPT7lWN6qaWmqy1jig==
X-Google-Smtp-Source: APiQypKLQfeXmbpfCSKxjxNDfDESvbR/4c3x5o3NczPGdzzeGc2PxgmbZ0POJwPpA1OAl+xzMjMD33hImdfNEkDFqHY=
X-Received: by 2002:a2e:700e:: with SMTP id l14mr10496920ljc.51.1585696748342;
 Tue, 31 Mar 2020 16:19:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200331085308.098696461@linuxfoundation.org> <CA+G9fYsZjmf34pQT1DeLN_DDwvxCWEkbzBfF0q2VERHb25dfZQ@mail.gmail.com>
 <CAHk-=whyW9TXfYxyxUW6hP9e0A=5MnOHrTarr4_k0hiddxq69Q@mail.gmail.com> <20200331192949.GN9917@kernel.org>
In-Reply-To: <20200331192949.GN9917@kernel.org>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Tue, 31 Mar 2020 17:18:57 -0600
Message-ID: <CAEUSe7_f8m0dLQT1jdU+87fNThnxMKuoGJkFuGpbT4OmpmE4iA@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Tue, 31 Mar 2020 at 13:29, Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Tue, Mar 31, 2020 at 11:20:37AM -0700, Linus Torvalds escreveu:
> > On Tue, Mar 31, 2020 at 11:08 AM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > >
> > > Perf build broken on Linux next and mainline and now on stable-rc-5.6=
 branch.
> >
> > Strange. What is it that triggers the problem for you? It works fine
> > here.. The error looks like some kind of command line quoting error,
> > but I don't see the direct cause.
> >
> > Have you bisected the failure? Build failures should be particularly
> > easy and quick to bisect.
>
> Naresh, can you try with the patch below? There was some back and forth
> about a second patch in a series and this fell thru the cracks.

I tried that patch, did not help.

Bisection led to the expected merge, "perf-urgent-for-linus", so I
went one by one and found this commit: a7ffd416d804 ("perf python: Fix
clang detection when using CC=3Dclang-version"). Specifically, the line
that fails is:

  cc_is_clang =3D b"clang version" in Popen([cc, "-v"],
stderr=3DPIPE).stderr.readline()

with:

  Traceback (most recent call last):
    File "util/setup.py", line 6, in <module>
      cc_is_clang =3D b"clang version" in Popen([cc, "-v"],
stderr=3DPIPE).stderr.readline()
    File "/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot-n=
ative/usr/lib/python2.7/subprocess.py",
line 394, in __init__
      errread, errwrite)
    File "/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot-n=
ative/usr/lib/python2.7/subprocess.py",
line 1047, in _execute_child
      raise child_exception
  OSError: [Errno 2] No such file or directory

There, the value for CC is "aarch64-linaro-linux-gcc
--sysroot=3D/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot=
".

> And also, BTW, can you please send me instructions on how to get hold of
> the toolchain you use to crossbuild perf, so that I can add it to my set
> of test build containers?

It's an OE build, so it's bound to take quite a bit of space. I'll try
to get something dockerized so that it's easier to replicate.

Thanks and greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org



> - Arnaldo
>
> ---
>
> From: He Zhe <zhe.he@windriver.com>
>
> The $(CC) passed to arch_errno_names.sh may include a series of parameter=
s
> along with gcc itself. To avoid overwriting the following parameters of
> arch_errno_names.sh and break the build like below, we just pick up the
> first word of the $(CC).
>
> find: unknown predicate `-m64/arch'
> x86_64-wrs-linux-gcc: warning: '-x c' after last input file has no effect
> x86_64-wrs-linux-gcc: error: unrecognized command line option '-m64/inclu=
de/uapi/asm-generic/errno.h'
> x86_64-wrs-linux-gcc: fatal error: no input files
>
> Signed-off-by: He Zhe <zhe.he@windriver.com>
> ---
>  tools/perf/Makefile.perf | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 3eda9d4..7114c11 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -573,7 +573,7 @@ arch_errno_hdr_dir :=3D $(srctree)/tools
>  arch_errno_tbl :=3D $(srctree)/tools/perf/trace/beauty/arch_errno_names.=
sh
>
>  $(arch_errno_name_array): $(arch_errno_tbl)
> -       $(Q)$(SHELL) '$(arch_errno_tbl)' $(CC) $(arch_errno_hdr_dir) > $@
> +       $(Q)$(SHELL) '$(arch_errno_tbl)' $(firstword $(CC)) $(arch_errno_=
hdr_dir) > $@
>
>  sync_file_range_arrays :=3D $(beauty_outdir)/sync_file_range_arrays.c
>  sync_file_range_tbls :=3D $(srctree)/tools/perf/trace/beauty/sync_file_r=
ange.sh
> --
> 2.7.4
>
