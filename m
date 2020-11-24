Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6BE2C31F2
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 21:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbgKXU2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 15:28:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgKXU23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 15:28:29 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD13C20678;
        Tue, 24 Nov 2020 20:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606249709;
        bh=q3HfI7eDWEvCcM5TOm/m0jW4b+ROZFornFAgJ+Eyx/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VBg+GPlxRPM8VPtbTyT3KDudmNgBeOU58+b9Z6OpnnHIEX4XKZdlHkKG3OAkgyjpf
         194csfKl++VlT//57YPqL2pHEkJVjlJcAEHkdBcEcpozQKTta7ciLgJOgw3H+G/qLv
         3icebO642dL4StJSGWktHQop3rpcabo2cZWjT8NU=
Date:   Tue, 24 Nov 2020 21:28:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/252] 5.9.11-rc1 review
Message-ID: <X71s68HjR3biZpUg@kroah.com>
References: <20201123121835.580259631@linuxfoundation.org>
 <20201123223650.GE223204@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123223650.GE223204@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 02:36:50PM -0800, Guenter Roeck wrote:
> On Mon, Nov 23, 2020 at 01:19:10PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.11 release.
> > There are 252 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 426 pass: 426 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing them all and letting me know.

greg k-h
