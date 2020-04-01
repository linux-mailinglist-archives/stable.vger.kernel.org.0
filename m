Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE6219A515
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 08:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbgDAGH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 02:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731721AbgDAGH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 02:07:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 208292077D;
        Wed,  1 Apr 2020 06:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585721247;
        bh=NB8w8IwU3SCR56lY9A59ZGC5pvUvYquixCCcxJyRYaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oaXxetyfZQYBd2I/Oz1Yp+1rPTXZ18XqvCXScQFZgmJzbLtfz/jRzR5NiGqqFYVCn
         GukqF/bDXRRlTnySgojjWaxw4cOCmmq3pBEhQBtaJM2z45LpMt4k9A6RJHYHxP1+bC
         kdqlEo7biKH+dgxjpTLoWPxf+sMiT7EV7kALBglY=
Date:   Wed, 1 Apr 2020 08:07:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Barre <ludovic.barre@st.com>,
        "# 4.0+" <stable@vger.kernel.org>
Subject: Re: patch "driver core: platform: Initialize dma_parms for platform
 devices" added to char-misc-testing
Message-ID: <20200401060720.GA1904908@kroah.com>
References: <158523473532132@kroah.com>
 <CAPDyKFr0Em0-8RX3TnuRTiEEX6qs3Lu+SxFufmv5Mx6_6606=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFr0Em0-8RX3TnuRTiEEX6qs3Lu+SxFufmv5Mx6_6606=g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 08:43:25PM +0200, Ulf Hansson wrote:
> On Thu, 26 Mar 2020 at 15:58, <gregkh@linuxfoundation.org> wrote:
> >
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     driver core: platform: Initialize dma_parms for platform devices
> >
> > to my char-misc git tree which can be found at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
> > in the char-misc-testing branch.
> >
> > The patch will show up in the next release of the linux-next tree
> > (usually sometime within the next 24 hours during the week.)
> >
> > The patch will be merged to the char-misc-next branch sometime soon,
> > after it passes testing, and the merge window is open.
> >
> > If you have any questions about this process, please let me know.
> 
> Greg, would you mind dropping this one and the other patch for the amba bus?
> 
> I just sent out a new version (v2), addressing an issue for the
> platform device when used for OF based platforms.
> 
> If you prefer to not rebase/drop patches from your branch, I can send
> an incremental change on top instead, whatever you prefer.

I will just revert these and then send it all on to Linus later today.
That way you can have the longer development cycle for better testing.

thanks,

greg k-h
