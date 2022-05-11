Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B042C522BD3
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 07:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbiEKFlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 01:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241952AbiEKFlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 01:41:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8331815714;
        Tue, 10 May 2022 22:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FDE2616E2;
        Wed, 11 May 2022 05:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B4EC385DB;
        Wed, 11 May 2022 05:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652247659;
        bh=P+aYvgp7Upklf6ZVYjoCa+XwYgleSzcjiOjK6PSc6Bg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GmrF3I4lK1lgms2ATcSRQCZ52K/j689iod3SRVlIatCZpFDzvcLhbjvr6PnfrtMmp
         /OqI1VALYrJyA58bIkQnZEnQgIqnpec3yIdeSMwljo+gDcWXSiODY7Dr/Gbxy0TlYw
         nN2FZQcgLq8LXnDk6IQ5XhVk+uHT9CfENBXjaPP4=
Date:   Wed, 11 May 2022 07:40:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/88] 4.19.242-rc1 review
Message-ID: <YntMaNodADlwRtMH@kroah.com>
References: <20220510130733.735278074@linuxfoundation.org>
 <CADVatmOK41UB0dNQim7h5LwL3DaG4RWQ8zMge9WKn18c_jJa=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmOK41UB0dNQim7h5LwL3DaG4RWQ8zMge9WKn18c_jJa=w@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 09:34:21PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, May 10, 2022 at 2:18 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.242 release.
> > There are 88 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> > Anything received after that time might be too late.
> 
> Just some initial report for you,
> 
> I just moved to gcc-12 and many mips builds are failing with errors like:
> arch/mips/lantiq/prom.c: In function 'plat_mem_setup':
> arch/mips/lantiq/prom.c:82:30: error: comparison between two arrays
> [-Werror=array-compare]
>    82 |         else if (__dtb_start != __dtb_end)
> 
> It will need d422c6c0644b ("MIPS: Use address-of operator on section
> symbols")  for all branches upto v5.10-stable.

But gcc-11 still works, right?  We really haven't started adding the
needed changes for gcc-12 to all of the branches yet.

thanks,

greg k-h
