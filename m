Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1EC819ABDC
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 14:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732537AbgDAMkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 08:40:43 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:32949 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732348AbgDAMkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 08:40:43 -0400
Received: by mail-qk1-f196.google.com with SMTP id v7so26825116qkc.0;
        Wed, 01 Apr 2020 05:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5D5WlOb6fY8PPPchuMxt6wwTTWk93pwGqrVmb70psZE=;
        b=B6PhY4P1o3H6vCWkDICINLnmhXpaNcwbLdsSG74t0WM+BQNQ09PuuSxzim/DpSE5Lk
         yLC6dkJnDu3gn7B1G7aNUB/4muTOk3H+VAx8zBKpvjgNzx9+Xig+0T7q7OVFrozNxVfU
         l/HZedpaErA43kty0NS6SqRoVPXEmRhhVdS7Mz7l7AYwnY254yF2+k1d0ifBYRW4ApyX
         P7tir0gQEVt01T12a7f56H288FszPpdYpwOHVyK1SjkH4TZ1hxcAhcIUR88ik8shWERD
         uRWvvmkf+SKWLFcZK1WbitA+belPTBnh5ozryCP0QX34cdz2EsnVewOVoLzPTvnjbDRc
         QObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5D5WlOb6fY8PPPchuMxt6wwTTWk93pwGqrVmb70psZE=;
        b=rvJfcDgY7MMdE0Ww8m7DEyNfw+A7uSk1YG/zU6oVFSAeFdSQpm5Bkm1o4sejdzbbqO
         8CV2NnFw6mbHNJA0cG8KnceyV1Je7guGBjjABWL7JfkDjvl28k3WYBcvdZEPobjWwdK0
         DOsndggvigngQO95w2W+0BeItO40wOR4cBTIZKoy7X0LcSYFd/KcwUr8WceHbjt4wIrH
         v6HtjkCrgxfpWBZ/lxlkbuVOIQjy0R0VbahR1gF+yjG6eVdo6uReNZCNMk9cmDi7r7Vt
         MNMf2ZPb65/nkOaYXZcNblOdB2uFzqtU7APIAp0QLaLSHPn+DmwaAlRuIDam3iS3hlbJ
         C2iA==
X-Gm-Message-State: ANhLgQ3LAPioDRO0QNYq0mY/KegOBNlb/ivrLl1/MJPpoP8iXDKRZ4zu
        +yTjrLjt5qkytwiKp/yz2PM=
X-Google-Smtp-Source: ADFU+vsNIM4PtZ/nLBCtKhPniLVbeouoyyF0HhDwYjZSRNgbZVqU6rT2FNgQOKVrNMUOwSzyHVxCAg==
X-Received: by 2002:a37:a84c:: with SMTP id r73mr10037918qke.370.1585744841383;
        Wed, 01 Apr 2020 05:40:41 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id o81sm1340836qke.24.2020.04.01.05.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 05:40:40 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 9615D409A3; Wed,  1 Apr 2020 09:40:37 -0300 (-03)
Date:   Wed, 1 Apr 2020 09:40:37 -0300
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
Message-ID: <20200401124037.GA12534@kernel.org>
References: <20200331085308.098696461@linuxfoundation.org>
 <CA+G9fYsZjmf34pQT1DeLN_DDwvxCWEkbzBfF0q2VERHb25dfZQ@mail.gmail.com>
 <CAHk-=whyW9TXfYxyxUW6hP9e0A=5MnOHrTarr4_k0hiddxq69Q@mail.gmail.com>
 <20200331192949.GN9917@kernel.org>
 <CAEUSe7_f8m0dLQT1jdU+87fNThnxMKuoGJkFuGpbT4OmpmE4iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7_f8m0dLQT1jdU+87fNThnxMKuoGJkFuGpbT4OmpmE4iA@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Tue, Mar 31, 2020 at 05:18:57PM -0600, Daniel Díaz escreveu:
> On Tue, 31 Mar 2020 at 13:29, Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:
> > Em Tue, Mar 31, 2020 at 11:20:37AM -0700, Linus Torvalds escreveu:
> > > On Tue, Mar 31, 2020 at 11:08 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > > Perf build broken on Linux next and mainline and now on stable-rc-5.6 branch.

> > > Strange. What is it that triggers the problem for you? It works fine
> > > here.. The error looks like some kind of command line quoting error,
> > > but I don't see the direct cause.

> > > Have you bisected the failure? Build failures should be particularly
> > > easy and quick to bisect.

> > Naresh, can you try with the patch below? There was some back and forth
> > about a second patch in a series and this fell thru the cracks.

> I tried that patch, did not help.
 
> Bisection led to the expected merge, "perf-urgent-for-linus", so I
> went one by one and found this commit: a7ffd416d804 ("perf python: Fix
> clang detection when using CC=clang-version"). Specifically, the line
> that fails is:
 
>   cc_is_clang = b"clang version" in Popen([cc, "-v"],
> stderr=PIPE).stderr.readline()
 
> with:
 
>   Traceback (most recent call last):
>     File "util/setup.py", line 6, in <module>
>       cc_is_clang = b"clang version" in Popen([cc, "-v"],
> stderr=PIPE).stderr.readline()
>     File "/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot-native/usr/lib/python2.7/subprocess.py",
> line 394, in __init__
>       errread, errwrite)
>     File "/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot-native/usr/lib/python2.7/subprocess.py",
> line 1047, in _execute_child
>       raise child_exception
>   OSError: [Errno 2] No such file or directory
 
