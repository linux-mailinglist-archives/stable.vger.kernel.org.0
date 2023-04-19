Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992DD6E7634
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjDSJ1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbjDSJ1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:27:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAF1B464;
        Wed, 19 Apr 2023 02:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDE0962C76;
        Wed, 19 Apr 2023 09:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9D9C433A0;
        Wed, 19 Apr 2023 09:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681896417;
        bh=qxflMxePag1Pfp9FeskoGvnzx5TEu05J4qB66RIz4rc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wX8OfZTayjwW6YX7xOLU3POe0aPRl6JO4m/T5PLFXaqUZqdpxXFqQ/vxy7I0M/rxa
         +yS8acIoPwUueFeHp/yuP0hFYjsCaxuYaQHzRR8o84phECE1X0LN3EjP7f83i/Yqy1
         6YfVTF2fJBPdlEnn01u8jv8X+91DlXoaYnxPfgRI=
Date:   Wed, 19 Apr 2023 11:26:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/88] 5.15.108-rc2 review
Message-ID: <2023041934-affection-whisking-db24@gregkh>
References: <20230419072156.965447596@linuxfoundation.org>
 <f10dd20e-6dce-490a-f3fb-fdf79e83bc1d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f10dd20e-6dce-490a-f3fb-fdf79e83bc1d@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 19, 2023 at 01:11:32AM -0700, Guenter Roeck wrote:
> On 4/19/23 00:23, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.108 release.
> > There are 88 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 21 Apr 2023 07:21:37 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc2.gz
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
> > 
> ...
> > Alexandre Ghiti <alexghiti@rivosinc.com>
> >      riscv: Do not set initial_boot_params to the linear address of the dtb
> > 
> 
> As expected, a quick test shows that this patch still results in immediate
> riscv32/64 crashes.

Thanks for the report, let me go drop this and push out a -rc3...

greg k-h
