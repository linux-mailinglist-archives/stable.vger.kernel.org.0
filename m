Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36A83C9E16
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhGOMCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231360AbhGOMCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:02:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C8726117A;
        Thu, 15 Jul 2021 11:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626350361;
        bh=Frq97DH8PUDhicGHcKkWV64WB9Hhxt8VufgNAWt6Prc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NpGTCpcWut5/865R1qnxuUNWOotjnL/nf0cmyajyF9xLYY8mNita/5hWANk5Zq55V
         EzEjGobGthhXzZu07URDIdoqSnOgesCQ6dqs0VIxZdL7j0vPaTnszPWWPCLPIBruNU
         xd7sBIK8Gvr4OasYsc0dTYqfsMwQWdxxtcu7+pHM=
Date:   Thu, 15 Jul 2021 13:53:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH stable 4.4 4.9] can: gw: synchronize rcu operations
 before removing gw job entry
Message-ID: <YPAhzN9jmCvTIgCq@kroah.com>
References: <20210712153036.5937-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712153036.5937-1-socketcan@hartkopp.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 05:30:35PM +0200, Oliver Hartkopp wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> commit fb8696ab14adadb2e3f6c17c18ed26b3ecd96691 upstream.
> 
> can_can_gw_rcv() is called under RCU protection, so after calling
> can_rx_unregister(), we have to call synchronize_rcu in order to wait
> for any RCU read-side critical sections to finish before removing the
> kmem_cache entry with the referenced gw job entry.
> 
> Link: https://lore.kernel.org/r/20210618173645.2238-1-socketcan@hartkopp.net
> Fixes: c1aabdf379bc ("can-gw: add netlink based CAN routing")
> Cc: linux-stable <stable@vger.kernel.org>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  net/can/gw.c | 3 +++
>  1 file changed, 3 insertions(+)

Both now queued up, thanks.

greg k-h
