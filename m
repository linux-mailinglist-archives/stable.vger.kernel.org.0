Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0735E75A6C
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 00:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfGYWK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 18:10:28 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52951 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfGYWK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 18:10:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so46263002wms.2
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 15:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/efOnDxSbGdN0Bdr5SzMCIHE/dK0Kshq+Eu+fKkpIAI=;
        b=BdnzZwZBJupTx6YmmxfA9OBv4ZmIpqbFI7hnKjEaXQ/HFHteq1EKYpD6+q0X0MZ8dL
         3QajWPSLx+uGwCrBmj/KdwYcL686+R9fL5AoYJ6wk4UVdD5aeFhdv96mOOyvj5erPmJf
         cI67sFPNxpV29A/s1+qD1mRiXBJqQkh8UyhnTblUjNGPN6dSpGcHn62woyxRSX5fHm4I
         7R46SSroLR3oV/cKPqhhYSbmclzuRoPLmBrqvXOa6m1xGU4+Qww5IzFCn/sDpz/yHTSq
         pFIJz2V9cM6jIt4yumEex3sOVbKmuaFU3Y6Wv3GSACcWs5wlQei50GSW6bDabDyw9Hb4
         bvjA==
X-Gm-Message-State: APjAAAV2KjAxZMZgN+Y2qL5tz9On7aA2VvkuM4NAO5Dm3iF+dIxyAQrT
        QO1tQdivnGg2nMjvjgrvbBIuOg==
X-Google-Smtp-Source: APXvYqxuCBM42nA2ri+2nQ+IFiLkfFjMyzd5RxP94/5hxtMLT55P9FoKuk7obZIVITd21utAuKT30g==
X-Received: by 2002:a1c:a1c1:: with SMTP id k184mr84016054wme.81.1564092625944;
        Thu, 25 Jul 2019 15:10:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:cc23:f353:392:d2ee? ([2001:b07:6468:f312:cc23:f353:392:d2ee])
        by smtp.gmail.com with ESMTPSA id 15sm35602094wmk.34.2019.07.25.15.10.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 15:10:25 -0700 (PDT)
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
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
References: <20190725113437.GA27429@kroah.com>
 <230a5b34-d23e-8318-0b1f-d23ada7318e0@redhat.com>
 <CA+G9fYsWdmboyquZ=Bs3tkTwRFTzd1yuL0_EVpHOecNi4E_stA@mail.gmail.com>
 <20190725160939.GC18612@linux.intel.com>
 <33f1cfaa-525d-996a-4977-fda32dc368ee@redhat.com>
 <20190725162053.GD18612@linux.intel.com>
 <7bc207e0-0812-e41a-bfd5-e3fbfd43f242@redhat.com>
 <20190725163946.xt2p3pvxwuabzojj@xps.therub.org>
 <3e55414d-cb4f-8f3f-a359-e374b6298715@redhat.com>
 <20190725201933.aiqh6oj7bacdwact@xps.therub.org>
 <20190725205701.GF18612@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dc5ff4ed-c6dd-74ea-03ae-4f65c5d58073@redhat.com>
Date:   Fri, 26 Jul 2019 00:10:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725205701.GF18612@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/07/19 22:57, Sean Christopherson wrote:
> On Thu, Jul 25, 2019 at 03:19:33PM -0500, Dan Rue wrote:
>> I would still prefer to run the latest tests against all kernel versions
>> (but better control when we upgrade it). Like I said, we can handle
>> expected failures, and it would even help to validate backports for
>> fixes that do get backported. I'm afraid on your behalf that snapping
>> (and maintaining) branches per kernel branch is going to be a lot to
>> manage.
> 
> Having the branches would be beneficial for kernel developers as well,
> e.g. on multiple occasions I've spent time hunting down non-existent KVM
> bugs, only to realize my base kernel was stale with respect to kvm-unit-tests.
> 
> My thought was to have a mostly-unmaintained branch for each major kernel
> version, e.g. snapshot a working version of kvm_unit_tests when the KVM
> pull request for the merge window is sent, and for the most part leave it
> at that.  I don't think it would introduce much overhead, but then again,
> I'm not the person who would be maintaining this :-)
> 

Yes, I agree.  Stable backports that have fixes in kvm-unit-tests are
relatively rare, so the branch would hardly move after a release is cut.

Paolo
