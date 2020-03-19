Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D95B18ACFD
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 07:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgCSGtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 02:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgCSGtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 02:49:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45322206D7;
        Thu, 19 Mar 2020 06:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584600561;
        bh=CdhUXSRj6wC/PVtvLOMlMxFAnPIs+Uqp5NzW8ZCegKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lje5J6PxUgT58EWYuNhWbCdP+/+FYFUR8UxauhZmLm3e5rTytYNRIprvNxH16Ye5G
         PDxYfWMpsQZxOy5onzEmWvkmtQjUdkQbuVPPaF1ABesshq3FgPFKdJXPL/aaFBHOoO
         zvfEd6Z7woDkvoXUMyj2xP6ml8F1lo6mjYcpwl8w=
Date:   Thu, 19 Mar 2020 07:49:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Artem S . Tashkinov" <aros@gmx.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH AUTOSEL 5.4 60/73] driver code: clarify and fix platform
 device DMA mask allocation
Message-ID: <20200319064919.GA3283689@kroah.com>
References: <20200318205337.16279-1-sashal@kernel.org>
 <20200318205337.16279-60-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318205337.16279-60-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 04:53:24PM -0400, Sasha Levin wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit e3a36eb6dfaeea8175c05d5915dcf0b939be6dab ]

This is already in 5.4.26 and 5.5.10, so no need to try to apply it
again :)

thanks,

greg k-h
