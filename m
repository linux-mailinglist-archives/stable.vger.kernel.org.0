Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 355E1377D8
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 17:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbfFFP3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 11:29:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46267 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727559AbfFFP3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 11:29:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 06C7D21F3C;
        Thu,  6 Jun 2019 11:29:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 06 Jun 2019 11:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=KM3+rjgHE9zwmgIp4q8PuCvwkLo
        nNg1CMyx9clBhSkc=; b=oM9db89XrFgrY+/tumKGLVICuHCWNKzyOfX77t8RHNE
        o11g79468XinfSuzHjlGFCiwcrAzGjDcyaMQQty5/HntAPek4pszDTpK0sDUStI3
        wd1TwImS+MfB7hGSVll81mH8auge89dcFyBVs7ZK1+JEzoG6gs69l1gzhDm73oLz
        TGauKrI7C2MyynGydBubQWOHr1iKB8uLS66ledTN+qs0Mpu4DsIZNVSI1RuL2pjk
        8Jxn6G2FhSKcF/SSvNLBtuk/EtWt12rNE3JXTZrXBCfEMcwiGYHfru1LIK/lllgA
        Bvcx6ce5VyWgNSp8wPbcclmuGPB7Xp19mebOtondPkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KM3+rj
        gHE9zwmgIp4q8PuCvwkLonNg1CMyx9clBhSkc=; b=FxiDVYPUl2u4PyybhrtkRv
        drriKiL5QyZn90jo5XB9sV9BdJMXB/F2pKKw4pZ5pA4aJG9iMCYi9KQnWGW2X2Ri
        ESVLrCGoWgTt6lGFo6HUT5GzP1p1FtRhV/j09TtMgyzIl+Jyd3AEownEmuRLfddg
        oKbuuT8J4Rg0NpebaJHoZH2QKMDGUEm2Ufs6em904Z80kupFNQl75sNz1S9uPvuY
        w9f5dFMbi8pftT013ulsZHLXPhifPaYtKjgNiVFzysCUSvBLcQBSAywuU1rne90d
        FDW2ZJY86K1/frOaD/mNricv9NUEPPhYunOG4+ubS05zVhNxKLVVnS1w75OtH+Jw
        ==
X-ME-Sender: <xms:QDH5XPSAcVHyx36O8wu4K8bTk_y8Gj_3p2Gbse0_bzCKnbCGSicTyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeggedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:QDH5XI9y5-70iS4hv5APGNh-HIxcypogFglHTMld6JAlz96v85k8oQ>
    <xmx:QDH5XMJSlUb7D5F8xVQOc5HxfxBnKPoNrgDeq4-yryjwXodGreS3iA>
    <xmx:QDH5XMuutwxTpDNPLubFBIluOsa4GsVnwZZa1uFhWzNWX9FVcDdaSQ>
    <xmx:QDH5XO3quEb2AKrjeUYuW90MHuvhigTaQCJZB4vbVnPO5cAFcMYIEw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C62C380087;
        Thu,  6 Jun 2019 11:29:04 -0400 (EDT)
Date:   Thu, 6 Jun 2019 17:29:02 +0200
From:   Greg KH <greg@kroah.com>
To:     Rolf Eike Beer <eb@emlix.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: Linux 4.9.180 build fails =?utf-8?Q?wi?=
 =?utf-8?Q?th_gcc_9_and_'cleanup=5Fmodule'_specifies_less_restrictive_attr?=
 =?utf-8?Q?ibute_than_its_target_=E2=80=A6?=
Message-ID: <20190606152902.GC21921@kroah.com>
References: <259986242.BvXPX32bHu@devpool35>
 <20190606152746.GB21921@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606152746.GB21921@kroah.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 05:27:46PM +0200, Greg KH wrote:
