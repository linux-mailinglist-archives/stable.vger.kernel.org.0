Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2092057609B
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 13:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiGOLf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 07:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiGOLf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 07:35:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AE2D2408D
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 04:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657884922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LqiZ2BH3t6nZQUEw5FLpGzjxGjfx9YKB6EQJtDup9/U=;
        b=DAQl6yno/T/MhUpjZS0lgx7oLqWn594QyCAEVAELAj9rBc16TkOuOgEzGJ50WzAzLY7iHi
        te7Bm0umtGWtG0R5G7QWL+sVqszrHgWQAOLJ47D2c0JNt08kBTf/Mfp9nWg06WHcSckUTJ
        XBiDzuGpxxBOWGotqZZ+7yoT5M8ezuo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-4tpJq5ueMlK7se7BVPqdMQ-1; Fri, 15 Jul 2022 07:35:21 -0400
X-MC-Unique: 4tpJq5ueMlK7se7BVPqdMQ-1
Received: by mail-ed1-f69.google.com with SMTP id f13-20020a0564021e8d00b00437a2acb543so3278612edf.7
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 04:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=LqiZ2BH3t6nZQUEw5FLpGzjxGjfx9YKB6EQJtDup9/U=;
        b=gFgMld7hq2ISwgkTAC5mvnKvubf4hgPazDbc97Wz1esDGgDjEdNgG5Ob70kB2RFNLt
         VRsaqvqXkwqcbBt9RS/j5GUqRynYh0GAeqi9C3PdPm1aIcUhZl/qcxWsg1N6uno/XUs7
         YfOfjHrn8kL2WIBlHKgmRFHdqeidkY8yFLWl9oimG8dbIQlOD4Z5ib7ObT+hWnpN5J1V
         iK6T5cAKEJIdO2pRv9aNJeshHrUfRTIRHONb7NcjzQAPALmvoVnNADjMWF6KpNyZcLMm
         ajcpLKm8gYEucfOlBVg7Icjptp3OFMY9VUxGDK7PI42bIuRr8EBwQjPBJ1/NS32ckmxx
         OvJg==
X-Gm-Message-State: AJIora/JbXF1dvHg2Lu+nafpjEzSBaFcyTgNytkDo07mb7KwU3EfdQr+
        1B7Dy207s76TJWSVmP/rrXwAJPZPi8YkZ9FXZLNccgV+/znEgJQbzHg61oFXYpkAzzZ/QsmBc1R
        UQYArxdrKYX/3OkSN
X-Received: by 2002:a17:906:106:b0:722:d84c:6df0 with SMTP id 6-20020a170906010600b00722d84c6df0mr13298264eje.203.1657884919858;
        Fri, 15 Jul 2022 04:35:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tKNjtas+bHjgEhFzyt+2Qnh9h2GuUxR+sU4F7JpDtHGRCeQrtjcgsEPD04deI4nscwAsU8fQ==
X-Received: by 2002:a17:906:106:b0:722:d84c:6df0 with SMTP id 6-20020a170906010600b00722d84c6df0mr13298252eje.203.1657884919540;
        Fri, 15 Jul 2022 04:35:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id 10-20020a170906318a00b0072aac739089sm1942032ejy.98.2022.07.15.04.35.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 04:35:18 -0700 (PDT)
Message-ID: <7b3ccb3e-174b-6f31-d875-452082262906@redhat.com>
Date:   Fri, 15 Jul 2022 13:35:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Boris Petkov <bp@alien8.de>, Guenter Roeck <linux@roeck-us.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        kvm list <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>, patches@kernelci.org,
        Sean Christopherson <seanjc@google.com>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        lkft-triage@lists.linaro.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Anders Roxell <anders.roxell@linaro.org>
References: <20220712183238.844813653@linuxfoundation.org>
 <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net>
 <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
 <Ys/bYJ2bLVfNBjFI@nazgul.tnic>
 <6b4337f4-d1de-7ba3-14e8-3ad0f9b18788@redhat.com>
 <8BEC3365-FC09-46C5-8211-518657C0308E@alien8.de>
 <CAHk-=wj4vtoWZPMXJU-B9qW1zLHsoA1Qb2P0NW=UFhZmrCrf9Q@mail.gmail.com>
 <YtBQutgSh2j3mFNB@worktop.programming.kicks-ass.net>
 <CAHk-=wjAouqJQ=C4XZVUmWEV9kerNzbOkK9OeErpHshNkcR=gQ@mail.gmail.com>
 <CAHk-=whYia1fnjJFiJ59xZv4ROqqTfG4crQNWxb71JYJf5B-Lg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
In-Reply-To: <CAHk-=whYia1fnjJFiJ59xZv4ROqqTfG4crQNWxb71JYJf5B-Lg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/14/22 20:16, Linus Torvalds wrote:
> Oh, btw, how bad would it be to just do
> 
>      #define FASTOP_SIZE 16
>      static_assert(FASTOP_SIZE >= FASTOP_LENGTH)

Yeah, for 32 I might have some (probably irrational) qualms, but 16 is 
not worth the trouble.

Given 3 bytes for ENDBR, 5 for the return thunk and 1 for the straight 
line speculation INT3, there are 7 bytes left and only 4 are currently 
used (for instructions encoded as "66 0f xx xx").  So FASTOP_SIZE at 
SETCC_ALIGN can indeed be 16 unconditionally.

Paolo

