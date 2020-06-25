Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24435209FEB
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 15:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404974AbgFYNae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 09:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404872AbgFYNae (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 09:30:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEC7020781;
        Thu, 25 Jun 2020 13:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593091834;
        bh=kTR/iLxjF/lcWHpuVFsRSdgI4rsOP4Auvx2ZjW7rDGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MyPuup7aPYDP1eQ6soRoVqO18YygUZaMGUGn1S/bd1chk80P7GtowkusO3eV+psAa
         +MB2c+K66jGTbYx01xCuYJmjVF1LqNTbMc1yDtsRODVO69nDzF5mPgylMOlprrHLli
         MlaTKVGBDhBUDeyk2WmnT8kSWwzCAgvXMt5JRJ+I=
Date:   Thu, 25 Jun 2020 15:30:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/477] 5.7.6-rc1 review
Message-ID: <20200625133030.GA3528477@kroah.com>
References: <20200623195407.572062007@linuxfoundation.org>
 <86d738fd-5f5d-9328-6d7b-6f5148bc3e72@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86d738fd-5f5d-9328-6d7b-6f5148bc3e72@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 03:57:39PM -0600, Shuah Khan wrote:
> On 6/23/20 1:49 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.6 release.
> > There are 477 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 25 Jun 2020 19:52:30 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
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
