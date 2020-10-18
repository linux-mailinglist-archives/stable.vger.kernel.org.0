Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0C529163A
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 08:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725308AbgJRGAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 02:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgJRGAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 02:00:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6A942087C;
        Sun, 18 Oct 2020 06:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603000833;
        bh=Y/rhN1Kv/c449jMMZ3aTSC63N9a8O604oH5TBpTsFcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y1C5hXdt/PWnFj4wsHS8KIBotKezQnOiwIOezrHXm77NEoqbmttf8M4l9UZiqeuqh
         sSi4FqL4+XqwErU39liSQOoMFgHkHTMvvUBB/fEXUDrn5scJKDG35iyeq2UkrmCiPD
         hsKgH1ih0TaMYcigh2XGIq1WQDSnEXwgCU5lr5VA=
Date:   Sun, 18 Oct 2020 08:00:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/15] 5.9.1-rc1 review
Message-ID: <20201018060030.GD599591@kroah.com>
References: <20201016090437.170032996@linuxfoundation.org>
 <7f0a580a-40d7-96bc-b51f-df4217759eb3@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f0a580a-40d7-96bc-b51f-df4217759eb3@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 17, 2020 at 10:02:50AM -0600, Shuah Khan wrote:
> On 10/16/20 3:08 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.1 release.
> > There are 15 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.1-rc1.gz
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

Thanks for testing them all and letting me know.

greg k-h
