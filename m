Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9708629EA7E
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgJ2L3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 07:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgJ2L3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 07:29:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A086B2076E;
        Thu, 29 Oct 2020 11:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603970990;
        bh=MTjIkXr3NnrpMfTDAn9/ha1Br4t8KXcW4JAFcRvu3Ig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DV7fA6WBexJy/iN1X1aDDm4cJFQlw7gxjsVOgkmKUipGPBoxOA/PiYBRxhsz2exXQ
         fbQ7kPsunyU62GNInG9pNWRcQABqdZ+fBYdIJW9Ab/jaXVo172X7t60G3OKqyLufjt
         LUF7nw+B1uAXci128tghenvna7XpAobxM90UBxHY=
Date:   Thu, 29 Oct 2020 12:30:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        linux-fbdev@vger.kernel.org, b.zolnierkie@samsung.com,
        daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gustavoars@kernel.org,
        dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        akpm@linux-foundation.org, rppt@kernel.org
Subject: Re: [PATCH 1/1] video: fbdev: fix divide error in fbcon_switch
Message-ID: <20201029113040.GA3850079@kroah.com>
References: <20201021235758.59993-1-saeed.mirzamohammadi@oracle.com>
 <ad87c5c1-061d-8a81-7b2c-43a8687a464f@suse.de>
 <3294C797-1BBB-4410-812B-4A4BB813F002@oracle.com>
 <20201027062217.GE206502@kroah.com>
 <2DA9AE6D-93D6-4142-9FC4-EEACB92B7203@oracle.com>
 <20201029110326.GC3840801@kroah.com>
 <874kmdi8ua.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874kmdi8ua.fsf@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 01:13:01PM +0200, Jani Nikula wrote:
> On Thu, 29 Oct 2020, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Oct 27, 2020 at 10:12:49AM -0700, Saeed Mirzamohammadi wrote:
> >> Hi Greg,
> >> 
> >> Sorry for the confusion. I’m requesting stable maintainers to cherry-pick this patch into stable 5.4 and 5.8.
> >> commit cc07057c7c88fb8eff3b1991131ded0f0bcfa7e3
> >> Author: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> >> Date:   Wed Oct 21 16:57:58 2020 -0700
> >> 
> >>     video: fbdev: fix divide error in fbcon_switch
> >
> > I do not see that commit in Linus's tree, do you?
> 
> It's in drm-misc-next, IIUC heading for Linus' tree in the next merge
> window in 6-8 weeks. Which is to say this should probably have been
> applied to drm-misc-fixes branch heading for v5.10-rcX, with a Cc:
> stable tag, to begin with.

Ok, nothing I can do with this now, please email stable@vger.kernel.org
when it hits Linus's tree and we can take it then.

Saeed, please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

thanks,

greg k-h
