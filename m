Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE935533DD
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 15:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350098AbiFUNmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 09:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349766AbiFUNmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 09:42:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CDCF13;
        Tue, 21 Jun 2022 06:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA9661568;
        Tue, 21 Jun 2022 13:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D11EC3411C;
        Tue, 21 Jun 2022 13:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655818931;
        bh=7v2QJm1hZaDdt0zLPShmmQgmJHEAyqYcRMacSX9FLOw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WrEtS4ysPqCv5tbxXfkLbeM7+XPv/BZh03yLYEBrKk954BlABPlcfl9q4u0+eBVfA
         puajsNHutY9CHrO0SE17L83mST3Yi59LZFsy0kdoOEFj/olRJdyHzZ1o84WFWNmwUD
         u9om2KGKsdZ76e8W7fMRsWGzjzCw3h8uobreASC0=
Date:   Tue, 21 Jun 2022 15:42:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/240] 5.4.200-rc1 review
Message-ID: <YrHKtECSMSQkc+g/@kroah.com>
References: <20220620124737.799371052@linuxfoundation.org>
 <20220621133627.GA3436363@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621133627.GA3436363@roeck-us.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 06:36:27AM -0700, Guenter Roeck wrote:
> On Mon, Jun 20, 2022 at 02:48:21PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.200 release.
> > There are 240 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.200-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> [ ... ]
> > 
> > Linus Torvalds <torvalds@linux-foundation.org>
> >     netfs: gcc-12: temporarily disable '-Wattribute-warning' for now
> > 
> I am told that this commit breaks builds with clang. Maybe that is no
> concern for others, but we'll have to revert it when merging the release
> into ChromeOS.

I have now deleted it from all branches except for 5.18.y.

thanks,

greg k-h
