Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741A3424CE3
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 07:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhJGFx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 01:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhJGFx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 01:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D2846120D;
        Thu,  7 Oct 2021 05:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633585925;
        bh=N7JY5bAzFOPn7GNNIPP2kkoavMMDFcgaUujRxu0X9Ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AYWe8FoUg+elF9HRmMmKVJkxI3bkR1uvUZQNvy0nCyztML8t48+7s8NTw1BWlmWI9
         dFLjCVz80GZSPOOypzxdPhKz+qp51sT5IXdzjh1nKVLitvwhHPFlkfMAJC7WvD/RgD
         pMt7Oh7K6pMMOpA3uR7GynAJqEl/iL0btTnmXjQU=
Date:   Thu, 7 Oct 2021 07:52:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/172] 5.14.10-rc3 review
Message-ID: <YV6LA7Wld8R7BmW/@kroah.com>
References: <20211006073100.650368172@linuxfoundation.org>
 <20211007004433.GG650309@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007004433.GG650309@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 05:44:33PM -0700, Guenter Roeck wrote:
> On Wed, Oct 06, 2021 at 10:19:58AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.14.10 release.
> > There are 172 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 08 Oct 2021 07:30:34 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 480 pass: 480 fail: 0
> 
> The new warnings are now gone.

Wonderful, thanks for testing this again and letting me know!

greg k-h
