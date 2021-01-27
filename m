Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5726305917
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbhA0LCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 06:02:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236335AbhA0K70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 05:59:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9603B20770;
        Wed, 27 Jan 2021 10:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611745014;
        bh=QDzl1ovuUSa6aCqAcBWeRjk76zT/aNmdk61ejaarg8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M9iSICozDsKJp9HIgOkzKy860uwMzbEhJkWiJqKslDjqrQq/Y63JOnSv+d/gWyyGu
         Xp5E8ngIIhG2JrErtHAjBfnOfFYdAF0y52wzvSRXFMdQpwLvMiDj8EL2+CJMgXamX4
         EqQ4RMKlTcqLUT+Wg4KXXlgHwrEAFTwWsWMAb3gk=
Date:   Wed, 27 Jan 2021 11:56:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/203] 5.10.11-rc2 review
Message-ID: <YBFG8yKLQ6AXF0Ja@kroah.com>
References: <20210126094313.589480033@linuxfoundation.org>
 <20210126113817.GA23197@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126113817.GA23197@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 12:38:17PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.11 release.
> > There are 203 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
> > Anything received after that time might be too late.
> 
> CIP testing did not find any problems here. (Due to minimal changs
> between -rc1 and rc2, that's expectd I guess)
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing 2 of these and letting me know.

greg k-h
