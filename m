Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582CF32D108
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 11:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbhCDKmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 05:42:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238843AbhCDKli (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 05:41:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0565764F35;
        Thu,  4 Mar 2021 10:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614854458;
        bh=UyFQWnO6Qa/aokP/cHZO6JswbXplosdGEb6Wlbvqzjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BpyWqa2GKXHZNqL1gzkBSU2/nGwC6XMaQkXG9cuqnxOm98f2jB91cKHqmlV8SiG+s
         /MuNKu1gkxIT4zqmMqNFM0Snu24w1QodiA5l365cLISa8CVxdPtHWp0sxznsgC5/Qx
         a7iABjEVDx5R44ydzUS/eu5L0ZPG5tco9xnJiTS4=
Date:   Thu, 4 Mar 2021 11:40:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
Message-ID: <YEC5OO6R3gftJY7B@kroah.com>
References: <20210302192700.399054668@linuxfoundation.org>
 <20210303200820.GF33580@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303200820.GF33580@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 12:08:20PM -0800, Guenter Roeck wrote:
> On Tue, Mar 02, 2021 at 08:28:49PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.20 release.
> > There are 657 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 156 pass: 156 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

thanks for testing them all and letting me know.

greg k-h
