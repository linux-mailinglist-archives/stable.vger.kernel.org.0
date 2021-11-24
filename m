Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B3C45C9B5
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhKXQTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241890AbhKXQTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 11:19:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DED7260C4A;
        Wed, 24 Nov 2021 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637770596;
        bh=E3s6JXxJb3KXTWDUS6t6MnzjGsPdRHVubeMoMxNeYDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JqNMA1/X7M9ZF1sizJbQ/CDVaYUfgAKPaUIrLm8B6PB4Ww6M1KIyfwBy2W0Smogwv
         VwaswPBADdKIFxc18t8ZPBju6DwVAPwJUi64oABrAdwgpieBBlQZlYltbUxhLa5Q9s
         7x0NuX+moc0w69S4XYg2oC0IoEuC9qpKsTqezmzg=
Date:   Wed, 24 Nov 2021 17:16:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc1 review
Message-ID: <YZ5lYvfHy+yM/BS9@kroah.com>
References: <20211124115654.849735859@linuxfoundation.org>
 <CA+G9fYt_DK3Ft1J08Wsw=4YfV0iayKqNtkQt_=8vgr+A6CrC6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt_DK3Ft1J08Wsw=4YfV0iayKqNtkQt_=8vgr+A6CrC6g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 09:10:35PM +0530, Naresh Kamboju wrote:
> On Wed, 24 Nov 2021 at 18:19, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.162 release.
> > There are 100 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.162-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regression found on arm64 gcc-11 builds
> Following build warnings / errors reported on stable-rc 5.4.
> 
> 
> builds/linux/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi:412.21-414.5:
> ERROR (duplicate_label): /soc/codec: Duplicate label 'lpass_codec' on
> /soc/codec and /soc@0/codec
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[3]: *** [scripts/Makefile.lib:285:
> arch/arm64/boot/dts/qcom/apq8016-sbc.dtb] Error 2
> 
> 
> The bisect tool pointed to,
> 
> b979ffa8bbd6e4c33df7f3e7ac3d63f2234c023c is the first bad commit
> commit b979ffa8bbd6e4c33df7f3e7ac3d63f2234c023c
> Author: Stephan Gerhold <stephan@gerhold.net>
> Date:   Tue Sep 21 17:21:18 2021 +0200
> 
>     arm64: dts: qcom: msm8916: Add unit name for /soc node
> 
> 
> 
> As it was reported here,
> https://lore.kernel.org/stable/CA+G9fYv5fnntoa1vzXp52=TSxCK=U8fV8J-AbE+WmKH1w4ebwg@mail.gmail.com/
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Now dropped, thanks.

greg k-h
