Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEDE3E7CAC
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 17:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242316AbhHJPqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 11:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242284AbhHJPpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 11:45:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5633F60C40;
        Tue, 10 Aug 2021 15:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628610280;
        bh=DyjL5yU1Em86ylYoW16yWtrZUlWVgtNJ9er/Qt62Pow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mw9hFo8tkWxqfbG54puXo/LSFqvzsI8fc342rmTSUhFYq9znQg3ML7/TvZnZnf2sR
         5wxRFAqdb4oNd1/MrbAA+Og++HOTFo4SdJ40HDDfkimUjO71f2is3bdSjSXSejGSlf
         mmjQihoNzAaZ+HWh3ymq4mD8hCBJgVbTBuRhwCjU=
Date:   Tue, 10 Aug 2021 17:44:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/11] 4.4.280-rc1 review
Message-ID: <YRKe5ksJhHMiN81Z@kroah.com>
References: <20210808072217.322468704@linuxfoundation.org>
 <20210808160024.GA832953@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808160024.GA832953@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 08, 2021 at 09:00:24AM -0700, Guenter Roeck wrote:
> On Sun, Aug 08, 2021 at 09:22:35AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.280 release.
> > There are 11 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 10 Aug 2021 07:22:11 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 160 pass: 160 fail: 0
> Qemu test results:
> 	total: 340 pass: 340 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Guenter

Thanks for testing and letting me know,

greg k-h
