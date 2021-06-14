Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9008E3A5C5C
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 07:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhFNFTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 01:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhFNFTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 01:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E286D6124B;
        Mon, 14 Jun 2021 05:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623647868;
        bh=all8y8cijNXHjcQvfoX4XHYQxRDUamDHqbY/Fh67Ta8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sIVDFYjtvayS9oLHzMZznKpvbbRrXdGW1hk2nDBWr7yWrY7dAaY4QuADo98H0pAQ/
         7w4AaMF9OdA4PiIxzmP8wj3Ff4WqdQ3Q5ZJnvwQfpGydl8KZiSFkzANlXEM3mbExMz
         fEcDRkJ97BwtzlO+XHndSIxNbCG+CTHLuCXY4Qh0=
Date:   Mon, 14 Jun 2021 07:17:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     adel.ks@zegrapher.com
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Kernel 5.12.10 and 5.12.9 freezing after boot-up with while
 sound output is looping
Message-ID: <YMbmeRH38Wp6BHPf@kroah.com>
References: <d086de2a793eb2ea52acb11ed143675c@zegrapher.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d086de2a793eb2ea52acb11ed143675c@zegrapher.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 13, 2021 at 08:19:37PM +0200, adel.ks@zegrapher.com wrote:
> Hello,
> 
> I am encountering an issue where my system freezes entirely after a random
> but short time after boot-up: the computer does not react to any user input,
> be it mouse, keyboard or plugging-unplugging peripherals.  The image on
> screen remains still and does not go black. Any sound that was playing at
> the moment of the freeze loops indefinitely with a period of around 1s. I
> have the intuition that the issue is sound related because of that.
> 
> Some additional information with this issue
> - Only happens only with the latest stable releases of the kernel:  5.12.9
> and 5.12.10 . 5.12.8  does not have this issue. I have not tested other
> kernel version, e.g. LTS 5.10 , to see if it's a change that got
> back-ported.

Any chance you can run 'git bisect' to find the offending change?
That's the easiest way to fix this up.

thanks,

greg k-h
