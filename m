Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE42F316769
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 14:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBJNDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 08:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhBJNBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 08:01:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D67D64E3B;
        Wed, 10 Feb 2021 13:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612962053;
        bh=nrXu6xAPjOcZpDR/4duoPi3UpzdK1/f3kCdIhheWMhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TJKEKIxWT+Z3R8hf5yttBCH7MbYjeJYP2zckMhhhVQnHcjTxQ0TOmGSF0vBaT0fkX
         UYUlpyb9qmWxNMjzecLREgMUROavGJC5mTe9Kb671BFGqrhChBOIFGKw+Z8btbZz0B
         MO5tRF1VOBMLiY76vkC7sIzDgiO+6JfJADlKxvXE=
Date:   Wed, 10 Feb 2021 14:00:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joerg Vehlow <lkml@jv-coder.de>
Cc:     stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [4.14] Failing selftest timer/adjtick
Message-ID: <YCPZA7nkGGDru3xw@kroah.com>
References: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 01:43:10PM +0100, Joerg Vehlow wrote:
> Hi,
> 
> we found that on the selftest timer/adjtick fails on arm64 (tested on some
> renesas board and in qemu) quite frequently.
> By bisecting the kernel I found that it stopped failing after commit
> 78b98e3c5a66 (timekeeping/ntp: Determine the multiplier directly from NTP
> tick length).
> Should this patch be applied to 4.14 and is it even possible or could it
> break something else?

Have you tried applying it to that tree to see if it solves your problem
and works properly?  If so, please feel free to provide a working
backported copy, with your signed-off-by and we can consider it.

But, why not just use 4.19 or newer on that system?

thanks,

greg k-h
