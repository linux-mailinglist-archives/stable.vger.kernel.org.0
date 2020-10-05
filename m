Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF881283737
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgJEOCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbgJEOCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:02:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEA832078A;
        Mon,  5 Oct 2020 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601906530;
        bh=AM25riSnMqgF+lZR32u1pWyqgPFCPFU4xdB0Cfbce1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XNVecaIcejIPLG8lqB4D+cJDXWgR0UuLjf63QynZlVENvrX75VnWoYPcssugTY9Sw
         fuA080XkQx7No2hWF+dTtcQJifonv2h7Gew6wWmzAsqAur1O7HaI4EyNrkmpbSstSS
         2WZd0L9KMnapbYMSuPWPIWOKJnJxKHGX72EDVCrA=
Date:   Mon, 5 Oct 2020 16:02:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Doug Berger <opendmb@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Pavel Tatashin <pasha.tatashin@oracle.com>,
        Russell King <linux@armlinux.org.uk>,
        Michal Hocko <mhocko@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        zhaoyang <huangzhaoyang@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Baoquan He <bhe@redhat.com>
Subject: Re: RFC: backport of commit a32c1c61212d
Message-ID: <20201005140254.GC1506031@kroah.com>
References: <bd960a80-c953-ad11-cdfd-1e48ffdce443@gmail.com>
 <20200901140018.GD397411@kroah.com>
 <4eb51ae0-427d-5359-2439-b38dc0d3b2e5@gmail.com>
 <98f2309c-e674-c3fc-0c13-0bf85f123f8c@gmail.com>
 <62fef535-199b-9b62-c206-c92d2d929be3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62fef535-199b-9b62-c206-c92d2d929be3@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 10:09:37AM -0700, Doug Berger wrote:
> On 9/1/2020 9:36 AM, Florian Fainelli wrote:
> > 
> > 
> > On 9/1/2020 9:06 AM, Doug Berger wrote:
> >> On 9/1/2020 7:00 AM, Greg Kroah-Hartman wrote:
> > 
> > [snip]
> > 
> >> [snip]
> >>
> >> My best guess at this point is to submit patches to the affected stable
> >> branches like the one in my RFC and reference a32c1c61212d as the
> >> upstream commit. This would be confusing to anyone that tried to compare
> >> the submitted patch with the upstream patch since they
> >> wouldn't look at all alike, but the fixes and upstream tags would define
> >> the affected range in Linus' tree.
> >>
> >> I would appreciate any guidance on how best to handle this kind of
> >> situation.
> > 
> > You could submit various patches with [PATCH stable x.y] in the subject
> > to indicate they are targeting a specific stable branch, copy
> > stable@vger.kernel.org as well as all recipients in this email and see
> > if that works.
> > 
> > Not sure if there is a more documented process than that.
> Yes, that is what I had in mind based on the "Option 3" for patch
> submission. The sticking point is this requirement:
> "You must note the upstream commit ID in the changelog of your submission"
> 
> My best guess is to use a32c1c61212d, but that could easily cause
> confusion in this case. My hope is that now I can reference this
> discussion to provide additional clarity.

I'm still totally confused, is there any specific commits that you wish
to see backported to any specific stable kernel trees?  If so, what are
they?

thanks,

greg k-h
