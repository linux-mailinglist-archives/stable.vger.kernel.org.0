Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009AE5753C6
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 19:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbiGNRMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 13:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiGNRMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 13:12:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9AFD4C60E
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 10:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657818727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HjWNjW2j61ucjIjN1Yf39Thjioq1zyAsNONdyKe2ob0=;
        b=NfJmaqUOF/VyVcxoJGzXGNSm0Rdg5u0Lcpn64hGrUjt6ioJZ25FE/2fEHIywIjXKg4We8u
        muwh3gYGoyfiTiT2X6ZTTnW99RniZM0DuVwp93L4CWqCFNNqIMMmxrEh6TxQ2UIjN6m6MG
        FzQNw3A8AtyznPehVER4UlpJP32ZSxM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-fTutQPS3NhqiR7pQthVpmg-1; Thu, 14 Jul 2022 13:12:06 -0400
X-MC-Unique: fTutQPS3NhqiR7pQthVpmg-1
Received: by mail-ed1-f71.google.com with SMTP id v19-20020a056402349300b0043b0f690cbaso1865527edc.11
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 10:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=HjWNjW2j61ucjIjN1Yf39Thjioq1zyAsNONdyKe2ob0=;
        b=2vtUCFASpY4iprrN8GfkA0q43FjHPiqNnqphiRgNYfImONgmLjAW7f9wWHvUHHGtW2
         BwaxyTpcHojjwtNNkSzd7qR+3e9XO4WmqvrRDjt0b1+pa4unvzKf6kU9QkG3bPYneUdc
         gdvBPOUuVv8VFI7VtFZJ7vdN9G3oYUt5MHNP3EkoU71c4rJNj89Gb+y6A0sJyhUkCQHk
         /p69vVEeYm3R61K8JUiSP8N831sG/PnahU9ZurnBIH/C6k3q1EOx+drVJ1MzJLgqba3p
         Ls9WLYQgQv2wdo8RUEeU9JubJDRexaKbbs5K6A3a+G8BFy0BFu3dWLh1YJpnh3IosX1s
         lOzw==
X-Gm-Message-State: AJIora99WjJE8xqOpAZ5XG+GocDBSBpFSYclK9iXX+fgswR/lQN82+Kd
        Rmi8qElghwAxsStUE+A8D3GvOuSOFJN5uKG7MhBH1cRkqWQN9MtbPseMIU2vQMPMiZXE+NxAzuC
        ySsWMAKchVPG5rwyl
X-Received: by 2002:a17:906:98c8:b0:72b:41dc:c271 with SMTP id zd8-20020a17090698c800b0072b41dcc271mr9951323ejb.36.1657818725037;
        Thu, 14 Jul 2022 10:12:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s4QWugzGtCYIVhcQOfjMkddqnFDUCHwgwKB/hRFje6kOt4GvXPs1eutx8bZ864l4FIGpiklA==
X-Received: by 2002:a17:906:98c8:b0:72b:41dc:c271 with SMTP id zd8-20020a17090698c800b0072b41dcc271mr9951310ejb.36.1657818724813;
        Thu, 14 Jul 2022 10:12:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id n6-20020aa7c786000000b0043787ad7cfasm1362571eds.22.2022.07.14.10.12.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 10:12:04 -0700 (PDT)
Message-ID: <19b6f502-94f2-621a-4c30-fe9641474669@redhat.com>
Date:   Thu, 14 Jul 2022 19:12:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Boris Petkov <bp@alien8.de>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
In-Reply-To: <CAHk-=wj4vtoWZPMXJU-B9qW1zLHsoA1Qb2P0NW=UFhZmrCrf9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/14/22 19:02, Linus Torvalds wrote:
> And guess what? The code could just use roundup_pow_of_two(), which is
> designed exactly like ilog2() to be used for compile-time constant
> values.
> 
> So the code should just use
> 
>      #define FASTOP_SIZE roundup_pow_of_two(FASTOP_LENGTH)
> 
> and be a lot more legible, wouldn't it?
> 
> Because I don't think there is anything magical about the length
> "8/16/32". It's purely "aligned and big enough to contain
> FASTOP_LENGTH".

roundup_pow_of_two unfortunately is not enough for stringizing 
FASTOP_SIZE into an asm statement. :(

	#define __FOP_FUNC(name) \
	        ".align " __stringify(FASTOP_SIZE) " \n\t" \
	        ".type " name ", @function \n\t" \
	        name ":\n\t" \
	        ASM_ENDBR

The shifts are what we came up with for the SETCC thunks when ENDBR and 
SLS made them grew beyond 4 bytes; Peter's patch is reusing the trick 
for the fastop thunks.

> Because I don't think there is anything magical about the length
> "8/16/32". It's purely "aligned and big enough to contain
> FASTOP_LENGTH".

I agree with that, it's only limited to 8/16/32 to keep the macro to a 
decent size.

> And then the point of that
> 
>     static_assert(FASTOP_LENGTH <= FASTOP_SIZE);
> 
> just goes away, because there are no subtle math issues there any more.
> 
> In fact, the remaining question is just "where did the 7 come from" in
> 
>     #define FASTOP_LENGTH (7 + ENDBR_INSN_SIZE + RET_LENGTH)

The 7 is an upper limit to the length of the code between endbr and ret.
There's no particular reason to limit to 7, but it allows using an 
alignment of 8 in the smallest case (no thunks, no SLS, no endbr) where 
you just have ".align 8; ...; ret".

Paolo

