Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD3E57BFCE
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 23:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiGTVr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 17:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiGTVr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 17:47:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BEE3AE4A;
        Wed, 20 Jul 2022 14:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+Ay+S7xOHyowQsA3HpHkXeX/xEj090g28cZhD6zCnnU=; b=hy/x6fMwZRDmXXIJgI0QPZubvl
        2CW3Fp0044+2v+TBNwrFMP+ncj5+3jnBjwQW673H/TuUESm4NXRf6AD3T+WRf+DGMMZttYXE68qLo
        Rd8vFWMivwETAJfQ9fC2w9SRfCTKI1nqdQWBExcp8FL8oWvlz3oBLbDdI96zUhZVwQNsIT7Ol9XUz
        laYl4UznLxDoYsUPauqgc37vn1JP31UhW3m8t0ZCUSb3C0hHBi/kBoLqQ20GAXdxdE5RHT2P8ywgV
        s5ZaFGvBp+IqD1F4wxyfEpimRu0tZqqNza366F9AZzFMpTa1C5eyfMtFGvS/+WuyWvorm0SMgqPXS
        4VnNCpUw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oEHX5-00Ep8Z-CG; Wed, 20 Jul 2022 21:47:03 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id AC809980BBE; Wed, 20 Jul 2022 23:47:02 +0200 (CEST)
Date:   Wed, 20 Jul 2022 23:47:02 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Justin Forbes <jforbes@fedoraproject.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Message-ID: <Yth31qsO1nDN4WLB@worktop.programming.kicks-ass.net>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
 <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
 <CAHk-=wiu=yk=3xzXk18o5yU6v1wn27rcrOD=vmKm_aLNz=zJ+w@mail.gmail.com>
 <YthCBl4SORA2BfDv@fedora64.linuxtx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YthCBl4SORA2BfDv@fedora64.linuxtx.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 20, 2022 at 12:57:26PM -0500, Justin Forbes wrote:
> On Wed, Jul 20, 2022 at 10:28:33AM -0700, Linus Torvalds wrote:
> > [ Adding PeterZ and Jiri to the participants. ]
> > 
> > Looks like 5.18.13 added that commit 9bb2ec608a20 ("objtool: Update
> > Retpoline validation") but I don't see 3131ef39fb03 ("x86/asm/32: Fix
> > ANNOTATE_UNRET_SAFE use on 32-bit") in that list.
> 
> It should be noted that the build doesn't fail, it just warns.
> I am guessing the 32bit failure is what promoted someone to look at
> the logs to begin with and notice the warn initially. I just verified
> that it exists in our builds of 5.18.13-rc1, but not on mainline builds.
> I am gueesing it is because commit 9bb2ec608a20 ("objtool: Update Retpoline
> validation") should be followed up with at least commit f43b9876e857c
> ("x86/retbleed: Add fine grained Kconfig knobs")

Still updateing the stable repro to see what the actual code looks like,
but that warning seems to suggest the -mfunction-return=thunk-extern
compiler argument went missing.

For all the files objtool complains about, does the V=1 build output
show that option?
