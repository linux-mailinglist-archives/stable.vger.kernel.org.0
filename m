Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFD32EFF85
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 13:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbhAIMnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 07:43:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbhAIMnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 07:43:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C74F23A03;
        Sat,  9 Jan 2021 12:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610196191;
        bh=8tdaQjzADBH47moXCZKaZIvSyQffVozoopC7ZSRMLkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pb8LNQv9TWnP9FGTIrpyEs4OpT4KeHmqHF7m+DWAnslKjvsGT30MlR54fyZWWhYni
         /AWwCGOTaIJwskQyi6vkg9atgw2HI0DoZwy2csVXXHatvhfkggg274SOJ2mqQiT4C8
         2gcSnfwy5g/3n6Po10UiL15KQW5ERjEEcFU2ZTiw=
Date:   Sat, 9 Jan 2021 13:44:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/8] 4.19.166-rc1 review
Message-ID: <X/mlKyfk3q72IcZ0@kroah.com>
References: <20210107143047.586006010@linuxfoundation.org>
 <20210107175801.GA3906@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107175801.GA3906@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 06:58:01PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.166 release.
> > There are 8 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This was tested by CIP project, and we did not find anything wrong.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing two of these and letting me know.

greg k-h
