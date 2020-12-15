Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A782DAA07
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 10:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgLOJYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 04:24:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgLOJYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 04:24:34 -0500
Date:   Tue, 15 Dec 2020 10:24:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608024228;
        bh=MyNdnLJ4k+1GwRzFsj1LdOXGVC+xx0loit6VUv2Q4k4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=dicXN51XQnSBJB1FtgtV00vDBx6HeTkKVaAb99LY02NwQ2YpTBxqsDRPpF2ibliPR
         q2lNTWrBu27RIeBnowrF0Y9aK73kr78W4BqEVXKxRPlLebtvIbNle0hF/4GDPqeSO/
         Htr+06c8g6qezxGqHOg8E7FUxxKSBi5EkFYEJmxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] 5.10.1-rc1 review
Message-ID: <X9iA4xtJLyFkPgCW@kroah.com>
References: <20201214170452.563016590@linuxfoundation.org>
 <89f51647-625f-5319-24ed-60e538a32f13@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89f51647-625f-5319-24ed-60e538a32f13@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 03:20:38PM -0700, Shuah Khan wrote:
> On 12/14/20 10:06 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.1 release.
> > There are 2 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Monday, 14 Dec 2020 18:04:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

Thanks for testing this one and letting me know!

greg k-h
