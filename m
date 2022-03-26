Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2E4E7FA8
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 07:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiCZHBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 03:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiCZHBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 03:01:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD6758808;
        Fri, 25 Mar 2022 23:59:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F145560B8E;
        Sat, 26 Mar 2022 06:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8553FC340E8;
        Sat, 26 Mar 2022 06:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648277971;
        bh=hcnH4+UMQw++oX3xHdLZbQDMciOJal1V9edqfc5pFT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0IQwESLLFrZUE8bD36nlPhVsNI0+Ss1+wcGYvi8aO06GXd9Z8DFyrIag5O/pKZ08T
         AZyJ0pqst8d7HyaafTG6X4RzIg/7caK9KbdvzW5EOjHzxdIqGkipCtoVaW5V+78c6i
         P2a0Ro/dviLeMpKAT6TyY20QUEBLkGXqts+7ncW0=
Date:   Sat, 26 Mar 2022 07:59:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/14] 4.9.309-rc1 review
Message-ID: <Yj650YKy7UG+enlA@kroah.com>
References: <20220325150415.694544076@linuxfoundation.org>
 <15268a27-5386-45d8-5c55-1095251331f7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15268a27-5386-45d8-5c55-1095251331f7@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 02:31:59PM -0700, Florian Fainelli wrote:
> On 3/25/22 08:04, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.309 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.309-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> PS: is there any reason why the Spectre BHB patches from here are not part
> of linux-stable/linux-4.9.y?

Because they were not submitted for inclusion :(
