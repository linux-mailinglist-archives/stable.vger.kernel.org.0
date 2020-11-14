Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634902B2C25
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 09:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgKNIfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 03:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgKNIfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 03:35:06 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BA7C0613D1;
        Sat, 14 Nov 2020 00:35:05 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id r17so12914221wrw.1;
        Sat, 14 Nov 2020 00:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=V4uVH/qVYLEvup0G3E3Qtkaer2TCC4UFRFl7fBwGs6Y=;
        b=pDJCdu2qiR1PowiYneUprRwTwnE5PYucuEJcT0abMgMlqqVYD99jlVKB9FutrgHhWp
         qofF56PBj/gkph7aw6oGW+EurE1tOUiUJcKw5spbZfdZIS/HunXMqiw/lNlMTss3HUWt
         aHie1iuxB3kvYD66Bi88Zh9VK7fwT1WZR3J8niU3YKnvr8ug+XiB7nODm4mlZ7fy6Dn6
         /Qhc5vYleutoRrQsUtxJ4MPRcUWkCFIMS66u8tMUCyjIqgiMjLnBqv9dY+yHSGqnhJsI
         TTWKZpKR36c6MNMsMVFW0qYUK1omIMy3XJZGJgtOz4ktUuKv6ET/DVOr1uNtRghAHKhS
         LbVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=V4uVH/qVYLEvup0G3E3Qtkaer2TCC4UFRFl7fBwGs6Y=;
        b=tK50l75dCDvYLBugHW+tP1CMTl14HCTFU59KAfJRbisTxJY5+uEu5eaxoDhdDbR23g
         np742YeZYHX668hTu9LPh9Q8E9pKH6BEw+0pNLx7A5VAK68OyarGO0e/U3EZjSLkzYOA
         BcIEXOb/yxXIVJsU78Nq/+7Ex3fF3Ie8wOe+4KsAs1DNoSeM17CcRR3ifiYevQHWVUMW
         +bLpcL5MrnyulpMaoLUXokCVRlvsEz8+09VD1CCUhDvLItqUXOC9z3EKUEu7SSEQqc2v
         dtsk91n+My0ObZ1VvbxfZw4q5vuRoTNErtXfhjIQK0vGI9Jsxyz31/fjkB0AFMaG/bj3
         No0g==
X-Gm-Message-State: AOAM5305nK+A43MmHWgQvD98yddDaKti8Q/TnncfD3DIasChM7db49PV
        f3JoFCNsmq7+QmWwqRTt7+MHg2DFQ/haMw==
X-Google-Smtp-Source: ABdhPJyQ21GoHW5+kjqrNLDwrNzOOkcqh+XK1ELp6ElIOK7aMfbYjo/+s0S0gOmvCTzwPo7Zouws6Q==
X-Received: by 2002:adf:f3d2:: with SMTP id g18mr8837364wrp.77.1605342903701;
        Sat, 14 Nov 2020 00:35:03 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id f18sm883403wru.42.2020.11.14.00.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 00:35:02 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 14 Nov 2020 09:35:01 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
Message-ID: <20201114083501.GA468764@eldamar.lan>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201028171035.GD118534@roeck-us.net>
 <20201028195619.GC124982@roeck-us.net>
 <20201031094500.GA271135@eldamar.lan>
 <7608060e-f48b-1a7c-1a92-9c41d81d9a40@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7608060e-f48b-1a7c-1a92-9c41d81d9a40@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guenter,

