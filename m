Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CB918B9D6
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 15:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgCSO7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 10:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgCSO7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 10:59:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FFAE20782;
        Thu, 19 Mar 2020 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584629943;
        bh=QYecqSd02Nj2TlGYTfbNFSxRHUgkqUMuykRd9RA3qJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wN3pajYOYJ0vop6SHhK4Cg+Ngfw8xwyeqKEN8QJ8tq9chfcp1xuocXdx9sttuGRfD
         WmD3rYQxkyDugxVLuNn32yN1syAZDxZ2ox8Mh5xP6Vo/BujCORKQOPfgRwq/jbJ/8I
         QCm8RTepMq+SpVqvOSrXEToXUpipsl51o1tEYRUw=
Date:   Thu, 19 Mar 2020 15:59:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>
Subject: Re: [PATCH 5.5 00/65] 5.5.11-rc1 review
Message-ID: <20200319145900.GC92193@kroah.com>
References: <20200319123926.466988514@linuxfoundation.org>
 <fcf6db4c-cebe-9ad3-9f19-00d49a7b1043@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcf6db4c-cebe-9ad3-9f19-00d49a7b1043@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 07:44:33AM -0700, Guenter Roeck wrote:
> On 3/19/20 6:03 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.11 release.
> > There are 65 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> > Anything received after that time might be too late.
> > 
> 
> arm:davinci_all_defconfig fails to build.
> 
> include/linux/gpio/driver.h: In function 'gpiochip_populate_parent_fwspec_twocell':
> include/linux/gpio/driver.h:552:1: error: no return statement in function returning non-void [-Werror=return-type]
>   552 | }
> 
> The problem is caused by commit 8db6a5905e98 ("gpiolib: Add support for the
> irqdomain which doesn't use irq_fwspec as arg") which is missing its fix,
> commit 9c6722d85e922 ("gpio: Fix the no return statement warning"). That one
> is missing a Fixes: tag, providing a good example why such tags are desirable.

Thanks for letting me know, I've now dropped that patch (others
complained about it for other reasons) and will push out a -rc2 with
that fix.

thanks,

greg k-h
