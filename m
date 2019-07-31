Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A83E7CA19
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 19:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbfGaROj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 31 Jul 2019 13:14:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:51464 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728879AbfGaROi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 13:14:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 10:14:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,330,1559545200"; 
   d="scan'208";a="200831992"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jul 2019 10:14:38 -0700
Received: from fmsmsx115.amr.corp.intel.com ([169.254.4.194]) by
 fmsmsx107.amr.corp.intel.com ([169.254.6.32]) with mapi id 14.03.0439.000;
 Wed, 31 Jul 2019 10:14:38 -0700
From:   "Vivi, Rodrigo" <rodrigo.vivi@intel.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Pandiyan, Dhinakaran" <dhinakaran.pandiyan@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR
 section
Thread-Topic: [Intel-gfx] [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR
 section
Thread-Index: AQHVPPA32UuiQAqQX0GQuUuHjAoekqbRkfmAgBKYLYCAABJ4gIABRbaA
Date:   Wed, 31 Jul 2019 17:14:38 +0000
Message-ID: <1689B7E0-5CA6-4B27-B2A8-F352618096EA@intel.com>
References: <20190717223451.2595-1-dhinakaran.pandiyan@intel.com>
 <20190719004526.B0CC521850@mail.kernel.org>
 <CABVU7+sbS8mw+4O1Ct8EY_5cj+fnmNFzyd6_=v2_RmCgBRA13g@mail.gmail.com>
 <20190730214851.GF29162@sasha-vm>
In-Reply-To: <20190730214851.GF29162@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.7.196.66]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12F8BF15E0B9324CB1CE296363467821@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jul 30, 2019, at 2:48 PM, Sasha Levin <sashal@kernel.org> wrote:
> 
> On Tue, Jul 30, 2019 at 01:42:45PM -0700, Rodrigo Vivi wrote:
>> Hi Sasha,
> 
> Hello!
> 
>> On Thu, Jul 18, 2019 at 5:45 PM Sasha Levin <sashal@kernel.org> wrote:
>>> 
>>> Hi,
>>> 
>>> [This is an automated email]
>> 
>> Where did you get this patch from? Since stable needs patches merged
> 
> This bot grabs them from various mailing lists.
> 
>> on Linus tree,
>> shouldn't your scripts run to try backporting only patches from there?
> 
> There's a note a few lines down that says:
> 
>   "NOTE: The patch will not be queued to stable trees until it is upstream."
> 
> Otherwise, no, there's no rule that says we can't look at patches before
> they are upstream. We can't queue them up, but we sure can poke them.
> 
> The reasoning behind this is that it's easier to get replies (and
> backports) from folks who are actively working on the patch now,


This is a very good reason indeed...

> rather
> than a few weeks later when Greg sends his "FAILED:" mails and gets
> ignored because said folks have moved on.

however this could potentially cause extra work and confusion like we can see on this
thread where the developer immediately responded to your email and sent the
backported patch to the stable mailing list.

Maybe it is just because we are used to Greg's failed to apply email or maybe
it was just a matter of education... 

But I wonder if there isn't something that could be improved on the automated
message here. Some message clearly stating:

- No action required at this point
- you can work to prepare the backport in advance
-  don't send it to stable before requested by Greg

Anyway, just few ideas. I just reached you to understand the flow and I'm already
happy to understand what happened here.

Thanks a lot for that,
Rodrigo.


> 
> --
> Thanks,
> Sasha
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

