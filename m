Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE851136C5A
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 12:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgAJLyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 06:54:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727717AbgAJLyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 06:54:07 -0500
Received: from localhost (83-84-126-242.cable.dynamic.v4.ziggo.nl [83.84.126.242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A95AF2072A;
        Fri, 10 Jan 2020 11:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578657247;
        bh=lhVenOJ6s+P8475zKLSkROrO37p0bVEiiTrIGGrOrS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NTAFbSxK/TvK7RZ18ZBtWjzzLieB3QtfaOjyx0oHbZcrVUZMaXOncJMpi+eN9t50o
         0nh/lLNTUaJOMF1IMFUV50DuI/1lvTuJmq49qWHOEhHkazk9KVDAjI3BAB6oc2q+o8
         oxwOfAdb0C4Gdom+/qonTTJpb2RaQPP4LzYzW2Eo=
Date:   Fri, 10 Jan 2020 12:54:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Sasha Levin <sashal@kernel.org>, Doug Meyer <dmeyer@gigaio.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Kelvin Cao <Kelvin.Cao@microchip.com>
Subject: Re: [PATCH v2] PCI/switchtec: Read all 64 bits of part_event_bitmap
Message-ID: <20200110115404.GA924184@kroah.com>
References: <20200103171029.25790-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103171029.25790-1-logang@deltatee.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 10:10:29AM -0700, Logan Gunthorpe wrote:
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
>  drivers/pci/switch/switchtec.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> v2 of this patch adds the missing header that provides readq() on
> non-64bit architectures.

Thanks for this, now queued up.

greg k-h
