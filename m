Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5135731AB6D
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 13:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBMM6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 07:58:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhBMM6d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 07:58:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E37D864E3C;
        Sat, 13 Feb 2021 12:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613221073;
        bh=n9Kc6qtE8zZ7Uco+k2p1ZsHLcXmmAFKB942FmcmmFMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QzBOdW/c2/JrNI5htnMSw5gAb0epUNTeJxFtkmUJYhEn67L/GxfYNdAyT4kO7wYWS
         wk70aHzMeQryGE7/wLYq7dOygl5w7J+NQpb2Ievc0czNg4vIXXd0mhc+8+cIyOERWr
         ZaJ9s8a/0b0b/ALH8LUHI624QpmqND7Gzk3e2dgU=
Date:   Sat, 13 Feb 2021 13:57:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ross Schmidt <ross.schm.dev@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
Message-ID: <YCfMz1UUp0y61/IJ@kroah.com>
References: <20210211150152.885701259@linuxfoundation.org>
 <20210213032005.GC7927@book>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213032005.GC7927@book>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 09:20:05PM -0600, Ross Schmidt wrote:
> On Thu, Feb 11, 2021 at 04:01:44PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.16 release.
> > There are 54 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> 
> Compiled and booted with no regressions on x86_64.
> 
> Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>
> 

Thanks for testing them all and letting me know.

greg k-h
