Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404AD421F29
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 08:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhJEG6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 02:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJEG6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 02:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08C7A61372;
        Tue,  5 Oct 2021 06:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633416976;
        bh=8xocH1TIp5esYxShaGlUAuH+2sGPO8Fc6nf0SMYns7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vyqarDM7AlIq91NZhVzFctJK8/dvOcfztXntMkai7mANJMaWJPbrfJPstbMGy+7bH
         bw0oae6e3uzdM2qlZqsMIF8rMAthCgc9IiKNcSqAeLIdlpbbBQcF51hAZS0M2D6CSN
         G32A/65ZcBirk4fQvDkQU4cC1RY3fiLavHXjQqo4=
Date:   Tue, 5 Oct 2021 08:56:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 29/56] net: phy: bcm7xxx: request and manage GPHY
 clock
Message-ID: <YVv3Doe5y3f2Csqz@kroah.com>
References: <20211004125030.002116402@linuxfoundation.org>
 <20211004125030.918133685@linuxfoundation.org>
 <2098a161-58c2-c3d8-0c4b-8ff0c20df934@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2098a161-58c2-c3d8-0c4b-8ff0c20df934@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 01:35:40PM -0700, Florian Fainelli wrote:
> On 10/4/21 5:52 AM, Greg Kroah-Hartman wrote:
> > From: Florian Fainelli <f.fainelli@gmail.com>
> > 
> > [ Upstream commit ba4ee3c053659119472135231dbef8f6880ce1fb ]
> > 
> > The internal Gigabit PHY on Broadcom STB chips has a digital clock which
> > drives its MDIO interface among other things, the driver now requests
> > and manage that clock during .probe() and .remove() accordingly.
> > 
> > Because the PHY driver can be probed with the clocks turned off we need
> > to apply the dummy BMSR workaround during the driver probe function to
> > ensure subsequent MDIO read or write towards the PHY will succeed.
> > 
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Please drop this patch from the queue, this is not a bug fix for the 5.4
> branch. If you would like me to send a patch for "net: phy: bcm7xxx:
> Fixed indirect MMD operations", please let me know.

I have dropped both of these now.  If you think the second commit needs
to be in the 5.4.y tree, please send a backport.

thanks,

greg k-h
