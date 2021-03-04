Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8696432D0FF
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 11:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbhCDKkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 05:40:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238893AbhCDKkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 05:40:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 341D364F31;
        Thu,  4 Mar 2021 10:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614854376;
        bh=pgzcVu2ArW8bmvZqveEjjpKDr7APopXTqA+qbuSonak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f+ke4l9RE0svc2dxkaTQIwLvTE+6OYRZ2YpFCXQ5vhVS2ZNxbp7Euht3izMuLsjjb
         K/zIVkDCOeKMiNYZZitM31O2FoXFE0rfuYbvdagXsaSQiGEZd9oaLzlYgkxoygf/gM
         +AtoZQAV7UBXyVgPc+tXGwPuK7LvSxILqrIR1CcU=
Date:   Thu, 4 Mar 2021 11:39:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
Message-ID: <YEC45v1Ag1c3ny+I@kroah.com>
References: <20210301193642.707301430@linuxfoundation.org>
 <20210301211925.GC1284@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301211925.GC1284@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 10:19:25PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.20 release.
> > There are 661 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here (failures are due to
> unavailable boards).
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing some of these and letting me know.

greg k-h
