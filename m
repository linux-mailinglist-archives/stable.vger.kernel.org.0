Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2E43418A5
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 10:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhCSJmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 05:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhCSJmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 05:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1818864F6A;
        Fri, 19 Mar 2021 09:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616146956;
        bh=jCtEid/z5ZgFFSrjZaWsDGBnuHOdSOCLQc/DANzNHY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X0TFF/tdPUt1IKK1XMMhpxkDblQrU7ZhkR73+maugvcD2vJYsDzJ7g3RuvdNyIqBu
         tUm8rlK6zeurbnk6wD+DocIpPmYR7p3iWEOf3ZRRYUix0qKNplkp3/0xZFlezAInz+
         E7uY7mrVEqCKeRdj/t3f/qjvI0wIGAN1P2G79FxE=
Date:   Fri, 19 Mar 2021 10:42:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/306] 5.11.7-rc1 review
Message-ID: <YFRyCn+tZ4rdz43H@kroah.com>
References: <20210315135507.611436477@linuxfoundation.org>
 <20210316211443.GD60156@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316211443.GD60156@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 02:14:43PM -0700, Guenter Roeck wrote:
> On Mon, Mar 15, 2021 at 02:51:03PM +0100, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.11.7 release.
> > There are 306 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 17 Mar 2021 13:54:26 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 436 pass: 436 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing them all and letting me know.

greg k-h
