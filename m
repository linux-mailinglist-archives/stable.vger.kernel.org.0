Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910901249A9
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 15:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfLRO3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 09:29:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726856AbfLRO3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 09:29:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5FED20716;
        Wed, 18 Dec 2019 14:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576679376;
        bh=6TmEszoREjc8yIfDNgzG2vNgMDwZQPO+PjlcW1S5bh4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDHNBfurToKdwV7ffFSdbuHn3zL79IJ87rn+Zbcw216Yx6jJBxvxeODd4nSQAlK+O
         fNTn2LN9if3KXjonfafq7PQ3pCczWxlmvyPK8cSz2GynnL/F9ErgIhGhcaNJbNYdoh
         VOUYSQNFIO1qb//yDvvOtqp5UomLqkZbSCkT19y8=
Date:   Wed, 18 Dec 2019 15:29:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henry Lin <henryl@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: xhci: Fix build warning seen with CONFIG_PM=n
Message-ID: <20191218142932.GA237894@kroah.com>
References: <20191218011911.6907-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218011911.6907-1-linux@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 05:19:11PM -0800, Guenter Roeck wrote:
> The following build warning is seen if CONFIG_PM is disabled.
> 
> drivers/usb/host/xhci-pci.c:498:13: warning:
> 	unused function 'xhci_pci_shutdown'
> 
> Fixes: f2c710f7dca8 ("usb: xhci: only set D3hot for pci device")
> Cc: Henry Lin <henryl@nvidia.com>
> Cc: stable@vger.kernel.org	# all stable releases with 2f23dc86c3f8
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/usb/host/xhci-pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Nice catch.

Mathias, I can queue this up now if you give me an ack.

thanks,

greg k-h
