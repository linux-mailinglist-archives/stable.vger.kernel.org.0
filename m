Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522EE3E3409
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 10:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhHGIRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 04:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231376AbhHGIRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Aug 2021 04:17:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADF6460F59;
        Sat,  7 Aug 2021 08:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628324210;
        bh=d7H3u7cqpnsZ9Xce5y7GvurT2XWmylBa5mXCyE1ePvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GLjNarE2CCrxFP5ZVjcAo7+4fyzNmsFTceG6YzX+7Y0OCpbHZzu4T5WAzxHq6EWfG
         NZf2UaSTpxVWNALNF1Nf73bPqxwaWYK7tAOdmV7QoaMWcEB7vayxy7vaLdk6Iq12gC
         tF+LQ0eEDfsc4gQ6eRPP4hPs17cfS1mmR7/wo2LE=
Date:   Sat, 7 Aug 2021 10:16:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>, Jeff Woods <jwoods@fnordco.com>
Cc:     alsa-devel@alsa-project.org, stable <stable@vger.kernel.org>,
        regressions <regressions@lists.linux.dev>
Subject: Re: Kernel 5.13.6 breaks mmap with snd-hdsp module
Message-ID: <YQ5Bb+mPgPivLqvX@kroah.com>
References: <17b1f9647ee.1179b6a05461889.5940365952430364689@fnordco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17b1f9647ee.1179b6a05461889.5940365952430364689@fnordco.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 07, 2021 at 12:49:07AM -0700, Jeff Woods wrote:
> Specifically, commit c4824ae7db418aee6f50f308a20b832e58e997fd triggers the problem. Reverting this change restores functionality.
> 
> The device is an RME Multiface II, using the snd-hdsp driver.
> 
> Expected behavior: Device plays sound normally
> 
> Exhibited behavior: When a program attempts to open the device, the following ALSA lib error happens:
> 
> ALSA lib pcm_direct.c:1169:(snd1_pcm_direct_initialize_slave) slave plugin does not support mmap interleaved or mmap noninterleaved access
> 
> This change hasn't affected my other computers with less esoteric hardware, so probably the problem lies with the snd-hdsp driver, but the device is unusable without reverting that commit.
> 
> I am available to test any patches for this issue.

Have you notified the developers involved in this change about this
issue?

Adding them now...

thanks,

greg k-h
