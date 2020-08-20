Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0EF24B0D4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHTINS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgHTIMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 04:12:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BF1920855;
        Thu, 20 Aug 2020 08:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597911157;
        bh=PjLUIELg6AGmEcCuySJBbcx9LnsJL6bBZfnzdEx1HL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rl1hK7Rln0Ja3vRQKKuRNfzOuc0MNrNixxzn+HcxnLGT2fanQYauQokNruCyVHMjC
         Ol9BTSVkzOYMg+6cOKSCpObxwfqPmcbOFYN8PcQYqClPUQAHLM0Vit85Rlb7jhRHP2
         eNdg8JGqxwYVG2YmoeMpImjjYI9QeF3Cvdq7PBHw=
Date:   Thu, 20 Aug 2020 10:12:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: marvell: espressobin: add ethernet alias
Message-ID: <20200820081257.GE4049659@kroah.com>
References: <20200805094333.12503-1-pali@kernel.org>
 <20200818173013.n6pgdvawy5dyekz6@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200818173013.n6pgdvawy5dyekz6@pali>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 07:30:13PM +0200, Pali Rohár wrote:
> On Wednesday 05 August 2020 11:43:33 Pali Rohár wrote:
> > From: Tomasz Maciej Nowak <tmn505@gmail.com>
> > 
> > commit 5253cb8c00a6f4356760efb38bca0e0393aa06de upstream.
> > 
> > The maker of this board and its variants, stores MAC address in U-Boot
> > environment. Add alias for bootloader to recognise, to which ethernet
> > node inject the factory MAC address.
> > 
> > Signed-off-by: Tomasz Maciej Nowak <tmn505@gmail.com>
> > Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
> > [pali: Backported to 5.4 and older versions]
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> 
> Hello! I should have been more explicit, that this patch is backport for
> stable releases: 5.4 4.19 4.14

Thanks for that, now queued up.

greg k-h
