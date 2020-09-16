Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C27E26C605
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 19:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgIPR3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 13:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbgIPR3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 13:29:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C78CB222E9;
        Wed, 16 Sep 2020 17:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600277374;
        bh=HQY6xflJpGglMz2DK2M1DUuUcDJLXAWATVceoBo4lpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JxOxkRWzCmqKYWCniBPbpm3FXiu/KLwpWEqWj3tKAeJsXKgueUMnGBRcoSEMO0c4T
         DkuU7vAg928KDZPjrFYDafkJsF3Cv+8Oonlw41Icb807bQWxAGeqRyso7U0K9LS431
         rt0hHQwpi3DeLWphP7DefB94gGiXmGV8gdHyXqGE=
Date:   Wed, 16 Sep 2020 19:30:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Villalovos <jlvillal@os.amperecomputing.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/5] Add support needed for Renesas USB 3.0
 controller
Message-ID: <20200916173008.GA3068942@kroah.com>
References: <20200915213039.862123-1-jlvillal@os.amperecomputing.com>
 <20200916063116.GI142621@kroah.com>
 <e92b6d88-387b-1b06-9df1-49897145e0a7@os.amperecomputing.com>
 <20200916170821.GA3054459@kroah.com>
 <935e6153-f249-56ef-0696-f46968993038@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <935e6153-f249-56ef-0696-f46968993038@os.amperecomputing.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 10:15:12AM -0700, John Villalovos wrote:
> On 9/16/2020 10:08 AM, Greg KH wrote:
> > On Wed, Sep 16, 2020 at 09:54:50AM -0700, John Villalovos wrote:
> > > 
> > > On 9/15/2020 11:31 PM, Greg KH wrote:
> > > > On Tue, Sep 15, 2020 at 02:30:34PM -0700, John L. Villalovos wrote:
> > > > > Add support needed for the Renesas USB 3.0 controller
> > > > > (PD720201/PD720202).  Without these patches a system with this USB
> > > > > controller will crash during boot.
> > > > Is this a regression, or something that has always happened?  If a
> > > > regression, any pointers to what commit caused this?
> > > > 
> > > > this really feels like a "new feature" addition to me, unless this used
> > > > to work properly.
> > > 
> > > It is not a regression. It is a crash that occurs on new hardware that has
> > > this USB controller.
> > > 
> > > 
> > > Without this patch series, hardware with this USB controller will fail to
> > > work. So in the choice between "regression" and "new feature" I would say
> > > "new feature".
> > 
> > Ok, to support new hardware, use a newer kernel, no reason why 5.4 or
> > newer will not work here, right?
> 
> This is true, but some customers who want to use this hardware don't want
> (refuse) to use a new kernel :(

That's crazy, 4.19 should NOT be used for any system that requires new
hardware.  You all have read my "what kernel should I pick" guide,
right?

> Can I take this to mean that this patch series is not allowed to go into the
> stable kernel?

That is correct.  Use a newer kernel, it's much better overall.

Only reason you should be stuck on 4.19 at this point in time is if you
have an SoC with millions of out-of-tree lines added to it (making a
Linux-like system), or you are an "enterprise" distro and you are paying
for support for them.

Or you are using Debian, they know what they are doing there :)

thanks,

greg k-h
