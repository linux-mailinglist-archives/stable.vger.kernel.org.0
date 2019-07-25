Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCB574F4D
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 15:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfGYN0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 09:26:35 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35641 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfGYN0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 09:26:34 -0400
Received: by mail-lj1-f193.google.com with SMTP id x25so48058431ljh.2
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 06:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vq1nmmnAokEWi6IeeQFF/Sj1eC/PC82lAqP5SEvu0eI=;
        b=rxsDhgIXtyO7uV/fBbnWgz1a050eJfJt36cd+xIy+sc6LSML9a1bt0Oonq2Dhcq0Nn
         i9OQ0cm7OQUO7961kjhNW3cPXmjkWMo+F/+IWzwmV0zx3aIk7WqX60RSI99k8n3vHJsN
         J0IfNv75l1I6SN8MBb186ufzkSTkIBI2h/if5QfSFLoLAZ8NU1WIPiU4o8KvP7wxRCnL
         0+QqRxKpNMJ4vTrQjgSz0Z72XTSb8cqNLTf29DIUgysxxPJDw5G4Kx745P4DySPla3zp
         mvsXwRnsdPDe4zxfL9UDg6nlDdp/hQjGY2aXGL2SShlB36uScGod+oyYT1h8wWSKB2sy
         mgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vq1nmmnAokEWi6IeeQFF/Sj1eC/PC82lAqP5SEvu0eI=;
        b=nOo12O9JEUx6LR0/7+6rBV52Nv9cDO89nS60toEaXC0GLDd/74Mhy+bC99p2zAKxDH
         kLgxsq78xLUOAo5oBPI2yikiy58eCT0MNHnm41FruBK+SuSc+z5pgJJhHzNbsQ7JaIYZ
         OV6ZDAZHBGQg8PF0nI1E0lPcGd3eAvzYo/+gNRcUHFMDh8MtoFgfGxfchwD77jJQIxji
         IVrY1tp5cgIzLJ/WkuXlFqHO9r/5HPLt+LguVHNoaVQdW6jUD+hXX602zK39vZVggcMO
         G1b2gd3LEeuZvEZD7VLfTSllxmumZn/1m1vGBvfIuGzr75mrHyamXocEN+ptEzHcVufw
         IFEQ==
X-Gm-Message-State: APjAAAUWq4PTI5LJHGG/AQqgDHzo+5WKZUuQDKdpPClR8bp3hIIxJDwE
        Hcnk5gUMbgCmCbUwb6aw+pmxI0NF2nYH20kOdJbcSQ==
X-Google-Smtp-Source: APXvYqyw66/Sf84tPzZxGkwYYc6jtAysQYq8MKoYuMY/aQJzca4JUqEOIuiImP+kz3UDj00OHYOKCGgqyA5GwFzPp1g=
X-Received: by 2002:a2e:8559:: with SMTP id u25mr45784601ljj.224.1564061192579;
 Thu, 25 Jul 2019 06:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190724191735.096702571@linuxfoundation.org> <CADYN=9+WLxhmqX3JNL_s-kWSN97G=8WhD=TF=uAuKecJnKcj_Q@mail.gmail.com>
 <20190725113437.GA27429@kroah.com>
In-Reply-To: <20190725113437.GA27429@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Jul 2019 18:56:20 +0530
Message-ID: <CA+G9fYugOviC4W87AMFN3EfyXhSuEWitTX7t+v4G_EbhfQgLAg@mail.gmail.com>
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > Regressions (compared to build v5.2.2)
> > ------------------------------------------------------------------------
> >
> > x86:
> >   kvm-unit-tests:
> >     * vmx
> >
> >
> > TESTNAME=vmx TIMEOUT=90s ACCEL= ./x86/run x86/vmx.flat -smp 1 -cpu
> > host,+vmx -append \"-exit_monitor_from_l2_test -ept_access* -vmx_smp*
> > -vmx_vmcs_shadow_test\"
> > [  155.670748] kvm [6062]: vcpu0, guest rIP: 0x4050cb
...
> > [  158.479030] nested_vmx_exit_reflected failed vm entry 7
> > [  161.044379] set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> > FAIL vmx (timeout; duration=90s)
> >
> > kernel-config: http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-5.2/14/config
> > Full log: https://lkft.validation.linaro.org/scheduler/job/836289#L1597
>
> Ick.
>
> Any chance you can run 'git bisect' to find the offending patch?  Or
> just try reverting a few, you can ignore the ppc ones, so that only
> leaves you 7 different commits.

We have started 'git bisect' please allow sometime.

> Does this same test pass in 5.3-rc1?

yes.
kvm-unit-tests: vmx test getting PASS on 5.3-rc1 mainline kernel [1].

ref:
[1] https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kvm-unit-tests/vmx

- Naresh

>
> thanks,
>
> greg k-h
