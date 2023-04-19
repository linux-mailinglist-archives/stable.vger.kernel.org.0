Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB456E7D7D
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 16:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjDSOyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 10:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjDSOyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 10:54:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A478C10C;
        Wed, 19 Apr 2023 07:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 405DD639C8;
        Wed, 19 Apr 2023 14:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A41BC433D2;
        Wed, 19 Apr 2023 14:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681916053;
        bh=rdyLr7aFLUZLENJcBM/mnB7sHCE8bnoXYHFradjo19U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Ggi/1ECAd3fa8x0xsfGfJzrQ7MjKlWQjKgWwNAOu3KupyYvHZHUd1Y9oVaw7ODSp
         1obj0jbmpYGfo0SeI33q+Ewo7f2TCAGXxpSR21Pk9oIBDKNHI4kypercle7VrNKHn2
         PlfnSgIlEf0UgLfXXUtdhve41fTdk2VlK41YepvA=
Date:   Wed, 19 Apr 2023 16:54:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alyssa Ross <hi@alyssa.is>
Cc:     Conor.Dooley@microchip.com, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/138] 6.2.12-rc2 review
Message-ID: <2023041944-marvelous-barge-ec64@gregkh>
References: <20230419093655.693770727@linuxfoundation.org>
 <b6e0cc8b-eb4b-4906-9697-a1dab4741745@microchip.com>
 <2023041957-sector-purposely-859f@gregkh>
 <20230419135705.phaf4qmqhorwx3jd@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419135705.phaf4qmqhorwx3jd@x220>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 19, 2023 at 01:57:05PM +0000, Alyssa Ross wrote:
> On Wed, Apr 19, 2023 at 03:17:13PM +0200, Greg KH wrote:
> > On Wed, Apr 19, 2023 at 12:26:26PM +0000, Conor.Dooley@microchip.com wrote:
> > > On 19/04/2023 10:40, Greg Kroah-Hartman wrote:
> > > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > > >
> > > > This is the start of the stable review cycle for the 6.2.12 release.
> > > > There are 138 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Fri, 21 Apr 2023 09:36:26 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >          https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.12-rc2.gz
> > > > or in the git tree and branch at:
> > > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > >
> > > > Alyssa Ross <hi@alyssa.is>
> > > >      purgatory: fix disabling debug info
> > > >
> > > > Heiko Stuebner <heiko.stuebner@vrull.eu>
> > > >      RISC-V: add infrastructure to allow different str* implementations
> > >
> > > Lore is ~dead for me right now, but there should be a custom backport of
> > > Alyssa's commit, submitted by her, here:
> > > https://lore.kernel.org/all/20230417134044.1821014-1-hi@alyssa.is/
> > >
> > > Perhaps the reason is just the quantity of email, but that was
> > > submitted against the "fail" email (and within a few hours), so why
> > > was another commit pulled back instead of using what she provided?
> >
> > Ok, now both dropped, this got confusing fast.
> 
> So what's my next step to getting my patch backported?
> 
> Do I have to wait for these kernels to be released, and then submit my
> backport again and hope it gets selected the second time round?

Yes please, that would be the best, sorry for the trouble, patches were
in flight from multiple people and we got confused.

greg k-hj
