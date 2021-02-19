Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0957231F772
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 11:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBSKkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 05:40:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230119AbhBSKjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 05:39:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22C0364EAF;
        Fri, 19 Feb 2021 10:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613731146;
        bh=w7OASQQEYc3Y1k9l01EtmnfDXmcGJBmgwV4obgHSi+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ejwrlwOZmLmMaAkUK2mFExD7t1jKgpJDhUztDLdCKFDHCkk4Rih8bxxV46ADv/GNh
         0QHuJGbbHSYwokMVeiRGSml4Dq8EQUPs3SoJAMdYR8xvwCpbq5Feqw1OtyhHlu3t0u
         CImCIxIvkbNBfXJSC5IlsFlPiLPSI/v0V3O/oZCc=
Date:   Fri, 19 Feb 2021 11:39:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Krishnamraju Eraparaju <krishna2@chelsio.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>, bharat@chelsio.com
Subject: Re: backport of dma_virt_ops related fixes to 5.10.y kernels
Message-ID: <YC+VSJEzXdWdYITx@kroah.com>
References: <20210219095510.GA24256@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219095510.GA24256@chelsio.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 19, 2021 at 03:25:12PM +0530, Krishnamraju Eraparaju wrote:
> Hi All,
> 
> Below commits needs to be backported to 5.10.y kernels to avoid NULL
> pointer deref panic(while trying to access 'numa_node' from NULL
> 'dma_device'), @ Line:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/nvme/host/rdma.c?h=v5.10.17#n863)
> 
> commit:22dd4c707673129ed17e803b4bf68a567b2731db 
> commit:8ecfca68dc4cbee1272a0161e3f2fb9387dc6930

So just these 2 commits?  In which order?

> The panic is observed at nvme host(provider/transport being SoftiWARP),
> while perfroming "nvme discover".
> 
> Hence, please backport the below patch series to '5.10.y' kernel.
>  "https://lore.kernel.org/linux-iommu/20201106181941.1878556-1-hch@lst.de/"

What are the git commit ids of these patches in Linus's tree and have
you tested them to ensure that they work?  Why this 10 patch series and
not the 2 above?  Or is this a different request?

confused,

greg k-h
