Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215723695C0
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbhDWPM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230294AbhDWPM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:12:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40EAC613D5;
        Fri, 23 Apr 2021 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190711;
        bh=pRvdHw9EcnpaLKM69axa64lLoJKi9Cz0YmK+KqwiGDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O9lsIr/dFB67AkBgtpLoR/fZkd6/v8Q1+irMcKKYytgkcg2mYumLBaUtOouW//mwm
         k8SganjyM37qKtUrG29EluSLHI6ugaAjfdv1UIovKK3obpNWYs/Q9H+6otMaXwczZy
         LSIJU+0bx0n2gR0qHOrSwRoT2BsdRKWD2o3K8Ds8=
Date:   Fri, 23 Apr 2021 17:11:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
Message-ID: <YILjtWuUbwyVXEyc@kroah.com>
References: <20210419130527.791982064@linuxfoundation.org>
 <20210419213037.GB6626@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419213037.GB6626@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 11:30:37PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.32 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> > Anything received after that time might be too late.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> Best regards,
>                                                                 Pavel
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


Thanks for testing and letting me know.

greg k-h

