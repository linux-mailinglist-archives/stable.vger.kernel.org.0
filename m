Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C059E2B6ECC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 20:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgKQTg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 14:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgKQTg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 14:36:26 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01076C0613CF;
        Tue, 17 Nov 2020 11:36:26 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p22so4479536wmg.3;
        Tue, 17 Nov 2020 11:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eSOMRKTehP2DeGUhI6ZUphXvg5rrCFia/70gJOxthGI=;
        b=eCdZ7LtCQkcs1VLeFJFP8fvVlW/9XV//FlXF7qbQ9z2kmQGXWUbnN7GLrSm6dC0HPE
         IvkOasPAM0bZE5uFKhZhAab0LMS/KzTi5kHG+Pr3MspA1+iBuxOUHPVARwjAkdM8/CFV
         EMbx4r6VJAd6Z5YcgfwtED2/smowMw2FQvnLMqxdmz4dCEcaK8XClrcYl/Jp2Gs2M1Ab
         dJqK0HiurvT33f1oZIBai3McKPHheLQWsC4+9wJBksd2bz6SnVMSdF93M4oQGGAqR9Sg
         EtD6WFyALyAsqMT5EnOVy5momGz9quEaHt3QqIbbyNs0VRELGD3mhER9U+5KRnh/2nX9
         U4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=eSOMRKTehP2DeGUhI6ZUphXvg5rrCFia/70gJOxthGI=;
        b=KasjW2Bucadvh5viop4Q9L9CueJoKQZ4FGSRiotSd4H0QWo0n5ywNLfkrGrqjXsu3G
         M6l/3Ogcbf68F+GSe8wgpm0ztXYIMDt/DfZxBTzbjGmHEtGsribh21YM6J9WEtOfx7Lb
         fv/ZUUx3/OKjeV4yAFmH1qt5PvwzTHMuKt7XB1Azxfpoq2QNl3/NOXOlnVZMjugbSUig
         glEWT+ax+KpnzoMluRS7hHQmQnur/Q+qktPwYkAF5wEKHqoM2jZR2RRgr41t8LCb4O+t
         6oA9P7Llxq4zeEYFUqm+CMp29DOtEe8K4Yg0PeGfRpGmvm9eq+eR23c4PiYlrou4U+Iw
         U1Bw==
X-Gm-Message-State: AOAM532zwa1pKjz+HnUP1Qws8GsiA6w8ril6+3lTnIUrWARUCYxkZa9q
        mg7wojvh5jSTNwauS3fpbBaaufct06nPBA==
X-Google-Smtp-Source: ABdhPJwETgzPaVvged0xWepz8FXRosLkftY8agZYvFxO2lXzmW0t5lWTtLPn54u3/iNwfHIXyDoOBw==
X-Received: by 2002:a1c:f20d:: with SMTP id s13mr722205wmc.156.1605641784324;
        Tue, 17 Nov 2020 11:36:24 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id m126sm5240840wmm.0.2020.11.17.11.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 11:36:22 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 17 Nov 2020 20:36:21 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
Message-ID: <20201117193621.GA25637@eldamar.lan>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201028171035.GD118534@roeck-us.net>
 <20201028195619.GC124982@roeck-us.net>
 <20201031094500.GA271135@eldamar.lan>
 <7608060e-f48b-1a7c-1a92-9c41d81d9a40@roeck-us.net>
 <20201114083501.GA468764@eldamar.lan>
 <0a338aae-c3cc-97d4-825e-9082a9659504@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a338aae-c3cc-97d4-825e-9082a9659504@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guenter,

