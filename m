Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E0C6B5A01
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 10:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjCKJVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 04:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCKJVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 04:21:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0657714499;
        Sat, 11 Mar 2023 01:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A36AEB8250B;
        Sat, 11 Mar 2023 09:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976C1C433EF;
        Sat, 11 Mar 2023 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678526414;
        bh=BPD8iZ7NmgAO/P2+4l2QmGyukbYibkFfEbCkZWi187s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rn8/KpWPzfbmk/CVifvlyw0qIY1DNALK0sTxXLItfC5CMC+bnhkrteKdYqYWYHsbI
         aovsq2RWBy6jK80H+FjFzbqarLdfsPybfv+Dja0ZmeQwzB0zGvxeOmuh9z/cT+554v
         TJ/y63HuPu72ifvEsu/jJWzX+K3i0Ld7CbyuUllc=
Date:   Sat, 11 Mar 2023 10:20:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/193] 4.14.308-rc1 review
Message-ID: <ZAxHywhmpQhbMzfX@kroah.com>
References: <20230310133710.926811681@linuxfoundation.org>
 <fa9bb069-e298-4984-931d-40e151fab15e@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa9bb069-e298-4984-931d-40e151fab15e@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 01:03:46PM -0800, Guenter Roeck wrote:
> On Fri, Mar 10, 2023 at 02:36:22PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.308 release.
> > There are 193 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> > Anything received after that time might be too late.
> > 
> 
> s390:
> 
> arch/s390/net/bpf_jit_comp.c: In function 'bpf_jit_insn':
> arch/s390/net/bpf_jit_comp.c:1122:7: error: implicit declaration of function 'nospec_uses_trampoline'
> 
> arch/s390/net/bpf_jit_comp.c:1127:4: error: implicit declaration of function 'EMIT6_PCREL_RILC'

Thanks, I'll go drop the offending patch.

greg k-h
