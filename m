Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06A837F7D5
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhEMMZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbhEMMZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 08:25:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775C5C0613ED
        for <stable@vger.kernel.org>; Thu, 13 May 2021 05:23:59 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id n2so39576845ejy.7
        for <stable@vger.kernel.org>; Thu, 13 May 2021 05:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O/EgZ0Mib/f1h1pn6ynsix9LbKLcelscbkr1YNLcxt0=;
        b=tCXa270jHTARQ+SrPRUuPKjez1uo4RI0PDczBLDyslWWXw5kc8l/rKW/hg/e0ObEC5
         9vF6BFhmbnrL1EizRV+UeRzphaQXA3XLTCh3aRPFPt/gDbBhIm9RLXj33bEc+mNNAQH5
         CXgvNyTXpmQkBzZHu40ZzdG5wdLWNh06ZAZmXoiNdd8sSlLTu2/PbTqWgSQi1zfNLb89
         obXXqRFErYFjFrxXhsgP7jLVHT8Ct6F6KTkP3dUoni7Skl/Z+RIm0CzJHXGe5lalfY2n
         DY+PrAL/q2XtreThld8QGQlWTo5+4BCYszLN4HMiS43J0vVmMlQVzVjcn9KJjLvYuvFK
         hk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O/EgZ0Mib/f1h1pn6ynsix9LbKLcelscbkr1YNLcxt0=;
        b=faj3WoQ6+2dDRvzEDLhu7q+TNf0J213LzEJP7tv5HROikS99MJbTWJhDDTR7ICRGSD
         kjvyTpofdVGH+2GliPIRiUA9QVp5GAAf3IO/LjFWoX19JEtD59kAoEPCSRyeppIufMde
         y9CdmtvPfNUhORZ6M3zuduAiSQdqwrjksueIjGyJrDD6VhxlDELBjkF9KKUivbD1T2hk
         8/O2hOCULYb3l9EfhilZ/9RNjZJBmLlExcDcHgr7qL8BUZgHJ3/dbjgCf9QlxrhT60Xy
         PfzFADoo9Wr65ph6B2dSbEzImom4TbvSggzb9pYHHsgggaZQDvYk7r7OBVSE6OH/owGe
         i2EQ==
X-Gm-Message-State: AOAM532YehHLqY2YEKtmtPLx3I8gKVAFQQl00p90TLcE+LrguAeCK4ao
        H0CzRfzZj6R/Tla+z5FqEwAxtRJvQmz0NRVSAArUqg==
X-Google-Smtp-Source: ABdhPJzKsGAqpkUcIG97jIx+mrSeLSOY0Z3A2rGv49qhwxB5VfeKopzZ4b9Kyxf2I5g3UyueWtekoNaK6tdTEvYDh5w=
X-Received: by 2002:a17:906:c211:: with SMTP id d17mr8276408ejz.247.1620908638026;
 Thu, 13 May 2021 05:23:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144743.039977287@linuxfoundation.org> <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
 <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
In-Reply-To: <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 13 May 2021 17:53:46 +0530
Message-ID: <CA+G9fYuVkX20yUZgtEVAmNc_kheKjnNZXcdSPW2HecXNKmcBBQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Marc Zyngier <maz@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Alex,

On Wed, 12 May 2021 at 22:29, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi Naresh,
>
> Thank you for the report!
>
> On 5/12/21 5:47 PM, Naresh Kamboju wrote:
> > On Wed, 12 May 2021 at 20:22, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >> This is the start of the stable review cycle for the 5.4.119 release.
> >> There are 244 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
> >> or in the git tree and branch at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> > Build regression detected.
> >
> >> Alexandru Elisei <alexandru.elisei@arm.com>
> >>     KVM: arm64: Initialize VCPU mdcr_el2 before loading it
> > stable rc 5.4 arm axm55xx_defconfig builds failed due to these
> > warnings / errors.
> >   - arm (axm55xx_defconfig) with gcc-8,9 and 10 failed
> >
> > arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_vcpu_first_run_init':
> > arch/arm/kvm/../../../virt/kvm/arm/arm.c:582:2: error: implicit
> > declaration of function 'kvm_arm_vcpu_init_debug'; did you mean
> > 'kvm_arm_init_debug'? [-Werror=implicit-function-declaration]
> >   kvm_arm_vcpu_init_debug(vcpu);
> >   ^~~~~~~~~~~~~~~~~~~~~~~
> >   kvm_arm_init_debug
> > cc1: some warnings being treated as errors
>
> This is my fault, in Linux v5.4 KVM for arm is still around, and there's no
> prototype for the function when compiling for arm. I suspect that's also the case
> for v4.19.
>
> I made this change to get it to build:
>
> $ git diff
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index dd03d5e01a94..32564b017ba0 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -335,6 +335,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu,
> int cpu) {}
>  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>
>  static inline void kvm_arm_init_debug(void) {}
> +static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
>
> which matches the stub for kvm_arm_init_debug(). I can spin a patch out of it and
> send it for 5.4 and 4.19. Marc, what do you think?

FYI,
This proposed fix patch applied and built PASS on the arm.
(you may apply this patch for the next round of stable rc review)

- Naresh
