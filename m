Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222941E4BE3
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 19:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgE0Rag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 13:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgE0Rag (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 13:30:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32DA22075A;
        Wed, 27 May 2020 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590600635;
        bh=uCheWP0RRdcKgswz2mo82OhL1DROGME9HKnFGxF7iEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PtHD1zEQEGidw92ybPOQEyLX1Au+AklTvp69WTUKLRcKbKsTYBKuMrBfzoMXmSRA0
         /wtvAV7ZLLCPpo9okeUF1o3YiHGIil9hQ8T6+zcIm6fFlJlXfcMRlKQCvdr0nAFZOr
         UQfSU17pN2QlNwxhjuEqPhovHGD5mYOQP5wyszM0=
Date:   Wed, 27 May 2020 19:30:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/126] 5.6.15-rc1 review
Message-ID: <20200527173033.GA933114@kroah.com>
References: <20200526183937.471379031@linuxfoundation.org>
 <7cb6fb39-5161-4111-8626-746eff5405ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cb6fb39-5161-4111-8626-746eff5405ce@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 10:28:00AM -0600, shuah wrote:
> On 5/26/20 12:52 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.15 release.
> > There are 126 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.15-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
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
