Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61181D48D4
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 10:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgEOIwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 04:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbgEOIwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 04:52:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 602B1206F1;
        Fri, 15 May 2020 08:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589532737;
        bh=fuhJSdEfA9wXBciATiW1rBSEOH0JlqUdRQedH7ApBMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NiQ3Zeetuw4T1/7QJVvJO3wN5JvHzwDyD42cxbVWRVWtxCT6o6p0JI0QoB31zS5YB
         lzSkrBPqV4nguBX5h6pp0mWY2GRfrqJBuSdC46AGrt+E33rNAnfq8oJgE2pkrXzWA3
         wrSk5LaPRLX5/GfLRrQ9jfL3RG3vGXPo1UycLEgQ=
Date:   Fri, 15 May 2020 10:52:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/118] 5.6.13-rc1 review
Message-ID: <20200515085215.GE1474499@kroah.com>
References: <20200513094417.618129545@linuxfoundation.org>
 <20200513170412.GC224971@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513170412.GC224971@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 10:04:12AM -0700, Guenter Roeck wrote:
> On Wed, May 13, 2020 at 11:43:39AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.13 release.
> > There are 118 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 15 May 2020 09:41:20 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 431 pass: 431 fail: 0

Thanks for testing them all.

greg k-h
