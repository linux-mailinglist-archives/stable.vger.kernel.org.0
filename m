Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E1B23CF9F
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgHETXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728946AbgHERjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 13:39:49 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13870C061575
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 10:39:49 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id w12so33152174iom.4
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 10:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ltXiat2Rl2Zwbogz+0r5FKwZHjDORLemXuadza+vI+Q=;
        b=Ya3jo9QJDcOA6NffqQfhpqKparGgzal9V+JPBiYU4afxBELrAdQZJKpN77F6OHvG2j
         0LgWLVjraEAcCbRa70iPs+xRARHMu3NwCtbyhcT0sYY4bbuXXlfMbd6q0uhG4YOBBaDf
         GLy4rLWmBI24Wbb9KFKW1Z+hv6w0zSikRGiha05Ko6lAntvWEAuKWgy9T43+o6t5WjIK
         OF5XQXzdU2zHIQUd6UXL/vMefBjaDUDOTx1PqHmP9p3vHmRp5F7bRqWoybKf9zM91N6a
         UvAmoeHGvce1psyCwUAPesnydIxy8TNzzRlMkx2re4mSSw9WDW0ccl/aLKJKGSEZUDfi
         gbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ltXiat2Rl2Zwbogz+0r5FKwZHjDORLemXuadza+vI+Q=;
        b=int7VSdh8d7DVEJVbykwDTN0j1Khjfquq3NO+PPCbw0513JvpNCC512+nUrRi2ljJ9
         TbQjKi0hLMg83wJI4MUadzmw1kjZPL3rtRFRqw6mWQkfqOvd+uaqcZk4Ghy3+FN+LOKL
         EUfXa2lwHPqaKOwdJ20gzi//1StpYcewyeUV/j4Xe2edaS+1wfGIDQmAWKRNbdmit7Dn
         CJsEUyUh1IRLUDRAJMY7xZj8WmbAOmSVuHqToVhN8j1uqzpu48WMyVp5mxw7u7cOeHIq
         2F7smWdBggTKKrPQs9WLUOwrElN19I+P0zo0UVfNiKGlGUMznB2j5MWXfvNkmB7w3ZVx
         4HvQ==
X-Gm-Message-State: AOAM53264M3AMEMGnSXVGDYv0oFcw5Q9WTMO0YKgDK6rZwvZP8qIU7Zp
        ElK36xImxS4anCpfV95VlQw7uHBhEhXZvGVDOwIgiA==
X-Google-Smtp-Source: ABdhPJyFew5VLDSWc3gE+0xFUlGE3hKSfOMO1eUbHLBzf9JX57Tz6MZ9GTG6hb1mgP02FR8F+uwTF+rF0OjPkL+kLVk=
X-Received: by 2002:a5d:995a:: with SMTP id v26mr4435600ios.176.1596649188239;
 Wed, 05 Aug 2020 10:39:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200805153506.978105994@linuxfoundation.org>
In-Reply-To: <20200805153506.978105994@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 5 Aug 2020 23:09:37 +0530
Message-ID: <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
Subject: Re: [PATCH 5.7 0/6] 5.7.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, w@1wt.eu,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 5 Aug 2020 at 21:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.14 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.7.14-rc1
>
> Marc Zyngier <maz@kernel.org>
>     arm64: Workaround circular dependency in pointer_auth.h
>
> Linus Torvalds <torvalds@linux-foundation.org>
>     random32: move the pseudo-random 32-bit definitions to prandom.h
>
> Linus Torvalds <torvalds@linux-foundation.org>
>     random32: remove net_rand_state from the latent entropy gcc plugin
>
> Willy Tarreau <w@1wt.eu>
>     random: fix circular include dependency on arm64 after addition of percpu.h
>
> Grygorii Strashko <grygorii.strashko@ti.com>
>     ARM: percpu.h: fix build error
>
> Willy Tarreau <w@1wt.eu>
>     random32: update the net random state on interrupt and activity
>

[ sorry if it is not interesting ! ]

While building with old gcc-7.3.0 the build breaks for arm64
whereas build PASS on gcc-8, gcc-9 and gcc-10.

with gcc 7.3.0 build breaks log,

In file included from arch/arm64/include/asm/archrandom.h:9:0,
                 from arch/arm64/kernel/kaslr.c:14:
include/linux/random.h: In function 'arch_get_random_seed_long_early':
include/linux/random.h:149:9: error: implicit declaration of function
'arch_get_random_seed_long'; did you mean
'arch_get_random_seed_long_early'?
[-Werror=implicit-function-declaration]
  return arch_get_random_seed_long(v);
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         arch_get_random_seed_long_early
include/linux/random.h: In function 'arch_get_random_long_early':
include/linux/random.h:157:9: error: implicit declaration of function
'arch_get_random_long'; did you mean 'get_random_long'?
[-Werror=implicit-function-declaration]
  return arch_get_random_long(v);
         ^~~~~~~~~~~~~~~~~~~~
         get_random_long
In file included from arch/arm64/kernel/kaslr.c:14:0:
arch/arm64/include/asm/archrandom.h: At top level:
arch/arm64/include/asm/archrandom.h:30:33: error: conflicting types
for 'arch_get_random_long'
 static inline bool __must_check arch_get_random_long(unsigned long *v)
                                 ^~~~~~~~~~~~~~~~~~~~
In file included from arch/arm64/include/asm/archrandom.h:9:0,
                 from arch/arm64/kernel/kaslr.c:14:
include/linux/random.h:157:9: note: previous implicit declaration of
'arch_get_random_long' was here
  return arch_get_random_long(v);
         ^~~~~~~~~~~~~~~~~~~~
In file included from arch/arm64/kernel/kaslr.c:14:0:
arch/arm64/include/asm/archrandom.h:40:33: error: conflicting types
for 'arch_get_random_seed_long'
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
                                 ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from arch/arm64/include/asm/archrandom.h:9:0,
                 from arch/arm64/kernel/kaslr.c:14:
include/linux/random.h:149:9: note: previous implicit declaration of
'arch_get_random_seed_long' was here
  return arch_get_random_seed_long(v);
         ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from arch/arm64/kernel/kaslr.c:14:0:
arch/arm64/include/asm/archrandom.h:72:1: error: redefinition of
'arch_get_random_seed_long_early'
 arch_get_random_seed_long_early(unsigned long *v)
 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from arch/arm64/include/asm/archrandom.h:9:0,
                 from arch/arm64/kernel/kaslr.c:14:
include/linux/random.h:146:27: note: previous definition of
'arch_get_random_seed_long_early' was here
 static inline bool __init arch_get_random_seed_long_early(unsigned long *v)


-- 
Linaro LKFT
https://lkft.linaro.org
