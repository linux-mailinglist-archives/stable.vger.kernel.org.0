Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083E92262ED
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgGTPFS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Jul 2020 11:05:18 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:46451 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbgGTPFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 11:05:17 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MnJQq-1keGYJ1oSS-00jFmj for <stable@vger.kernel.org>; Mon, 20 Jul 2020
 17:05:15 +0200
Received: by mail-qk1-f175.google.com with SMTP id 11so6126263qkn.2
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 08:05:15 -0700 (PDT)
X-Gm-Message-State: AOAM530QmNP0oBdzBQu4rEGjU08IGIA3fmlvTdCXyDCTYPq9EYN5CUm1
        n8y87U43fU7mQreWwnvs3GG8IpUGmaiV16gz/N4=
X-Google-Smtp-Source: ABdhPJyBwDkm5UmI3FBfVvLPqaDiOmMOBwW+vDDIZIKp/1zCqSRF7c0HdeNRamtr4fFBE4zG1RW0DqQ52K2DV8aL0oc=
X-Received: by 2002:a37:9004:: with SMTP id s4mr13688280qkd.286.1595257514191;
 Mon, 20 Jul 2020 08:05:14 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuPe=XkrTx+yDo556D5t4wrFRFXctPPb2+7w+v-hAHvyw@mail.gmail.com>
