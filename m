Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1846220CD6
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 14:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgGOMWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 08:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbgGOMWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jul 2020 08:22:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8462206E9;
        Wed, 15 Jul 2020 12:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594815729;
        bh=UIbWTmsIpIufzoOWQIGro7Qwb6TcGxkYqhUw+qYkL3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dMg+jRnunLGOKutcCXWupjPn5h0pmwGue4v9IOLxbaKG7UdjQT4shT4UfbA7OtZSE
         D7SEJ4RUBgIlPk9KcJ5wl5SH2Z2yWlKeIN1O5ytW2A1HWpYhcg8I8p+SIxyZODD9fc
         ibaY5Aghy6wSBQT1csDCNFNCldFXFe23a4knEjD0=
Date:   Wed, 15 Jul 2020 14:22:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor.Ambarus@microchip.com
Cc:     alexander.levin@microsoft.com, stable@vger.kernel.org,
        herbert@gondor.apana.org.au, hulkci@huawei.com, lkp@intel.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH 5.4] crypto: atmel - Fix build error of CRYPTO_AUTHENC
Message-ID: <20200715122205.GB2937397@kroah.com>
References: <20200715083802.460760-1-tudor.ambarus@microchip.com>
 <20200715092008.GC2722864@kroah.com>
 <d8246e0c-2948-c9d8-e4b0-fb3581ec5983@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8246e0c-2948-c9d8-e4b0-fb3581ec5983@microchip.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 11:37:47AM +0000, Tudor.Ambarus@microchip.com wrote:
> On 7/15/20 12:20 PM, Greg KH wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Wed, Jul 15, 2020 at 11:38:02AM +0300, Tudor Ambarus wrote:
> >> Backport to 5.4.52-rc1 the following commits in upstream:
> >> commit aee1f9f3c30e1e20e7f74729ced61eac7d74ca68 upstream.
> >> commit d158367682cd822aca811971e988be6a8d8f679f upstream.
> > 
> > Please backport the individual commits, do not squash them together.
> > That way lies problems as it is hard to track and almost always
> > incorrect.
> > 
> 
> d158367682cd822aca811971e988be6a8d8f679f attempted to fix the problem,
> but it was just papering it. The real fix is in
> aee1f9f3c30e1e20e7f74729ced61eac7d74ca68. I kept references to both
> commits for tracking reasons.
> 
> Please let me know if you still want me to backport both in dedicated
> patches, or maybe to just drop the reference to
> d158367682cd822aca811971e988be6a8d8f679f

No, please backport both, as a patch series.

thanks,

greg k-h
