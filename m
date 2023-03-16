Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9986BC7AE
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 08:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCPHuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 03:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCPHuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 03:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD04CA9DDB;
        Thu, 16 Mar 2023 00:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A520B82026;
        Thu, 16 Mar 2023 07:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5869FC4339B;
        Thu, 16 Mar 2023 07:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678952988;
        bh=0yOANMPqtyND/qZrPRckKTU0+G5MvOSEyU4jtRcWVzU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hHkKMHYfMo/u5ASQuDW4Wfod9VB2DV0aXNGPOw4aDxYfg6mZgD2SfvXhpEfVmR556
         rxRvCv+oywXXdot9qs7zimjPkhPLBCXRjAvZ9LpC3Pjdj4m8o6j2iAiKANIa+djggj
         89Gy6kL7zFObax0ovJpt1gMVS2gpVmdgcD8zhz4E=
Date:   Thu, 16 Mar 2023 08:49:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: Re: [PATCH 5.4 00/68] 5.4.237-rc1 review
Message-ID: <ZBLKGpyaGnpOb3Km@kroah.com>
References: <20230315115726.103942885@linuxfoundation.org>
 <TYCPR01MB10588F845D48C023460EDB70BB7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCPR01MB10588F845D48C023460EDB70BB7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 02:27:28PM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: 15 March 2023 12:12
> > 
> > This is the start of the stable review cycle for the 5.4.237 release.
> > There are 68 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
> 
> Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>
> CI Pipeline:  https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/807195748
> 
> We (CIP) are seeing some build issues with Linux 5.4.237-rc1 (543ff97e810c).
> 
> 1)
> For arm multi_v7_defconfig builds we're seeing a some errors when building the exynos5422 device trees:
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:409.10-412.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:413.10-416.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb] Error 2
> make[1]: *** Waiting for unfinished jobs....
> arch/arm/boot/dts/exynos5422-odroidhc1.dts:238.10-241.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map0: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidhc1.dts:242.10-245.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map1: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroidhc1.dtb] Error 2
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:409.10-412.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:413.10-416.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroidxu3.dtb] Error 2
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:409.10-412.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:413.10-416.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroidxu4.dtb] Error 2
> 
> Log: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/3939400038#L8368
> 
> Presumably caused by "ARM: dts: exynos: Add GPU thermal zone cooling maps for Odroid XU3/XU4/HC1", but I haven't had a chance to revert and re-test.

Should now be fixed up for -rc2, thanks.

greg k-h
