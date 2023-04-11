Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F0C6DDD07
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjDKN5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjDKN5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:57:30 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181A949E0
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:56:57 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id g13so7175303vsk.12
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681221413;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jNsTQ4XR5/CznA5wIAmNdsmA60Fa8LxEsk7Mxg1E2a0=;
        b=P8tY30hvW0KiStYCkr+CQ9qJ3Xlr1hT7AKXuYbuGk+hW0RMW+Vr4vMBqeqY61pSviB
         JUne9QD4XJzfsilV8V+znYD394LvRgPje+rSKoxaNFT1BZavG9H3rkTabXi6sbqi11N+
         VBvVWJ2DQmnhHpN4Mp6rHietTUVOxDo2UOZ6UlfbB2E9yVYHZbRVaKIg1eM+56o9RYlc
         S+aZXS5sdP3lNoVkmyVCNkuKUwiPEiskpl5IF7xRIMXq90E6OV+++c3S+6Pv52lduXsJ
         sgI4IxwoR3JFBoIo3NnWojQ308oLXeUv7S8WjtwxY+nSAt16dW65GKtyyk6GfP9qnQ45
         mfwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681221413;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jNsTQ4XR5/CznA5wIAmNdsmA60Fa8LxEsk7Mxg1E2a0=;
        b=JuF+mvEMDdC4DZwXLLIJhkf8r87T9ZuH0tYEaJmy2VzfNcSPNbkXSBLum+8LSVtG8o
         1YFHzMypmRQWAuY1OzLvg75ROIAmi+9FIRrpGTyKZLRTrrLBL4m1XAMaUehpz7YrUWwN
         1CvgjXT7gCIg3pKGxYGpOYrPS7WPLUHqUTNYTcseyZ6e1CqgsKLzC1v4WlKqkE7Dh0n+
         VOHFe0fhrcfKIKLnETUKkiS3eb7HlIwBn94ccmK0Z8aYTpE2wsbEvCwKkIJyqfTREz+C
         KUq7WGHIYtBaCzr0pVLFb07bQdNjYS1H3AaMnLAKds8Ozz7XBkxtwQcN9V8szxT31wbu
         w9XA==
X-Gm-Message-State: AAQBX9dmlARMsX/43D+mohDd64PzSbh/gdfqNNEh0L9vwuAjtbCMIhUR
        682z2BgwRJVKHnHnRM0KC0UkkJdnvzs2oyjtNNBNNg==
X-Google-Smtp-Source: AKy350a1tbbHH/dRWfchaRMX4YvLvvu460/Eu7NoyDyMNsKx8FPL4g0oEVqCPhql+hwkPOoji2PeAyuwhx48fNtXBlI=
X-Received: by 2002:a67:c38a:0:b0:425:e623:360a with SMTP id
 s10-20020a67c38a000000b00425e623360amr8524084vsj.1.1681221412753; Tue, 11 Apr
 2023 06:56:52 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYsF4D7o1iNW6fMNMdX9fKqqrvJw5GHcbW5yGr9PLSWcrw@mail.gmail.com>
 <2023040343-sift-phonebook-dead@gregkh>
In-Reply-To: <2023040343-sift-phonebook-dead@gregkh>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Apr 2023 19:26:41 +0530
Message-ID: <CA+G9fYs7nv16aP9q2Y7sgYAXMEwbnkYmzs7o21wRHGZRRrv=4g@mail.gmail.com>
Subject: Re: stable-rc / queue : 5.15: arm64 build failed
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, 3 Apr 2023 at 18:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Apr 03, 2023 at 03:47:11PM +0530, Naresh Kamboju wrote:
> > Following build warning noticed on arm64,
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >

This patch is now in queue 5.15,

> > suspecting commit:
> > KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
> > commit 9228b26194d1cc00449f12f306f53ef2e234a55b upstream.
>
> Now dropped, thanks!

I have started noticing this build error again on queue 5.15.

arch/arm64/kvm/sys_regs.c:1671:43: error: initialization of 'int
(*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct
kvm_one_reg *, void *)' from incompatible pointer type 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, u64 *)' {aka 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, long long unsigned int *)'}
[-Werror=incompatible-pointer-types]
 1671 |           .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr},
      |                                           ^~~~~~~~~~~~~~
arch/arm64/kvm/sys_regs.c:1671:43: note: (near initialization for
'sys_reg_descs[224].__get_user')
arch/arm64/kvm/sys_regs.c:999:48: error: initialization of 'int
(*)(struct kvm_vcpu *, const struct sys_reg_desc *, const struct
kvm_one_reg *, void *)' from incompatible pointer type 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, u64 *)' {aka 'int (*)(struct
kvm_vcpu *, const struct sys_reg_desc *, long long unsigned int *)'}
[-Werror=incompatible-pointer-types]
  999 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,
         \
      |                                                ^~~~


https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.105-187-ga996798ba4fa/testrun/16173915/suite/build/test/gcc-11-defconfig-lkftconfig/history/


- Naresh

>
> greg k-h
