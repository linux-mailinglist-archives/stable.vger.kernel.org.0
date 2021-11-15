Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CC244FEE3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 07:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhKOG67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 01:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhKOG65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 01:58:57 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A36C061746
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 22:56:02 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x15so67313704edv.1
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 22:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DnhRi/yEd8/77prJmECQX07Ui1HU8yjd7OJqe5An4dY=;
        b=t9Se2sEFkosEsGaNqN9T9TCcZk0wJQhitNRtoH2HD7Q2i2sVGG1qJ3I3iazk8G1Zhx
         DzzlyqGN/XFf0VbvwUIZ8tQVqAvpQjouQUkr2GU+QBikDZMFlGq9s2QzIBuEos8B/HqW
         EFe9W+COyW+NeY2MoRs9g8EOuHeVF1/8XylW/KfsqFMGmGzUkuTFrdPg9AV1k2eIyVfb
         OimAFbLeYeBb61FeElkDPneXjoWJhwx1tqGrhE7zBN0C1kvJiuzZELex0qiYQfhJgD6F
         2MDLkJY7YLD5bffE4C5GkyEiDhaUGqp5Z6pAs7awOEro/Odbc7Jh6Mu9QkAykwWCICvg
         6znA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DnhRi/yEd8/77prJmECQX07Ui1HU8yjd7OJqe5An4dY=;
        b=FBO4K1X8tFKj60/nZ3ys99oOHqnL4IXJ+i6s/ODG3CU0jJ+Me4BbOFPLBfDCAHk/+s
         kEayXt5a3kR1/qCwP0R0h7TePMfsYlFz84EVggXnKWubiwmCGMJVUDgz5jw06zr6u0tX
         Yi/lI0diDuJV34LS62dE5vtDCL7kA27bt3OuWxi9n3xLHovLvpHeX6+Q0KY0YlNjZ6DS
         TDD3aG17xCgmcI7H3AkGJFFfDgh9Q5MaQwH6pTToHfhc4BVrNbBHc3+R+vRKF6m1x2UP
         S57RL4IntbI1BJttHsp68ztQNGcgOcAWciondV348YwP7U58JMVIbFX70IwnALFgHA2F
         nXNQ==
X-Gm-Message-State: AOAM531K/fsKZD9ec/Cg5yEeBgWHGue6qmIyF3tY5e2F1HtMsxqbopey
        Q01T/xoPU6zU4bk5xWrw/5MnnLOsFe8E/RLzoccbFg==
X-Google-Smtp-Source: ABdhPJxlHl1kfno22u1uQK+1W5VimX8ZWFmx5vC5rSL362dcc7YkX1nxubWNXAqFsM73XZh/gTsf7e19SMdHhJVT6EU=
X-Received: by 2002:a05:6402:26c2:: with SMTP id x2mr52235690edd.198.1636959361036;
 Sun, 14 Nov 2021 22:56:01 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 15 Nov 2021 12:25:50 +0530
Message-ID: <CA+G9fYsZ_Zks32WTNgKjQg2gwRuqS4E92ttH+okUCdnPFdaNTQ@mail.gmail.com>
Subject: [stable-rc queue/5/15 ]: rk3568-evb1-v10.dts:10:10: fatal error:
 rk3568.dtsi: No such file or directory
To:     Peter Geis <pgwipeout@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following build warnings/ errors noticed on Linux stable-rc queue/5.15 branch.
with gcc-11 for arm64 architecture.

arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi:464.3-52: Warning
(pci_device_reg): /pcie@f8000000/pcie@0,0:reg: PCI reg address is not
configuration space
arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts:10:10: fatal error:
rk3568.dtsi: No such file or directory
   10 | #include rk3568.dtsi
      |          ^~~~~~~~~~~~~
compilation terminated.
make[3]: *** [scripts/Makefile.lib:358:
arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dtb] Error 1

The first bad commit:
--------
arm64: dts: rockchip: move rk3568 dtsi to rk356x dtsi
[ Upstream commit 4e50d2173b67115a5574f4f4ce64ec9c5d9c136e ]

In preparation for separating the rk3568 and rk3566 device trees, move
the base rk3568 dtsi to rk356x dtsi.
This will allow us to strip out the rk3568 specific nodes.

Signed-off-by: Peter Geis <pgwipeout@gmail.com>
Link: https://lore.kernel.org/r/20210710151034.32857-2-pgwipeout@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org



Build config:
https://builds.tuxbuild.com/20wHY13986hVAE9j4Kwxq4C8JUX/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

meta data:
-----------
    git_describe: v5.15.2-851-g750602323c68
    git_ref:
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
    git_sha: 750602323c68ab51f3b65c59efc4289a7e7c60f9
    git_short_log: 750602323c68 (\thermal: int340x: fix build on
32-bit targets\)
    kernel_version: 5.15.2
    target_arch: arm64
    toolchain: gcc-11
    kconfig: [
        defconfig,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft-crypto.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/distro-overrides.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/systemd.config,
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/virtio.config,
        CONFIG_ARM64_MODULE_PLTS=y,
        CONFIG_SYN_COOKIES=y
    ],

steps to reproduce:
tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig defconfig \
 --kconfig-add https://builds.tuxbuild.com/20wHY13986hVAE9j4Kwxq4C8JUX/config

https://builds.tuxbuild.com/20wHY13986hVAE9j4Kwxq4C8JUX/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org
