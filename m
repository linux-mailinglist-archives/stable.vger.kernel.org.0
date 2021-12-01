Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C97C464A57
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 10:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348142AbhLAJLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 04:11:19 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56230 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242325AbhLAJLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 04:11:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9DC29CE1758
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 09:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2F0C53FAD;
        Wed,  1 Dec 2021 09:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638349674;
        bh=/0mxix4TRBQX2c/FjdYMj5Px3VUr9SHtF3JJiGAc5DI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PBKVe/GfONMJnxU0m7b63Rwp07K9w2Y/p/YPKKc2TTlLNyRKAkmNXS+h5xQhARQn/
         gYb31JF5BqhWA28caiSKGYnEZMwxpqKBN9H8bIgaDRsArMM/Vh4Ccd95DQsQ29pgaF
         /WpEiCzWXPqEVG0ry2nnKGYWnLKELlrMSC6kUOxI=
Date:   Wed, 1 Dec 2021 10:07:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org
Subject: Re: Request for cherry-picking USB-audio fixes to 5.15.x stable
Message-ID: <Yac7TspPxwdHGcRA@kroah.com>
References: <s5htuftz5uo.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htuftz5uo.wl-tiwai@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 30, 2021 at 10:33:19PM +0100, Takashi Iwai wrote:
> Hi Greg,
> 
> it seems that many reported issues for 5.15 and 5.14 kernels are fixed
> by the recent development on 5.16-rc, and it's worth to backport those
> to 5.15.x stable.
> 
> Below is the list of commits from the mainline.  Could you cherry-pick
> them to 5.15.x stable?  Applying from top to bottom.
> I confirmed that they can be applied and built cleanly on 5.15.5.
> 
> 4e7cf1fbb34ecb472c073980458cbe413afd4d64
> 9c9a3b9da891cc70405a544da6855700eddcbb71
> e581f1cec4f899f788f6c9477f805b1d5fef25e2
> bceee75387554f682638e719d1ea60125ea78cea
> d215f63d49da9a8803af3e81acd6cad743686573
> 0ef74366bc150dda4f53c546dfa6e8f7c707e087
> d5f871f89e21bb71827ea57bd484eedea85839a0
> 813a17cab9b708bbb1e0db8902e19857b57196ec
> 23939115be181bc5dbc33aa8471adcdbffa28910
> 53451b6da8271905941eb1eb369db152c4bd92f2
> eee5d6f1356a016105a974fb176b491288439efa
> 83de8f83816e8e15227dac985163e3d433a2bf9d
> 
> 
> The diffstat of those are like below:
> 
>  sound/usb/card.h     |  10 ++-
>  sound/usb/endpoint.c | 223 +++++++++++++++++++++++++++++++++++++--------------
>  sound/usb/endpoint.h |  13 ++-
>  sound/usb/pcm.c      | 165 +++++++++++++++++++++++++++++--------
>  4 files changed, 306 insertions(+), 105 deletions(-)
> 
> If you prefer, I can submit the patches, too.

This is fine, all now queued up, thanks!

greg k-h
