Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4CC45763A
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 19:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbhKSSUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 13:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbhKSSUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 13:20:18 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFBAC061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 10:17:16 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z5so46237574edd.3
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 10:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=628q7p3vVd0CrFkuTgEua4myh/YWxoKJzbNr8Nt91Dc=;
        b=B1qBurZLaTfs+YDrS88+hpXrRqF+sRYb+RNluKjR4PQ/0ek0HiF8Mwa2OTZPwJrFzJ
         3xsMytEib1XmwgDyiEc66iSSMH2iFZPfJ292ZecypDC1DlrigRQlQvoITAgvimf4zdSM
         H0b8nyx8avpQNuFPS+eqZuEq6lZLQ8E+DT8Q8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=628q7p3vVd0CrFkuTgEua4myh/YWxoKJzbNr8Nt91Dc=;
        b=jPYwx3LYW7gc9RLbFtF5uyJR4VfNxGl+/x3/u4vWANw5LeS1tPB8n5zYJXhKx7zhp3
         vtE3fWDL560Tgy7ahopC3jcyF9/zrmzFuX3ZlULK2OU0kcfh3CvBVdjP55GXAePdFY8z
         sLqQ5ZomhqyDiEXAE1vdaE5ra+02tz+zwtncgBCDBmxSvuSoQw7rYBXBHe/+5kinP5Hk
         mpGkQLhF1SUN3oINPRvFnqwhWxjKZGoW3gTY2wZhSziRvt1MUbuMxwQAGq31ohoY7VJC
         5SKXI6zqKpbSMkLRq3dFy7NRsh4CCuzlwdQvQJ242nJ+eSaRu6MdN1ZFZ590OIotecxD
         L8fA==
X-Gm-Message-State: AOAM531WuJFKl5uNdHQfxpmR6IRcRXm73FHGzkIEkSrlnTKfS0ShjI6G
        byXBuztkk3cA9X2cN3OI2yjaBk1uCO1HhUCY
X-Google-Smtp-Source: ABdhPJxCz+u0wWcPT0tD1JZ0CdBpG8n7G/UDxRerRzHJSeRxMWdTFHHDP7IFD0b0kxn0Jrxd39sEKA==
X-Received: by 2002:a17:907:7fa8:: with SMTP id qk40mr10267851ejc.497.1637345834256;
        Fri, 19 Nov 2021 10:17:14 -0800 (PST)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id sa3sm237979ejc.113.2021.11.19.10.17.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 10:17:13 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so8165688wme.4
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 10:17:13 -0800 (PST)
X-Received: by 2002:a05:600c:1d97:: with SMTP id p23mr2056537wms.144.1637345833034;
 Fri, 19 Nov 2021 10:17:13 -0800 (PST)
MIME-Version: 1.0
References: <20211117101657.463560063@linuxfoundation.org> <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net> <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
 <20211119020427.2y5esq2czquwmvwc@treble> <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
In-Reply-To: <YZduix64h64cDa7R@hirez.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 19 Nov 2021 10:16:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9S-ETonTdvm+DWSBcvmNN50ccDBJ3DXBKYoGoNXBXUg@mail.gmail.com>
Message-ID: <CAHk-=wj9S-ETonTdvm+DWSBcvmNN50ccDBJ3DXBKYoGoNXBXUg@mail.gmail.com>
Subject: Re: [PATCH] x86: Pin task-stack in __get_wchan()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        "Holger Hoffst??tte" <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 1:30 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> Anyway, below is the minimal fix for the situation at hand. I'm not
> going to be around much today, so if Linus wants to pick that up instead
> of mass revert things that's obviously fine too.

Applied.

I did have to add a number of "Link:" and "Reported-by:" etc lines
though. Please try to keep those kinds around as you make patches,
they get lost and forgotten too easily.

            Linus
