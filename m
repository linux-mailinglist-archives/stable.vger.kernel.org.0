Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3DA34918A
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhCYMHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230239AbhCYMHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 08:07:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B54D461A1B;
        Thu, 25 Mar 2021 12:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616674042;
        bh=ab2p6DJiCVBO6B0m6B+kh7FohANAvCJ9UCEjUAtRpCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yyCTiQpuQy3AeyppGR7p+qIJ2EmpRm3/VSVP7oqTB8pNpqPyOtXtf1UrD2zhYecEz
         6eXJ+abpnyIpJZ3kjphTU3yDqUPjAtSI64thSnRb80c1pc7La4bflrRa6wUnd2IF9G
         BeF/rl5+DQszyjxDzLPgZQGjyryBduIwAK0jdcug=
Date:   Thu, 25 Mar 2021 13:07:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/150] 5.10.26-rc3 review
Message-ID: <YFx89+z3bzhR6ec9@kroah.com>
References: <20210324093435.962321672@linuxfoundation.org>
 <20210324144214.GA224108@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324144214.GA224108@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 07:42:14AM -0700, Guenter Roeck wrote:
> On Wed, Mar 24, 2021 at 10:40:21AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.26 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Mar 2021 09:33:54 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 156 pass: 156 fail: 0
> Qemu test results:
> 	total: 433 pass: 433 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

thanks for testing them all.
