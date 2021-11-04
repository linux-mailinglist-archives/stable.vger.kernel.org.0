Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED774452B8
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 13:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhKDMMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 08:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231423AbhKDMMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 08:12:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54EB4610D0;
        Thu,  4 Nov 2021 12:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636027784;
        bh=TXgvDixywjGqJvJlBoS1znCanf4iPMsz4yWurHuzzAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lgjl6RQkwvEp7K2DS2Nuyr863EgshZ8792bbzlnB14dzleowKtWW7V7SZi1JSpATR
         pYjudCcuEF7TavWlLvvrrRZwk1BRlS5EnVYRd1BpyRV453+CQJHzmQXCXXTO2HBzdr
         Sl8/jAmEo4p1w6MznTyzUcpR6ROVeSbQrl0xRBy4=
Date:   Thu, 4 Nov 2021 13:09:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.14.y 0/2] Two USB-audio backported patches
Message-ID: <YYPNhgdfqrcuDeG3@kroah.com>
References: <20211104112309.30984-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104112309.30984-1-tiwai@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 12:23:07PM +0100, Takashi Iwai wrote:
> Hi,
> 
> here are two trivial USB-audio patches I adapted the upstream commits
> for the older kernels up to 5.14.y.  Feel free cherry-pick to 5.10.y
> and older trees as long as applicable.
> 
> 
> thanks,
> 
> Takashi
> 
> ===
> 
> Takashi Iwai (2):
>   ALSA: usb-audio: Add Schiit Hel device to mixer map quirk table
>   ALSA: usb-audio: Add Audient iD14 to mixer map quirk table
> 
>  sound/usb/mixer_maps.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

All now queued up, thanks!

greg k-h
