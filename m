Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DE7291109
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 11:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437805AbgJQJl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 05:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437804AbgJQJl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 05:41:58 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD64C061755;
        Sat, 17 Oct 2020 02:41:57 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id n6so6081233wrm.13;
        Sat, 17 Oct 2020 02:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=frj0hMFswhbwKQy9gVoCGXX1iV/P0S0K6hJFq4KVoTo=;
        b=TWVzqB+S39pbBrAm/OWQgg30FTxoDU1D4EJ5Y9O7LdddDcdOfJQ1t03ZkVGPBr3JOh
         5cZx8plYMYy7E1Qy4RaOTjhU5oItxUvDCA/msiHU1OF+wyX+pwNSVPWwBH/AapIIHAbs
         5KWo0WhVD/5GbdDHX3sySaI85x5t2Lf14lF+s4urLIG7SFjG7CRGAlp7s+6BXgLF+aaX
         dHnKfne4lOBv2mVSwRoR5OQYBvhtuNhENX2aKetM/5C6qnmpQnutgU+38iMcLp1XDOX8
         SCz8vW6xX7exopQiM/J5ngYSRvylLk7lcY60o2lOEpprd8RCvjOaPlx2pGyunzYzT/gS
         z+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=frj0hMFswhbwKQy9gVoCGXX1iV/P0S0K6hJFq4KVoTo=;
        b=e4ZNP1HHYBUbKU3DC2G+2gLVLRfW3FtSB4bIjAIOwZIshz/IaUW5Jw5yybbkD5ctff
         56f46cAECMQojQl+aYB1Kfr3lJGeOl7M57jgTD75SxYgkIttqyPevUGbgQANiWTDhh3m
         C/KbmzHZ4aWn5tDmjwCzhs7IVRN+TDWcp0uGRTKbkFsG6gIkJGBHs/XQawNVK4iWI5Mw
         8CZMA1OimSLGrVJLz5HAW+WvoTwmHivlyLsspgCxIf2cnv7XWBoKG5mAWZXlxyIuaCiT
         M4uAdSjKNg9u93AJ+sNf9vUUgTmGC2c0RNZCGWdlomf5m+UqYCcGnNvDsNLPUEyhXsJr
         igLw==
X-Gm-Message-State: AOAM533BdQL5u12/rXPknZREg+saN4NTZ0gYWLDWpppxwoKDiLJkTfsH
        Qv//Ggcaj6P+75AlraU1DiMXZJP23v+9TA==
X-Google-Smtp-Source: ABdhPJzHTG2zC/Q/xApv2cmsdqWeZ+LtcWxn6QoyYImE1WM1PF+6M7wyXlerRktf4GEVW3sxnRSYXw==
X-Received: by 2002:a5d:4691:: with SMTP id u17mr9350589wrq.324.1602927714839;
        Sat, 17 Oct 2020 02:41:54 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id a3sm6337871wmb.46.2020.10.17.02.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 02:41:53 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 17 Oct 2020 11:41:53 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/21] 4.19.152-rc1 review
Message-ID: <20201017094153.GA190870@eldamar.lan>
References: <20201016090437.301376476@linuxfoundation.org>
 <20201016190151.GD32893@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201016190151.GD32893@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hi,

On Fri, Oct 16, 2020 at 12:01:51PM -0700, Guenter Roeck wrote:
> On Fri, Oct 16, 2020 at 11:07:19AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.152 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> > Anything received after that time might be too late.
> >=20
>=20
> Build results:
> 	total: 155 pass: 153 fail: 2
> Failed builds:
> 	i386:tools/perf
> 	x86_64:tools/perf

I'm seeing the tools/perf failure as well:

  gcc -Wp,-MD,/home/build/linux-4.19.152/debian/build/build-tools/tools/per=
f/util/intel-pt-decoder/.intel-pt-insn-decoder.o.d -Wp,-MT,/home/build/linu=
x-4.19.152/debian/build/build-tools/tools/perf/util/intel-pt-decoder/intel-=
pt-insn-decoder.o -g -O2 -fstack-protector-strong -Wformat -Werror=3Dformat=
-security -Wall -Wdate-time -D_FORTIFY_SOURCE=3D2 -I/home/build/linux-4.19.=
152/tools/perf -I/home/build/linux-4.19.152/debian/build/build-tools/tools/=
perf -isystem /home/build/linux-4.19.152/debian/build/build-tools/include -=
Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat=
-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-exter=
ns -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -W=
shadow -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-s=
trings -Wformat -Wstrict-aliasing=3D3 -DHAVE_ARCH_X86_64_SUPPORT -I/home/bu=
ild/linux-4.19.152/debian/build/build-tools/tools/perf/arch/x86/include/gen=
erated -DHAVE_SYSCALL_TABLE_SUPPORT -DHAVE_PERF_REGS_SUPPORT -DHAVE_ARCH_RE=
GS_QUERY_REGISTER_OFFSET -O6 -fno-omit-frame-pointer -ggdb3 -funwind-tables=
 -Wall -Wextra -std=3Dgnu99 -fstack-protector-all -D_FORTIFY_SOURCE=3D2 -I/=
