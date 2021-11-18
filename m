Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F745560B
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 08:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243849AbhKRHwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 02:52:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243336AbhKRHwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 02:52:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1135600CD;
        Thu, 18 Nov 2021 07:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637221753;
        bh=/QWAUMA7fqelw+gPFIuYq2JUVgPtXXwmq4KWTN+JzAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G35vcInTjHU4ncg6fQKhQE6lXgPFVF2aQUZpmnT+lbrmZzXUccEdSaVbbaG6TwEhH
         dBIh5teTId27ZZ0YFm9jGGtEOtBvbKJ1nAiGHCrTknjPrtKinnZE8VOWGQxlx8KSON
         7vKspv2rBtrzzlNbRsIOvVWuPs9j7dIHOciB84IE=
Date:   Thu, 18 Nov 2021 08:49:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/569] 5.10.80-rc4 review
Message-ID: <YZYFdqDPNDLh95V2@kroah.com>
References: <20211117144602.341592498@linuxfoundation.org>
 <97dfe80b-1847-2326-8fca-fc4318d115f7@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97dfe80b-1847-2326-8fca-fc4318d115f7@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 12:29:04PM -0800, Guenter Roeck wrote:
> Hi Greg,
> 
> On 11/17/21 6:46 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.80 release.
> > There are 569 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 19 Nov 2021 14:44:50 +0000.
> > Anything received after that time might be too late.
> > 
> 
> You were correct, v5.10.y also needs commit 19221e3083020 ("soc/tegra:
> pmc: Fix imbalanced clock disabling in error code path") to fix the
> following build warning.
> 
> drivers/soc/tegra/pmc.c: In function 'tegra_powergate_power_up':
> drivers/soc/tegra/pmc.c:726:1: warning: label 'powergate_off' defined but not used [-Wunused-label]
>   726 | powergate_off:

Now queued up, thanks.

greg k-h
