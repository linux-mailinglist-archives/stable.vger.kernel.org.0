Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FA866E051
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 15:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjAQOV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 09:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjAQOU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 09:20:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420883C2B2;
        Tue, 17 Jan 2023 06:20:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFCCB61467;
        Tue, 17 Jan 2023 14:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63817C43396;
        Tue, 17 Jan 2023 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673965241;
        bh=HVjYbcbIJqfuU8LXS8YoP7sbskPMk0r1wpvuZF2N8Cw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UHf+qHkbZA9FT63mH1FDa9Wd82xAZTZWBymhF99aIszJNfGADZLMw66RzpP820Cek
         WVRpRh2kmw0bXz2Y4a5RW0yd3qj1c6Xz1R4DaThB/1EuhOZulso1+oLCFBCv0xElmd
         RLU7rQrI6DGlFZ9mDSIM8A3KIJxD3vKh+nUg2ZHU=
Date:   Tue, 17 Jan 2023 15:20:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
Message-ID: <Y8ausb2O0NOkIaid@kroah.com>
References: <20230116154743.577276578@linuxfoundation.org>
 <Y8aWCCF8bvmMnj0g@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8aWCCF8bvmMnj0g@debian>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 12:35:20PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 16, 2023 at 04:51:07PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.164 release.
> > There are 64 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> > Anything received after that time might be too late.
> 
> Build test (gcc version 11.3.1 20221127):
> mips: 63 configs -> no failure
> arm: 104 configs -> 1 failure
> arm64: 3 configs -> 1 failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
> 
> Note:
> arm and arm64 builds fail with the error:
> drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
> drivers/gpu/drm/msm/dp/dp_aux.c:427:14: error: 'isr' undeclared (first use in this function); did you mean 'idr'?
>   427 |         if (!isr)
>       |              ^~~
>       |

Should now be fixed in -rc2.

thanks,

greg k-h
