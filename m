Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB3B49E5F0
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiA0PXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiA0PXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:23:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285BAC06173B
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 07:23:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCCD661333
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C7FC340E8;
        Thu, 27 Jan 2022 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643297020;
        bh=CuaZnUr9PTRSypSdqDtiqdNwS0JMW8OSGLF3UKEn6no=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R/Pkt4KKhccccKQ03ZPib+68dc2+Iso7lrGTlT+ypqDobfcmMcgxmFoDQMzBiUAy4
         mQOttuV9xsTZjf/jiRUF0mDHRJyIwTL/GWNvIYh5xb+T0OGfHFzHqPXAhK85OkXZuN
         iR812zqPjpBLiNVPsQWUqI4u+TO4x7Xot5PcITIk=
Date:   Thu, 27 Jan 2022 16:23:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     stable@vger.kernel.org, aelior@marvell.com
Subject: Re: [PATCH stable 5.16 1/2] bnx2x: Utilize firmware 7.13.21.0
Message-ID: <YfK4+TSppmJlXgOh@kroah.com>
References: <20220125185749.26774-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125185749.26774-1-manishc@marvell.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 10:57:48AM -0800, Manish Chopra wrote:
> commit b7a49f73059fe6147b6b78e8f674ce0d21237432 upstream
> 
> This new firmware addresses few important issues and enhancements
> as mentioned below -
> 
> - Support direct invalidation of FP HSI Ver per function ID, required for
>   invalidating FP HSI Ver prior to each VF start, as there is no VF start
> - BRB hardware block parity error detection support for the driver
> - Fix the FCOE underrun flow
> - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
> - Maintains backward compatibility
> 
> This patch incorporates this new firmware 7.13.21.0 in bnx2x driver.
> 
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        | 11 +++-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  6 +-
>  .../net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h    |  2 +
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h    |  3 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 75 +++++++++++++++-------
>  5 files changed, 69 insertions(+), 28 deletions(-)

All backports now queued up, thanks.

greg k-h
