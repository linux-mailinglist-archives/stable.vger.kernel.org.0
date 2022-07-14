Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E9B5753B3
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 19:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbiGNRDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 13:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiGNRDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 13:03:19 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BF45726E
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 10:03:18 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id fy29so3398329ejc.12
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 10:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pm+iphli5RRfa4JmHeh81lVBkwRMzWQKLMKTsw18lMo=;
        b=Z6ZquADLYu4uMwnTfB77Llp499vJAhe+VRkqcHP7yOsgzWOu9zDeuVv569iCGwq/TN
         n14hSaPCbUQ38LjnNOasq8gCvSbs/42WYABjzHa4Zob3/Bzo6643Bg7S4R0uqisbfoYa
         ihvN3aq2+yGj/oCPRE7nev9NxH4BVy6V92VdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pm+iphli5RRfa4JmHeh81lVBkwRMzWQKLMKTsw18lMo=;
        b=cRXOWR2FJZsky9GQcDMswORmS2AS5Le4lbCbcROAZyD4stFk0DEsisnqg7rWTucacs
         tn0wWSjCBxqzQi3Mx/mpoCWBxRJtulWbJFYvmxjDYe9TQ/gSG8YogleAF42eRtD4P60R
         rzLS2V3z9TRRwkAeCVTjrpb5LR9pimj0mVDTp19XeuOL9oS6+Ien3jj39E4FeBpjPdba
         Zw2zyqyiYQlOQ65ZgLI0NMlE732kGpRUIzMiHWuCga1VB0FcVEwTyO3LHt/5C4LznXt1
         f15QFRbQSOwNqyfV3pwZ7aF8LRQCMdqkmOxVgVPPYjCwneTdZ+tEICyqDQ994gUlXZpZ
         1e4Q==
X-Gm-Message-State: AJIora+aa6CEcXm9qddEQCOk4MAgXETGkxU0+SNY8+Snp5hUzPIevq/L
        J8hypksNVpoDXL9JOgkEEl1pwpV1WihUiLhys9o=
X-Google-Smtp-Source: AGRyM1v+o6ufwjZZjgaT0fqJ3fr1I8UhxiOEnm3l4BY6u6tqX0phlZ9ea2gWnfMedh3Gc+BsokDA1g==
X-Received: by 2002:a17:906:9bef:b0:72b:40d1:4276 with SMTP id de47-20020a1709069bef00b0072b40d14276mr9207062ejc.360.1657818196507;
        Thu, 14 Jul 2022 10:03:16 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id cw11-20020a056402228b00b0043a8f40a038sm1356110edb.93.2022.07.14.10.03.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 10:03:14 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id r2so2366743wrs.3
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 10:03:13 -0700 (PDT)
X-Received: by 2002:a5d:544b:0:b0:21d:70cb:b4a2 with SMTP id
 w11-20020a5d544b000000b0021d70cbb4a2mr8990916wrv.281.1657818193135; Thu, 14
 Jul 2022 10:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net> <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
 <Ys/bYJ2bLVfNBjFI@nazgul.tnic> <6b4337f4-d1de-7ba3-14e8-3ad0f9b18788@redhat.com>
 <8BEC3365-FC09-46C5-8211-518657C0308E@alien8.de>
In-Reply-To: <8BEC3365-FC09-46C5-8211-518657C0308E@alien8.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 10:02:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj4vtoWZPMXJU-B9qW1zLHsoA1Qb2P0NW=UFhZmrCrf9Q@mail.gmail.com>
Message-ID: <CAHk-=wj4vtoWZPMXJU-B9qW1zLHsoA1Qb2P0NW=UFhZmrCrf9Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
To:     Boris Petkov <bp@alien8.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
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
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 7:46 AM Boris Petkov <bp@alien8.de> wrote:
>
> On July 14, 2022 1:46:53 PM UTC, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >Please leave that one out as Peter suggested a better fix and I have that queued for Linus.
>
> Already zapped.

I like Peter's more obvious use of FASTYOP_LENGTH, but this is just disgusting:

    #define FASTOP_SIZE (8 << ((FASTOP_LENGTH > 8) & 1) <<
((FASTOP_LENGTH > 16) & 1))

I mean, I understand what it's doing, but just two lines above it the
code has a "ilog2()" use that already depends on the fact that you can
use ilog2() as a constant compile-time expression.

And guess what? The code could just use roundup_pow_of_two(), which is
designed exactly like ilog2() to be used for compile-time constant
values.

So the code should just use

    #define FASTOP_SIZE roundup_pow_of_two(FASTOP_LENGTH)

and be a lot more legible, wouldn't it?

Because I don't think there is anything magical about the length
"8/16/32". It's purely "aligned and big enough to contain
FASTOP_LENGTH".

And then the point of that

    static_assert(FASTOP_LENGTH <= FASTOP_SIZE);

just goes away, because there are no subtle math issues there any more.

In fact, the remaining question is just "where did the 7 come from" in

    #define FASTOP_LENGTH (7 + ENDBR_INSN_SIZE + RET_LENGTH)

because other than that it all looks fairly straightforward.

              Linus
