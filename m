Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104B52B5E8E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgKQLpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:45:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKQLpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 06:45:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 195EA2225E;
        Tue, 17 Nov 2020 11:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605613500;
        bh=g3FrPe6ISc02vImdBTiS+mvG58uMY5V4dTCjnspecJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mee9PQ4/FDFYAt729VwZNcrenVuknK33Ams6axiyOFY20otOy9UQZnHwyHm08lXG/
         9VrruDPrZi6Zh+IL2/glAjj1QMWcnKW6vbxmOj1fg5CdNvHzAVPu08/HsmTsoDZL/u
         XLn88t4ldOrRLlYN39ij3tdvh3ir2v7xDBLuHNP0=
Date:   Tue, 17 Nov 2020 12:45:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Linu Cherian <lcherian@marvell.com>
Cc:     stable@vger.kernel.org, mathieu.poirier@linaro.org,
        suzuki.poulose@arm.com, mike.leach@linaro.org,
        linux-arm-kernel@lists.infradead.org, coresight@lists.linaro.org,
        linuc.decode@gmail.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH stable-5.9 1/2] coresight: etm: perf: Sink selection
 using sysfs is deprecated
Message-ID: <X7O37HSQE4nFqWMh@kroah.com>
References: <20201116123510.28980-1-lcherian@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116123510.28980-1-lcherian@marvell.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 06:05:09PM +0530, Linu Cherian wrote:
> commit bb1860efc817c18fce4112f25f51043e44346d1b upstream.
> 
> When commit 6d578258b955 ("coresight: Make sysfs functional on
> topologies with per core sink") 
> was merged to stable, this patch was a pre-requisite and got
> missed out leading to build breakages.
> 
> When using the perf interface, sink selection using sysfs is
> deprecated.
> 
> Signed-off-by: Linu Cherian <lcherian@marvell.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Link: https://lore.kernel.org/r/20200916191737.4001561-14-mathieu.poirier@linaro.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>  drivers/hwtracing/coresight/coresight-etm-perf.c | 2 --
>  1 file changed, 2 deletions(-)

Both now queued up, thanks.

greg k-h
