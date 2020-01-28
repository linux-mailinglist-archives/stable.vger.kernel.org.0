Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D853514B091
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 08:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgA1Hw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 02:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgA1HwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 02:52:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F22332465B;
        Tue, 28 Jan 2020 07:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580197945;
        bh=BWZI1SGP7I1eCA0zPpPT/HaXMZfAirxOfLE9j6CTh44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DYRBxo04WvER8RAJItw6Ee7fLszcPEyzIHXO9zqfTT/ukSPDMDdbR9urYLclfRCWA
         mahd78FNLqfHeDsfo5/ShFFuqmfSvZtZOcYYbvXkgBjUJy6F4ZytBAV6PRN+kRUWTy
         VYbFyKd7I63kpTj+xxubCPXq8HjaEUrhsPZzYkpw=
Date:   Tue, 28 Jan 2020 08:52:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Noah Meyerhans <noahm@debian.org>
Cc:     stable@vger.kernel.org
Subject: Re: Please apply 50ee7529ec45 ("random: try to actively add entropy
 rather than passively wait for it") to 4.19.y
Message-ID: <20200128075223.GD2105706@kroah.com>
References: <20200127230214.GC25530@morgul.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127230214.GC25530@morgul.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 27, 2020 at 06:02:14PM -0500, Noah Meyerhans wrote:
> As detailed in https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=948519 and
> https://wiki.debian.org/BoottimeEntropyStarvation, lack of boot-time entropy
> can contribute to multi-minute pauses during system initialization in some
> hardware configurations.  While userspace workarounds, e.g. haveged, are
> documented, the in-kernel jitter entropy collector eliminates the need for such
> workarounds.
> 
> It cherry-picks cleanly to 4.19.y and 4.14.y.  I'm particularly interested
> in the former.
> 
> Thanks for considering this.

Please cc: the developers of that commit, and the maintainer of that
code, and we will be glad to consider it if they agree it is viable for
those kernels.

Personally, this looks like a "new feature" to me, if you really need
this, what is preventing you from moving to a newer kernel version?

thanks,

greg k-h
