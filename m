Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE09180B1
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 21:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfEHTwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 15:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbfEHTwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 15:52:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99315214AF;
        Wed,  8 May 2019 19:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557345159;
        bh=AbqWklh7wQR67sEkjeLgqgaMOMh1ejquMtpBoCLZfzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aK9Hrh8GYArrrC2PR6dMDPN6aTg5mpsntG7Qhb5wkAuPvHFQuOrgKb1i1UcC3DALa
         aKI8mDGQQV+hlJ/FYrg/9DlnltkaWMXrgTt76Qru1j/Nt4yWYUoCiRGJRcJYlh10i+
         95Zvw3ga/zURbdrDdhQjcReNqJxoNeHaD9aLL7bw=
Date:   Wed, 8 May 2019 18:52:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Don Zickus <dzickus@redhat.com>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4pyFIFBBU1M=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190508165202.GB6157@kroah.com>
References: <cki.8007596684.1FGCVHW930@redhat.com>
 <20190507170150.GA1468@kroah.com>
 <870847532.18462136.1557251794376.JavaMail.zimbra@redhat.com>
 <20190508092439.GB2361@kroah.com>
 <20190508162242.tbhuuwd6wrm66ppb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508162242.tbhuuwd6wrm66ppb@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 12:22:42PM -0400, Don Zickus wrote:
> On Wed, May 08, 2019 at 11:24:39AM +0200, Greg KH wrote:
> > > Hi,
> > > 
> > > in some cases we are running multiple recipes in a single test job, to
> > > get out the results faster. Each recipe is started by a "boot test" since
> > > that's responsible for installing and booting the kernel being tested. The
> > > report joins all recipes for given architecture, hence that one test is
> > > shown there multiple times. I agree that we should make this more clear
> > > and separate the report parts per recipes but we didn't have time for it
> > > yet, sorry. I notified people about the problem and we'll prioritize :)
> > > 
> > > > And I see you are running xfstests, which is great, but does it really
> > > > all "pass"?  What type of filesystem image are you running it on.
> > > > 
> > > 
> > > Here you can find the list of subtests that's being run [0] and a list of
> > > excluded ones from them [1]. This is just a reduced test set as some of the
> > > tests were triggering fake failures or taking too long to run as a part of
> > > CI. The lists may change in the future of course.
> > > 
> > > We set up two separate xfs partitions for the testing. The machine should
> > > have at least 50G of space available for this.
> > > 
> > > 
> > > Hope this explains everything and sorry for the recipe confusion. Let us
> > > know if you have anything else!
> > 
> > Thanks a lot for the information.  It's good to see that someone is
> > finally running xfstests on the stable trees, that's much appreciated.
> 
> Hi Greg,
> 
> Thanks for the feedback.  If you have some other suggested tests, we might
> be able to add them to our test harness.  We do have some bandwidth for
> extra testing.  Thanks!

Oh, hey, yes, I do have a list!

It's the list that 0-day does today:
	https://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git/tree/tests
pick some up from there and run with it.

Or look at what Linaro did, they are running a bunch of tests.

Or better yet, work with kernel.ci to integrate runtime tests there so
that everyone can benifit!

Having these "closed" testing silos is not good overall.  I'm happy to
see the kernels get tested, but the duplication of effort is quite sad.

thanks,

greg k-h
