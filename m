Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50ED13F159D
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 10:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhHSIxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 04:53:02 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:36367 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhHSIxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 04:53:01 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 17J8qETA009339;
        Thu, 19 Aug 2021 10:52:14 +0200
Date:   Thu, 19 Aug 2021 10:52:14 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jason@jlekstrand.net,
        Jonathan Gray <jsg@jsg.id.au>
Subject: Re: Determining corresponding mainline patch for stable patches Re:
 [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in eb_parse()
Message-ID: <20210819085214.GC8538@1wt.eu>
References: <20210811122702.GA8045@duo.ucw.cz>
 <YRPLbV+Dq2xTnv2e@kroah.com>
 <20210813093104.GA20799@duo.ucw.cz>
 <20210813095429.GA21912@1wt.eu>
 <20210813102429.GA28610@duo.ucw.cz>
 <YRZRU4JIh5LQjDfE@kroah.com>
 <20210813111953.GB21912@1wt.eu>
 <YRaT3u4Qes8UY3x6@mit.edu>
 <YRdnANmNvp+Hkcg5@kroah.com>
 <20210819082242.GA13181@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819082242.GA13181@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On Thu, Aug 19, 2021 at 10:22:42AM +0200, Pavel Machek wrote:
> I agree that submitters would need to know about the tag; OTOH I
> believe that if it looked like a tag, people would be more likely to
> get it right. We moved from "mention what this fixes in body" to
> "Fixes: " and I believe that was an improvement.
> 
> Anyway, three new entries in stable queues have format I have not seen
> before:
> 
> |ec547f971 None .: 4.19| KVM: nSVM: always intercept VMLOAD/VMSAVE when nested (CVE-2021-3656)
> |dbfcc0f75 None o: 4.19| KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)
> |b79b08940 None o: 4.4| KVM: nSVM: avoid picking up unsupported bits from L2 in int_ctl (CVE-2021-3653)

I can't find these commits.

> [ upstream commit 0f923e07124df069ba68d8bb12324398f4b6b709 ]

I've seen them a few times, mostly in the bpf subsystem or in net
components whose backports were provided later by the original
patch authors (or users) trying to use the same format and using
a different case on "upstream".

> I guess I'll simply update the script.

That's clearly how it ought to be done. Again, I don't remember having
faced issues during 2.6.32/3.10 in the past using the trivial script I
shared and which used to ignore the case, so I don't see any particular
difficulty there :-/

Cheers,
Willy
