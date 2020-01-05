Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C57B130943
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 18:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgAERBN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 5 Jan 2020 12:01:13 -0500
Received: from mail-ot1-f49.google.com ([209.85.210.49]:35383 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgAERBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 12:01:12 -0500
Received: by mail-ot1-f49.google.com with SMTP id i15so613595oto.2;
        Sun, 05 Jan 2020 09:01:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pImI0pMnPTGnff6kUft8PijJl8eQvtSKHYBARbvH43Q=;
        b=NIfI4R7weyyCJ/x/0sVoBV/biORA4X+scJMm1FFj3+HJRr5TGdMJAaisYkpw0kTSZV
         YknRUdMYXkwNg4/3k6i5GJAPnqx/gPFzijj5EJc3wYqXGjV7e1pQsCU84Qn2yE6gj8eO
         dJoTARZV2R9cLITdEB2VjZQqnuuxwugeMQRHcY6ZNlYt7k2JOgRUbnGFJ22sJKQ9JreC
         yjFTWSycV5W9cXZKBIr1pdggSFmCgCSgT/McaOhVjVnU23jGYml8b5NxZCRb63rNddYQ
         gc36Qh4rmg/WzCi/YGFjzx4qekesjmOdaMkjLWHL4L4u0p20Jg56W2Yo0RQ6ERcZxRXv
         sz1g==
X-Gm-Message-State: APjAAAWu0Ip8TsVBrSMBDFJlb9FUUmkaWYAkqdipHgi3spYKfADxX8+o
        tnAksb9kq0z1YkROH9ia4aQMgGOG47I=
X-Google-Smtp-Source: APXvYqybrK1QpYTvw+QQIPHbG20EngK6S3l+gDPJoUNPHNKPNRhBNJavl6bhSyjJj7yTpomd5ONNIA==
X-Received: by 2002:a9d:67c1:: with SMTP id c1mr76255422otn.161.1578243671683;
        Sun, 05 Jan 2020 09:01:11 -0800 (PST)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.googlemail.com with ESMTPSA id v25sm22958792otk.51.2020.01.05.09.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2020 09:01:11 -0800 (PST)
Received: by mail-ot1-f46.google.com with SMTP id r27so68259940otc.8;
        Sun, 05 Jan 2020 09:01:11 -0800 (PST)
X-Received: by 2002:a9d:65cb:: with SMTP id z11mr87893641oth.348.1578243671217;
 Sun, 05 Jan 2020 09:01:11 -0800 (PST)
MIME-Version: 1.0
References: <CAMx4oe38RytiyqWfYb=So8iC6N=8nebqy3DsekiT7A5DGjpe+w@mail.gmail.com>
In-Reply-To: <CAMx4oe38RytiyqWfYb=So8iC6N=8nebqy3DsekiT7A5DGjpe+w@mail.gmail.com>
From:   Gordan Bobic <gordan@redsleeve.org>
Date:   Sun, 5 Jan 2020 17:01:00 +0000
X-Gmail-Original-Message-ID: <CAMx4oe2JKTsOKg3P324PYRH=0ajOVDaXTLa7p=16Fo9fGiQSpQ@mail.gmail.com>
Message-ID: <CAMx4oe2JKTsOKg3P324PYRH=0ajOVDaXTLa7p=16Fo9fGiQSpQ@mail.gmail.com>
Subject: Re: 4.9.208 regression in perf building
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It looks like 4.9.208 introduces a build regression for perf:

make -f /builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/build/Makefile.build
dir=. obj=perf
  gcc -Wp,-MD,./.builtin-report.o.d,-MT,builtin-report.o
-Wbad-function-cast -Wdeclaration-after-statement -Wformat-security
-Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes
-Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked
-Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes
-Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat
-DHAVE_ARCH_X86_64_SUPPORT -DHAVE_SYSCALL_TABLE
-Iarch/x86/include/generated -DHAVE_PERF_REGS_SUPPORT
-DHAVE_ARCH_REGS_QUERY_REGISTER_OFFSET -O6 -fno-omit-frame-pointer
-ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -fstack-protector-all
-D_FORTIFY_SOURCE=2
-I/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/perf/util/include
-I/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/perf/arch/x86/include
-I/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/include/uapi
-I/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/include/
-I/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/arch/x86/include/uapi
-I/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/arch/x86/include/
-I/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/arch/x86/
-I/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/perf/util
-I/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/perf
-I/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/lib/
-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
-DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT
-DHAVE_PTHREAD_ATTR_SETAFFINITY_NP -DHAVE_DWARF_GETLOCATIONS
-DHAVE_LIBELF_SUPPORT -DHAVE_LIBELF_MMAP_SUPPORT
-DHAVE_ELF_GETPHDRNUM_SUPPORT -DHAVE_GELF_GETNOTE_SUPPORT
-DHAVE_ELF_GETSHDRSTRNDX_SUPPORT -DHAVE_DWARF_SUPPORT
-DHAVE_LIBBPF_SUPPORT -DHAVE_BPF_PROLOGUE -DHAVE_SDT_EVENT
-DHAVE_JITDUMP -DHAVE_DWARF_UNWIND_SUPPORT -DHAVE_LIBAUDIT_SUPPORT
-DHAVE_LIBCRYPTO_SUPPORT -I/usr/include/slang -DHAVE_SLANG_SUPPORT
-DHAVE_TIMERFD_SUPPORT -DHAVE_LIBBFD_SUPPORT -DHAVE_ZLIB_SUPPORT
-DHAVE_LZMA_SUPPORT -DHAVE_BACKTRACE_SUPPORT -DHAVE_LIBNUMA_SUPPORT
-DHAVE_KVM_STAT_SUPPORT -DHAVE_AUXTRACE_SUPPORT -D"BUILD_STR(s)=#s"
-DTIPDIR="BUILD_STR(share/doc/perf-tip)"
-DDOCDIR="BUILD_STR(/builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/perf/Documentation)"
 -c -o builtin-report.o builtin-report.c
builtin-report.c: In function ‘report__setup_sample_type’:
builtin-report.c:296:6: error: ‘dwarf_callchain_users’ undeclared
(first use in this function)
  if (dwarf_callchain_users) {
      ^
builtin-report.c:296:6: note: each undeclared identifier is reported
only once for each function it appears in
mv: cannot stat ‘./.builtin-report.o.tmp’: No such file or directory
make[3]: *** [builtin-report.o] Error 1
make[2]: *** [perf-in.o] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

4,9.207 works fine.
