Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A228324C0B2
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 16:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgHTOfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 10:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgHTOff (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 10:35:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B022C061385;
        Thu, 20 Aug 2020 07:35:34 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m8so1127713pfh.3;
        Thu, 20 Aug 2020 07:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=buWOKQJLcnOJc7cnNogDlAeM2uo0sPR65962gACuPYA=;
        b=rx9tD1dpJE2qwM3lc5G0srjcRy6hK+TSHS4TivZr91cMQfYlvGS5uGW9eDsnGrNg0m
         KzkoYOZ7uNWcmPQk5ZRe1E62cTdl0zjXPRvS9n+FRYXsc3uNFzn+nv/daKgtZYiCiorI
         s26bg6R8KOZF3VzMo7Phn+S6Y0L/SBGFSWEExYF/P2JeSLWvp8fl467My+xHpsH/ZKsL
         JZXX/XAUgr3ineLKjux5qW7vZh4iuRdoDo8yaJZtggAWOKy6WSAfNr4POkBnJ9K8b1vu
         ySSfMrUvVbLmujGVzO9UTfCv3zSvlLg6gEN04GvFEEZFx7mOUI/KDk3N+tU9BrVVkYSr
         nCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=buWOKQJLcnOJc7cnNogDlAeM2uo0sPR65962gACuPYA=;
        b=eRtMJji7SuFKiyEfFv2y6T7QgiXK0XwoGDXdNZg9lpZ7lAGJ1voJr5ythqACzENtaJ
         hm0paJOBbvKJ1DoZh6F0hB5VC6CovW/8E5KXjlyg0BipiqPzxGmAignkgEeJZG4xxyZv
         VUv7imsle5xM3kn4bRhBEHICNtUR6bId1yiDSJMlEcgvwNFDTqHTJOVG5aVdzo4oqG+o
         8J66xLVa17RqToBi54gAE9r/KVYYFfw28x797ZjS5hLqaiRKgt4m4eQaqOfA6Ztmsitr
         e4r+l6/b/jYwgR51bmapagZ+s+QUTa4UmzW/G14aJnX2daKotROGa1DhfcVkSW9gGKrl
         T2cg==
X-Gm-Message-State: AOAM531+L+qtqdz+MF5ZIkkJRWz55Rco55c4Z95l1NBNd3D8ZiqlBckC
        dzlDwtIOnWKb3lNPMNkqX+k=
X-Google-Smtp-Source: ABdhPJwOuE+g7pC229sGWiwlW2fGH+3ml/B8Lh21zvJZRdHpG5riq5JZZdabGKeyaUYto9dH/TNunA==
X-Received: by 2002:aa7:954d:: with SMTP id w13mr2551467pfq.156.1597934134111;
        Thu, 20 Aug 2020 07:35:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h19sm2337289pjv.41.2020.08.20.07.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 07:35:33 -0700 (PDT)
Subject: Re: [PATCH 4.4 000/149] 4.4.233-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Kees Cook <keescook@chromium.org>
References: <20200820092125.688850368@linuxfoundation.org>
 <CA+G9fYsxQEnACmjP+CUtBq9P+0nWU_19oG62tpCbKtdcGAStfA@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <02d1fdb7-34b3-e048-d4ac-cb82d392157f@roeck-us.net>
Date:   Thu, 20 Aug 2020 07:35:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYsxQEnACmjP+CUtBq9P+0nWU_19oG62tpCbKtdcGAStfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/20 7:19 AM, Naresh Kamboju wrote:
> On Thu, 20 Aug 2020 at 15:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 4.4.233 release.
>> There are 149 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 22 Aug 2020 09:21:01 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.233-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> i386 build failed on stable-rc 4.4 branch
> 

It builds for me.

Build reference: v4.4.232-150-g1c57f0a
gcc version: x86_64-linux-gcc (GCC) 9.2.0

Building i386:defconfig ... passed
Building i386:allyesconfig ... passed
Building i386:allmodconfig ... passed
Building i386:allnoconfig ... passed
Building i386:tinyconfig ... passed
Building i386:tools/perf ... passed

What configuration fails to build for you ?

Thanks,
Guenter

> make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=i386 HOSTCC=gcc
> CC="sccache gcc" O=build
> #
> In file included from ../samples/seccomp/bpf-direct.c:19:
> /usr/include/linux/types.h:5:10: fatal error: asm/types.h: No such
> file or directory
>     5 | #include <asm/types.h>
>       |          ^~~~~~~~~~~~~
> compilation terminated.
> In file included from /usr/include/linux/filter.h:10,
>                  from ../samples/seccomp/bpf-fancy.c:12:
> /usr/include/linux/types.h:5:10: fatal error: asm/types.h: No such
> file or directory
>     5 | #include <asm/types.h>
>       |          ^~~~~~~~~~~~~
> compilation terminated.
> make[3]: *** [scripts/Makefile.host:108: samples/seccomp/bpf-direct.o] Error 1
> make[3]: *** [scripts/Makefile.host:108: samples/seccomp/bpf-fancy.o] Error 1
> In file included from /usr/include/bits/errno.h:26,
>                  from /usr/include/errno.h:28,
>                  from ../samples/seccomp/dropper.c:17:
> /usr/include/linux/errno.h:1:10: fatal error: asm/errno.h: No such
> file or directory
>     1 | #include <asm/errno.h>
>       |          ^~~~~~~~~~~~~
> compilation terminated.
> make[3]: *** [scripts/Makefile.host:108: samples/seccomp/dropper.o] Error 1
> In file included from ../samples/seccomp/bpf-helper.c:16:
> ../samples/seccomp/bpf-helper.h:17:10: fatal error: asm/bitsperlong.h:
> No such file or directory
>    17 | #include <asm/bitsperlong.h> /* for __BITS_PER_LONG */
>       |          ^~~~~~~~~~~~~~~~~~~
> 
> 

