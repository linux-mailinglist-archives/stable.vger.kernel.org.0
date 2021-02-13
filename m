Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F98B31AB6F
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 13:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBMM6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 07:58:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhBMM6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 07:58:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC2AF64E3F;
        Sat, 13 Feb 2021 12:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613221087;
        bh=VzxdHlROQQSY3+/HI+4EFj0/P29wTFi0zMgEcZmBcJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B2rTbASTGzV0gvAx2xJJDWI0ty82iwtYn9hmFhpH3qip1H06RrWSfNhatZH+IVywN
         ch4r9wjDeqxLPLL0Ui3NA2XQXsCfzSvapQRsze9citAb91OccRPyFi5HzFBwVXw2yO
         kK577+YbcEPaXkBSLHv7BZh+p/764vKI5uBl1tv0=
Date:   Sat, 13 Feb 2021 13:58:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
Message-ID: <YCfM28YLrrvVUDqR@kroah.com>
References: <20210211150152.885701259@linuxfoundation.org>
 <20210212195401.GB30277@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212195401.GB30277@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 08:54:01PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.16 release.
> > There are 54 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing some and letting me know.

greg k-h
