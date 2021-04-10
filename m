Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D06035AC67
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 11:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhDJJWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 05:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234405AbhDJJWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 05:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920E561105;
        Sat, 10 Apr 2021 09:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618046537;
        bh=guS/9O2iN5aKMEsCuRGh+YuCvXRpnjgb7xqSMM1CO2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1skzc16rKJkkPggnpG40MU23R9bD1TpqX+CGZvaA+GL5nDxug3HcFI4jLYsHQKq6n
         Nwsh9tHxaRg3fldCoLf3+cnAaofPnbldT1x455/tqZGeaqxHBHpNUuKeXsG6mgC/5V
         HBjNJHeI3t09F7we1RUmP6/U6ov0k8Baq6KoZ4Vo=
Date:   Sat, 10 Apr 2021 11:22:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/28] 4.4.265-rc1 review
Message-ID: <YHFuRgDuZ6+VvoWT@kroah.com>
References: <20210405085017.012074144@linuxfoundation.org>
 <e022cc60-efb4-815b-279f-c0278c9cfa6f@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e022cc60-efb4-815b-279f-c0278c9cfa6f@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 06:30:05PM -0600, Shuah Khan wrote:
> On 4/5/21 2:53 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.265 release.
> > There are 28 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.265-rc1.gz
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
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>


Thanks for testing all of these and letting me know

greg k-h

