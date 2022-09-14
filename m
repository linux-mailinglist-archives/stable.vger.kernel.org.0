Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF2F5B8AF5
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 16:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiINOsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 10:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiINOsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 10:48:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8033127B21;
        Wed, 14 Sep 2022 07:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EF9F6190F;
        Wed, 14 Sep 2022 14:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E5BC433C1;
        Wed, 14 Sep 2022 14:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663166925;
        bh=uG+AaPBxPtOjaUn3tEdoPZSA/SMlRErc0dXN6w/lBk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OEBP+Lyj0tCT+iwxhLGjDZnCD6dJSvUSptRQ3mAuWTSUzyM22ZpGsw/E4Gn+MywLb
         DP3Fupq4Qyu+DXihLQh1aSVAKaG4GVCOoEBrM3rz7s60/MuMopplgdg7DSE5SFFp1G
         Em087Yk/IIhlxuYVIwU5BzJmzaHXqsyX/rLvH9K8=
Date:   Wed, 14 Sep 2022 16:49:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Message-ID: <YyHp5d4kqkNbgP1d@kroah.com>
References: <20220913140410.043243217@linuxfoundation.org>
 <20220914142843.GA941669@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220914142843.GA941669@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 14, 2022 at 07:28:43AM -0700, Guenter Roeck wrote:
> On Tue, Sep 13, 2022 at 04:01:46PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.19.9 release.
> > There are 192 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> [ ... ]
> > Csókás Bence <csokas.bence@prolan.hu>
> >     net: fec: Use a spinlock to guard `fep->ptp_clk_on`
> > 
> 
> This commit is broken, will be reverted upstream, and should not be
> applied to any stable releases.

Already dropped from all queues, thanks.

greg k-h
