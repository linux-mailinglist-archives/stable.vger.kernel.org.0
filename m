Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1214D02AE
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiCGP0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 10:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240171AbiCGP0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 10:26:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDD28AE48;
        Mon,  7 Mar 2022 07:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4418B815E6;
        Mon,  7 Mar 2022 15:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA19CC340E9;
        Mon,  7 Mar 2022 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646666718;
        bh=tPSJwvj/nx+CuAGrMtbK/3CwSFyUdSo8yj+RMGWVt04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Td7eMQGb8trZ4OVTsel2FbR60G/053iM6Vxv/y/P94BWUkFQH29vLjN6qW+DuGBx3
         9clsR5m+lw2d6iJ6jjd5wZLTTdO+bXcijlpZA1Ge3s3jtHIg/XF1RBZQWnuYM5VDYX
         nO+2bMHRPD93x7I0swALYI69aQlJk+LbVRCps2pQ=
Date:   Mon, 7 Mar 2022 16:25:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/262] 5.15.27-rc1 review
Message-ID: <YiYj2+N+wn1Y6yqL@kroah.com>
References: <20220307091702.378509770@linuxfoundation.org>
 <195f7801-7207-d317-c4d9-30859ff9cbe1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <195f7801-7207-d317-c4d9-30859ff9cbe1@nvidia.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 02:26:43PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 07/03/2022 09:15, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.27 release.
> > There are 262 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.kernel.org%2Fpub%2Flinux%2Fkernel%2Fv5.x%2Fstable-review%2Fpatch-5.15.27-rc1.gz&amp;data=04%7C01%7Cjonathanh%40nvidia.com%7C52f7666efdc24e35cbc708da001e0bcc%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637822426962400608%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=7OrqXqRl71%2FAG4A1q5lIuWzCpA0r7uul3XpgJIfyVuA%3D&amp;reserved=0
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
> > Hou Tao <houtao1@huawei.com>
> >      bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
> 
> 
> The above commit is causing a build break for ARM64 ...
> 
> arch/arm64/net/bpf_jit_comp.c: In function ‘build_insn’:
> arch/arm64/net/bpf_jit_comp.c:791:7: error: implicit declaration of function ‘bpf_pseudo_func’ [-Werror=implicit-function-declaration]
>    if (bpf_pseudo_func(insn))
>        ^~~~~~~~~~~~~~~

Thanks, I'll go drop that offending patch.

greg k-h
