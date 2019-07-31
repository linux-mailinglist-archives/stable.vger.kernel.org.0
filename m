Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1EDB7BD99
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfGaJqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfGaJqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:46:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FD2820665;
        Wed, 31 Jul 2019 09:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564566400;
        bh=q3KpGX/XUNJA3eJAkxkFOo+2OaZ5W4T7lP3JIMP+b1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vGS4Ot1HRygpgYeZk+zUx1H25Cu5geTg4KtNhz3H5JdNSUlaB6jgh2jpv8Rk0YUri
         IAxcFXXSrNoleky+OFIew1LIk6id0ibMld78fgcyi0QTeJJ2NnsLtpscJ1CDA8NFCL
         UBtIp5KVWzk8Lik1BBzARAzmUMBYSq5wUOHTVFWY=
Date:   Wed, 31 Jul 2019 11:46:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Pundir <amit.pundir@linaro.org>
Cc:     Stable <stable@vger.kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH for-4.19.y 3/3] powerpc/4xx/uic: clear pending interrupt
 after irq type/pol change
Message-ID: <20190731094637.GG18269@kroah.com>
References: <1564517799-16880-1-git-send-email-amit.pundir@linaro.org>
 <1564517799-16880-3-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564517799-16880-3-git-send-email-amit.pundir@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 01:46:39AM +0530, Amit Pundir wrote:
> From: Christian Lamparter <chunkeey@gmail.com>
> 
> commit 3ab3a0689e74e6aa5b41360bc18861040ddef5b1 upstream.
> 
> When testing out gpio-keys with a button, a spurious
> interrupt (and therefore a key press or release event)
> gets triggered as soon as the driver enables the irq
> line for the first time.
> 
> This patch clears any potential bogus generated interrupt
> that was caused by the switching of the associated irq's
> type and polarity.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> Cherry-picked from lede/openwrt tree
> https://git.lede-project.org/?p=source.git.
> To be picked up for 4.14.y as well.

This is already in the 4.14.135 kernel release.

thanks,

greg k-h
