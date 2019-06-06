Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A549377D4
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 17:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbfFFP1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 11:27:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47449 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728565AbfFFP1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 11:27:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D1AB220C9;
        Thu,  6 Jun 2019 11:27:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 06 Jun 2019 11:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=xYXa16oaIxYe9YeoyZG2PW5G95x
        +tUDhZwJ3LaMVdZU=; b=QxBi4qVwNfyPBfX7SYAwBMBXUBRSIDHODyOjpUsbsi9
        TB92ihsGC86WXd4iQbJKn7Y3G9MFs99FB65yqW6vho9E/EkaxQoio5d33REJWjDZ
        Rg/KrgFCzU4P23ibKsgpIRuSCbpYqio/jpsXrZH6LQN/a5eJNKPnliVnPvtq9668
        +3HD1XalprI5yGHLpQQqqDOLxHA9C5Jz/Itt7b58NBkFUr9ktUwj3211uhBETHtR
        f1oaNt5Z76AQs1FfT4cdRwA49qgZufY5EKz8tk5xRpIpzJbkp0LySz2BXglB4QIe
        ej3V9FDeiAQXmdBrAYkhTwLIV8phbi0tEd/Spt/5LwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xYXa16
        oaIxYe9YeoyZG2PW5G95x+tUDhZwJ3LaMVdZU=; b=Y7AV8mb33I7EHfAoYkhvCA
        OV9CvDvwxaJiD5Wd/idFXvO4D5AQhBBOjq0wu+L1KnQtZdZN1ZxtWLllYWCiVvuI
        ATh4SnuPbk67MPf3HXRKA48wKZa9Q+enFoNenQwlCZxC78dL77tluVFcD6TfK4zq
        ahCwQ5ZKgyGnK8gG/8ZAYdAJpfk9OzEf0q1iKLYLqxgVMh9Z0lJZRXR4qHsp4lyf
        18n1HHVmDoSqC51Ib8u0nmD08aSUWUKkBrQkYkncEEhnAytT9QlibLyc4uz0AEZv
        qoqyrHx6g3BUlojLPxAZzjoJTOLP6WwAJKHOX2059JRdjBVt5QZiPRA0+nQiIQjQ
        ==
X-ME-Sender: <xms:9TD5XPUB43vH2bvn5h--WOuFhGaTAjA0rFEAHPo2h-hj5z4h-R05Gw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeggedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:9TD5XE9cBovlGkXe7i-34_X3Lzy1Ff54Rhkd_v-9o6Xp3ZrY5g7_lQ>
    <xmx:9TD5XE5Y6kWUkleTFSbwHkBLjGMOBTAEoune6hg226YbrLp-1JQoEQ>
    <xmx:9TD5XFlvgOXNicmupwssAcFBK-J6JtyDkKF3AfHj_g3FOdCL4j_QZQ>
    <xmx:9TD5XDQH0G6pepUshmrsWQQBNzYe6kJ7tIWOZdoBI5PsJBtCxneqkA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9198F8005A;
        Thu,  6 Jun 2019 11:27:48 -0400 (EDT)
Date:   Thu, 6 Jun 2019 17:27:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Rolf Eike Beer <eb@emlix.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: Linux 4.9.180 build fails =?utf-8?Q?wi?=
 =?utf-8?Q?th_gcc_9_and_'cleanup=5Fmodule'_specifies_less_restrictive_attr?=
 =?utf-8?Q?ibute_than_its_target_=E2=80=A6?=
