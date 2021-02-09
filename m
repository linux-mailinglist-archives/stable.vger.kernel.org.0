Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF7C3150B3
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 14:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhBINqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 08:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231309AbhBINpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 08:45:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17EA264E0D;
        Tue,  9 Feb 2021 13:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612878262;
        bh=4h3GT5egqwm04FikNjpgIj9VjhyE6EXY+YLLVJe3RDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R2CGMQtHpql1DsKZunw3zR/88ekQ3bGZVifWAMMQZbcrbzj/NWABv4t2+iLdPa4Ds
         NRMF3396ygWqbmUrt8D+qmg4vU9yS+mGNxsjtQwIMgTCfQR2WtsCCR1yVA/CLLJqq8
         p616TPIdWDd8m/vaNxp8Utv+/hyTawkZFCMFcVp4=
Date:   Tue, 9 Feb 2021 14:44:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devel@driverdev.osuosl.org,
        Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 14/36] media: rkisp1: uapi: change hist_bins
 array type from __u16 to __u32
Message-ID: <YCKRsxE23f7zJtkO@kroah.com>
References: <20210208175806.2091668-1-sashal@kernel.org>
 <20210208175806.2091668-14-sashal@kernel.org>
 <12c8f50e-3bba-5936-6e67-55bd928a75c7@xs4all.nl>
 <e086d0f4-c5f0-e38c-8937-593852ac0b50@collabora.com>
 <YCKH0HvTxeYKg1xf@kroah.com>
 <3413d0af-bc8e-4a9d-e0a2-eea98febd4e9@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3413d0af-bc8e-4a9d-e0a2-eea98febd4e9@xs4all.nl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 02:39:41PM +0100, Hans Verkuil wrote:
> On 09/02/2021 14:02, Greg Kroah-Hartman wrote:
> > On Tue, Feb 09, 2021 at 01:45:35PM +0100, Dafna Hirschfeld wrote:
> >>
> >>
> >> Am 08.02.21 um 21:46 schrieb Hans Verkuil:
> >>> On 08/02/2021 18:57, Sasha Levin wrote:
> >>>> From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
> >>>>
> >>>> [ Upstream commit 31f190e0ccac8b75d33fdc95a797c526cf9b149e ]
> >>>>
> >>>> Each entry in the array is a 20 bits value composed of 16 bits unsigned
> >>>> integer and 4 bits fractional part. So the type should change to __u32.
> >>>> In addition add a documentation of how the measurements are done.
> >>>
> >>> Dafna, Helen, does it make sense at all to backport these three patches to
> >>> when rkisp1 was a staging driver?
> >>>
> >>> I would be inclined not to backport this.
> >>
> >> I also don't think it makes sense since this changes the uapi and it is not really a bug fix.
> > 
> > Why was it ok to change the uapi in a newer kernel and not an older one?
> 
> In the older kernels this was a staging driver and the driver API was not public.
> It's debatable whether there is any benefit from trying to backport patches like
> this to a staging driver like that.
> 
> Also, these backports are incomplete, there are other patches that would need to
> be applied to make this work. Applying just these three patches without the other
> three (commits 66d81de7ea9d, fc672d806bd7 and ef357e02b6c4) makes it very messy
> indeed.
> 
> I'd just leave the staging driver in older kernels as-is. Certainly don't just
> apply these three patches without the other three commits, that would make it
> even worse.

Fair enough, Sasha, can you drop these?

thanks,

greg k-h
