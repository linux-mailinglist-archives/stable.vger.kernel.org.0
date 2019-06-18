Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF70C49E27
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 12:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbfFRKV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 06:21:27 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37904 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfFRKV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 06:21:27 -0400
Received: by mail-pl1-f194.google.com with SMTP id f97so5537657plb.5
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 03:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AkjQ8u0Q3m/SzCvMdM2EUOK1pzB6kGaGnwLoVIN3KQM=;
        b=KJ1/t/bhwcsT1nteaM2wvu8LoWKMXSPLrUGfybLH37/Xa0uqZBUG6S3Bjsc2jJAup2
         N2DO/9PNBnR5CBG1sMxFiScbGgpnqZ5xpe9oZhQ48pIeps3MTv0TSRPVxrmlv0c6s32f
         2gpmTsGr/iJfH3R8N25AFnUqYCAt7b+foUG+2xLsu1/Zp6dfDv9mvuC4DedKF9M5IDJK
         mLuilfbjEmFxMSMKqNS+1dU35mvQtOZD3R1qCJXmdKVbBX7pZYUbZ52XWUpf4WD+Kgdb
         bKSObQgqfR3XnrGPQSFuHnFfOILGJonhw9mYVLWhSx5g3FaKguIM2ZydSlG/Tx8Dg03g
         uZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AkjQ8u0Q3m/SzCvMdM2EUOK1pzB6kGaGnwLoVIN3KQM=;
        b=Sol+ME+RJ2SUKM1/jbGDo0QMZ2R4uFQbHUJ5Ov5QMgyTgkbpjKN7IpI/xrLf4+Xzjt
         TXGd/imus/oG1SZyT2iuscX65Zav7/wMNd6PuGNeHzgSvlCvTUl7NwtGd7l/WDmZmcfh
         Pfy3oCnoGxAUHMGFhlBnjW9qumgj1NDBC0ZoyjYQ+q0rGau3JtPwvg02mMY8Ua7jG2p0
         g0pNnM65i0REkUxF09sZo3EK09lIr1PdJVCad6tW43r5ONiWEXPy/I55RxJ0+6T95eyX
         4m4oW5ts/V7ktnaCpQqrT9+p/4KJNIwrBNa0AKB77+tkrlip1ecEVnpLeU4QR5WndUHv
         x4xg==
X-Gm-Message-State: APjAAAXlr/l0lZbY8jLFTtu1nxkllG8MXg8Py/lHVTuAw45CrvibC1PM
        zP0o0oZFAespMQcdx/RS2nWhqA==
X-Google-Smtp-Source: APXvYqzfJHrp9HZA7Ao8ku14aFEpKvPoTVvW1PkWmPKrJEaI1JDGAocXVduGyLaEtQ1vXj/fDxe6Og==
X-Received: by 2002:a17:902:20e2:: with SMTP id v31mr112731954plg.138.1560853286460;
        Tue, 18 Jun 2019 03:21:26 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id h6sm2062381pjs.2.2019.06.18.03.21.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 03:21:24 -0700 (PDT)
Date:   Tue, 18 Jun 2019 15:51:22 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Julien Thierry <julien.thierry@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 00/45] V4.4 backport of arm64 Spectre patches
Message-ID: <20190618102122.z52oi37pp3wigqxx@vireshk-i7>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
 <7329e6d9-140d-59bc-c835-5f6300cf60e0@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7329e6d9-140d-59bc-c835-5f6300cf60e0@arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17-06-19, 17:03, Julien Thierry wrote:
> On 14/06/2019 04:07, Viresh Kumar wrote:
> > Hello,
> > 
> > Here is an attempt to backport arm64 spectre patches to v4.4 stable
> > tree.
> > 
> > I have started this backport with Mark Rutland's backport of Spectre to
> > 4.9 [1] and tried applying the upstream version of them over 4.4 and
> > resolved conflicts by checking how they have been resolved in 4.9.
> > 
> > I had to pick few extra upstream patches to avoid unnecessary conflicts
> > (upstream commit ids mentioned):
> > 
> >   a842789837c0 arm64: remove duplicate macro __KERNEL__ check
> 
> I'm a bit unfamiliar with what gets or doesn't get backported. My
> understanding is that we try to backport only what's necessary to reduce
> the noise and potential introduction of issues in stable releases.
> 
> This commit is just a cleanup and (while valid) doesn't really seem
> necessary (and potential conflicts from its absence would easily be
> resolved IMO). So I'm just concerned that this doesn't constitute a
> candidate for back porting (someone can correct me if I'm wrong).

Dropped now.

> >   64f8ebaf115b mm/kasan: add API to check memory regions
> >   bffe1baff5d5 arm64: kasan: instrument user memory access API
> >   92406f0cc9e3 arm64: cpufeature: Add scope for capability check
> >   9eb8a2cdf65c arm64: cputype info for Broadcom Vulcan
> >   0d90718871fe arm64: cputype: Add MIDR values for Cavium ThunderX2 CPUs
> >   98dd64f34f47 ARM: 8478/2: arm/arm64: add arm-smccc
> > 
> > 
> > I had to drop few patches as well as they weren't getting applied
> > properly due to missing files/features (upstream commit id mentioned):
> > 
> >   93f339ef4175 arm64: cpufeature: __this_cpu_has_cap() shouldn't stop early
> >   3c31fa5a06b4 arm64: Run enable method for errata work arounds on late CPUs
> 
> Looking at this and at the patches that implement the BP callbacks, we
> need that patch or an equivalent, otherwise we won't be using the
> correct vectors for late CPUs...
> 
> I appreciate the code has changed, but it might be worth considering
> 6a6efbb45b7d95c84840010095367eb06a64f342 as a needed dependency for BP
> hardening.

Okay, I had to pick two more patches for a clean rebase.

d4a7e845dab5 arm64: Introduce cpu_die_early
7242dbf2e4da arm64: Move cpu_die_early to smp.c
545fe20330c3 arm64: Verify CPU errata work arounds on hotplugged CPU
0365babc6c1f arm64: Run enable method for errata work arounds on late CPUs

(You can fetch my tree again to get these commit ids)

> >   6840bdd73d07 arm64: KVM: Use per-CPU vector when BP hardening is enabled
> 
> I don't believe we can do without this patch. Otherwise we're only using
> the vector that has no mitigation for kvm guests.
> 
> In v4.4, it looks like the contents of virt/kvm/arm/arm.c were contained
> in arch/arm/kvm/arm.c (yes, even for amr64). Are there other reasons
> this patch was not applying?

It was something other than this I believe, I have already used these paths for
many other patches.

Anyway, KVM stuff is mostly dropped now, just that I had to keep the changes to
arm-smccc.h from those patches.

I have updated the stable/v4.4.y/spectre branch with all the changes you
suggested and pushed the earlier version to stable/v4.4.y/spectre-v1 branch.

Will it be possible for you to have a look at stable/v4.4.y/spectre branch to
see if it is okay, so I can send the v2 version ? Don't want to spam list
unnecessary with so many patches :)

Thanks for your help Julien, really appreciate it.

-- 
viresh
