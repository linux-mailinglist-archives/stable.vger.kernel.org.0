Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CBD2911A9
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 13:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411846AbgJQLcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 07:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411640AbgJQLcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 07:32:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D599206E5;
        Sat, 17 Oct 2020 11:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602934323;
        bh=qFcxvL/ueTNQ8dM+qDPX7QRwIYM6GSjei18kWKvhnTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kXaFfO2TPq40glasB+vLPL/Ep51R+nDuuV+4lVOj6VclAd3ddIQLcia1DUQm/QOIr
         EBcBWnIcBMPdGZPxZBmv0mGonl0OgQrLaWaU8JyGxZJu7PBnEgj+HQxJDnC1VVAB/T
         ESA2n6HIrYfLOBGiVtMeJmv1rdZaATReOngmW0B4=
Date:   Sat, 17 Oct 2020 13:32:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/21] 4.19.152-rc1 review
Message-ID: <20201017113253.GA2978968@kroah.com>
References: <20201016090437.301376476@linuxfoundation.org>
 <20201016103354.GA11338@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016103354.GA11338@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 12:33:54PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.152 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> First post! :-).
> 
> No problems revealed by CIP testing.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing 2 of these and letting me know.

greg k-h