In-Reply-To: <CA+G9fYuPe=XkrTx+yDo556D5t4wrFRFXctPPb2+7w+v-hAHvyw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 20 Jul 2020 17:04:57 +0200
X-Gmail-Original-Message-ID: <CAK8P3a24UWMoH9775FD3++Uwp1O-9gJkjoiq0M21RLZoe7TxbQ@mail.gmail.com>
Message-ID: <CAK8P3a24UWMoH9775FD3++Uwp1O-9gJkjoiq0M21RLZoe7TxbQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_stable=2Drc_5=2E4=3A_arm_build_failed=3A_arm=2Dinit=2Ec=3A327=3A?=
        =?UTF-8?Q?12=3A_error=3A_implicit_declaration_of_function_=E2=80=98get=5Fdev=5Ffrom=5F?=
        =?UTF-8?Q?fwnode=E2=80=99?=
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, saravanak@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:o4Kvubw7Yg0rdNy8E9HFC8DDDZXYJUqBS5zxs2a4p2y8xDpU2dD
 LZTdnxNeYmsu5AqMPxfemmwLWM4XwOcq/xvq0xCVOW5abhN5Qa/F5mU9qVQ2tIp4mTzSXuC
 mIsIfJuXMXHK9JeQephxU2kzcv+peRHyEvLE5KLOiETIG0W9eHxH6zS5z7AyjHKOPY6OF5x
 TYNbhIWmX8ZH2+Ypf5C9g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/QaDSn5v6ro=:Qf9qHGBf/YulW6cXkr8ZQX
 EGbc4ltJxYWJgHhi/azF1ObiV0uw+jtVy0jFR3MAEsJ9CyPixQb+257G0PDqAPUH63XqnCmO1
 W9zdN6CJCLrHHugy83BSEpcN+7kZKSV4AxIi1vHoMzbtRcCayCvYXn6FFIM0J7lacm4AyHJlu
 KoroFDflsZNWy7ezB23/Hk0FUFw/0xh6lmnnQwYhHefXwiu/DvzGIUR+AWVVagtSEeW4L6kgJ
 X25RuLoj06XAASLVJCkB8CPVvmeh53J7+9n2HN46SBJzbZQNDv7JiGQMORY79e2mii7b1SBgg
 jP0CtHKS+qtCpFPJEM/lDoU8SotKm2ZKHW7aif41QQWCrDoVkK12Uw55i1ACsuHJPlRzFAtaz
 dW4ro6fvu44G3R/i/+hmzYrsUAnT2+tyteiWhfnzNCOrcuxWiiIQDPYJVTm8VVKSsAZzMeCW4
 z34PP1Xn7pDAzXYZoT8pmk+/tvwJ2His/IajxaAHvh9ZepFEcePhnw1XsgaQfYalJPYrcJWvd
 +JQn+02rGaQc9c/oUNiJbTNFPFM3Djs8M06k/oZ6Xlv+A+idB8uPCaYAWbAbfa2Nmx2PzukYT
 PVwjD0XYlM9m+XwzVM1wibwoPUOxEAPUQKYPsHOCStzbdPyv1onerG0B+BFM8+yKAhpO5uy8R
 tjaOZYVSJK6Rw0OdGbcsjyCvNtlAOs/TPlfD/MbtbOkDA+l02ogVUvv29E0aeJU8XBvF1/K5t
 W4Un2+dNmApoaxQj1s3l6GeoRqke9u3Edom9oeSyDOPqN0VLenanQ3CGbudZLvl6dd1y2muYD
 9pNtcZVYwDUPcTZ0MOdSQzGNUlacG3X3xUTzAYRPoIDHLYeTndDMs45AbKFgAcajdS5mCYdG1
 9h8OnmE4k2SP24NsMvlAPIZGE9uZ/O61/B59bnHVnJLTBaLe5YtLnSH+FwilC7kILUK3o96ey
 6SUwFt0KZq87bLMhE+GNrH9xCvwFUrRfUBWAi6UtiNCJ3Rd2yzKxs
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 4:46 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> arm build failed on stable-rc 5.4 branch.
>
> make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j32 ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> arm-linux-gnueabihf-gcc" O=build zImage
> #
> ../drivers/firmware/efi/arm-init.c: In function ‘efifb_add_links’:
> ../drivers/firmware/efi/arm-init.c:327:12: error: implicit declaration
> of function ‘get_dev_from_fwnode’
> [-Werror=implicit-function-declaration]
>   327 |  sup_dev = get_dev_from_fwnode(&sup_np->fwnode);
>       |            ^~~~~~~~~~~~~~~~~~~
> ../drivers/firmware/efi/arm-init.c:327:10: warning: assignment to
> ‘struct device *’ from ‘int’ makes pointer from integer without a cast
> [-Wint-conversion]
>   327 |  sup_dev = get_dev_from_fwnode(&sup_np->fwnode);
>       |          ^
> ../drivers/firmware/efi/arm-init.c: At top level:
> ../drivers/firmware/efi/arm-init.c:352:3: error: ‘const struct
> fwnode_operations’ has no member named ‘add_links’
>   352 |  .add_links = efifb_add_links,
>       |   ^~~~~~~~~
> ../drivers/firmware/efi/arm-init.c:352:15: error: initialization of
> ‘struct fwnode_handle * (*)(struct fwnode_handle *)’ from incompatible
> pointer type ‘int (*)(const struct fwnode_handle *, struct device *)’
> [-Werror=incompatible-pointer-types]
>   352 |  .add_links = efifb_add_links,
>       |               ^~~~~~~~~~~~~~~
> ../drivers/firmware/efi/arm-init.c:352:15: note: (near initialization
> for ‘efifb_fwnode_ops.get’)
>
>
> seems like this is coming from the below patch
> --
> efi/arm: Defer probe of PCIe backed efifb on DT systems
> [ Upstream commit 64c8a0cd0a535891d5905c3a1651150f0f141439 ]
>
> The new of_devlink support breaks PCIe probing on ARM platforms booting
> via UEFI if the firmware exposes a EFI framebuffer that is backed by a
> PCI device. The reason is that the probing order gets reversed,
> resulting in a resource conflict on the framebuffer memory window when
> the PCIe probes last, causing it to give up entirely.
>
> Given that we rely on PCI quirks to deal with EFI framebuffers that get
> moved around in memory, we cannot simply drop the memory reservation, so
> instead, let's use the device link infrastructure to register this
> dependency, and force the probing to occur in the expected order.
>
> Co-developed-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Link: https://lore.kernel.org/r/20200113172245.27925-9-ardb@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>

It seems that the stable kernels need a backport of commit 372a67c0c5ef
("driver core: Add fwnode_to_dev() to look up device from fwnode") as well.

     Arnd
