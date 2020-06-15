Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F04C1FA15E
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgFOUVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731467AbgFOUVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 16:21:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C17B02074D;
        Mon, 15 Jun 2020 20:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592252513;
        bh=Dw9Kj1Eh/GPhSFI5HK0KidQanqNj4ZjQFHrlJ2mp3z8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKNfETPsAk2jOETo0b+q9pgRgsCUo+2vVoyEIaocYgJLEEfcK8e4C/90spr5EtUNe
         UU5RBnJwirzTyT0wH7Yssce3cBT95ymniDoEscciiGRBntjoPB59yy58URZBMiKkw7
         LX5+T1xDoE8671S/pW+kQc23Dx6bnNMgaylTdeog=
Date:   Mon, 15 Jun 2020 22:21:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH 4.19.y] ALSA: pcm: disallow linking stream to itself
Message-ID: <20200615202148.GB437074@kroah.com>
References: <20200615154119.1612-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200615154119.1612-1-tiwai@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 05:41:19PM +0200, Takashi Iwai wrote:
> From: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> 
> commit 951e2736f4b11b58dc44d41964fa17c3527d882a upstream.
> 
> Prevent SNDRV_PCM_IOCTL_LINK linking stream to itself - the code
> can't handle it. Fixed commit is not where bug was introduced, but
> changes the context significantly.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0888c321de70 ("pcm_native: switch to fdget()/fdput()")
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> Link: https://lore.kernel.org/r/89c4a2487609a0ed6af3ecf01cc972bdc59a7a2d.1591634956.git.mirq-linux@rere.qmqm.pl
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> ---
> 
> Backported to 4.19.y.  It can be used for older branches, too.

Thanks, that worked.

greg k-h
