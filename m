Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F9C2A004D
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 09:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgJ3Is2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 04:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3Is2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 04:48:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C680A20704;
        Fri, 30 Oct 2020 08:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604047707;
        bh=EoamfXZEZdx3YAhsBX1sTng3tOL0F7DLpmSrdtkTeP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OfMxO/rhyMJ79ZUGEYLTOIagmd8co1r2I3yZbdaBpsQmFpJE/F+RP+bhPV95J7nnt
         w4xdWSmju3P+GN11oGQD35d7/SAyXm+DrQOJUQh4PTeywSoyS582fQXF646YMIF+lt
         JTcDHXBDmdlT4vODjMhLLanaDXtxq7qwEz4nG1PY=
Date:   Fri, 30 Oct 2020 09:49:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.19.153
Message-ID: <20201030084915.GB1625087@kroah.com>
References: <160396822019115@kroah.com>
 <20201030082653.GA29475@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030082653.GA29475@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 09:26:54AM +0100, Pavel Machek wrote:
> Hi!
> 
> > I'm announcing the release of the 4.19.153 kernel.
> > 
> > All users of the 4.19 kernel series must upgrade.
> > 
> > The updated 4.19.y git tree can be found at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
> > and can be browsed at the normal kernel.org git web browser:
> > 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> Did something go seriously wrong here?
> 
> The original 4.19.153-rc1 series had 264 patches. "powerpc/tau: Remove
> duplicated set_thresholds() call" is 146/264 of the series, but it is
> last one in 4.19.153 as released. "178/264 ext4: limit entries
> returned when counting...", for example, is not present in
> 4.19.153... as are others, for example "net: korina: cast KSEG0
> address to pointer in kfree". Looks like 118 or so patches are
> missing.
> 
> They are not in origin/queue/4.19, either.

Wow, something did go wrong here, thanks for catching this.

Let me dig and see what happened, the whole series did not apply, which
makes me wonder if the same thing happened for other branches as well...

thanks for checking up and finding this.

Give me a bit...

greg k-h
