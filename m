Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BB4329244
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242517AbhCAUmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:42:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239582AbhCAUfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:35:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35A4164DE0;
        Mon,  1 Mar 2021 19:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614625471;
        bh=ZebO4o3MbO+ElTMp+7Xdoc7cm8HPQYFd1qugZVUFXgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wqcXvJTCEmuCJECSmM7W29OiqrFS/gOu/siksYdOyAuZ6QF2jSABYKILAWCrNcJ7e
         5Fm90UcsCAa3qiSA3R4giF4GSHM1WIsdoaNQBnwKQO4OfYl/VDmLFcXyNgtlYYFu+x
         lCI3kLYeLSabXuT03QH0jzObbS5qhncFgeOOQmY8=
Date:   Mon, 1 Mar 2021 20:04:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Ananth N Mavinakayanahalli <ananth@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Subject: Re: [stable-rc 5.4] powerpc/sstep: Fix incorrect return from
 analyze_instr()
Message-ID: <YD06vKTN+MRRyEAK@kroah.com>
References: <CA+G9fYsv+xCtoAYXgz5jkMLDGALjXCEvy=HiSWZigA5jLtnytQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsv+xCtoAYXgz5jkMLDGALjXCEvy=HiSWZigA5jLtnytQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 11:43:25PM +0530, Naresh Kamboju wrote:
> On stable rc 5.10 the ppc defconfig build failed due to below errors/warnings.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=powerpc
> CROSS_COMPILE=powerpc64le-linux-gnu- 'CC=sccache
> powerpc64le-linux-gnu-gcc' 'HOSTCC=sccache gcc'
> arch/powerpc/lib/sstep.c: In function 'analyse_instr':
> arch/powerpc/lib/sstep.c:1415:3: error: label 'unknown_opcode' used
> but not defined
>    goto unknown_opcode;
>    ^~~~
> make[3]: *** [scripts/Makefile.build:279: arch/powerpc/lib/sstep.o] Error 1
> make[3]: Target '__build' not remade because of errors.
> 
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Now dropped from 5.4 and 5.10 queues, thanks.

greg k-h
