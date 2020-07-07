Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DAA217074
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgGGPRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgGGPRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:17:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69EA720663;
        Tue,  7 Jul 2020 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135035;
        bh=z0xVd73LlzIi9Jp12AHZZNXTjQwy1Z8TxR4Az/EGjfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PZdf3y3KnRo/zH0Vr1xrrcEIZd/IBnVfU1Sc+znNuJ8lrshIqdQD6o1oB/KeyPFwX
         iIuQUWxJgTlNaakBN4TFzA+wwafAIhEZcRtF/OtXCaP2DIiXXr1XaffoNb+PGVDeCK
         zLBMuFeWWKOirPSKkXLFahfJebchhINji6M3DSfE=
Date:   Tue, 7 Jul 2020 17:17:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Tsoy <alexander@tsoy.me>,
        Sasha Levin <sashal@kernel.org>,
        Hans de Goede <jwrdegoede@fedoraproject.org>
Subject: Re: [PATCH 4.4 14/19] Revert "ALSA: usb-audio: Improve frames size
 computation"
Message-ID: <20200707151701.GA104827@kroah.com>
References: <20200707145747.493710555@linuxfoundation.org>
 <20200707145748.216607526@linuxfoundation.org>
 <s5hzh8bbbns.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hzh8bbbns.wl-tiwai@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 05:13:59PM +0200, Takashi Iwai wrote:
> On Tue, 07 Jul 2020 17:10:17 +0200,
> Greg Kroah-Hartman wrote:
> > 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This reverts commit 02c56650f3c118d3752122996d96173d26bb13aa which is
> > commit f0bd62b64016508938df9babe47f65c2c727d25c upstream.
> > 
> > It causes a number of reported issues and a fix for it has not hit
> > Linus's tree yet.
> 
> FYI, I'm going to send a pull request to Linus in tomorrow.
> So the fix will be available in a couple of days.
> Though...
> 
> > Revert this to resolve those problems.
> 
> ... I'm not against the revert itself if this needs to be addressed
> right now.

It kind of does, I've gotten lots of distro complaints about it.  As the
original wasn't originally tagged for stable, we should just revert it
for now so that people have working systems again.

thanks,

greg k-h
