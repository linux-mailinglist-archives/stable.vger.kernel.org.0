Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E727757EFF9
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 17:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbiGWPIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 11:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237394AbiGWPIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 11:08:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E591A814;
        Sat, 23 Jul 2022 08:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FBC260B7B;
        Sat, 23 Jul 2022 15:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76267C341D7;
        Sat, 23 Jul 2022 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658588909;
        bh=JKFXmQp5waJvFePZ5Eo1ghy1swS0GuRdJRrA5CrHhB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gMnH8+cYonPoPu/Bj4xhVhPDtAJoQgfLu438n8dLWQ/V7Ma37f80AUOMkf9mYiceL
         sXoluEwd7HymFvaW5Ts4ZJctCgW0yWqZ1EmC7ne02X86HJGkr7YIOKV1baHWPypGVu
         9k2EYNp1g4jKBL8UYrtDARYEYquVdSCKBgHjGwfo=
Date:   Sat, 23 Jul 2022 17:08:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [linux-stable-rc:linux-5.10.y 644/7104] synclink.c:undefined
 reference to `free_dma'
Message-ID: <YtwO6yaYaf5Eu1Md@kroah.com>
References: <202207220652.CGm6UUjK-lkp@intel.com>
 <CAK8P3a0vZrXxNp3YhrxFjFunHgxSZBKD9Y4darSODgeFAukCeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0vZrXxNp3YhrxFjFunHgxSZBKD9Y4darSODgeFAukCeQ@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 22, 2022 at 02:58:32PM +0200, Arnd Bergmann wrote:
> Hi Greg,
> 
> I looked at this report for 5.10.y:
> 
> On Fri, Jul 22, 2022 at 12:20 AM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi Arnd,
> >
> > FYI, the error/warning still remains.
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > head:   7748091a31277b35d55bffa6fecda439d8526366
> > commit: 87ae522e467e17a13b796e2cb595f9c3943e4d5e [644/7104] m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch
> > config: m68k-randconfig-r011-20220721 (https://download.01.org/0day-ci/archive/20220722/202207220652.CGm6UUjK-lkp@intel.com/config)
> > compiler: m68k-linux-gcc (GCC) 12.1.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=87ae522e467e17a13b796e2cb595f9c3943e4d5e
> >         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >         git fetch --no-tags linux-stable-rc linux-5.10.y
> >         git checkout 87ae522e467e17a13b796e2cb595f9c3943e4d5e
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash
> >
> > If you fix the issue, kindly add following tag where applicable
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >    m68k-linux-ld: section .rodata VMA [0000000000002000,00000000005fa837] overlaps section .text VMA [0000000000000400,0000000000ffa6bf]
> >    m68k-linux-ld: drivers/tty/synclink.o: in function `mgsl_release_resources':
> > >> synclink.c:(.text+0xd1a): undefined reference to `free_dma'
> 
> This can be addressed by either backporting f95a387cdeb3 ("m68k: coldfire: drop
> ISA_DMA_API support") or by reverting the 87ae522e467e ("m68knommu: only
> set CONFIG_ISA_DMA_API for ColdFire sub-arch"), which is not actually needed
> on 5.10.

I've now reverted it, thanks.

greg k-h
