Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD261F6213
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 09:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgFKHTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 03:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbgFKHTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 03:19:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F7822074B;
        Thu, 11 Jun 2020 07:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591859984;
        bh=gMMtTQFVkMf6IKKMKJKbN6xgkfHJXO/dI/WduuxiJBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N8QwY+MCjDK25bwxpv/ERXM1PmxkV7Hd5cjeowAYkgNjBI9wGf4o2TZ9wT8UWiEOT
         A2G0SdkoFgPwjDsVFsmwisRoFo7n7gR79iiV9b+B5A+2e4KL5Ev80fPDqzxiXuI+34
         x5QUQ7nAcK4s13ZB7VYxcyViVSgS0PuQvukJH3eo=
Date:   Thu, 11 Jun 2020 09:19:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/36] 4.4.227-rc2 review
Message-ID: <20200611071938.GB2637725@kroah.com>
References: <20200609190211.793882726@linuxfoundation.org>
 <d78b5b05-2f40-9152-1752-4a1823d0ab46@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d78b5b05-2f40-9152-1752-4a1823d0ab46@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 01:37:56PM -0600, Shuah Khan wrote:
> On 6/9/20 1:18 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.227 release.
> > There are 36 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 11 Jun 2020 19:02:00 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.227-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
