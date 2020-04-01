Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8105519A724
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 10:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732064AbgDAIVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 04:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729703AbgDAIVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 04:21:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35EEF2078B;
        Wed,  1 Apr 2020 08:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585729293;
        bh=btOKXSGf76FBzOEt5fSGzQ5RZEDzDZ4bhHY+Uwrci3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F7BsK5jNFRn+yLZvfpo2cl4bjYIcY40dMDqH1UJUEhiK0u+AORKhlHlmz7RGPz6NZ
         bh04s7asofV/FE2OhzpMcuGnl2iryzHWYyrgy/W0lUQmcZU6VmbR3zW+nMZH3pksD6
         /DLvC8rxkjExqHzDv5UbUDBjWnNsn3GCl0kwX9jQ=
Date:   Wed, 1 Apr 2020 10:21:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Barre <ludovic.barre@st.com>,
        "# 4.0+" <stable@vger.kernel.org>
Subject: Re: patch "driver core: platform: Initialize dma_parms for platform
 devices" added to char-misc-testing
Message-ID: <20200401082131.GA2023796@kroah.com>
References: <158523473532132@kroah.com>
 <CAPDyKFr0Em0-8RX3TnuRTiEEX6qs3Lu+SxFufmv5Mx6_6606=g@mail.gmail.com>
 <20200401060720.GA1904908@kroah.com>
 <CAPDyKFo2SZKDfv9oGpRXrYi-y26jRVPqDd5Xa4XX+7xVAwo-qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFo2SZKDfv9oGpRXrYi-y26jRVPqDd5Xa4XX+7xVAwo-qg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 10:12:28AM +0200, Ulf Hansson wrote:
> On Wed, 1 Apr 2020 at 08:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Mar 31, 2020 at 08:43:25PM +0200, Ulf Hansson wrote:
> > > On Thu, 26 Mar 2020 at 15:58, <gregkh@linuxfoundation.org> wrote:
> > > >
> > > >
> > > > This is a note to let you know that I've just added the patch titled
> > > >
> > > >     driver core: platform: Initialize dma_parms for platform devices
> > > >
> > > > to my char-misc git tree which can be found at
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
> > > > in the char-misc-testing branch.
> > > >
> > > > The patch will show up in the next release of the linux-next tree
> > > > (usually sometime within the next 24 hours during the week.)
> > > >
> > > > The patch will be merged to the char-misc-next branch sometime soon,
> > > > after it passes testing, and the merge window is open.
> > > >
> > > > If you have any questions about this process, please let me know.
> > >
> > > Greg, would you mind dropping this one and the other patch for the amba bus?
> > >
> > > I just sent out a new version (v2), addressing an issue for the
> > > platform device when used for OF based platforms.
> > >
> > > If you prefer to not rebase/drop patches from your branch, I can send
> > > an incremental change on top instead, whatever you prefer.
> >
> > I will just revert these and then send it all on to Linus later today.
> > That way you can have the longer development cycle for better testing.
> 
> Alright!
> 
> Actually, reverting wasn't really necessary as the patches didn't
> break anything, just that v1 did fix the complete range of the
> problems.

This late in the cycle, reverting is probably best :)
