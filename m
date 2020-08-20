Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CA124C377
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 18:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgHTQjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 12:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729981AbgHTQju (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 12:39:50 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEC0C061386
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 09:39:50 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id y17so760142uaq.6
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 09:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PyflrXnQUbtPNUqSeNBAoTuBoeAweIXkGnj1Lf7fZSk=;
        b=dr6MhC1jPPfshOSLfPKpekWjY1WHI+qJSoim5A4vRN0/F4DFjTNMiPhq5bet4Tf8p7
         B7ZLQnoPZFPXCQ9ui1d4ETCVWa/8qUDz4ye4CbuyixhGZinkBNpp3r8pvuFUYQtZjpZf
         WeGzJJSTBL/0P0T4INT0G1bg5lsWCyiR9QsWjycUGwsdcuZ0TobFpTYUp3WuTokWbHjP
         sD/mYfze0TLOxAyDC0UX4CCpfvbBZ/lcEIrh9U+q9jBH24+GW59JNQ07BPp3zb0t2yXe
         QZy8gyrNq29iR2so09dePODfIuLDRWeTwkZ6fxOJLkgDhC3r6zoRaPBtVNVIBCOVdd1Y
         wCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PyflrXnQUbtPNUqSeNBAoTuBoeAweIXkGnj1Lf7fZSk=;
        b=n3eCxIlBbtMzaVW7AzR6TIdJYX8tX+ieN/LFk9bQbwgZBeDJ3oHFI50j4RMayMtR+0
         DdbGOpB3LlVVM++fyOodlfrTF4B7rkepAJ/Lk5NHd6hob6za3YLMmUDDRPUkQyVnvnLV
         q7rck2WtRz/DCckDlA4lxahYBbA+BNNw/qiK0CY326+RtngRBVM8S8ROGubOuG2gCUfI
         JsNb4OXZwYvLJUNePN1BsmYztccITbhvFF2MSvsnEm7fkdqnwGnPZoJM4cqsCOakkZct
         mzW1724HkM2ObpEZU8Qwtp1Px0YBL8UzfBVLidZHZarqhNTjLMXPqLzZgMj3jL4ZV5rx
         AWmw==
X-Gm-Message-State: AOAM533SEhIW+Jopt/IR6VbaF6ezSYjkaVU+s5HG/tCNKFVGtXKPnWzG
        jh5Ewet/j/wgCnN8uHZ8i2AO5eStLVoYv80ljfnbtQ==
X-Google-Smtp-Source: ABdhPJzTyguz0hHskIuhi/a8ZlQvRyze+vAX2RCvtL1XzFeizaLNtlEV/e/4IdYUD/JqaIZ9RY3WBc6ECZCeBAFFOnA=
X-Received: by 2002:ab0:4029:: with SMTP id h38mr2363377uad.6.1597941589256;
 Thu, 20 Aug 2020 09:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200820092125.688850368@linuxfoundation.org> <CA+G9fYsxQEnACmjP+CUtBq9P+0nWU_19oG62tpCbKtdcGAStfA@mail.gmail.com>
 <20200820150848.GA1565072@kroah.com>
In-Reply-To: <20200820150848.GA1565072@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Aug 2020 22:09:37 +0530
Message-ID: <CA+G9fYu9r8wfWVLmyMC+bbnCbJH1Zzr7ps_4N0coybYEUenUaw@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/149] 4.4.233-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, danieltimlee@gmail.com,
        masahiroy@kernel.org, ivan.khoronzhuk@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Aug 2020 at 20:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Aug 20, 2020 at 07:49:06PM +0530, Naresh Kamboju wrote:
> > On Thu, 20 Aug 2020 at 15:47, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.4.233 release.
> > > There are 149 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 22 Aug 2020 09:21:01 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.233-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > i386 build failed on stable-rc 4.4 branch
> >
> > make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=i386 HOSTCC=gcc
> > CC="sccache gcc" O=build
> > #
> > In file included from ../samples/seccomp/bpf-direct.c:19:
> > /usr/include/linux/types.h:5:10: fatal error: asm/types.h: No such
> > file or directory
> >     5 | #include <asm/types.h>
> >       |          ^~~~~~~~~~~~~
> > compilation terminated.
> > In file included from /usr/include/linux/filter.h:10,
> >                  from ../samples/seccomp/bpf-fancy.c:12:
> > /usr/include/linux/types.h:5:10: fatal error: asm/types.h: No such
> > file or directory
> >     5 | #include <asm/types.h>
> >       |          ^~~~~~~~~~~~~
> > compilation terminated.
> > make[3]: *** [scripts/Makefile.host:108: samples/seccomp/bpf-direct.o] Error 1
> > make[3]: *** [scripts/Makefile.host:108: samples/seccomp/bpf-fancy.o] Error 1
> > In file included from /usr/include/bits/errno.h:26,
> >                  from /usr/include/errno.h:28,
> >                  from ../samples/seccomp/dropper.c:17:
> > /usr/include/linux/errno.h:1:10: fatal error: asm/errno.h: No such
> > file or directory
> >     1 | #include <asm/errno.h>
> >       |          ^~~~~~~~~~~~~
> > compilation terminated.
> > make[3]: *** [scripts/Makefile.host:108: samples/seccomp/dropper.o] Error 1
> > In file included from ../samples/seccomp/bpf-helper.c:16:
> > ../samples/seccomp/bpf-helper.h:17:10: fatal error: asm/bitsperlong.h:
> > No such file or directory
> >    17 | #include <asm/bitsperlong.h> /* for __BITS_PER_LONG */
> >       |          ^~~~~~~~~~~~~~~~~~~
>
> Any pointers to the commit that caused this?  I'll place odds on one of
> the random.h changes :(
>

This config is causing a build break with gcc-9 on stable-rc 4.4 on i386.
CONFIG_SAMPLES=y

P.S. Recently we have enabled DYNAMIC debug and more trace configs.

- Naresh
