Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A53314D5E
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 11:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhBIKo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 05:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231522AbhBIKln (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 05:41:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4BC464E4B;
        Tue,  9 Feb 2021 10:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612867197;
        bh=/jh06s5G/k5IVhUW0yt0cXHDhlQpDXNonOEqGQ0F5qg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NvMFBEAJSBSoBgfeE00P1l46u1S3zR8ZgC92VkrGXNBZQuRkiv3FBf5/BWa3AU0l2
         +Bcp0x149qDPwTIkgv9CTtwbxFBMuydrVT7JTYBcT2SpShOevWsbynTFEld/q+rWL7
         +RbWKxPN1+fsK/BNEFqHZj5ruw1wX0KC4xxywqXU=
Date:   Tue, 9 Feb 2021 11:39:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     obayashi.yoshimasa@socionext.com
Cc:     sumit.garg@linaro.org, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        daniel.thompson@linaro.org
Subject: Re: DMA direct mapping fix for 5.4 and earlier stable branches
Message-ID: <YCJmegLycZ5hnCUr@kroah.com>
References: <CAFA6WYNazCmYN20irLdNV+2vcv5dqR+grvaY-FA7q2WOBMs__g@mail.gmail.com>
 <YCIym62vHfbG+dWf@kroah.com>
 <CAFA6WYM+xJ0YDKenWFPMHrTz4gLWatnog84wyk31Xy2dTiT2RA@mail.gmail.com>
 <YCJCDZGa1Dhqv6Ni@kroah.com>
 <27bbe35deacb4ca49f31307f4ed551b5@SOC-EX02V.e01.socionext.com>
 <YCJUgKDNVjJ4dUqM@kroah.com>
 <ed485ad069af4d1481e3961db4a3e079@SOC-EX02V.e01.socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed485ad069af4d1481e3961db4a3e079@SOC-EX02V.e01.socionext.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 10:19:07AM +0000, obayashi.yoshimasa@socionext.com wrote:
> > How do you judge "mature"?
> 
>   My basic criteria are
> * Function is exist, but bug fix is necessary: "mature"
> * Function extension is necessary: "immature"
> 
> > And again, if a feature isn't present in a specific kernel version, why would you think that it would be
> > a viable solution for you to use?
> 
>   So, "a feature isn't present in a specific kernel version", 
> also means "immature" according to my criteria.

Great, please use the 5.10 or newer kernel release then.

thanks,

greg k-h
