Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4CB12DF9E
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 18:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgAAREJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 12:04:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgAAREJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 12:04:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DAB82073D;
        Wed,  1 Jan 2020 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577898249;
        bh=hFTe6FEEeHWo92o8HagkoyU/bJLYmn7h1V8jODxoPOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QPvwzRMme1b2xmzFaRRFsuTkCkDTtIgOIRdo9Xb1l7gcA5sNcUn4Rh5UfI4kF6ssQ
         8YETJK9oIbMwR9we7EyULYllI8JLnTbCfzY85QSZTjqBM0yspgBRIs6o95hyvjG6fH
         MJc5VDUYn75TyzF2txTdmL/VNIYMTLEj8K644bao=
Date:   Wed, 1 Jan 2020 18:04:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Doug Meyer <dmeyer@gigaio.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Kelvin Cao <Kelvin.Cao@microchip.com>
Subject: Re: [PATCH] PCI/switchtec: Read all 64 bits of part_event_bitmap
Message-ID: <20200101170406.GE2712976@kroah.com>
References: <20191219182747.28917-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219182747.28917-1-logang@deltatee.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 11:27:47AM -0700, Logan Gunthorpe wrote:
> commit 6acdf7e19b37cb3a9258603d0eab315079c19c5e upstream.
> 
> The part_event_bitmap register is 64 bits wide, so read it with ioread64()
> instead of the 32-bit ioread32().
> 
> Fixes: 52eabba5bcdb ("switchtec: Add IOCTLs to the Switchtec driver")
> Link: https://lore.kernel.org/r/20190910195833.3891-1-logang@deltatee.com
> Reported-by: Doug Meyer <dmeyer@gigaio.com>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: stable@vger.kernel.org	# v4.12+
> Cc: Kelvin Cao <Kelvin.Cao@microchip.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> ioread64() was introduced in v5.1 so the upstream patch won't compile on
> stable versions 4.14 or 4.19. This is the same patch but uses readq()
> which should be equivalent.

Now queued up, thanks.

greg k-h
