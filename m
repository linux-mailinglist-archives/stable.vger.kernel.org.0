Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1084D37D19C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbhELR7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345965AbhELRMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 13:12:35 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31727C06174A;
        Wed, 12 May 2021 10:03:53 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id g15-20020a9d128f0000b02902a7d7a7bb6eso21178309otg.9;
        Wed, 12 May 2021 10:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GQY3BWbMy9+/6V8xt2qeBB5wUj+Dk0xC8e1RwDTKwgY=;
        b=ABbmoiaLS7kWwiM1hNQv32Kxv5Wf5VEttMvkx/HieokwPGCGeGP+/e0OXYr1WLwWeE
         X+IQARzf+g3ordHnEf9eLN54QPlIz4oCRY0XGslthb+grNmd5jGBG25lmHfuxPvvwIsI
         8n8/G8SbPu+HXalO7YVnrme56eh7vKNtU7hBcuWNH2xWxm7FdeO1e6/Gjo5PIv+l2nkg
         ymG5MNGLycWt2g19jyw3qvztdOGoLN/ohm13YseJGdl56y57yP4mH2SgrRhdeFHDbE/e
         89YJB4otzkNs4j8UJM1u7L37q6YuNbzbzKKWid2/d35f9ok5kY28vUt9V5Nls3UGxA5g
         j19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=GQY3BWbMy9+/6V8xt2qeBB5wUj+Dk0xC8e1RwDTKwgY=;
        b=t4ZU005ITdfnPJN66FyVJXYZEFWH7cX3eC9I+aQuBb7VH74TCULLAP+QJMVGaNZCGM
         n7qO27RJVNWPBx3yLWsBFdenUUvS5u2tIEMAZOo50r4+6uORSWM7i/ScbbuFFCJtDCxg
         wFgHcc4USC78OUjMbuX0lOkXYMht/sndxYotByxw6VXwY4DnZzXdyejU0NBxRHGRT3kS
         pOkkw/DVRG1O5aQu0lekqxzMgSGA2pH0quABbq188sUtby5X/7Gdkcv84FxwoK1SOeRI
         ZlgRRa0Id5hrMRTWD0QUz5/i0w09IuFu/bftvIaWGBGExM52eaKcYwiZkhkI1vHRtN/k
         xf/g==
X-Gm-Message-State: AOAM533/Ak5PrDmIu0H/8UIX49RptF3zWfYkd9YLtWkuer+/Eee+mR6D
        8tF67kn8ELUDBFFgxBxM8c30xR3qwhM=
X-Google-Smtp-Source: ABdhPJze1icLTqJpnsPuqAWyMdwpAW0H8Px+lIVDzFprpriTmtx+5+uJinwOMyRsrv3BiXr4Mxs34A==
X-Received: by 2002:a05:6830:803:: with SMTP id r3mr27456804ots.237.1620839033196;
        Wed, 12 May 2021 10:03:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c65sm87223oia.47.2021.05.12.10.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 10:03:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 12 May 2021 10:03:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
Message-ID: <20210512170350.GA1277039@roeck-us.net>
References: <20210512144743.039977287@linuxfoundation.org>
 <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
 <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 06:00:16PM +0100, Alexandru Elisei wrote:
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

Correct.

Guenter

> I made this change to get it to build:
> 
> $ git diff
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index dd03d5e01a94..32564b017ba0 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -335,6 +335,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu,
> int cpu) {}
>  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  
>  static inline void kvm_arm_init_debug(void) {}
> +static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
> 
> which matches the stub for kvm_arm_init_debug(). I can spin a patch out of it and
> send it for 5.4 and 4.19. Marc, what do you think?
> 
> Thanks,
> 
> Alex
> 
> >
> >
> > steps to reproduce:
> > --------------------
> > #!/bin/sh
> >
> > # TuxMake is a command line tool and Python library that provides
> > # portable and repeatable Linux kernel builds across a variety of
> > # architectures, toolchains, kernel configurations, and make targets.
> > #
> > # TuxMake supports the concept of runtimes.
> > # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> > # that you install podman or docker on your system.
> > #
> > # To install tuxmake on your system globally:
> > # sudo pip3 install -U tuxmake
> > #
> > # See https://docs.tuxmake.org/ for complete documentation.
> >
> >
> > tuxmake --runtime podman --target-arch arm --toolchain gcc-8 --kconfig
> > axm55xx_defconfig
> >
> > ref:
> > https://builds.tuxbuild.com/1sRT0HOyHnZ8N5ktJmaEcMIQZL0/
> >
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
