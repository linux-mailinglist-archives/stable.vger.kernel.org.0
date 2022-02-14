Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2D94B4EC8
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351998AbiBNLiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 06:38:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352161AbiBNLhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 06:37:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1266E4EC;
        Mon, 14 Feb 2022 03:27:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 57211CE130E;
        Mon, 14 Feb 2022 11:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D591CC340E9;
        Mon, 14 Feb 2022 11:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644838056;
        bh=qLuppaN8oBFmEHh9MTiE+azA4DDoYSKO9izAxxdx0po=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aLgDleEPSPv4Q5yHU+iyuNmxwTPNFzY5R5R/CnxH/XrT0ZKA5BTqSU3xrPgtbtSb1
         KVfj0xgrnaoIugCzX30a8AgcZ/X3jZxqOFNjdyWFD1NjeWTqo9xMx3+q+XOMjzdMo8
         ANKgYnD5zgHOA7xa4uJQyRN/+I20of5z0Jw0ssvA=
Date:   Mon, 14 Feb 2022 12:27:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
Message-ID: <Ygo8pUuBuNYmP9ds@kroah.com>
References: <20220214092510.221474733@linuxfoundation.org>
 <CA+G9fYvfx2jRPnU6zVK8v9vNbwXc4wV0KX0JfGWeNsAbL72y-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvfx2jRPnU6zVK8v9vNbwXc4wV0KX0JfGWeNsAbL72y-g@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 04:29:43PM +0530, Naresh Kamboju wrote:
> On Mon, 14 Feb 2022 at 15:23, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.16.10 release.
> > There are 203 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> On Linux mainline master branch with arm64 clang-nigtly build failed
> due to following errors and warnings.
> Now it is also noticed on stable-rc 5.15 and 5.16.

Sounds like a compiler error.  Do the clang developers know about this?

thanks,

greg k-h
