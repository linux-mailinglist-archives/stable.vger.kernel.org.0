Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A151137E3
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 08:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfEDGrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 02:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbfEDGrz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 02:47:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5094F20859;
        Sat,  4 May 2019 06:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556952474;
        bh=7l71ZSU3M+WEGSb7UqT6PUeEoXqIQnQZWKkJNyWkUUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HSe+KcnyRAROKYy00Je2AAmo65w6EVjfaJt5uPgSiFsCXTKH447PU65pSZcdlH6bt
         KH9Svi35JAvWKE9i6BLWzTzujLuwK18kL+vdPNYNSCw2RP5S7BbGSWizjWZFhYtLEf
         dkMisPrRPnYtBOtC3bQspP7Vv0t9dm4BhM4MoWBI=
Date:   Sat, 4 May 2019 08:47:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.0 000/101] 5.0.12-stable review
Message-ID: <20190504064752.GH26311@kroah.com>
References: <20190502143339.434882399@linuxfoundation.org>
 <20190503171630.GD2359@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503171630.GD2359@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 10:16:30AM -0700, Guenter Roeck wrote:
> On Thu, May 02, 2019 at 05:20:02PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.0.12 release.
> > There are 101 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 04 May 2019 02:32:10 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 349 pass: 349 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
