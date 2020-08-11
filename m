Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31212241C27
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 16:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgHKOOD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 11 Aug 2020 10:14:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:34466 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbgHKOOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 10:14:03 -0400
IronPort-SDR: 5KIlzxdxRgTpJxrKAFhwt0LnZCaR464VD4gaAK8QmutdgL+u220U/jZQ1QCbp13rh5DLQRZJv3
 g1K6S9WCe9jg==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="215254349"
X-IronPort-AV: E=Sophos;i="5.75,461,1589266800"; 
   d="scan'208";a="215254349"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 07:14:02 -0700
IronPort-SDR: ivxge3TGxLwJ8F2OXvGWmfn2+ZCMGSL0lxUlN+V2jU46jPCLrj/9cndhvl0xYALuJi4Ld2sRBb
 x4j1kHNg4ZWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,461,1589266800"; 
   d="scan'208";a="308412261"
Received: from orsmsx604-2.jf.intel.com (HELO ORSMSX604.amr.corp.intel.com) ([10.22.229.84])
  by orsmga002.jf.intel.com with ESMTP; 11 Aug 2020 07:14:02 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 11 Aug 2020 07:14:02 -0700
Received: from orsmsx106.amr.corp.intel.com (10.22.225.133) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 11 Aug 2020 07:14:02 -0700
Received: from orsmsx163.amr.corp.intel.com ([169.254.9.31]) by
 ORSMSX106.amr.corp.intel.com ([169.254.1.122]) with mapi id 14.03.0439.000;
 Tue, 11 Aug 2020 07:14:02 -0700
From:   "Vivi, Rodrigo" <rodrigo.vivi@intel.com>
To:     "daniel@ffwll. ch" <daniel@ffwll.ch>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>,
        "Alex Deucher" <alexander.deucher@amd.com>,
        "armijn@tjaldur.nl" <armijn@tjaldur.nl>,
        Emil Velikov <emil.velikov@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        =?iso-8859-1?Q?Noralf_Tr=F8nnes?= <noralf@tronnes.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: WTF: patch "[PATCH] drm/mgag200: Remove declaration of
 mgag200_mmap() from header" was seriously submitted to be applied to the
 5.8-stable tree?
Thread-Topic: WTF: patch "[PATCH] drm/mgag200: Remove declaration of
 mgag200_mmap() from header" was seriously submitted to be applied to the
 5.8-stable tree?
Thread-Index: AQHWbZgiapOlBxtRVEO++lDYV3x3EKkxw2UAgAGqFAA=
Date:   Tue, 11 Aug 2020 14:14:01 +0000
Message-ID: <B6E0F69E-7D9B-41B7-8323-FE8FC5332309@intel.com>
References: <159680700523135@kroah.com>
 <a92e73b9-c3da-76f6-9405-b2456fe68ce6@suse.de>
 <CAKMK7uFJVzm1avAOZd0kPAzRUQkTQv3LtrjafjpjXh4K8TaAHg@mail.gmail.com>
 <20200808102512.GA3039253@kroah.com>
 <CAKMK7uF2zeOS714mq2Y29TgjLB7h3A51FhKs70YL+kK84DCyRQ@mail.gmail.com>
 <20200808112908.GA3063898@kroah.com>
 <CAKMK7uG=JBvmkAAN_Jq-N96zO-Xp5WwN9fQJqRdaxbRqus13ow@mail.gmail.com>
 <20200810124900.GN2352366@phenom.ffwll.local>
