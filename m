Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1000D4BF41C
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 09:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiBVIzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 03:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiBVIzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 03:55:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2ED8113AE5;
        Tue, 22 Feb 2022 00:54:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83E8761468;
        Tue, 22 Feb 2022 08:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329BDC340E8;
        Tue, 22 Feb 2022 08:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645520077;
        bh=KV1vyrf03wHo5kkH8ahFpD4CbSLO9lMyXX/0EYnxBT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fIUj0Xu+co9enBoM12nDEJ2dUJ5gfDlk8Z0+WUH2QajBxmAwKv2tFHAex19PruztO
         UIhIKRJhS4T1/NMq2KDH/99db1/eZ4t/wn68nSWbdvIUkUBBkhwBdGiwDNKH6rCtnE
         JsDs6khcT1pkOuYTF77CGywloZ+I4zRqus2iPS+w=
Date:   Tue, 22 Feb 2022 09:54:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
Message-ID: <YhSkypbAQUq5t5K7@kroah.com>
References: <20220221084930.872957717@linuxfoundation.org>
 <d72c8af1-e93d-44ae-15e0-737302523961@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d72c8af1-e93d-44ae-15e0-737302523961@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 09:15:52AM -0800, Guenter Roeck wrote:
> On 2/21/22 00:47, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.25 release.
> > There are 196 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> > Anything received after that time might be too late.
> > 
> 
> 
> Building arm:allmodconfig ... failed
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> drivers/tee/optee/core.c: In function 'optee_probe':
> drivers/tee/optee/core.c:726:20: error: operation on 'rc' may be undefined

I'm going to drop the tee patches in 5.10 and 5.15 for now.

thanks,

> 
> Building mips:nlm_xlp_defconfig ... failed
> --------------
> Error log:
> net/netfilter/xt_socket.c: In function 'socket_mt_destroy':
> net/netfilter/xt_socket.c:224:17: error: implicit declaration of function 'nf_defrag_ipv6_disable'; did you mean 'nf_defrag_ipv4_disable'?

I'll go drop this one from everywhere as well, until it gets
straightened out upstream.

thanks,

greg k-h