Message-ID: <20190606152746.GB21921@kroah.com>
References: <259986242.BvXPX32bHu@devpool35>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <259986242.BvXPX32bHu@devpool35>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 03:16:03PM +0200, Rolf Eike Beer wrote:
> I have at least these 2 instances:
> 
> 
> In file included from /tmp/e2/build/linux-4.9.180/include/drm/drm_vma_manager.h:28,
>                  from /tmp/e2/build/linux-4.9.180/include/drm/drmP.h:78,
>                  from /tmp/e2/build/linux-4.9.180/include/drm/drm_modeset_helper.h:26,
>                  from /tmp/e2/build/linux-4.9.180/include/drm/drm_atomic_helper.h:33,
>                  from /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:24:
> /tmp/e2/build/linux-4.9.180/include/linux/module.h:138:7: error: 'cleanup_module' specifies less restrictive attribute than its target 'tilcdc_drm_fini': 'cold' [-Werror=missing-attributes]
>   138 |  void cleanup_module(void) __attribute__((alias(#exitfn)));
>       |       ^~~~~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:757:1: note: in expansion of macro 'module_exit'
>   757 | module_exit(tilcdc_drm_fini);
>       | ^~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:748:20: note: 'cleanup_module' target declared here
>   748 | static void __exit tilcdc_drm_fini(void)
>       |                    ^~~~~~~~~~~~~~~
> In file included from /tmp/e2/build/linux-4.9.180/include/drm/drm_vma_manager.h:28,
>                  from /tmp/e2/build/linux-4.9.180/include/drm/drmP.h:78,
>                  from /tmp/e2/build/linux-4.9.180/include/drm/drm_modeset_helper.h:26,
>                  from /tmp/e2/build/linux-4.9.180/include/drm/drm_atomic_helper.h:33,
>                  from /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:24:
> /tmp/e2/build/linux-4.9.180/include/linux/module.h:132:6: error: 'init_module' specifies less restrictive attribute than its target 'tilcdc_drm_init': 'cold' [-Werror=missing-attributes]
>   132 |  int init_module(void) __attribute__((alias(#initfn)));
>       |      ^~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:756:1: note: in expansion of macro 'module_init'
>   756 | module_init(tilcdc_drm_init);
>       | ^~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/drivers/gpu/drm/tilcdc/tilcdc_drv.c:740:19: note: 'init_module' target declared here
>   740 | static int __init tilcdc_drm_init(void)
>       |                   ^~~~~~~~~~~~~~~
> 
> 
> 
> In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:17:
> /tmp/e2/build/linux-4.9.180/include/linux/module.h:138:7: error: 'cleanup_module' specifies less restrictive attribute than its target 'mpc52xx_lpbfifo_driver_exit': 'cold' [-Werror=missing-attributes]
>   138 |  void cleanup_module(void) __attribute__((alias(#exitfn)));
>       |       ^~~~~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/include/linux/device.h:1360:1: note: in expansion of macro 'module_exit'
>  1360 | module_exit(__driver##_exit);
>       | ^~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/include/linux/platform_device.h:228:2: note: in expansion of macro 'module_driver'
>   228 |  module_driver(__platform_driver, platform_driver_register, \
>       |  ^~~~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:1: note: in expansion of macro 'module_platform_driver'
>   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
>       | ^~~~~~~~~~~~~~~~~~~~~~
> In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/io.h:27,
>                  from /tmp/e2/build/linux-4.9.180/include/linux/io.h:25,
>                  from /tmp/e2/build/linux-4.9.180/include/linux/irq.h:24,
>                  from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/hardirq.h:5,
>                  from /tmp/e2/build/linux-4.9.180/include/linux/hardirq.h:8,
>                  from /tmp/e2/build/linux-4.9.180/include/linux/interrupt.h:12,
>                  from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:12:
> /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:24: note: 'cleanup_module' target declared here
>   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
>       |                        ^~~~~~~~~~~~~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/include/linux/device.h:1356:20: note: in definition of macro 'module_driver'
>  1356 | static void __exit __driver##_exit(void) \
>       |                    ^~~~~~~~
> /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:1: note: in expansion of macro 'module_platform_driver'
>   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
>       | ^~~~~~~~~~~~~~~~~~~~~~
> In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:17:
> /tmp/e2/build/linux-4.9.180/include/linux/module.h:132:6: error: 'init_module' specifies less restrictive attribute than its target 'mpc52xx_lpbfifo_driver_init': 'cold' [-Werror=missing-attributes]
>   132 |  int init_module(void) __attribute__((alias(#initfn)));
>       |      ^~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/include/linux/device.h:1355:1: note: in expansion of macro 'module_init'
>  1355 | module_init(__driver##_init); \
>       | ^~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/include/linux/platform_device.h:228:2: note: in expansion of macro 'module_driver'
>   228 |  module_driver(__platform_driver, platform_driver_register, \
>       |  ^~~~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:1: note: in expansion of macro 'module_platform_driver'
>   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
>       | ^~~~~~~~~~~~~~~~~~~~~~
> In file included from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/io.h:27,
>                  from /tmp/e2/build/linux-4.9.180/include/linux/io.h:25,
>                  from /tmp/e2/build/linux-4.9.180/include/linux/irq.h:24,
>                  from /tmp/e2/build/linux-4.9.180/arch/powerpc/include/asm/hardirq.h:5,
>                  from /tmp/e2/build/linux-4.9.180/include/linux/hardirq.h:8,
>                  from /tmp/e2/build/linux-4.9.180/include/linux/interrupt.h:12,
>                  from /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:12:
> /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:24: note: 'init_module' target declared here
>   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
>       |                        ^~~~~~~~~~~~~~~~~~~~~~
> /tmp/e2/build/linux-4.9.180/include/linux/device.h:1351:19: note: in definition of macro 'module_driver'
>  1351 | static int __init __driver##_init(void) \
>       |                   ^~~~~~~~
> /tmp/e2/build/linux-4.9.180/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c:581:1: note: in expansion of macro 'module_platform_driver'
>   581 | module_platform_driver(mpc52xx_lpbfifo_driver);
>       | ^~~~~~~~~~~~~~~~~~~~~~
> 
> 
> So this needs a6e60d84989fa0e91db7f236eda40453b0e44afa, which needs 
> c0d9782f5b6d7157635ae2fd782a4b27d55a6013, which can't be applied cleanly 
> because a3f8a30f3f0079c7edfc72e329eee8594fb3e3cb is missing in 4.9.
> 
> I have applied a6e60d84989fa0e91db7f236eda40453b0e44afa and modified it to 
> directly use __attribute__((__copy__(initfn))) and (exitfn), which fixes the 
> build for me.

I just added some patches for gcc9 to 4.14 and 4.19, are you really
going to want to build it on 4.9?

If so, I can try to fix this up...

thanks,

greg k-h
