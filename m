Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D861575530
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 19:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfGYRMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 13:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727530AbfGYRMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 13:12:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C2F92238C;
        Thu, 25 Jul 2019 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564074767;
        bh=YPftwxjzIcxENrpmBlC3tx1gBgZCdzVEXa6GpdleYog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=znQb+wxg35zGrHa1JSuBFx3mQ1gjpmpYSB2ICHw7t7z8O7TQIEO1iOtAUwK4l7s0M
         P+oY5yh2GT5sqecA1uHjcyhj9Xi/li8OcadKk/t24k64GEDSwOwFUfjAdgQwo4pOaM
         g7jL+yoGafnWuXeAAQgYfmdhfQuNiYIq6hRl5WZM=
Date:   Thu, 25 Jul 2019 19:12:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/371] 5.1.20-stable review
Message-ID: <20190725171245.GA15739@kroah.com>
References: <20190724191724.382593077@linuxfoundation.org>
 <20190725163329.GA11220@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190725163329.GA11220@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 09:33:29AM -0700, Guenter Roeck wrote:
> On Wed, Jul 24, 2019 at 09:15:52PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.20 release.
> > There are 371 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Building powerpc:defconfig ... failed
> Building powerpc:allmodconfig ... failed
> 
> arch/powerpc/kernel/prom_init.c: In function ‘early_cmdline_parse’:
> arch/powerpc/kernel/prom_init.c:689:8: error: implicit declaration of function ‘prom_strstr’
> 
> plus several qemu tests failing to build for the same reason.

Found it, it's a powerpc patch.  I've now dropped it and am pushing out
a -rc2 right now with that patch removed.

thanks,

greg k-h
