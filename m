Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC72124A60
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 15:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfLROxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 09:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbfLROxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 09:53:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDFD02146E;
        Wed, 18 Dec 2019 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576680813;
        bh=JkHDnOY5P9I5w10xZEaHs+fhTecywtGbMXClR5tfdIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z3Z3w0h7BclxAjayuS1bzFy6igHy+wgCXL/3XD2tyj51VFlFc+e+PBo8XkXOW7tdx
         Xf1Jg/8KZAGNHgPiv5HBc5mpq378EBpYLy6Li25Z/Ys7S6fFNf/uaG4r1OE1gNRonU
         vuS2qSlv5uTTHgqUtOrY8zGaGR1UHi44FZ4G6eX8=
Date:   Wed, 18 Dec 2019 15:53:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/37] 5.4.5-stable review
Message-ID: <20191218145326.GA387753@kroah.com>
References: <20191217200721.741054904@linuxfoundation.org>
 <20191218144831.GB19358@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218144831.GB19358@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 06:48:31AM -0800, Guenter Roeck wrote:
> On Tue, Dec 17, 2019 at 09:09:21PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.5 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 19 Dec 2019 20:06:21 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 387 pass: 387 fail: 0

Wonderful, thanks for the quick response and testing.

greg k-h
