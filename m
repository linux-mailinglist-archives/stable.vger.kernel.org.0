Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0BA101976
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfKSGhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:37:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:35242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbfKSGhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 01:37:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23A922082F;
        Tue, 19 Nov 2019 06:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574145426;
        bh=3tS1R60By79kezmM5W29uKHxxS7Tv7oeXzLP07Z44qo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RiOmBj/tL891fQMNyQ6JFyV2tCKesSW1xRbKvtyq2X+Uj3WK4VX2S4NzuQ2hGuJ7Q
         h/s7m6+OhJh9KLeuPxuVYqfNDm8VJ9Zky7MUu9sB1LnEHcX9CX4hFDimAdDmxrMXPC
         gDAxUOzXbCOhaxS65FOVAVZrZIYDcSUoFwUXeB3M=
Date:   Tue, 19 Nov 2019 07:37:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     20190516090651.1396-1-harry.pan@intel.com,
        20191016103816.30650-1-kai.heng.feng@canonical.com,
        feng.tang@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: Patch "x86/quirks: Disable HPET on Intel Coffe Lake platforms"
 has been added to the 4.4-stable tree
Message-ID: <20191119063704.GA1688684@kroah.com>
References: <1574092522185210@kroah.com>
 <8B3CE6F5-0DD0-4F03-B86B-5AAA883F2569@canonical.com>
 <20191119060008.GA1618644@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119060008.GA1618644@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 07:00:08AM +0100, Greg KH wrote:
> On Tue, Nov 19, 2019 at 01:27:31PM +0800, Kai-Heng Feng wrote:
> > Hi Greg,
> > 
> > > On Nov 18, 2019, at 23:55, <gregkh@linuxfoundation.org> <gregkh@linuxfoundation.org> wrote:
> > > 
> > > 
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >    x86/quirks: Disable HPET on Intel Coffe Lake platforms
> > > 
> > > to the 4.4-stable tree which can be found at:
> > >    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > 
> > > The filename of the patch is:
> > >     x86-quirks-disable-hpet-on-intel-coffe-lake-platforms.patch
> > > and it can be found in the queue-4.4 subdirectory.
> > > 
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> > 
> > This patch depends on commit c8c4076723da ("x86/timer: Skip PIT initialization on modern chipsets").
> > Otherwise the system may freeze at boot. So please also include that commit.
> 
> Thanks for the info, now queued up everywhere.

And it broke the build everywhere, so I've dropped it now :(

I'll drop this quirks patch as well, can you please provide a proper
series backported for the stable trees if you think it should be
included in them?

thanks,

greg k-h
