Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB54554C8
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 07:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243380AbhKRG3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 01:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243387AbhKRG3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 01:29:35 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC6FC061570;
        Wed, 17 Nov 2021 22:26:35 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id q25so12207278oiw.0;
        Wed, 17 Nov 2021 22:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zC3lGC5vP7hv7dugfu+cJwFjkb/yK58mvfwGdIvQ6+Q=;
        b=UJyHTSrqgpc6qSJ7dtKuhmvl7CwjoI5Be72JM1kVeyHWFvCxlgyJNjGnIduhZKKT2N
         LoIyvADcLPOPnFUb6sZ2mtqFBs4yCWrB/fMRcekgbzrM13tqZUOkMzDUwOSy4hBc+0S3
         wp2YoJxgUdLE5vtcGnCCxtNhebWj0ls3CXaiIPR9TQC6/oG/bUNLpZDGTCliKzGi8ECU
         3hc8lSj+6ZSqPm5Gw9qzi5MZ+F4XpE71/C3kRTUwjWN1h1WJAdQVmILK/6cE1vZUOvYm
         VCRNtwThsFluQvZBAq1OhN5WpRe5SnRGKt5yRHtYGFOPOqvlx9SJz5oDp/vWR88nF9kY
         F2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zC3lGC5vP7hv7dugfu+cJwFjkb/yK58mvfwGdIvQ6+Q=;
        b=Tiz02LPyo0AgTYq6MVSnqSxYY3JOruYk6nttponROFKsXP57fAr8S0HNgYX5cbVzVM
         BKNGHOgVdBIGpEXp1d5nkYbAJeG4wNd5pg8G0XcqWn8dp0dKSdzCcq1zs7fjs9JwzK94
         OXOcp/xgGyg00F336Hqd4NJ6WL+jZsRHOo0VUmMR3CIC6ExEca4McMuoAtvCjegag16N
         BP4UIowm5YIfTMqHhZlYQmWm5+tu5YZpsBa8QZokqa0qf0R+tGO+vLQON6Mu6vSqd9Nm
         3XHh8MsbVD6+QSu6JQekkayAU135vpBwDOVzEBb3wq83fKIaW6t5VLNOxFhhRYbaG06x
         UThg==
X-Gm-Message-State: AOAM533/mrkJTo53mPvTs7Hjj6hgc3xpiPohJecHAukg0sqVuy00xynG
        spnkxsIGTjP3J+hm7w59P1c=
X-Google-Smtp-Source: ABdhPJwA0Q3XlpFWj5xMSUo2FP2f9bsNXHhPMSNIPkd6MOQOLgbPY7tF3VlylTWmaC9TA1g+gURyGA==
X-Received: by 2002:a05:6808:53:: with SMTP id v19mr5666603oic.8.1637216794882;
        Wed, 17 Nov 2021 22:26:34 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bi20sm645377oib.29.2021.11.17.22.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 22:26:34 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
To:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Wang Yugui <wangyugui@e16-tech.com>,
        =?UTF-8?Q?Fran=c3=a7ois_Guerraz?= <kubrick@fgv6.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <202111171609.56F12BD@keescook>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <7bc0d46b-1412-a630-bbf7-57e7ec702784@roeck-us.net>
Date:   Wed, 17 Nov 2021 22:26:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <202111171609.56F12BD@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/17/21 4:16 PM, Kees Cook wrote:
> On Wed, Nov 17, 2021 at 03:50:17PM -0800, Linus Torvalds wrote:
>> Sorry for top-posting and quoting this all, but the actual people
>> involved with the wchan changes don't seem to be on the participant
>> list.
> 
> Adding more folks from a private report and
> https://bugzilla.kernel.org/show_bug.cgi?id=215031
> 
> and for the new people, here's a lore link for this thread:
> https://lore.kernel.org/stable/YZV02RCRVHIa144u@fedora64.linuxtx.org/
> 
> 
> FWIW, earlier bisection pointed to the stable backport of
> 5d1ceb3969b6b2e47e2df6d17790a7c5a20fcbb4 being the primary culprit.
> At first glance it seems to me that the problem with -stable is that an
> unvetted subset of the wchan refactoring series landed in -stable.
> 

Can the (partial) wchan backport possibly be dropped from v5.15.y until
someone figures out what exactly - if anything - is needed ?

Thanks,
Guenter
