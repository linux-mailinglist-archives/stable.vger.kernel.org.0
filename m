Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82F457566F
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 22:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbiGNUjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 16:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240510AbiGNUjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 16:39:49 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D2941D27
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 13:39:47 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l23so5507054ejr.5
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 13:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TExNSZ/s/035rcwvcGhKf8b3mCtg1+8MAx2E+0mZs0k=;
        b=QlimJt9jnXA9WGUrrQpsyCnanjLLw2jppJeg8tlDJyUjoU7EVZkhjwQfw1utPbJFYw
         V2J/VhZUmpGT/0AOkO/cGcOvDnr/166nGbtK/23TIpPRTkOHY0byi1fwM5PVz2v65CaC
         CGxmh6/85iCwDd/Ru/CPAYbK8QhOpNrWTrRyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TExNSZ/s/035rcwvcGhKf8b3mCtg1+8MAx2E+0mZs0k=;
        b=T198wZLeF0mLLQEq3TbM1CYoC/qVwDi8/qnEVnWug7UbMIV8/joqdH8miNWouF1Laj
         o8/zGpAF4XTLZK8Dw0L4yI4/98rKlDJfkCBwzKxBhaEmAQKaFEUfLg7qFZ22WzOaSFFN
         aEzvSvMm1vo8CA+BHyUUKgRtRq8mKHGfXhaizdK2GgpAwjyNjE/6vWTopPhBptVritY9
         05VwmBTOiV3dBT+FZ8rfIdQ39FNklau7zfHjuZ5I1ka6urv5YPKBUODl8TzFVk5DRuPG
         82d3daxKclYfoGNckEgWJO29OppWAOX3i2g+b5cuUOeRfVIWNz/Gjbil1dJUP8Rs5qC9
         MZWg==
X-Gm-Message-State: AJIora8Ekxt60Sii+/6qUlryvFuBnLJgeOaRe3mJj/2zhvgfWimdB+hx
        48vueuHaKwLKbv2hBvzQlLYS1ewBpSizEq9gcgU=
X-Google-Smtp-Source: AGRyM1u7XbqFJ4zpC/d+qRMwDoajvIJrx45qNWDHlcyb0nVpQ8oQb+D0XsDazZhwjKtQo4CbVUYOzw==
X-Received: by 2002:a17:906:58c8:b0:6fe:91d5:18d2 with SMTP id e8-20020a17090658c800b006fe91d518d2mr10470794ejs.190.1657831185291;
        Thu, 14 Jul 2022 13:39:45 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id p19-20020a056402075300b0043a7cdfac46sm1632774edy.23.2022.07.14.13.39.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 13:39:42 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id z12so4097652wrq.7
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 13:39:41 -0700 (PDT)
X-Received: by 2002:a05:6000:1f8c:b0:21d:7e98:51ba with SMTP id
 bw12-20020a0560001f8c00b0021d7e9851bamr9427301wrb.442.1657831181447; Thu, 14
 Jul 2022 13:39:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220712183238.844813653@linuxfoundation.org> <CA+G9fYtntg7=zWSs-dm+n_AUr_u0eBOU0zrwWqMeXZ+SF6_bLw@mail.gmail.com>
 <eb63e4ce-843f-c840-060e-6e15defd3c4d@roeck-us.net> <CAHk-=wj5cOA+fbGeV15kvwe6YGT54Wsk8F2UGoekVQLTPJz_pw@mail.gmail.com>
 <CAHk-=wgq1soM4gudypWLVQdYuvJbXn38LtvJMtnLZX+RTypqLg@mail.gmail.com>
 <Ys/bYJ2bLVfNBjFI@nazgul.tnic> <CAHk-=wjdafFUFwwQNvNQY_D32CBXnp6_V=DL2FpbbdstVxafow@mail.gmail.com>
 <YtBLe5AziniDm/Wt@nazgul.tnic>
In-Reply-To: <YtBLe5AziniDm/Wt@nazgul.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 14 Jul 2022 13:39:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wghZB60WCh5M_Y0n1qGYbg-1fvWFnU-bV-4j1bQM1qE5A@mail.gmail.com>
Message-ID: <CAHk-=wghZB60WCh5M_Y0n1qGYbg-1fvWFnU-bV-4j1bQM1qE5A@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
To:     Borislav Petkov <bp@alien8.de>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
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

On Thu, Jul 14, 2022 at 10:02 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Jul 14, 2022 at 09:51:40AM -0700, Linus Torvalds wrote:
> > Oh, absolutely. Doing an -rc7 is normal.
>
> Good. I'm gathering all the fallout fixes and will send them to you on
> Sunday, if nothing unexpected happens.

Btw, I assume that includes the clang fix for the
x86_spec_ctrl_current section attribute.

That's kind of personally embarrassing that it slipped through: I do
all my normal test builds that I actually *boot* with clang.

But since I kept all of the embargoed stuff outside my normal trees,
it also meant that the test builds I did didn't have my "this is my
clang tree" stuff in it.

And so I - like apparently everybody else - only did those builds with gcc.

And gcc for some reason doesn't care about this whole "you redeclared
that variable with a different attribute" thing.

And sadly, our percpu accessor functions don't verify these things
either, so you can write code like this:

    unsigned long myvariable;

    unsigned long test_fn(void)
    {
        return this_cpu_read(myvariable);
    }

and the compiler will not complain about anything at all, and happily
generate completely nonsensical code like

        movq %gs:myvariable(%rip), %rax

for it, which will do entirely the wrong thing because 'myvariable'
wasn't allocated in the percpu section.

In the 'x86_spec_ctrl_current' case, that nonsensical code _worked_
(with gcc), because despite the declaration being for a regular
variable, the actual definition was in the proper segment.

But that 'myvariable' thing above does end up being another example of
how we are clearly missing some type checkng in this area.

I'm not sure if there's any way to get that section mismatch at
compile-time at all. For the static declarations, we could just make
DECLARE_PER_CPU() add some prefix/postfix to the name (and obviously
then do it at use time too).

We have that '__pcpu_scope_##name' thing to make sure of globally
unique naming due to the whole weak type thing. I wonder if we could
do something similar to verify that "yes, this has been declared as a
percpu variable" at use time?

                   Linus
