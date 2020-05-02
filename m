Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE06A1C2383
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 08:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgEBGR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 02:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726058AbgEBGR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 02:17:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4F1A21775;
        Sat,  2 May 2020 06:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588400248;
        bh=//nlECgryOelNdzOoFPqzRTJSfSuHWAatQp8ys5mRaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rDwxi5CbMZb6/AsUVW66xu0cv5yN9flOBBCcbixdLaHmUmM+q2jFPcMK/TgcOvNS6
         4XrqItx7ZzKjnkakzRnDj8N6nAqpB/JJKKYmTeBazOHpMC6zPGyMBt2j+AJDe9lEKv
         Rdu2vJBpLX4F+YsTUYjpCzDTbm8ZKfc7VamEdD1o=
Date:   Sat, 2 May 2020 08:17:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/106] 5.6.9-rc1 review
Message-ID: <20200502061726.GA2531911@kroah.com>
References: <20200501131543.421333643@linuxfoundation.org>
 <20200501221831.GF44185@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501221831.GF44185@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 03:18:31PM -0700, Guenter Roeck wrote:
> On Fri, May 01, 2020 at 03:22:33PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.9 release.
> > There are 106 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
