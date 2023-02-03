Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE157689F74
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 17:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbjBCQif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 11:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbjBCQia (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 11:38:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C090CA87B6;
        Fri,  3 Feb 2023 08:38:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06E12B82B5D;
        Fri,  3 Feb 2023 16:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D883C4339C;
        Fri,  3 Feb 2023 16:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675442304;
        bh=RlHl4TafOtyURvLxW+47xe/s90fdw7Ug/R5zJammeOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mk4QVRB6leRZyW/eTVgv6PWc0Kb6RGTPj/gfETFAHKSBN4uGqtPkXKFMJfHLy6TUi
         B9YyG8BAKxllIin9Eyug9PhYIdkVEH9NbWVStGZUJrxh4Ve2nZ/IrkJ8f0ObBUSlrG
         cWQf6twgS5g0e7Jvi0LWeX+N5dhntqqAH2GJ7Io0=
Date:   Fri, 3 Feb 2023 17:38:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Gaosheng Cui <cuigaosheng1@huawei.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
Message-ID: <Y904fF2WZHsznw9C@kroah.com>
References: <20230203101015.263854890@linuxfoundation.org>
 <CA+G9fYvd8D3LfxPg2afZXKFC3WNHrhyE7c3fFLViaG4WhJeHVg@mail.gmail.com>
 <5ed630fd-8bd7-4b80-9fa8-a3dab2eb0447@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ed630fd-8bd7-4b80-9fa8-a3dab2eb0447@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 01:28:59PM +0100, Krzysztof Kozlowski wrote:
> On 03/02/2023 12:04, Naresh Kamboju wrote:
> > On Fri, 3 Feb 2023 at 15:48, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >>
> >> This is the start of the stable review cycle for the 4.19.272 release.
> >> There are 80 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
> >> or in the git tree and branch at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> >>
> > 
> > Following patch caused build error on arm,
> > 
> >> Gaosheng Cui <cuigaosheng1@huawei.com>
> >>     memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
> > 
> > drivers/memory/mvebu-devbus.c: In function 'mvebu_devbus_probe':
> > drivers/memory/mvebu-devbus.c:297:8: error: implicit declaration of
> > function 'devm_clk_get_enabled'
> > [-Werror=implicit-function-declaration]
> >   297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
> >       |        ^~~~~~~~~~~~~~~~~~~~
> 
> Already reported:
> https://lore.kernel.org/all/202302020048.ZsmUJDHo-lkp@intel.com/

I barely look at 0-day reports about the stable stuff as there is just
too much noise with it, and loads of false problems reported.

So this is a valid report, thanks!

greg k-h
