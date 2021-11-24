Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39B345B904
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 12:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240937AbhKXL0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 06:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240520AbhKXL0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 06:26:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D847F60E94;
        Wed, 24 Nov 2021 11:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637752976;
        bh=fj8kX52IzBNeM2fXPv7s/W0SZrANn5QTg171W6szxkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EIwcAMOe5ViwSV6gjc4KXqnyI8DYcL82msqtf80XFy5h8XpzihCwpv2XuChegV8wQ
         671xjcD25JXLMhxy9NtkfQ6384mVerYUZUjGhDBp3CxojBL//uVCDrDBzigK2Jw1iP
         X89bAHXKVDommmK0zCowr6pw4C4T8AxHDGiRTdZU=
Date:   Wed, 24 Nov 2021 12:22:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Stephen Boyd <swboyd@chromium.org>,
        lkft-triage@lists.linaro.org
Subject: Re: qcom :apq8016-sbc.dtsi:412.21-414.5: ERROR (duplicate_label):
 /soc/codec: Duplicate label 'lpass_codec' on /soc/codec and /soc@0/codec
Message-ID: <YZ4gjaTqE++yDAB/@kroah.com>
References: <CA+G9fYv5fnntoa1vzXp52=TSxCK=U8fV8J-AbE+WmKH1w4ebwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv5fnntoa1vzXp52=TSxCK=U8fV8J-AbE+WmKH1w4ebwg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 03:30:09PM +0530, Naresh Kamboju wrote:
> Regression found on arm64 gcc-11 builds
> Following build warnings / errors reported on stable-rc 5.4.
> 
> metadata:
>     git_describe: v5.4.161-99-g60345e6d23ca
>     git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>     git_short_log: 60345e6d23ca (\"Linux 5.4.162-rc1\")
>     target_arch: arm64
>     toolchain: gcc-11
> 
> build error :
> --------------
> builds/linux/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi:412.21-414.5:
> ERROR (duplicate_label): /soc/codec: Duplicate label 'lpass_codec' on
> /soc/codec and /soc@0/codec
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[3]: *** [scripts/Makefile.lib:285:
> arch/arm64/boot/dts/qcom/apq8016-sbc.dtb] Error 2
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> build link:
> -----------
> https://builds.tuxbuild.com//21MKqVm5LdLI4FQGooFsnEUB3jO/build.log
> 
> build config:
> -------------
> https://builds.tuxbuild.com//21MKqVm5LdLI4FQGooFsnEUB3jO/config
> 
> # To install tuxmake on your system globally
> # sudo pip3 install -U tuxmake
> tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
> --kconfig defconfig \
>       --kconfig-add
> https://builds.tuxbuild.com//21MKqVm5LdLI4FQGooFsnEUB3jO/config

I can not figure out what commit caused this problem.  Any pointers
would be appreciated...

thanks,

greg k-h
