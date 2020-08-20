Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1FF24C06F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 16:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgHTOT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 10:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgHTOTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 10:19:20 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F915C061386
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 07:19:20 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id a1so1148460vsp.4
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 07:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZnDxdkuxYRmNtyk7Y2huayEumQNpEwRvmtnxfMXB4XU=;
        b=ycvUl+MIZkhh4i8WXE15mw8LqxN3ey4UI3XKE1PFm+ioTX5Rxxs+bUZCMNTmMhB6Yo
         +OyB4iENr/YC0+7OkuV1mdJL8vkMNBAuYS27Zb3CMuhpLDUtztBi07B3oHaHAAlw4LAv
         faPtW4aLGLuDBfUflYkU+HQlompO0tg0AGLkCj0AP+bAJWs6tRSMjaGkrHq6OOY/tncy
         BNxP1x+p0RKupWOa0A5i7DKeLHY/+GX8xnh1UGwsFhZhQTAlqI3i365iYGvFMCzQg+qs
         gPqFOssA/diIZdAwWejMobS56aGInUxXfr6vX3f3NjBZwZJZzMUPveJu32uGeqOAQu6l
         +1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZnDxdkuxYRmNtyk7Y2huayEumQNpEwRvmtnxfMXB4XU=;
        b=B6OdvW3vlh0pucWMNj8dovzpSC5eH4liDW/B0Zd43eO325ZUEpf3NupxqvyrOufc3p
         RKqc/RwlJsRQmesYRwjhGbjqsDyyrTX8oxhfT8d6CclZjUGRElfPPH6ZhIVJTq4B98XG
         jr4JbGUqnFJDUC24Ni68vwYQQeMqBfEntNlLDLPtQ0397aRt7U6DB7EJ1TRb2ZnuLH8v
         wypW0Wz4ZEHOf/jCvmc/mznTMiS9xl48lR36fuAvPPew9qkKiraeDnDIrmaLbe/5Qn9E
         4r9Hhnn6PTOhH0Morr3OKrXlHe4ucHpfRiE+ZDvrh0J3180Z69zoULR35Wp9dGD3ZOJB
         tHZQ==
X-Gm-Message-State: AOAM533WwMZfHOM7QxZJGGbne1Gvq0KhE8aEiNX6UOZOGK1gmPtfGRsL
        i9MkAyrpFNxXzwAo5vrP4HRJWcfSdqLZwjhZqRhRaw==
X-Google-Smtp-Source: ABdhPJwuYHKqDHqKwLv8/8PxuHVAGY/r1uoCFi8obd0CL6NZntClddlPGruInNtIRyyIkgjWiazXUfLgaWFjk+pxu8Y=
X-Received: by 2002:a67:6996:: with SMTP id e144mr2120745vsc.185.1597933157760;
 Thu, 20 Aug 2020 07:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200820092125.688850368@linuxfoundation.org>
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Aug 2020 19:49:06 +0530
Message-ID: <CA+G9fYsxQEnACmjP+CUtBq9P+0nWU_19oG62tpCbKtdcGAStfA@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/149] 4.4.233-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 at 15:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.233 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2020 09:21:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.233-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

i386 build failed on stable-rc 4.4 branch

make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=i386 HOSTCC=gcc
CC="sccache gcc" O=build
#
In file included from ../samples/seccomp/bpf-direct.c:19:
/usr/include/linux/types.h:5:10: fatal error: asm/types.h: No such
file or directory
    5 | #include <asm/types.h>
      |          ^~~~~~~~~~~~~
compilation terminated.
In file included from /usr/include/linux/filter.h:10,
                 from ../samples/seccomp/bpf-fancy.c:12:
/usr/include/linux/types.h:5:10: fatal error: asm/types.h: No such
file or directory
    5 | #include <asm/types.h>
      |          ^~~~~~~~~~~~~
compilation terminated.
make[3]: *** [scripts/Makefile.host:108: samples/seccomp/bpf-direct.o] Error 1
make[3]: *** [scripts/Makefile.host:108: samples/seccomp/bpf-fancy.o] Error 1
In file included from /usr/include/bits/errno.h:26,
                 from /usr/include/errno.h:28,
                 from ../samples/seccomp/dropper.c:17:
/usr/include/linux/errno.h:1:10: fatal error: asm/errno.h: No such
file or directory
    1 | #include <asm/errno.h>
      |          ^~~~~~~~~~~~~
compilation terminated.
make[3]: *** [scripts/Makefile.host:108: samples/seccomp/dropper.o] Error 1
In file included from ../samples/seccomp/bpf-helper.c:16:
../samples/seccomp/bpf-helper.h:17:10: fatal error: asm/bitsperlong.h:
No such file or directory
   17 | #include <asm/bitsperlong.h> /* for __BITS_PER_LONG */
      |          ^~~~~~~~~~~~~~~~~~~


-- 
Linaro LKFT
https://lkft.linaro.org
