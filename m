Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC2C65360A
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 19:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiLUSU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 13:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLUSUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 13:20:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE87BC4;
        Wed, 21 Dec 2022 10:20:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B959618A8;
        Wed, 21 Dec 2022 18:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E517EC433D2;
        Wed, 21 Dec 2022 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671646823;
        bh=EaL1FZjLFJ4p/Kw6JDysbkFcTcClZFXC8wsmE4QUj1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y0b/+0V0GXcWQHdrRu33PGYH0DmXMpXG6qg84EZ0JRauzqdfTqRtTNTcxbXu84JfZ
         C5fmHMEPmZPZiTiBZyBEZW+ExFvfc2vGtyswlbyFyoZvrg9FMDMhwI35hpRKOtTxM4
         HRMl1vc+5C6gujCacBy5T+06vipBA3t7u+wUTRjk=
Date:   Wed, 21 Dec 2022 19:20:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <Y6NOZEaDpod+9r/0@kroah.com>
References: <20221219182943.395169070@linuxfoundation.org>
 <20221220150049.GE3748047@roeck-us.net>
 <Y6HQfwEnw75iajYr@kroah.com>
 <20221220161135.GA1983195@roeck-us.net>
 <e3b06c93-1985-a958-871a-bfd73646c38a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3b06c93-1985-a958-871a-bfd73646c38a@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 07:34:04AM +0100, Jiri Slaby wrote:
> On 20. 12. 22, 17:11, Guenter Roeck wrote:
> > You probably didn't see any reports on mainline because I didn't report
> > the issue there yet. There are so many failures in mainline that it is
> > a bit difficult to keep up.
> 
> Just heads up, these are breakages in 6.1 known to me:
> 
> an io_uring 32bit test crashes the kernel:
> https://lore.kernel.org/all/c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com/
> 
> Fixed in io_uring tree.
> 
> 
> bind() of previously bound port no longer fails:
> https://lore.kernel.org/all/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
> 
> No fix available and revert close to impossible.
> 
> 
> 
> And most important, mremap() is broken in 6.1, so mostly everything fails in
> some random way:
> https://lore.kernel.org/all/20221216163227.24648-1-vbabka@suse.cz/T/#u
> 
> Fixed in -mm.
> 
> maybe it can help...

Thanks for the list, I'll keep an eye out for these...

greg k-h
