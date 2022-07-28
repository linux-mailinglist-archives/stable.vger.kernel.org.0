Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A204A583FDA
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 15:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbiG1NUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 09:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238292AbiG1NUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 09:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1282832DAD;
        Thu, 28 Jul 2022 06:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F6F961D24;
        Thu, 28 Jul 2022 13:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE87C433C1;
        Thu, 28 Jul 2022 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659014421;
        bh=tHDTyq2hdN96B8IB/iVj5p+CrqNlScGtW51Z07fePSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZeSXlfmSi4bs66UnUuv/RfkhzPunN+pJb8couQVgnafx+rIPUx9cpEzO71+yAiif
         NmVvug172XK3zCzP+dQHb3oFKb9L4qvkxzZsNOqrAK3ZpA44DSFYHdeTXC6Cubi2iM
         ZHh5sZoxq7SuTujceywxey7Ob80D3Reui1kuAp8M=
Date:   Thu, 28 Jul 2022 15:20:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/201] 5.15.58-rc1 review
Message-ID: <YuKNE2wtpJEXAgWj@kroah.com>
References: <20220727161026.977588183@linuxfoundation.org>
 <fa5fd00e-d71f-da29-0242-058026f90128@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa5fd00e-d71f-da29-0242-058026f90128@roeck-us.net>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 28, 2022 at 06:13:42AM -0700, Guenter Roeck wrote:
> On 7/27/22 09:08, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.58 release.
> > There are 201 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building i386:allyesconfig ... failed
> --------------
> Error log:
> In file included from drivers/gpu/drm/amd/amdgpu/../display/dc/os_types.h:37,
>                  from drivers/gpu/drm/amd/amdgpu/../display/dc/dm_services_types.h:29,
>                  from drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:29:
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c: In function 'dm_dmub_outbox1_low_irq':
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:761:51: error: format '%ld' expects argument of type 'long int', but argument 3 has type 'unsigned int'
> 
> Needs commit 655c167edc8c26 ("drm/amd/display: Fix wrong format specifier
> in amdgpu_dm.c").

Thanks, now added.  I'll push out a -rc2 now with that fix as well.

greg k-h
