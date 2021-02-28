Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA25327367
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 17:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhB1Q6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 11:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230458AbhB1Q6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Feb 2021 11:58:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC95364E4A;
        Sun, 28 Feb 2021 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614531453;
        bh=elywOISqfW65pI9FKoAX66OzSCyJWWigVNSkKoFG1bQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KEjl6dczglM2Qu32+hR4X5/6TO3jX5BMZyC4Kb8Inj/D5+Gd72UCJwvf3JxionpWZ
         tiHspstoFN6hEsU/xpZmelxykHOEZjMB7phV6mO956puoX/WViw543AnWJ+OBz+Zeb
         qHkMqOYSCL8GhxtxexaQwu04ANe5KNbfnkHMlG88=
Date:   Sun, 28 Feb 2021 17:57:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Diego Calleja <diegocg@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] -stable regression in Intel graphics, introduced in
 Linux 5.10.9
Message-ID: <YDvLeslGElXdjf2t@kroah.com>
References: <3423617.kz1aARBMGD@archlinux>
 <YDuzbvIjMO5mFcYm@kroah.com>
 <e662d6bf-53e3-9774-37db-9e7ea88a4ec9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e662d6bf-53e3-9774-37db-9e7ea88a4ec9@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 28, 2021 at 05:28:06PM +0100, Hans de Goede wrote:
> Hi,
> 
> On 2/28/21 4:14 PM, Greg KH wrote:
> > On Sun, Feb 28, 2021 at 03:29:07PM +0100, Diego Calleja wrote:
> >> Hi,
> >>
> >> There is a regression in Linux 5.10.9 that does not happen in 5.10.8. It is still there as
> >> of 5.11.1
> > 
> > Is this the same issue reported here:
> > 	https://lore.kernel.org/r/f1070486-891a-8ec0-0390-b9aeb03178ce@redhat.com
> > ?
> > 
> > If so, is this a problem in 5.11 as well?
> 
> I see in the original email:
> https://lore.kernel.org/stable/3423617.kz1aARBMGD@archlinux/
> 
> That Diego is using the iGPU part of a Haswell CPU, so yes this is almost
> certainly the same issue.
> 
> Diego as I already mentioned to another arch user, it would be good if the
> arch kernel-maintainers can pick-up these 3 commits from the drm-intel tree
> as downstream patches for now:
> 
> e627d5923cae ("drm/i915/gt: One more flush for Baytrail clear residuals")
> d30bbd62b1bf ("drm/i915/gt: Flush before changing register state")
> 1914911f4aa0 ("drm/i915/gt: Correct surface base address for renderclear")
> 
> We (Fedora) have added these as downstream patches for now and we have
> multiple reports that these resolve the problem.
> 
> Chris, can you please send the 2nd and 3th commit of the above list on
> their way to Linus ASAP, so that Greg can add them to the stable series?
> 
> ATM only the 1st commit is in Linus tree (unless the others have landed
> with different hashes?)

I have queued the first one up now, thanks.

greg k-h
