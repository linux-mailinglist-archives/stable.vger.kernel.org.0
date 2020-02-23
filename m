Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22901698C7
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 18:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgBWRL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 12:11:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBWRL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 12:11:29 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32EFF206E0;
        Sun, 23 Feb 2020 17:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582477888;
        bh=8OqyEc7QNyMjoxGmRiTLt1GHC5rgEgONufByIwUsCfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2MtTavgKoK5qRZ5VqTTxSalzi9v3SSijmLs3uSd/UKixNKt0syBDc6Z5fGoEdcDMI
         WnE3THI6SHQOubFJR/5BWGJzwP8s3vlpweWz6LeCBcSRDFMsOxzCZcPbI3re6JV7it
         Xea7UwaNKItKjKGLFVbZh4rVVKPhnkpLc51tOATM=
Date:   Sun, 23 Feb 2020 18:11:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
Message-ID: <20200223171126.GB275658@kroah.com>
References: <20200221072349.335551332@linuxfoundation.org>
 <45ea9919-8924-fd56-6c78-3cf7f23bb7ff@roeck-us.net>
 <9a4b6a0a2cbc6264e691b501ac962767283f08ad.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a4b6a0a2cbc6264e691b501ac962767283f08ad.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 03:15:02PM +0000, Ben Hutchings wrote:
> On Fri, 2020-02-21 at 06:22 -0800, Guenter Roeck wrote:
> > On 2/20/20 11:36 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.22 release.
> > > There are 344 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build reference: v5.4.21-345-gbae6e9bf73af
> > gcc version: x86_64-linux-gcc (GCC) 9.2.0
> > 
> > Building x86_64:allnoconfig ... failed
> > --------------
> > Error log:
> > arch/x86/kernel/unwind_orc.c: In function 'unwind_init':
> > arch/x86/kernel/unwind_orc.c:278:56: error: 'orc_sort_cmp' undeclared (first use in this function)
> > 
> > Affects v{4.14,4.19,5,4,5,5}.y.queue.
> 
> This seems to be due to commit 22a7fa8848c5 (x86-unwind-orc-fix-
> config_modules-build-warning.patch), which is only valid after commit
> f14bf6a350df "x86/unwind/orc: Remove boot-time ORC unwind tables
> sorting".

Ugh, sorry about that, now dropped from everywhere.  I'll push out a
-rc3 soon...

greg k-h
