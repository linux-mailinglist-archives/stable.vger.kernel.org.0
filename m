Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223401BD1D1
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 03:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgD2BnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 21:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgD2BnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 21:43:13 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB3AC03C1AC
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 18:43:12 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id v2so226521plp.9
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 18:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c306gKEj+sUnZrWrAaQmILCDoHByTCdq9f/Xrpt4wnk=;
        b=jHuEN7lqGaEdqBrYky79i0JVHki4oT16ay2/GBmryu+wgZ7K6BvVFptB4nBWR4qUSR
         +AOUpISo/5m9N7ZOFuTrq17UAQntkpaHarvza0smLaMQKZ+2VV17nzrr/4/DhdwkUILc
         v1vkPtpH43VDJZn96GNxCByWTGBVY/A2IpXC/ESrfz5Jqn5xlQgE/UKklAvb2URhi6GF
         dTO/zBMTCHh65hhO6MyMLn5y7L7hf/VTZLFm5SVjZhH1epsjcxkUJktGvYWhiDDE7AtI
         2ZP7p9INQGP1aoQ2n2Fhw1UYTD3nw9fGKF3fbFj3LQh5SxQzlaHoINbWReYuupgLWcPN
         Z3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c306gKEj+sUnZrWrAaQmILCDoHByTCdq9f/Xrpt4wnk=;
        b=Sek60UzrFN7tFO8B/AN0zT8znZo63bKL6e51GKGtcufXKWHM3plEZp2mkLABCDhYjZ
         prJz5Xg6a6FWXQ+sR62W/BAMWieYorESdF1BPgw6+pJE7GAAI0JyHMDQgGzaKOe4zckD
         zfyeoSR4FCmwWDGHwKLVWKrViroNNEMRbjQc1dLWm2/vPEp7RPlJQ8HSxIO7ZmVbnPqY
         cKSVKpjb6n6RgNSAvrOMlE+8YaPFy7MPmMyD/5tpjRg0YwV/kelBpQ53igwFiyFuIc29
         +PIHeb0MjkhlCxayMWhQ4AA2aBVJYSSpn5pDyFQtzRCnjTY711VvwUdMzwa5rALl9ege
         t7uQ==
X-Gm-Message-State: AGi0Pubnf3iqACnCItb5bHHtMOoZZL5E3uXu8B1BvqmO38Kv4+uKbcCj
        Kfs+j0umtkBKPCDwD1DhcIxRCZ+zKT4=
X-Google-Smtp-Source: APiQypKHuDzYSMRCQJinTmlFaUClacXrK4EjJWpBYx8QdfRRvLKpfzW4YfVGvEaf1glOylO/xV29uw==
X-Received: by 2002:a17:90a:de8d:: with SMTP id n13mr275095pjv.173.1588124591382;
        Tue, 28 Apr 2020 18:43:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o30sm9301229pgn.12.2020.04.28.18.43.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 18:43:10 -0700 (PDT)
Message-ID: <5ea8dbae.1c69fb81.db559.73d4@mx.google.com>
Date:   Tue, 28 Apr 2020 18:43:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-3.16.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v3.16.83
X-Kernelci-Report-Type: boot
Subject: stable/linux-3.16.y boot: 43 boots: 39 failed,
 0 passed with 4 untried/unknown (v3.16.83)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-3.16.y boot: 43 boots: 39 failed, 0 passed with 4 untried/unkn=
own (v3.16.83)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-3.=
16.y/kernel/v3.16.83/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-3.16.y/k=
ernel/v3.16.83/

Tree: stable
Branch: linux-3.16.y
Git Describe: v3.16.83
Git Commit: 92f17c867833bbfdaced034629afb8e30a19e882
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 18 unique boards, 6 SoC families, 10 builds out of 186

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu_x86_64: 2 failed labs

arm:
    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 2 failed labs

    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6q-sabrelite: 2 failed labs
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 2 failed labs
            qemu_arm-virt-gicv2: 2 failed labs
            qemu_arm-virt-gicv3: 2 failed labs
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun7i-a20-cubietruck: 1 failed lab
            tegra124-jetson-tk1: 2 failed labs

    imx_v6_v7_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab
            imx6dl-riotboard: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 2 failed labs

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun7i-a20-cubietruck: 1 failed lab

---
For more info write to <info@kernelci.org>
