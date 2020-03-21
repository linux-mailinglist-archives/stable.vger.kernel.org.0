Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB4018DE6D
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 08:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgCUHMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 03:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728144AbgCUHMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 03:12:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D185920739;
        Sat, 21 Mar 2020 07:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584774770;
        bh=ONBXm7wvSbenkXhvCMl2bQVP8Csq4D+32Z7BlpoohGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zcaI8mXKaqeYHZI1ECm2ZIUVI7JsRXV3WeLWJh0/O3nFseQBhyMwmEo8kap3V8Uct
         N0uCVZAL5c0B2XN8HPRgQ3fHG4ofF+e5faGwlGs2nfPG1/tzgzoVcGEuygAjrs6pAM
         QFmv+aYqEYOZ3o0oQrRT8YfL9lBQW3ivj7MNiGg8=
Date:   Sat, 21 Mar 2020 08:12:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/93] 4.4.217-rc1 review
Message-ID: <20200321071247.GF850676@kroah.com>
References: <20200319123924.795019515@linuxfoundation.org>
 <bf7f6d54-40c0-f772-ef1f-ff8a3c505df3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf7f6d54-40c0-f772-ef1f-ff8a3c505df3@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 20, 2020 at 06:50:52PM -0600, shuah wrote:
> On 3/19/20 6:59 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.217 release.
> > There are 93 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.217-rc1.gz
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

Wonderful, thanks for testing them all and letting me know.

greg k-h
