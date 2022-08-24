Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0E859F3D0
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 08:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiHXG4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 02:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235240AbiHXG4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 02:56:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD70985AA1;
        Tue, 23 Aug 2022 23:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55B7D61469;
        Wed, 24 Aug 2022 06:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BF1C433D7;
        Wed, 24 Aug 2022 06:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661324207;
        bh=9HYM15PC+hUyN57tjYe2yczfmjSrKdoZXbVKvSoMEdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mNrniA9zUeWThftZ6Df2bB49x1JDga7LczYqOVI/AwaYS50bJk+zibxQTmuEKqwiq
         qQpW74V1WYsoWBs2ChnCdKy3QUVZQZdj5W5uHTRCzbUlp1OumF95s0cArQ6BdIzuOJ
         mT3qVEpiRPaoUD1N8JFkY3fPOY/C2ioOlXNUxR4A=
Date:   Wed, 24 Aug 2022 08:56:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/365] 5.19.4-rc1 review
Message-ID: <YwXLrGTTlzfGaUOz@kroah.com>
References: <20220823080118.128342613@linuxfoundation.org>
 <20220823211620.GA2439282@roeck-us.net>
 <YwXAAtL8082my6dh@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwXAAtL8082my6dh@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 08:06:58AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 23, 2022 at 02:16:20PM -0700, Guenter Roeck wrote:
> > On Tue, Aug 23, 2022 at 09:58:21AM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.19.4 release.
> > > There are 365 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 150 pass: 149 fail: 1
> > Failed builds:
> > 	um:defconfig
> > Qemu test results:
> > 	total: 489 pass: 489 fail: 0
> > 
> > arch/um/kernel/um_arch.c:447:6: error: redefinition of 'apply_returns'
> > 
> > I don't see the point of commit 89164a58fdc9 ("um: Add missing
> > apply_returns()") because it results in two sets of apply_returns()
> > functions.
> 
> Odd, the commit lied :)
> 
> I'll go delete this from 5.19.y, 5.15.y, and 5.10.y and push out a new
> -rc2 for all of them.

Well, -rc3 for 5.10.y, you get the idea...
