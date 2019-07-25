Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFFB75410
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbfGYQaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 12:30:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55795 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbfGYQaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 12:30:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so45563999wmj.5
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 09:30:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TJee9iv3dQfcDC0wZilFBJPLTspmLKcTYUWHZ1YT3mc=;
        b=r9rVzfaNvUBm+vEXPacp1bMO0IuQ3fk7rzVaWSXNwFBtoFdbUh6CzZi/EKgSobrc9f
         2wLihdtoKQh1doVnCoz6CXrOyN9rJ0S/30dJVR4p8RvODa8TNJKpNUaJCrAkwuxNTSXh
         Xx3q0EqFwHIqnES/ZMdVnfTfaRy0QfQ7XQhU+0Fx+DMIw5P/GyJAOAQ8gJ0pX0x15+Ln
         6iu2FJRaPiXJdNYHyk2jNs5eXj82esnvYMjZ/GM9nj1ARM7wIFjdmVyHz09wsB5B2XhP
         AhXx/sZN4i+RW9sC0vYv9hBME9DlT76b7ZsnU5gma+NQWhWlp7GWWfz/gS4VenrsBmiD
         Y/xA==
X-Gm-Message-State: APjAAAVFg3ehPqedGdhMAWzBKaydH3qr0vncQ1aYDP8yahdaHecm8R7Y
        IenNFyGKy7wRQqGszXxf15IookBr0Tw=
X-Google-Smtp-Source: APXvYqz9H3fBrmL3D9ICTqPd7Cn3mBSxvMw7jKETUjOZrtGbOupCF836qSCXTQ6/2qzyFiNuDh5JjQ==
X-Received: by 2002:a1c:200a:: with SMTP id g10mr75279624wmg.160.1564072212129;
        Thu, 25 Jul 2019 09:30:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:cc23:f353:392:d2ee? ([2001:b07:6468:f312:cc23:f353:392:d2ee])
        by smtp.gmail.com with ESMTPSA id v18sm54143073wrs.80.2019.07.25.09.30.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 09:30:11 -0700 (PDT)
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
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
References: <20190724191735.096702571@linuxfoundation.org>
 <CADYN=9+WLxhmqX3JNL_s-kWSN97G=8WhD=TF=uAuKecJnKcj_Q@mail.gmail.com>
 <20190725113437.GA27429@kroah.com>
 <230a5b34-d23e-8318-0b1f-d23ada7318e0@redhat.com>
 <CA+G9fYsWdmboyquZ=Bs3tkTwRFTzd1yuL0_EVpHOecNi4E_stA@mail.gmail.com>
 <20190725160939.GC18612@linux.intel.com>
 <33f1cfaa-525d-996a-4977-fda32dc368ee@redhat.com>
 <20190725162053.GD18612@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7bc207e0-0812-e41a-bfd5-e3fbfd43f242@redhat.com>
Date:   Thu, 25 Jul 2019 18:30:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725162053.GD18612@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/07/19 18:20, Sean Christopherson wrote:
> On Thu, Jul 25, 2019 at 06:10:37PM +0200, Paolo Bonzini wrote:
>> On 25/07/19 18:09, Sean Christopherson wrote:
>>>> This investigation confirms it is a new test code failure on stable-rc 5.2.3
>>> No, it only confirms that kvm-unit-tests/master fails on 5.2.*.  To confirm
>>> a new failure in 5.2.3 you would need to show a test that passes on 5.2.2
>>> and fails on 5.2.3.
>>
>> I think he meant "a failure in new test code". :)
> 
> Ah, that does appear to be the case.  So just to be clear, we're good, right?

Yes.  I'm happy to gather ideas on how to avoid this (i.e. 1) if a
submodule would be useful; 2) where to stick it).

Paolo
