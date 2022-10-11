Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F645FAF38
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 11:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJKJV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 05:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiJKJV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 05:21:26 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF3A74BAA;
        Tue, 11 Oct 2022 02:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665480085; x=1697016085;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/iqPBs1hBs9f/qKO6UtSulhE5K4l2ShU4hkvQSIklmM=;
  b=Ue+w6wSeGkCZQUWbtyTh2nJeb7Rrk3QLEAxMk7fjjnPi3OyyuO8n7GuV
   7/WwBhll3hzgtBbcvdFEYCm0NM3XEjXBBggd3ML/4Rx/jG4mUraCHirYd
   dkkMMtT5xbcMGc9t/mTuH/D2JhkWv3M3UKUW3qfF+Q/qkU+Cs5H9FMP0y
   /rp0OuwrlW07FLvA/jcizPiATh/j1W0/uJWaqqMqFY6kJz6ZnmSjW6dVk
   31JeMU3RdcvPOTZo6uaZdHkX/5vmbCXcq6n0P6TXgeqiGkz5EgB7T8huw
   PG5ZW3otHkIENWEAQo9QlU8hr9TADu205N9VnC1UFuYxgjmBEgPJCEaS5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="390762496"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="390762496"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 02:21:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="577371739"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="577371739"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga003.jf.intel.com with ESMTP; 11 Oct 2022 02:21:22 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oiBRv-005F1U-2p;
        Tue, 11 Oct 2022 12:21:19 +0300
Date:   Tue, 11 Oct 2022 12:21:19 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Ferry Toth <fntoth@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Message-ID: <Y0U1j2LXmGLBYLAV@smile.fi.intel.com>
References: <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
 <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com>
 <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
 <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com>
 <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
 <Y0PFZGLaREQUazVP@smile.fi.intel.com>
 <CAHQ1cqG73UAoU=ag9qSuKdp+MzT9gYJcwGv8k8BOa=e8gWwzSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqG73UAoU=ag9qSuKdp+MzT9gYJcwGv8k8BOa=e8gWwzSg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 02:40:30PM -0700, Andrey Smirnov wrote:
> On Mon, Oct 10, 2022 at 12:13 AM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Sun, Oct 09, 2022 at 10:02:26PM -0700, Andrey Smirnov wrote:
> > > On Fri, Oct 7, 2022 at 6:07 AM Ferry Toth <fntoth@gmail.com> wrote:

...

> > > OK, Ferry, I think I'm going to need clarification on specifics on
> > > your test setup. Can you share your kernel config, maybe your
> > > "/proc/config.gz", somewhere? When you say you are running vanilla
> > > Linux, do you mean it or do you mean vanilla tree + some patch delta?
> > >
> > > The reason I'm asking is because I'm having a hard time reproducing
> > > the problem on my end. In fact, when I build v6.0
> > > (4fe89d07dcc2804c8b562f6c7896a45643d34b2f) and then do a
> > >
> > > git revert 8bd6b8c4b100 0f0101719138 (original revert proposed by Andy)
> > >
> > > I get an infinite loop of reprobing that looks something like (some
> > > debug tracing, function name + line number, included):
> >
> > Yes, this is (one of) known drawback(s) of deferred probe hack. I think
> > the kernel that Ferry runs has a patch that basically reverts one from
> > 2014 [1] and allows to have extcon as a module. (1)
> >
> > [1]: 58b116bce136 ("drivercore: deferral race condition fix")
> >
> > > which renders the system completely unusable, but USB host is
> > > definitely going to be broken too. Now, ironically, with my patch
> > > in-place, an attempt to probe extcon that ends up deferring the probe
> > > happens before the ULPI driver failure (which wasn't failing driver
> > > probe prior to https://lore.kernel.org/all/20220213130524.18748-7-hdegoede@redhat.com/),
> > > there no "driver binding" event that re-triggers deferred probe
> > > causing the loop, so the system progresses to a point where extcon is
> > > available and dwc3 driver eventually loads.
> > >
> > > After that, and I don't know if I'm doing the same test, USB host
> > > seems to work as expected. lsusb works, my USB stick enumerates as
> > > expected. Switching the USB mux to micro-USB and back shuts the host
> > > functionality down and brings it up as expected. Now I didn't try to
> > > load any gadgets to make sure USB gadget works 100%, but since you
> > > were saying it was USB host that was broken, I wasn't concerned with
> > > that. Am I doing the right test?
> >
> > Hmm... What you described above sounds more like a yet another attempt to
> > workaround (1). _If_ this is the case, we probably can discuss how to fix
> > it in generic way (somewhere in dd.c, rather than in the certain driver).
> 
> No, I'm not describing an attempt to fix anything. Just how vanilla
> v6.0 (where my patch is not reverted) works and where my patch, fixing
> a logical problem in which extcon was requested too late causing a
> forced OTG -> "gadget only" switch, also changed the ordering enough
> to accidentally avoid the loop.

You still refer to a fix, but my question was if it's the same problem or not.

> > That said, the real test case should be performed on top of clean kernel
> > before judging if it's good or bad.
> 
> Given your level of involvemnt with this particular platform and you
> being the author of
> https://github.com/edison-fw/meta-intel-edison/blob/master/meta-intel-edison-bsp/recipes-kernel/linux/files/0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch
> I assumed/expected you to double check this before sending this revert
> out. Please do so next time.

As I said I have not yet restored my testing environment for that platform and
I relied on the Ferry's report. Taking into account the history of breakages
that done for Intel Merrifield, in particular by not wide tested patches
against DWC3 driver, I immediately react with a revert. I agree that I had had
to think about that ordering issue and a patch on top of it first. I thought
that Yocto configuration that Ferry is using is clean of custom (controversial)
patches like that. Now, since you have this platform, you can also help with
testing the DWC3 on it.

-- 
With Best Regards,
Andy Shevchenko


