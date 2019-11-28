Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40CC10C355
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 06:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbfK1FCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 00:02:25 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33133 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfK1FCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 00:02:25 -0500
Received: by mail-lj1-f195.google.com with SMTP id t5so26998855ljk.0
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 21:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wwAHZEA0jlGAecazH8A4WVcg6j9/yx6Hh8ujY0Dq/vM=;
        b=sOAAZbEJsiX980a7JeUj7a7cXAEr95sXDfUkO68+lZPsnHBdRXXUMmOuOUfkelWFY2
         QXoGEOyxhVnNrKMCoI3Tg9MScml5yHLRbnXGUv7lilIRxSr3hqJ6afgvUC/KvDc3zVNA
         PC5oR2+SpOGiF0REPK275GWQmDzzoYNk9GY4s5bz+LiZQLnVZTJpqkyxEvaZ7mfqZxrI
         s+Wp3uvquKzzVBx4Lk5/vCmmlcE1VbRPMzLQ5kC38Jvzqoua5B7RRJexxunvid6APAIE
         Qhg3mYe0ytbf+Ncj3d3oYF45GdwObSSUrO3Iv5HTtHUjFQdrfXcs3FnGJN+1HmMfJZoG
         YJ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wwAHZEA0jlGAecazH8A4WVcg6j9/yx6Hh8ujY0Dq/vM=;
        b=PwaxOnaFkLPNqIHjjsXpHT9Ju4BZ8k7xMHDLVN+cYbeSERNF6NqpAj+vxuOElJMZps
         cA6MbchiU6Jh4qswmjPUgwpBjsBvW/TC1N1dr8eU/DUeJpjT0iMOZjwh/xCTu2GSK2Yd
         3TNY3ZaQVofjKnOv6zg8F63sR5WXYG/v5qQwrOsMVj9a8iYj9wP4hXBAQDiU0ppH9gPn
         YLeIsDTjUyRbZXcxwBlPB2JXLBhctHmtpP7u6KGtWyBkEOmlnk3p7iDVi29QZYcLCAwp
         zm3kt4izgrgkYrZW3smeg6w02ovo2L8mDnUwpVA1FqGesiQF+xVWfmysirD4FhOWttbx
         pofA==
X-Gm-Message-State: APjAAAUedyuh0pzNCOhX0x8JEWnDgnAW+ckl22zXIswYBpQjaWPBI9zC
        1Ck0cTHfTT4chqDkAg1kfBeBtohir0rHN1G8xTlqtA==
X-Google-Smtp-Source: APXvYqypJIEfugB0UvdI6BgmE5R9HF/glAtn2wZ4w1z6KcQ3egurLdE1sd9MVMGYQzf/dnSD7MS/1JAMuJmSR4Kq+w0=
X-Received: by 2002:a2e:7202:: with SMTP id n2mr29808167ljc.194.1574917341238;
 Wed, 27 Nov 2019 21:02:21 -0800 (PST)
MIME-Version: 1.0
References: <20191127203049.431810767@linuxfoundation.org>
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Nov 2019 10:32:10 +0530
Message-ID: <CA+G9fYsMm5L+Yd99pZPDMWg3nKVp8RqiboUJ=YVitae8zmFnsA@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/211] 4.14.157-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 Nov 2019 at 02:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.157 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.157-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

This patch causing build failure for x86 32bit on stable-rc 4.14 and
stable-rc-4.19

> Thomas Gleixner <tglx@linutronix.de>
>     x86/cpu_entry_area: Add guard page for entry stack on 32bit

In file included from include/linux/kernel.h:10:0,
                 from include/linux/list.h:9,
                 from include/linux/preempt.h:11,
                 from include/linux/spinlock.h:51,
                 from arch/x86/mm/cpu_entry_area.c:3:
In function 'setup_cpu_entry_area_ptes',
    inlined from 'setup_cpu_entry_areas' at arch/x86/mm/cpu_entry_area.c:164:2:
include/linux/compiler.h:334:38: error: call to
'__compiletime_assert_147' declared with attribute error: BUILD_BUG_ON
failed: (CPU_ENTRY_AREA_PAGES+1)*PAGE_SIZE != CPU_ENTRY_AREA_MAP_SIZE
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
                                      ^
include/linux/compiler.h:314:4: note: in definition of macro
'__compiletime_assert'
    prefix ## suffix();    \
    ^~~~~~
include/linux/compiler.h:334:2: note: in expansion of macro
'_compiletime_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
  ^~~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:47:37: note: in expansion of macro
'compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:71:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
  ^~~~~~~~~~~~~~~~
arch/x86/mm/cpu_entry_area.c:147:2: note: in expansion of macro 'BUILD_BUG_ON'
  BUILD_BUG_ON((CPU_ENTRY_AREA_PAGES+1)*PAGE_SIZE != CPU_ENTRY_AREA_MAP_SIZE);
  ^~~~~~~~~~~~

--
Linaro LKFT
https://lkft.linaro.org
