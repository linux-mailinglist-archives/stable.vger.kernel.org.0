Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FE764B740
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 15:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbiLMOXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 09:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbiLMOXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 09:23:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A11E25E;
        Tue, 13 Dec 2022 06:23:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D52CF61554;
        Tue, 13 Dec 2022 14:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AB9C433D2;
        Tue, 13 Dec 2022 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670941385;
        bh=kIVlJ1wgdxh3uRwxhcQwYg7GRITJfYPzPgFLuI+9U4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V6RUet3S5mNOEZXXkV6b4aAvTrfZNSuXAwWjM0dSWIoP/EkbY0mV69K/YSOBr8xn6
         V+27PgkPjC4vBCY8BU2Iw+ixZHEOIOVjaI2zq4hkAkRde/qUcVX7BScZ8QTuCWZrz1
         05wp/R0G9+bkrUPgkkOovsX2wRPSEiIZkPs43xCg=
Date:   Tue, 13 Dec 2022 15:23:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     yuehaibing@huawei.com, keescook@chromium.org,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <Y5iKxjEHCIzMEOCa@kroah.com>
References: <20221212130924.863767275@linuxfoundation.org>
 <Y5dzn4y73kgwuas+@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5dzn4y73kgwuas+@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 07:31:59PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.159 release.
> > There are 106 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> 
> > YueHaibing <yuehaibing@huawei.com>
> >     net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835
> 
> This one is not suitable for 5.10, we don't have
> PTP_1588_CLOCK_OPTIONAL there.

Now dropped.

> > Kees Cook <keescook@chromium.org>
> >     ALSA: seq: Fix function prototype mismatch in
> > snd_seq_expand_var_event
> 
> This is useful fo kCFI, but we don't have kCFI in 5.10 and others.

I'll keep this one as it solves a clang warning that people are going to
hit eventually on older kernels.

thanks,

greg k-h
