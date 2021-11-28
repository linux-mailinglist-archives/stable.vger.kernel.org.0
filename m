Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C815D460604
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 13:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357379AbhK1MEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 07:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357375AbhK1MCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 07:02:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6976DC06175E
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 03:58:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 320D8B80CCF
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A77CC004E1;
        Sun, 28 Nov 2021 11:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638100695;
        bh=ppf1Lm8MWoJ8I3PB7hW4akdlGGTkSY+mepp7p/MqlmM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S/hNbptJIQbZrUipxFKkGc5GayZJdMRYC6Z72ze8abpAPHa26janI1bQpeJR5jnyU
         diSx6wbUDeSr4TrHqHv/ESQdrvXcc2y1yKBoN+hpQPgAwjF0mzNQV1f9C5WTmWRaaC
         hBnz23SnzS0W3iwKl96tIM7SSEpnaZipFiZGsmBA=
Date:   Sun, 28 Nov 2021 12:58:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.15 0/4] Armada 3720 PCIe fixes for 5.15
Message-ID: <YaNuyBuNrz7K407w@kroah.com>
References: <20211125140416.15181-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211125140416.15181-1-kabel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 03:04:12PM +0100, Marek Behún wrote:
> Hello Greg, Sasha,
> 
> this series for 5.15-stable backports all the fixes (and their
> dependencies) for Armada 3720 PCIe driver.
> For 5.15 these are only changes to the pci-aardvark controller.
> 
> Marek
> 
> Marek Behún (1):
>   PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()
> 
> Pali Rohár (3):
>   PCI: aardvark: Implement re-issuing config requests on CRS response
>   PCI: aardvark: Simplify initialization of rootcap on virtual bridge
>   PCI: aardvark: Fix link training
> 
>  drivers/pci/controller/pci-aardvark.c | 242 +++++++++++---------------
>  1 file changed, 99 insertions(+), 143 deletions(-)
> 
> -- 
> 2.32.0
> 

Now queued up, thanks.

greg k-h
