Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38833705D1
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 08:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhEAGF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 02:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhEAGF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 May 2021 02:05:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30530613EF;
        Sat,  1 May 2021 06:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619849107;
        bh=jKAeSidIYw+pjP6w4+Pyzw3K8K6OjreYf9hO1IaYp6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J74+NWKpUsHX22Eh3tfTKnhBN5eCAR9ivrBYVyhve/6F8g+LIF0RpsEKKyGUvAGJS
         +wSN5CThuZF2d9rFnmNSQ/TkAOb6D1ibsrSTfbclA3CkJKc6VmmPvMqDEtKD32gI8J
         if/e4t8TZff9tHwIHBwEuoQi/nqS/A3xv7ndVUnY=
Date:   Sat, 1 May 2021 08:05:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "van der Linden, Frank" <fllinden@amazon.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 5.4 0/8] BPF backports for CVE-2021-29155
Message-ID: <YIzvjSU6xAHsNOkd@kroah.com>
References: <20210429220839.15667-1-fllinden@amazon.com>
 <YIwIX2mB/+tR0AuG@kroah.com>
 <275977B4-72C4-4B86-9B94-47054AAA8067@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <275977B4-72C4-4B86-9B94-47054AAA8067@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 04:38:29PM +0000, van der Linden, Frank wrote:
> Sure. I have a 4.14 one coming up too, but that one was just a little harder, and it also corrects a previous backport error that was made (correction was already acked), and picks some other commits to get selftests clean. So I'll probably send it to just bpf@ first.
> 
> Others will have to take care of 4.19 or older kernels, though, just flagging that I have done the 4.14 backport for these.

I can not take fixes for 4.14 that are not also in 4.19, sorry, as we
can not have people upgrading to newer kernels and have regressions.

thanks,

greg k-h
