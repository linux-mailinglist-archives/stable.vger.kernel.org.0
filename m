Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE25382B1F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 13:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbhEQLfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 07:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236741AbhEQLfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 07:35:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1107F6105A;
        Mon, 17 May 2021 11:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621251235;
        bh=dxv4TFOe0IkIIY9wi4OssIURCUrkfjiImnuowIFKN9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nDz1jWUmB8eNiQHe9CBySuQ5a2VWKP3qpiQ0TPjuXihj5DpD7U/0O0MSNS9cs+AkZ
         EGc/O2WL+5XdKVTDTP4YlhGT8C0wvxWmCsIZmLopqC3PFuVsMsYnBG8o5PiS4aahUA
         QGvRvmYThle92T+w3pkjYG69W9jqpt0eT/Z1Y2GY=
Date:   Mon, 17 May 2021 13:33:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/530] 5.10.37-rc1 review
Message-ID: <YKJUofvhQJl2k1c7@kroah.com>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512205308.GA30312@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512205308.GA30312@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 10:53:08PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.37 release.
> > There are 530 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> > Anything received after that time might be too late.
> 
> While trying to review the patches... I discovered 5.10.36 is not
> tagged in origin/queue:
> 
> commit 72bb632d15f2eabf22b085d79590125a6e2e1aa3
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Tue May 11 14:47:41 2021 +0200
> 
>     Linux 5.10.36
>     
> ...
> commit f53a3a4808625f876aebc5a0bfb354480bbf0c21 (tag: v5.10.35)
> 
> Best regards,
> 								Pavel

Are you sure?  I see it here locally...
