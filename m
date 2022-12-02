Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138716406FF
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 13:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiLBMlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 07:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbiLBMlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 07:41:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D318D4AC0;
        Fri,  2 Dec 2022 04:41:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BACACB81F90;
        Fri,  2 Dec 2022 12:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D6EC433D6;
        Fri,  2 Dec 2022 12:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669984867;
        bh=8Mgmgc8JRHZIdHnXKTkMUL7Ca7WLlADDMZ58sKG0rhg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kKUnWgsHTeixo34aKNOEMfoJw79i4zzG0x3rbyh8wGR1ELI30Nf5pBRL094HxDVN1
         9Jg/0cfAaZLlomTK548FFLOPNAgXnWrYg9iFF+SSrkLQ/XpslTgNWOj9E2xUzMO0Lc
         7QeXhMPFszIpmSE30C8gIB6H4DfQgXo87Yippx8M=
Date:   Fri, 2 Dec 2022 13:41:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     mlevitsk@redhat.com, samuel.thibault@ens-lyon.org,
        pawell@cadence.com, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Message-ID: <Y4nyX9/clyX0P3f8@kroah.com>
References: <20221130180528.466039523@linuxfoundation.org>
 <Y4nmNb46aqbm7JuS@duo.ucw.cz>
 <Y4nx/HMggCOhdIMy@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4nx/HMggCOhdIMy@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 01:39:24PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Dec 02, 2022 at 12:49:09PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > [If I cc-ed you, you are author of one of patches below. Please take a
> > look.]
> > 
> > > Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> > > Anything received after that time might be too late.
> > 
> > I hope to make it :-). I
> > 
> > > Pawel Laszczak <pawell@cadence.com>
> > >     usb: cdnsp: Device side header file for CDNSP driver
> > > 
> > > Pawel Laszczak <pawell@cadence.com>
> > >     usb: cdns3: Add support for DRD CDNSP
> > 
> > These two together are 1500+ lines, and are marked as Stable-dep-of:
> > 9d5333c93134 ("usb: cdns3: host: fix endless superspeed hub port
> > reset") . But we don't have that one in 5.10 tree. Likely we should
> > not have these either.
> 
> I already dropped these yesterday.
> 
> > > Maxim Levitsky <mlevitsk@redhat.com>
> > >     KVM: x86: emulator: update the emulation mode after rsm
> > 
> > No. The patch does not do anything. Mainline commit this referenced
> > changed the return value, this changes just a comment. Wrong backport?
> 
> I will look at this.

Yeah, something went wrong with the backport, I'll drop this.  Sasha,
can you add this back to your queue?

thanks,

greg k-h
