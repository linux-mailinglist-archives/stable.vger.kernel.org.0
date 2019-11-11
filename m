Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A36F748A
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfKKNJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:09:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfKKNJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 08:09:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5652F2190F;
        Mon, 11 Nov 2019 13:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573477750;
        bh=3xzfN7HO5sNEukhZGMJTQbWhQzu/Ph+4fmBi41L95NE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=140HyVD1YDADStWVq/1srVYt7SBOok7BufX0EWHZ+XrC1dnRvHpvHAVQORzYeGJxE
         30kCaFH+O0OFBXJQHp7v2VgnzPcmVLc4QiX/KL4q6C8xIMC1NnCkwEcM5EBgAJTA79
         9y0OWF7V/eHFzhxsEOj/53ar5FR29t3NMHvnasiI=
Date:   Mon, 11 Nov 2019 14:09:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vidya Sagar <vidyas@nvidia.com>
Cc:     stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: stable request: PCI: tegra: Enable Relaxed Ordering only for
 Tegra20 & Tegra30
Message-ID: <20191111130908.GA448544@kroah.com>
References: <11251eb0-5675-9d3d-d15f-c346781e2bff@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11251eb0-5675-9d3d-d15f-c346781e2bff@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 06:24:53PM +0530, Vidya Sagar wrote:
> Hi Greg,
> We noticed that the Tegra PCIe host controller driver enabled
> "Relaxed Ordering" bit in the PCIe configuration space for "all"
> devices erroneously. We pushed a fix for this through the
> commit: 7be142caabc4780b13a522c485abc806de5c4114 and it has been
> soaking in main line for the last four months.
> Based on the discussion we had @ http://patchwork.ozlabs.org/patch/1127604/
> we would now like to push it to the following stable kernels
> 4.19                  : Applies cleanly
> 3.16, 4.4, 4.9 & 4.14 : Following equivalent patch needs to be used as the
>                         file was at drivers/pci/host/pci-tegra.c earlier
>                         (and moved to drivers/pci/controller/pci-tegra.c starting 4.19)

All now queued up (except for 3.16, that's Ben's tree, he will get to it
soon.)

thanks,

greg k-h
