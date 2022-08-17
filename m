Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0328596DC1
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 13:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbiHQLjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 07:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235733AbiHQLj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 07:39:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AFE83BF1;
        Wed, 17 Aug 2022 04:39:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80F91B81BA5;
        Wed, 17 Aug 2022 11:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1D6C433C1;
        Wed, 17 Aug 2022 11:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660736351;
        bh=xR5OHx3wWrAWhFzk+jDMobJ+vVLZPA43p9GHmgWatfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qDFmH2owlZDKS3ym6Xb4wYyi2v10RPNEBbQ3SCtjFJNuy1QP0ny+LnZUN/P726Z49
         3uWGj9din1S+CtaTJSvU4E0X00fQPfXPKQsAkzJUdTNWXSizbShumnuX40swZY0f3C
         MKOjxu1RvlDr052by8NV6+SwgMcxPR9oTCESFhC4=
Date:   Wed, 17 Aug 2022 13:39:08 +0200
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
Subject: Re: [PATCH 5.18 0000/1094] 5.18.18-rc2 review
Message-ID: <YvzTXOKsbSfDpLjZ@kroah.com>
References: <20220816124604.978842485@linuxfoundation.org>
 <CADVatmPOCPfHQHEuwVmOb5oeN2HfWWMztVok3qvoq7Ndndb14A@mail.gmail.com>
 <YvutIhMRZW/nKOPi@kroah.com>
 <CADVatmM4ZH0PvPiFrdwqXg5y-w4Z3=7YqLz9SW54ygScoODPmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmM4ZH0PvPiFrdwqXg5y-w4Z3=7YqLz9SW54ygScoODPmQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 05:41:23PM +0100, Sudip Mukherjee wrote:
> On Tue, Aug 16, 2022 at 3:43 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Aug 16, 2022 at 03:34:56PM +0100, Sudip Mukherjee wrote:
> > > Hi Greg,
> > >
> > > On Tue, Aug 16, 2022 at 1:59 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.18.18 release.
> > > > There are 1094 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 18 Aug 2022 12:43:14 +0000.
> > > > Anything received after that time might be too late.
> > >
> > > The hung task problem I reported for v5.18.18-rc1 is not seen with rc2.
> >
> > Nice!
> >
> > > The drm warning is still there and a bisect pointed it to:
> > > 4b8701565b59 ("drm/vc4: hdmi: Move HDMI reset to
> > > pm_resume")4b8701565b59 ("drm/vc4: hdmi: Move HDMI reset to
> > > pm_resume")
> >
> > What drm warning?
> 
> Reported for mainline now, at
> https://lore.kernel.org/lkml/YvvHK2zb1lbm2baU@debian/

Thanks, I'll wait for that to land in Linus's tree.

> > > I have not noticed earlier, the warning is there with mainline also. I
> > > will verify tonight and send another mail for mainline.
> >
> > Ah, ok, being bug compatible is good :)
> >
> > > Also, mips and csky allmodconfig build fails with gcc-12 due to
> > > 85d03e83bbfc ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
> > > regression").
> > > Mainline also has the same build failure reported at
> > > https://lore.kernel.org/lkml/YvY4xdZEWAPosFdJ@debian/
> >
> > Looks like they have a fix somewhere for that, any hints on where to
> > find it?
> 
> There is a fix in the bluetooth tree master branch but it has not
> reached mainline yet. I will check which commit has fixed the failure
> and ping the bluetooth maintainers.

Same here, will just wait for that to land.

greg k-h
