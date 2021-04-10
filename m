Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B25135AD7B
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 15:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbhDJNQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 09:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234262AbhDJNQN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Apr 2021 09:16:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2947610F7;
        Sat, 10 Apr 2021 13:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618060559;
        bh=aUxXdcbgwyO5J4cRwq+Y2sJvYu+DdtrroMROtyupCEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SWO0OWTclHsw9ayiPIzcEHLkOE7zVwtSaV3GXoAgh+xlAHCC0Os2I9gRi+LrXwCLL
         ZnTGen3h4p7gK+Fz23dwmhoidmwF8VDnGheikkaAHxLZnI5gaTC3Es/WK+aVqWWFSJ
         gOLYBRyni4QtzISjp0wXFyiWgF9jIXSPJZzP6w40=
Date:   Sat, 10 Apr 2021 15:15:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/14] 4.14.230-rc1 review
Message-ID: <YHGlDRbuyyGL1Jqk@kroah.com>
References: <20210409095300.391558233@linuxfoundation.org>
 <20210409201306.GC227412@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409201306.GC227412@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 01:13:06PM -0700, Guenter Roeck wrote:
> On Fri, Apr 09, 2021 at 11:53:25AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.230 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 168 pass: 168 fail: 0
> Qemu test results:
> 	total: 408 pass: 408 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Having said this, I did see a spurious crash, and I see an unusual warning.
> I have seen the crash only once, but the warning happens with every boot.
> These are likely not new but exposed because I added network interface
> tests. This is all v4.14.y specific; I did not see it in other branches.
> See below for the tracebacks. Maybe someone has seen it before.

Thanks for testing all of these, I'll go queue up your reported fixes
here for the next release.

greg k-h
