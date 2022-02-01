Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC064A5E2B
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 15:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239212AbiBAOZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 09:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239185AbiBAOZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 09:25:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57618C061714;
        Tue,  1 Feb 2022 06:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98B7BB8013C;
        Tue,  1 Feb 2022 14:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3D2C340EB;
        Tue,  1 Feb 2022 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643725516;
        bh=wHIeeX9U5AwcjNo/guzOtcE27pXsW5eq/T0M+mw+YDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y1MNdRppEWVwnLr3TFvtLN7X/DBujdUvqy1mxoROshVIpCQXwHIA2a6R2Hc8X7gLF
         ufgGZfAjlGx+BiTtUw/7glBlyUDvk3sumQtgjtBqdOJwS7+K/8/hQUfoceSUFs1yod
         c2Y/LKqoY0Q7754U6kNwZOc2vbdH55Rf3zQgY9zo=
Date:   Tue, 1 Feb 2022 15:25:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 5.15 000/171] 5.15.19-rc1 review
Message-ID: <YflCyZEtKTqyGKzX@kroah.com>
References: <20220131105229.959216821@linuxfoundation.org>
 <20220201042743.GC2556037@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201042743.GC2556037@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 08:27:43PM -0800, Guenter Roeck wrote:
> On Mon, Jan 31, 2022 at 11:54:25AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.19 release.
> > There are 171 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 156 pass: 155 fail: 1
> Failed builds:
> 	powerpc:ppc32_allmodconfig
> Qemu test results:
> 	total: 488 pass: 488 fail: 0
> 
> The build failure is not new; I did not build powerpc:ppc32_allmodconfig
> before. The build error is:
> 
> drivers/mtd/nand/raw/mpc5121_nfc.c: In function 'ads5121_select_chip':
> drivers/mtd/nand/raw/mpc5121_nfc.c:294:26: error: unused variable 'mtd'
> 
> Fix is upstream commit 33a0da68fb07 ("mtd: rawnand: mpc5121: Remove unused
> variable in ads5121_select_chip()") which needs to be applied to v5.15.y
> and v5.16.y.

Thanks, I'll go queue that up now.

greg k-h
