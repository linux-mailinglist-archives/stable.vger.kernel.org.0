Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199F4392AA4
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 11:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbhE0JYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 05:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235559AbhE0JYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 05:24:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 449FE61157;
        Thu, 27 May 2021 09:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622107351;
        bh=fJ9zvQCZy/pO5Tvnl6CDi7EfKOrG7h/NAdzmcNCroII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nL3l3saOYFbjX7GTWdfrbQcVnblpOtclt+UOzP5aXVo/IIlWMhyfwDYrGxd7wb1G6
         4ML5ew4/pq6wFSPXDPC5Nh79aMI0sA52WiZ307QODRIFGybZfZjxakypDtlne7aTKI
         tNp0m4fQhvY77hTJFt20gWKHtH5jzY4B57wXfmO4=
Date:   Thu, 27 May 2021 11:22:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Pham <jackp@codeaurora.org>
Cc:     balbi@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4] usb: dwc3: gadget: Enable suspend events
Message-ID: <YK9k1XE5q1xdl950@kroah.com>
References: <1621239318160213@kroah.com>
 <20210525050424.14724-1-jackp@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525050424.14724-1-jackp@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 10:04:24PM -0700, Jack Pham wrote:
> commit d1d90dd27254c44d087ad3f8b5b3e4fff0571f45 upstream.
> 
> commit 72704f876f50 ("dwc3: gadget: Implement the suspend entry event
> handler") introduced (nearly 5 years ago!) an interrupt handler for
> U3/L1-L2 suspend events.  The problem is that these events aren't
> currently enabled in the DEVTEN register so the handler is never
> even invoked.  Fix this simply by enabling the corresponding bit
> in dwc3_gadget_enable_irq() using the same revision check as found
> in the handler.
> 
> Fixes: 72704f876f50 ("dwc3: gadget: Implement the suspend entry event handler")
> Acked-by: Felipe Balbi <balbi@kernel.org>
> Signed-off-by: Jack Pham <jackp@codeaurora.org>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20210428090111.3370-1-jackp@codeaurora.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [jackp@codeaurora.org: backport to pre-5.7 by replacing
>  DWC3_IS_VER_PRIOR check with direct comparison of dwc->revision]
> Signed-off-by: Jack Pham <jackp@codeaurora.org>
> ---
>  drivers/usb/dwc3/gadget.c | 4 ++++
>  1 file changed, 4 insertions(+)

All now queued up, thanks.

greg k-h
