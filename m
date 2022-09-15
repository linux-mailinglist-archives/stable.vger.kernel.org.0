Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709E15B952A
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 09:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiIOHXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 03:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiIOHXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 03:23:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E795C8A7D8;
        Thu, 15 Sep 2022 00:23:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83F2E6212E;
        Thu, 15 Sep 2022 07:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DED6C433D7;
        Thu, 15 Sep 2022 07:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663226595;
        bh=0SnTifM38uuGpOzCk/4nJazCkvUROprkrsGQ8G+k6i0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B+EWzrT/8d47AlN/5m4fPay4wsX2D6k8r928y+sMAsJVpVQxpmnAwbE4xlQgWuIbJ
         gg110KX9BunAmR0MEZxNTauwVo6QVWrzBW3xUz2+oELvdhum/pJzFp+ITKmL/UHKzO
         vvIWOC8WY887llCPDuu+vkyKqnaCgsvPi6o8cY1Y=
Date:   Thu, 15 Sep 2022 09:23:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Message-ID: <YyLS/LYEqixRcV9V@kroah.com>
References: <20220913140410.043243217@linuxfoundation.org>
 <20220915000912.GA603793@roeck-us.net>
 <81314196-ccd5-069b-a6ea-db07b1d2a857@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81314196-ccd5-069b-a6ea-db07b1d2a857@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 14, 2022 at 07:24:42PM -0700, Florian Fainelli wrote:
> 
> 
> On 9/14/2022 5:09 PM, Guenter Roeck wrote:
> > On Tue, Sep 13, 2022 at 04:01:46PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.19.9 release.
> > > There are 192 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 150 pass: 150 fail: 0
> > Qemu test results:
> > 	total: 490 pass: 490 fail: 0
> > 
> > New runtime warning
> > 
> > BUG: sleeping function called from invalid context at drivers/clk/imx/clk-pllv3.c:68
> > 
> > thanks to:
> > 
> > > Csókás Bence <csokas.bence@prolan.hu>
> > >      net: fec: Use a spinlock to guard `fep->ptp_clk_on`
> > 
> > In the assumption that this patch will be dropped
> > 
> > Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> It is being reverted upstream:
> 
> https://lore.kernel.org/netdev/20220912070143.98153-1-francesco.dolcini@toradex.com/
> 
> So probably best to just drop that patch.

It is already dropped, thanks.

greg k-h
