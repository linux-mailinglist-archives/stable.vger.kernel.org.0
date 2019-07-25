Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B3E7543D
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 18:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbfGYQjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 12:39:49 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40203 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbfGYQjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 12:39:48 -0400
Received: by mail-io1-f65.google.com with SMTP id h6so12044417iom.7
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 09:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=obR63h1i9BTxqQDmE4djGLMnXZRaUmocRF7TA6/FFLU=;
        b=fnAdnCZ8mXjzi0Ez/WAImfwe0mh8dxrf0Mm/NKM0Ak4rUX1VniWZ9VJa2C581rfCit
         omI2LoEHf2D597gUyoqvqACH/9hmAQYqnoWQxJnw+t+qr3WPKZA4r/H7lmsvCQE+a7Zt
         EkCVsZx7FrGEWzQvrM9ArMdWPmYvJqwksiwuIXxYDwCNtar+IuffKBqvh87Hcobrth6h
         +Qg/PqYq/xNeaUKy4cOV1aZr/t0yRG18uHIbykOmPlycWmoZWXriQsiNeWVKzRCLQs48
         sRnoNeu4Rf3F64YDT+Kvjew3fssi/LsU6UaQwIvbdW6KA/Tmhmr5mHJsyQjLmuSs8nI5
         GYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=obR63h1i9BTxqQDmE4djGLMnXZRaUmocRF7TA6/FFLU=;
        b=QySmIJuANoDGFNacYNfoqIPXgisVgZpxsExqXZT4bx0Yt48YY4PBx2oOyUA4c49vnC
         IwfrTidVF71f9yEQSmDvcTlJVxxorFbtpEjMeUYoQYOiNQvN1yDVGMn80+57rkkN1cod
         TE/oarL/XXl7frCr4c1+kCc8Sla806AOrXnlV2/px1FaaSvjgR2H1dWJB7HQyiwY048H
         l9j3fnrO9KYIWiEwp5Ns4irXfWvk7ZU06XeSwXtwhY1uu7RckGX72Xe/oBm9ZRavf/pF
         rhUj8D5jAVuTSCT8WKKBxNmx7hcRHYveMiR5U2hQRtQC3XEgrns0QqKx+piXWk2ki64S
         8Qdg==
X-Gm-Message-State: APjAAAWq0uRoF8Yjb7M7SMZhJC03KrJEIRJMTksp30AIo4rTCEhEWBQv
        02YqS/CiamPQ/mOmyWxQ0Tuyx7dToUg=
X-Google-Smtp-Source: APXvYqwmaCog90kSDSaqWIR64tr1c51dMxcgT/Z5zkYX4lANAr+lfcC8+kobCHL+WrjIQz22GD+p1A==
X-Received: by 2002:a5d:8497:: with SMTP id t23mr57365077iom.298.1564072787932;
        Thu, 25 Jul 2019 09:39:47 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id q22sm41603613ioj.56.2019.07.25.09.39.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 09:39:47 -0700 (PDT)
Date:   Thu, 25 Jul 2019 11:39:46 -0500
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
Message-ID: <20190725163946.xt2p3pvxwuabzojj@xps.therub.org>
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
References: <20190724191735.096702571@linuxfoundation.org>
 <CADYN=9+WLxhmqX3JNL_s-kWSN97G=8WhD=TF=uAuKecJnKcj_Q@mail.gmail.com>
 <20190725113437.GA27429@kroah.com>
 <230a5b34-d23e-8318-0b1f-d23ada7318e0@redhat.com>
 <CA+G9fYsWdmboyquZ=Bs3tkTwRFTzd1yuL0_EVpHOecNi4E_stA@mail.gmail.com>
 <20190725160939.GC18612@linux.intel.com>
 <33f1cfaa-525d-996a-4977-fda32dc368ee@redhat.com>
 <20190725162053.GD18612@linux.intel.com>
 <7bc207e0-0812-e41a-bfd5-e3fbfd43f242@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc207e0-0812-e41a-bfd5-e3fbfd43f242@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 06:30:10PM +0200, Paolo Bonzini wrote:
> On 25/07/19 18:20, Sean Christopherson wrote:
> > On Thu, Jul 25, 2019 at 06:10:37PM +0200, Paolo Bonzini wrote:
> >> On 25/07/19 18:09, Sean Christopherson wrote:
> >>>> This investigation confirms it is a new test code failure on stable-rc 5.2.3
> >>> No, it only confirms that kvm-unit-tests/master fails on 5.2.*.  To confirm
> >>> a new failure in 5.2.3 you would need to show a test that passes on 5.2.2
> >>> and fails on 5.2.3.
> >>
> >> I think he meant "a failure in new test code". :)
> > 
> > Ah, that does appear to be the case.  So just to be clear, we're good, right?
> 
> Yes.  I'm happy to gather ideas on how to avoid this (i.e. 1) if a
> submodule would be useful; 2) where to stick it).

Hi!

First, to be clear: from LKFT perspective there are no kernel
regressions here.

To your point Paolo - reporting 'fail' because of a missing kernel
feature is a generic problem we see across test suites, and causes tons
of pain and misery for CI people. As a general rule, I'd avoid
submodules, and even branches that track specific kernels. Rather, and I
don't know if it's possible in this case, but the best way to manage it
from both a test author and a test runner POV is to wrap the test in
kernel feature checks, kernel version checks, kernel config checks, etc.
Report 'skip' if the environment in which the test is running isn't
sufficient to run the test. Then, you only have to maintain one version
of the test suite, users can always use the latest, and critically: all
failures are actual failures.

Dan

> 
> Paolo

-- 
Linaro - Kernel Validation
