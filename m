Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84AA1BCB5C
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgD1S4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729143AbgD1S4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 14:56:43 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902B6C03C1AB
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 11:56:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id e6so1649802pjt.4
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 11:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wl43242k0gFtWpH0P0XBuqEDactuY98MDJxfPzjwJZQ=;
        b=lWfAkXIhJKG7BsRDtYVHHlhTUSf686YHemclLaqOVtY+c1uLPEjfEYpJ94eDeoBujL
         S6dMVogn6h2+Czlmy4ggZL+RELA7ASgEhwCBNumFC4u+tAu5neTuQjLjuL1TsOzEJKPP
         IyxNj1Gp2Wh6/l9V96E0Xvx/Hju6NLizFxcYAY59WoD5C4AZi8g95AYrpH5fgpapEdAd
         G6dWl9HAJvN7Sey+thtX7XaZ7vcBdVgOkvvEYUXC6M7kgo4EwdO+qleQx7MSMcRPtfgr
         GFGqnFcGBVJVdEMhOHo91er597Zuu6evSKr3dL0OkDENqtqlmqaDmAAJew8QXztvs4UK
         FNDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wl43242k0gFtWpH0P0XBuqEDactuY98MDJxfPzjwJZQ=;
        b=g7r1lRa2ivWwKjnp9mrtSzdthBxMG6U1H+T4T6GTfTztJgfoImt3ZzoWNjZEB+UIYw
         /qOunRcM8x6BSQX0seb8GtoXsngvvf79h9iw9B6W0J4IALRPufg2zAV7VEiUfc88a9jm
         WPvCgWkDI2M/eQDwiMjlg5uU007whTDxUFbqPep2U1fQXJeLpXVyrNnfdOBFTIex349C
         d5r415hN58L1GpFvnUQRnVXtNI0whs/TwsDVtWZkJdhv4ugbYtdwDNz5Gv51gyWFTeAm
         9hgrweBaxMEH6QTcEtHc+fC8ea2Zc8YBChoKsh9/X3YBdJ+gDCLltjarYGhv0Nc7W6ct
         bmcQ==
X-Gm-Message-State: AGi0PuYhEziTI80CJRgqAVd4dbXf3PXe9TC7RLZxeTjRR58mvIR4Oeu4
        Q4Dth1BJPkUJqQNqzBy7Mvezf4Hq5xQ=
X-Google-Smtp-Source: APiQypJTcPSpicKtw/bETT7ZlSPwVdPmdT92MAshgqKcTRBs2uZGsDpHquo9W0mJp1LSgJq2Lmmpdg==
X-Received: by 2002:a17:90a:7105:: with SMTP id h5mr6749366pjk.3.1588100202712;
        Tue, 28 Apr 2020 11:56:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w13sm15444118pfn.192.2020.04.28.11.56.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 11:56:42 -0700 (PDT)
Message-ID: <5ea87c6a.1c69fb81.4dfc3.ca26@mx.google.com>
Date:   Tue, 28 Apr 2020 11:56:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.7-167-g9a37d69c8170
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 170 boots: 3 failed,
 151 passed with 8 offline, 6 untried/unknown,
 2 conflicts (v5.6.7-167-g9a37d69c8170)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 170 boots: 3 failed, 151 passed with 8 offline,=
 6 untried/unknown, 2 conflicts (v5.6.7-167-g9a37d69c8170)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.7-167-g9a37d69c8170/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.7-167-g9a37d69c8170/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.7-167-g9a37d69c8170
Git Commit: 9a37d69c81701d74367031326c8651e11b8752cf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 105 unique boards, 26 SoC families, 21 builds out of 192

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.6.7-164-g86c=
fba65ced0)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.6.7-164-g86c=
fba65ced0)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.7-164-g86cfba65ce=
d0)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.7-164-g86c=
fba65ced0)
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.6.7-164-g86cfba65ced=
0)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
