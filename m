Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEA540D4B8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 10:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbhIPIm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 04:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232063AbhIPIm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 04:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABD046120C;
        Thu, 16 Sep 2021 08:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631781668;
        bh=XDTb0BylEIqufttl2RdPXYrNEMHyAPhK26TPthkiSqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lVocjsG0r1pd860UdxiZs0HesceUdd6DPBzDIspzNfzluHc7rqnehyZDSqe/yDYDL
         awIQx+jI7NJd7c1f8qMMdRqT84ku2DfhdPT0HuOt6ItSXfY5vevr7XvTkK531+PcYt
         oUMZJQTtB6LDKiAWjcc/u/c+AVgbtGRv3yvWBnkg=
Date:   Thu, 16 Sep 2021 10:41:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Christoph Hellwig <hch@lst.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: ARM: 9109/1: oabi-compat: add epoll_pwait handler
Message-ID: <YUMDIUe7ykhvC1OA@kroah.com>
References: <CA+G9fYtcsy_jaGkssSSUb5qeQehLvPF9=TgEG9kn42NKez1mOQ@mail.gmail.com>
 <CAK8P3a19jGTStRnO+em7-7VRwEE-LBL0xY9uqY4+tqx+n04qeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a19jGTStRnO+em7-7VRwEE-LBL0xY9uqY4+tqx+n04qeQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 08:57:20AM +0200, Arnd Bergmann wrote:
> On Thu, Sep 16, 2021 at 8:40 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > Following build warnings/ errors noticed while building stable-rc 4.14...5.14
> > branches with gcc-8/9/10/11 for arm architecture with axm55xx_defconfig.
> >
> > # to reproduce this build locally:
> > tuxmake --runtime podman --target-arch arm --toolchain gcc-11
> > --kconfig axm55xx_defconfig
> 
> Thank you for the report!
> 
> This was introduced in my upstream commit b6e47f3c11c1 ("ARM: 9109/1:
> oabi-compat:
> add epoll_pwait handler") and fixed in the immediately following 249dbe74d3c4
> ("ARM: 9108/1: oabi-compat: rework epoll_wait/epoll_pwait emulation").
> 
> Only the first patch got backported to stable-rc, so it's broken
> there. If anyone
> thinks we want to keep the epoll_pwait emulation in stable, I can do a backport,
> but I would just drop that commit from all stable kernels.

Good idea, I'm going to drop it from all stable queues now.

thanks,

greg k-h
