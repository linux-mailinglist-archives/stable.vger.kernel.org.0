Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E15125CE5
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 09:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfLSIob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 03:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfLSIoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 03:44:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03A8B24650;
        Thu, 19 Dec 2019 08:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576745070;
        bh=UX6kGOjM03rADOWcCLSrdOGNZ7etcKRLSdYrfQGuKI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M4qIsSHf8SoqLufVcTas2dcJnhLGNiZixs92UUDvGlWxl6aRRHd0NXkuefcW3aGyg
         dqYFwnSS3hqrXJgt4oMPYtHfWEY2LxBsmkSz9ujlG9W+NxUqU/l97hBDdqqhpk7BEI
         ZQYQCxBzPn/uQNEYyXcOFlig6nKbnIEYi7weyDw4=
Date:   Thu, 19 Dec 2019 09:44:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/37] 5.4.5-stable review
Message-ID: <20191219084428.GA1027830@kroah.com>
References: <20191217200721.741054904@linuxfoundation.org>
 <6cec4c6c-ff54-0cf9-3cbc-1581c24d7d97@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cec4c6c-ff54-0cf9-3cbc-1581c24d7d97@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 01:59:31PM -0700, shuah wrote:
> On 12/17/19 1:09 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.5 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 19 Dec 2019 20:06:21 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.5-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing both of these and letting me know.

greg k-h
