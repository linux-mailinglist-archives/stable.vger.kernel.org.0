Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F653486216
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 10:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbiAFJ0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 04:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbiAFJ0G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 04:26:06 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31B2C061212
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 01:26:05 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id k69so5734662ybf.1
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 01:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=1qCNKBijl+qhalBNqXGw/nmUY/wmEYIr8f+v0ZZhmlI=;
        b=AMA8DX0auN2ez9j7TDDHCNP2XuOF4AMWVgkALWHapySXLQPy8AN68ezCoUNKOShE95
         Jutrutgtz4ylk+WSDiGR0q4CfJpwEHGlJFu2A1d0R8AFBNro2IyWUhy6maZN2u4zQTRG
         V3aRSPU8fIwehB3tM4ZvDXeKQWijeR6reFCjSW1z9SjpVUdaqt1osuBtT5dPhNoQTUX4
         mtNPnu5jk1S6mCQeqRAYE1fR77Q7j//ekBLPWh12H+k+RI6J/L4MVD1rM2qITg70kpHk
         I8qpzs0ZbuXp/Sl1PwYUpAcQjy2oiOz++pt25Q4rnEQZc7dQgWccIZ4PNFuFDguMiQnp
         t6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=1qCNKBijl+qhalBNqXGw/nmUY/wmEYIr8f+v0ZZhmlI=;
        b=PiuKy0b/brGUixsmJ1RSIFVcMrRdO1GWYP3c+z910zjrK+ar0xLbE5pqsok8jLKeLG
         1qyTmduZ+jkscdR0nxhgGhCi7X656YvSBx8bboCwmYERPIlNksRi0w2u9HLl7Yd9qxt0
         199hgEZA5R7GQhEgkxytj6QKEBEi6jzpOBMphPqO5Zw3JXMf4ISsEpxv7n186W/rabnN
         qtxMaoxFexmSI+6uVxn002wx/cGCzH7uSU0xjWiwd1n90KKTfIqmJQaHceYuM5K7UZhh
         hum10rn5EddTbXVl402l/PtsMbfP8J5tr6rGObKnSY7TPZI7pIaDFnglv4OK2x5JQRNE
         lIbA==
X-Gm-Message-State: AOAM532q1NySUbnrFofXIJJIDOFjwaBwBOTVeqC7QEZf27Sh6vpZozFo
        f9gbe2OwwnIdn/N1yol9EB25lA2HpAqVLXqZtdtyUpU1jWrM5Q==
X-Google-Smtp-Source: ABdhPJxjtb00LDV2rNHY9CDeOBp8VVAoGTticmpTULfvTnd1Pgpwq9UEA8zCqiWrjoZIj9/i4i+s32db9OPvMibVvtE=
X-Received: by 2002:a25:414f:: with SMTP id o76mr60050604yba.146.1641461163899;
 Thu, 06 Jan 2022 01:26:03 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 6 Jan 2022 14:55:53 +0530
Message-ID: <CA+G9fYvUu9+68mkCT0S8L0gL28jc5MXGQqOGH6ObciK72FbD8A@mail.gmail.com>
Subject: test_vsyscall.c:500:22: warning: '__builtin_memcmp_eq' specified
 bound 4096 exceeds source size 0
To:     linux-stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, X86 ML <x86@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While building selftests the following warnings were noticed for x86_64
architecture on Linux stable v5.15.13 kernel.

metadata:
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  git commit: 734eb1fd2073f503f5c6b44f1c0d453ca6986b84
  git describe: v5.15.13
  toolchain":  gcc-11
  kernel-config: https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/config

x86_64-linux-gnu-gcc -m64 -o \
/home/tuxbuild/.cache/tuxmake/builds/current/kselftest/x86/test_vsyscall_64 \
 -O2 -g -std=gnu99 -pthread -Wall -no-pie \
 -DCAN_BUILD_64 test_vsyscall.c helpers.h -lrt -ldl

test_vsyscall.c: In function 'test_process_vm_readv':
test_vsyscall.c:500:22: warning: '__builtin_memcmp_eq' specified bound
4096 exceeds source size 0 [-Wstringop-overread]
  500 |                 if (!memcmp(buf, (const void
*)0xffffffffff600000, 4096)) {
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build link:
https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/

# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake

tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-11 \
 --kconfig https://builds.tuxbuild.com/23HFo8abXIL6i4FFfSYiJlqAYMW/config \
 cpupower headers kernel kselftest kselftest-merge modules


--
Linaro LKFT
https://lkft.linaro.org
