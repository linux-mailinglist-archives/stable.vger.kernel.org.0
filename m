Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FD7460607
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 13:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357384AbhK1MGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 07:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357429AbhK1MEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 07:04:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5FFC0613F3
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 04:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 725D7B80CD7
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF5BC004E1;
        Sun, 28 Nov 2021 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638100816;
        bh=nCe2OWuoFFwKPQ54Wd6av6LgpL2a/0H+JVb1S6pqQes=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=veuGh4NwiXMSCihUJHb5IwY+COQPfJ7hmywpMZj0WX5SAkF2LAi+UF3uxQADRE75e
         ek4x5xlWfp9wF37U1jUG/AQdThCkPUt8KdazD8OurrG0DW98Is+RdcMG4D39NM4xa+
         iIWpJiGhj2UwsVg4umBz9fTAt32ojuMMgn+sPPZE=
Date:   Sun, 28 Nov 2021 13:00:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/5] Armada 3720 PCIe fixes for 5.10
Message-ID: <YaNvSFMDq9Z3Vza1@kroah.com>
References: <20211125112612.11501-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211125112612.11501-1-kabel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 12:26:07PM +0100, Marek Behún wrote:
> Hello Greg, Sasha,
> 
> this series for 5.10-stable backports all the fixes (and their
> dependencies) for Armada 3720 PCIe driver.
> For 5.10 these are only changes to the pci-aardvark controller.
> 
> Marek
> 
> Marek Behún (1):
>   PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()
> 
> Pali Rohár (4):
>   PCI: aardvark: Update comment about disabling link training
>   PCI: aardvark: Implement re-issuing config requests on CRS response
>   PCI: aardvark: Simplify initialization of rootcap on virtual bridge
>   PCI: aardvark: Fix link training
> 
>  drivers/pci/controller/pci-aardvark.c | 235 +++++++++++---------------
>  1 file changed, 99 insertions(+), 136 deletions(-)
> 
> -- 
> 2.32.0
> 

Now queued up, thanks.

greg k-h
