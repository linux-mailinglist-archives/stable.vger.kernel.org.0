Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C540134296
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 11:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfFDJEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 05:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbfFDJEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 05:04:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 747AC24A11;
        Tue,  4 Jun 2019 09:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559639083;
        bh=hSn10/Llq55bbW0r19+An6AcRIqK1Br9yWFMTOB8XRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oIJvoPIak9aVI7yfIee864DAGHmDgDCRmQ10BhrfwN6K6jjLuVKwSV1pNXst7nJl1
         JOXFSjql6w6Nr8j7CwKbYowtN/PI+NQQwx4TB/ZELPqVl0vXNWOVqC98dYo4djNc1n
         UjfSnnGCDNUjxfcbqUdqDkGu0pGg2zKKaxCuk/rY=
Date:   Tue, 4 Jun 2019 11:04:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <groeck@google.com>
Cc:     Zubin Mithra <zsm@chromium.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>, blackgod016574@gmail.com,
        David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: 95baa60a0da8 ("ipv6_sockglue: Fix a missing-check bug in
 ip6_ra_control()")
Message-ID: <20190604090440.GC2855@kroah.com>
References: <20190603173114.GA126543@google.com>
 <20190604075235.GD6840@kroah.com>
 <CABXOdTcgyQ2XrCAurq-pne95mdeh5B36yidGTFfc6r_wu5kJsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABXOdTcgyQ2XrCAurq-pne95mdeh5B36yidGTFfc6r_wu5kJsQ@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 01:43:17AM -0700, Guenter Roeck wrote:
> On Tue, Jun 4, 2019 at 12:52 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jun 03, 2019 at 10:31:15AM -0700, Zubin Mithra wrote:
> > > Hello,
> > >
> > > CVE-2019-12378 was fixed in the upstream linux kernel with the following commit.
> > > * 95baa60a0da8 ("ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()")
> >
> > A CVE was created for that tiny thing?
> >
> > Hah, no, I think I'll refuse to apply it just for the very point of it.
> 
> We don't create CVEs, but we do have to get CVE fixes applied to our
> branches. We don't try to police the creation of CVEs, and we don't
> try to double-guess them since that would be futile (who guarantees
> that our double-guessing matches yours ?). We do have a policy to not
> apply CVEs directly but ask for stable tree merges instead to avoid
> deviation, and we (more specifically, Zubin) spend a lot of time
> validating the fixes before sending a request. I just made that
> official policy, but a policy is not cast in stone. We will stop doing
> that if we get this kind of response. If that is what you want, let me
> know.
> 
> Zubin, maybe hold back with -stable backport requests for the time
> being, and just apply missing patches directly to our branches. Sorry
> for the trouble.

It's not "trouble", and don't hold back on requesting stable backports,
I'm not asking for that at all, be reasonable.

What I am asking for is pushing back on the "all CVEs must be applied"
when obviously the patch is dumb.  It is trivial for anyone to get a CVE
for a kernel patch these days, and loads of work to try to get one
revoked (I tried in the past, gave up due to it being futile.)

So while CVEs might be a "flag" that you should look at something, they
are never a "this MUST be applied" rule that ANYONE should ever follow.

> > That's something that can not be triggered by normal operations, right?
> > It's a bugfix-for-the-theoritical from what I can see...
> >
> > > Could the patch be applied to v4.19.y, v4.14.y, v4.9.y and v4.4.y?
> >
> > Why are you ignoring 5.1?
> >
> Probably because no one is perfect.

That's fine, but always remember that I can not apply patches only to
older stable kernels and not newer ones.  When you see a patch is only
in 5.2-rcX, that's a big hint that maybe it should go to all stable
releases, if necessary.

And again, as always, for networking stable patches, please follow the
documented rules for how to ask for them.

thanks,

greg k-h
