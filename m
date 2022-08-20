Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F88459B275
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiHUHBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiHUHAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DED2A97D;
        Sun, 21 Aug 2022 00:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE0A1B80BAB;
        Sun, 21 Aug 2022 07:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EADCC433D6;
        Sun, 21 Aug 2022 07:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065217;
        bh=U3R0PXOVeBNi/aGM4YLPCESs8wspJ1yGJqt1ZsKx6+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x7Tf+AMVCgIQZwayiOfU/Y1dszhZX8/KbmuJcz/pS1ymQMDBPzGnQSi3kEHmunUhb
         9crcz/ibXy39LqfgyrmoBMQ47F9XCVOGed0JyVtgzzLxH6mS2yrRHi+q9ClqBKgjcH
         nz7755oseR7rTVc5iHnf51Hk3OcP10cEOgAQTzDY=
Date:   Sat, 20 Aug 2022 20:16:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0/6] 5.18.19-rc1 review
Message-ID: <YwEk5xZ/wXWJMMUq@kroah.com>
References: <20220819153710.430046927@linuxfoundation.org>
 <YwCxc5gwpmGRBUL1@debian>
 <CADVatmM_xDmAORG8J0KgrCOwmEyVKd7kc8VGQRHPaLZzifivhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmM_xDmAORG8J0KgrCOwmEyVKd7kc8VGQRHPaLZzifivhg@mail.gmail.com>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 20, 2022 at 11:32:36AM +0100, Sudip Mukherjee wrote:
> On Sat, Aug 20, 2022 at 11:03 AM Sudip Mukherjee (Codethink)
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Fri, Aug 19, 2022 at 05:40:12PM +0200, Greg Kroah-Hartman wrote:
> > > -------------------
> > > NOTE, this is the LAST 5.18.y stable release.  This tree will be
> > > end-of-life after this one.  Please move to 5.19.y at this point in time
> > > or let us know why that is not possible.
> > > -------------------
> > >
> > > This is the start of the stable review cycle for the 5.18.19 release.
> > > There are 6 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> > > Anything received after that time might be too late.
> >
> 
> <snip>
> 
> >
> > powerpc failure is not seen in mainline. Same error as csky and mips.
> >
> > In function 'memcmp',
> >     inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:302:9,
> >     inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2002:15:
> > ./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
> >    44 | #define __underlying_memcmp     __builtin_memcmp
> >       |                                 ^
> > ./include/linux/fortify-string.h:404:16: note: in expansion of macro '__underlying_memcmp'
> >   404 |         return __underlying_memcmp(p, q, size);
> >       |                ^~~~~~~~~~~~~~~~~~~
> > In function 'memcmp',
> >     inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:302:9,
> >     inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2003:15:
> > ./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
> >    44 | #define __underlying_memcmp     __builtin_memcmp
> >       |                                 ^
> > ./include/linux/fortify-string.h:404:16: note: in expansion of macro '__underlying_memcmp'
> >   404 |         return __underlying_memcmp(p, q, size);
> >       |                ^~~~~~~~~~~~~~~~~~~
> >
> > I am bisecting now to find out what caused it.
> 
> Introduced in v5.18.18 due to 11e008e59970 ("Bluetooth: L2CAP: Fix
> l2cap_global_chan_by_psm regression").
> But v5.19.y and mainline does not show the build failure as they also
> have 41b7a347bf14 ("powerpc: Book3S 64-bit outline-only KASAN
> support").

Ick, that's a mess.  This is going to be the last 5.18 tree, so I'm just
going to leave this alone...

thanks,

greg k-h
