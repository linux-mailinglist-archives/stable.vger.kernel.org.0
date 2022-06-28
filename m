Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F82655EFA7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 22:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiF1UdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 16:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiF1UdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 16:33:00 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC618BF7F;
        Tue, 28 Jun 2022 13:32:59 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x138so10352445pfc.3;
        Tue, 28 Jun 2022 13:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wg8+F4TuFkG1xW6NWKjkWvVt/UeHSlIng0uV9LgXC0s=;
        b=dqVD2Rci/rbAyFFszQrdO48V3S3apzN/yRFMOMcr7JtbtriXkLnLJitsUgfjpKK7Z+
         y3wyvHK8B+WaonGnTc3snZIYrvkvrsgye37c3cz/Nv3PqEHIVjHKpCAxIUZpDcYWB1Pa
         W28xlLtVHPr0jPhsgbGyLDnnMxbmJtr6HZc2hIf4sJchxwIx8Trtr/D3vqK2l+XR8mcG
         tiRixn1dYXmdcwA1bWJVXJLvjExYl+8rbKfSTzRIlgZUBy9o5lK7liort9h1mXq8IwCQ
         MNSskNRcEG8URFcpPrhzcZE1KQSIfSI5e/S110Bpk2XOPXqdwAb5Kx9aH+u6bmpOrZQg
         xMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wg8+F4TuFkG1xW6NWKjkWvVt/UeHSlIng0uV9LgXC0s=;
        b=FwTpOluSW+cHmSkkBetOPbGEZRnajbNYrlquCEKgNK5MdPR3P+qObuDg4VHpgbH6ck
         mXq5GbMcjlnINpSqATrp4ZZGbmdYFDfsqdqh5Ty8SeZ92JMy1ToQAJcAZHpz1o12482t
         YfoKgF1FtufvcupDOAlsQF6b4UGZgemZQ5ihEwRJCGGqvRwFt1Q2rbMPCz0HdGxwGU/k
         /1j3TQ0chd+RCzAIhPSIbUx1I/2Na2GeGbJv0bl4gbAg9KQluTmW0VDHdPRq9xxSw3ht
         JQ/Z9wAzb8Kz0UOuvReKl+IXGmciTSpLtLISGdNvtYWELwkHPU46KogQTAdKQeEFoZko
         wbHg==
X-Gm-Message-State: AJIora9fNhxJiRsVrQHZBNLfNMXEQn56K1yLDsiUI+r25z0MH3MGi5VR
        CQXiIBXa3B0BdJMCzlC9WyU=
X-Google-Smtp-Source: AGRyM1udAr2RA5pfWkYa0XVxSNy7W5KHGCo6ZXIjn694WLrbM6NtFsMcKbOusvCcRMF0+doZu0RiGw==
X-Received: by 2002:a63:88c3:0:b0:40d:5f26:bfa8 with SMTP id l186-20020a6388c3000000b0040d5f26bfa8mr19136588pgd.608.1656448379122;
        Tue, 28 Jun 2022 13:32:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x10-20020a1709027c0a00b0016a6caacaefsm9272820pll.103.2022.06.28.13.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 13:32:58 -0700 (PDT)
Message-ID: <ef48302b-3421-ebbe-7135-1297cffba7ed@gmail.com>
Date:   Tue, 28 Jun 2022 13:32:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 57/60] modpost: fix section mismatch check for
 exported init/exit sections
Content-Language: en-US
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jessica Yu <jeyu@kernel.org>
References: <20220627111927.641837068@linuxfoundation.org>
 <20220627111929.368555413@linuxfoundation.org>
 <6cd16364-f0cd-b3f3-248f-4b6d585d05ef@gmail.com>
 <CAKwvOdm8UiY8CsqNgyoq4MdC2TbBj-1+cRE+fWZ9+vVBxNZz_Q@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAKwvOdm8UiY8CsqNgyoq4MdC2TbBj-1+cRE+fWZ9+vVBxNZz_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/28/22 12:11, Nick Desaulniers wrote:
> On Mon, Jun 27, 2022 at 10:03 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 6/27/22 04:22, Greg Kroah-Hartman wrote:
>>> From: Masahiro Yamada <masahiroy@kernel.org>
>>>
>>> commit 28438794aba47a27e922857d27b31b74e8559143 upstream.
>>>
>>> Since commit f02e8a6596b7 ("module: Sort exported symbols"),
>>> EXPORT_SYMBOL* is placed in the individual section ___ksymtab(_gpl)+<sym>
>>> (3 leading underscores instead of 2).
>>>
>>> Since then, modpost cannot detect the bad combination of EXPORT_SYMBOL
>>> and __init/__exit.
>>>
>>> Fix the .fromsec field.
>>>
>>> Fixes: f02e8a6596b7 ("module: Sort exported symbols")
>>> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>>> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> This commit causes the following warning to show up on my kernel builds
>> used for testing 5.4 stable candidates:
>>
>> WARNING: vmlinux.o(___ksymtab+drm_fb_helper_modinit+0x0): Section
>> mismatch in reference from the variable __ksymtab_drm_fb_helper_modinit
>> to the function .init.text:drm_fb_helper_modinit()
>> The symbol drm_fb_helper_modinit is exported and annotated __init
>> Fix this by removing the __init annotation of drm_fb_helper_modinit or
>> drop the export.
> 
> Thanks for the report. Looks like the patch is "working as intended."
> 
> It looks like drm_fb_helper_modinit was deleted outright in
> commit bf22c9ec39da ("drm: remove drm_fb_helper_modinit")
> in v5.12-rc1.
> 
> Florian, can you test if that cherry-picks cleanly and resolves the
> issue for you?

It does and it does, thanks!

> 
> Maybe let's check with Christoph if it's ok to backport bf22c9ec39da
> to stable 5.10 and 5.4?
> 
>>
>> The kernel configuration to reproduce this is located here (this is 5.10
>> but works in 5.4 as well):
>>
>> https://gist.github.com/2c3e8edd5ceb089c8040db724073d941
>>
>> Same applies to the 5.10, 5.15 and 5.18 stable queues FWIW.
>> --
>> Florian
> 
> 
> 


-- 
Florian
