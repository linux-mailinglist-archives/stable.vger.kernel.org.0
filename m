Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A66C77F49
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 13:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfG1Llq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 07:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbfG1Llq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 07:41:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9942075B;
        Sun, 28 Jul 2019 11:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564314105;
        bh=v69FRAAQnIURGWg+sOI65FJv+CPdwkJioM6i99zqd2I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F1o49gpsPGrHMyZwTZvQwK5VIN4Dus2wkSx8lWM7/3iBIIZ1av+DJVPPB/6z6/aky
         HKiUKPKjfb63kyjlEyqJvA9tzuXnhq1AkssT5xcyTQ6F/HhyL1eI4JHkft66ZCEHO8
         1wMuBZG+OzovPFgX2RlCfpW+V/cPEKedoI+jnT/M=
Date:   Sun, 28 Jul 2019 13:41:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Maik Stohn <maik.stohn@seal-one.com>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        nsaenzjulienne@suse.de, stable@vger.kernel.org
Subject: Re: patch "xhci: Fix crash if scatter gather is used with Immediate
 Data" added to usb-linus
Message-ID: <20190728114142.GA12033@kroah.com>
References: <1564046825237139@kroah.com>
 <0430A0F6-6777-4EC3-B0D6-BBAF3AAF900C@seal-one.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0430A0F6-6777-4EC3-B0D6-BBAF3AAF900C@seal-one.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 28, 2019 at 01:25:32PM +0200, Maik Stohn wrote:
> Hello Greg,
> 
> Sorry to trouble you again.
> 
> I was waiting and observing how the FIX is applied and it looks like
> it will not be applied to 5.2.x (5.2.3 and 5.2.4 came out without this
> patch).
> Personally I think it is a big mistake not to merge the fix but this
> is your decision. 
> 
> I have to tell my users now to AVOID KERNEL 5.2 at all since it is
> buggy and most likely will never be fixed.
> 
> But since it is also not part of any 5.3 (right now) I'm a bit afraid
> I also need to put a warning to avoid 5.3 as well.
> 
> Would be nice to get an official statement like: "Linux kernel will
> not merge the USB fix to 5.2, maybe 5.3 will have it, but better wait
> for 5.4", so I can quote this to my users.

How about an official statement like "wait a week please" :)

Or, "if you have problems, please apply this patch."

We _just_ found the fix, it _just_ went into my tree a few days ago.  A
patch can not be in a stable kernel until it shows up in Linus's kernel,
in a release (like a -rc).

So, ideally this patch gets into 5.3-rc2.  Then I can add it to the
queue of patches to go into the 5.2.y release, which should happen
sometime next week or the week after at worst case.

Please read Documentation/process/ for how all of this works if you are
curious, we have tests to pass, releases to make it through, and reviews
to happen here.  Give us a chance please, there is no major rush.  And
if there is a rush, you have the fix to apply to your kernel to solve
the problem!  You are not dependant on any of us here anymore, anyone
can patch their machines if they run into this issue and can not wait a
week or so.

Also, odds are that most people are even running the 5.2.y kernel yet is
pretty low... :)

So, again, patience.  Your fix is just one of hundreds winding its way
through the ether to get out to users.  You are not alone, and at the
same time, not special.  It will happen, just relax.

greg k-h
