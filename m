Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D36D23ABB1
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 19:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgHCRdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 13:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbgHCRdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 13:33:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1559A20792;
        Mon,  3 Aug 2020 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596476027;
        bh=2naqeHvLiLtwprqSiylF2YGRkOK9THB+M7+cZVJOxCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aatV76knd5VTEmj7cAS7DnhxV1olLGHhmxgnrIDWAQ6CWVC3tjBI1bzuWX6ofIxgz
         xTaFVPuov+aidiuU8pyxosIZlvtAgkeNtG+1eJuXrK4qZksIP5MLvbnW5u1QsMkHPN
         Ve4gicMEt4dONJD8U12x7K+ItfouU1lvIhsKb2CM=
Date:   Mon, 3 Aug 2020 19:33:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/120] 5.7.13-rc1 review
Message-ID: <20200803173330.GA1186998@kroah.com>
References: <20200803121902.860751811@linuxfoundation.org>
 <20200803155820.GA160756@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803155820.GA160756@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 08:58:20AM -0700, Guenter Roeck wrote:
> On Mon, Aug 03, 2020 at 02:17:38PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.13 release.  There
> > are 120 patches in this series, all will be posted as a response to this one.
> > If anyone has any issues with these being applied, please let me know.
> > 
> > Responses should be made by Wed, 05 Aug 2020 12:18:33 +0000.  Anything
> > received after that time might be too late.
> > 
> 
> Building sparc64:allmodconfig ... failed
> --------------
> Error log:
> <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> In file included from arch/sparc/include/asm/percpu_64.h:11,
>                  from arch/sparc/include/asm/percpu.h:5,
>                  from include/linux/random.h:14,
>                  from fs/crypto/policy.c:13:
> arch/sparc/include/asm/trap_block.h:54:39: error: 'NR_CPUS' undeclared here (not in a function)
>    54 | extern struct trap_per_cpu trap_block[NR_CPUS];
> 
> Inherited from mainline. Builds are not complete yet;
> we may see a few more failures (powerpc:ppc64e_defconfig
> fails to build in mainline as well).

If it gets fixed upstream, I'll fix it here :)

thanks,

greg k-h
