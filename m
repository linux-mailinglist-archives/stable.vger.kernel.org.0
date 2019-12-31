Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C8212DA47
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 17:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfLaQSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 11:18:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfLaQSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Dec 2019 11:18:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBD79205ED;
        Tue, 31 Dec 2019 16:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577809130;
        bh=1BmX/9uyTuHbAwuq+zHAduZlUwujlsL+eGzJlEzVzpg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ufa+j/83KQNDWFS9zIiFp1cJgDHVAdKX3bJPd1hC4IrP1PPr3aHyMDXr4T44vfqtw
         rqQMgSPU0Ncn7opgvDklpLz3+4tTkqY+q32c+y8JJlmhf6VsUZz7/+mdisj7QCNK+R
         2H0bnFKvDH0kjEzchrv8KBSDTfJ1LcbMD2NyR30M=
Date:   Tue, 31 Dec 2019 17:18:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/161] 4.14.161-stable review
Message-ID: <20191231161848.GC2279398@kroah.com>
References: <20191229162355.500086350@linuxfoundation.org>
 <20191231160325.GA11542@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231160325.GA11542@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 31, 2019 at 08:03:25AM -0800, Guenter Roeck wrote:
> On Sun, Dec 29, 2019 at 06:17:28PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.161 release.
> > There are 161 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> > Anything received after that time might be too late.
> > 
> 
> For -rc2:
> 
> Build results:
> 	total: 172 pass: 172 fail: 0
> Qemu test results:
> 	total: 373 pass: 373 fail: 0

Great, thanks for testing and letting me know.

greg k-h
