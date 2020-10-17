Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13166291190
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 13:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411792AbgJQLLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 07:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411788AbgJQLLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 07:11:16 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565E0C061755;
        Sat, 17 Oct 2020 04:11:16 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j136so8098840wmj.2;
        Sat, 17 Oct 2020 04:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Pm5lcM7xCMgydOKeCL0HJ7IwwbAf9QYQ2Zi7aqPQeB4=;
        b=EgZGKwhiwTox00z4tbgYo/hOr6ERqvzrhWbqjlRPNJtbL/mFJpcty5lW1e4Fe4hv9G
         jk/UHASmPO07WOKrMnHK5iXN4TL853vqSYwaLGUcxwmjVFOa2l2HBF4UwIr9JU847wP4
         QWRE2u5NBlV2KMFQKBeUWclaDXBck+/eeZISR6RdWSpFAR2g+LUvRpI5jbH40cGwysBc
         z/RrQ6oEU7bSC/gIatfmxmVlORyevmIT5SvfRHEFWh+AB5V7IOiWOWPQpI2kUnhG68JI
         o2yo9qQzDHLKdzP+8zRMfl+WFxA349DF29lYzge5HjSLxCizVU1Cpqu7etl+uBedrmib
         jW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=Pm5lcM7xCMgydOKeCL0HJ7IwwbAf9QYQ2Zi7aqPQeB4=;
        b=r4CeSUtoR0yYbULO7l2/4K27sWPGsgmSCx6oPCXQIXnJCrbpM804m/tOJ9yEcCsnJD
         648i8j/gfseaKZO1V9vopYzUkp8KkI2S86C6itY67SHR0/ZYDx4A05MVr2YdL7gbA62f
         oHXR6fJCDbEw/4NgW12nxJUvbVBtPCc89buekYydqQqKFDL+vbr/vsIXIJuRvDm9Ap1Y
         mfVg/CTcifer9cSP04Ticq8k/B/ftQr/tGYLsYnWMwU+sOOo/M0Fh35FKb7ZuOuKT6ym
         Ak8K+a20d/PuLKnuSihHKQLoN00BV5Oa6PjDPAvf4Q92ijv1RO6azQNQWYhi8J4DDKBV
         g98Q==
X-Gm-Message-State: AOAM532KuflUtbSqdfrIQqzoYinbgsHwXCPcicmpUZ7RvOHi/1DZhkEm
        V5VHzmRiUIJ+jPqTI16STjjavZ/KVE3JuQ==
X-Google-Smtp-Source: ABdhPJwVlGhBzuaAf9bfzkWPNzbnroeZoEo1Iie93AWfzV2m0i/NKOx4M5ZX5OImN9ZHtiK1uvxxPw==
X-Received: by 2002:a1c:e919:: with SMTP id q25mr7994790wmc.142.1602933074755;
        Sat, 17 Oct 2020 04:11:14 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id b63sm7356305wme.9.2020.10.17.04.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 04:11:12 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 17 Oct 2020 13:11:11 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/21] 4.19.152-rc1 review
Message-ID: <20201017111111.GA206185@eldamar.lan>
References: <20201016090437.301376476@linuxfoundation.org>
 <20201016190151.GD32893@roeck-us.net>
 <20201017094153.GA190870@eldamar.lan>
 <20201017094943.GA1356372@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201017094943.GA1356372@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Oct 17, 2020 at 11:49:43AM +0200, Greg Kroah-Hartman wrote:
