Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699D1681869
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 19:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbjA3SOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 13:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjA3SOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 13:14:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0E613D54;
        Mon, 30 Jan 2023 10:14:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EC1661206;
        Mon, 30 Jan 2023 18:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323A6C433EF;
        Mon, 30 Jan 2023 18:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675102476;
        bh=21jkaeox/IaE/j91iGqPRujdRRemIKiKw5zjR/dW7y4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jpo+LVlV6BXWVmuj1CrnFn4N6Vk4KmNT1smO4ro3TNnPJ3kinJSusBJj5MNZOl7GX
         004h8kpetyP7Z5CV1n90K/QFVGx7z7fqiYPc2UyzsnzoqXgi7lPQpLUS0dlC53n2ed
         a0jHspuDARZ4GG8wagy4ESsnk1rgDZ6jUgDkJhuM=
Date:   Mon, 30 Jan 2023 19:14:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc1 review
Message-ID: <Y9gJCaPhWGnffClH@kroah.com>
References: <20230130134336.532886729@linuxfoundation.org>
 <01cb274a-1adb-1a46-0260-fbaee94feb8a@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01cb274a-1adb-1a46-0260-fbaee94feb8a@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 30, 2023 at 08:41:48AM -0800, Guenter Roeck wrote:
> On 1/30/23 05:47, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.9 release.
> > There are 313 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building csky:allmodconfig ... failed
> --------------
> Error log:
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c: In function 'amdgpu_dm_atomic_check':
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:9397:43: error: unused variable 'mst_state' [-Werror=unused-variable]
>  9397 |         struct drm_dp_mst_topology_state *mst_state;
>       |                                           ^~~~~~~~~
> drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:9396:41: error: unused variable 'mgr' [-Werror=unused-variable]
>  9396 |         struct drm_dp_mst_topology_mgr *mgr;
>       |                                         ^~~
> 
> and other similar errors.
> 
> AFAICS it is missing upstream commit f439a959dcfb ("amdgpu: fix build on
> non-DCN platforms.").

Ah, good catch, I'll go apply this and push out a -rc2 now.

thanks!

greg k-h
