Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255D728DB92
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 10:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgJNIbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 04:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgJNIbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 04:31:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AA6A20BED;
        Wed, 14 Oct 2020 08:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602664295;
        bh=i7qxKdEIB/6jzRVpLam0aavq0LdtdCOf7dV7AuGAYlU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kzd/UipnB/ktxcl/oVgeGV3J7bx0zgzgsv1J30bAb/ekKyDgXAQCXSzcancdp5e3h
         0cuvhpQ9NUv1hctoXmYw10zhhi2EGpVxFRF3W0Tdjl18gi2DDXtDR3V0ynwMU+7L8Y
         N6x5GQQLbVeEI2E7OPihTsMQYQt4aZ3aqyRjAwok=
Date:   Wed, 14 Oct 2020 10:32:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/49] 4.19.151-rc1 review
Message-ID: <20201014083211.GA3034607@kroah.com>
References: <20201012132629.469542486@linuxfoundation.org>
 <20201013181135.GA23594@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013181135.GA23594@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 08:11:35PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.151 release.
> > There are 49 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> > Anything received after that time might be too late.
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

thanks for testing 2 of these and letting me know.

greg k-h
