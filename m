Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27A7231B1F
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 10:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgG2IWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 04:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgG2IWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 04:22:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA2FE206D4;
        Wed, 29 Jul 2020 08:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596010938;
        bh=C/LqSO9a0vOZ5bkzJgvbomZtHjzYq9zd7pHRgfiBBFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hqqijd1z7UnXs1qzW6W6ErsJvZZdO3nTIfv+T7kiqqEr6ellf5JuSXoJRwwMJO1gy
         Hj6o4GBTEGSNNuvVKFcjewWCuT75L2uxv39Lfsf3ymRJr3j1gzZFtjnNUwcCJqSxUC
         9fmRlHkS8GO9/Tn7+wCeJCiY2pLionqprVEcsSCY=
Date:   Wed, 29 Jul 2020 10:22:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/179] 5.7.11-rc1 review
Message-ID: <20200729082209.GC529870@kroah.com>
References: <20200727134932.659499757@linuxfoundation.org>
 <20200728182407.GD183563@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728182407.GD183563@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 28, 2020 at 11:24:07AM -0700, Guenter Roeck wrote:
> On Mon, Jul 27, 2020 at 04:02:55PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.11 release.
> > There are 179 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 431 pass: 431 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
