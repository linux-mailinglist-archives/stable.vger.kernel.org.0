Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A17B371FFE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 20:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhECS5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 14:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229628AbhECS5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 14:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5CBC611C0;
        Mon,  3 May 2021 18:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620068201;
        bh=z/7gw+6ZRLXsuBnPOx43bmGTgE7IjCZTwYT4ifHiBRU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=XMnFZUGh83wJO1+naG1Nf0e/EYLcxFyXO1zaYUgXgq/5X+iRcL1seqtOVB43xLa3r
         FTAvVz8XkYEGfZpkIFXhBR2qZkTd3pvvTRFYemFbt7jr5lh/0KHmJzDmtQlLLBAfZQ
         m3AZwuu5R1r41ZvpcUyPZSzLQI2d3s56vM1jB/8ltMkfrnqJBu4DQ0/fOXslUf+LLS
         atY5Coe0mzABQfvZAh/MctmOOkoQoaZnTfsdrrTu27me+XIyzkSr6eYIcV4inUspf0
         ufaXs6Mn+Xrb2EdD9PaQmUE5rtdjLSgYHPKxY8jy5136LdKCM0oeXxA2wKUdZpwqoB
         LhyxVT+KQvJRQ==
Date:   Mon, 3 May 2021 13:56:39 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jim Quinlan <jim2101024@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Amjad Ouled-Ameur <aouledameur@baylibre.com>,
        linux-pci@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        bcm-kernel-feedback-list@broadcom.com, james.quinlan@broadcom.com,
        stable@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/3] reset: add missing empty function
 reset_control_rearm()
Message-ID: <20210503185639.GA993318@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430152156.21162-2-jim2101024@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 11:21:54AM -0400, Jim Quinlan wrote:
> All other functions are defined for when CONFIG_RESET_CONTROLLER
> is not set.
> 
> Fixes: 557acb3d2cd9 ("reset: make shared pulsed reset controls re-triggerable")
> CC: stable@vger.kernel.org # v5.11+
> Signed-off-by: Jim Quinlan <jim2101024@gmail.com>

Philipp, I'd like to merge this via the PCI tree since the brcmstb
patch depends on it.  It looks correct to me, but I'd really like to
have your ack before merging it.

> ---
>  include/linux/reset.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/reset.h b/include/linux/reset.h
> index b9109efa2a5c..9700124affa3 100644
> --- a/include/linux/reset.h
> +++ b/include/linux/reset.h
> @@ -47,6 +47,11 @@ static inline int reset_control_reset(struct reset_control *rstc)
>  	return 0;
>  }
>  
> +static inline int reset_control_rearm(struct reset_control *rstc)
> +{
> +	return 0;
> +}
> +
>  static inline int reset_control_assert(struct reset_control *rstc)
>  {
>  	return 0;
> -- 
> 2.17.1
> 
