Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18A03AE518
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 10:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFUImF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 04:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhFUImF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 04:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21AD960FD8;
        Mon, 21 Jun 2021 08:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624264790;
        bh=9kzzjefyjneTAiDNZ6xrBap47Es23Ehns4z0lVHvvyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B0ZNVGiCdQk72cDAT0sY80V4RF75JKQJODenJ3qhKj3Es1Ur+CWCQXc3H2RrM/08K
         tzZLB7QLoVTE9LaAsFLYvzhr+QND1EXCDRb0KjWRZerOjZnQomnbDeveKDVF/gcLUR
         2GsKYMbVy5mR9YV5ZAocfb6ZiCzg+41A0OH/EX/0=
Date:   Mon, 21 Jun 2021 10:39:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shunsuke Mie <mie@igel.co.jp>
Cc:     kishon@ti.com, lorenzo.pieralisi@arm.com, bhelgaas@google.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: endpoint: Fix use after free in pci_epf_remove_cfs()
Message-ID: <YNBQVIT1yrzSng43@kroah.com>
References: <20210621070058.37682-1-mie@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621070058.37682-1-mie@igel.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 04:00:58PM +0900, Shunsuke Mie wrote:
> All of entries are freed in a loop, however, the freed entry is accessed
> by list_del() after the loop.
> 
> When epf driver that includes pci-epf-test unload, the pci_epf_remove_cfs()
> is called, and occurred the use after free. Therefore, kernel panics
> randomly after or while the module unloading.
> 
> I tested this patch with r8a77951-Salvator-xs boards.
> 
> Fixes: ef1433f ("PCI: endpoint: Create configfs entry for each pci_epf_device_id table entry")
> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> ---
>  drivers/pci/endpoint/pci-epf-core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
