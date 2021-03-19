Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D033418CD
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 10:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCSJvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 05:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229876AbhCSJvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 05:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C28F064F68;
        Fri, 19 Mar 2021 09:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616147483;
        bh=zNRRNI5SNHdeZq52+KvDsJyeWgz3+d4aqumGU6Pm154=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vrn6yavKJFRl1K3Gi0L8STnEJgBDls9+252z4g5xNstZ/Hhg4QX2V1oGr5Ak/GqAp
         1CxjJDG1qHqgvvk9AjIpmbn1L9ulJspe11OiOrGpNn7H36VoQx5T1Ccsnb/AFaI1QY
         Ivw90ncRSotkY9rM/kOchTz2obaMeVvw8fhnRxnM=
Date:   Fri, 19 Mar 2021 10:51:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/290] 5.10.24-rc1 review
Message-ID: <YFR0GJef8Y81gPYr@kroah.com>
References: <20210315135541.921894249@linuxfoundation.org>
 <ed1d3843-71a7-e569-59ad-8db7caa5aed2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed1d3843-71a7-e569-59ad-8db7caa5aed2@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 01:36:06PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/15/2021 6:51 AM, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.10.24 release.
> > There are 290 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 17 Mar 2021 13:55:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.24-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB, using 32-bit and 64-bit kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for testing!
