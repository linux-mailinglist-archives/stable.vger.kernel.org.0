Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4507A64BB95
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 19:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbiLMSHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 13:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiLMSHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 13:07:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E811DEBD;
        Tue, 13 Dec 2022 10:07:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5697661638;
        Tue, 13 Dec 2022 18:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F9FC433D2;
        Tue, 13 Dec 2022 18:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670954869;
        bh=7nIhFvx45XTCphvvUSpM+7j2P/I9wE89cs+unNBEsiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZM+9+W6Zef2IIByoKIihgPBXIFq+HsSuSK4fpOsWcYIX+37gdy31leW68o/9+NWam
         ffMBdhijtoED2p3BtqRq+2uDkFQd1HKTOxaJdF51FfWSfjFql2sy210Nm4ROGXjc9q
         KLik/0LY9X6f1FRMawE1rsvFhs1B63F1dqnENG1I=
Date:   Tue, 13 Dec 2022 19:07:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <Y5i/c2tNslzs86Gj@kroah.com>
References: <20221212130924.863767275@linuxfoundation.org>
 <Y5hqsggURI1Me1ik@debian>
 <CADVatmPM4Q5A9jVO6-ixhqa2HWh4rWPKNpfwy75u69My=3Xhjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmPM4Q5A9jVO6-ixhqa2HWh4rWPKNpfwy75u69My=3Xhjw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 03:31:35PM +0000, Sudip Mukherjee wrote:
> On Tue, 13 Dec 2022 at 12:06, Sudip Mukherjee (Codethink)
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Mon, Dec 12, 2022 at 02:09:03PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.159 release.
> > > There are 106 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> > > Anything received after that time might be too late.
> >
> > Build test (gcc version 11.3.1 20221127):
> > mips: 63 configs -> no failure
> > arm: 104 configs -> no failure
> > arm64: 3 configs -> no failure
> > x86_64: 4 configs -> no failure
> > alpha allmodconfig -> no failure
> > powerpc allmodconfig -> no failure
> > riscv allmodconfig -> no failure
> > s390 allmodconfig -> no failure
> > xtensa allmodconfig -> no failure
> >
> > Boot test:
> > x86_64: Booted on my test laptop. No regression.
> > x86_64: Booted on qemu. No regression. [1]
> >
> > arm64: Booted on rpi4b (4GB model).
> > Regression noticed:
> > Failed to start Network Manager
> >
> > Will try a bisect and find which commit caused it.
> 
> Bisect pointed to 60aefe77fb48 ("net: broadcom: Add
> PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835")

Should be fixed in -rc2.

thanks,

greg k-h
