Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C432758BC
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 22:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfGYUTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 16:19:37 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35796 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfGYUTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 16:19:37 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so100034268ioo.2
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 13:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t+P0HgQtVoSGPP4WNOjKgOLE6EijYeFIeYo8RF4X35w=;
        b=JbeXsfGxZNECNWfw5yFkXZH+MNoz+D/swRQgzPMLghoyO2zRQSK3HbEdvUo4mJPIZ4
         2U0Xtr3B76TNn1kn0lNgvsG8fEuIIBoZa/nkAPludlxPF2i9BiNbOLNsgHDSdqK97rVA
         9NynPzqCCA/Blt6TUOOd/oqOyZ4koex1kH2dIYCg/9nu5CrFCyzlRjtGe/S4g4qlrwzG
         Db+dSHml4qN+iuUobdMw12MnsiLzFQP5V/8KTf8BxnuVXrHHcTQumHbGKORyp+796Etb
         SCRD4noYvRc0rK8mLYGPKD+EwN2waXezF9fLF/ik4NgVrMbxKjFcBUr3vkABM+p0i8mG
         7v3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=t+P0HgQtVoSGPP4WNOjKgOLE6EijYeFIeYo8RF4X35w=;
        b=iWygi2PJBdacnJ6X7tGMpe9bIlI3bZi0z+Yerq0WqTCcyHTxGsfANrWcGHx17Z/UoF
         heHNI5N8UDzuJ5Sh0M5rJt6o78ye90g/srNzRAE975nGKzKADGLurdlEyqYt8oDCph7I
         JIMqERz2h8fD89NycpDI4EWLcdJtXkP2NB76yVAEJnzfOyMYHD5mjpRFB0j8jFKXzzeu
         sa4eJWrSawWvU3kwNEtdlbu72eT0Fbrt3U0dLCMe6om2aSAS/Bhg7eivQYySKc74aBLG
         DAy8hMmh4onekxRRJHGnUh5csYnpBJeLjA3mbEsFPo93SvAZRVli2ivcr247g22L/ely
         vXBQ==
X-Gm-Message-State: APjAAAUquzeoY1nJpPC7S1aiP1Kj76HRe1ot8B0LtY1HCuGHuZJBYQkO
        gvybecSWcvYAHs62SQSRKE8BbQ==
X-Google-Smtp-Source: APXvYqwvkJxxV0fZpjkKga8Y+RaQMVdGjDc9o4hwMDRkD6Ki+prPp7J6OIqwAahJ8ly4GjoglrQxzA==
X-Received: by 2002:a6b:7909:: with SMTP id i9mr52428090iop.8.1564085975985;
        Thu, 25 Jul 2019 13:19:35 -0700 (PDT)
Received: from localhost (c-24-7-195-109.hsd1.mn.comcast.net. [24.7.195.109])
        by smtp.gmail.com with ESMTPSA id t19sm51448100iog.41.2019.07.25.13.19.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 13:19:35 -0700 (PDT)
Date:   Thu, 25 Jul 2019 15:19:33 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        wanpengli@tencent.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, jmattson@google.com
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
Message-ID: <20190725201933.aiqh6oj7bacdwact@xps.therub.org>
Mail-Followup-To: Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        wanpengli@tencent.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        jmattson@google.com
References: <CADYN=9+WLxhmqX3JNL_s-kWSN97G=8WhD=TF=uAuKecJnKcj_Q@mail.gmail.com>
 <20190725113437.GA27429@kroah.com>
 <230a5b34-d23e-8318-0b1f-d23ada7318e0@redhat.com>
 <CA+G9fYsWdmboyquZ=Bs3tkTwRFTzd1yuL0_EVpHOecNi4E_stA@mail.gmail.com>
 <20190725160939.GC18612@linux.intel.com>
 <33f1cfaa-525d-996a-4977-fda32dc368ee@redhat.com>
 <20190725162053.GD18612@linux.intel.com>
 <7bc207e0-0812-e41a-bfd5-e3fbfd43f242@redhat.com>
 <20190725163946.xt2p3pvxwuabzojj@xps.therub.org>
 <3e55414d-cb4f-8f3f-a359-e374b6298715@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e55414d-cb4f-8f3f-a359-e374b6298715@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 07:06:19PM +0200, Paolo Bonzini wrote:
> On 25/07/19 18:39, Dan Rue wrote:
> > To your point Paolo - reporting 'fail' because of a missing kernel
> > feature is a generic problem we see across test suites, and causes tons
> > of pain and misery for CI people. As a general rule, I'd avoid
> > submodules, and even branches that track specific kernels. Rather, and I
> > don't know if it's possible in this case, but the best way to manage it
> > from both a test author and a test runner POV is to wrap the test in
> > kernel feature checks, kernel version checks, kernel config checks, etc.
> > Report 'skip' if the environment in which the test is running isn't
> > sufficient to run the test. Then, you only have to maintain one version
> > of the test suite, users can always use the latest, and critically: all
> > failures are actual failures.
> 
> Note that kvm-unit-tests are not really testing new kernel features;
> those are covered by tools/testing/selftests/kvm.  For some of these
> kvm-unit-tests there are some CPU features that we can check from the
> virtual machine, but those are easy to handle and they produce SKIP
> results just fine.
> 
> The problematic ones are tests that cover emulation accuracy.  These are
> effectively bugfixes, so the failures you see _are_ actual failures.  At
> the same time, the bugs are usually inoffensive(*), while the fixes are
> invasive and a bad source of cause conflicts in older Linux versions.
> This combines so that backporting to stable is not feasible.

In this case, a fail result seems correct then. The thing we're doing
that we need to fix is to run against a pinned version of kvm-unit-tests
and upgrade it independently so that we can identify such failures and
mark them as known issues.

> 
> Passing the host kernel version would be really ugly because 1) the
> tests can run on other hypervisor or emulators or even bare metal, and
> of course the host kernel version has no bearing if you're using
> userspace emulation 2) there are thousands of tests that would be
> littered with kernel version checks of little significance.
> 
> So this is why I suggested a submodule: using a submodule effectively
> ignores all tests that were added after a given Linus release, and thus
> all the failures for which backports are just not going to happen.
> However, if Sean's idea of creating a linux-M.N branch in
> kvm-unit-tests.git works for you, we can also do that as a stopgap
> measure to ease your testing.

I would still prefer to run the latest tests against all kernel versions
(but better control when we upgrade it). Like I said, we can handle
expected failures, and it would even help to validate backports for
fixes that do get backported. I'm afraid on your behalf that snapping
(and maintaining) branches per kernel branch is going to be a lot to
manage.

In any case, _thank you so much_ for jumping on this and helping us run
these tests. Is there anything else we can do to make this better for
you?

Dan

> 
> Thanks,
> 
> Paolo
> 
> (*) if they aren't, we *do* mark them for backport!

-- 
Linaro - Kernel Validation
