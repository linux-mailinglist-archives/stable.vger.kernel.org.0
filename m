Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEAC372532
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 06:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhEDEnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 00:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229715AbhEDEnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 00:43:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D13F161076;
        Tue,  4 May 2021 04:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620103380;
        bh=aDIexvMx+Nj3gvtxPKQXaCPTeb7I8Bm2MAOIhitUt9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cjngS0LSFvEWgtN/m9C/rNEggQ5zz5Xxs3aDUnotlGwbXZABfimhOMzFroKE39EdO
         V6OJRqevKtq/8ZwoS726gRtCI4fnYX2gEkHqZF9hUmx8J9efmNYYjM9XwT16uyQD5k
         yDO6Z0MJiCAOUvnkps4SfKGLLiiyfl8R3Cp9RvfA=
Date:   Tue, 4 May 2021 06:42:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable:linux-5.4.y 5541/6083] ERROR: "__memcat_p"
 [drivers/hwtracing/stm/stm_core.ko] undefined!
Message-ID: <YJDQ0ePGHxmcB7dX@kroah.com>
References: <202105030311.xWwkyV9z-lkp@intel.com>
 <CAK8P3a0ZdZY94KVwF-C_t+7rx=iHC60ty52AQAmc1VDZwsn9Rw@mail.gmail.com>
 <CAKwvOdmCmvHNpyjNtNU1OeSzK_E_9n9T4CPiFGD7K_JuJDOj-w@mail.gmail.com>
 <CAK8P3a3KLasm-CdcM3HCP6EZO1Vr0ay17jw7zSy0btqPr32WRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3KLasm-CdcM3HCP6EZO1Vr0ay17jw7zSy0btqPr32WRg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 09:16:42PM +0200, Arnd Bergmann wrote:
> On Mon, May 3, 2021 at 7:00 PM 'Nick Desaulniers' via Clang Built
> Linux <clang-built-linux@googlegroups.com> wrote:
> > > > >> ERROR: "__memcat_p" [drivers/hwtracing/stm/stm_core.ko] undefined!
> > >
> > > I'm fairly sure this is unrelated to my patch, but I don't see what
> > > happened here.
> >
> > It's unrelated to your patch. It was fixed in 5.7 by
> > 7273ad2b08f8ac9563579d16a3cf528857b26f49 and a few other dependencies
> > according to https://github.com/ClangBuiltLinux/linux/issues/515.
> >
> 
> Ah right, the big hammer.
> 
> Greg, not sure what we want to do here. Backporting
> 
> 7273ad2b08f8 ("kbuild: link lib-y objects to vmlinux forcibly when
> CONFIG_MODULES=y")
> 
> to v5.4 and earlier would be an easy workaround, but it has the potential
> of adding extra bloat to the kernel image since it links in all other
> library objects as well.

I've lost the thread here, but what _real_ problem is happening here
that doing the above is required?

thanks,

greg k-h
