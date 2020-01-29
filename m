Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7225F14C667
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 07:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgA2GRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 01:17:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgA2GRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 01:17:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CF21206A2;
        Wed, 29 Jan 2020 06:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580278651;
        bh=yWzTGoVZiwZ0LjtV7+6Rwyv3oTv1Ts0ntr+VJTvUIjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AwCM2mmPcx7NBaU55spqHjtnUoyusb+e2IfMIFtfXfz7YsHgNuFCY4JLg85WsVUAw
         OuVIMjf+CNgnBAF1+6aovMmWGTieOZ3VAr75Kv5JxiuquercbPX+8/odzgHrJzSIPP
         wNZyQI5nxhKBSStnllomy4SRUU4Ti527BgBS7FmM=
Date:   Wed, 29 Jan 2020 07:17:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/104] 5.4.16-stable review
Message-ID: <20200129061728.GA3768602@kroah.com>
References: <20200128135817.238524998@linuxfoundation.org>
 <13867bdc-88b4-5c0c-aa63-de003c44a44f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13867bdc-88b4-5c0c-aa63-de003c44a44f@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 04:00:50PM -0700, shuah wrote:
> On 1/28/20 6:59 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.16 release.
> > There are 104 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.16-rc1.gz
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

Great, thanks for testing all of these and letting me know.

greg k-h
