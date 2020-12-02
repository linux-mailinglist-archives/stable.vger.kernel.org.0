Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D31D2CC42F
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 18:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389206AbgLBRqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 12:46:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389201AbgLBRqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 12:46:16 -0500
Date:   Wed, 2 Dec 2020 18:46:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606931135;
        bh=gaM1jyUuINdh1hwybqw5xsVbT4n2d9nIqbQ5BT4ysJI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jtf9svJliZ06YgzeVvXr4EenxebHDt5SyQMlxYekvfOG33V2V4IERixVY9+nJMtNn
         KyeiKX1Nr0d0LVThZ7x2QjJla4AEX0PGGi5+ImItJEL60lwHCDlB3xVx57V2aZxTZt
         uBmqEr7YCTkEc2AQnjCDE3BAidMbxAEUt09wB99E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/152] 5.9.12-rc1 review
Message-ID: <X8fTBEw7VD8TQfjF@kroah.com>
References: <20201201084711.707195422@linuxfoundation.org>
 <53ca0c70-8cb2-68ea-25df-07a26318e4e3@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ca0c70-8cb2-68ea-25df-07a26318e4e3@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 02, 2020 at 09:57:10AM -0700, Shuah Khan wrote:
> On 12/1/20 1:51 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.12 release.
> > There are 152 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing all of these and letting me know.

greg k-h
