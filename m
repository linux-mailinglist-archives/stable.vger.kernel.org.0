Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F87A5EADB8
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiIZRL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiIZRLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:11:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC0A5465D;
        Mon, 26 Sep 2022 09:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6D36B80066;
        Mon, 26 Sep 2022 16:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02565C433C1;
        Mon, 26 Sep 2022 16:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664209234;
        bh=yypSsraSsf0tgaRhvFqL+1XAUv+XvuX00wBiIndmoRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GYfPnzSPYjLCKm0TgwOa0t48I/18Rqvk/lp8oHX7DPe8RAqjUW4G7SBtHaU+daiHU
         uZWTjgrsrKsnwE1kdB4tvEB5uIP4HPsZAxxWxcp0m77rfn839KE1/jdWcqdqazNcKc
         o9eU3T23/uRPUkp9W9S83oI5V3euVhFoY4h2O3Og=
Date:   Mon, 26 Sep 2022 18:20:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/58] 4.19.260-rc1 review
Message-ID: <YzHRTx1QZ9F9vJcK@kroah.com>
References: <20220926100741.430882406@linuxfoundation.org>
 <41bf6865-ed26-b1d0-f540-7c2d34a2522c@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41bf6865-ed26-b1d0-f540-7c2d34a2522c@roeck-us.net>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 06:40:27AM -0700, Guenter Roeck wrote:
> On 9/26/22 03:11, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.260 release.
> > There are 58 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> > Anything received after that time might be too late.
> 
> 
> Building riscv:defconfig ... failed
> --------------
> Error log:
> arch/riscv/kernel/signal.c: In function 'sys_rt_sigreturn':
> arch/riscv/kernel/signal.c:108:15: error: 'struct pt_regs' has no member named 'cause'; did you mean 'scause'?
>   108 |         regs->cause = -1UL;
>       |               ^~~~~
>       |               scause
> make[2]: *** [scripts/Makefile.build:303: arch/riscv/kernel/signal.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [Makefile:1073: arch/riscv/kernel] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:146: sub-make] Error 2

Will go drop the offending commit, thanks.

greg k-h
