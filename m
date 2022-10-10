Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913925F99DA
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiJJHTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiJJHSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:18:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6285763F39;
        Mon, 10 Oct 2022 00:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665385999; x=1696921999;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HKEWtJctxYEfqje53CBekXZxJ+dZd98yO90P5ZQ0vT4=;
  b=cgPYJ06TPV1YTIYWJKhSazsuRjLo7hnH9d3aX/FzWVASP9T7MOXWhOKb
   QetFA+b/Y+fMAmlzwY8aq2XwfT3+dno7goJzKDf93OoOia5keelT9Sr/e
   KN0B8HT/NpEHUFdu0wXK/9STJFGSZ7iaemJofl0BlyCBhrMCcXeGJCnwz
   rwlH/JjEddpnrMiFDzQvV5oiCiPMqIv1dM4VDntUw+0uFVEs3WL7IlHj7
   PkLyr+xw6SlLwYP/IMWhjKJ0Zvs0yp6ScGTV2HKkHKznVL+75CFjFHPbk
   z/zADjPbQ93I2+GS3fvB2PuOEfO9h6XBPSk5faNCr6bBhk2f4bnnn4s+u
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="366123853"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="366123853"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 00:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10495"; a="954818916"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="954818916"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga005.fm.intel.com with ESMTP; 10 Oct 2022 00:10:30 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ohmvk-004lLT-2M;
        Mon, 10 Oct 2022 10:10:28 +0300
Date:   Mon, 10 Oct 2022 10:10:28 +0300
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
Message-ID: <Y0PFZGLaREQUazVP@smile.fi.intel.com>
References: <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
 <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
 <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com>
 <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
 <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com>
 <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 09, 2022 at 10:02:26PM -0700, Andrey Smirnov wrote:
> On Fri, Oct 7, 2022 at 6:07 AM Ferry Toth <fntoth@gmail.com> wrote:

Thank you for the testing on your side!

...

> OK, Ferry, I think I'm going to need clarification on specifics on
> your test setup. Can you share your kernel config, maybe your
> "/proc/config.gz", somewhere? When you say you are running vanilla
> Linux, do you mean it or do you mean vanilla tree + some patch delta?
> 
> The reason I'm asking is because I'm having a hard time reproducing
> the problem on my end. In fact, when I build v6.0
> (4fe89d07dcc2804c8b562f6c7896a45643d34b2f) and then do a
> 
> git revert 8bd6b8c4b100 0f0101719138 (original revert proposed by Andy)
> 
> I get an infinite loop of reprobing that looks something like (some
> debug tracing, function name + line number, included):

Yes, this is (one of) known drawback(s) of deferred probe hack. I think
the kernel that Ferry runs has a patch that basically reverts one from
2014 [1] and allows to have extcon as a module. (1)

[1]: 58b116bce136 ("drivercore: deferral race condition fix")

> which renders the system completely unusable, but USB host is
> definitely going to be broken too. Now, ironically, with my patch
> in-place, an attempt to probe extcon that ends up deferring the probe
> happens before the ULPI driver failure (which wasn't failing driver
> probe prior to https://lore.kernel.org/all/20220213130524.18748-7-hdegoede@redhat.com/),
> there no "driver binding" event that re-triggers deferred probe
> causing the loop, so the system progresses to a point where extcon is
> available and dwc3 driver eventually loads.
> 
> After that, and I don't know if I'm doing the same test, USB host
> seems to work as expected. lsusb works, my USB stick enumerates as
> expected. Switching the USB mux to micro-USB and back shuts the host
> functionality down and brings it up as expected. Now I didn't try to
> load any gadgets to make sure USB gadget works 100%, but since you
> were saying it was USB host that was broken, I wasn't concerned with
> that. Am I doing the right test?

Hmm... What you described above sounds more like a yet another attempt to
workaround (1). _If_ this is the case, we probably can discuss how to fix
it in generic way (somewhere in dd.c, rather than in the certain driver).

That said, the real test case should be performed on top of clean kernel
before judging if it's good or bad.

> For the reference what I test with is:
>  - vanilla kernel, no patch delta (sans minor debug tracing) + initrd
> built with Buildroot 2022.08.1
>  - Initrd is using systemd (don't think that really matters, but who knows)
>  - U-Boot 2022.04 (built with Buildroot as well)
>  - kernel config is x86_64_defconfig + whatever I gathered from *.cfg
> files in https://github.com/edison-fw/meta-intel-edison/tree/master/meta-intel-edison-bsp/recipes-kernel/linux/files

-- 
With Best Regards,
Andy Shevchenko


