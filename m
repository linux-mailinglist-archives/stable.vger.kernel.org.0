Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFB867A85
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 16:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfGMOZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 10:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbfGMOZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Jul 2019 10:25:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21BCD20838;
        Sat, 13 Jul 2019 14:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563027906;
        bh=E1+vjFTZH5P9sUtne9fNDAYR51eeWGKXVWRlwo0DwYQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m05xDgbzQw9hWaWXG1nlzHVPsAkzl9mv6CrEQzZzZCvpMxIPxK2sfmna8NwIuu7hW
         6YiT62v1nqDf39V2WhGvN4tk+lAR7XcnlWoBVp6DxzoBrj6CaWzT8HR3gWRHFLioG6
         jfLFWJlQqtAGPy4RL4yhUpHsLmBX/5HklY7umdcE=
Date:   Sat, 13 Jul 2019 16:25:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Jon Hunter <jonathanh@nvidia.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>,
        j-keerthy@ti.com
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
Message-ID: <20190713142504.GA7695@kroah.com>
References: <20190712121628.731888964@linuxfoundation.org>
 <4dae64c8-046e-3647-52d6-43362e986d21@nvidia.com>
 <20190712153035.GC13940@kroah.com>
 <20190712202141.GA18698@roeck-us.net>
 <20190713082233.GA28657@kroah.com>
 <9871ef1a-ea5d-e9cb-2eff-a0a1a93ad44f@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9871ef1a-ea5d-e9cb-2eff-a0a1a93ad44f@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 13, 2019 at 06:16:56AM -0700, Guenter Roeck wrote:
> On 7/13/19 1:22 AM, Greg Kroah-Hartman wrote:
> > On Fri, Jul 12, 2019 at 01:21:41PM -0700, Guenter Roeck wrote:
> > > On Fri, Jul 12, 2019 at 05:30:35PM +0200, Greg Kroah-Hartman wrote:
> > > > On Fri, Jul 12, 2019 at 02:26:57PM +0100, Jon Hunter wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > On 12/07/2019 13:17, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 5.1.18 release.
> > > > > > There are 138 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > > 
> > > > > > Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> > > > > > Anything received after that time might be too late.
> > > > > > 
> > > > > > The whole patch series can be found in one patch at:
> > > > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.18-rc1.gz
> > > > > > or in the git tree and branch at:
> > > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > > > > > and the diffstat can be found below.
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > > 
> > > > > > -------------
> > > > > > Pseudo-Shortlog of commits:
> > > > > 
> > > > Both are now dropped, thanks.  I'll push out a -rc2 with that changed.
> > > > 
> > > 
> > > Can you push that update into the git repository ?
> > > v5.1.17-137-gde182b90f76d still has the problem.
> > 
> > Odd, I thought I did this.  Pushed out again just to be sure.
> > 
> Problem is still seen in -rc2.

Ugh, I dropped one, but not the other, now both gone.  I'll push out
updates in a bit.

> > > Also:
> > > 
> > > Building powerpc:ppc6xx_defconfig ... failed
> > > 
> > > drivers/crypto/talitos.c: In function ‘get_request_hdr’:
> > > include/linux/kernel.h:979:51: error:
> > > 	dereferencing pointer to incomplete type ‘struct talitos_edesc’
> > > 
> > > Seen with both v4.19.58-92-gd66f8e7 and v5.1.17-137-gde182b90f76d.
> > > 
> > > This problem is caused by "crypto: talitos - fix hash on SEC1.", which will
> > > need a proper backport - struct talitos_edesc is declared later in the
> > > source file.
> > 
> > Ick, let me go drop this one after breakfast...
> > 
> 
> Turns out this affects all three branches (v4.19. v5.1, and v5.2).

Ok, dropping it now (sorry, longer than just breakfast...)

greg k-h