On Sat, Nov 14, 2020 at 05:27:41AM -0800, Guenter Roeck wrote:
> On 11/14/20 12:35 AM, Salvatore Bonaccorso wrote:
> > Hi Guenter,
> > 
> > On Sat, Oct 31, 2020 at 07:31:32AM -0700, Guenter Roeck wrote:
> >> On 10/31/20 2:45 AM, Salvatore Bonaccorso wrote:
> >>> Hi Greg,
> >>>
> >>> On Wed, Oct 28, 2020 at 12:56:19PM -0700, Guenter Roeck wrote:
> >>>> Retry.
> >>>>
> >>>> On Wed, Oct 28, 2020 at 10:10:35AM -0700, Guenter Roeck wrote:
> >>>>> On Tue, Oct 27, 2020 at 02:50:58PM +0100, Greg Kroah-Hartman wrote:
> >>>>>> This is the start of the stable review cycle for the 4.19.153 release.
> >>>>>> There are 264 patches in this series, all will be posted as a response
> >>>>>> to this one.  If anyone has any issues with these being applied, please
> >>>>>> let me know.
> >>>>>>
> >>>>>> Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
> >>>>>> Anything received after that time might be too late.
> >>>>>>
> >>>>>
> >>>>> Build results:
> >>>>> 	total: 155 pass: 152 fail: 3
> >>>>> Failed builds:
> >>>>> 	i386:tools/perf
> >>>>> 	powerpc:ppc6xx_defconfig
> >>>>> 	x86_64:tools/perf
> >>>>> Qemu test results:
> >>>>> 	total: 417 pass: 417 fail: 0
> >>>>>
> >>>>> perf failures are as usual. powerpc:
> >>>
> >>> Regarding the perf failures, do you plan to revert b801d568c7d8 ("perf
> >>> cs-etm: Move definition of 'traceid_list' global variable from header
> >>> file") included in 4.19.152 or is a bugfix underway?
> >>>
> >>
> >> The problem is:
> >>
> >> In file included from util/evlist.h:15:0,
> >>                  from util/evsel.c:30:
> >> util/evsel.c: In function ‘perf_evsel__exit’:
> >> util/util.h:25:28: error: passing argument 1 of ‘free’ discards ‘const’ qualifier from pointer target type
> >> /usr/include/stdlib.h:563:13: note: expected ‘void *’ but argument is of type ‘const char *’
> >>  extern void free (void *__ptr) __THROW;
> >>
> >> This is seen with older versions of gcc (6.5.0 in my case). I have no idea why
> >> newer versions of gcc/glibc accept this (afaics free() still expects a char *,
> >> not a const char *). The underlying problem is that pmu_name should not be
> >> declared const char *, but char *, since it is allocated. The upstream version
> >> of perf no longer uses the same definition of zfree(). It was changed from
> >> 	#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
> >> to
> >> 	#define zfree(ptr) __zfree((void **)(ptr))
> >> which does the necessary typecast. The fix would be to either change the definition
> >> of zfree to add the typecast, or to change the definition of pmu_name to drop the const.
> >> Both would only apply to v4.19.y. I don't know if either would be acceptable.
> >>
> >> Either case, reverting b801d568c7d8 won't solve that problem.
> > 
> > Are we talking about the same problem though? With v4.19.157 and
> > building with "gcc (Debian 8.3.0-6) 8.3.0", with an unpatched source:
> > 
> > $ LC_ALL=C.UTF-8 ARCH=x86 make perf
> > mkdir -p  .
> > make --no-print-directory -C perf O= subdir=
> >   BUILD:   Doing 'make -j2' parallel build
> > Warning: Kernel ABI header at 'tools/include/uapi/drm/i915_drm.h' differs from latest version at 'include/uapi/drm/i915_drm.h'
> > diff -u tools/include/uapi/drm/i915_drm.h include/uapi/drm/i915_drm.h
> > Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h'
> > diff -u tools/include/uapi/linux/kvm.h include/uapi/linux/kvm.h
> > Warning: Kernel ABI header at 'tools/include/uapi/linux/perf_event.h' differs from latest version at 'include/uapi/linux/perf_event.h'
> > diff -u tools/include/uapi/linux/perf_event.h include/uapi/linux/perf_event.h
> > Warning: Kernel ABI header at 'tools/arch/x86/include/asm/cpufeatures.h' differs from latest version at 'arch/x86/include/asm/cpufeatures.h'
> > diff -u tools/arch/x86/include/asm/cpufeatures.h arch/x86/include/asm/cpufeatures.h
> > Warning: Kernel ABI header at 'tools/arch/x86/include/uapi/asm/kvm.h' differs from latest version at 'arch/x86/include/uapi/asm/kvm.h'
> > diff -u tools/arch/x86/include/uapi/asm/kvm.h arch/x86/include/uapi/asm/kvm.h
> > Warning: Kernel ABI header at 'tools/arch/x86/lib/memcpy_64.S' differs from latest version at 'arch/x86/lib/memcpy_64.S'
> > diff -u tools/arch/x86/lib/memcpy_64.S arch/x86/lib/memcpy_64.S
> > Warning: Kernel ABI header at 'tools/include/uapi/linux/mman.h' differs from latest version at 'include/uapi/linux/mman.h'
> > diff -u tools/include/uapi/linux/mman.h include/uapi/linux/mman.h
> > 
> > Auto-detecting system features:
> > ...                         dwarf: [ on  ]
> > ...            dwarf_getlocations: [ on  ]
> > ...                         glibc: [ on  ]
> > ...                          gtk2: [ OFF ]
> > ...                      libaudit: [ on  ]
> > ...                        libbfd: [ OFF ]
> > ...                        libelf: [ on  ]
> > ...                       libnuma: [ on  ]
> > ...        numa_num_possible_cpus: [ on  ]
> > ...                       libperl: [ on  ]
> > ...                     libpython: [ on  ]
> > ...                      libslang: [ on  ]
> > ...                     libcrypto: [ on  ]
> > ...                     libunwind: [ on  ]
> > ...            libdw-dwarf-unwind: [ on  ]
> > ...                          zlib: [ on  ]
> > ...                          lzma: [ on  ]
> > ...                     get_cpuid: [ on  ]
> > ...                           bpf: [ on  ]
> > 
> > Makefile.config:456: No sys/sdt.h found, no SDT events are defined, please install systemtap-sdt-devel or systemtap-sdt-dev
> > Makefile.config:623: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
> > Makefile.config:682: No 'python-config' tool was found: disables Python support - please install python-devel/python-dev
> > Makefile.config:853: No alternatives command found, you need to set JDIR= to point to the root of your Java directory
> > Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'
> >   CC       util/cs-etm-decoder/cs-etm-decoder.o
> >   CC       util/intel-pt.o
> > util/cs-etm-decoder/cs-etm-decoder.c: In function 'cs_etm_decoder__buffer_packet':
> > util/cs-etm-decoder/cs-etm-decoder.c:287:24: error: 'traceid_list' undeclared (first use in this function); did you mean 'trace_event'?
> >   inode = intlist__find(traceid_list, trace_chan_id);
> >                         ^~~~~~~~~~~~
> >                         trace_event
> > util/cs-etm-decoder/cs-etm-decoder.c:287:24: note: each undeclared identifier is reported only once for each function it appears in
> > make[6]: *** [/build/linux-stable/tools/build/Makefile.build:97: util/cs-etm-decoder/cs-etm-decoder.o] Error 1
> > make[5]: *** [/build/linux-stable/tools/build/Makefile.build:139: cs-etm-decoder] Error 2
> > make[5]: *** Waiting for unfinished jobs....
> > make[4]: *** [/build/linux-stable/tools/build/Makefile.build:139: util] Error 2
> > make[3]: *** [Makefile.perf:633: libperf-in.o] Error 2
> > make[2]: *** [Makefile.perf:206: sub-make] Error 2
> > make[1]: *** [Makefile:70: all] Error 2
> > make: *** [Makefile:77: perf] Error 2
> > 
> > Reverting b801d568c7d8 would still fix the issue for me.
> > 
> 
> You are correct, that is a different issue, and b801d568c7d8 will need to be reverted
> to fix it. I just can't figure out how to convince perf to compile this file for me.

Thanks for confirming/acking.

So how to move from here, Greg do you need an explicit patch with the
revert or can it be taken from here?

Salvatore