In-Reply-To: <20200810124900.GN2352366@phenom.ffwll.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.212.29.17]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <9917E71748748A4383182228F11DDB9D@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Aug 10, 2020, at 5:49 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> On Sat, Aug 08, 2020 at 05:24:53PM +0200, Daniel Vetter wrote:
>> On Sat, Aug 8, 2020 at 1:28 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>> 
>>> On Sat, Aug 08, 2020 at 01:02:34PM +0200, Daniel Vetter wrote:
>>>> On Sat, Aug 8, 2020 at 12:24 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>> 
>>>>> On Sat, Aug 08, 2020 at 11:13:54AM +0200, Daniel Vetter wrote:
>>>>>> On Fri, Aug 7, 2020 at 3:54 PM Thomas Zimmermann <tzimmermann@suse.de> wrote:
>>>>>>> 
>>>>>>> Hi
>>>>>>> 
>>>>>>> Am 07.08.20 um 15:30 schrieb gregkh@linuxfoundation.org:
>>>>>>>> The patch below was submitted to be applied to the 5.8-stable tree.
>>>>>>>> 
>>>>>>>> I fail to see how this patch meets the stable kernel rules as found at
>>>>>>>> Documentation/process/stable-kernel-rules.rst.
>>>>>>>> 
>>>>>>>> I could be totally wrong, and if so, please respond to
>>>>>>>> <stable@vger.kernel.org> and let me know why this patch should be
>>>>>>>> applied.  Otherwise, it is now dropped from my patch queues, never to be
>>>>>>>> seen again.
>>>>>>> 
>>>>>>> Sorry for the noise. There's no reason this should go into stable.
>>>>>> 
>>>>>> We have a little script in our maintainer toolbox for bugfixes, which
>>>>>> generates the Fixes: line, adds everyone from the original commit to
>>>>>> the cc: list and also adds Cc: stable if that sha1 the patch fixes is
>>>>>> in a release already.
>>>>>> 
>>>>>> I guess we trained people a bit too much on using Fixes: tags like
>>>>>> that with the tooling, since they often do that for checkpatch stuff
>>>>>> and spelling fixes like this here too. I think the autoselect bot also
>>>>>> loves Fixes: tags a bit too much for its own good.
>>>>>> 
>>>>>> Not sure what to do, since telling people to "please sprinkle less
>>>>>> Fixes: tags" doesn't sound great either. I also don't want to tell
>>>>>> people to use the maintainer toolbox less, the autogenerated cc: list
>>>>>> is generally the right thing to do. Maybe best if the stable team
>>>>>> catches the obvious ones before adding them to the stable queue, if
>>>>>> you're ok with that Greg?
>>>>> 
>>>>> As I think this is the first time that I've had this problem for a DRM
>>>>> submission, I don't think it's a big issue yet at all, so whatever you
>>>>> are doing today is fine.
>>>>> 
>>>>> I do think that the number of patches submitted for stable for
>>>>> drm-related issues feels very very low given the rate of change and
>>>>> number of overall patches you all submit to the kernel, so if anything,
>>>>> you all should be increasing the number of times you tag stuff for
>>>>> stable, not reducing it :)
>>>> 
>>>> Ok, sounds like we should encourage people to use the Fixes: tag and
>>>> auto-cc tooling more, not less.
>>>> 
>>>> I also crunched some quick numbers:
>>>> commits with cc: stable in drm/amd: 2.6%
>>>> ... in drm/i915: 2.5%
>>>> ... drm overall: 2.3%
>>>> drivers/ overall: 3.1%
>>>> 
>>>> So from a quick look no big outliers at least, maybe not quite enough
>>>> cc: stable from smaller drivers (i915+amd is about 60% of everything
>>>> in drm). This is for the past year. Compared to drivers/ overall a bit
>>>> lower, but not drastically so. At least if I didn't screw up my
>>>> scripting.
>>> 
>>> Seems about right, so on those averages, you have missed about 40-50
>>> patches that should have been cc:ed stable.
>>> 
>>> However, you are comparing yourself against stuff like drivers/net/
>>> which shouldn't have cc: stable for most stuff (as per the networking
>>> workflow), and other subsystems that seem to never want to cc: stable
>>> for various reasons (offenders not mentioned to be nice...)
>>> 
>>> So let's bump that number up a bit, maybe you are missing 100 patches
>>> this past year that should have been backported?
>>> 
>>> Feels like you all could tag more, even if the number is only 40-50 :)
>>> 
>>> Oh wait, are you sure you don't count the horrid "double commits" where
>>> you backport something from your development branch to your "for linus"
>>> branch, and have cc: stable on both, so that during the -rc1 merge
>>> window I see a ton of commits that are already in the tree?  That would
>>> inflate your numbers a lot more so your real percentages might be a lot
>>> lower...
>>> 
>>> fun with math.
>> 
>> Even drivers/net has like 1.0% cc: stable or so, but yeah maybe a
>> third cc: stable might be missing overall in drm. The math aint more
>> accurate no matter what, but agrees with your "about 100 patches".
>> 
>> And yeah I didn't take out the cherry-picked ones. Trying to grep for
>> those (yay more fun with math) says there's 37 stable commits I
>> double-counted, leaving 1.4% left over for drm/i915. That seems indeed
>> a bit too low :-/
>> 
>> I guess time to add intel maintainers (kinda not my direct business anymore).
> 
> So for comparison I also looked at mesa3d, which at least compared to
> drivers/gpu is very similar:
> - 3 months release cycle, 1 month -rc
> - very low level C codebase dealing with gpu nonsense
> - same Cc: stable process, shamelessly copied from the kernel
> - roughly same review process, but recently switched from patch bombs on
>  m-l to gitlab merge requests (but still pretty similar flow with
>  detailed per-commit review)
> 
> It has a 0.9% stable ratio over the past year.
> 
> The really big difference is that mesa3d CI is really, really good. Like
> we run a ton of unit tests, sw rendering tests and then a bunch of hw
> platforms running validation suits. All pre-merge, i.e. before the patches
> are even reviewed in detail. And there's a bot used for merging, to make
> sure you're patches pass, or they don't go in.
> 
> tldr; roughly the same, except a CI that's a few orders of magnitude
> better than what drm/i915 has (especially wrt sporadic issues). Which I
> think is still lots better than what any other drm driver has (but it does
> help the subsytem overall with catching lots of issues in helpers an core
> code).
> 
> So maybe the lower cc: stable is because we catch more crap before it
> even lands ... no idea really, and no human can go and quickly review 10k
> patches for why there's fewer cc: stable.

Or maybe because we have a higher rate of code refactor? :/

But yes, let's work to encourage more people of using Fixes; and cc-stable
properly. Luckily we already have some tools in place (dim fixes <has>) that
our developers are used to. This will dump the right "Fixes: <hash><commit-subject>"
line, and appropriated Ccs, including stable when needed.

> 
> Cheers, Daniel
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

