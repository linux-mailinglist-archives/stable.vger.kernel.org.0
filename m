Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8632B9251
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 13:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgKSMNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 07:13:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgKSMNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Nov 2020 07:13:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ECF3206D5;
        Thu, 19 Nov 2020 12:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605788001;
        bh=5udg/3TsFPOvmXPOVOm10/2VGSSaG6LhMIAotNo3zc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=giS+EFLUImj1vYZ9nswoSVNVF0xwDz3QeqZDbbA5nWLCl7rnyXZNTYasMrvcyakWB
         EcokcjQPSIaD0837/2xJ8IrvfNJ85Q55RvHjH10Ou/v821FK4iUMdJNnz9Y45kihlR
         05+Zn445AkxL8j8vLBHozOrh9x1X8w6378gkgJ7M=
Date:   Thu, 19 Nov 2020 13:14:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/255] 5.9.9-rc1 review
Message-ID: <X7ZhjUYTZxzmUh58@kroah.com>
References: <20201117122138.925150709@linuxfoundation.org>
 <06bf0c38-a484-86c7-5a6b-5191c79c143b@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06bf0c38-a484-86c7-5a6b-5191c79c143b@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 03:04:01PM -0700, Shuah Khan wrote:
> On 11/17/20 6:02 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.9 release.
> > There are 255 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
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

Thanks for testing them all and letting me know.

greg k-h
