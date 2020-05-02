Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0372B1C25FE
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 16:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgEBOJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 10:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbgEBOJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 10:09:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 438FC21775;
        Sat,  2 May 2020 14:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588428551;
        bh=MDyVjZWnm5EvNAHWJ1mOzIJ83FG+EVxuwwcCWJaro3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UdYTtL0tJm4pDAJdkk0jA2Pl4wn/Y0pmT0tkl+Ym73e1Y5SeNV26aAoSjnOADOGR3
         Z2CrMXCFV1jj8nOlb7huAU/Y1F0im1D9EjwqYX4t+p9Nh9IovYfLHgnjxvpKzLmFoM
         3enP6QhzvOZpKMji7n7/dc0Sempgkxa07zumwe7Y=
Date:   Sat, 2 May 2020 16:09:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Jerome Brunet <jbrunet@baylibre.com>, kernelci@groups.io,
        Kevin Hilman <khilman@baylibre.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: stable-rc/linux-5.4.y bisection: baseline.dmesg.alert on
 meson-g12a-x96-max
Message-ID: <20200502140908.GA10998@kroah.com>
References: <5eabecbf.1c69fb81.2c617.628f@mx.google.com>
 <cc10812b-19bd-6bd1-75da-32082241640a@collabora.com>
 <20200501122536.GA38314@sirena.org.uk>
 <20200502134721.GH13035@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502134721.GH13035@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 02, 2020 at 09:47:21AM -0400, Sasha Levin wrote:
> On Fri, May 01, 2020 at 01:25:36PM +0100, Mark Brown wrote:
> > On Fri, May 01, 2020 at 12:57:27PM +0100, Guillaume Tucker wrote:
> > 
> > > The call stack is not the same as in the commit message found by
> > > the bisection, so maybe it only fixed part of the problem:
> > 
> > No, it is a backport which was fixing an issue that wasn't present in
> > v5.4.
> > 
> > > >   Result:     09f4294793bd3 ASoC: meson: axg-card: fix codec-to-codec link setup
> > 
> > As I said in reply to the AUTOSEL mail:
> > 
> > | > Since the addition of commit 9b5db059366a ("ASoC: soc-pcm: dpcm: Only allow
> > | > playback/capture if supported"), meson-axg cards which have codec-to-codec
> > | > links fail to init and Oops:
> > 
> > | This clearly describes the issue as only being present after the above
> > | commit which is not in v5.6.
> > 
> > Probably best that this not be backported.
> 
> Hrm... But I never queued that commit... I wonder what's up.

I saw the Fixes: tag, but missed the changelog text.  My fault.

I'll go drop it from everywhere, sorry about that.

greg k-h
