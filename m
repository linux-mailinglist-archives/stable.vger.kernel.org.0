Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C23557E1C5
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 14:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiGVM6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 08:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiGVM6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 08:58:52 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67896167CC;
        Fri, 22 Jul 2022 05:58:51 -0700 (PDT)
Received: from mail-oi1-f179.google.com ([209.85.167.179]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MNtjq-1nqicT2rdY-00OCVl; Fri, 22 Jul 2022 14:58:49 +0200
Received: by mail-oi1-f179.google.com with SMTP id w188so1292623oiw.8;
        Fri, 22 Jul 2022 05:58:49 -0700 (PDT)
X-Gm-Message-State: AJIora9yIDxJvpjATVbEeKy58WGa+QmZVbGgwNK9klOtkOfY+VQ76LJv
        DAVyhRYqgsBXkqXjS0ppFh5SnLDwTnRusyMUVDw=
X-Google-Smtp-Source: AGRyM1vgw6SMBzhXYQK4zFqvbgayuF+UD0cn5QvmGtwr/W9iKKc0A57ydVQhGfGSxW4IOot10smtGip40ZPGAg9nWu8=
X-Received: by 2002:a05:6808:1b28:b0:33a:9495:d7b with SMTP id
 bx40-20020a0568081b2800b0033a94950d7bmr93476oib.155.1658494728333; Fri, 22
 Jul 2022 05:58:48 -0700 (PDT)
MIME-Version: 1.0
References: <202207220652.CGm6UUjK-lkp@intel.com>
In-Reply-To: <202207220652.CGm6UUjK-lkp@intel.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 22 Jul 2022 14:58:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0vZrXxNp3YhrxFjFunHgxSZBKD9Y4darSODgeFAukCeQ@mail.gmail.com>
Message-ID: <CAK8P3a0vZrXxNp3YhrxFjFunHgxSZBKD9Y4darSODgeFAukCeQ@mail.gmail.com>
Subject: Re: [linux-stable-rc:linux-5.10.y 644/7104] synclink.c:undefined
 reference to `free_dma'
To:     kernel test robot <lkp@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:q605q68iw4haOp75pTRK1QONrdL9dhffuO1kv/Htp6+/KNo8zpp
 hV8D7UCZR5lVpzIkJ3oIQ4Fh7EyiIZdMT16yDiQtmoZHhCIsP5ugZIsphIhk4NP4FQAxG4y
 JqLGrZFAm62VkQGHEghH/23Gn0I7rfvKL75DE5f3TtfDBSKkTh9d6KHLerqsxluhNdwmbFB
 KdRjH24Op3SU/307j62hg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qcEw5IcqaEA=:KeYX1A+x3Xo+b6NNDixIBD
 5/bTVuHUlezBy+pSZeierVUW8fmLqh0hXPAzJa2ZeJ9l23Lgy/WobI9mptIlgBd0pY368hzOm
 IPAGKYcBPgBuCHNSYnT+8RtarmOjF67DBHARm0uGbdjAeC33UtJXjEgzbf9jZjELN6YCZEgnP
 jA3BBxtMZArVdV3aRWHVaRKfZBEHWv04sKE814Ybnq+grydUnQmyxkLFsKsPS1XOWuS/xFNSP
 MRcX4ahXarcvbrTlo4hMVnAh/xysBq8DzaD+8YCZ28/2JDX4qd4OOwvjHiZtHZQ528w5mCEh9
 Xt4j6jX0tW/pKkM1wcyswfQW037x/Yi0N1+JyhzoYcOBXSFdo4It+8Ql7xMvR+lvSkLhz1OaD
 au808t32ryARVThMWZgMjlwHCbd7KhjP7EUFkh0M8N/Tuov6FtEVnHjSiEbu2Si7Gn5yRPkx+
 o484UVd37wCpNV+t6DWTMfEeD7IT+H3816ogkNCAWUb47qc4VF/1s6qSJjkB+Kgx1nTsLvmiL
 JNzY6ce97+kfdVxPcRkb3xmrvTjhlsJZYYmAk8oHsYYqAM6zO5vgSeRGanJ0oZ55HEcBZ98Y4
 zOGxfh8+bmEYF752cwQBPAoAZvMpwaFpqtriTL83EZhxj5yK0EVO3ftr8PRGi0QfdaIKCwDH8
 L/1lCWb8PiIjh79lVF2qKnbA4AQU16eEhQqvYPUskgpRswWrQuWDbJBpc5xFnGqYNVPW1zvCV
 uGtX+9H+RH6NmxsQtTOR1APELHUmf1VF68NoGROSWz0rDmYIaGqHVVRndOhGFin7+KNIy+MJi
 zGutbvtGAea7wzzzy4HJs0oQwBwjkM4fYSAlHJAVU6bEvEmQkhDkNW89JmTZUo6JyqaNzhZn8
 eh5Ll1defagq93/U3ovA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

I looked at this report for 5.10.y:

On Fri, Jul 22, 2022 at 12:20 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Arnd,
>
> FYI, the error/warning still remains.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> head:   7748091a31277b35d55bffa6fecda439d8526366
> commit: 87ae522e467e17a13b796e2cb595f9c3943e4d5e [644/7104] m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch
> config: m68k-randconfig-r011-20220721 (https://download.01.org/0day-ci/archive/20220722/202207220652.CGm6UUjK-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=87ae522e467e17a13b796e2cb595f9c3943e4d5e
>         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>         git fetch --no-tags linux-stable-rc linux-5.10.y
>         git checkout 87ae522e467e17a13b796e2cb595f9c3943e4d5e
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    m68k-linux-ld: section .rodata VMA [0000000000002000,00000000005fa837] overlaps section .text VMA [0000000000000400,0000000000ffa6bf]
>    m68k-linux-ld: drivers/tty/synclink.o: in function `mgsl_release_resources':
> >> synclink.c:(.text+0xd1a): undefined reference to `free_dma'

This can be addressed by either backporting f95a387cdeb3 ("m68k: coldfire: drop
ISA_DMA_API support") or by reverting the 87ae522e467e ("m68knommu: only
set CONFIG_ISA_DMA_API for ColdFire sub-arch"), which is not actually needed
on 5.10.

          Arnd