> On Sat, Oct 17, 2020 at 11:41:53AM +0200, Salvatore Bonaccorso wrote:
> > hi,
> >=20
> > On Fri, Oct 16, 2020 at 12:01:51PM -0700, Guenter Roeck wrote:
> > > On Fri, Oct 16, 2020 at 11:07:19AM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.19.152 relea=
se.
> > > > There are 21 patches in this series, all will be posted as a respon=
se
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >=20
> > > > Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> > > > Anything received after that time might be too late.
> > > >=20
> > >=20
> > > Build results:
> > > 	total: 155 pass: 153 fail: 2
> > > Failed builds:
> > > 	i386:tools/perf
> > > 	x86_64:tools/perf
> >=20
> > I'm seeing the tools/perf failure as well:
> >=20
> >   gcc -Wp,-MD,/home/build/linux-4.19.152/debian/build/build-tools/tools=
/perf/util/intel-pt-decoder/.intel-pt-insn-decoder.o.d -Wp,-MT,/home/build/=
linux-4.19.152/debian/build/build-tools/tools/perf/util/intel-pt-decoder/in=
tel-pt-insn-decoder.o -g -O2 -fstack-protector-strong -Wformat -Werror=3Dfo=
rmat-security -Wall -Wdate-time -D_FORTIFY_SOURCE=3D2 -I/home/build/linux-4=
=2E19.152/tools/perf -I/home/build/linux-4.19.152/debian/build/build-tools/=
tools/perf -isystem /home/build/linux-4.19.152/debian/build/build-tools/inc=
lude -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -W=
format-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested=
-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-de=
cls -Wshadow -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Ww=
rite-strings -Wformat -Wstrict-aliasing=3D3 -DHAVE_ARCH_X86_64_SUPPORT -I/h=
ome/build/linux-4.19.152/debian/build/build-tools/tools/perf/arch/x86/inclu=
de/generated -DHAVE_SYSCALL_TABLE_SUPPORT -DHAVE_PERF_REGS_SUPPORT -DHAVE_A=
RCH_REGS_QUERY_REGISTER_OFFSET -O6 -fno-omit-frame-pointer -ggdb3 -funwind-=
tables -Wall -Wextra -std=3Dgnu99 -fstack-protector-all -D_FORTIFY_SOURCE=
=3D2 -I/home/build/linux-4.19.152/tools/perf/util/include -I/home/build/lin=
ux-4.19.152/tools/perf/arch/x86/include -I/home/build/linux-4.19.152/tools/=
include/uapi -I/home/build/linux-4.19.152/tools/include/ -I/home/build/linu=
x-4.19.152/tools/arch/x86/include/uapi -I/home/build/linux-4.19.152/tools/a=
rch/x86/include/ -I/home/build/linux-4.19.152/tools/arch/x86/ -I/home/build=
/linux-4.19.152/debian/build/build-tools/tools/perf//util -I/home/build/lin=
ux-4.19.152/debian/build/build-tools/tools/perf/ -I/home/build/linux-4.19.1=
52/tools/perf/util -I/home/build/linux-4.19.152/tools/perf -I/home/build/li=
nux-4.19.152/tools/lib/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_G=
NU_SOURCE -DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT -DHAVE_PTHREAD_ATTR_SETAFFIN=
ITY_NP -DHAVE_PTHREAD_BARRIER -DHAVE_DWARF_GETLOCATIONS_SUPPORT -DHAVE_GLIB=
C_SUPPORT -DHAVE_SCHED_GETCPU_SUPPORT -DHAVE_SETNS_SUPPORT -DHAVE_CSTRACE_S=
UPPORT -DHAVE_LIBELF_SUPPORT -DHAVE_LIBELF_MMAP_SUPPORT -DHAVE_ELF_GETPHDRN=
UM_SUPPORT -DHAVE_GELF_GETNOTE_SUPPORT -DHAVE_ELF_GETSHDRSTRNDX_SUPPORT -DH=
AVE_DWARF_SUPPORT -DHAVE_LIBBPF_SUPPORT -DHAVE_BPF_PROLOGUE -DHAVE_JITDUMP =
-DHAVE_DWARF_UNWIND_SUPPORT -DNO_LIBUNWIND_DEBUG_FRAME -DHAVE_LIBUNWIND_SUP=
PORT -I/usr/include/slang -DHAVE_SLANG_SUPPORT -DHAVE_LIBPERL_SUPPORT -DHAV=
E_TIMERFD_SUPPORT -DHAVE_LIBPYTHON_SUPPORT -DHAVE_CPLUS_DEMANGLE_SUPPORT -D=
HAVE_ZLIB_SUPPORT -DHAVE_LZMA_SUPPORT -DHAVE_BACKTRACE_SUPPORT -DHAVE_LIBNU=
MA_SUPPORT -DHAVE_KVM_STAT_SUPPORT -DHAVE_PERF_READ_VDSO32 -DHAVE_PERF_READ=
_VDSOX32 -DHAVE_LIBBABELTRACE_SUPPORT -DHAVE_AUXTRACE_SUPPORT -I/home/build=
/linux-4.19.152/debian/build/build-tools/tools/perf/ -D"BUILD_STR(s)=3D#s" =
-I/home/build/linux-4.19.152/debian/build/build-tools/tools/perf/util/intel=
-pt-decoder -c -o /home/build/linux-4.19.152/debian/build/build-tools/tools=
/perf/util/intel-pt-decoder/intel-pt-insn-decoder.o util/intel-pt-decoder/i=
ntel-pt-insn-decoder.c
> > util/cs-etm-decoder/cs-etm-decoder.c: In function 'cs_etm_decoder__buff=
er_packet':
> > util/cs-etm-decoder/cs-etm-decoder.c:287:24: error: 'traceid_list' unde=
clared (first use in this function); did you mean 'trace_event'?
> >   inode =3D intlist__find(traceid_list, trace_chan_id);
> >                         ^~~~~~~~~~~~
> >                         trace_event
> > util/cs-etm-decoder/cs-etm-decoder.c:287:24: note: each undeclared iden=
tifier is reported only once for each function it appears in
> > make[8]: *** [/home/build/linux-4.19.152/tools/build/Makefile.build:97:=
 /home/build/linux-4.19.152/debian/build/build-tools/tools/perf/util/cs-etm=
-decoder/cs-etm-decoder.o] Error 1
> > make[8]: Leaving directory '/home/build/linux-4.19.152/tools/perf'
> > make[7]: *** [/home/build/linux-4.19.152/tools/build/Makefile.build:139=
: cs-etm-decoder] Error 2
>=20
> Yeah, it's a mess, and I tried to unwind it, but it was not a simple
> fix.
>=20
> If people still care about building perf on 4.19 with newer gcc
> releases, I'll gladly take backports of the needed patches for this.

Ack! For the build of 4.19.152 in Debian we will for now just revert
"perf cs-etm: Move definition of 'traceid_list' global variable from
header file" again.

Regards,
Salvatore