> There, the value for CC is "aarch64-linaro-linux-gcc
> --sysroot=/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot".

Yeah, the assumption was that CC would be just the compiler, whatever
options needed for compiling would be in CFLAGS, so the solution should
be similar to the other patch, i.e. split CC and get the first word to
use with 'cc -v', i.e.:

  [perfbuilder@five ~]$ podman run --entrypoint=/bin/sh --rm -ti acmel/linux-perf-tools-build-ubuntu:18.04-x-arm64
  $
  [perfbuilder@five ~]$ podman run --entrypoint=/bin/bash --rm -ti acmel/linux-perf-tools-build-ubuntu:18.04-x-arm64
  perfbuilder@92dcc3ff8814:/$ python3
  Python 3.6.9 (default, Nov  7 2019, 10:44:02)
  [GCC 8.3.0] on linux
  Type "help", "copyright", "credits" or "license" for more information.
  >>> from subprocess import Popen
  >>> a = Popen(["aarch64-linux-gnu-gcc --sysroot=/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot", "-v"])
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    File "/usr/lib/python3.6/subprocess.py", line 729, in __init__
      restore_signals, start_new_session)
    File "/usr/lib/python3.6/subprocess.py", line 1364, in _execute_child
      raise child_exception_type(errno_num, err_msg, err_filename)
  FileNotFoundError: [Errno 2] No such file or directory: 'aarch64-linux-gnu-gcc --sysroot=/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot': 'aarch64-linux-gnu-gcc --sysroot=/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot'
  >>> a = Popen(["aarch64-linux-gnu-gcc --sysroot=/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot".split()[0], "-v"])
  >>> Using built-in specs.
  COLLECT_GCC=aarch64-linux-gnu-gcc
  COLLECT_LTO_WRAPPER=/usr/lib/gcc-cross/aarch64-linux-gnu/7/lto-wrapper
  Target: aarch64-linux-gnu
  Configured with: ../src/configure -v --with-pkgversion='Ubuntu/Linaro 7.5.0-3ubuntu1~18.04' --with-bugurl=file:///usr/share/doc/gcc-7/README.Bugs --enable-languages=c,ada,c++,go,d,fortran,objc,obj-c++ --prefix=/usr --with-gcc-major-version-only --program-suffix=-7 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-libquadmath --disable-libquadmath-support --enable-plugin --enable-default-pie --with-system-zlib --enable-multiarch --enable-fix-cortex-a53-843419 --disable-werror --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=aarch64-linux-gnu --program-prefix=aarch64-linux-gnu- --includedir=/usr/aarch64-linux-gnu/include
  Thread model: posix
  gcc version 7.5.0 (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04)
  
  >>>

Can you please try the one-liner at the end of this message?

> > And also, BTW, can you please send me instructions on how to get hold of
> > the toolchain you use to crossbuild perf, so that I can add it to my set
> > of test build containers?
> 
> It's an OE build, so it's bound to take quite a bit of space. I'll try
> to get something dockerized so that it's easier to replicate.

Thanks a lot!
 
- Arnaldo

From 2a88ba6ddf54a4340f5a5f896705d5e42561e210 Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Wed, 1 Apr 2020 09:33:59 -0300
Subject: [PATCH 1/1] perf python: Fix clang detection to strip out options
 passed in $CC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The clang check in the python setup.py file expected $CC to be just the
name of the compiler, not the compiler + options, i.e. all options were
expected to be passed in $CFLAGS, this ends up making it fail in systems
where CC is set to, e.g.:

 "aarch64-linaro-linux-gcc --sysroot=/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot"

Like this:

  $ python3
  >>> from subprocess import Popen
  >>> a = Popen(["aarch64-linux-gnu-gcc --sysroot=/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot", "-v"])
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
    File "/usr/lib/python3.6/subprocess.py", line 729, in __init__
      restore_signals, start_new_session)
    File "/usr/lib/python3.6/subprocess.py", line 1364, in _execute_child
      raise child_exception_type(errno_num, err_msg, err_filename)
  FileNotFoundError: [Errno 2] No such file or directory: 'aarch64-linux-gnu-gcc --sysroot=/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot': 'aarch64-linux-gnu-gcc --sysroot=/oe/build/tmp/work/juno-linaro-linux/perf/1.0-r9/recipe-sysroot'
  >>>

Make it more robust, covering this case, by passing cc.split()[0] as the
first arg to popen().

Reported-by: Daniel Díaz <daniel.diaz@linaro.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/setup.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 8a065a6f9713..347b2c0789e4 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -3,7 +3,7 @@ from subprocess import Popen, PIPE
 from re import sub
 
 cc = getenv("CC")
-cc_is_clang = b"clang version" in Popen([cc, "-v"], stderr=PIPE).stderr.readline()
+cc_is_clang = b"clang version" in Popen([cc.split()[0], "-v"], stderr=PIPE).stderr.readline()
 
 def clang_has_option(option):
     return [o for o in Popen([cc, option], stderr=PIPE).stderr.readlines() if b"unknown argument" in o] == [ ]
-- 
2.21.1