> On Thu, Jun 06, 2019 at 03:16:03PM +0200, Rolf Eike Beer wrote:
> > I have at least these 2 instances:
> > 
> > 
> > In file included from /tmp/e2/build/linux-4.9.180/include/drm/drm_vma_manager.h:28,
> >                  from /tmp/e2/build/linux-4.9.180/include/drm/drmP.h:78,
> >                  from /tmp/e2/build/linux-4.9.180/include/drm/drm_modeset_helper.h:26,
> >                  from /tmp/e2/build/linux-4.9.180/include/drm/drm_atomic_helper.h:33,
> >                  from /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:24:
> > /tmp/e2/build/linux-4.9.180/include/linux/module.h:138:7: error: 'cleanup_module' specifies less restrictive attribute than its target 'tilcdc_drm_fini': 'cold' [-Werror=missing-attributes]
> >   138 |  void cleanup_module(void) __attribute__((alias(#exitfn)));
> >       |       ^~~~~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:757:1: note: in expansion of macro 'module_exit'
> >   757 | module_exit(tilcdc_drm_fini);
> >       | ^~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:748:20: note: 'cleanup_module' target declared here
> >   748 | static void __exit tilcdc_drm_fini(void)
> >       |                    ^~~~~~~~~~~~~~~
> > In file included from /tmp/e2/build/linux-4.9.180/include/drm/drm_vma_manager.h:28,
> >                  from /tmp/e2/build/linux-4.9.180/include/drm/drmP.h:78,
> >                  from /tmp/e2/build/linux-4.9.180/include/drm/drm_modeset_helper.h:26,
> >                  from /tmp/e2/build/linux-4.9.180/include/drm/drm_atomic_helper.h:33,
> >                  from /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:24:
> > /tmp/e2/build/linux-4.9.180/include/linux/module.h:132:6: error: 'init_module' specifies less restrictive attribute than its target 'tilcdc_drm_init': 'cold' [-Werror=missing-attributes]
> >   132 |  int init_module(void) __attribute__((alias(#initfn)));
> >       |      ^~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:756:1: note: in expansion of macro 'module_init'
> >   756 | module_init(tilcdc_drm_init);
> >       | ^~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:740:19: note: 'init_module' target declared here
> >   740 | static int __init tilcdc_drm_init(void)
> >       |                   ^~~~~~~~~~~~~~~
> > 
> > 
> > 
> > In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:17:
> > /tmp/e2/build/linux-4.9.180/include/linux/module.h:138:7: error: 'cleanup_module' specifies less restrictive attribute than its target 'mpc52xx_lpbfifo_driver_exit': 'cold' [-Werror=missing-attributes]
> >   138 |  void cleanup_module(void) __attribute__((alias(#exitfn)));
> >       |       ^~~~~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/include/linux/device.h:1360:1: note: in expansion of macro 'module_exit'
> >  1360 | module_exit(__driver##_exit);
> >       | ^~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/include/linux/platform_device.h:228:2: note: in expansion of macro 'module_driver'
> >   228 |  module_driver(__platform_driver, platform_driver_register, \
> >       |  ^~~~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:1: note: in expansion of macro 'module_platform_driver'
> >   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
> >       | ^~~~~~~~~~~~~~~~~~~~~~
> > In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/io.h:27,
> >                  from /tmp/e2/build/linux-4.9.180/include/linux/io.h:25,
> >                  from /tmp/e2/build/linux-4.9.180/include/linux/irq.h:24,
> >                  from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/hardirq.h:5,
> >                  from /tmp/e2/build/linux-4.9.180/include/linux/hardirq.h:8,
> >                  from /tmp/e2/build/linux-4.9.180/include/linux/interrupt.h:12,
> >                  from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:12:
> > /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:24: note: 'cleanup_module' target declared here
> >   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
> >       |                        ^~~~~~~~~~~~~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/include/linux/device.h:1356:20: note: in definition of macro 'module_driver'
> >  1356 | static void __exit __driver##_exit(void) \
> >       |                    ^~~~~~~~
> > /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:1: note: in expansion of macro 'module_platform_driver'
> >   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
> >       | ^~~~~~~~~~~~~~~~~~~~~~
> > In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:17:
> > /tmp/e2/build/linux-4.9.180/include/linux/module.h:132:6: error: 'init_module' specifies less restrictive attribute than its target 'mpc52xx_lpbfifo_driver_init': 'cold' [-Werror=missing-attributes]
> >   132 |  int init_module(void) __attribute__((alias(#initfn)));
> >       |      ^~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/include/linux/device.h:1355:1: note: in expansion of macro 'module_init'
> >  1355 | module_init(__driver##_init); \
> >       | ^~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/include/linux/platform_device.h:228:2: note: in expansion of macro 'module_driver'
> >   228 |  module_driver(__platform_driver, platform_driver_register, \
> >       |  ^~~~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:1: note: in expansion of macro 'module_platform_driver'
> >   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
> >       | ^~~~~~~~~~~~~~~~~~~~~~
> > In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/io.h:27,
> >                  from /tmp/e2/build/linux-4.9.180/include/linux/io.h:25,
> >                  from /tmp/e2/build/linux-4.9.180/include/linux/irq.h:24,
> >                  from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/hardirq.h:5,
> >                  from /tmp/e2/build/linux-4.9.180/include/linux/hardirq.h:8,
> >                  from /tmp/e2/build/linux-4.9.180/include/linux/interrupt.h:12,
> >                  from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:12:
> > /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:24: note: 'init_module' target declared here
> >   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
> >       |                        ^~~~~~~~~~~~~~~~~~~~~~
> > /tmp/e2/build/linux-4.9.180/include/linux/device.h:1351:19: note: in definition of macro 'module_driver'
> >  1351 | static int __init __driver##_init(void) \
> >       |                   ^~~~~~~~
> > /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:1: note: in expansion of macro 'module_platform_driver'
> >   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
> >       | ^~~~~~~~~~~~~~~~~~~~~~
> > 
> > 
> > So this needs a6e60d84989fa0e91db7f236eda40453b0e44afa, which needs 
> > c0d9782f5b6d7157635ae2fd782a4b27d55a6013, which can't be applied cleanly 
> > because a3f8a30f3f0079c7edfc72e329eee8594fb3e3cb is missing in 4.9.
> > 
> > I have applied a6e60d84989fa0e91db7f236eda40453b0e44afa and modified it to 
> > directly use __attribute__((__copy__(initfn))) and (exitfn), which fixes the 
> > build for me.
> 
> I just added some patches for gcc9 to 4.14 and 4.19, are you really
> going to want to build it on 4.9?
> 
> If so, I can try to fix this up...

And if you want this, you should look at how the backports to 4.14.y
worked, they did not include a3f8a30f3f00 ("Compiler Attributes: use
feature checks instead of version checks"), as that gets really messy...

thanks,

greg k-h
