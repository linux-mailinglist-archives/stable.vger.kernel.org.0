Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DD11A0523
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 05:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgDGDJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 23:09:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41661 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgDGDJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 23:09:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id m13so1038948pgd.8
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 20:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7DgoxfHW4d77+vYnvAApAlnM6fxS0LFWLU4z+TaNXvE=;
        b=mYaP3ngYwyhdadx1ZEnI+HkSFbHz7Nso2vN7k+lbhiqJ5tKudE5Vpz5uCxPbJpxsBL
         n2+o6OEc/F0DpVXZfis76Y5kQaTDVpH+Y+cMp5McO62l4GSdVve6P2QKT6NvTRKJYRij
         KFmFARvvrrhd3WhXBAJlGTnry8hurCbbP8Bx7gS4tiQNI73iVI4B1lgUoQ9T3jeOFiyG
         m+F9BmoostYTd3pRmKPtIdQc1KLG4klHDtmYUgiRYZzQTeOOEPlImTguyuNKpgh1mVy1
         iSs2JXErZqnJBWZolGGLHsv+U2SJ44ahrVP/Fz2/R9SA0WLofu69l5WSx5pYmrqFEw37
         qXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7DgoxfHW4d77+vYnvAApAlnM6fxS0LFWLU4z+TaNXvE=;
        b=fmWcB5/AtyV4LLEDT5iTtlA4AXZZeTjnD4U9hJsRfNDmzNf1GDzGTc2zNipy/MjR36
         s4kCHD8b7O+8mbmDuhvLswP8sAHEFTAN8BPqxYLkssyVjx3jTEdldKMtq4kiUlzeRUMU
         SIa4feB4lIjrUQBegqZTsapVTxbccapJj9+44jVhQdcdfTPbGddWN5H1zE1TP+gGBFJ0
         pR6hOb9aPBYyp08TIesZJM9R+f3qhS6dR3cCitu2BbQwz2Q7FNYBZQXkHgdQS8Y+cBiu
         hZ4a+VjMEDFszq+E3hQKUuU5y4wdLJ30DD+x2FHc/oaVdxgrscwyLWTSSK1JBDD9PYRg
         JHjg==
X-Gm-Message-State: AGi0PuZQUYTDmG0Td/amHsnos/Y2h9iArWTHk6mAipbk8vTdloNxdfIO
        u4L8gmgBvWFexjKZWMEBcNTE3r+aBGg=
X-Google-Smtp-Source: APiQypJccDXczClvuLuBhb3aOUNo9bYgFQnJlJtIN1uu/qPNlJ2ynFDhHruJYpYDpYyKX+BDcl6hGA==
X-Received: by 2002:a62:194c:: with SMTP id 73mr506381pfz.159.1586228939933;
        Mon, 06 Apr 2020 20:08:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11sm229117pjb.18.2020.04.06.20.08.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 20:08:59 -0700 (PDT)
Message-ID: <5e8beecb.1c69fb81.7f24a.14ae@mx.google.com>
Date:   Mon, 06 Apr 2020 20:08:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v3.16.82
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-3.16.y
Subject: stable-rc/linux-3.16.y boot: 71 boots: 64 failed,
 1 passed with 2 offline, 4 untried/unknown (v3.16.82)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.16.y boot: 71 boots: 64 failed, 1 passed with 2 offline, =
4 untried/unknown (v3.16.82)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.16.y/kernel/v3.16.82/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.16.=
y/kernel/v3.16.82/

Tree: stable-rc
Branch: linux-3.16.y
Git Describe: v3.16.82
Git Commit: 4f0eaca39dd14d3492f6bbdd02b9657a180e6c03
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 11 SoC families, 15 builds out of 187

Boot Failures Detected:

arm:
    imx_v6_v7_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx53-qsrb: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-wandboard: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-evm: 1 failed lab
            dm365evm,legacy: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    mvebu_v7_defconfig:
        gcc-8:
            armada-xp-openblocks-ax3-4: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs

    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            omap3-beagle: 1 failed lab
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 3 failed labs

    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            armada-xp-openblocks-ax3-4: 1 failed lab
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx53-qsrb: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-sabrelite: 2 failed labs
            imx6q-wandboard: 1 failed lab
            omap3-beagle: 1 failed lab
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 3 failed labs
            qemu_arm-virt-gicv2: 2 failed labs
            qemu_arm-virt-gicv3: 2 failed labs
            sun4i-a10-cubieboard: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            tegra124-jetson-tk1: 2 failed labs
            tegra30-beaver: 1 failed lab
            zynq-zc702: 1 failed lab

    bcm2835_defconfig:
        gcc-8:
            bcm2835-rpi-b: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 2 failed labs
            tegra30-beaver: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5800-peach-pi: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu_x86_64: 2 failed labs

arm64:
    defconfig:
        gcc-8:
            qemu_arm64-virt-gicv2: 2 failed labs
            qemu_arm64-virt-gicv3: 2 failed labs

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
