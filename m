Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE426430C
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 09:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfGJHsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 03:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbfGJHsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 03:48:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 501EB20651;
        Wed, 10 Jul 2019 07:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562744932;
        bh=BenjStb5n/6B/hevmzp6v5JEuIWbx4ZhERtQWTk6hcY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=erYrFx5im6TuXJiWpbLdSeLYdOMC8+7XuqQwCX7lKlq9yW1TuX2R47bsJVSIZSl8U
         AJl3UIsuzaEgBD8L3oII/TQVFctdhg38tmgEra+Ic0kFHMbJA2s8m4R70wFy7AdnSx
         PerEpRx02YKK3amEWwzRJg+IuESmaNUiMaOZGcEo=
Date:   Wed, 10 Jul 2019 09:48:50 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Joshua Scott <Joshua.Scott@alliedtelesis.co.nz>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart
 serial node" has been added to the 4.14-stable tree
Message-ID: <20190710074850.GA5186@kroah.com>
References: <156231715780108@kroah.com>
 <1562565301017.49476@alliedtelesis.co.nz>
 <20190708062332.GA28690@kroah.com>
 <1562623610543.71373@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562623610543.71373@alliedtelesis.co.nz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 10:06:50PM +0000, Joshua Scott wrote:
> Hi Greg,
> 
> 43e28ba87708 ("ARM: dts: Use armada-370-xp as a base for armada-xp-98dx3236") is the patch
> which introduces the armada-xp-98dx3236, and contains the device-tree entry for the driver that does
> not behave correctly with this SoC.
> 
> However, the driver quirk that implements the fix does not exist until the two patches I mentioned :
> b7639b0b15dd serial: 8250_dw: Limit dw8250_tx_wait_empty quirk to armada-38x devices
> 914eaf935ec7 serial: 8250_dw: Allow TX FIFO to drain before writing to UART_LCR
> 
> Before then, there is no "marvell,armada-38x-uart".
> 
> The current patch being delivered only changes the .dts to make use of the quirk. This won't work
> if it's being delivered to a branch that does not have the above two patches. I had a look at linux-4.14.y
> on kernel.org, and did not see the two patches there.

Ok, thanks, I've deleted it from the queueu now.

greg k-h
