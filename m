Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E567B3829D0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236334AbhEQKan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236315AbhEQKan (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 06:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9801F61184;
        Mon, 17 May 2021 10:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621247367;
        bh=cTFdwPsJbINdMpD2LNRDK8Q0vyJ8F8wDU5WSk6Vo52U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RYc+1zE11r3x8gyAl702ZjX9XpMKw0TlncBBDhrWWsYStYYdflDs98ngVm1DbtQio
         VkKLUsFdJXzAizjxdBE4ii0rs07M6ISxKj7M1XEGuyYMi8XNBPaO3uiBtsJ6o2mPJV
         iMvCE0xmWLwgrRNEstXbnWmywPhHjXA6gBLCxiO4=
Date:   Mon, 17 May 2021 12:29:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukasz Luba <lukasz.luba@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        daniel.lezcano@linaro.org, rui.zhang@intel.com
Subject: Re: [STABLE][PATCH 4.4] thermal/core/fair share: Lock the thermal
 zone while looping over instances
Message-ID: <YKJFhW+ByGl3/zSC@kroah.com>
References: <20210514104916.19975-1-lukasz.luba@arm.com>
 <YJ5XTW9TYvv7wYr6@kroah.com>
 <12419f82-3efa-7587-da50-4edf7eef99e1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12419f82-3efa-7587-da50-4edf7eef99e1@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14, 2021 at 11:58:10AM +0100, Lukasz Luba wrote:
> 
> 
> On 5/14/21 11:56 AM, Greg KH wrote:
> > On Fri, May 14, 2021 at 11:49:16AM +0100, Lukasz Luba wrote:
> > > commit fef05776eb02238dcad8d5514e666a42572c3f32 upstream.
> > > 
> > > The tz->lock must be hold during the looping over the instances in that
> > > thermal zone. This lock was missing in the governor code since the
> > > beginning, so it's hard to point into a particular commit.
> > > 
> > > CC: stable@vger.kernel.org # 4.4
> > > Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
> > > ---
> > > Hi all,
> > > 
> > > I've backported my patch which was sent to LKML:
> > > https://lore.kernel.org/linux-pm/20210422153624.6074-2-lukasz.luba@arm.com/
> > > 
> > > The upstream patch failed while applying:
> > > https://lore.kernel.org/stable/16206371483193@kroah.com/
> > > 
> > > This patch should apply to stable v4.4.y, on top of stable tree branch:
> > > linux-4.4.y which head was at:
> > > commit 47127fcd287c ("Linux 4.4.268")
> > 
> > What about 4.9, 4.14, 4.14, and 5.4 releases?  They need this fix as
> > well, right?
> 
> s/4.14/4.19
> 
> Yes, I'm going to send them in next few hours after building and
> testing.

All now queued up, thanks.

greg k-h
