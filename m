Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BAC1B5C80
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgDWNXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728072AbgDWNW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 09:22:58 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD4192084D;
        Thu, 23 Apr 2020 13:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587648178;
        bh=+Uk+Cci4QWSfYXo+YoUafIBAzfVVwswgXkfs1lhaB4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iupvT34iXG7Xoe8jDi57mUdCKgeDUaeRZ01FLkBBRx1+mJNZ/vNM8ZOLdnhnYRtlP
         uc5Rq7PFLr6qsBk9mKCKyFLEtQ+55VVP/RUzThyMpPDeKT8etoAHJhiWj1WkC3w09y
         3mDocWLKsmRT3e+R+UzRUOlX8WLfGUgM1pEcn7Js=
Date:   Thu, 23 Apr 2020 09:22:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     Greg KH <greg@kroah.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Fwd: Re: [PATCH AUTOSEL 5.6 082/129] compiler.h: fix error in
 BUILD_BUG_ON() reporting
Message-ID: <20200423132256.GA6171@sasha-vm>
References: <9b7c57b0-4441-12a1-420d-684a84e97ba0@oracle.com>
 <05565e26-e472-67e5-34e9-c466457a0db3@oracle.com>
 <20200422083446.GA3039100@kroah.com>
 <aea96721-4b51-ff0c-3da9-660e318654b4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aea96721-4b51-ff0c-3da9-660e318654b4@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 10:53:33AM +0200, Vegard Nossum wrote:
>
>On 4/22/20 10:34 AM, Greg KH wrote:
>>On Wed, Apr 22, 2020 at 10:21:23AM +0200, Vegard Nossum wrote:
>>>
>>>Hi,
>>>
>>>There is no point in taking this patch on any stable kernel as it's just
>>>improving a build error diagnostic message.
>>
>>build error messages are nice to have be correct, don't you think?
>>
>>Seems like a valid fix for me.
>>
>>thanks,
>>
>>greg k-h
>>
>
>The patch will break on gcc 4.2 and earlier, so if the older stable
>kernels support those then people might be surprised. The mainline patch
>was deemed fine since gcc 4.6 is required. More info here:
><https://lkml.org/lkml/2020/3/31/1477>
>
>If no stable kernel is built with gcc <= 4.2 then you can disregard this.
>
>I think the patch also doesn't really satisfy the following criteria
>from stable_kernel_rules.txt:
>
> - "It must fix a real bug that bothers people": It bothered me (and I
>ran into the bug) on mainline, but that was while writing brand new code
>that used BUILD_BUG_ON(). Presumably these things will not fire on
>existing kernel code.
>
> - "It must fix a problem that causes a build error ...": It doesn't fix
>any of the things listed, not even a build error, just a _diagnostic_
>for an incredibly rare case of a rare kind of build error.
>
>In the end, I am not personally opposed to having the patch in stable,
>but it seems to go against everything I've ever heard about stable rules
>so I'm a bit surprised when you take it anyway. I think it might reduce
>people's trust in stable kernels if any random weird patch is taken
>uncritically when even the patch author points out that it doesn't fit
>the criteria!

Hey Vegard,

I'll drop it.

In general, patches that address build issues are easier to rationalize
in the context of stable as the regressions they might cause will be
limited to build time.

-- 
Thanks,
Sasha
