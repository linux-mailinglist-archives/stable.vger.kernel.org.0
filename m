Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974EF3291A6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243456AbhCAU3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:29:33 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:39434 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243286AbhCAUXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:23:45 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2021 15:23:45 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614629780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B/ujJxxWhi8iH6kW3BNk+UwJgKAp8t1KiRtcZ6xK4bc=;
        b=GP9uHqMuuWG2ClzeLZonBGMVDAliD6lajc471sQpNdhIsc6FKkrTx/WddTJmEa++LoH8Eq
        lm0jUijo7yw4unCIF6g+SGSJtDiA+FKNY89fYkxM6JmLahnVKUu3Lzs29tXHx+BZ9kKhTe
        PzfJHCnqJaQJQLkj91WiLnETIdsALJk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e018c367 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 1 Mar 2021 20:16:19 +0000 (UTC)
Date:   Mon, 1 Mar 2021 21:16:17 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sahaj Sarup <sahaj.sarup@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: sparc: icmpv6.h:70:2: error: implicit declaration of function
 '__icmpv6_send'; did you mean 'icmpv6_send'?
 [-Werror=implicit-function-declaration]
Message-ID: <YD1LkefVa5gbgpzI@zx2c4.com>
References: <CA+G9fYvxM8ECmog5rGSesSUmw3NsmXYZfdg957-37B_BDm=R9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+G9fYvxM8ECmog5rGSesSUmw3NsmXYZfdg957-37B_BDm=R9Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

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
> 
> Ref:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1064179275#L62

That looks like a 4.19 build, not 5.11. Is that correct?

Thanks,
Jason
