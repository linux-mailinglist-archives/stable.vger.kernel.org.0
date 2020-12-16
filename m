Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DF62DC111
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 14:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgLPNUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 08:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgLPNUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 08:20:24 -0500
Date:   Wed, 16 Dec 2020 14:20:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608124783;
        bh=D3eLwlDXOdShqlBUzATTq6VzotPEnEQLnnlHUjpS0z0=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=q9YmKR9x/pE7uzjjHPMDP4PkI2ksfgKoJorWLqxT0xtcrfm2qLpqsQiRp8sprjBxh
         jVYZAhXfAkJ96d9FfkvNdJwyTx8yMqO/sE5eJw7qRXwR/2lNovbCVZnrLL6ObjRSQs
         P9i/DoawNb1ckOqc0XDpF+xx8GwQ5/f+GuNmhixw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/105] 5.9.15-rc1 review
Message-ID: <X9oJrEnq46raimPh@kroah.com>
References: <20201214172555.280929671@linuxfoundation.org>
 <f70996b9-9c9d-6a6d-2468-b00443d83905@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f70996b9-9c9d-6a6d-2468-b00443d83905@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 04:53:20PM -0700, Shuah Khan wrote:
> On 12/14/20 10:27 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.15 release.
> > There are 105 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.15-rc1.gz
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

Thanks for testing and letting me know.

gre gk-h
