Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6BE247F43
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 09:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHRHTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 03:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgHRHTo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 03:19:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D37020674;
        Tue, 18 Aug 2020 07:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597735184;
        bh=ndDr5gBeXa2DhedJSq6jsY4W3eu+OkBDVTlHft298h8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N78mL0//T89hewnNTcx5QkD9m1oUP08Li1k258M+ZUfWRgdIve7my8dv1l5M29e9o
         2UHwIEG8r+M0jfxq0cvaEEIDLB7zY0dHj0ImlNsd5OjmsRlKRIfX/b242B/uodffRa
         y3t3Ksv9u02kMsH7X8QgwKXJV85vf5Sa0j8Y0bbE=
Date:   Tue, 18 Aug 2020 09:20:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     davem@davemloft.net, tim.froidcoeur@tessares.net,
        stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: Patch "net: refactor bind_bucket fastreuse into helper" has been
 added to the 4.14-stable tree
Message-ID: <20200818072007.GA9254@kroah.com>
References: <159765838685222@kroah.com>
 <9f27fa03-b205-9195-758c-c9c67b384a21@tessares.net>
 <20200818070831.GB3333@kroah.com>
 <bf040796-d96b-d9a3-589f-317eed1e299b@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf040796-d96b-d9a3-589f-317eed1e299b@tessares.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 09:11:36AM +0200, Matthieu Baerts wrote:
> On 18/08/2020 09:08, Greg KH wrote:
> > On Mon, Aug 17, 2020 at 09:28:48PM +0200, Matthieu Baerts wrote:
> > > Hi Greg,
> > > 
> > > On 17/08/2020 11:59, gregkh@linuxfoundation.org wrote:
> > > > 
> > > > This is a note to let you know that I've just added the patch titled
> > > > 
> > > >       net: refactor bind_bucket fastreuse into helper
> > > > 
> > > > to the 4.14-stable tree which can be found at:
> > > >       http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > > 
> > > > The filename of the patch is:
> > > >        net-refactor-bind_bucket-fastreuse-into-helper.patch
> > > > and it can be found in the queue-4.14 subdirectory.
> > > > 
> > > > If you, or anyone else, feels it should not be added to the stable tree,
> > > > please let <stable@vger.kernel.org> know about it.
> > > 
> > > (...)
> > > 
> > > > Patches currently in stable-queue which might be from tim.froidcoeur@tessares.net are
> > > > 
> > > > queue-4.14/net-refactor-bind_bucket-fastreuse-into-helper.patch
> > > 
> > > Thank you for backporting this patch!
> > > 
> > > It seems the backport of the companion patch -- d76f3351cea2 ("net:
> > > initialize fastreuse on inet_inherit_port") -- was lost somewhere for 4.14
> > > version. It was backported in all other newer stable versions: 5.8, 5.7,
> > > 5.4, 4.19 but not in 4.14.
> > > The patch backported here is a preparation for the real fix which is the
> > > missing patch.
> > > 
> > > I guess the intention is to backport d76f3351cea2 to v4.14 as well. If not,
> > > this refactoring is maybe not needed :)
> > 
> > Ugh, that was my fault, thanks for catching this.  I've now queued this
> > up to 4.14.y.
> 
> Thank you for having added it!
> 
> All these backported patches look good to me!

Thanks for checking.

I stopped at 4.14.y as the code for 4.9.y and 4.4.y changed a bunch in
this area, do you think it's worth doing the backport to those really
old kernels?  If not, no big deal, I figured I would ask, as I couldn't
tell how realistic devices running them would hit this issue.

thanks,

greg k-h
