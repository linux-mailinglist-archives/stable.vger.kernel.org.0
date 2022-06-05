Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEB653DABD
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 09:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbiFEHhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 03:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiFEHhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 03:37:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5325D5F4B;
        Sun,  5 Jun 2022 00:37:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 845B7B80AE0;
        Sun,  5 Jun 2022 07:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9D2C385A5;
        Sun,  5 Jun 2022 07:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654414648;
        bh=BlHOdUUFu9ARO6Hrbt/vvzWUROrjNL6rVvx1mwyku9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hu2QmpbrutMFqqlp9pCtR64kbJzb4P1B+q3DeYiWWUEW29YzrFjUgPMt5oPDT2FrH
         1JuNjfrkBJXxJfXbwCRSIbgBvRnkICOX8BSv69Cbid2VZwAk1xHCxT2XhpTABZ8/pX
         LlCp/7QWZh7ginlvjKsjuo7Vh29lhrV+Zykp+ekI=
Date:   Sun, 5 Jun 2022 09:38:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Ferenc Havasi <havasi@inf.u-szeged.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5.18 00/67] 5.18.2-rc1 review
Message-ID: <YpxdZnfOuTybBeOi@kroah.com>
References: <20220603173820.731531504@linuxfoundation.org>
 <YpxU/bVogip64iQF@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpxU/bVogip64iQF@debian.me>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 05, 2022 at 02:02:21PM +0700, Bagas Sanjaya wrote:
> On Fri, Jun 03, 2022 at 07:43:01PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.18.2 release.
> > There are 67 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> 
> Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0, neon
> FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).
> 
> On arm64 build, I found partly outside array bounds warning:

The kernel does not build cleanly on gcc12 just yet, so it will be a
while before stuff like this goes away.  Please submit patches to the
proper subsystem developers to help resolve this.

thanks,

greg k-h
