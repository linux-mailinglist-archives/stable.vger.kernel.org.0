Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD146BE9B7
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 13:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjCQMzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 08:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCQMzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 08:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AADE12BC7;
        Fri, 17 Mar 2023 05:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C84E7622A3;
        Fri, 17 Mar 2023 12:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CB0C4339B;
        Fri, 17 Mar 2023 12:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679057745;
        bh=qg+EwQsv/p5UD+n3/gGaCynZ+XcaO3bFfgawomGNlQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d+qMuMXC7iao+a1aAKpUS2OVaIkAjXbk9uWgOqd/hGE9TvU8rQkUN6gh1NgFLJRPW
         DJaYCUr46TbKw9fzMmbBOt4BCzgp5R9S2ivZK1bhGmPFW5Q/7thQebwY/qtUk6Gazs
         vMMevCEVS45DFDoGgjRwHJsQpK3TqCqTi0eia8vo=
Date:   Fri, 17 Mar 2023 13:55:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/27] 4.19.278-rc3 review
Message-ID: <ZBRjTid0Hc4V7bwB@kroah.com>
References: <20230316094129.846802350@linuxfoundation.org>
 <ZBQ/rhv9nP+i8Pyc@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBQ/rhv9nP+i8Pyc@debian>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 17, 2023 at 10:23:42AM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Thu, Mar 16, 2023 at 10:42:14AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.278 release.
> > There are 27 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 18 Mar 2023 09:41:20 +0000.
> > Anything received after that time might be too late.
> 
> Build test (gcc version 11.3.1 20230311):
> mips: 63 configs -> no  failure
> arm: 115 configs -> no failure
> arm64: 2 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
> 
> Boot test:
> x86_64: Booted on qemu. No regression. [1]
> 
> Boot Regression on test laptop:
> Only black screen but ssh worked, so from the dmesg it seems i915 failed.

Can you bisect this?

