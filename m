Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5E12509E7
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 22:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgHXUS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 16:18:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48959 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726531AbgHXUS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 16:18:57 -0400
Received: (qmail 345376 invoked by uid 1000); 24 Aug 2020 16:18:56 -0400
Date:   Mon, 24 Aug 2020 16:18:56 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Cyril Roelandt <tipecaml@gmail.com>
Cc:     linux-usb@vger.kernel.org, sellis@redhat.com, pachoramos@gmail.com,
        labbott@fedoraproject.org, javhera@gmx.com, brice.goglin@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge
Message-ID: <20200824201856.GC344424@rowland.harvard.edu>
References: <20200824074027.GB3983120@kroah.com>
 <20200824173128.48740-1-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824173128.48740-1-tipecaml@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 07:31:28PM +0200, Cyril Roelandt wrote:
> This device does not support UAS properly and a similar entry already
> exists in drivers/usb/storage/unusual_uas.h. Without this patch,
> storage_probe() defers the handling of this device to UAS, which cannot
> handle it either.
> 
> Tested-by: Brice Goglin <brice.goglin@gmail.com>
> CC: <stable@vger.kernel.org>

You left out the Signed-off-by: tag and a Fixes: tag.  Please resend the 
patch with those tags.  When you do, you may add:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

> ---
>  drivers/usb/storage/unusual_devs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
> index 220ae2c356ee..5732e9691f08 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -2328,7 +2328,7 @@ UNUSUAL_DEV(  0x357d, 0x7788, 0x0114, 0x0114,
>  		"JMicron",
>  		"USB to ATA/ATAPI Bridge",
>  		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> -		US_FL_BROKEN_FUA ),
> +		US_FL_BROKEN_FUA | US_FL_IGNORE_UAS ),
>  
>  /* Reported by Andrey Rahmatullin <wrar@altlinux.org> */
>  UNUSUAL_DEV(  0x4102, 0x1020, 0x0100,  0x0100,
> -- 
> 2.28.0
> 
