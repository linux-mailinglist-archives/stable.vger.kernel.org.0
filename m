Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEDC32CFA0
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 10:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbhCDJ2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 04:28:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237503AbhCDJ2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 04:28:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F375F64ED7;
        Thu,  4 Mar 2021 09:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614850048;
        bh=oDbXo7l7EhH9lPSgxNeGOV0sHf+Ht0HyTZR4LDwhgIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mvJXjA8uWRqPN0b7HFkZvI/FVorFTI1Z81s2T974wnmUhoWaJpuj0vJ8FthiC8NoW
         dGst7AIxMG4XiBm2nMNOn9A8zFw/s5PB5iEcmsJfiOrDaKQ5N54M0HQGywEJk7cTLU
         cDK4cPHVYKXQt/oF9nuNi6EVpbAOZe3MOeGJBKP4=
Date:   Thu, 4 Mar 2021 10:27:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/338] 5.4.102-rc2 review
Message-ID: <YECn/tQRxN26NtRn@kroah.com>
References: <20210301194420.658523615@linuxfoundation.org>
 <ef02a144-343a-dbbf-a650-a90d179e74ad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef02a144-343a-dbbf-a650-a90d179e74ad@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 02:20:23PM -0800, Florian Fainelli wrote:
> On 3/1/21 11:47 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.102 release.
> > There are 338 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 03 Mar 2021 19:43:25 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.102-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks for testing and letting me know.

greg k-h
