Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0E81A4433
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 11:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgDJJGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 05:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgDJJGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 05:06:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4D77206F7;
        Fri, 10 Apr 2020 09:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586509603;
        bh=JTq46RbrNLPWsJ/7ptHMTiLcozvoYcru3UmUukNHKXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=12PTp2k/DSA+Y5jC/xKgoqq7Baq4AkdmqA3XqbmGn6WSXe3bwP/Q0+rOrRHrKOVV+
         6gaRaggz8QDHvdgd6XNQ4z0S1qleAOvhKy+6YonhkDD+hbCwCZN8ZVLMXRYBf83d2y
         3KyXcUT96t8xbHCY3eTiRk7Yn8QtcK7/IB3mXILo=
Date:   Fri, 10 Apr 2020 11:06:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: Missing patches related to ARM_ERRATA_814220 in linux-5.4.y
 branch
Message-ID: <20200410090641.GC1691838@kroah.com>
References: <48084060.SnRd2sqJNp@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48084060.SnRd2sqJNp@n95hx1g2>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 06:52:22PM +0200, Christian Eggers wrote:
> subject of the patch:
> ARM: imx: Enable ARM_ERRATA_814220 for i.MX6UL and i.MX7D
> 
> the commit ID:
> 4562fa4c86c92a2df635fe0697c9e06379738741
> 
> why you think it should be applied: 
> ARM_ERRATA_814220 is already available in v5.4.x, but not yet automatically selected for i.MX6UL(L)
> 
> and what kernel version you wish it to be applied to.
> linux-5.4.y

What about 5.5.y also?

thanks,

greg k-h
