Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0AC4D8669
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 15:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242092AbiCNOG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 10:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiCNOG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 10:06:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB2C6557;
        Mon, 14 Mar 2022 07:05:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D458EB80D41;
        Mon, 14 Mar 2022 14:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99548C340E9;
        Mon, 14 Mar 2022 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647266713;
        bh=IsAAYV3WUOlv8+MoKeOWEm/Ep7g4LUqQIqxERqeOzOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gH9sHxFxQkL2kjJ/SRfXSq+ZYnmM737KrfOnm3TpuCcB1eu6TD+MxIKEyqnZVhZkC
         w985PD0sc9xUKAlbrAYQcXwI01Tos9JlrRQ/0aegEmhYRPgsoTiB52ANbFJfC/e4jQ
         ytdFlfNiNuy8sSjBrcGd+qtkpgTy77PKSDUQcwY4=
Date:   Mon, 14 Mar 2022 15:05:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/30] 4.19.235-rc1 review
Message-ID: <Yi9LlP+x2swdsrbE@kroah.com>
References: <20220314112731.785042288@linuxfoundation.org>
 <0ac87017-362d-33e2-eace-3407e0891a94@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ac87017-362d-33e2-eace-3407e0891a94@nvidia.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 01:58:12PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 14/03/2022 11:34, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.235 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.kernel.org%2Fpub%2Flinux%2Fkernel%2Fv4.x%2Fstable-review%2Fpatch-4.19.235-rc1.gz&amp;data=04%7C01%7Cjonathanh%40nvidia.com%7C4c0c664e42044e5bd8a208da05af4c30%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637828547981871505%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=xF4hLHeQMZiCVtbZX2jXwWYGz30QY84EzlbqHLPUZSs%3D&amp;reserved=0
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > James Morse <james.morse@arm.com>
> >      KVM: arm64: Reset PMC_EL0 to avoid a panic() on systems with no PMU
> 
> 
> The above is causing the following build error for ARM64 ...
> 
> arch/arm64/kvm/sys_regs.c: In function ‘reset_pmcr’:
> arch/arm64/kvm/sys_regs.c:624:3: error: implicit declaration of function ‘vcpu_sys_reg’ [-Werror=implicit-function-declaration]
>    vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
>    ^~~~~~~~~~~~
> arch/arm64/kvm/sys_regs.c:624:32: error: lvalue required as left operand of assignment
>    vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
> 

Is this also broken in Linus's tree?

thanks,

greg k-h
