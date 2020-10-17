Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D010291115
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 11:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411495AbgJQJsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 05:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410334AbgJQJsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 05:48:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3787206CB;
        Sat, 17 Oct 2020 09:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602928133;
        bh=kVPGSawdTzm6fxKGp6WkH3lpLhOH3m5i432ozWjMbiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZGCXXWfjJvYw7tQUy31lZMspPSCudYKHDRxBfVaFL4a0DugWDo+GdJImMGw0sIOh6
         kAO2jIbukkDRdE65afibp+iuJKdKNAKXjLBA760DhMP+upBUwTwBQiteyPeP+nn+Eb
         6O6Uy/YefF9shML7p/XOFA6E7Y/TAgdjffLgYt6I=
Date:   Sat, 17 Oct 2020 11:49:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/21] 4.19.152-rc1 review
Message-ID: <20201017094943.GA1356372@kroah.com>
References: <20201016090437.301376476@linuxfoundation.org>
 <20201016190151.GD32893@roeck-us.net>
 <20201017094153.GA190870@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201017094153.GA190870@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 17, 2020 at 11:41:53AM +0200, Salvatore Bonaccorso wrote:
> hi,
>=20
> On Fri, Oct 16, 2020 at 12:01:51PM -0700, Guenter Roeck wrote:
> > On Fri, Oct 16, 2020 at 11:07:19AM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.152 release.
> > > There are 21 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> > > Anything received after that time might be too late.
> > >=20
> >=20
> > Build results:
> > 	total: 155 pass: 153 fail: 2
> > Failed builds:
> > 	i386:tools/perf
> > 	x86_64:tools/perf
>=20
> I'm seeing the tools/perf failure as well:
>=20
>   gcc -Wp,-MD,/home/build/linux-4.19.152/debian/build/build-tools/tools/p=
erf/util/intel-pt-decoder/.intel-pt-insn-decoder.o.d -Wp,-MT,/home/build/li=
nux-4.19.152/debian/build/build-tools/tools/perf/util/intel-pt-decoder/inte=
l-pt-insn-decoder.o -g -O2 -fstack-protector-strong -Wformat -Werror=3Dform=
at-security -Wall -Wdate-time -D_FORTIFY_SOURCE=3D2 -I/home/build/linux-4.1=
9.152/tools/perf -I/home/build/linux-4.19.152/debian/build/build-tools/tool=
s/perf -isystem /home/build/linux-4.19.152/debian/build/build-tools/include=
 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wform=
at-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-ext=
erns -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls =
-Wshadow -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite=
-strings -Wformat -Wstrict-aliasing=3D3 -DHAVE_ARCH_X86_64_SUPPORT -I/home/=
build/linux-4.19.152/debian/build/build-tools/tools/perf/arch/x86/include/g=
enerated -DHAVE_SYSCALL_TABLE_SUPPORT -DHAVE_PERF_REGS_SUPPORT -DHAVE_ARCH_=
REGS_QUERY_REGISTER_OFFSET -O6 -fno-omit-frame-pointer -ggdb3 -funwind-tabl=
es -Wall -Wextra -std=3Dgnu99 -fstack-protector-all -D_FORTIFY_SOURCE=3D2 -=
I/home/build/linux-4.19.152/tools/perf/util/include -I/home/build/linux-4.1=
9.152/tools/perf/arch/x86/include -I/home/build/linux-4.19.152/tools/includ=
e/uapi -I/home/build/linux-4.19.152/tools/include/ -I/home/build/linux-4.19=
=2E152/tools/arch/x86/include/uapi -I/home/build/linux-4.19.152/tools/arch/=
x86/include/ -I/home/build/linux-4.19.152/tools/arch/x86/ -I/home/build/lin=
ux-4.19.152/debian/build/build-tools/tools/perf//util -I/home/build/linux-4=
=2E19.152/debian/build/build-tools/tools/perf/ -I/home/build/linux-4.19.152=
/tools/perf/util -I/home/build/linux-4.19.152/tools/perf -I/home/build/linu=
x-4.19.152/tools/lib/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_GNU=
_SOURCE -DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT -DHAVE_PTHREAD_ATTR_SETAFFINIT=
Y_NP -DHAVE_PTHREAD_BARRIER -DHAVE_DWARF_GETLOCATIONS_SUPPORT -DHAVE_GLIBC_=
SUPPORT -DHAVE_SCHED_GETCPU_SUPPORT -DHAVE_SETNS_SUPPORT -DHAVE_CSTRACE_SUP=
PORT -DHAVE_LIBELF_SUPPORT -DHAVE_LIBELF_MMAP_SUPPORT -DHAVE_ELF_GETPHDRNUM=
_SUPPORT -DHAVE_GELF_GETNOTE_SUPPORT -DHAVE_ELF_GETSHDRSTRNDX_SUPPORT -DHAV=
E_DWARF_SUPPORT -DHAVE_LIBBPF_SUPPORT -DHAVE_BPF_PROLOGUE -DHAVE_JITDUMP -D=
HAVE_DWARF_UNWIND_SUPPORT -DNO_LIBUNWIND_DEBUG_FRAME -DHAVE_LIBUNWIND_SUPPO=
RT -I/usr/include/slang -DHAVE_SLANG_SUPPORT -DHAVE_LIBPERL_SUPPORT -DHAVE_=
TIMERFD_SUPPORT -DHAVE_LIBPYTHON_SUPPORT -DHAVE_CPLUS_DEMANGLE_SUPPORT -DHA=
VE_ZLIB_SUPPORT -DHAVE_LZMA_SUPPORT -DHAVE_BACKTRACE_SUPPORT -DHAVE_LIBNUMA=
_SUPPORT -DHAVE_KVM_STAT_SUPPORT -DHAVE_PERF_READ_VDSO32 -DHAVE_PERF_READ_V=
DSOX32 -DHAVE_LIBBABELTRACE_SUPPORT -DHAVE_AUXTRACE_SUPPORT -I/home/build/l=
inux-4.19.152/debian/build/build-tools/tools/perf/ -D"BUILD_STR(s)=3D#s" -I=
/home/build/linux-4.19.152/debian/build/build-tools/tools/perf/util/intel-p=
t-decoder -c -o /home/build/linux-4.19.152/debian/build/build-tools/tools/p=
erf/util/intel-pt-decoder/intel-pt-insn-decoder.o util/intel-pt-decoder/int=
el-pt-insn-decoder.c
> util/cs-etm-decoder/cs-etm-decoder.c: In function 'cs_etm_decoder__buffer=
_packet':
> util/cs-etm-decoder/cs-etm-decoder.c:287:24: error: 'traceid_list' undecl=
ared (first use in this function); did you mean 'trace_event'?
>   inode =3D intlist__find(traceid_list, trace_chan_id);
>                         ^~~~~~~~~~~~
>                         trace_event
> util/cs-etm-decoder/cs-etm-decoder.c:287:24: note: each undeclared identi=
fier is reported only once for each function it appears in
> make[8]: *** [/home/build/linux-4.19.152/tools/build/Makefile.build:97: /=
home/build/linux-4.19.152/debian/build/build-tools/tools/perf/util/cs-etm-d=
ecoder/cs-etm-decoder.o] Error 1
> make[8]: Leaving directory '/home/build/linux-4.19.152/tools/perf'
> make[7]: *** [/home/build/linux-4.19.152/tools/build/Makefile.build:139: =
cs-etm-decoder] Error 2

Yeah, it's a mess, and I tried to unwind it, but it was not a simple
fix.

If people still care about building perf on 4.19 with newer gcc
releases, I'll gladly take backports of the needed patches for this.

thanks,

greg k-h
