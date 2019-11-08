Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC58F4D5D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfKHNj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:39:59 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41566 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfKHNj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 08:39:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lF8c9pUqjrhtWmsftEu4+aVJCTWsPTaSKwSCzFeogkU=; b=pLxIHUY2jmEVkBxvvRDbWZz/S
        t/yeO90G6d2vK+hIOve5RZTVe8WZHjEdTEh4g8mFHcGJ2apRpwupXupMmpre/vA14KGtJr9lDVXAS
        ierXhuZNkgUxERQ+aSgTAzT1EIjJvv1DhVc2o78mub1HCAGe9jxE0v8qr6c5eXbU7Oaq9LdGVtQ/D
        O5oDJpW8vdlgY8KXvSSH5UhKho7PSLuyzKz/pW/uontCM937GRZzwYwAiB65RRnn72TNuq2/xCD/R
        N/vWfSnQ88NWsInAUE/ZlFQI1TD9L/op82Bb80wOQp7K+SjmKXj+ciHZgYn+NL1ucMT6IsavcknuA
        cMynp1vGQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60960)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iT4UU-0002XH-Va; Fri, 08 Nov 2019 13:39:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iT4US-0005wS-4q; Fri, 08 Nov 2019 13:39:52 +0000
Date:   Fri, 8 Nov 2019 13:39:52 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Greg KH <greg@kroah.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        linus.walleij@linaro.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH for-stable-4.4 08/50] arm/arm64: KVM: Advertise SMCCC v1.1
Message-ID: <20191108133952.GX25745@shell.armlinux.org.uk>
References: <20191108123554.29004-1-ardb@kernel.org>
 <20191108123554.29004-9-ardb@kernel.org>
 <20191108131105.GA759061@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108131105.GA759061@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 02:11:05PM +0100, Greg KH wrote:
> On Fri, Nov 08, 2019 at 01:35:12PM +0100, Ard Biesheuvel wrote:
> > From: Mark Rutland <mark.rutland@arm.com>
> > 
> > From: Marc Zyngier <marc.zyngier@arm.com>
> 
> Lots of Mar[c/k]'s :)
> 
> I'll fix this up...

Mark and Marc are both valid variants, there is nothing to be fixed up
(and if you do, you risk insulting one or other.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
