Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D8A25BE6E
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 11:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgICJ2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Sep 2020 05:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgICJ2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Sep 2020 05:28:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32B19206C0;
        Thu,  3 Sep 2020 09:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599125318;
        bh=jTKNSFC0rUuuQ2H61NOt/joQnR4J5RR9Re5/rDJAZUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o5YhlEgtqgkiEzxFFDuD3nsSULH7o4Y/T/pNAM4oWP6nzPLUvXXiL8qii2+tQtcyl
         qFl2B17on9mxC7PmHUhCQp+Z0dM6NWg7fLWtxBBDYxmuX4P4e++XB0ESAsNChTwppZ
         naYvuW4eGcGeWIf+MDajyGdbPdWJn7QeX3bHSyV0=
Date:   Thu, 3 Sep 2020 11:29:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/255] 5.8.6-rc1 review
Message-ID: <20200903092902.GC2220117@kroah.com>
References: <20200901151000.800754757@linuxfoundation.org>
 <5774a892-bf17-c759-0616-aaec4b740b9d@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5774a892-bf17-c759-0616-aaec4b740b9d@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 04:19:59PM -0600, Shuah Khan wrote:
> On 9/1/20 9:07 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.6 release.
> > There are 255 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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
