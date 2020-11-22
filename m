Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7375E2BC4A0
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 10:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgKVJR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 04:17:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbgKVJRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 04:17:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4699A20781;
        Sun, 22 Nov 2020 09:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606036674;
        bh=bRg4+Bx7coAV2ndPNZhsddBZe4PlIookTlw6QEITVAs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ygt0Al0tXA36kWii7MbRzCyeoSMA5RE56RB2cYDpoVDp0nGIXQWNpEvuFm4NxdmNg
         6zCfxPUryZWsKrtxjz2dP15CtGtzWDMXm/ZUN/V4Zvqn6mXm+1hWBJyLlHO52IzcMF
         fNXltB98WzTd3GWr67bsQrkc5koAMzYkhKQmF/os=
Date:   Sun, 22 Nov 2020 10:18:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/14] 5.9.10-rc1 review
Message-ID: <X7os6a0PjnZSQCc+@kroah.com>
References: <20201120104541.168007611@linuxfoundation.org>
 <f59b0645-cb2d-ba84-c2fa-ce02b7b520bf@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f59b0645-cb2d-ba84-c2fa-ce02b7b520bf@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 03:27:28PM -0700, Shuah Khan wrote:
> On 11/20/20 4:03 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.10 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.10-rc1.gz
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
