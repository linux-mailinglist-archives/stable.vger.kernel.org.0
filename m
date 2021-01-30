Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3E3309534
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhA3NCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231569AbhA3NCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 08:02:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D009164E0C;
        Sat, 30 Jan 2021 13:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612011696;
        bh=8YTymH4UM235aIUfuwfR3Ni4re/rEAHJtpQwVF2UQf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gHJ5TTYWT+t1zV+NKGVloT2iSV9tRvBVcYPNihknKnh5JFXcnBVjAXwa1q2EAaJiL
         O8heI1PoCKmpecE+MC6l9c1n/aSUrN0tettjsafmA3CT8Y7NfwS6WVrUld5hQ64Owo
         UWJ/0HPei62lkVyUYTZ5XmPwtSCa0KYegMMRW+Mc=
Date:   Sat, 30 Jan 2021 14:01:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/32] 5.10.12-rc1 review
Message-ID: <YBVYrWG/q7/MJm03@kroah.com>
References: <20210129105912.628174874@linuxfoundation.org>
 <20210129182316.GF146143@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129182316.GF146143@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 10:23:16AM -0800, Guenter Roeck wrote:
> On Fri, Jan 29, 2021 at 12:07:10PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.12 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing them all and letting me know.

greg k-h
