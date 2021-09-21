Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5730412EAB
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 08:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhIUGiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 02:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhIUGiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 02:38:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5632660E73;
        Tue, 21 Sep 2021 06:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632206243;
        bh=KxaiReibRDCeRpXb4s8U69auTzdHe+HPYnNirpmbXSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EVIgb1xvY7clTQ9grCh7lq89fE5+D7N0SyHIWZV5HHwn4IvDN/XqytGn3bcD5ftuU
         kSpaORMb6OJDlossgaqhNhB5rjZZrCF+VBUP0lECqRlEkNy77S6Y+ZbA7jJ0wuWHOw
         4Bw6uIXtbL77l2ALQr+JynlyQ5sYZ/YEVWNMDIpo=
Date:   Tue, 21 Sep 2021 08:37:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/168] 5.14.7-rc1 review
Message-ID: <YUl9oRuf1dqoEx6G@kroah.com>
References: <20210920163921.633181900@linuxfoundation.org>
 <ca3953f8-e3a9-e3a9-d318-0f84ba96db12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca3953f8-e3a9-e3a9-d318-0f84ba96db12@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 11:54:04AM -0700, Florian Fainelli wrote:
> On 9/20/21 9:42 AM, Greg Kroah-Hartman wrote:
> > 
> > Rafał Miłecki <rafal@milecki.pl>
> >     net: dsa: b53: Set correct number of ports in the DSA struct
> 
> (same comment as for 5.10)
> 
> This patch will cause an out of bounds access on two platforms that use
> the b53 driver, you would need to wait for this commit:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=02319bf15acf54004216e40ac9c171437f24be24
> 
> to land in Linus' tree and then you can also take Rafal's b53 change.
> This is applicable to both the 5.14 and 5.10 trees and any tree where
> this change would be back ported to in between.

Now queued up, thanks.

greg k-h
