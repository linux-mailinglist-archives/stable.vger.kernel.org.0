Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A54472C84
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 13:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhLMMoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 07:44:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51928 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbhLMMoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 07:44:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BE897CE0FBC;
        Mon, 13 Dec 2021 12:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867DFC34602;
        Mon, 13 Dec 2021 12:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639399446;
        bh=2m3wvn1F+nJcMECZUft+U0pktLZt1yY5Fc7xYXqHPek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rbmP7oSD4/nSH+lGz15FExXCMmgGbQb9aC5JciekgS7eClyZBlFdAbTdb1ATZ5NhW
         Ye9AbdirtQY5T86yXeqAptzoyapiHVec3vILD6WhNzJR8/035hSwZwPaEVg4/YHpW3
         Ncifr6DF1WchIf1O14OxXQoyEvElfITGrORZswH4=
Date:   Mon, 13 Dec 2021 13:44:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Message-ID: <YbdAE9r9GXZlnyfr@kroah.com>
References: <20211213092939.074326017@linuxfoundation.org>
 <20211213103536.GC17683@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213103536.GC17683@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 11:35:36AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.85 release.
> > There are 132 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I'm getting a lot of build failures -- missing gmp.h:
> 
>   UPD     include/generated/utsrelease.h
> 1317In file included from /builds/hVatwYBy/68/cip-project/cip-testing/linux-stable-rc-ci/gcc/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/8.1.0/plugin/include/gcc-plugin.h:28:0,
> 1318                 from scripts/gcc-plugins/gcc-common.h:7,
> 1319                 from scripts/gcc-plugins/arm_ssp_per_task_plugin.c:3:
> 1320/builds/hVatwYBy/68/cip-project/cip-testing/linux-stable-rc-ci/gcc/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/8.1.0/plugin/include/system.h:687:10: fatal error: gmp.h: No such file or directory
> 1321 #include <gmp.h>
> 1322          ^~~~~~~
> 1323compilation terminated.
> 1324scripts/gcc-plugins/Makefile:47: recipe for target 'scripts/gcc-plugins/arm_ssp_per_task_plugin.so' failed
> 1325
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y

What gcc plugins are you trying to build with?

thanks,

greg k-h
