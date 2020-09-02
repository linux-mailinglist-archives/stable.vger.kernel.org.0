Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177B025A681
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 09:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgIBHX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 03:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIBHX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 03:23:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A995D207EA;
        Wed,  2 Sep 2020 07:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599031435;
        bh=9ggE8lB4fLOzytqntNeN+BEJFMLCazCIAGhJHuRBPeo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nwh+4kDJPpAVaf3StG6MUO1wbTA2pTR527FnnyPY18YYKIQW+Uo7wKpHbXLY5j1kb
         zPVJx527tmzn6rOh3T5JfnEnOr6TE8YAw+RvBO63/4imEv6GxGJEYt+knGB+XySfYp
         x06/Kjlb+8EplLQ4X9lBY/zKCa+stEfJnC1b12r8=
Date:   Wed, 2 Sep 2020 09:24:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/214] 5.4.62-rc1 review
Message-ID: <20200902072421.GA1610179@kroah.com>
References: <20200901150952.963606936@linuxfoundation.org>
 <694f63b6-c5a0-f434-5212-27f1cb7b5f2a@roeck-us.net>
 <CA+G9fYtoxNSRKncYBnc=LgYVJTW51rQGAgnLaWwhYZT==VeqAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtoxNSRKncYBnc=LgYVJTW51rQGAgnLaWwhYZT==VeqAA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 10:47:51AM +0530, Naresh Kamboju wrote:
> On Wed, 2 Sep 2020 at 00:39, Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On 9/1/20 8:08 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.62 release.
> > > There are 214 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> > > Anything received after that time might be too late.
> > >
> >
> > Building x86_64:tools/perf ... failed
> > --------------
> > Error log:
> > Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h'
> > Warning: Kernel ABI header at 'tools/include/uapi/linux/sched.h' differs from latest version at 'include/uapi/linux/sched.h'
> > Warning: Kernel ABI header at 'tools/arch/x86/include/asm/cpufeatures.h' differs from latest version at 'arch/x86/include/asm/cpufeatures.h'
> > Warning: Kernel ABI header at 'tools/arch/x86/include/uapi/asm/unistd.h' differs from latest version at 'arch/x86/include/uapi/asm/unistd.h'
> > Makefile.config:846: No libcap found, disables capability support, please install libcap-devel/libcap-dev
> > Makefile.config:958: No openjdk development package found, please install JDK package, e.g. openjdk-8-jdk, java-1.8.0-openjdk-devel
> >   PERF_VERSION = 5.4.61.gf5583dd12e6f
> > In file included from btf_dump.c:16:0:
> > btf_dump.c: In function ‘btf_align_of’:
> > tools/include/linux/kernel.h:53:17: error: comparison of distinct pointer types lacks a cast [-Werror]
> >   (void) (&_min1 == &_min2);  \
> >                  ^
> > btf_dump.c:770:10: note: in expansion of macro ‘min’
> >    return min(sizeof(void *), t->size);
> >           ^~~
> > cc1: all warnings being treated as errors
> > make[7]: *** [/tmp/buildbot-builddir/tools/perf/staticobjs/btf_dump.o] Error 1
> 
> This perf build break noticed and reported on mailing list [1]
> 
> >
> > Bisect log below. Reverting the following two patches fixes the problem.
> >
> > 497ef945f327 libbpf: Fix build on ppc64le architecture
> > 401834f55ce7 libbpf: Handle GCC built-in types for Arm NEON
> >
> > Guenter
> >
> > ---
> > $ git bisect log
> > # bad: [f5583dd12e6fc8a3c11ae732f38bce8334e150a2] Linux 5.4.62-rc1
> > # good: [6576d69aac94cd8409636dfa86e0df39facdf0d2] Linux 5.4.61
> > git bisect start 'HEAD' 'v5.4.61'
> > # good: [6c747bd0794c982b500bda7334ef55d9dabb6cc6] nvme-fc: Fix wrong return value in __nvme_fc_init_request()
> > git bisect good 6c747bd0794c982b500bda7334ef55d9dabb6cc6
> > # bad: [81b5698e6d9ecdc9569df8f4b93be70d587f5ddf] serial: samsung: Removes the IRQ not found warning
> > git bisect bad 81b5698e6d9ecdc9569df8f4b93be70d587f5ddf
> > # bad: [973679736caa8e1b39b68866535bdc7899a46f25] ASoC: wm8994: Avoid attempts to read unreadable registers
> > git bisect bad 973679736caa8e1b39b68866535bdc7899a46f25
> > # good: [1789df2a787c589dbe83bc3ed52af2abbc739d1b] ext4: correctly restore system zone info when remount fails
> > git bisect good 1789df2a787c589dbe83bc3ed52af2abbc739d1b
> > # good: [ba1fb0301a60cbded377e0f312c82847415a1820] drm/amd/powerplay: correct UVD/VCE PG state on custom pptable uploading
> > git bisect good ba1fb0301a60cbded377e0f312c82847415a1820
> > # bad: [1ef070d29e73a50e98a93d9a68f69cfef4247170] netfilter: avoid ipv6 -> nf_defrag_ipv6 module dependency
> > git bisect bad 1ef070d29e73a50e98a93d9a68f69cfef4247170
> > # bad: [401834f55ce7f86bf2c0f8fdd8fbf9e1baf19f1c] libbpf: Handle GCC built-in types for Arm NEON
> > git bisect bad 401834f55ce7f86bf2c0f8fdd8fbf9e1baf19f1c
> > # good: [ccb6e88cd42a9cb65bde705f7f8e7c9822dcb711] drm/amd/display: Switch to immediate mode for updating infopackets
> > git bisect good ccb6e88cd42a9cb65bde705f7f8e7c9822dcb711
> > # first bad commit: [401834f55ce7f86bf2c0f8fdd8fbf9e1baf19f1c] libbpf: Handle GCC built-in types for Arm NEON
> 
> [1] https://lore.kernel.org/stable/CA+G9fYvsNkxvs7hdCB3LC9W+rP8hBa3F1fG3951S+xHfiOJwNA@mail.gmail.com/

Yes, sorry, I thought the follow-on patch I added would solve this
issue, I guess not :(

Odd that it works in Linus's tree?  I'll go drop both of these patches
now...

thanks,

greg k-h
