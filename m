Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DEB1FD2D7
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 18:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgFQQwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 12:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgFQQwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 12:52:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 499C820897;
        Wed, 17 Jun 2020 16:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592412740;
        bh=uV3IiYjFlLVwwg7PEdc7kiPq2Jybg2uBJNU2nbR9T/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FFIhvyWEaYEeh0v9V0/oo7jImzSl6V12N36WKEyOxQUjdk78Yd0cPikkpkU59micW
         vhfx+4NDS5YeIHKEXhlYItNd5AyOZn/NcA+RD59HJgAoiv82pS/+HL2fZQmWivyE56
         ehsOt4xjzZSvtRph7zVa8hsvivbqRKbkgAHl14tY=
Date:   Wed, 17 Jun 2020 18:52:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/162] 5.7.3-rc2 review
Message-ID: <20200617165213.GC3794995@kroah.com>
References: <20200616172615.453746383@linuxfoundation.org>
 <20200617141634.GC93431@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617141634.GC93431@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 17, 2020 at 07:16:34AM -0700, Guenter Roeck wrote:
> On Tue, Jun 16, 2020 at 07:27:11PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.3 release.
> > There are 162 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 18 Jun 2020 17:25:43 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 431 pass: 431 fail: 0

thanks for testing all of these and letting me know.

greg k-h
