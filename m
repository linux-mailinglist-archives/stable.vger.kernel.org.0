Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF96D46FDE8
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 10:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhLJJkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 04:40:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbhLJJkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 04:40:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE7C9B823BC;
        Fri, 10 Dec 2021 09:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3843EC00446;
        Fri, 10 Dec 2021 09:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639128986;
        bh=Xirrl2rA3niRtiZyVAwCl3Xhpc5LTglC4KS+lzMqM1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mHbsizfhFiwkd/lzCIKplHz7x0wbhKZBUz3aGsIcvqqqZqorR5OirVhLteENOJkAU
         GhDWphRkAyR1i6VYIkFvqfMXcPVEW3A13wgfkdzIjLQVaKyU8IakI7pIgOlZFGT3TG
         yi17o3PEphtfEwGr8sJE/BWYfWAjNiGtVKS+ubjk=
Date:   Fri, 10 Dec 2021 10:36:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: stable request: 5.15.y: device-tree SPI ID fixes
Message-ID: <YbMfleZE6OgvMGim@kroah.com>
References: <8f72e275-b2be-0caf-d88f-5767847e70e9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f72e275-b2be-0caf-d88f-5767847e70e9@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 09:21:32PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> Please can you include the following changes for linux-5.15.y to fix some
> kernel warnings.
> 
> 
> commit 27a030e8729255b2068f35c1cd609b532b263311
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Tue Nov 30 11:24:43 2021 +0000
> 
>     mtd: dataflash: Add device-tree SPI IDs
> 
> 
> commit 5f719948b5d43eb39356e94e8d0b462568915381
> Author: Jon Hunter <jonathanh@nvidia.com>
> Date:   Mon Nov 15 11:38:13 2021 +0000
> 
>     mmc: spi: Add device-tree SPI IDs

Now queued up, thanks.

greg k-h
