Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C8861018E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 21:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbiJ0T0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 15:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiJ0T0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 15:26:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AC274CEB;
        Thu, 27 Oct 2022 12:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D25FB827B5;
        Thu, 27 Oct 2022 19:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D140C433C1;
        Thu, 27 Oct 2022 19:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666898757;
        bh=zr7b8qZ4gtlQNUFQgECsHuudY99YZOoZyFtKqPxs0G4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vdadE0bklm5emAhzN7N9Odapw9HDCeGEKILUnJ8eRnUqynNzqLBq05dF3mK8yiUJd
         c5c6ufSJPLFB/ghtk30VbasQYntQgJ7UUyXn5QsV9WqyPXsKSNtw+2YDv6WEtZGBbj
         HhN/AuGLZtlr0LyNn3cYHRzD4qk3qW+21tGIzywM=
Date:   Thu, 27 Oct 2022 21:25:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
Message-ID: <Y1rbQqkdeliRrQPF@kroah.com>
References: <20221027165054.270676357@linuxfoundation.org>
 <8617f970-2a72-799b-530d-3a5bb07822a6@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8617f970-2a72-799b-530d-3a5bb07822a6@roeck-us.net>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 11:10:18AM -0700, Guenter Roeck wrote:
> On 10/27/22 09:55, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.151 release.
> > There are 79 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> /bin/sh: scripts/pahole-flags.sh: Permission denied
> 
> Indeed:
> 
> $ ls -l scripts/pahole-flags.sh
> -rw-rw-r-- 1 groeck groeck 530 Oct 27 11:08 scripts/pahole-flags.sh
> 
> Compared to upstream:
> 
> -rwxrwxr-x 1 groeck groeck 585 Oct 20 11:31 scripts/pahole-flags.sh

Yeah, this is going to be an odd one.  I have to do this by hand as
quilt and git quilt-import doesn't like setting the mode bit.

I wonder if I should just make a single-commit release with this file in
it, set to the proper permission, to get past this hurdle.  I'll think
about it in the morning...

thanks,

greg k-h
