Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF88173817
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 14:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgB1NQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 08:16:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgB1NQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 08:16:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E158246B2;
        Fri, 28 Feb 2020 13:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582895809;
        bh=kmwO2duRmxrJ+p701KSv+i2iZUGdm8OdYHFt5luodto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JJEkvhEV8ejzUQW+yZFzWDs/7AEP/Bc5fRB0HdNy3R6My5bUlMPOf8j3f8ESCDA2W
         cmnHO65NXGHJ31lBuf56eHp+xJXXMhrY5/0nt+J8LLvVSTE8dj+obhU6oZcju00cjc
         imCckjkxjCh+WFtAwh0YfbDyjoajWiHshFt5darg=
Date:   Fri, 28 Feb 2020 14:16:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/150] 5.5.7-stable review
Message-ID: <20200228131647.GA3020536@kroah.com>
References: <20200227132232.815448360@linuxfoundation.org>
 <e1772ba8-f03a-4423-b41c-ca54e85ad7e2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1772ba8-f03a-4423-b41c-ca54e85ad7e2@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 08:35:09PM -0700, shuah wrote:
> On 2/27/20 6:35 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.7 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.7-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
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
