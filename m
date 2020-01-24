Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCD1148D0A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 18:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390277AbgAXRhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 12:37:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390106AbgAXRhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 12:37:22 -0500
Received: from localhost (unknown [84.241.198.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EBC32087E;
        Fri, 24 Jan 2020 17:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579887441;
        bh=jVgs4yxvjm/D3IicuAVGJAnb8hZ0lRIStSmtw1Js5nQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yu4r0j8T4e7ey6QMwRoOMwkRBJ2r0uXaAW/+KTDPPWQ37OyyxFBzLwLBQT02ImjFk
         phdWvbORLjYVh+Xfgwu+4iEGPq6P4HlzxbJsrOJDHwXfAZf8HqVeC0NprLMaj1hJYP
         lFB+R7c1aLZxD7mGNGFsCdzHdKrJzLVxcEqgMetk=
Date:   Fri, 24 Jan 2020 18:33:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/343] 4.14.168-stable review
Message-ID: <20200124173346.GB3166016@kroah.com>
References: <20200124092919.490687572@linuxfoundation.org>
 <6fce449c-e0d4-7660-bee6-578bd5cefeb2@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fce449c-e0d4-7660-bee6-578bd5cefeb2@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 06:17:03AM -0800, Guenter Roeck wrote:
> On 1/24/20 1:26 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.168 release.
> > There are 343 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 26 Jan 2020 09:26:30 +0000.
> > Anything received after that time might be too late.
> > 
> 
> powerpc:allmodconfig:
> 
> arch/powerpc/kernel/kgdb.c: In function 'kgdb_arch_set_breakpoint':
> arch/powerpc/kernel/kgdb.c:451:8: error: implicit declaration of function 'probe_kernel_address'

Ah, nice catch, will go push out a -rc2 with this removed and with
Sasha's fixes.

thanks,

greg k-h
