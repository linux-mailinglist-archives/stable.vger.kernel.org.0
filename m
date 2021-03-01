Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BDE327C05
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhCAKZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:25:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:32778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234241AbhCAKZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 05:25:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1ED5601FE;
        Mon,  1 Mar 2021 10:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614594283;
        bh=FK/AThtBxITI//ZD/oP1uszU74a03b0Ho7NJTF0EuvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G4RWutD39b7bC3hnooLgtMNpcm/C0ne99k5IiETsqkGCQvDnvryVbUIQRJd7IYtNe
         uykb0yJhX3cZTIpLctmcVwhGxz6j6+TnlOzvttvWYfQ0EGW2+500moyqpah+5PevoK
         QOpWeRdFO1e0ceBpYiB+4q01Z3SAtfCMiQIstuWg=
Date:   Mon, 1 Mar 2021 11:24:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Diego Calleja <diegocg@gmail.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: -stable regression in Intel graphics, introduced in Linux 5.10.9
Message-ID: <YDzA6LMG6rUxJXWP@kroah.com>
References: <3423617.kz1aARBMGD@archlinux>
 <1911334.sV3ZJath2r@archlinux>
 <YDyvNoiRAQwT4boR@kroah.com>
 <1969510.QSeQnKm9EC@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1969510.QSeQnKm9EC@archlinux>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 11:11:13AM +0100, Diego Calleja wrote:
> El lunes, 1 de marzo de 2021 10:09:10 (CET) Greg KH escribió:
> > I do not see all 3 commits in Linus's tree already, am I missing
> > something?
> > 
> > What are the git ids that you are looking at?
> 
> I used grep on the git log, the commits are there but seem to have different commit ids (except for the first one)
> 
> commit e627d5923cae93fa4188f4c4afba6486169a1337
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Tue Jan 19 11:07:57 2021 +0000
> 
>     drm/i915/gt: One more flush for Baytrail clear residuals
> 
> 
> commit d5109f739c9f14a3bda249cb48b16de1065932f0
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Mon Jan 25 22:02:47 2021 +0000
> 
>     drm/i915/gt: Flush before changing register state
> 
> 
> commit 81ce8f04aa96f7f6cae05770f68b5d15be91f5a2
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Wed Feb 10 12:27:28 2021 +0000
> 
>     drm/i915/gt: Correct surface base address for renderclear
> 
> 

Ugh, have I mentioned recently just how badly I think the drm developers
handle their git trees?  It's a constant mess to unwind that stuff...

{sigh}

Now queued up.

greg k-h
