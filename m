Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2FE710826B
	for <lists+stable@lfdr.de>; Sun, 24 Nov 2019 08:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKXHAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Nov 2019 02:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfKXHAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Nov 2019 02:00:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0043207FC;
        Sun, 24 Nov 2019 07:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574578838;
        bh=NzzqisF+akJ9nukjZHOfzaIXXKGif2YRt2J9cwGPjwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ie1Bb5/q33DsFwagOoqV8xwsLY5P0dDbLONgbo8+lDgTQfIv/FMse0gB/8jssPf2Z
         CnITMSdepSBzqfInRmKqIs86B4v9TUEr36WgzqhDd8KDkIEPwIs/T0qRgDFzwHOJvM
         9YdA1xCD8s4gXzJSScRmbu6bU5KvzvDYZUIEQxqg=
Date:   Sun, 24 Nov 2019 08:00:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 0/6] 5.3.13-stable review
Message-ID: <20191124070034.GA2229527@kroah.com>
References: <20191122100320.878809004@linuxfoundation.org>
 <20191122181407.GE13514@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122181407.GE13514@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 10:14:07AM -0800, Guenter Roeck wrote:
> On Fri, Nov 22, 2019 at 11:30:02AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.13 release.
> > There are 6 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 156 pass: 156 fail: 0
> Qemu test results:
> 	total: 390 pass: 390 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
