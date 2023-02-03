Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F68689FE0
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 18:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbjBCRFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 12:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbjBCREm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 12:04:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6510E9D06F;
        Fri,  3 Feb 2023 09:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1917BB82B59;
        Fri,  3 Feb 2023 17:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3BDC433EF;
        Fri,  3 Feb 2023 17:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675443878;
        bh=nU73C6viOxbyUSqx/3DL5zkhAa9hnTEqq/1ERVAXrvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rDCsBtBhgSbn/0F6fLu+O+sPq9XSJ3QiA8XtUWJ1UMWqzEFqJ2fCUDtknNCK8usZe
         W4gFJM/CnSeIMKUZDE7PuAiue0aQT5Hdtl04snLDlGIoY+YE9bvNz89YrTxmIFXJv1
         76aOMizO7TqVeu7PZN9xWtetvyZy+xWD1KFdlx6s=
Date:   Fri, 3 Feb 2023 18:04:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Gaosheng Cui <cuigaosheng1@huawei.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
Message-ID: <Y90+o7thxeMg369g@kroah.com>
References: <20230203101015.263854890@linuxfoundation.org>
 <CA+G9fYvd8D3LfxPg2afZXKFC3WNHrhyE7c3fFLViaG4WhJeHVg@mail.gmail.com>
 <5ed630fd-8bd7-4b80-9fa8-a3dab2eb0447@linaro.org>
 <4e5a447b-1796-513c-135a-f9e9c870d88a@roeck-us.net>
 <5e57cf49-6348-7878-0e01-51e5e1359fa8@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e57cf49-6348-7878-0e01-51e5e1359fa8@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 05:56:17PM +0100, Krzysztof Kozlowski wrote:
> On 03/02/2023 16:51, Guenter Roeck wrote:
> > On 2/3/23 04:28, Krzysztof Kozlowski wrote:
> >> On 03/02/2023 12:04, Naresh Kamboju wrote:
> >>> On Fri, 3 Feb 2023 at 15:48, Greg Kroah-Hartman
> >>> <gregkh@linuxfoundation.org> wrote:
> >>>>
> >>>> This is the start of the stable review cycle for the 4.19.272 release.
> >>>> There are 80 patches in this series, all will be posted as a response
> >>>> to this one.  If anyone has any issues with these being applied, please
> >>>> let me know.
> >>>>
> >>>> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> >>>> Anything received after that time might be too late.
> >>>>
> >>>> The whole patch series can be found in one patch at:
> >>>>          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
> >>>> or in the git tree and branch at:
> >>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> >>>> and the diffstat can be found below.
> >>>>
> >>>> thanks,
> >>>>
> >>>> greg k-h
> >>>>
> >>>
> >>> Following patch caused build error on arm,
> >>>
> >>>> Gaosheng Cui <cuigaosheng1@huawei.com>
> >>>>      memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
> >>>
> >>> drivers/memory/mvebu-devbus.c: In function 'mvebu_devbus_probe':
> >>> drivers/memory/mvebu-devbus.c:297:8: error: implicit declaration of
> >>> function 'devm_clk_get_enabled'
> >>> [-Werror=implicit-function-declaration]
> >>>    297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
> >>>        |        ^~~~~~~~~~~~~~~~~~~~
> >>
> >> Already reported:
> >> https://lore.kernel.org/all/202302020048.ZsmUJDHo-lkp@intel.com/
> >>
> > 
> > I don't usually check if release candidate reports have been reported already.
> > If I know about it, I may add a reference to the report, but typically I still
> > report it.
> > 
> > Personally I find it discouraging to get those "already reported" e-mails.
> > To me it sounds like "hey, you didn't do your job properly". It should not matter
> > if a problem was already reported or not, and I find it valuable if it is
> > reported multiple times because it gives an indication of the level of test
> > coverage. I would find it better if people would use something like "Also
> > reported:" instead. But then maybe I am just oversensitive, who knows.
> > 
> > Anyway, yes, I noticed this problem as well (and probably overlooked it
> > in my previous report to Greg - sorry for that).
> > 
> 
> Let me rephrase it then:
> 
> This topic is already discussed here:
> https://lore.kernel.org/all/202302020048.ZsmUJDHo-lkp@intel.com/
> 
> I proposed to drop both broken backports - mvebu-devbus and
> atmel-sdramc, because they require new features in common clock
> framework API.

Ah, I totally missed that, again, seeing the good in the mess of the
0-day reports here is hard and not obvious at all.  I ignored that and
hence the problem was here.  I've dropped the offending commit now.

thanks,

greg k-h
