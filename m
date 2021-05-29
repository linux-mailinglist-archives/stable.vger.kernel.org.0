Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A09394A93
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 07:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhE2Fau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 01:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhE2Fau (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 May 2021 01:30:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A312E6128D;
        Sat, 29 May 2021 05:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622266154;
        bh=vUcwMg0oxT4K5R8nTbh3KdbXpvAddhf1SbDPcXhNnP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tm2hPmeU/sfWm5aTQ0V0BHRISk6rF/ZIbPTPWt29w3f4Id/gQ9YdmqBW65i44OyJS
         2EM6N+Zc20RMOtzi6m7ywS4uo3qc8qh3znhmUzeuLNV/a5xgl5FSXBIbWelFTbXVhU
         kIqSWNfNJY5V9KIYsybERb2CoZTeQFYqg1arpRQ8=
Date:   Sat, 29 May 2021 07:29:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Subject: Re: [CI] drm/i915: Disable atomics in L3 for gen9
Message-ID: <YLHRKI+RZ0nvIe/P@kroah.com>
References: <20210528172543.GA7385@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528172543.GA7385@fieldses.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 28, 2021 at 01:25:43PM -0400, J. Bruce Fields wrote:
> Would it be possible to apply
> 
> 	58586680ffad "drm/i915: Disable atomics in L3 for gen9"
> 
> to stable kernels?
> 
> I'm finding it quite easy to crash my Thinkpad X1 Carbon 6th gen with
> Blender on Fedora 34 (which is using the 5.11.y kernels).  It applies
> cleanly, and I've been running 5.11.16 with the patch applied and seeing
> no obvious ill effects.

As 5.11.y is now end-of-life, and has been for a week or so, what
kernel(s) would you want this applied to given that 5.12.y is the latest
stable kernel tree?

What prevents you from moving to 5.12.y now?

thanks,

greg k-h
