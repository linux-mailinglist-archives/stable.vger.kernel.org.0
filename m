Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2100E337B06
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCKRiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:38:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCKRhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 12:37:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F5964F90;
        Thu, 11 Mar 2021 17:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615484263;
        bh=Kh/T3Uo5cupmNF0P2Z6a90ABkS0eST1P9UrSZ6cD7ps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GmFiklZXORziwfjcYRJ38TS9A3MKNLg0KkyKxpbPR6KzW37bIlVIPPsynq4hNF3yu
         bCxcayX4FIeNkYnF0tg5VH9tUjBHK+13uAA/C+jIAHtRcwcSGMyr8znMxlmP2dLsMD
         3Jq+ukn10/baOg7OoyNrZrfuiYsZGLqHG0JlldgM=
Date:   Thu, 11 Mar 2021 18:37:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/36] 5.11.6-rc1 review
Message-ID: <YEpVZLxCWGp9bhXk@kroah.com>
References: <20210310132320.510840709@linuxfoundation.org>
 <14801dd7-0adb-fdc3-babe-f3f6cbb64b58@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14801dd7-0adb-fdc3-babe-f3f6cbb64b58@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:59:43PM -0700, Shuah Khan wrote:
> On 3/10/21 6:23 AM, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.11.6 release.
> > There are 36 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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
