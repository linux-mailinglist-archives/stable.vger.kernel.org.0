Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B7633AD24
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCOIQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhCOIPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:15:35 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B36FC061574
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 01:15:34 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ci14so64459940ejc.7
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 01:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3E/HgAUGKBXr8cYQC+XkQtHB2ouqiR5oxRiytLTvQdI=;
        b=V1LHhRnHlGYLoum/ubHEEwn+LaldOacEI/ogN+unCyoIpgKYYnsrgpYMTlCB8Kxtqp
         53mOHhBVia/OxlUV/NtkiE6MbEuewgIA68XkQZgHtyMYMX6wtH1NOwH7HIPmQklUDG8Q
         +C50CqYFhtfibUWKGqsh1i5EpLei8zYkUVZjHXMpt5b74mYqENVzNXkEZU1dk/mCgnR7
         wYpNSE3c+Fslcdp07ZVxgz5TfpWFzXa8gV0q4Fn/z7YSLv3UaLUcB9GFNOJolBEiq3DZ
         9eYUIY9fzv5l6IrBAxUpww1YW2fJKzGGv4c1crkqWArMPB9xFkn904uZFf/Oh4sa90Q3
         LgEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3E/HgAUGKBXr8cYQC+XkQtHB2ouqiR5oxRiytLTvQdI=;
        b=oawyycKyA4Mup6m8yeteN9xzK48cMWgDCeiWtWvw4BBxKYSrpiKYAYFVqF/DuoCUsn
         gYjQJj38KwFqHsM6+RhfliqxLbY8oRJSKcllzwg5UuqUNg7jVa9srazXxGWAsJ7cmN1y
         HIpSgAFKbKZbGGsjTpncSuYTM+S2E4k63FGnMmh+MI9QhKHmuUy70Ufi0Te/NYQfe22w
         DAzoj2WIzLjpY+QlD26r0prmOekGzLtDC1MiOJroj8UCOCgXOuM/+LbvMNI+znWrASg9
         xGUlmPU6ejNaC9h8pKuMlA1R/4ysNpy/ubbspOy3B7n/X2s52nEvqz6Cisa+E/RHMzB0
         sfyQ==
X-Gm-Message-State: AOAM531aZDb6oQKlGt27ud3Bi3UtaLw+71hch/tzULl1fpzK32lz9QfV
        4Kw3BkYKozw/BBJoYW+J+fCQ2loZk9+vy/uZPsND2t2qqkAbA2Y3
X-Google-Smtp-Source: ABdhPJwJZL6iRC5jAIPXDRG+Qsz9glQBq+eH1fa64oEGXAjWVO2I4SEwzYZWl1pTHuewmaTLHJlbdiC00R+KQccNIGQ=
X-Received: by 2002:a17:906:a052:: with SMTP id bg18mr22474577ejb.18.1615796132999;
 Mon, 15 Mar 2021 01:15:32 -0700 (PDT)
MIME-Version: 1.0
References: <be846d89-ab5a-f02a-c05e-1cd40acc5baa@roeck-us.net>
In-Reply-To: <be846d89-ab5a-f02a-c05e-1cd40acc5baa@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 15 Mar 2021 13:45:21 +0530
Message-ID: <CA+G9fYv+46uD-RqW9ue5x_4_JF_iKYavd9PDnEFsrEUvvVZStg@mail.gmail.com>
Subject: Re: v4.19.y-queue, v5.4.y-queue stable rc build failures
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Mar 2021 at 05:56, Guenter Roeck <linux@roeck-us.net> wrote:
>
> Building arm:axm55xx_defconfig ... failed
> --------------
> Error log:
> /tmp/cc2ylxxJ.s: Assembler messages:
> /tmp/cc2ylxxJ.s:87: Error: co-processor register expected -- `mrc p10,7,r7,FPEXC,cr0,0'
> /tmp/cc2ylxxJ.s:103: Error: co-processor register expected -- `mcr p10,7,r3,FPEXC,cr0,0'
> /tmp/cc2ylxxJ.s:537: Error: co-processor register expected -- `mcr p10,7,r7,FPEXC,cr0,0'
> make[3]: *** [arch/arm/kvm/hyp/switch.o] Error 1
> make[2]: *** [arch/arm/kvm/hyp] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [arch/arm/kvm] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [sub-make] Error 2

These issues were noticed on the stable rc 5.4 branch also while building for
arm axm55xx_defconfig.

/tmp/ccKgdkaN.s: Assembler messages:
/tmp/ccKgdkaN.s:87: Error: co-processor register expected -- `mrc
p10,7,r7,FPEXC,cr0,0'
/tmp/ccKgdkaN.s:103: Error: co-processor register expected -- `mcr
p10,7,r3,FPEXC,cr0,0'
/tmp/ccKgdkaN.s:556: Error: co-processor register expected -- `mcr
p10,7,r7,FPEXC,cr0,0'
make[3]: *** [/builds/1piRajjPILoGGDzi5cHI5ZMuCJZ/scripts/Makefile.build:261:
arch/arm/kvm/hyp/switch.o] Error 1


> --------------
>
> I didn't find an obvious candidate so I bisected it.
>
> # bad: [a233c6b3f6de88ca62da8fde45f330b104827851] Linux 4.19.181-rc1
> # good: [030194a5b292bb7613407668d85af0b987bb9839] Linux 4.19.180
> git bisect start 'HEAD' 'v4.19.180'
> # good: [ecee76d4b15b8431827e910589edfb4c12a589f9] powerpc/perf: Record counter overflow always if SAMPLE_IP is unset
> git bisect good ecee76d4b15b8431827e910589edfb4c12a589f9
> # good: [722ce092b23ae91337694d40e6ac216b16962788] ARM: 8929/1: use APSR_nzcv instead of r15 as mrc operand
> git bisect good 722ce092b23ae91337694d40e6ac216b16962788
> # bad: [2e6919206bb0bcac507b7905fc7c9b3dd861ab4b] ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on !LD_IS_LLD
> git bisect bad 2e6919206bb0bcac507b7905fc7c9b3dd861ab4b
> # good: [831e354481111c30d68c980434e2cfe42590f189] kbuild: add CONFIG_LD_IS_LLD
> git bisect good 831e354481111c30d68c980434e2cfe42590f189
> # bad: [9b99f469087843c9216976865a97da96f9cdcbbc] ARM: 8991/1: use VFP assembler mnemonics if available
> git bisect bad 9b99f469087843c9216976865a97da96f9cdcbbc
> # good: [41ad45cb9ecb66f76abc77d938b3693839fb5e20] ARM: 8990/1: use VFP assembler mnemonics in register load/store macros
> git bisect good 41ad45cb9ecb66f76abc77d938b3693839fb5e20
> # first bad commit: [9b99f469087843c9216976865a97da96f9cdcbbc] ARM: 8991/1: use VFP assembler mnemonics if available
>
> Reverting the offending patch from v4.19.y-queue fixes the problem.
> I didn't check v5.4.y-queue.

https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1095669013#L346

- Naresh
