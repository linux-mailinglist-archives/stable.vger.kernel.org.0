Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210894606C3
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 15:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345486AbhK1OVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 09:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhK1OTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 09:19:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA34AC061574
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 06:16:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACB9F60FF0
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5C6C004E1;
        Sun, 28 Nov 2021 14:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638108994;
        bh=9YIuN7nLFmTkt405ovBJ6w208Uy0DGLEswSy3nSSuBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wLjW4GhvbsN5E70GH+jA0aCmib+HChehKFe5iN++8PVnodIoCax4eOy7kcSyUrPrF
         xPqtqRDVsaNJ1jIrm4JUsm145E8GJbtbD3COh9xTrknpiVnfUU69YAsvPuK7077/6b
         wTO/s5UizvMFweo5gSCC8yTN13h2RT3QKtFhVeTM=
Date:   Sun, 28 Nov 2021 15:16:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/20] Armada 3720 PCIe fixes for 4.19
Message-ID: <YaOPPzKtmAzc7tAP@kroah.com>
References: <20211124230500.27109-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 12:04:40AM +0100, Marek Behún wrote:
> Hello Greg, Sasha,
> 
> this series for 4.19-stable backports all the fixes (and their
> dependencies) for Armada 3720 PCIe driver.
> These include:
> - fixes (and their dependencies) for pci-aardvark controller
> - fixes (and their dependencies) for pinctrl-armada-37xx driver
> - device-tree fixes

Now queued up, thanks.

greg k-h
