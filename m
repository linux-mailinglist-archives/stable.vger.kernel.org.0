Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABBD44605F
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 08:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhKEH7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 03:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhKEH7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 03:59:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E1AE6023B;
        Fri,  5 Nov 2021 07:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636099031;
        bh=p6ypVVVM5zrINRoLDSki31w3j0jWMh8NaTFkXgRDWwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DxsdexoiPWRNQ4V++/JdtuSQ660hQI0Tw53+OEPvm1BV/Xcb7V+WjkXeuGnShNTKg
         yHjs5VkXPPy1wqoAPSbwRogXZleY+gT/EoMa+ORAVBYFnoT4uxHVe7TdmOPj36rkEB
         VEgzhPj8Q9VZeHQg5V0AQ5eBViw1B5x9MpIBrT78=
Date:   Fri, 5 Nov 2021 08:57:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: 5.14.14+ USB regression caused by "usb: core: hcd: Add support
 for deferring roothub registration" series
Message-ID: <YYTj1MfWmVgXakIr@kroah.com>
References: <42bcbea6-5eb8-16c7-336a-2cb72e71bc36@redhat.com>
 <YYJRRg8QDBfy2PP7@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYJRRg8QDBfy2PP7@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 10:07:18AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 03, 2021 at 10:02:52AM +0100, Hans de Goede wrote:
> > Hi Greg,
> > 
> > We (Fedora) have been receiving multiple reports about USB devices stopping
> > working starting with 5.14.14 .
> > 
> > An Arch Linux user has found that reverting the first 2 patches from this series:
> > https://lore.kernel.org/all/20210909064200.16216-1-kishon@ti.com/
> > 
> > Fixes things (the 3th patch is just some mostly unrelated refactoring/cleanup).
> > 
> > See here for the Arch-linux discussion surrounding this:
> > https://bbs.archlinux.org/viewtopic.php?pid=2000956#p2000956
> > 
> > And here are 2 Fedora bug reports of Fedora users being unable to use their
> > machines due their mouse + kbd not working:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=2019542
> > https://bugzilla.redhat.com/show_bug.cgi?id=2019576
> > 
> > Can we get this patch-series reverted from the 5.14.y releases please ?
> 
> Sure, but can you also submit patches to get into 5.15.y and 5.16-rc1
> that revert these changes as they should still be an issue there, right?

I've reverted these in my tree now so that the revert will get into
5.16-rc1.

thanks,

greg k-h
