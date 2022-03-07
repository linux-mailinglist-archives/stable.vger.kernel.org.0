Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BC44D03ED
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 17:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240647AbiCGQVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 11:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239693AbiCGQVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 11:21:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E2589CD5;
        Mon,  7 Mar 2022 08:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67127B81628;
        Mon,  7 Mar 2022 16:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772CEC340E9;
        Mon,  7 Mar 2022 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646670049;
        bh=QQdou9mghXN2Rem2PuBoMaDpoGKx45EZ/NsKNrRqeto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ff2zrdg5SDpnxEm+X51iAUiwziqlDQjfngefbScA1lMPcd6WiT63UaYtpLdz21BcB
         hu+rRl73QP/k+zGIru24lgU4OlJPisqhKLrrCZ5Vn9YnPk/bjd14DTP9Vp0WRFLAfh
         /zXeAnyLpny5xbsmKQl2EvCGFK8oidAIb45/Tbyc=
Date:   Mon, 7 Mar 2022 17:20:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/262] 5.15.27-rc1 review
Message-ID: <YiYw3hV2r8DTa7fb@kroah.com>
References: <20220307091702.378509770@linuxfoundation.org>
 <24c54a05-bb80-a128-d0ba-a78c6d5d101c@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24c54a05-bb80-a128-d0ba-a78c6d5d101c@roeck-us.net>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 06:36:22AM -0800, Guenter Roeck wrote:
> On 3/7/22 01:15, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.27 release.
> > There are 262 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> > Anything received after that time might be too late.
> > 
> 
> In addition to other reported build errors:
> 
> Building mips:allmodconfig ... failed
> --------------
> Error log:
> drivers/net/hamradio/mkiss.c:35: error: "END" redefined

That is odd, I don't see any changes to that driver, nor any MIPS
changes that touch "END".

I don't even see "END" in the diff anywhere.

Any chance you can bisect?

I'll go push out -rc2 versions with everything else fixed up
(hopefully).

thanks,

greg k-h
