Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A34A7CCB1
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 21:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730873AbfGaTXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 15:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730870AbfGaTXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 15:23:33 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4032208E4;
        Wed, 31 Jul 2019 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564601013;
        bh=Y2Pz74QYqGGC1hOcZt1OKTgO0goLWg57a6iQRfF+1Kw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NMQDgh1hqFQzzLdCjRq/hLpLWq2U4IIa2H5rpTrVcjyfsysDSRcIYfFfM0OpHVqiS
         DqSajvRGX6Wwp+u2ME7ta1aPHoUABht0Vly1raA+Epsveadsdpx2pEc/XL0Jf/SjEa
         YXoUWobDFvjp8HTJj7maSrVoT/CItZnQYjSyGB0g=
Date:   Wed, 31 Jul 2019 15:23:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Vivi, Rodrigo" <rodrigo.vivi@intel.com>
Cc:     Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Pandiyan, Dhinakaran" <dhinakaran.pandiyan@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR
 section
Message-ID: <20190731192331.GA17697@sasha-vm>
References: <20190717223451.2595-1-dhinakaran.pandiyan@intel.com>
 <20190719004526.B0CC521850@mail.kernel.org>
 <CABVU7+sbS8mw+4O1Ct8EY_5cj+fnmNFzyd6_=v2_RmCgBRA13g@mail.gmail.com>
 <20190730214851.GF29162@sasha-vm>
 <1689B7E0-5CA6-4B27-B2A8-F352618096EA@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1689B7E0-5CA6-4B27-B2A8-F352618096EA@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 05:14:38PM +0000, Vivi, Rodrigo wrote:
>> On Jul 30, 2019, at 2:48 PM, Sasha Levin <sashal@kernel.org> wrote:
>> rather
>> than a few weeks later when Greg sends his "FAILED:" mails and gets
>> ignored because said folks have moved on.
>
>however this could potentially cause extra work and confusion like we can see on this
>thread where the developer immediately responded to your email and sent the
>backported patch to the stable mailing list.
>
>Maybe it is just because we are used to Greg's failed to apply email or maybe
>it was just a matter of education...

I think that there were a few things here that ended up causing
confusion, but I'm not quite sure how to address them.

I think that stable should have a clearer rules as to how backports
should be sent. Right now we weed through mails to stable@ to figure out
what are backport requests, what are upstream patches, and what are just
confused folks.

We have gotten pretty good at this, but still not perfect...

>But I wonder if there isn't something that could be improved on the automated
>message here. Some message clearly stating:
>
>- No action required at this point

One *could* send a backport at this point. My understanding is that when
Greg sees a failure to apply a commit tagged for stable he'll grep
through his mailbox, hopefully finding the backport as a result of this
bot bugging people.

>- you can work to prepare the backport in advance
>-  don't send it to stable before requested by Greg

Why not? I think it's fine to put it on the mailing list, specially
under the same thread, and let us deal with it after the patch goes
upstream.

--
Thanks,
Sasha
