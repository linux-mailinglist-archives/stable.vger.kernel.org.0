Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553B31DAA02
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 07:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgETFj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 01:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgETFj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 01:39:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F38592075F;
        Wed, 20 May 2020 05:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589953197;
        bh=GF8ALfHDQj6gILoTls7FkitIXQLfUzf016GL4L23y34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1jiYRcghXY1WwFoqBIffuHXT5XJEFtiS5T3iFrSVMsq42QV2v/SXR3xFma2DNOmIb
         0ZXaIpAjw+gOfY5N51JrleEbg1RCvdRkSxFEeMa7XJ7Yl3iGuyVezBXsgERB4Rzh9W
         VMaRLJi4kpiAyKrlNC1f50E1btEz2/wRlP5SdxwA=
Date:   Wed, 20 May 2020 07:39:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/192] 5.6.14-rc2 review
Message-ID: <20200520053954.GB2174594@kroah.com>
References: <20200519054650.064501564@linuxfoundation.org>
 <981436bc-c36d-32e8-73ca-e121b4aea948@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <981436bc-c36d-32e8-73ca-e121b4aea948@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 09:30:22AM -0700, Guenter Roeck wrote:
> On 5/18/20 10:47 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.14 release.
> > There are 192 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 21 May 2020 05:45:41 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 431 pass: 431 fail: 0

Great, thanks for testing all of these and letting me know.

greg k-h
