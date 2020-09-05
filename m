Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A8425E6BB
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 11:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgIEJ2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 05:28:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbgIEJ2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 05:28:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D690E2074D;
        Sat,  5 Sep 2020 09:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599298110;
        bh=/A50ZbK+4T3DpwzsRWE24zHeV6HPq3Y0Se11BWsh19M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sEQWMwmI7ro+bm1OkH8+f/b0k9wZ8cBrKWRK0ZGB4FlfsT8SJAjifnDeOX5oQNVNA
         Xwcp+6o7yQUbynj75qI78+ozqug1F8YPdBwrEsvRzav5uYc3TzCO4CiKaFxKcn7euC
         VuM+VeBuEqMtsxSAlqZVt5/ceoFzonuPa4sLHFWQ=
Date:   Sat, 5 Sep 2020 11:28:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/17] 5.8.7-rc1 review
Message-ID: <20200905092849.GB3975295@kroah.com>
References: <20200904120257.983551609@linuxfoundation.org>
 <20200904192345.GB211974@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904192345.GB211974@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 04, 2020 at 12:23:45PM -0700, Guenter Roeck wrote:
> On Fri, Sep 04, 2020 at 03:29:59PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.7 release.
> > There are 17 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 06 Sep 2020 12:02:48 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing both of these and letting me know.

greg k-h
