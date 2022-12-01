Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B9863E9BE
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 07:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLAGPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 01:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiLAGPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 01:15:37 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545D8A9CD3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 22:15:34 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id s16so364896iln.4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 22:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I3cbFWF/3wbRJ/LJGSbr3S2YLSTVjERFCva7QGH+gmg=;
        b=TQXq8UL4QgqOzU99DZ2FZnR8wuYuOhizw+MMZjtpJkUFGvg9P5i/lw/RWwqrdLoDKQ
         UnpYETf8awGpkGv3IpRi451RomQ6opklMdUuCi/w2gZGRvoMjNeIrHS4ZTPjma5Cv/Ud
         loNtoud4t9r43vBYNniWgJcERDfHHrHCNMnplIvKD71BxqW7j1JsRNYzUaMxlrgy1NHn
         6xdNTQN8tz+KfNNFtAnd4cswjrjr9nbNCsv8wa5thCsyCu4zRmoJ3wvA83cBbsAM1nN7
         IfS70kBNMfXBwfegiGQRDlLftR0WgGHsIJ9aky32vwQM38kMW3gkXoC+vm0tjq4uMYNc
         2iBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3cbFWF/3wbRJ/LJGSbr3S2YLSTVjERFCva7QGH+gmg=;
        b=dPzMqFj6Y6gO5WvXtNoDa4s6ro4PcjdaN5L+rze4JeKNwJZ335jO7ZfBb0V6ECmOQw
         RczG1AHewg4B7ax84JeYO/L3HDbRkc3dk0aCX/F0KLpz1R9adiHKyLiMghPGe2Le2KBS
         E1XDnwCMpjixY1OEDx0L6d+7qo4DRWPxGDkZGBSFWZdFoVjwT5wdUCuBxj9Y4U8OWzi1
         VMok3BuZOdULU/82TsSgl7/SRDrt9ummWG3nmMoPs//1x4OmYwUqJ9HyltqwSJ5lxLMT
         UJps8wA32ySblpDrj59OCFzwNY+hB5a30anmXTUM/chqHoU1V27hGt3wmFaXbjl9uph7
         aJmQ==
X-Gm-Message-State: ANoB5pmsKztVI2PQ89uiZakF6ioCuIvt3B8lv+Asfzzy9H512PobpeHL
        dhDxyxwc7qRcfD7rxz/jNek8MAThbLcQFhHryzj95Q==
X-Google-Smtp-Source: AA0mqf6datZ2W/Sl/db9jupMjDNWdTR8+AnW/Km4dlC/pKlQg+8tzrVb8F6lOwvMJ2ylFNiAwvsV75vh6r2wBQp1BT8=
X-Received: by 2002:a92:db4b:0:b0:302:5575:9e46 with SMTP id
 w11-20020a92db4b000000b0030255759e46mr29366206ilq.41.1669875333395; Wed, 30
 Nov 2022 22:15:33 -0800 (PST)
MIME-Version: 1.0
References: <20221130180544.105550592@linuxfoundation.org>
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 1 Dec 2022 11:44:53 +0530
Message-ID: <CA+G9fYuJVxhKbeN9OGCr2_zyfa1k3j4DS1gAoTW0P89Eyz2FHg@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        bpf <bpf@vger.kernel.org>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 1 Dec 2022 at 00:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
Regressions found on x86_64:

    - build-clang-15-allmodconfig-x86_64
    - build-clang-nightly-allmodconfig-x86_64

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

    bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)
    [ Upstream commit c86df29d11dfba27c0a1f5039cd6fe387fbf4239 ]

Causing the following build warnings / errors with clang-15 allmodconfig
on x86_64,

Build error:
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
ARCH=x86_64 SRCARCH=x86 CROSS_COMPILE=x86_64-linux-gnu-
'HOSTCC=sccache clang' 'CC=sccache clang'
kernel/bpf/dispatcher.c:126:33: error: pointer type mismatch ('void *'
and 'unsigned int (*)(const void *, const struct bpf_insn *,
bpf_func_t)' (aka 'unsigned int (*)(const void *, const struct
bpf_insn *, unsigned int (*)(const void *, const struct bpf_insn
*))')) [-Werror,-Wpointer-type-mismatch]
        __BPF_DISPATCHER_UPDATE(d, new ?: &bpf_dispatcher_nop_func);
                                   ~~~ ^  ~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/bpf.h:938:54: note: expanded from macro '__BPF_DISPATCHER_UPDATE'
        __static_call_update((_d)->sc_key, (_d)->sc_tramp, (_new))
                                                            ^~~~
1 error generated.

Build logs:
  - https://builds.tuxbuild.com/2IHYTj6JN108YShWQ8K8Fd0HyVW/

--
Linaro LKFT
https://lkft.linaro.org
