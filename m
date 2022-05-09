Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96ECD51F5A5
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 09:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiEIHlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 03:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiEIHSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 03:18:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D7F1B1768;
        Mon,  9 May 2022 00:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 437826126D;
        Mon,  9 May 2022 07:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ECBC385AE;
        Mon,  9 May 2022 07:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652080457;
        bh=gcRoyV3X96LpN7F+la4KyWiaZ7nU+vesDFBx8IloRgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UKGHSo0b9+4XPNzsOoMnkaWr0jATuLoxk3Syvje5qIWQk8l3tNZyxV5HCxj/63Twb
         TR+z+yMszswb+Nhv86oTnKY67Mm9vZNfovtYFyVLImqsrnLhssEenBmvatbXjlwua8
         k7Jwr6zVgW7763SvUHg1mrJ1tpGHkTjqOENNeMZ8=
Date:   Mon, 9 May 2022 09:14:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.15 000/177] 5.15.38-rc1 review
Message-ID: <Yni/Rj0b0IBiXtMi@kroah.com>
References: <20220504153053.873100034@linuxfoundation.org>
 <3b2c2d62-1e05-4a41-9d73-7bec2e63f8e7@rnnvmail202.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b2c2d62-1e05-4a41-9d73-7bec2e63f8e7@rnnvmail202.nvidia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 05, 2022 at 02:59:59AM -0700, Jon Hunter wrote:
> On Wed, 04 May 2022 18:43:13 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.38 release.
> > There are 177 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.38-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v5.15:
>     10 builds:	10 pass, 0 fail
>     28 boots:	28 pass, 0 fail
>     114 tests:	110 pass, 4 fail
> 
> Linux version:	5.15.38-rc1-gc8851235b4b7
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py
>                 tegra194-p2972-0000: pm-system-suspend.sh
>                 tegra20-ventana: pm-system-suspend.sh

Odd, any ideas why things failed here?

thanks,

greg k-h
