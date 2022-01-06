Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596BF48625D
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 10:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbiAFJuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 04:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237567AbiAFJuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 04:50:12 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18784C061212
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 01:50:12 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id c6so3748946ybk.3
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 01:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K8lARk+9aIceWETxoJnQyDEyoZX3xAzp3WCfINwI6nM=;
        b=k9xVZQ7F0zo07Vy5vxEiX15gDzQ/J8WPpVLEcmZcOxvEOEsxI+uA1tbFmD+ryerBQ0
         URYkWpkO5NPe8ZSXPNUkrBq/p2p0rJSi0Ov36BZOIU8dEawNxkcz9sYrOqcA2OLqVQfa
         Pmc9+UZcwCm4VWtjOUkjlrUYb3HwrsKVH5hr9yfBKjSQUY9mAJ3VGuCg/quT70qVEent
         fDsWG7UQJw/f31HDqod4tRJZQqgIA93DaBgNfs3+dq6O96ASSnc7BeE9lpmq5feoZQP1
         bOHqkfgUamss86JkpTaTdp6Gezl2oT5a650xuUO9ugsdZ7k4iT8laMAXOnWCYbweLk9a
         UlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K8lARk+9aIceWETxoJnQyDEyoZX3xAzp3WCfINwI6nM=;
        b=LCAY3bGhS5O/9e+WInOz1a8jP/t7MeOiKWZjg+ddkR+mik9ZfrpjLfS4ZIIKlgy2i7
         gtJulw8retlT7Xk7PzzzmZjrwuHb6uaTesY+ev1HQMfGNijNdLbBAVdP8BItfDkHuj0n
         ybNT1fyjynj3J7BrSlDE4+V8HgQJpS4RsUmbRpU5zlXnvdSu64BzF7hlG+HUF17eEkSO
         TwjrObHSUOLCMURaSJ/D15LGhoQt5JICMjDCYozefdv+s3Mv6HT+zgYTV05PR6YZJstd
         91KdnxpeXkDcgQtj67dbGrmoC+BPEvvWcDljPhUskL0dkK3HlsZGIHXplaRa3i0/R9Jf
         AksA==
X-Gm-Message-State: AOAM530K9hGqOPYyC3dY7cf1rxPWht53pvBzT9cL3E6LbhtI7h6nFSAn
        MGOF0FYZ4xzDHQtcNQ5DKpfNM8TnnO//loyCx1NXrWrBm9pR6Q==
X-Google-Smtp-Source: ABdhPJwuRNMrNbvBg4YjrN/D91Fr46dhfxItlTDQnp7sGMJmAh0rX6MJOEXcWkd8jZEKIJV+FKdae74tO2GnvWwMyBA=
X-Received: by 2002:a25:73c7:: with SMTP id o190mr23381904ybc.108.1641462611076;
 Thu, 06 Jan 2022 01:50:11 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYvUu9+68mkCT0S8L0gL28jc5MXGQqOGH6ObciK72FbD8A@mail.gmail.com>
 <Yda3L0givFBDZtXs@kroah.com>
In-Reply-To: <Yda3L0givFBDZtXs@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 6 Jan 2022 15:19:59 +0530
Message-ID: <CA+G9fYuRUsmsj+f3RXAKpvX2k=YJwxj4-_MqWzi1L-D9YdE5Cg@mail.gmail.com>
Subject: Re: test_vsyscall.c:500:22: warning: '__builtin_memcmp_eq' specified
 bound 4096 exceeds source size 0
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        skhan@linuxfoundation.org
Cc:     linux-stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, X86 ML <x86@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jann Horn <jannh@google.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Jan 2022 at 15:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jan 06, 2022 at 02:55:53PM +0530, Naresh Kamboju wrote:
> > While building selftests the following warnings were noticed for x86_64
> > architecture on Linux stable v5.15.13 kernel.
> >
> > metadata:
> >   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x.git
> >   git commit: 734eb1fd2073f503f5c6b44f1c0d453ca6986b84
> >   git describe: v5.15.13
> >   toolchain":  gcc-11
> >   kernel-config: https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYM=
W/config
> >
> > x86_64-linux-gnu-gcc -m64 -o \
> > /home/tuxbuild/.cache/tuxmake/builds/current/kselftest/x86/test_vsyscal=
l_64 \
> >  -O2 -g -std=3Dgnu99 -pthread -Wall -no-pie \
> >  -DCAN_BUILD_64 test_vsyscall.c helpers.h -lrt -ldl
> >
> > test_vsyscall.c: In function 'test_process_vm_readv':
> > test_vsyscall.c:500:22: warning: '__builtin_memcmp_eq' specified bound
> > 4096 exceeds source size 0 [-Wstringop-overread]
> >   500 |                 if (!memcmp(buf, (const void
> > *)0xffffffffff600000, 4096)) {
> >       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Build link:
> > https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/
> >
> > # To install tuxmake on your system globally:
> > # sudo pip3 install -U tuxmake
> >
> > tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-11 \
> >  --kconfig https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/conf=
ig \
> >  cpupower headers kernel kselftest kselftest-merge modules
>
> Is this a new regression from 5.15.0?  Is it also present on Linus's tree=
?

This build warning is not present in Linus's tree.
Following patch to be backported to 5.15.x

---
From dd40f44eabe1e122c6852fabb298aac05b083fce Mon Sep 17 00:00:00 2001
From: Shuah Khan <skhan@linuxfoundation.org>
Date: Thu, 21 Oct 2021 15:33:33 -0600
Subject: selftests: x86: fix [-Wstringop-overread] warn in
 test_process_vm_readv()

Fix the following [-Wstringop-overread] by passing in the variable
instead of the value.

test_vsyscall.c: In function =E2=80=98test_process_vm_readv=E2=80=99:
test_vsyscall.c:500:22: warning: =E2=80=98__builtin_memcmp_eq=E2=80=99 spec=
ified bound
4096 exceeds source size 0 [-Wstringop-overread]
  500 |                 if (!memcmp(buf, (const void
*)0xffffffffff600000, 4096)) {
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>

- Naresh
