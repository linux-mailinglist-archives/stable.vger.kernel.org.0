Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83ED44B54EE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 16:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiBNPhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 10:37:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiBNPhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 10:37:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF50DF19;
        Mon, 14 Feb 2022 07:37:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9CBEB81128;
        Mon, 14 Feb 2022 15:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42DBC340EE;
        Mon, 14 Feb 2022 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644853053;
        bh=TGfDEvbs7Wyxord98HhplZKBquF6jeKuRkvjNaSxV8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uBnGROUT6OZUqoDwiwDiuVFCFycWKqRclb52GfvVRuU6zlyC4uSBaacRqAXINj1EW
         pGHKMX1pd3HIxtJDXK3E3gdndQenpFRLyioVvu9APpHxsYk/RtUJVUfVuURkZkVrZW
         pSJghEKHTJ7crpiuUOmUSrWykuSCnNTda9kpc//Ttpl6E4gpv8Ce+F95Saw/yGAkv1
         A2aWNn3o0klUtWfP2Y4CK34fCR8gDwlbaDmvo1DhGZfE1/8J0ojC9vin4GXpIKTzr5
         /TevaZG2vKw8mgfpv6wK12qiS5vsOeH4w1Z4iQ+pDkrXmQbY2vfKMA0KUfQcb+tudg
         WjNhb74fkhdZg==
Date:   Mon, 14 Feb 2022 08:37:27 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, llvm@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
Message-ID: <Ygp3NyV5AptXcmzV@dev-arch.archlinux-ax161>
References: <20220214092510.221474733@linuxfoundation.org>
 <CA+G9fYvfx2jRPnU6zVK8v9vNbwXc4wV0KX0JfGWeNsAbL72y-g@mail.gmail.com>
 <Ygo8pUuBuNYmP9ds@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ygo8pUuBuNYmP9ds@kroah.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 12:27:33PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Feb 14, 2022 at 04:29:43PM +0530, Naresh Kamboju wrote:
> > On Mon, 14 Feb 2022 at 15:23, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.16.10 release.
> > > There are 203 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > On Linux mainline master branch with arm64 clang-nigtly build failed
> > due to following errors and warnings.
> > Now it is also noticed on stable-rc 5.15 and 5.16.
> 
> Sounds like a compiler error.  Do the clang developers know about this?

Yes, please see my response to Naresh in his other report for more
information:

https://lore.kernel.org/r/Ygp2wVo8JfWh5iOk@dev-arch.archlinux-ax161

Cheers,
Nathan
