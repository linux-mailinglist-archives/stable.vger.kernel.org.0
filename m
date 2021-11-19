Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4595457035
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 15:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbhKSOGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 09:06:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235213AbhKSOGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 09:06:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBBE61AE2;
        Fri, 19 Nov 2021 14:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637330615;
        bh=ztWs7YJESb2HlxvJOJUnYLVjw5JJpn17jX9QzKhXyGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OHPQEK1mITZC66XS1ZIsDWSImMRKXMS9jv5dhNYWAcsWoAdZn56fJ27uvJ8Ro4s0Q
         hSI4bwi7NhSCZNfQ98BWUeOUg6JeBVuxWGAUywgzn61HMzSMTH3mZiLCoS/OXHWhuB
         HlRFPT1DU1eGNlm+dmxuNGD3uBKpvPp7s0Rk7pqQ=
Date:   Fri, 19 Nov 2021 15:03:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     helgaas@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4.14y - v5.14y] PCI/MSI: Destroy sysfs before freeing
 entries
Message-ID: <YZeutF6uD+IaryNu@kroah.com>
References: <163698010954101@kroah.com>
 <87fsrx6whk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsrx6whk.ffs@tglx>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 08:37:43PM +0100, Thomas Gleixner wrote:
> Commit 3735459037114d31e5acd9894fad9aed104231a0 uptream
> 
> free_msi_irqs() frees the MSI entries before destroying the sysfs entries
> which are exposing them. Nothing prevents a concurrent free while a sysfs
> file is read and accesses the possibly freed entry.
> 
> Move the sysfs release ahead of freeing the entries.
> 
> Fixes: 1c51b50c2995 ("PCI/MSI: Export MSI mode using attributes, not kobjects")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/87sfw5305m.ffs@tglx
> ---
> Backport applies to 4.14.y up to 5.14.y series

All now queued up, thanks.

greg k-h
