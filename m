Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B079775397
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 18:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbfGYQKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 12:10:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33447 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728570AbfGYQKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 12:10:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so36108290wme.0
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 09:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QB8+Ez/D+PUFOQMAsouYXbDd4SjR4KTjj5x3oemn60c=;
        b=rkZfwBDHK+BGz/rXmAeZrTG6KL3CN+j3fFx6qdofph5kLA8HUZzUBTtUMYys9l0X4w
         Zm4Cld/cS/1F7kSLtER/vFbCsNPeAt1soHvcqhUL3ba7Rya1OnWhi1V+8cjoxcialPhs
         XKTCLnAXi3olNirARVX+Ph99zv/OvTwi4EyhosHHtYwj4i+o4Y+vRsulTK1OxNCPH4Us
         B8Bvw8HiDOM6d1kQu7bfILb3oUHD3VBEOsxDrjimfCkU6A7FdO+YLVV2kLJ/oL4PjrWA
         9lOj03NOXYlsPqLxDQcKbUSgv1Lqkhr19i8tRtjO1najK/CYbgEN/+f7yn5rmo6XW1nQ
         flpg==
X-Gm-Message-State: APjAAAWOZmy99KNZoIsvtAqqv7/sCBajEGx+gMY9T9ySjepLnTeaSUSv
        Il/w/RpIS5JlmzzJ0OtERMCNKQ==
X-Google-Smtp-Source: APXvYqzyc7ld3a0F97/OP7eE5jfJEUGNelvR19s3aWv/8FskLdH/9ILHyDLMt0101HiQPsZeQBEqig==
X-Received: by 2002:a7b:ce01:: with SMTP id m1mr239009wmc.1.1564071039566;
        Thu, 25 Jul 2019 09:10:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:cc23:f353:392:d2ee? ([2001:b07:6468:f312:cc23:f353:392:d2ee])
        by smtp.gmail.com with ESMTPSA id f17sm45546782wmf.27.2019.07.25.09.10.38
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 09:10:39 -0700 (PDT)
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <33f1cfaa-525d-996a-4977-fda32dc368ee@redhat.com>
Date:   Thu, 25 Jul 2019 18:10:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725160939.GC18612@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/07/19 18:09, Sean Christopherson wrote:
>> This investigation confirms it is a new test code failure on stable-rc 5.2.3
> No, it only confirms that kvm-unit-tests/master fails on 5.2.*.  To confirm
> a new failure in 5.2.3 you would need to show a test that passes on 5.2.2
> and fails on 5.2.3.

I think he meant "a failure in new test code". :)

Paolo

> As Paolo suspected, kvm-unit-tests/master fails on 5.2.* and passes if
> commit 95d6d2c ("nVMX: Test Host Segment Registers and Descriptor Tables on
> vmentry of nested guests") is reverted (from kvm-unit-tests).
