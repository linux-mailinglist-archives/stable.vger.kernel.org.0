Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4313329247
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243559AbhCAUmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240305AbhCAUfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:35:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C562614A7;
        Mon,  1 Mar 2021 19:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614625533;
        bh=UHbwUDibRi5SL1ewCSUWuPXoSXjGxOHrMJxQqAoXVE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kfMdLa/lzY+vz8SFbTjmfI0jcWWTacvlfEezJBhUgii+aUMHSr9I4OaypJiF5MN0c
         kV2ObSqQcOw4Gfcpmr8MF7H6CtRt/1CWeDlmmJ2r/dZSxc6GuNT6QOPGILv3PiNJvk
         PFpy78mJavsoMdssHt1iLXTcRa+sJLcTFB6cRV34=
Date:   Mon, 1 Mar 2021 20:05:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sahaj Sarup <sahaj.sarup@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: sparc: icmpv6.h:70:2: error: implicit declaration of function
 '__icmpv6_send'; did you mean 'icmpv6_send'?
 [-Werror=implicit-function-declaration]
Message-ID: <YD06+unUAIh8ufOl@kroah.com>
References: <CA+G9fYvxM8ECmog5rGSesSUmw3NsmXYZfdg957-37B_BDm=R9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvxM8ECmog5rGSesSUmw3NsmXYZfdg957-37B_BDm=R9Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 10:42:34PM +0530, Naresh Kamboju wrote:
> On stable rc 5.11 sparc allnoconfig and tinyconfig failed with gcc-8,
> gcc-9 and gcc-10.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=sparc
> CROSS_COMPILE=sparc64-linux-gnu- 'CC=sccache sparc64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> <stdin>:1335:2: warning: #warning syscall rseq not implemented [-Wcpp]
> In file included from include/net/ndisc.h:50,
>                  from include/net/ipv6.h:21,
>                  from include/linux/sunrpc/clnt.h:28,
>                  from include/linux/nfs_fs.h:32,
>                  from init/do_mounts.c:22:
> include/linux/icmpv6.h: In function 'icmpv6_ndo_send':
> include/linux/icmpv6.h:70:2: error: implicit declaration of function
> '__icmpv6_send'; did you mean 'icmpv6_send'?
> [-Werror=implicit-function-declaration]
>    70 |  __icmpv6_send(skb_in, type, code, info, &parm);
>       |  ^~~~~~~~~~~~~
>       |  icmpv6_send
> cc1: some warnings being treated as errors
> make[2]: *** [scripts/Makefile.build:304: init/do_mounts.o] Error 1
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

What is the odds that Linus's tree also fails with this configuration
and arch right now?

thanks,

greg k-h
