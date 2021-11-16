Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C47E452A4A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 07:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240072AbhKPGFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 01:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbhKPGE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 01:04:58 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADE5C079795;
        Mon, 15 Nov 2021 21:58:07 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id y68so48875968ybe.1;
        Mon, 15 Nov 2021 21:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwQbbB+o9iFHKHMMakR4a/9yedm1CycVNM0ARkL4Ywc=;
        b=HHJqLNdhGHu+SOFMVNqyvbD8fgOVsyNW66mYrrln1ubpoh2hGONrP2k9fs5fyHHp6I
         hNGfhYyCz61ia8FoMcYNeHgj2re+Zmdmy93DpV3P1wcK+e4NE6eSsFqE3jgcHBu1k6Y3
         ahQGEstOcGsrGjy8PSNlMshnOQ3TkbDhbam4qscwSao4Z57UbiSxv16W6tC2oZpIUutu
         SwCS11Lf9nIO6aI9o0CfWLIoH5KVXj8UsSntIh6x7GwVJtSf4LMqHIHN2xVPgZvo3WTo
         1Y8a+9cXp3qtWXgg6GMJSS4IrX18zMZzA020M1TjQqsLUecSaUu6P9LYLdXZVx9jK2tu
         iiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwQbbB+o9iFHKHMMakR4a/9yedm1CycVNM0ARkL4Ywc=;
        b=Y0z0Pe1M+Ra+jq1ZomIErq8uLRec/b+hVL3RL6rH0DYdVJB7ShsbDHnnrJRB7E7EAd
         sUOxI2e5DX9d161KLsJm137K+QHCgA1SriXDaQonQeKiVeLAT7t4ATEaIcP0wNx9e+Zs
         MZD3RCRThdj5PCxITwbhhGFBDdSji0K1nEox/UPsLAuVosh2Nie+ARNEHctWkJgM4dxB
         IyKGcRfwYKvSYTZsM4Mc07ZJn1VkMIszvfOcuYiDX85JV8Nl10rD1uGnBc3VnX2id2XD
         KbgsiG4SWc4oFHgwIw6iyWWsNTzodd9udqXg6SVu6H2RFlVl2QFveGfgvAwR7jEusAcw
         yzKg==
X-Gm-Message-State: AOAM533uQ4X2bypRnS4/yVG/piwPe+gV8MBlUpi/iUU60N2fM+iU5KRC
        XH+k/7vH2CiFpvMznHCPI+rKtbgV2GRJMpwfebI/imEC8rs=
X-Google-Smtp-Source: ABdhPJy/XFTN66T4NkHoWvK070CLFU0NcH1wCiGJkOEZhzbiEF979SeVeR/laiSwDMifMU6FzmTJNLCvDJgCfJM3q8k=
X-Received: by 2002:a25:d010:: with SMTP id h16mr5981439ybg.225.1637042286816;
 Mon, 15 Nov 2021 21:58:06 -0800 (PST)
MIME-Version: 1.0
References: <20211115165313.549179499@linuxfoundation.org> <CA+G9fYvxhzL9KUxZcRzMxnbGPK5GKTCtb5kWM3JB09D+-KhVug@mail.gmail.com>
In-Reply-To: <CA+G9fYvxhzL9KUxZcRzMxnbGPK5GKTCtb5kWM3JB09D+-KhVug@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Nov 2021 21:57:55 -0800
Message-ID: <CAEf4BzZHsbAhA6RJYias+e10PsXWbOD9ekyNMAHKt5PKAGe=Rw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/355] 5.4.160-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, f.fainelli@gmail.com,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, linux- stable <stable@vger.kernel.org>,
        pavel@denx.de, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux@roeck-us.net, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 10:00 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Mon, 15 Nov 2021 at 22:39, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.160 release.
> > There are 355 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.160-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> Perf build broken due to following errors.
>
> > Andrii Nakryiko <andrii@kernel.org>
> >     libbpf: Fix BTF data layout checks and allow empty BTF
>
>
> In file included from btf.c:17:
> btf.c: In function 'btf_parse_hdr':
> btf.c:104:62: error: 'struct btf' has no member named 'raw_size'; did
> you mean 'data_size'?
>   104 |                 pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
>       |                                                              ^~~~~~~~
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Build log:
> https://builds.tuxbuild.com/20xsgAxLwf4E60xl2dTdXnNS8FZ/

Greg,

c733c19fda7b ("libbpf: Fix BTF data layout checks and allow empty
BTF") should either be dropped, or fixed like the below:

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3380aadb7465..41daf0fa95b9 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -101,7 +101,7 @@ static int btf_parse_hdr(struct btf *btf)
        }

        if (meta_left < hdr->str_off + hdr->str_len) {
-               pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
+               pr_debug("Invalid BTF total size:%u\n", btf->data_size);
                return -EINVAL;
        }

Not sure which one you'd prefer. Both will fix perf build.

>
> --
> Linaro LKFT
> https://lkft.linaro.org
