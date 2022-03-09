Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBE04D2E84
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 12:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiCIL7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 06:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbiCIL7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 06:59:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DB8B2C;
        Wed,  9 Mar 2022 03:58:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B6F4618FA;
        Wed,  9 Mar 2022 11:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D0FC340E8;
        Wed,  9 Mar 2022 11:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646827087;
        bh=EPDIyPTfIzkpzB1JrpoCB7b8Z3SZpnETDozJlxtnVZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E4Wh3DvU+/FpBL9Q0Rth68R7XgzLAb5rariVlDHoUxBmhOYKhY5jb+55JN4kvF4H1
         p8VM1pEuK5V2HJ5+Xv/3GP8kH0ab3Gm/CosYud24ZXEF+fVAC/lFEh95IWJS5VzhVq
         F3ZDUQaPQZYezpPvw7X4OBRKfsibRhpEnqYCZVrY=
Date:   Wed, 9 Mar 2022 12:58:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
Message-ID: <YiiWS/0UcOzTOPxt@kroah.com>
References: <20220307162207.188028559@linuxfoundation.org>
 <Yid4BNbLm3mStBi2@debian>
 <CADVatmPdzXRU2aTeh-8dfZVmW6YPJwntSDCO8gcGDUJn-qzzAg@mail.gmail.com>
 <CA+G9fYv74gGWQLkEZ4idGYri+F9BFV1+9=bz5L0+aophSzDdVA@mail.gmail.com>
 <YifFMPFMp9gPnjPc@kroah.com>
 <CADVatmMs_+YN3YAajL95fy98iEgoeb-7qXA_ZJ7K3QsdHGG=oA@mail.gmail.com>
 <8f97b76e-fe64-ad9e-fa46-9874df61c35d@roeck-us.net>
 <CADVatmNXDx4-vrsyZBeRs8HHYfS3j8OPpS4CGnhQc=uyijgwvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmNXDx4-vrsyZBeRs8HHYfS3j8OPpS4CGnhQc=uyijgwvQ@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 09:53:25AM +0000, Sudip Mukherjee wrote:
> On Wed, Mar 9, 2022 at 12:53 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On 3/8/22 14:27, Sudip Mukherjee wrote:
> > > On Tue, Mar 8, 2022 at 9:05 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > >>
> > >> On Tue, Mar 08, 2022 at 11:08:10PM +0530, Naresh Kamboju wrote:
> > >>> Hi Greg,
> > >>>
> > >>> On Tue, 8 Mar 2022 at 21:40, Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > >>>>
> > >>>> On Tue, Mar 8, 2022 at 3:36 PM Sudip Mukherjee
> > >>>> <sudipm.mukherjee@gmail.com> wrote:
> > >>>>>
> > >>>>> Hi Greg,
> > >>>>>
> > >>>>> On Mon, Mar 07, 2022 at 05:28:50PM +0100, Greg Kroah-Hartman wrote:
> > >>>>>> This is the start of the stable review cycle for the 5.15.27 release.
> > >>>>>> There are 256 patches in this series, all will be posted as a response
> > >>>>>> to this one.  If anyone has any issues with these being applied, please
> > >>>>>> let me know.
> > >>>>>>
> > >>>>
> > >>>> <snip>
> > >>>>
> > >>>>>
> > >>>>> Mips failures,
> > >>>>>
> > >>>>> allmodconfig, gpr_defconfig and mtx1_defconfig fails with:
> > >>>
> > >
> > > <snip>
> > >
> > >>
> > >> Ah, I'll queue up the revert for that in the morning, thanks for finding
> > >> it.  Odd it doesn't trigger the same issue in 5.16.y.
> > >
> > > ohh.. thats odd. I don't build v5.16.y, so never thought of it.
> > > Just checked a little now, and I was expecting it to be fixed by:
> > > e5b40668e930 ("slip: fix macro redefine warning")
> > > but it still has the build error. I will check tomorrow morning what
> > > is missing in v5.15.y
> > > Please delay the revert till tomorrow afternoon.
> > >
> >
> > In case you did not get my other e-mail: You also need commit
> > b81e0c2372e ("block: drop unused includes in <linux/genhd.h>").
> 
> Thanks Guenter.
> And, I have now verified that both gpr_defconfig and mtx1_defconfig
> passes after cherry-picking these two commits.

Great, I've queued both these up now.

greg k-h
