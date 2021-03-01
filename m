Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80EF32924E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbhCAUmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:42:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239589AbhCAUgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:36:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 241BC60232;
        Mon,  1 Mar 2021 19:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614627823;
        bh=G6qUCcBuuvXCkWgifBGLI+SOHMsMAwVISeY+5KIXh9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bkd1T+3ESJmQe3VuCHI9bEM86CmtNnSc/dZpNzyOJBQfPwsPCWk6sMIDFB2u+QbyY
         H0pL0okpsMGAiVyt/6zzSzIVnXoDQc7ZfWV2YV7QNGaQY7MzhJ008K/tZRvoBjljqZ
         wnB3WymWycdKvdT2EaL0mKlxVQD5xX/TISMnhlZ8=
Date:   Mon, 1 Mar 2021 20:43:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/338] 5.4.102-rc1 review
Message-ID: <YD1D7dRAKcgtyZb7@kroah.com>
References: <20210301193604.717100953@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301193604.717100953@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 08:36:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.102 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 19:35:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.102-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.

Argh, that should have been -rc2, let me go fix that up...

greg k-h
