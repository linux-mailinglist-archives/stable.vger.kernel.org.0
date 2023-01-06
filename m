Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273C065FBA4
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 07:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjAFG6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 01:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAFG6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 01:58:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B0B5C92A;
        Thu,  5 Jan 2023 22:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A8361CE6;
        Fri,  6 Jan 2023 06:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B28AC433D2;
        Fri,  6 Jan 2023 06:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672988329;
        bh=el314kZ7VBsdxmxA7/FGLXa4ifdIwEn5Eeyvb0I5bRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hxAnJzheqjLmDSraLu9htVurlEHrLldoaSOOWWy4RR+Pve0W1+0F4ygFQKYI7wMnh
         1Nuq6VlnvP/NaUZ88Ttl2drHewkKA9K7jz6CqYDRtI+Id3rU41qqYYMIpvvxm+g9hE
         Fh1WE8i1zYoHDWa5WRuQi48UVEqddfsvNAERzXzU=
Date:   Fri, 6 Jan 2023 07:58:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <Y7fGpYyaJWym1BxW@kroah.com>
References: <20230104160511.905925875@linuxfoundation.org>
 <Y7cmMKUr//oYKWXb@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7cmMKUr//oYKWXb@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 08:34:08PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.1.4 release.
> > There are 207 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Thank you.
> 
> Is it known at this point if 6.1 will became next longterm release? It
> is not listed as such on https://www.kernel.org/category/releases.html
> . We might want to do some extra testing if it is.

A kernel can not become "long term" until it would have normally dropped
off of support.  Right now there are known-regressions in 6.1 still that
are not resolved.

And "extra" testing is always good no matter what kernel branch it is
happening for, why not always do it?

thanks,

greg k-h