On Sat, Oct 31, 2020 at 07:31:32AM -0700, Guenter Roeck wrote:
> On 10/31/20 2:45 AM, Salvatore Bonaccorso wrote:
> > Hi Greg,
> > 
> > On Wed, Oct 28, 2020 at 12:56:19PM -0700, Guenter Roeck wrote:
> >> Retry.
> >>
> >> On Wed, Oct 28, 2020 at 10:10:35AM -0700, Guenter Roeck wrote:
> >>> On Tue, Oct 27, 2020 at 02:50:58PM +0100, Greg Kroah-Hartman wrote:
> >>>> This is the start of the stable review cycle for the 4.19.153 release.
> >>>> There are 264 patches in this series, all will be posted as a response
> >>>> to this one.  If anyone has any issues with these being applied, please
> >>>> let me know.
> >>>>
> >>>> Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
> >>>> Anything received after that time might be too late.
> >>>>
> >>>
> >>> Build results:
> >>> 	total: 155 pass: 152 fail: 3
> >>> Failed builds:
> >>> 	i386:tools/perf
> >>> 	powerpc:ppc6xx_defconfig
> >>> 	x86_64:tools/perf
> >>> Qemu test results:
> >>> 	total: 417 pass: 417 fail: 0
> >>>
> >>> perf failures are as usual. powerpc:
> > 
> > Regarding the perf failures, do you plan to revert b801d568c7d8 ("perf
> > cs-etm: Move definition of 'traceid_list' global variable from header
> > file") included in 4.19.152 or is a bugfix underway?
> > 
> 
> The problem is:
> 
> In file included from util/evlist.h:15:0,
>                  from util/evsel.c:30:
> util/evsel.c: In function ‘perf_evsel__exit’:
> util/util.h:25:28: error: passing argument 1 of ‘free’ discards ‘const’ qualifier from pointer target type
> /usr/include/stdlib.h:563:13: note: expected ‘void *’ but argument is of type ‘const char *’
>  extern void free (void *__ptr) __THROW;
> 
> This is seen with older versions of gcc (6.5.0 in my case). I have no idea why
> newer versions of gcc/glibc accept this (afaics free() still expects a char *,
> not a const char *). The underlying problem is that pmu_name should not be
> declared const char *, but char *, since it is allocated. The upstream version
> of perf no longer uses the same definition of zfree(). It was changed from
> 	#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
> to
> 	#define zfree(ptr) __zfree((void **)(ptr))
> which does the necessary typecast. The fix would be to either change the definition
> of zfree to add the typecast, or to change the definition of pmu_name to drop the const.
> Both would only apply to v4.19.y. I don't know if either would be acceptable.
> 
> Either case, reverting b801d568c7d8 won't solve that problem.

Are we talking about the same problem though? With v4.19.157 and
building with "gcc (Debian 8.3.0-6) 8.3.0", with an unpatched source:

$ LC_ALL=C.UTF-8 ARCH=x86 make perf
mkdir -p  .
make --no-print-directory -C perf O= subdir=
  BUILD:   Doing 'make -j2' parallel build
Warning: Kernel ABI header at 'tools/include/uapi/drm/i915_drm.h' differs from latest version at 'include/uapi/drm/i915_drm.h'
diff -u tools/include/uapi/drm/i915_drm.h include/uapi/drm/i915_drm.h
Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h'
diff -u tools/include/uapi/linux/kvm.h include/uapi/linux/kvm.h
Warning: Kernel ABI header at 'tools/include/uapi/linux/perf_event.h' differs from latest version at 'include/uapi/linux/perf_event.h'
diff -u tools/include/uapi/linux/perf_event.h include/uapi/linux/perf_event.h
Warning: Kernel ABI header at 'tools/arch/x86/include/asm/cpufeatures.h' differs from latest version at 'arch/x86/include/asm/cpufeatures.h'
diff -u tools/arch/x86/include/asm/cpufeatures.h arch/x86/include/asm/cpufeatures.h
Warning: Kernel ABI header at 'tools/arch/x86/include/uapi/asm/kvm.h' differs from latest version at 'arch/x86/include/uapi/asm/kvm.h'
diff -u tools/arch/x86/include/uapi/asm/kvm.h arch/x86/include/uapi/asm/kvm.h
Warning: Kernel ABI header at 'tools/arch/x86/lib/memcpy_64.S' differs from latest version at 'arch/x86/lib/memcpy_64.S'
diff -u tools/arch/x86/lib/memcpy_64.S arch/x86/lib/memcpy_64.S
Warning: Kernel ABI header at 'tools/include/uapi/linux/mman.h' differs from latest version at 'include/uapi/linux/mman.h'
diff -u tools/include/uapi/linux/mman.h include/uapi/linux/mman.h

Auto-detecting system features:
...                         dwarf: [ on  ]
...            dwarf_getlocations: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ OFF ]
...                      libaudit: [ on  ]
...                        libbfd: [ OFF ]
...                        libelf: [ on  ]
...                       libnuma: [ on  ]
...        numa_num_possible_cpus: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...                      libslang: [ on  ]
...                     libcrypto: [ on  ]
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ on  ]
...                          zlib: [ on  ]
...                          lzma: [ on  ]
...                     get_cpuid: [ on  ]
...                           bpf: [ on  ]

Makefile.config:456: No sys/sdt.h found, no SDT events are defined, please install systemtap-sdt-devel or systemtap-sdt-dev
Makefile.config:623: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
Makefile.config:682: No 'python-config' tool was found: disables Python support - please install python-devel/python-dev
Makefile.config:853: No alternatives command found, you need to set JDIR= to point to the root of your Java directory
Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'
  CC       util/cs-etm-decoder/cs-etm-decoder.o
  CC       util/intel-pt.o
util/cs-etm-decoder/cs-etm-decoder.c: In function 'cs_etm_decoder__buffer_packet':
util/cs-etm-decoder/cs-etm-decoder.c:287:24: error: 'traceid_list' undeclared (first use in this function); did you mean 'trace_event'?
  inode = intlist__find(traceid_list, trace_chan_id);
                        ^~~~~~~~~~~~
                        trace_event
util/cs-etm-decoder/cs-etm-decoder.c:287:24: note: each undeclared identifier is reported only once for each function it appears in
make[6]: *** [/build/linux-stable/tools/build/Makefile.build:97: util/cs-etm-decoder/cs-etm-decoder.o] Error 1
make[5]: *** [/build/linux-stable/tools/build/Makefile.build:139: cs-etm-decoder] Error 2
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [/build/linux-stable/tools/build/Makefile.build:139: util] Error 2
make[3]: *** [Makefile.perf:633: libperf-in.o] Error 2
make[2]: *** [Makefile.perf:206: sub-make] Error 2
make[1]: *** [Makefile:70: all] Error 2
make: *** [Makefile:77: perf] Error 2

Reverting b801d568c7d8 would still fix the issue for me.

Regards,
Salvatore
