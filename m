Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8700B48F6AB
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 13:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiAOMP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 07:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiAOMP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 07:15:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2324BC061574;
        Sat, 15 Jan 2022 04:15:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB920B800E2;
        Sat, 15 Jan 2022 12:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C21C36AE7;
        Sat, 15 Jan 2022 12:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642248953;
        bh=9D/1M0IN1K+yyBos/JhJyJTQtXFpKOg8pwstNDaj7MQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LkX9l+X/v6NGFFe7MdVZeUqytfLgXax6JmT1Tg6QgUK5wWhhxXdJFuG2Gknhvfj2d
         ich1dF5EddYOadwK0Kk/vfV6peYyQLZkNJ5JgEFGkdI7YTO3yLio1fFtF7sSvIkmBC
         IQgjqfrUKa+AKMpTUQAxtOYqntlQuvO7kSa9K+D4=
Date:   Sat, 15 Jan 2022 13:15:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ron Economos <re@w6rz.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/41] 5.15.15-rc1 review
Message-ID: <YeK69MTpuiz0wqrU@kroah.com>
References: <20220114081545.158363487@linuxfoundation.org>
 <b94bd7bd-0c8b-1697-f4af-27e99ca9e62f@w6rz.net>
 <YeKCeIOd8v7vOpdE@kroah.com>
 <6aa09e6a-9537-72d0-caf0-347038fe37b5@w6rz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6aa09e6a-9537-72d0-caf0-347038fe37b5@w6rz.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 15, 2022 at 03:52:34AM -0800, Ron Economos wrote:
> On 1/15/22 12:14 AM, Greg Kroah-Hartman wrote:
> > On Fri, Jan 14, 2022 at 11:59:57AM -0800, Ron Economos wrote:
> > > On 1/14/22 12:16 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.15.15 release.
> > > > There are 41 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.15-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > Built and booted successfully on RISC-V RV64 (HiFive Unmatched).
> > > 
> > > Warnings:
> > > 
> > > fs/jffs2/xattr.c: In function 'jffs2_build_xattr_subsystem':
> > > fs/jffs2/xattr.c:887:1: warning: the frame size of 1104 bytes is larger than
> > > 1024 bytes [-Wframe-larger-than=]
> > >    887 | }
> > >        | ^
> > > lib/crypto/curve25519-hacl64.c: In function 'ladder_cmult.constprop':
> > > lib/crypto/curve25519-hacl64.c:601:1: warning: the frame size of 1040 bytes
> > > is larger than 1024 bytes [-Wframe-larger-than=]
> > >    601 | }
> > >        | ^
> > > drivers/net/wireguard/allowedips.c: In function 'root_remove_peer_lists':
> > > drivers/net/wireguard/allowedips.c:77:1: warning: the frame size of 1040
> > > bytes is larger than 1024 bytes [-Wframe-larger-than=]
> > >     77 | }
> > >        | ^
> > > drivers/net/wireguard/allowedips.c: In function 'root_free_rcu':
> > > drivers/net/wireguard/allowedips.c:64:1: warning: the frame size of 1040
> > > bytes is larger than 1024 bytes [-Wframe-larger-than=]
> > >     64 | }
> > >        | ^
> > > drivers/vhost/scsi.c: In function 'vhost_scsi_flush':
> > > drivers/vhost/scsi.c:1444:1: warning: the frame size of 1040 bytes is larger
> > > than 1024 bytes [-Wframe-larger-than=]
> > >   1444 | }
> > >        | ^
> > Are these new warnings with this release, or old ones?
> > 
> > thanks,
> > 
> > greg k-h
> 
> They are old ones.

Ok, that's good.  Are they fixed in 5.16?  Anyone planning on fixing
them given that -Werror is now allowed to be set?

thanks,

greg k-h
