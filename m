Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA98E5EADB0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiIZRKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiIZRK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:10:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D2D2A26A;
        Mon, 26 Sep 2022 09:18:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 438E660B75;
        Mon, 26 Sep 2022 16:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B177C433D6;
        Mon, 26 Sep 2022 16:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664209137;
        bh=YiJbT1Nm+dX/sw2LoodX8ej/0S+ezoMzomlfvb0VmUA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v1dlv35LSawa8gn6f64o+e+ULe7pWp75RqVxD6x1dYdYfftCEYeHCox9r8GDJLJ/R
         beVcy15dRVqN7Z+vtYgpEzLOKJk3wyppZlOm2solFXZfPaPj0PqXIYiQUvvX5YMve2
         B8furSVkHrwGh6pJU+WBnYSX+954qm2sbj+IbM7w=
Date:   Mon, 26 Sep 2022 18:18:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/148] 5.15.71-rc1 review
Message-ID: <YzHQ71rtjD0PbxpP@kroah.com>
References: <20220926100756.074519146@linuxfoundation.org>
 <23dbb0fb-5bed-a340-55c2-1c0d3d537ea2@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23dbb0fb-5bed-a340-55c2-1c0d3d537ea2@roeck-us.net>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 06:44:49AM -0700, Guenter Roeck wrote:
> On 9/26/22 03:10, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.71 release.
> > There are 148 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Another build failure:
> 
> Building powerpc:defconfig ... failed
> --------------
> Error log:
> powerpc64-linux-ld: arch/powerpc/kernel/rtas_entry.o: in function `enter_rtas':
> (.text+0x92): undefined reference to `IRQS_ENABLED'
> make[1]: *** [Makefile:1214: vmlinux] Error 1
> make: *** [Makefile:219: __sub-make] Error 2

Offending patch (and follow-on patch), now dropped, thanks.

greg k-h
