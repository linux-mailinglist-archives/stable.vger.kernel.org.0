Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BB061A98
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 08:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfGHGXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 02:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfGHGXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 02:23:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FDE720665;
        Mon,  8 Jul 2019 06:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562567014;
        bh=CoycDhSwAV24qIDsR6HCOJQ0ORGEItOGF8m235nH6Pk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pp7sjW/ZxzvbWsNptxEa5Myo2WN8RKRuofPBYxUcdUsnPnAwka3zas3dKLE37q+V1
         UoQ+VmeZe6K0B3V7TZUCXfePyR6pPuExHCY6TXj+Kdt0+kCAZLoYA55TkrXOo6wAqU
         qs/pDEx90YAdcimITX7FSq4bHNZJZFL/TjQmrdAs=
Date:   Mon, 8 Jul 2019 08:23:32 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Joshua Scott <Joshua.Scott@alliedtelesis.co.nz>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart
 serial node" has been added to the 4.14-stable tree
Message-ID: <20190708062332.GA28690@kroah.com>
References: <156231715780108@kroah.com>
 <1562565301017.49476@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562565301017.49476@alliedtelesis.co.nz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 05:55:00AM +0000, Joshua Scott wrote:
> Hi,
> 
> I do not think this patch alone will work on 4.14.
> 
> An earlier pair of patches which implements the
> "marvell,armada-38x-uart" quirk is present on the other kernel
> versions, but I do see it as far back as 4.14.
> 
> The following two patches are the ones which add support for that compatible string:
> 
> b7639b0b15dd serial: 8250_dw: Limit dw8250_tx_wait_empty quirk to armada-38x devices
> 914eaf935ec7 serial: 8250_dw: Allow TX FIFO to drain before writing to UART_LCR

But, this patch says:
	Fixes: 43e28ba87708 ("ARM: dts: Use armada-370-xp as a base for armada-xp-98dx3236")
and that commit showed up in 4.12.

If that is not the case, fine, I'll drop this, otherwise I just have to
go off of what is given to me :)

thanks,

greg k-h
