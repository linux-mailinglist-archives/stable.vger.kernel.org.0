Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED04B39043A
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 16:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbhEYOpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 10:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232939AbhEYOpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 10:45:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1C9C61284;
        Tue, 25 May 2021 14:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621953859;
        bh=NJdUar8af0rdZYBLwdPudA7NpymLsCZxH70tBGhysbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2kKHVtuPcKdBu8+eEcJTppd47tQR4i/DIUwvrkzHptaah21baBrjuoVqKn5IzbP4h
         PXM3ew0KIW4KO1L38va50OfU9kxMI0n/mdwy7ygCB9p+Ewblsa6QycIYJffOiQzGp+
         trfPiuPrrOiadUanaAWsWpgeUUcx8cZfygolx2c0=
Date:   Tue, 25 May 2021 16:44:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Phillip Potter <phil@philpotter.co.uk>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.12 30/63] ASoC: rt5645: add error checking to
 rt5645_probe function
Message-ID: <YK0NQXRPpFl2Q1ut@kroah.com>
References: <20210524144620.2497249-1-sashal@kernel.org>
 <20210524144620.2497249-30-sashal@kernel.org>
 <YK0DRL1hXkWnIjOA@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK0DRL1hXkWnIjOA@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 03:01:40PM +0100, Mark Brown wrote:
> On Mon, May 24, 2021 at 10:45:47AM -0400, Sasha Levin wrote:
> > From: Phillip Potter <phil@philpotter.co.uk>
> > 
> > [ Upstream commit 5e70b8e22b64eed13d5bbebcb5911dae65bf8c6b ]
> > 
> > Check for return value from various snd_soc_dapm_* calls, as many of
> > them can return errors and this should be handled. Also, reintroduce
> > the allocation failure check for rt5645->eq_param as well. Make all
> 
> I also don't have this commit and can't see any sign of it
> having been submitted upstream.

I cc:ed you on it, as it was part of the larger "revert the umn.edu"
mess.  It's now in 5.13-rc3.

thanks,

greg k-h
