Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6462A198E32
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 10:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgCaIVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 04:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbgCaIVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 04:21:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3490D20787;
        Tue, 31 Mar 2020 08:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585642898;
        bh=af0F99FoItRJb/Y5nbD3JsPo6ZAAU9CVv/n2Q5USSKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n5amCFsSiTobzTxbVf3y+I8vHH6KL/aBPc+5q3XAOaa1Slf54zpHD3FmoTLT3/JJt
         +CRLyXdndB2u5VApdp/T6fzNmu4AAd29GiIyM3QwZ5EkmbJ3JhYHqRA+sXREf36Rfi
         X1/raJ/eh+58wybUnvQr6vZIcH6C2DF+RXfpiN/I=
Date:   Tue, 31 Mar 2020 10:20:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, megous@megous.com, maxime@cerno.tech
Subject: Re: stable-rc-4.19: arm: dts: sun8i-a83t-tbs-a711: make dtbs failed
Message-ID: <20200331082020.GA1076041@kroah.com>
References: <CA+G9fYsZRZoxTGieMCew7aC0pGCMjqJS0XbFzKgjw317gecEng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsZRZoxTGieMCew7aC0pGCMjqJS0XbFzKgjw317gecEng@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 10:47:34PM +0530, Naresh Kamboju wrote:
>  # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> arm-linux-gnueabihf-gcc" O=build dtbs
>  #
>  Error: ../arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts:419.38-39 syntax error
>  FATAL ERROR: Unable to parse input tree
>  make[2]: *** [scripts/Makefile.lib:294:
> arch/arm/boot/dts/sun8i-a83t-tbs-a711.dtb] Error 1
> 
> ref:
> https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/491105939

Thanks, I've dropped the offending patch now.

greg k-h
