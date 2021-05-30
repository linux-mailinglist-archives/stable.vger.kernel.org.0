Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A673950E9
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 14:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhE3MaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 08:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhE3MaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 May 2021 08:30:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F72B610C7;
        Sun, 30 May 2021 12:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622377722;
        bh=w/KihdfTB+4CtHtxExXKs8rsyYgzTYekkhRa6ROKVOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xLjQdi7yb/SBeThje/unbOaK47ZVOE0Rqoud+OJtwlBDulHzUfovOCxw+M0hyVkTX
         U0TDOO7hJHoL3kG3f6TqIPUKxj7U9iaIAOEXM/9iBI+Va4MyhDqXFv8pwAkvT3IJBz
         3Ka4EQfSpgGh8oRg5OCcTghGNTIll9AnBu3pShDI=
Date:   Sun, 30 May 2021 14:28:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     broonie@kernel.org, girishm@codeaurora.org, rnayak@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: spi-geni-qcom: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
Message-ID: <YLOE9zqfIXeqAgi0@kroah.com>
References: <16091533040136@kroah.com>
 <20210529043845.GA11302@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210529043845.GA11302@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 29, 2021 at 06:38:45AM +0200, Lukas Wunner wrote:
> On Mon, Dec 28, 2020 at 12:01:44PM +0100, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Sorry for the delay, here's the backport of 8f96c434dfbc to v5.4-stable:

Thanks for all the spi backports, now queued up.

greg k-h
