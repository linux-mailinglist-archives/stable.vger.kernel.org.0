Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B5B5F42FC
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 14:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJDMf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 08:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJDMfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 08:35:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F1F4F6A7
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 05:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664886949; x=1696422949;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=rdu3aEnJE8QH/dv4RJLZeZW13gyomgEmJe9KE3XU0Oo=;
  b=kBMilPbXp1S1B3KNsq+SmkyG7+imuDDM35ziKAbxr0ZRB9pQipuBkWNI
   wpkUpYWeJNvsrw7MMak8x1E6GPP1fTvSu8q709o5AEKxkCLtdx2ae8coP
   cl6EKZ+/0Rl69IpJ2Fp7QTta09mlyqlfytW1Rj1TGkeoG0BKyAhBz9YBp
   PcEUGEZTn9MJeUpoYasWDFmLdjGGUyspH3zLRoruqT+b0MNLH8L6lJ1u1
   /ucwDMrkl3Kpuxg0vxoXD2+lJ0KKvHIZNAojoW4oq1xglem320QVRuJUE
   pXDoIvmFmA7kjmBFPDhS+ZGseINqTbXj8Rk2QtOLeH76Pt7+SAsacWbxT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="301617890"
X-IronPort-AV: E=Sophos;i="5.93,157,1654585200"; 
   d="scan'208";a="301617890"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 05:35:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="657114222"
X-IronPort-AV: E=Sophos;i="5.93,157,1654585200"; 
   d="scan'208";a="657114222"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by orsmga001.jf.intel.com with SMTP; 04 Oct 2022 05:35:45 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 04 Oct 2022 15:35:44 +0300
Date:   Tue, 4 Oct 2022 15:35:44 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Slade Watkins <srw@sladewatkins.net>,
        Jerry Ling <jiling@cern.ch>, intel-gfx@lists.freedesktop.org,
        David Matthew Mattli <dmm@mattli.us>
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
Message-ID: <YzwooNdMECzuI5+h@intel.com>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
 <YzZynE2FAMNQKm2E@kroah.com>
 <YzaFq7fzw5TbrJyv@kroah.com>
 <03147889-B21C-449B-B110-7E504C8B0EF4@sladewatkins.net>
 <aa8b9724-50c6-ae2e-062d-3791144ac97e@cern.ch>
 <e3e2915d-1411-a758-3991-48d6c2688a1e@leemhuis.info>
 <YzsfrkJcwqKOO+E/@intel.com>
 <YzsgeXOK6JeVQGHF@intel.com>
 <714903fa-16c8-4247-d69d-74af6ef50bfa@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <714903fa-16c8-4247-d69d-74af6ef50bfa@leemhuis.info>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 08:28:50PM +0200, Thorsten Leemhuis wrote:
> 
> 
> On 03.10.22 19:48, Ville Syrjälä wrote:
> > On Mon, Oct 03, 2022 at 08:45:18PM +0300, Ville Syrjälä wrote:
> >> On Sat, Oct 01, 2022 at 12:07:39PM +0200, Thorsten Leemhuis wrote:
> >>> On 30.09.22 14:26, Jerry Ling wrote:
> >>>>
> >>>> looks like someone has done it:
> >>>> https://bbs.archlinux.org/viewtopic.php?pid=2059823#p2059823
> >>>>
> >>>> and the bisect points to:
> >>>>
> >>>> |# first bad commit: [fc6aff984b1c63d6b9e54f5eff9cc5ac5840bc8c]
> >>>> drm/i915/bios: Split VBT data into per-panel vs. global parts Best, Jerry |
> >>>
> >>> FWIW, that's 3cf050762534 in mainline. Adding Ville, its author to the
> >>> list of recipients.
> >>
> >> I definitely had no plans to backport any of that stuff,
> >> but I guess the automagics did it anyway.
> >>
> >> Looks like stable is at least missing this pile of stuff:
> >> 50759c13735d drm/i915/pps: Keep VDD enabled during eDP probe
> >> 67090801489d drm/i915/pps: Reinit PPS delays after VBT has been fully parsed
> >> 8e75e8f573e1 drm/i915/pps: Split PPS init+sanitize in two
> >> 586294c3c186 drm/i915/pps: Stash away original BIOS programmed PPS delays
> >> 89fcdf430599 drm/i915/pps: Don't apply quirks/etc. to the VBT PPS delays if they haven't been initialized
> >> 60b02a09598f drm/i915/pps: Introduce pps_delays_valid()
> >>
> >> But dunno if even that is enough.
> 
> If you need testers: David (now CCed) apparently has a affected machine
> and offered to test patches in a different subthread of this thread.
> 
> >> This bug report is probably the same thing:
> >> https://gitlab.freedesktop.org/drm/intel/-/issues/7013
> 
> Sounds like it.
> 
>  > Also cc intel-gfx...
> 
> Ahh, sorry, should have done that when I CCed you.

After looking at some logs we do end up with potentially bogus
panel power sequencing delays, which may harm the LCD panel.


Greg, I recommend immediate revert of this stuff, and new stable
release ASAP. Plus a recommendation that no one using laptops
with Intel GPUs run 5.19.12.


> 
> Ciao, Thorsten
> 
> 
> >>> Did anyone check if a revert on top of 5.19.12 works easily and solves
> >>> the problem?
> >>>
> >>> And does anybody known if mainline affected, too?
> >>>
> >>> Ciao, Thorsten
> >>>
> >>>
> >>>> On 9/30/22 07:11, Slade Watkins wrote:
> >>>>> Hey Greg,
> >>>>>
> >>>>>> On Sep 30, 2022, at 1:59 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >>>>>>
> >>>>>> On Fri, Sep 30, 2022 at 06:37:48AM +0200, Greg KH wrote:
> >>>>>>> On Thu, Sep 29, 2022 at 10:26:25PM -0400, Jerry Ling wrote:
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> It has been reported by multiple users across a handful of distros
> >>>>>>>> that
> >>>>>>>> there seems to be regression on Framework laptop (which presumably
> >>>>>>>> is not
> >>>>>>>> that special in terms of mobo and display)
> >>>>>>>>
> >>>>>>>> Ref:
> >>>>>>>> https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1-on-arch-linux-gen-11-model/23171
> >>>>>>> Can anyone do a 'git bisect' to find the offending commit?
> >>>>>> Also, this works for me on a gen 12 framework laptop:
> >>>>>>     $ uname -a
> >>>>>>     Linux frame 5.19.12 #68 SMP PREEMPT_DYNAMIC Fri Sep 30 07:02:33
> >>>>>> CEST 2022 x86_64 GNU/Linux
> >>>>>>
> >>>>>> so there's something odd with the older hardware?
> >>>>>>
> >>>>>> greg k-h
> >>>>> Could be. Running git bisect for 5.19.11 and 5.19.12 (as suggested by
> >>>>> the linked forum thread) returned nothing on gen 11 for me.
> >>>>>
> >>>>> This is very odd,
> >>>>> -srw
> >>>>
> >>>>
> >>
> >> -- 
> >> Ville Syrjälä
> >> Intel
> > 

-- 
Ville Syrjälä
Intel