home/build/linux-4.19.152/tools/perf/util/include -I/home/build/linux-4.19.=
152/tools/perf/arch/x86/include -I/home/build/linux-4.19.152/tools/include/=
uapi -I/home/build/linux-4.19.152/tools/include/ -I/home/build/linux-4.19.1=
52/tools/arch/x86/include/uapi -I/home/build/linux-4.19.152/tools/arch/x86/=
include/ -I/home/build/linux-4.19.152/tools/arch/x86/ -I/home/build/linux-4=
=2E19.152/debian/build/build-tools/tools/perf//util -I/home/build/linux-4.1=
9.152/debian/build/build-tools/tools/perf/ -I/home/build/linux-4.19.152/too=
ls/perf/util -I/home/build/linux-4.19.152/tools/perf -I/home/build/linux-4.=
19.152/tools/lib/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOU=
RCE -DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT -DHAVE_PTHREAD_ATTR_SETAFFINITY_NP=
 -DHAVE_PTHREAD_BARRIER -DHAVE_DWARF_GETLOCATIONS_SUPPORT -DHAVE_GLIBC_SUPP=
ORT -DHAVE_SCHED_GETCPU_SUPPORT -DHAVE_SETNS_SUPPORT -DHAVE_CSTRACE_SUPPORT=
 -DHAVE_LIBELF_SUPPORT -DHAVE_LIBELF_MMAP_SUPPORT -DHAVE_ELF_GETPHDRNUM_SUP=
PORT -DHAVE_GELF_GETNOTE_SUPPORT -DHAVE_ELF_GETSHDRSTRNDX_SUPPORT -DHAVE_DW=
ARF_SUPPORT -DHAVE_LIBBPF_SUPPORT -DHAVE_BPF_PROLOGUE -DHAVE_JITDUMP -DHAVE=
_DWARF_UNWIND_SUPPORT -DNO_LIBUNWIND_DEBUG_FRAME -DHAVE_LIBUNWIND_SUPPORT -=
I/usr/include/slang -DHAVE_SLANG_SUPPORT -DHAVE_LIBPERL_SUPPORT -DHAVE_TIME=
RFD_SUPPORT -DHAVE_LIBPYTHON_SUPPORT -DHAVE_CPLUS_DEMANGLE_SUPPORT -DHAVE_Z=
LIB_SUPPORT -DHAVE_LZMA_SUPPORT -DHAVE_BACKTRACE_SUPPORT -DHAVE_LIBNUMA_SUP=
PORT -DHAVE_KVM_STAT_SUPPORT -DHAVE_PERF_READ_VDSO32 -DHAVE_PERF_READ_VDSOX=
32 -DHAVE_LIBBABELTRACE_SUPPORT -DHAVE_AUXTRACE_SUPPORT -I/home/build/linux=
-4.19.152/debian/build/build-tools/tools/perf/ -D"BUILD_STR(s)=3D#s" -I/hom=
e/build/linux-4.19.152/debian/build/build-tools/tools/perf/util/intel-pt-de=
coder -c -o /home/build/linux-4.19.152/debian/build/build-tools/tools/perf/=
util/intel-pt-decoder/intel-pt-insn-decoder.o util/intel-pt-decoder/intel-p=
t-insn-decoder.c
util/cs-etm-decoder/cs-etm-decoder.c: In function 'cs_etm_decoder__buffer_p=
acket':
util/cs-etm-decoder/cs-etm-decoder.c:287:24: error: 'traceid_list' undeclar=
ed (first use in this function); did you mean 'trace_event'?
  inode =3D intlist__find(traceid_list, trace_chan_id);
                        ^~~~~~~~~~~~
                        trace_event
util/cs-etm-decoder/cs-etm-decoder.c:287:24: note: each undeclared identifi=
er is reported only once for each function it appears in
make[8]: *** [/home/build/linux-4.19.152/tools/build/Makefile.build:97: /ho=
me/build/linux-4.19.152/debian/build/build-tools/tools/perf/util/cs-etm-dec=
oder/cs-etm-decoder.o] Error 1
make[8]: Leaving directory '/home/build/linux-4.19.152/tools/perf'
make[7]: *** [/home/build/linux-4.19.152/tools/build/Makefile.build:139: cs=
-etm-decoder] Error 2

Regards,
Salvatore
