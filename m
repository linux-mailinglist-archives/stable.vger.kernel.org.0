Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3845A938E
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 11:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiIAJrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 05:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiIAJrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 05:47:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC7C10DE54;
        Thu,  1 Sep 2022 02:47:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB09361AA6;
        Thu,  1 Sep 2022 09:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DED5C433C1;
        Thu,  1 Sep 2022 09:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662025653;
        bh=z3wbJW9EJOCzS6m1Ox+YHd+GTb7zaje8+h5aW1CZKUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rZqdr31V+SM+FC2I+QME8mAQfyb/wVu/QyBOJ85Zq2BgrHShQI7vqHFjHh36ggOwG
         HhFRaQw5NyRg7FrD9nsxLjt3pwER7BPZ4WTMUPj49CWPk96sll64aPb5VJ4EROt8dv
         CnlZZPjEtTvJz6aAsBSlbADq6rxz+JtW9UUa4laY=
Date:   Thu, 1 Sep 2022 11:47:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
Message-ID: <YxB/stkbJtsz6IgY@kroah.com>
References: <20220829105808.828227973@linuxfoundation.org>
 <Yw3oZlIwhvJbG0rs@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw3oZlIwhvJbG0rs@debian>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 11:37:26AM +0100, Sudip Mukherjee (Codethink) wrote:
> Hi Greg,
> 
> On Mon, Aug 29, 2022 at 12:57:30PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.19.6 release.
> > There are 158 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> > Anything received after that time might be too late.
> 
> Build test (gcc version 12.2.1 20220819):
> mips: 59 configs -> 1 failure
> arm: 99 configs -> no failure
> arm64: 3 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> csky allmodconfig -> fails
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
> 
> mips and csky are known failure. Fix not yet in mainline.
> 
> Boot test:
> x86_64: Booted on my test laptop. No regression.
> x86_64: Booted on qemu. No regression. [1]
> arm64: Booted on rpi4b (4GB model). No regression. [2]
> mips: Booted on ci20 board. No regression. [3]
> 
> DRM warnings in rpi4b, now fixed in mainline.
> Will need:
> 258e483a4d5e ("drm/vc4: hdmi: Rework power up")
> 72e2329e7c9b ("drm/vc4: hdmi: Depends on CONFIG_PM")

Both now queued up, thanks!

greg k-h
