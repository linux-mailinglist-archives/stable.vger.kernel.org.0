Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD4D2E2E72
	for <lists+stable@lfdr.de>; Sat, 26 Dec 2020 16:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgLZPHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Dec 2020 10:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgLZPHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Dec 2020 10:07:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFA93207D0;
        Sat, 26 Dec 2020 15:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608995231;
        bh=drfiZm2c7GITupaqDgBQaUcB72Tn3WTac7f6pULrBz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mPI/j7i/KE5Eau19BfQu5U9Xsd66D3Fp1AvTg8jmUrRQk7HAmMsL3dC7HtAjEMnz5
         wD7dGTA43/UX8Gf42pkVLG9D8bJLt+JRTnVUGofV3uaC/RkR7NBZC5WFB4mYID9r2E
         +QnRF0hJf8p/zff9gUyDUEKY7k75Tu9ZK0+nwGdo=
Date:   Sat, 26 Dec 2020 16:07:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
Message-ID: <X+dRm6A+Dr8gIiMX@kroah.com>
References: <20201223150515.553836647@linuxfoundation.org>
 <60e63371-98cb-8cf0-4d23-0e1185902fa4@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60e63371-98cb-8cf0-4d23-0e1185902fa4@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 06:56:56PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 12/23/20 9:33 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.3 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 25 Dec 2020 15:05:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing!

greg k-h
