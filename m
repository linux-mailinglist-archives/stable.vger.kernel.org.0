Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39992444767
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhKCRrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:47:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhKCRrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 13:47:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D73160F58;
        Wed,  3 Nov 2021 17:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635961504;
        bh=PUS8nqosCs6ac/036S10fd9qEnRt0zfLj7ps/bMIqfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gkfyO+o+2meqGby2ZYSIJr5u0rBUMmm6yFjWCFI2ecnIo1/57uA2zkaWvk8kDpc/u
         i/2bMmVLGC+3PKKBka2XMvPoB0Cwoh39AD/fNr7hHzktHZX8HqG7ZoTHutnoWf059w
         0lV4/UUvgIn7Rt7E5BIRNsMsvAAdbr6oq7+DJsKc=
Date:   Wed, 3 Nov 2021 18:45:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: 5.14.14+ USB regression caused by "usb: core: hcd: Add support
 for deferring roothub registration" series
Message-ID: <YYLKngiZxyqARmvL@kroah.com>
References: <42bcbea6-5eb8-16c7-336a-2cb72e71bc36@redhat.com>
 <YYJRRg8QDBfy2PP7@kroah.com>
 <9e1abe71-d903-f227-38ae-a854ab9e5baf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e1abe71-d903-f227-38ae-a854ab9e5baf@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 01:48:11PM +0100, Hans de Goede wrote:
> Hi,
> 
> On 11/3/21 10:07, Greg Kroah-Hartman wrote:
> > On Wed, Nov 03, 2021 at 10:02:52AM +0100, Hans de Goede wrote:
> >> Hi Greg,
> >>
> >> We (Fedora) have been receiving multiple reports about USB devices stopping
> >> working starting with 5.14.14 .
> >>
> >> An Arch Linux user has found that reverting the first 2 patches from this series:
> >> https://lore.kernel.org/all/20210909064200.16216-1-kishon@ti.com/
> >>
> >> Fixes things (the 3th patch is just some mostly unrelated refactoring/cleanup).
> >>
> >> See here for the Arch-linux discussion surrounding this:
> >> https://bbs.archlinux.org/viewtopic.php?pid=2000956#p2000956
> >>
> >> And here are 2 Fedora bug reports of Fedora users being unable to use their
> >> machines due their mouse + kbd not working:
> >>
> >> https://bugzilla.redhat.com/show_bug.cgi?id=2019542
> >> https://bugzilla.redhat.com/show_bug.cgi?id=2019576
> >>
> >> Can we get this patch-series reverted from the 5.14.y releases please ?
> > 
> > Sure,
> 
> Thanks.
> 
> > but can you also submit patches to get into 5.15.y and 5.16-rc1
> > that revert these changes as they should still be an issue there, right?
> 
> Yes I assume this is still an issue there too, but I was hoping that
> Kishon can take a look and maybe actually fix things, since just
> reverting presumably regresses whatever these patches were addressing.
> 
> We've aprox 1-3 weeks before distros like Arch and Linux will switch
> to 5.15.y kernels.  So we have some time to come up with a fix
> there, where as for 5.14.y this is hitting users now.

I've reverted them from all stable kernels for now.  Unless this gets
figured out by 5.16-rc1, I will revert it from there then as well.

thanks,

greg k-h
