Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF61365CC9C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 06:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjADF3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 00:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjADF33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 00:29:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7B2DC;
        Tue,  3 Jan 2023 21:29:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5640615AA;
        Wed,  4 Jan 2023 05:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84F1C433EF;
        Wed,  4 Jan 2023 05:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672810167;
        bh=h1rPRJhSDLO0mtWeLAlKQj4L0G7kMVaMsBVCk/atgwU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fFFsiJ9NMVa5vjvSVW4AI4H9WIxItChO3F06PPHGbZXBgN6UX9h+05ItOctQNW80r
         ai0cG4X3iUEW8T2mSP6XYPygqsVyESDlzN65IySgEc4Sj66ZoNCc7Wr+Ogysma3aDz
         5/VmCkzSV87mIlbvOc7bJnftptCz0o+pBcVxyBQ4=
Date:   Wed, 4 Jan 2023 06:29:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
Message-ID: <Y7UOtInxdmaIP9nH@kroah.com>
References: <20230103081308.548338576@linuxfoundation.org>
 <Y7RUxwrokcIKZNZ4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7RUxwrokcIKZNZ4@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03, 2023 at 04:16:07PM +0000, Joel Fernandes wrote:
> On Tue, Jan 03, 2023 at 09:13:30AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.162 release.
> > There are 63 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.162-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> 
> Testing fails. Could you please pick these 2 up?
> https://lore.kernel.org/r/20221230153215.1333921-1-joel@joelfernandes.org
> https://lore.kernel.org/all/20221230153215.1333921-2-joel@joelfernandes.org/

That is not a regression from 5.10.161, right?  This release is only for
the io_uring stuff to make sure that backport was done correctly.

The current "to apply" queue for the stable trees is very large right
now due to everyone waiting to get tiny things into -rc1 instead of
before then, so the above two are still not yet queued up, sorry.

thanks,

greg k-h
