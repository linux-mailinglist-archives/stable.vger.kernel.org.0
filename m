Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430E545560E
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 08:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243946AbhKRHwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 02:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244031AbhKRHwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 02:52:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D30D7610E6;
        Thu, 18 Nov 2021 07:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637221774;
        bh=0rcamr85+CEtqR+M2g912J0NJm2tNp4sy6lQ01EjD34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Pbxx0tslnYHcArAtpJz7CRA8hNHP6fCZpvEtH0FcDUfwsysAXXVPVM1SKuC1Cg+u
         HdrtDJ3LjwzwG9SZ6M1swJnJirJxUguBdbUgzjf99MPpmXm5gKVvdFfCfgLKplK7Kr
         Y1QzHUV5DSiGY/68bRAtaquiz3ppw3kyBjOHgh+U=
Date:   Thu, 18 Nov 2021 08:49:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.10 000/577] 5.10.80-rc3 review
Message-ID: <YZYFjIuFEhkyXpID@kroah.com>
References: <20211117101457.890809587@linuxfoundation.org>
 <CADYN=9LNevXvdmgkCC06FFxQEq3JHHb4k=0DfiGLpW3viBzojA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9LNevXvdmgkCC06FFxQEq3JHHb4k=0DfiGLpW3viBzojA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 09:32:22PM +0100, Anders Roxell wrote:
> On Wed, 17 Nov 2021 at 11:16, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> >     soc/tegra: Fix an error handling path in tegra_powergate_power_up()
> 
> With this patch applied the following waring shows up:
> 
> make --silent --keep-going --jobs=32
> O=/home/anders/.cache/tuxmake/builds/current ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu-
>                                 drivers/soc/tegra/pmc.c: In function
> 'tegra_powergate_power_up':
> drivers/soc/tegra/pmc.c:726:1: warning: label 'powergate_off' defined
> but not used [-Wunused-label]   726 | powergate_off:
>         | ^~~~~~~~~~~~~
> 
> If I cherry pick 19221e308302 ("soc/tegra: pmc: Fix imbalanced clock
> disabling in error code path")
> the wraning goes away.

Now queued up, thanks.

greg k-h
