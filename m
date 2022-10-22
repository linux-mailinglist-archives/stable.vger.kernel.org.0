Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25781608CCC
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiJVLj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiJVLjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:39:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8382D11822;
        Sat, 22 Oct 2022 04:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ADC460C3E;
        Sat, 22 Oct 2022 11:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C14C433C1;
        Sat, 22 Oct 2022 11:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666438153;
        bh=hNeEwpi3kCIx0/LZBNebVPe/kvlDOWJtLF6rcIlmaek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GCamvHbZvjnjS+UEElXPAqrSV0i8VVPddjNl/XQSq4dzkCWIohKLQc9bWJFzVAySc
         Wj1/tYLIyg6UY3CKmFn+h1JtpHZgfFmGSTR0K+JHVdyqegJXMPXmXZu9O1mUVC7Adw
         IFtCu8QlHacHW3+qKjmBr/lX2EPHO7IkjpPgwaDs=
Date:   Sat, 22 Oct 2022 13:29:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.19 000/717] 5.19.17-rc1 review
Message-ID: <Y1PUBoPJx2m2BMRR@kroah.com>
References: <20221022072415.034382448@linuxfoundation.org>
 <Y1Ov3KuyKmb9Nizm@debian.me>
 <Y1PCyVHKEUst4mRL@kroah.com>
 <20221022111526.GA20649@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221022111526.GA20649@duo.ucw.cz>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 22, 2022 at 01:15:26PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > This is the start of the stable review cycle for the 5.19.17 release.
> > > > There are 717 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Note, this will be the LAST 5.19.y kernel to be released.  Please move
> > > > to the 6.0.y kernel branch at this point in time, as after this is
> > > > released, this branch will be end-of-life.
> > > > 
> > > 
> > > Hi Greg, thanks for the patch series, which is out three days after
> > > the -rc1 have been pused. As usual, the template message follows.
> > 
> > What exactly do you mean by "3 days after"?
> > 
> > Are you watching the linux-stable-rc branches?  Those are there only for
> > CI systems and are not a "real" -rc release at all until we do this
> > email announcement.
> > 
> > The -rc1 release here does not look at all like what was in the
> > linux-stable-rc branch 3 days ago if you look closely.  There are a lot
> > fewer patches now than before, and other changes.
> > 
> > So again, unless you are running a CI system, don't look at the
> > linux-stable-rc branches.
> 
> What do you suggest for people trying to review -stable? Two days are
> not enough to review 500 patches...

There's 717 patches here, more than 500 :)

Almost all of these have been in the stable queue for a full week now,
if not longer.  Almost all of these were already in the last 6.0.y
review cycle and release also, so you all should have already seen these
before, and maintainers have had a chance to weigh in on them.

Kernel development is constantly going faster this year than last year,
that's something that has always been the case, so having more patches
in stable is also a constant.

Also, there's no requirement that you have to review them all, right?
Review the ones that you care about in your subsystems and all is good.

thanks,

greg k-h
