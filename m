Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0A301625
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 16:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbhAWPHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 10:07:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbhAWPHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 10:07:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09715224BE;
        Sat, 23 Jan 2021 15:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611414395;
        bh=mg56uEMm/qfhkXuvhg2qmXaJnB6cBfQBnS9++lNliZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pPqMQHuY/DQdz2XpBK4vr3Nn8UI/KYztPzL4ot1993I48t9S1CGd59lCzXuKTgJVi
         WpJTVMOBJiTRhDsnGBwVnEyl9jw4jLDY/iIbELp2jcgl2v5nj/gZ6Iy9VkM6JKCVsM
         iym1FIotW6dmgxDZRaGrDwID6vi4BV7104c9ZlBU=
Date:   Sat, 23 Jan 2021 16:06:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/43] 5.10.10-rc1 review
Message-ID: <YAw7eBcrlYv9fdV7@kroah.com>
References: <20210122135735.652681690@linuxfoundation.org>
 <5ce91f74-86d0-778c-d884-769cf4d7e3b2@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ce91f74-86d0-778c-d884-769cf4d7e3b2@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 05:24:01PM -0700, Shuah Khan wrote:
> On 1/22/21 7:12 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.10 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.10-rc1.gz
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

Thanks for testing these and letting me know.

greg k-h
