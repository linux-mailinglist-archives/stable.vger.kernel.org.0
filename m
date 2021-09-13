Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9D740985E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344286AbhIMQIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245040AbhIMQIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 12:08:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1495604D1;
        Mon, 13 Sep 2021 16:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631549224;
        bh=qFke4Azamer/B+x9MjnkDwCycu3qLc4uyptmNdSF3dE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZrETo6Iz9fBfc1gCcxp51ohLFcBY2Q9VlsmUYDUljy52EOZE3f0pL5XPrBULfT75D
         +bZh/EKS6Yx1CCuPqRmK6bDAgJbOShfsxjq8RhEnrvsprO48wSy76ZYHudvpPo0g1u
         cw4FwJQmNZG95/ptssTlp2fbrsnwFrld1tsAkWAU=
Date:   Mon, 13 Sep 2021 18:07:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: 5.10 stable backports
Message-ID: <YT93JrYfMDrzGXpB@kroah.com>
References: <81a1f0ea-d875-8cce-6ac1-3307a656bb92@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81a1f0ea-d875-8cce-6ac1-3307a656bb92@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 09:49:05AM -0600, Jens Axboe wrote:
> Hi Greg,
> 
> Looked over the 5.10/13/14 stable failures, and here's the queue for
> 5.10. I'll be sending 5.13 and 5.14 after this.

Thanks for all of these, I'll queue them up later this week after this
next round of stable releases are out.

greg k-h
