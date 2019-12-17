Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA5E1225E9
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 08:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfLQHwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 02:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfLQHwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 02:52:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29A8C206D3;
        Tue, 17 Dec 2019 07:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576569159;
        bh=EE6TDiP1V3N/FLb6uYPI2wDikrmXsIXvjtdfQVaIDfg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lUFMjYMI5NaoggSikx5zp7iysHuSH96AkyQ9AbRMaktE6ngcI6nlsRVn9yCw4Xfrf
         QLxJZZ2PgkQbY+/k86lEfihdceAiIi6lvILwlYzmBgOBG2g3+MJjbrFa0lH9nzeeUP
         Ud6vgSKwBlmvEoivkbVmZT/DyJrpNA0YGj1xfLuE=
Date:   Tue, 17 Dec 2019 08:52:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/177] 5.4.4-stable review
Message-ID: <20191217075235.GD2474507@kroah.com>
References: <20191216174811.158424118@linuxfoundation.org>
 <aa042a91-ebf3-5f32-5fb4-98e11d8b7cab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa042a91-ebf3-5f32-5fb4-98e11d8b7cab@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 05:54:20PM -0700, shuah wrote:
> On 12/16/19 10:47 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.4 release.
> > There are 177 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
