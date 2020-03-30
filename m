Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304F0197701
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 10:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgC3Ivb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 04:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgC3Ivb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 04:51:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 939EA20732;
        Mon, 30 Mar 2020 08:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585558291;
        bh=ZGQd6sGlSFXJXiJa8J9CmkkifWkwNfprM7Fp0xJEi44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OR5f2CChIsamVYz/4UBAwo/aIF9o2pBOi3vYegFHSCGOgKCYnbTvDN/+YXRziiC8p
         pAJuKIaCcK9DJs0if47YX0h6q4dnGdqWxdxyFxHk+zTcP2mAOJftNi0qtf+XI9Cevh
         GtMZ4VbgBktHi+2+4E60c4kLv0o+jSnFf1pl5o/Y=
Date:   Mon, 30 Mar 2020 10:51:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/2] A couple of important fixes for i915 on 5.4
Message-ID: <20200330085128.GC239298@kroah.com>
References: <20200330033057.2629052-1-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330033057.2629052-1-sultan@kerneltoast.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 08:30:55PM -0700, Sultan Alsawaf wrote:
> From: Sultan Alsawaf <sultan@kerneltoast.com>
> 
> Hi,
> 
> This patchset contains fixes for two pesky i915 bugs that exist in 5.4.

Any reason you didn't also cc: the developers involved in these patches,
and maintainers?

Please resend and do that.

thanks,

greg k-h
