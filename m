Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77C55A9EFD
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 20:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbiIASeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 14:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiIASeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 14:34:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E887EFCA;
        Thu,  1 Sep 2022 11:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA21AB82894;
        Thu,  1 Sep 2022 18:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B968FC433D6;
        Thu,  1 Sep 2022 18:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662057233;
        bh=qtHWF6S3i85fV/boOivAFmcEhYa2jatpJ2WrW9WWZ7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OGQxbvWH7tx4vhuwp4yp8BSQ3qLhHKKPZKll7SMhAlHKTUns7AYAeWtqb7tOa7i5Q
         NZgstt1SxKl7kVTTF40gPtVIOs+wbWEy/rrlqGw/cEZSixj3tYPRdBG+pOV3pXRTGr
         RADcuemUP1c2xB7o6zSFLtd2TpsZsKmyS9LGrX+k=
Date:   Thu, 1 Sep 2022 20:33:50 +0200
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
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
Message-ID: <YxD7DqDe0vWRIl3E@kroah.com>
References: <20220829105804.609007228@linuxfoundation.org>
 <CADVatmOLoaGgAW951JqEk3v88EA7mn3qur84Xd30QJWP21+eVg@mail.gmail.com>
 <YxB/ZPFEQG9zS+wa@kroah.com>
 <CADVatmPxfdEA3yi9KGHtvmQA2n-mA=ekBidqU+keGrBsL+rFeQ@mail.gmail.com>
 <YxCJzr0XCd+6/JW4@kroah.com>
 <CADVatmPMGmvabWb0S21P8Xycu5ZYe+imyR8tbG27qX28VuyUtg@mail.gmail.com>
 <YxCgFemX8nn0Bzm1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxCgFemX8nn0Bzm1@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 02:05:41PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Sep 01, 2022 at 11:56:20AM +0100, Sudip Mukherjee wrote:
> > On Thu, Sep 1, 2022 at 11:30 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Sep 01, 2022 at 11:22:53AM +0100, Sudip Mukherjee wrote:
> > > > On Thu, Sep 1, 2022 at 10:46 AM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Mon, Aug 29, 2022 at 09:11:28PM +0100, Sudip Mukherjee wrote:
> > > > > > Hi Greg,
> > > > > >
> > > > > > On Mon, Aug 29, 2022 at 12:00 PM Greg Kroah-Hartman
> > > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > > >
> > > > > > > This is the start of the stable review cycle for the 5.15.64 release.
> > > > > > > There are 136 patches in this series, all will be posted as a response
> > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > let me know.
> > > > > > >
> > > > > > > Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> > > > > > > Anything received after that time might be too late.
> > > > > >
> > > > > > My builds are still running, but just an initial report for gcc-12. (I
> > > > > > know v5.15.y still does not build completely with gcc-12).
> > > > > >
> > > > > > x86_64 and arm64 allmodconfig build fails with gcc-12, with the error:
> > > > > >
> > > >
> > > > <snip>
> > > >
> > > > > >
> > > > > > Introduced in v5.15.61 due to 2711bedab26c ("Bluetooth: L2CAP: Fix
> > > > > > l2cap_global_chan_by_psm regression").
> > > > > > But v5.19.y and mainline does not show the build failure as they also
> > > > > > have 41b7a347bf14 ("powerpc: Book3S 64-bit outline-only KASAN
> > > > > > support").
> > > > >
> > > > > Ick, ok, what to do here?  I can't really backport 41b7a347bf14 to 5.15
> > > > > easily as it's huge and a new feature.  Any other ideas?
> > > >
> > > > Yeah.
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=b840304fb46cdf7012722f456bce06f151b3e81b
> > > > will fix the it for mips and csky failure in mainline and v5.19.y. And
> > > > I just verified that it will fix for powerpc also in v5.15.y. So, we
> > > > just need to wait for now.
> > >
> > > Ah good, thanks for pointing that out!
> > 
> > uhh.. I can see you already added to the stable tree, but its not in
> > mainline yet.
> 
> It's on track to get to Linus and fixes a build problem, should be ok.

And it's now in Linus's tree so all is good :)
