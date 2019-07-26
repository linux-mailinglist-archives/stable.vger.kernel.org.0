Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF9175FC3
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 09:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfGZHZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 03:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfGZHZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 03:25:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B17218B0;
        Fri, 26 Jul 2019 07:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564125935;
        bh=Fb30JrLkT7/ZIwl1lYL8/IT1R3rDhX5WjdX0Z6G6y+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TfVRuSxPISk+31hFik/jYFDBVX5slpBlXrupVqXoChU7rFgALBwpiyNFtV3Fj3wTa
         wmf3zsGweoCAiqYUuFfIH4FXsj8u5MNJtgWdVsbrHbxuWac1vc/h042vEO9RaVBIJE
         n5Z0ppysGJ2HPhUTju0kBm+u0/W36Qos/4F2rLgw=
Date:   Fri, 26 Jul 2019 09:25:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kelsey Skunberg <skunberg.kelsey@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
Message-ID: <20190726072533.GD19756@kroah.com>
References: <20190724191735.096702571@linuxfoundation.org>
 <20190726061854.GA4075@JATN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726061854.GA4075@JATN>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 12:18:54AM -0600, Kelsey Skunberg wrote:
> On Wed, Jul 24, 2019 at 09:14:51PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.3 release.
> > There are 413 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Compiled and booted with no regressions on my system.

Great, thanks for testing and letting me know.

greg k-h
