Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110645EBD15
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiI0IT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiI0ITx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:19:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB2583238;
        Tue, 27 Sep 2022 01:19:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78EDA6170A;
        Tue, 27 Sep 2022 08:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF1CC4347C;
        Tue, 27 Sep 2022 08:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664266787;
        bh=lovric0Rnn0QU/YYYsAyUx0mEMy8QhcJ6J2E9j/iNVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lh+mMtX8p7JV5UMx0n3fyFjuImriccxpXp6SXno4Qw0yMNBTzApz15D/jBxrE8iZz
         OgAOR5oQY2I5PireFu2aCb1SQrq0BS7xxILUq/p0iDMYo5jcj7WGSOiaW+nKwv2s5+
         my02LNYmnqoORtYtyVti9bFj4n5/rsaaKEGnk2Bw=
Date:   Tue, 27 Sep 2022 10:19:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
Message-ID: <YzKyIfQUq9eRbomG@kroah.com>
References: <20220926100806.522017616@linuxfoundation.org>
 <CA+G9fYtxogp--B0Em6VCL0C3wwVFXa6xW-Rq2kQk3br+FPGLgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtxogp--B0Em6VCL0C3wwVFXa6xW-Rq2kQk3br+FPGLgg@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 01:25:52PM +0530, Naresh Kamboju wrote:
> On Mon, 26 Sept 2022 at 16:13, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.19.12 release.
> > There are 207 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro's test farm.
> No regressions on arm, x86_64, and i386.
> Following deadlock warning noticed on arm64 with kselftests Kconfigs.

Is this new?  If so, what commit causes it?

thanks,

greg k-h
