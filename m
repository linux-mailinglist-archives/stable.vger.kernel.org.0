Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61257314FB4
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 14:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhBINC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 08:02:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230470AbhBINCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 08:02:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACCEC64E75;
        Tue,  9 Feb 2021 13:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612875731;
        bh=/Me+7Kp4JW3Y1A7KUFx3KcdF6XAOxqCUi6IcZfTyxrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jLTExcCLBH7WheJBZQ5S0RePJQet3Yt4yzTvMxtzy17ZPNcpv9XUzMvNhNqZqAlN/
         QcsM9TB6q/6DP5A6Q0uhWHweiv0yxIkpcY5o+iOyzpXFXBGkN3MkMRbPk9Ml2tHaIZ
         P46V3Blimx+4djJUl0gbR3wpdHfyXV4U4eftNzis=
Date:   Tue, 9 Feb 2021 14:02:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devel@driverdev.osuosl.org,
        Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 14/36] media: rkisp1: uapi: change hist_bins
 array type from __u16 to __u32
Message-ID: <YCKH0HvTxeYKg1xf@kroah.com>
References: <20210208175806.2091668-1-sashal@kernel.org>
 <20210208175806.2091668-14-sashal@kernel.org>
 <12c8f50e-3bba-5936-6e67-55bd928a75c7@xs4all.nl>
 <e086d0f4-c5f0-e38c-8937-593852ac0b50@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e086d0f4-c5f0-e38c-8937-593852ac0b50@collabora.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 01:45:35PM +0100, Dafna Hirschfeld wrote:
> 
> 
> Am 08.02.21 um 21:46 schrieb Hans Verkuil:
> > On 08/02/2021 18:57, Sasha Levin wrote:
> > > From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
> > > 
> > > [ Upstream commit 31f190e0ccac8b75d33fdc95a797c526cf9b149e ]
> > > 
> > > Each entry in the array is a 20 bits value composed of 16 bits unsigned
> > > integer and 4 bits fractional part. So the type should change to __u32.
> > > In addition add a documentation of how the measurements are done.
> > 
> > Dafna, Helen, does it make sense at all to backport these three patches to
> > when rkisp1 was a staging driver?
> > 
> > I would be inclined not to backport this.
> 
> I also don't think it makes sense since this changes the uapi and it is not really a bug fix.

Why was it ok to change the uapi in a newer kernel and not an older one?

thanks,

greg k-h
