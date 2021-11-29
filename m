Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC93461C8D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 18:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348780AbhK2RSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 12:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243001AbhK2RQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 12:16:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC997C0E655B
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 06:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD6F161550
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 14:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3E5C004E1;
        Mon, 29 Nov 2021 14:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638196422;
        bh=3r5benbv7VeNib/5hl1x20xZ/q72mK/g7+JphsIoY6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rGfgAuuGuRnCt0rgBNzGTDI6y405ja9wqmrA8N13RVgZS0mHrmq/lcCyaopvpwyVy
         g/rLuu6d9I3DQvxY+tfKyy97h9Sg4/7u6cSVXMvy6PZtRMz2vsWIBLAE/jPP11PhV4
         eNknshe/BrB8hWRPIS9bD1+T5U/4tvfegqyqBJyE=
Date:   Mon, 29 Nov 2021 15:33:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Antonio Terceiro <antonio.terceiro@linaro.org>,
        Vishal Bhoj <vishal.bhoj@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: Doesn't build 32 bit vDSO for arm64
Message-ID: <YaTkwsWycenqZHN9@kroah.com>
References: <CA+G9fYuzzknDMdu3q8ARyVHqd-cLYD_tsMLMH-ig-k-WVeTPAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuzzknDMdu3q8ARyVHqd-cLYD_tsMLMH-ig-k-WVeTPAg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:42:07PM +0530, Naresh Kamboju wrote:
> Hi Greg and Antonio,
> 
> The stable-rc 5.4 build is failing.
> ( 5.10 and 5.15 builds pass )
> because new build getting these two extra configs.
> 
> CONFIG_GENERIC_COMPAT_VDSO=y
> CONFIG_COMPAT_VDSO=y
> 
> These two configs are getting added by extra build variable
> 
> CROSS_COMPILE_COMPAT=arm-linux-gnueabihf-
> 
> This extra variable is coming from new tuxmake tool.
> 
> Doesn't build 32 bit vDSO for arm64
> https://gitlab.com/Linaro/tuxmake/-/issues/160
> 
> ref:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Has this ever worked on 5.4 for this configuration?

Or is this a new problem with the current 5.4.y queue?

thanks,

greg k-
