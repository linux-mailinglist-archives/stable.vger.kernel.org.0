Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C68021428
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 09:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbfEQHZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 03:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727871AbfEQHZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 03:25:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F3EC206A3;
        Fri, 17 May 2019 07:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558077950;
        bh=9nE/fO+4ZI8Pp7wGyPC+w/XBE2s/Yqg0rF+yBD133Jg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QrwB2uFupfKI1BV4tXBl/FeLwR8a28rcNLg1ANf0+Un6yj5OO+vT3zlOa6G0y/HuW
         27afnVzh9bKaAyqIVGVVbsjDj9gEG+bMMqy7fv71omqXqEnssGRZM87+OlMplWVcUo
         rw3zl4WfMYEPZvrraB6F1w8M5jJGg/5U50aOUsfo=
Date:   Fri, 17 May 2019 09:25:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kelsey Skunberg <skunberg.kelsey@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
Message-ID: <20190517072548.GA2827@kroah.com>
References: <20190515090616.670410738@linuxfoundation.org>
 <20190517063401.GB2378@asus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517063401.GB2378@asus>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 12:34:02AM -0600, Kelsey Skunberg wrote:
> On Wed, May 15, 2019 at 12:56:24PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.3 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 17 May 2019 09:04:22 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Compiled and booted with no dmesg regressions on my system.

Thanks for testing some of these and letting me know.

greg k-h
