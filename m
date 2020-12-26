Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10B12E2E6F
	for <lists+stable@lfdr.de>; Sat, 26 Dec 2020 16:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgLZPHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Dec 2020 10:07:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgLZPHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Dec 2020 10:07:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61514207CC;
        Sat, 26 Dec 2020 15:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608995192;
        bh=Hl4vizK6C4S6cGoWHESdlWX1lT0dXDgibrvHB8P9H+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UEbuBzqSNwXUTQpLain+yuyo39J7YOQ/h5Xdf9FwjIpQyOCIpaOX2rM0bLdPUnFiI
         BIf79S9LiJ21BtNGAtJ0f46MBb34/0eyPeZnB3UkZ5USCeETIHq+HrL1SYWIMOEp9A
         9P+AR/uiJDNSN6FKhzIN/W82F6oESCFF2xj5I/zg=
Date:   Sat, 26 Dec 2020 16:06:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
Message-ID: <X+dRdGzSDkeg77gE@kroah.com>
References: <20201223150515.553836647@linuxfoundation.org>
 <823a5a22-59d6-4564-4f77-81ccf648a579@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <823a5a22-59d6-4564-4f77-81ccf648a579@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 24, 2020 at 07:26:45AM -0800, Guenter Roeck wrote:
> On 12/23/20 7:33 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.3 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 25 Dec 2020 15:05:02 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing!

greg k-h
