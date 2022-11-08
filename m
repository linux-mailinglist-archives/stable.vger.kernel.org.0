Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C13621D4F
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 20:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiKHTyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 14:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKHTyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 14:54:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584D41C11A;
        Tue,  8 Nov 2022 11:54:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0FA5B81C1B;
        Tue,  8 Nov 2022 19:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F66C433D6;
        Tue,  8 Nov 2022 19:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667937287;
        bh=e9/OVV1olIacxfkwIpM+kXSymXydOoMWO2v3G8dy+Cc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OFNjL8xCfJnCk5wm1KhSjhEWEJ3wk9UDHMfnL5RC/3tsEQAQAcB08WhIrAB0h3Phn
         ny0RaC6MuvyQRxkRv0KqK1ERigFSRQKRH8C7mO4CDgasmDQf/0cSYh05/2Qu33fr85
         RVvDTeZbXbf2tIbcZnDCAtTavn4FqyBSzoSB7Rc4=
Date:   Tue, 8 Nov 2022 20:54:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     sashal@kernel.org, Pavel Machek <pavel@denx.de>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/118] 5.10.154-rc1 review
Message-ID: <Y2q0A/sbF65Z8UBs@kroah.com>
References: <20221108133340.718216105@linuxfoundation.org>
 <Y2pxr88XE+XP6uNc@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2pxr88XE+XP6uNc@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 04:11:43PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.154 release.
> > There are 118 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I'm getting build errors with the dtbs:
> 
> Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 syntax error
> 10169FATAL ERROR: Unable to parse input tree
> 10170make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-cx.dtb] Error 1
> 10171make[2]: *** Waiting for unfinished jobs....
> 10172Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 syntax error
> 10173FATAL ERROR: Unable to parse input tree
> 10174make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freescale/fsl-lx2160a-honeycomb.dtb] Error 1
> 10175  DTC     arch/arm64/boot/dts/renesas/r8a774b1-hihope-rzg2n-rev2.dtb
> 10176  DTC     arch/arm64/boot/dts/allwinner/sun50i-h5-bananapi-m2-plus-v1.2.dtb
> 10177  DTC     arch/arm64/boot/dts/renesas/r8a774b1-hihope-rzg2n-rev2-ex.dtb
> 10178Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 syntax error
> 10179FATAL ERROR: Unable to parse input tree
> 10180make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freescale/fsl-lx2160a-qds.dtb] Error 1
> 10181  DTC     arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dtb
> 10182
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/3291098692

Odd.

Sasha, any ideas what went wrong here, but not in the other branches?

thanks,

greg k-h
