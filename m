Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650023EFA1E
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 07:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbhHRFdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 01:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237832AbhHRFdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 01:33:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A50061029;
        Wed, 18 Aug 2021 05:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629264785;
        bh=no+f3mBvOZTZcMHSaEMPTLCDFymn4nvM/Z9J7kYjpOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MYiGkXri8B+NhHgw/Y/Q0aq+faThrNCt/sBJb/cP51qvYOYx/e5uK0jcS75MQKP8R
         4G2PFk3PWWQ0b42H+tSFQuWjP2vvYMc8ChRb8VxCaSdwGst7sgAkS2DKDJ3UM+ZB9b
         F0ori4ot97gW5M9Z0tiCiX3gtRIWX7ymwk+YIBTo=
Date:   Wed, 18 Aug 2021 07:33:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hui Wang <hui.wang@canonical.com>
Cc:     marex@denx.de, Stable <stable@vger.kernel.org>
Subject: Re: the commit c434e5e48dc4 (rsi: Use resume_noirq for SDIO)
 introduced driver crash in the 4.15 kernel
Message-ID: <YRybjZdFngJr9R8i@kroah.com>
References: <2b77868b-c1e6-9f30-9640-5c82a82f5b31@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b77868b-c1e6-9f30-9640-5c82a82f5b31@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 12:06:15PM +0800, Hui Wang wrote:
> Hi Marex,
> 
> We backported this patch to ubuntu 4.15.0-generic kernel, and found this
> patch introduced the rsi driver crashing when running system resume on the
> Dell 300x IoT platform (100% rate). Below is the log, After seeing this log,
> the rsi wifi can't work anymore, need to run 'rmmod rsi_sdio;modprobe
> rsi_sdio" to make it work again.
> 
> So do you know what is missing apart from this patch or this patch is not
> suitable for 4.15 kernel at all?

Does 4.19.191 work for this system?  Why not just use that or newer
instead?

thanks,

greg k-h
