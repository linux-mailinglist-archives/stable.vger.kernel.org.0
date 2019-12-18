Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 112801246B7
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 13:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfLRMX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 07:23:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfLRMX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 07:23:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A32921582;
        Wed, 18 Dec 2019 12:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576671807;
        bh=OIhlETukxqmmcn2ntslZDezXtG1c2lQqB+bonPynyW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eAAsTOXIm4AMtHCO0Us/JJGjAXbIBr5LvDGRPlXHfsyWZuJky6gjh+mtZ2HQ0Lj9P
         XccMOp3ZDMQ39qoMQQLfAmI4zkAu+NL0jsDm/70/EFRQLr6SSfzxU2BbMGa3qDDTs/
         WujGKyg5Tk7pbK8XByVf7JasCU04VZPGc6Dny/7o=
Date:   Wed, 18 Dec 2019 13:23:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND RESEND] media: uvc: Avoid cyclic entity chains due
 to malformed USB descriptors
Message-ID: <20191218122324.GB17086@kroah.com>
References: <20191108154838.21487-1-will@kernel.org>
 <20191108155503.GB15731@pendragon.ideasonboard.com>
 <20191216121651.GA12947@willie-the-truck>
 <CAAeHK+xdVmEFtK78bWd2Odn0uBynqnt5UT9jZJFvqGL=_9NU2w@mail.gmail.com>
 <20191218114137.GA15505@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218114137.GA15505@willie-the-truck>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 11:41:38AM +0000, Will Deacon wrote:
> On Mon, Dec 16, 2019 at 02:17:52PM +0100, Andrey Konovalov wrote:
> > On Mon, Dec 16, 2019 at 1:16 PM Will Deacon <will@kernel.org> wrote:
> > > On Fri, Nov 08, 2019 at 05:55:03PM +0200, Laurent Pinchart wrote:
> > > > Thank you for the patch.
> > > >
> > > > I'm sorry for the delay, and will have to ask you to be a bit more
> > > > patient I'm afraid. I will leave tomorrow for a week without computer
> > > > access and will only be able to go through my backlog when I will be
> > > > back on the 17th.
> > >
> > > Gentle reminder on this, now you've been back a month ;)
> > 
> > I think we now have a reproducer for this issue that syzbot just reported:
> > 
> > https://syzkaller.appspot.com/bug?extid=0a5c96772a9b26f2a876
> > 
> > You can try you patch on it :)
> 
> Oh wow, I *really* like the raw USB gadget thingy you have to reproduce
> these! I also really like that this patch fixes the issue. Logs below.

Ok, that's a good poke for me to go review that raw gadget code to see
if it can be merged upstream :)

> Laurent -- can we please merge this now?

Yes, that would be good to have, as this obviously fixes a problem, and
I can take it off of my "patches to track" list....

thanks,

greg k-h
