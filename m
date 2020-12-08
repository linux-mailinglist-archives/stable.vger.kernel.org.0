Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447492D27F7
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 10:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgLHJmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 04:42:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729048AbgLHJmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 04:42:43 -0500
Date:   Tue, 8 Dec 2020 10:43:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607420522;
        bh=w1nf9aRZwPuZBafKpjL531MngAbXEyNSYpf7tVShm2Y=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=BGH7fQQwxFG/YBy7QGfmKJ8BT9aCjvoWMVU3bdoX4VGN5kRa4or5O1yrS6ezU1/cP
         Bld+Kba7MacDJqKW3vVCf0867r+bB/6nZqY04uvo57lybaQ3OKP0gyJ/PZc2966Z3u
         3LubaJYdiMsVthFMiFfYQYclrHtx4W0q1PdF80H0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/46] 5.9.13-rc1 review
Message-ID: <X89Kr+aTg1o0KEfp@kroah.com>
References: <20201206111556.455533723@linuxfoundation.org>
 <20201207155532.GD43600@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207155532.GD43600@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 07:55:32AM -0800, Guenter Roeck wrote:
> On Sun, Dec 06, 2020 at 12:17:08PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.13 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
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
