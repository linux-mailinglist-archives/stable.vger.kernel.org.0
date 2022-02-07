Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7104ABF44
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386669AbiBGNEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388906AbiBGMjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 07:39:12 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5AFC033256
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 04:29:47 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id p5so39240977ybd.13
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 04:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zFqQ4IUhh5vrztnUr/w/RGdaRcKDiZgiBwmvAthyBgg=;
        b=VN+FcB+RSvt9TStrknBTJ9/6bBJGnhDmxvWrAUS8ukTM3V8TQy0ZgdfR1JkLwgNB3V
         YskmmsD3gir3pMGVQpb1dsfRUT1M4w6JljiA67SFvXWGHfYCva42QhHgnQYyfrTbWz4v
         t46BA05XelyzFpcBHUd9c5VpyweixV+Z6qN5m2EnRUiirmu/wuUcIB+YEOlY9pCNLgcr
         /Q6LIclFHwUP0iQm2QRVsFyVJQ0paCUzBwxh7T60uJCHm6j2q9YNkmmTISRWtGJ7szPV
         B6nsE0NZXlRo50QV6N4KtvmM86OcE6ZSH6hTYpwYE0OmkMpbNv3C8zkbKMh+HtEi3JC8
         FEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zFqQ4IUhh5vrztnUr/w/RGdaRcKDiZgiBwmvAthyBgg=;
        b=GZodCFck4Qg6V8RU6RDcoJR6bBjOfMLHsd11NZY/U9b2QfgJWIoUAwpEdtcRdRrHji
         wUSZ+IaOoReJQ68Ld9rlrDS7ANJwlgSFrAZAVOX7VtSUWOPIVu8bnjJ+JQl/ppDiEpim
         nA11oCmhJYffffRW8VY4eHdPGbDJnfWUBj7+obvLd3WchSLnAnUNE4U8BmU82YluI1v1
         ycZCRmzeHHqt1+XnCt0FSM4VD40RPr6VmXJGkN/w5VAlVJJfRFUWnpL6/NKE+tOk19aa
         lpcCTQN904zZFCu2PrASawh+msRdEw9cGSQdb6B5FxYwRdzPao4Gs64TsRKMjjiocEpb
         Silg==
X-Gm-Message-State: AOAM533OLs9i0vsCT9EMtNsJYRvlZDPTEbvIIBcjkz/vrrJL1BcOx/tV
        Cu+JMBozteY4HEsk6LzEIt/gOl3+VtXyLnxllwnU7g==
X-Google-Smtp-Source: ABdhPJzrRE2p9LRRkBiCf1z3sq4PCL4vokQUZAyBx14AqSX+BLjiHW9TChxVT7HaWTtBHB6TmmWZIX2APyxubPvxA64=
X-Received: by 2002:a25:1402:: with SMTP id 2mr9338333ybu.684.1644236986311;
 Mon, 07 Feb 2022 04:29:46 -0800 (PST)
MIME-Version: 1.0
References: <20220207103802.280120990@linuxfoundation.org>
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 7 Feb 2022 17:59:34 +0530
Message-ID: <CA+G9fYtLmasiEHvfTw+PSabJCfJR2d8yiVyhn1nd4TcKfZ7bOw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/110] 5.15.22-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Marc Zyngier <maz@kernel.org>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 7 Feb 2022 at 16:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.22 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.22-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Linux stable-rc 5.15 and 5.16 arm64 builds failed due to below errors.

  kvm/arm64: rework guest entry logic
  [ Upstream commit 8cfe148a7136bc60452a5c6b7ac2d9d15c36909b ]

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

arch/arm64/kvm/arm.c: In function 'kvm_arm_vcpu_enter_exit':
arch/arm64/kvm/arm.c:769:9: error: implicit declaration of function
'guest_state_enter_irqoff'; did you mean 'guest_enter_irqoff'?
[-Werror=implicit-function-declaration]
  769 |         guest_state_enter_irqoff();
      |         ^~~~~~~~~~~~~~~~~~~~~~~~
      |         guest_enter_irqoff
arch/arm64/kvm/arm.c:771:9: error: implicit declaration of function
'guest_state_exit_irqoff'; did you mean 'guest_exit_irqoff'?
[-Werror=implicit-function-declaration]
  771 |         guest_state_exit_irqoff();
      |         ^~~~~~~~~~~~~~~~~~~~~~~
      |         guest_exit_irqoff
arch/arm64/kvm/arm.c: In function 'kvm_arch_vcpu_ioctl_run':
arch/arm64/kvm/arm.c:866:17: error: implicit declaration of function
'guest_timing_enter_irqoff'; did you mean 'guest_enter_irqoff'?
[-Werror=implicit-function-declaration]
  866 |                 guest_timing_enter_irqoff();
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
      |                 guest_enter_irqoff
arch/arm64/kvm/arm.c:916:17: error: implicit declaration of function
'guest_timing_exit_irqoff'; did you mean 'guest_exit_irqoff'?
[-Werror=implicit-function-declaration]
  916 |                 guest_timing_exit_irqoff();
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~
      |                 guest_exit_irqoff
cc1: some warnings being treated as errors


build link:
-----------
https://builds.tuxbuild.com/24mNSY65SpZIASD4qYSPgMWIVqH/

steps to reproduce:
tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig https://builds.tuxbuild.com/24mNSY65SpZIASD4qYSPgMWIVqH/config

--
Linaro LKFT
https://lkft.linaro.org
