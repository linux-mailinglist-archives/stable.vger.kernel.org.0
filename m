Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7CFD134022
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 12:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgAHLRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 06:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbgAHLRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 06:17:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2F032072A;
        Wed,  8 Jan 2020 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578482263;
        bh=5aLkJfMYD7EYRkujAgNgTRs/2u3s3E+YOcu6siBzc2c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BwWwvGLQcuT2ypMyTe627gxCuL+g2TJArhhoQp9m78I9tAv0iEuAZ5hZkTdMH6s2V
         MsSb57oSXeihIONsWuoMNtmfq8TQ0PlGqboaoeY3qsHpUMLFOLgJKx53RX42RfiYEZ
         MJde0e8YCYgQw5VQ6Gd3crwhNZ7YhZvSycoydx/w=
Date:   Wed, 8 Jan 2020 07:42:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/191] 5.4.9-stable review
Message-ID: <20200108064251.GC2278146@kroah.com>
References: <20200107205332.984228665@linuxfoundation.org>
 <20200107212436.GA18475@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107212436.GA18475@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 01:24:36PM -0800, Guenter Roeck wrote:
> On Tue, Jan 07, 2020 at 09:52:00PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.9 release.
> > There are 191 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> [ ... ]
> 
> > Ming Lei <ming.lei@redhat.com>
> >     block: fix splitting segments on boundary masks
> > 
> 
> This patch causes a regression. See:
> 
> https://lore.kernel.org/linux-block/20200107181145.GA22076@roeck-us.net/T/#m4607a04fde9ef2ed80d45efacef01c0b0e8d2bfd

Thanks for letting me know, Jens also pointed this out and I've now
dropped it and will push out a -rc2 in a few minutes with it removed.

thanks,

greg k-h
