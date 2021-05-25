Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF786390438
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 16:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhEYOp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 10:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232939AbhEYOp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 10:45:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B87A6141C;
        Tue, 25 May 2021 14:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621953835;
        bh=PKuRkkYVUsjsx8prZ4f2odHDCB8TksLtWQ8YdxSBZWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mfYYI3h3CqOHnRs7Q1WE//kdP0frslMGuyujkauCTBsCHJ1JTGRuJuJNS9w0KlrYA
         h11P5RUM73YBiwrrfLgTOvLH3WT29nNgl36DT9oje2EOvl+XZbOb4fHQArIazABedT
         tBCVrmfljZpJ48SarpdR8J0TE8gl+pzPr1Q/8Xjs=
Date:   Tue, 25 May 2021 16:43:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: Re: [PATCH AUTOSEL 5.12 32/63] ASoC: cs43130: handle errors in
 cs43130_probe() properly
Message-ID: <YK0NKG0l3a5vjO8K@kroah.com>
References: <20210524144620.2497249-1-sashal@kernel.org>
 <20210524144620.2497249-32-sashal@kernel.org>
 <YK0C/HLiQtt/vyqV@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK0C/HLiQtt/vyqV@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 03:00:28PM +0100, Mark Brown wrote:
> On Mon, May 24, 2021 at 10:45:49AM -0400, Sasha Levin wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > [ Upstream commit 2da441a6491d93eff8ffff523837fd621dc80389 ]
> > 
> > cs43130_probe() does not do any valid error checking of things it
> > initializes, OR what it does, it does not unwind properly if there are
> > errors.
> 
> I don't have this commit and can't see any sign of it having been
> submitted upstream.  Where is it being backported from?  The last
> commit I can see in -next to this driver is
> d2912cb15bdda8ba4a5dd73396ad62641af2f520 (treewide: Replace GPLv2
> boilerplate/reference with SPDX - rule 500) from 2019.

This is now in 5.13-rc3.

You should have been cc:ed on it a few times already.

thanks,

greg k-h
