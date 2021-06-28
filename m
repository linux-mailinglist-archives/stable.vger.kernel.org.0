Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462463B5AE1
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 11:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhF1JIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 05:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232284AbhF1JIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 05:08:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59C996198E;
        Mon, 28 Jun 2021 09:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624871159;
        bh=FExLc1wSRzZCZTuy+DS4OkuAtySt6BaF1qn1uNPiMD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u8Lv7Xc7pXjrDYkFffNNAD1kjawaMTQoW+2Lk/uJXNL0ZU8w/1OYNgtjY8FW97gJ5
         zbuSdUWuWKF7scPx+ooFZIrDp0XCNE8fYl75iaNhK2Mgtw4hjxqM8nRd1hHPANbpye
         LoaPmagGr0cvEdAjLbAszSj7TkT4DLafBHjLS4EE=
Date:   Mon, 28 Jun 2021 11:05:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     Bumyong Lee <bumyong.lee@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] swiotlb: manipulate orig_addr when tlb_addr has offset
Message-ID: <YNmQ9ZmZS658Rxfi@kroah.com>
References: <16246131632380@kroah.com>
 <CGME20210628065823epcas2p19305f8b888a7fc0e883ec51db61e3bae@epcas2p1.samsung.com>
 <513700442.21624870682149.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513700442.21624870682149.JavaMail.epsvc@epcpadp4>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 03:59:16PM +0900, Chanho Park wrote:
> From: Bumyong Lee <bumyong.lee@samsung.com>
> 
> commit 5f89468e2f060031cd89fd4287298e0eaf246bf6 upstream.
> (Backported as different form due to absence of below patch series
> https://lore.kernel.org/linux-iommu/20210301074436.919889-1-hch@lst.de/)

What stable kernel(s) is this for?

And did you send the same patch twice?

thanks,

greg k-h
