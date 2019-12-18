Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5AE124E5C
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 17:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLRQwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 11:52:05 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49602 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfLRQwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 11:52:05 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9AA08B23;
        Wed, 18 Dec 2019 17:52:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1576687923;
        bh=5KtW9miUkrXGglIuVsNTuuwF8SSX51r9izKBn20t7LE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VCsXwXV+IB2g0GElTKvjl0oUCmo6qFhzjZ69EwIbvrkXDNcOkkpsT5B4b3Qy0xg7p
         Y5CX2xfZIhpu9uicKc373knwBPkSOtJv7foNQky6Ks6L/YYm9mWPkfGt5776GUwy9R
         3u0lVgCEFa9X7tx7PvFp8FsCQ5m8GstAK/W+eqhY=
Date:   Wed, 18 Dec 2019 18:51:53 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND RESEND] media: uvc: Avoid cyclic entity chains due
 to malformed USB descriptors
Message-ID: <20191218165153.GC17876@pendragon.ideasonboard.com>
References: <20191108154838.21487-1-will@kernel.org>
 <20191108155503.GB15731@pendragon.ideasonboard.com>
 <20191216121651.GA12947@willie-the-truck>
 <CAAeHK+xdVmEFtK78bWd2Odn0uBynqnt5UT9jZJFvqGL=_9NU2w@mail.gmail.com>
 <20191218114137.GA15505@willie-the-truck>
 <20191218122324.GB17086@kroah.com>
 <CAAeHK+xyv-x6ejwcqNAn=5eKoBYPkJsN=SgJLHJ1ey=6v+YyyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAeHK+xyv-x6ejwcqNAn=5eKoBYPkJsN=SgJLHJ1ey=6v+YyyA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 01:46:00PM +0100, Andrey Konovalov wrote:
> On Wed, Dec 18, 2019 at 1:23 PM Greg Kroah-Hartman wrote:
> > On Wed, Dec 18, 2019 at 11:41:38AM +0000, Will Deacon wrote:
> >> On Mon, Dec 16, 2019 at 02:17:52PM +0100, Andrey Konovalov wrote:
> >>> On Mon, Dec 16, 2019 at 1:16 PM Will Deacon <will@kernel.org> wrote:
> >>>> On Fri, Nov 08, 2019 at 05:55:03PM +0200, Laurent Pinchart wrote:
> >>>>> Thank you for the patch.
> >>>>>
> >>>>> I'm sorry for the delay, and will have to ask you to be a bit more
> >>>>> patient I'm afraid. I will leave tomorrow for a week without computer
> >>>>> access and will only be able to go through my backlog when I will be
> >>>>> back on the 17th.
> >>>>
> >>>> Gentle reminder on this, now you've been back a month ;)
> >>>
> >>> I think we now have a reproducer for this issue that syzbot just reported:
> >>>
> >>> https://syzkaller.appspot.com/bug?extid=0a5c96772a9b26f2a876
> >>>
> >>> You can try you patch on it :)
> >>
> >> Oh wow, I *really* like the raw USB gadget thingy you have to reproduce
> >> these! I also really like that this patch fixes the issue. Logs below.
> 
> Thanks! An easier way to test the patch would be to issue a syz test
> command, but I'm glad you managed to set up raw gadget manually and it
> worked for you.
> 
> >
> > Ok, that's a good poke for me to go review that raw gadget code to see
> > if it can be merged upstream :)
> 
> Looking forward to it! =)

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and merged in my tree. I'm so sorry for the way too long delay.

> >> Laurent -- can we please merge this now?
> >
> > Yes, that would be good to have, as this obviously fixes a problem, and
> > I can take it off of my "patches to track" list....

-- 
Regards,

Laurent Pinchart
