Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B3B8504E
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 17:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388781AbfHGPwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 11:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388779AbfHGPwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Aug 2019 11:52:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A800521E73;
        Wed,  7 Aug 2019 15:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565193152;
        bh=iPPtWlnu0mdKuUsp0if3WOacI3qGeyloGTtQwQXLvcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hyyyBTtsoUfIw5Kq90JqIEoA4OYvwSvbvJC4SeKO0ICBfVx3wUDKaxB71cjll0myF
         283mj1EE4cqzXNAFOYpneiuwIpmIxJvo4ujZr83g1RZgYDLL6/mFtznbSVqhKiuCV3
         hgPk5bq7lwOpQPTzrGIFbljHACKvEaIylx6Ff1pw=
Date:   Wed, 7 Aug 2019 17:52:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will@kernel.org>
Cc:     stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: cpufeature: Fix feature comparison for
 CTR_EL0.{CWG,ERG}
Message-ID: <20190807155229.GA27143@kroah.com>
References: <20190805171410.19358-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805171410.19358-1-will@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 06:14:10PM +0100, Will Deacon wrote:
> commit 147b9635e6347104b91f48ca9dca61eb0fbf2a54 upstream.
> 
> If CTR_EL0.{CWG,ERG} are 0b0000 then they must be interpreted to have
> their architecturally maximum values, which defeats the use of
> FTR_HIGHER_SAFE when sanitising CPU ID registers on heterogeneous
> machines.
> 
> Introduce FTR_HIGHER_OR_ZERO_SAFE so that these fields effectively
> saturate at zero.
> 
> Fixes: 3c739b571084 ("arm64: Keep track of CPU feature registers")
> Cc: <stable@vger.kernel.org> # 4.14.y only
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
> 
> Backport for 4.14.y -stable kernel, after original failed to apply:

Now queued up, thanks.

greg k-h
