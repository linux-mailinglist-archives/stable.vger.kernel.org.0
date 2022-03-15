Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C6A4D9B32
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 13:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348264AbiCOM3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 08:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbiCOM3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 08:29:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4256410E2;
        Tue, 15 Mar 2022 05:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2044B81604;
        Tue, 15 Mar 2022 12:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE02C340EE;
        Tue, 15 Mar 2022 12:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647347305;
        bh=Ye/ocCGoca+qFVAWeKWtxYvCf9/D8eC+LLNNN0SVF8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dwoyEDyPlZeusu3XvRaZorYD9Ag4OSd+LxC8HFYTcS6xHRV3uXWCTtJVpMGRrnc8b
         hLVncT+SxCzFNgGXx7MzqxhUKU8GfVxdb6UrRw1b4EyjLgio8duvlSsZa4DW0PGGrF
         RkhmW/dO0qHS9rv0WBtCblD0NBOjCrt3XBcdbnJo=
Date:   Tue, 15 Mar 2022 13:28:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     James Morse <james.morse@arm.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/30] 4.19.235-rc1 review
Message-ID: <YjCGZVxDgtxzzswA@kroah.com>
References: <20220314112731.785042288@linuxfoundation.org>
 <0ac87017-362d-33e2-eace-3407e0891a94@nvidia.com>
 <Yi9LlP+x2swdsrbE@kroah.com>
 <ae60e4a0-3333-1ad7-1ac9-62e6ac3751de@nvidia.com>
 <Yi9X4jqy4RT4jr5n@kroah.com>
 <3f809462-217d-fc4d-8e1e-a3d265350fcb@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f809462-217d-fc4d-8e1e-a3d265350fcb@arm.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 12:14:08PM +0000, James Morse wrote:
> Hi Greg,
> 
> On 3/14/22 2:57 PM, Greg Kroah-Hartman wrote:
> > On Mon, Mar 14, 2022 at 02:14:41PM +0000, Jon Hunter wrote:
> > > On 14/03/2022 14:05, Greg Kroah-Hartman wrote:
> > > > On Mon, Mar 14, 2022 at 01:58:12PM +0000, Jon Hunter wrote:
> > > > > On 14/03/2022 11:34, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 4.19.235 release.
> > > > > > There are 30 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > > 
> > > > > > Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> > > > > > Anything received after that time might be too late.
> 
> 
> > > > > > James Morse <james.morse@arm.com>
> > > > > >        KVM: arm64: Reset PMC_EL0 to avoid a panic() on systems with no PMU
> > > > > 
> > > > > 
> > > > > The above is causing the following build error for ARM64 ...
> > > > > 
> > > > > arch/arm64/kvm/sys_regs.c: In function ‘reset_pmcr’:
> > > > > arch/arm64/kvm/sys_regs.c:624:3: error: implicit declaration of function ‘vcpu_sys_reg’ [-Werror=implicit-function-declaration]
> > > > >      vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
> > > > >      ^~~~~~~~~~~~
> > > > > arch/arm64/kvm/sys_regs.c:624:32: error: lvalue required as left operand of assignment
> > > > >      vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
> > > > > 
> > > > 
> > > > Is this also broken in Linus's tree?
> > > 
> > > 
> > > No, Linus' tree is not broken. However, I don't see this change in Linus'
> > > tree (v5.17-rc8).
> > 
> > Ah, this is a "fix something broken in stable-only" type patch :(
> 
> > James, I'm dropping this from the 4.19, 4.9, and 4.14 trees right now as
> > it looks broken :(
> 
> What would you prefer I do here:
>  1 post a revert for the original problematic backport.
>  2 post versions of this to fix each of the above 3 stable kernels. (instead of putting conditions in the stable tag).

I don't see what I did wrong with the "conditions" in the existing
commit you sent.  How did I get it wrong?

Best case, send a patch series for each kernel tree.  That way I "know"
I got the right thing here.

thanks,

greg k-h
