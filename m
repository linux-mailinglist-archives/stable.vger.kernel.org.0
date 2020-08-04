Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2CD23B322
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 05:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgHDDBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 23:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgHDDBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 23:01:09 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0154C06174A;
        Mon,  3 Aug 2020 20:01:09 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id g19so9503608plq.0;
        Mon, 03 Aug 2020 20:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t7bwQ7uszFAoujrRz6CfHxaIJ5PCL1LbSKdLTSTnrIw=;
        b=gaxwoqhxXzq5sdzxrMO8ULxCa2KiPx1YgUoYsK2lXwp3FewnyOJxBnlqZaLvpSWYRR
         okPkoL4YtRjdezmdAFm1/+SZK9Gg/0eixFVXHWAzKchJ3O0iuGho0Rt/DjoWj9lbLL9r
         cD9mmKcfZjbtBMfVGYgmsv/SNz8zfjGkbJeOs7aN3+epY7fjaF1p+ILZ/cEUSo/ClHLU
         /smDmj9z3dhWVOem6Z0HPAt/jDfA/+YsEy4U7sRtR7CK1UgDCybC5hw22Weddr5BR5c8
         PY8uzMI2eYn6XnNUZ5PXyZDU9IEsqwByTrjSLvJzKWbEWqRmdwXjcRLnIABIqCXng3L9
         W/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=t7bwQ7uszFAoujrRz6CfHxaIJ5PCL1LbSKdLTSTnrIw=;
        b=Hzo2cN3KOyOhx7nRWGM4ZGA50UgGJ8uXACFs77lCg9UH4yCVnAFZkGHrcn7mqm075y
         YHDCkadlcJ4zyft9fyFm3bgjI3XzedqqfMSaILlxUsNrAWuauveneCNIkl57S2aBk9ZC
         VxbBaSracXJoBHjxOFNQYtvIQQZ24JVWP46xBoXxXBkFYuoSoBUw3q1q82eIaLeaPFiE
         nhfsuE/HlZqHuu6Sm6duwesBn9/OiYgs5hdn1Mz8rvChV8NkA2od9pKL/vYtECSCDNGB
         9/Q7SAH+I3OS2uiG9VraJ7ipxG3sEOiAs4DMhO3Anpx2UbuzcbbuOm71LtHJmIksDNjE
         oHDA==
X-Gm-Message-State: AOAM532Ep2WqI0jNEkQ8yi+6pVPfKS8U0C/3QqZ1C26JF+AAiV17ZhBZ
        T0h0KHgJmQSXnpc4lmxd5tE=
X-Google-Smtp-Source: ABdhPJzr1g+60gUIfi4iCvfQCTqYTrx7MMJPxlHxsCf1eNUSi9O/jLpDK6ahpOQsHsPrVbMZbltVkA==
X-Received: by 2002:a17:902:bd01:: with SMTP id p1mr13255411pls.25.1596510069334;
        Mon, 03 Aug 2020 20:01:09 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d81sm7352521pfd.174.2020.08.03.20.01.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Aug 2020 20:01:08 -0700 (PDT)
Date:   Mon, 3 Aug 2020 20:01:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/120] 5.7.13-rc1 review
Message-ID: <20200804030107.GA220454@roeck-us.net>
References: <20200803121902.860751811@linuxfoundation.org>
 <20200803155820.GA160756@roeck-us.net>
 <20200803173330.GA1186998@kroah.com>
 <CAMuHMdW1Cz_JJsTmssVz_0wjX_1_EEXGOvGjygPxTkcMsbR6Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdW1Cz_JJsTmssVz_0wjX_1_EEXGOvGjygPxTkcMsbR6Lw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 10:33:59PM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Mon, Aug 3, 2020 at 7:35 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, Aug 03, 2020 at 08:58:20AM -0700, Guenter Roeck wrote:
> > > On Mon, Aug 03, 2020 at 02:17:38PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.7.13 release.  There
> > > > are 120 patches in this series, all will be posted as a response to this one.
> > > > If anyone has any issues with these being applied, please let me know.
> > > >
> > > > Responses should be made by Wed, 05 Aug 2020 12:18:33 +0000.  Anything
> > > > received after that time might be too late.
> > > >
> > >
> > > Building sparc64:allmodconfig ... failed
> > > --------------
> > > Error log:
> > > <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> > > In file included from arch/sparc/include/asm/percpu_64.h:11,
> > >                  from arch/sparc/include/asm/percpu.h:5,
> > >                  from include/linux/random.h:14,
> > >                  from fs/crypto/policy.c:13:
> > > arch/sparc/include/asm/trap_block.h:54:39: error: 'NR_CPUS' undeclared here (not in a function)
> > >    54 | extern struct trap_per_cpu trap_block[NR_CPUS];
> > >
> > > Inherited from mainline. Builds are not complete yet;
> > > we may see a few more failures (powerpc:ppc64e_defconfig
> > > fails to build in mainline as well).
> >
> > If it gets fixed upstream, I'll fix it here :)
> 
> And else you'll release a known-broken v5.7.13?
> 
> Perhaps backporting should be a bit less aggressive?
> This breakage was introduced in between v5.8-rc7 and v5.8, and backported
> before people had the time to properly look into the v5.8 build bot logs.
> 

The bisect log below applies to both the sparc and the powerpc build
failures.

I should have guessed. Bisect points to the random changes. Those are
really causing an endless amount of trouble. I hope the problem they
are solving is worth all that trouble.

Guenter

---
# bad: [333e573a423b816b8b28000d6106fa52bd98e198] Linux 4.14.192-rc1
# good: [7f2c5eb458b8855655a19c44cd0043f7f83c595f] Linux 4.14.191
git bisect start 'HEAD' 'v4.14.191'
# bad: [88918f1a1f18dad31154103fa5218e714f10679e] net/x25: Fix x25_neigh refcnt leak when x25 disconnect
git bisect bad 88918f1a1f18dad31154103fa5218e714f10679e
# good: [1f9d268fd05887ecb6225a9452309efc3535492d] ARM: percpu.h: fix build error
git bisect good 1f9d268fd05887ecb6225a9452309efc3535492d
# bad: [f496bedf603212e6dbef88425680f8e137a51e27] random32: remove net_rand_state from the latent entropy gcc plugin
git bisect bad f496bedf603212e6dbef88425680f8e137a51e27
# good: [1e69d85c7e40051b57414953410bcee858285081] f2fs: check memory boundary by insane namelen
git bisect good 1e69d85c7e40051b57414953410bcee858285081
# bad: [0ea865dc4e3d93320e7103958ff041f5d7032ed5] random: fix circular include dependency on arm64 after addition of percpu.h
git bisect bad 0ea865dc4e3d93320e7103958ff041f5d7032ed5
# good: [e2bd43f819d770de686a904b7139bf444e96543c] f2fs: check if file namelen exceeds max value
git bisect good e2bd43f819d770de686a904b7139bf444e96543c
# first bad commit: [0ea865dc4e3d93320e7103958ff041f5d7032ed5] random: fix circular include dependency on arm64 after addition of percpu.h
