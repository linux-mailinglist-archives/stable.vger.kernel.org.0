Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1861BCC877
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 08:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfJEGuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 02:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbfJEGuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Oct 2019 02:50:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E3A72133F;
        Sat,  5 Oct 2019 06:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570258217;
        bh=1STiOpO0Zh5if1pvnZGaSsDnTwCXXWT3WdJgmTSI50s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YeX/E+9Igiy++l9Xm369u354yK3i0/dw2f1U5zS7fo6qK+YMNoGL+O84urHrqFUN9
         8AAMw/mpK5XuRk6MbjLRSZx+J1ey7m6K14I0VLLKj26nJ3Uz83ZbLdCzb/cOOKXpDM
         ckvG9qQy8xh4AvRbcj6KB050CqkCCyv8ZQ8ItwQI=
Date:   Sat, 5 Oct 2019 08:50:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/344] 5.3.4-stable review
Message-ID: <20191005065013.GA928719@kroah.com>
References: <20191003154540.062170222@linuxfoundation.org>
 <20191004230447.GA15860@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004230447.GA15860@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 04:04:47PM -0700, Guenter Roeck wrote:
> On Thu, Oct 03, 2019 at 05:49:25PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.4 release.
> > There are 344 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 158 pass: 158 fail: 0
> Qemu test results:
> 	total: 391 pass: 391 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
