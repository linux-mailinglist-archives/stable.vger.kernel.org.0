Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB09E3B4377
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 14:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFYMlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 08:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhFYMlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 08:41:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32AC461926;
        Fri, 25 Jun 2021 12:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624624740;
        bh=l8O+fjyGjRv3cj2MPL8Ia2Ha1nrIh5AMEL/MVYZ7Wt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1Wv76E15eJbmLpdMCIhfp499N7uAArrFCus5Q4uIEeJqENUKjsgfvrZWV8Hr+Vxgv
         it8a6E+KnLh/FASAzHKFyErMD2CVsm+3v3yVbIZou5ou5qYOvf89dGr3A4fGCzuViS
         AWCRHIBBWKkuR9NzHkMjWrsiaz3pgM8HpuweVVnk=
Date:   Fri, 25 Jun 2021 14:38:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     hemantk@codeaurora.org, bbhatt@codeaurora.org,
        linux-arm-msm@vger.kernel.org, jhugo@codeaurora.org,
        linux-kernel@vger.kernel.org, loic.poulain@linaro.org,
        kvalo@codeaurora.org, ath11k@lists.infradead.org,
        stable@vger.kernel.org, Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: Re: [PATCH 06/10] bus: mhi: core: Set BHI and BHIe pointers to NULL
 in clean-up
Message-ID: <YNXOYkj9TWZgYAG3@kroah.com>
References: <20210625123355.11578-1-manivannan.sadhasivam@linaro.org>
 <20210625123355.11578-7-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625123355.11578-7-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 25, 2021 at 06:03:51PM +0530, Manivannan Sadhasivam wrote:
> From: Bhaumik Bhatt <bbhatt@codeaurora.org>
> 
> Set the BHI and BHIe pointers to NULL as part of clean-up. This
> makes sure that stale pointers are not accessed after powering
> MHI down.
> 
> Cc: stable@vger.kernel.org

Why is this needed for stable, but patch 5/10 is not?

And what commit does this fix?  How far back should it go?

And is this really fixing anything?

thanks,

greg k-h
