Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090392F9280
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbhAQNVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:21:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbhAQNVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:21:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18F772225C;
        Sun, 17 Jan 2021 13:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610889666;
        bh=UkAgr5dxO44FUCOFdWvIis4FHp7LW8AWCYjLQK+y6+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hpBjRwQFZ8AMEa8/oJRoa1BygmJN+XFQMvNYpa3ZPkGOZlVWngxs34eZzooJR3F+R
         BhIpak5fk/ypIhI3wQmmPziRlVagKA3sPLuDWzGpwrZ0oHx+S/VjH5vwCui7YUmEG8
         5IRrz8fVyJRDX0hnnECM51QazoR+pBuc6dYOdmyc=
Date:   Sun, 17 Jan 2021 14:21:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.8-rc1 review
Message-ID: <YAQ5wG/wSIGxdzUC@kroah.com>
References: <20210115122006.047132306@linuxfoundation.org>
 <20210115211933.GF128727@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115211933.GF128727@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 01:19:33PM -0800, Guenter Roeck wrote:
> On Fri, Jan 15, 2021 at 01:26:53PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.8 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing and letting me know.

greg k-h
