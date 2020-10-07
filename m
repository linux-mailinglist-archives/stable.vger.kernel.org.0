Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9C1285B9F
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 11:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgJGJLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 05:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbgJGJLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 05:11:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCF2E20789;
        Wed,  7 Oct 2020 09:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602061865;
        bh=TjJk+OlCaYlARVePXxyEOjbbXiierRu6Y7J6fm6iYSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rz2OWmYyvilixxRF/bj8beR0DpyH3GhZmlWdjkOiRCnRZCbLHkC68yABSycdBi/2O
         M3R+bE/k9Zk+mkQRCjyBxHOk0fMg2BnIz1EmS+R8kwHCm2h08Bk6++K17kohmFqibu
         sFIN/RlQ4Y/GPEyNV1EP1IVVo6Oolbnqmw6ZBBiA=
Date:   Wed, 7 Oct 2020 11:11:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/85] 5.8.14-rc1 review
Message-ID: <20201007091149.GA614379@kroah.com>
References: <20201005142114.732094228@linuxfoundation.org>
 <da1db83d-33df-39bd-f46a-894cfa8ec583@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da1db83d-33df-39bd-f46a-894cfa8ec583@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 06, 2020 at 11:18:06AM -0700, Guenter Roeck wrote:
> On 10/5/20 8:25 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.14 release.
> > There are 85 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing all of these and letting me know.

I'll try to get to the perf 4.19 issues "soon"...

greg k-h
