Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8169220891
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 11:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbgGOJUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 05:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729503AbgGOJUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 05:20:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94E9F2053B;
        Wed, 15 Jul 2020 09:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594804812;
        bh=WHC1D4knoYMjTBupBGsEn8nxKsy9jo09+dZsxYSUxN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oZsyoNyumxue31lHTEToGG3Lmwl13egYOsSILod/KVFIFq9AEG2MnSamC8WAAOC7c
         uOoPD4butEyjb2qFi5qtGEhaq+facathumioWXaZuHV9QuSLvjPsZcq9F9/+dX6qZB
         xXu0D2WPUsWrw9QcSVdAIHLZhmsjMSxAchUKl+hI=
Date:   Wed, 15 Jul 2020 11:20:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     alexander.levin@microsoft.com, stable@vger.kernel.org,
        herbert@gondor.apana.org.au, Hulk Robot <hulkci@huawei.com>,
        kernel test robot <lkp@intel.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 5.4] crypto: atmel - Fix build error of CRYPTO_AUTHENC
Message-ID: <20200715092008.GC2722864@kroah.com>
References: <20200715083802.460760-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715083802.460760-1-tudor.ambarus@microchip.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 11:38:02AM +0300, Tudor Ambarus wrote:
> Backport to 5.4.52-rc1 the following commits in upstream:
> commit aee1f9f3c30e1e20e7f74729ced61eac7d74ca68 upstream.
> commit d158367682cd822aca811971e988be6a8d8f679f upstream.

Please backport the individual commits, do not squash them together.
That way lies problems as it is hard to track and almost always
incorrect.

thanks,

greg k-h
