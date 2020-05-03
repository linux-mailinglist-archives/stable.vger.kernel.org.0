Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA1B1C297C
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 05:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgECDMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 23:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726702AbgECDMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 23:12:43 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627D1C061A0C
        for <stable@vger.kernel.org>; Sat,  2 May 2020 20:12:43 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 18so3756309pfv.8
        for <stable@vger.kernel.org>; Sat, 02 May 2020 20:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gDs8wVMcuC1BMLGWa3uFnbnUZwkjs5rlKkm2cFADk9s=;
        b=t4GHCYgPX1PU3VvZfbtORmrI5nrwlA8wABsIi4dRZEf4uAMGz88l9zfaJEK6MhgVdS
         VLK40i/HQ1ru+g9erDt3T4vmdT1MsQV1/J8XTn6y068WAgTTaJTXIHOeb4e8MWFpoIHK
         QXzkrSOpEgdtL27ipyWmeuiDwKiyp+y8pnq3a6QdTjwlqynrXN367XM4X+RR/mDQqC9P
         gjDHFskBqQHNp0y9dDihUKynWiCj3a6pz0T8COz9SjOlenvl16hVaGEGN9xYSKwww53H
         hZjy9vpPd+7VQfKFbDHGte7Ss6fYQ81NodycreKK1AUQHAfSweNFV6ikVl/4Be9MYUtM
         kfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gDs8wVMcuC1BMLGWa3uFnbnUZwkjs5rlKkm2cFADk9s=;
        b=rHokNkcIbHEB91u+R1xs3LZmx/ZnsYaF5WIVCjCRCt1yz9D7AHVxavYbpni0mRZUM6
         ug6CFYTs/lLd5xY19D6asA0vYoywO0EoanD10vwdM1KBt+QRyq9qGwD4kFO9DB+qds3w
         rssEEXAMyjHt4z87LZJvEp/KL6umPDSESXWjCm+Fh+1RwE0304pV+fb0TF72EHu8lVWt
         syg01KskGqkVx/s0Mkb3bcz1eh31f2qcO2tuo00K7cWhHv62qiDmCIH625Wi21X/v6t4
         1AMj1IHZG4ZHI2acsdzkrSsu4J1aS5/PMN6ktWhc2ELwvqYxCu5mi+avYGa/DgsWiHSd
         ImLw==
X-Gm-Message-State: AGi0PuZa3qM3eM0FvHzs0n0pxBlI5RYfougiANBI8BGwOo9595sNXHAa
        i1xJjoDsdksF/sGQhWLutwe312PqgYg=
X-Google-Smtp-Source: APiQypIj5ow/77ts4QJeG9pkKoIzkdkJHCdX9AADInPCPaIcFdUfwC+DZqsqqbPwLp6e/mb+P0WoOQ==
X-Received: by 2002:a63:d610:: with SMTP id q16mr11083754pgg.370.1588475562452;
        Sat, 02 May 2020 20:12:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kb10sm3461615pjb.6.2020.05.02.20.12.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 20:12:41 -0700 (PDT)
Message-ID: <5eae36a9.1c69fb81.a392c.f2eb@mx.google.com>
Date:   Sat, 02 May 2020 20:12:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.221
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 72 boots: 4 failed,
 61 passed with 5 offline, 2 untried/unknown (v4.4.221)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 72 boots: 4 failed, 61 passed with 5 offline, 2=
 untried/unknown (v4.4.221)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.221/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.221/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.221
Git Commit: 54b0e1aed69edd904ba7e2e6516d37750c29beec
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 16 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.22=
0-71-gbe0a2ec77b53 - first fail: v4.4.220-71-gf63f49c39d51)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 84 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 37 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.4.220-71-gf63f49c39d=
51)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
