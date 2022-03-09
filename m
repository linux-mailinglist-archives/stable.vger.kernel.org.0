Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9426C4D434A
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 10:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240153AbiCJJTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 04:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbiCJJTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 04:19:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1E9DD46E;
        Thu, 10 Mar 2022 01:18:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 556D9B8251D;
        Thu, 10 Mar 2022 09:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803C8C340E8;
        Thu, 10 Mar 2022 09:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646903926;
        bh=o/RF3R6Jbu+ZjOfXjIJckekX7JDopQTo0G+jtOlkgSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ArZBgPrqM1SfOapP77287z5PP9Ywe2O3omkoKXTNZ1u1uC6LaIsnNmc6VgNRKRh08
         8iZZVBEmzUzhk+2a9xpt4cjET2O2ZCd1UmSK/E29fv7SyD+XyIolO6dy0Oh8EJa4Ty
         EitO38h+p/p1wH7UYaSykmu+2YzDgFX546DBWxzI=
Date:   Wed, 9 Mar 2022 18:50:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/18] 5.4.184-rc1 review
Message-ID: <YijpAJfZOyYxUY6o@kroah.com>
References: <20220309155856.552503355@linuxfoundation.org>
 <1ef6fd89-6648-215d-d44e-d577e242276f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ef6fd89-6648-215d-d44e-d577e242276f@gmail.com>
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 09:38:40AM -0800, Florian Fainelli wrote:
> On 3/9/22 7:59 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.184 release.
> > There are 18 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.184-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Russell made me aware of this message of yours:
> 
> https://lore.kernel.org/all/YiiuCMd%2FhLmQ7tfS@kroah.com/
> 
> do you expect to get ARM64 patches for 5.4 (included) and versions
> before and publish those as a different stable tag with those
> specifically? If so, would not it be easier from a logistics point of
> view if ARM, ARM64 and x86 all get BHB mitigations within the same
> stable tag?

I would have loved to have all three show up in the same stable
releases, and for some kernels (5.10 and newer) that looks like it will
happen.  I was not happy with the 5.4 and older backports just yet
enough to be able to add them to a -rc.

Hopefully James and I can work through the issues and have them in a
kernel soon.

Note, Linus's tree, and these backports, all do break when using clang
for arm32 and arm64, so that is an issue for many ARM users.  Hopefully
that can be resolved and when the fixes hit Linus's tree, I'll be glad
to take them to stable releases.

thanks,

greg k-h
