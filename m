Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8CD28DE16
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgJNJ5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbgJNJ5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 05:57:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3375520757;
        Wed, 14 Oct 2020 09:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602669422;
        bh=ZhhRvy0PMfe2YTsEKm0W0IVnzqXGdd4kyEBsR+wwfeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VRK1dErWf57Mk5B3Fr01YaiTkTvfG4UzC4W3dhcxDBaObaiZHCKqn+eZbpP8V9q6l
         j3kIHKtLzqJX8j8177mRJeQ+uEOX/j/Isx4voJ7RJBH/F5DnKjWhWmaLPxM2Zqm67j
         0StwjFmYmkEND1w11EP/uBIrm0HeMSHo4OjoouOE=
Date:   Wed, 14 Oct 2020 11:57:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/124] 5.8.15-rc1 review
Message-ID: <20201014095737.GE3599360@kroah.com>
References: <20201012133146.834528783@linuxfoundation.org>
 <75488e9d-392a-0a15-cfb2-5ba00e04f9f5@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75488e9d-392a-0a15-cfb2-5ba00e04f9f5@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 07:21:50PM -0600, Shuah Khan wrote:
> On 10/12/20 7:30 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.15 release.
> > There are 124 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Oct 2020 13:31:22 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.15-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing all of them and letting me know.

greg k-h
