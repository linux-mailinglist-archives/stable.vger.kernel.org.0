Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1818A1E736A
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 05:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390215AbgE2DFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 23:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389639AbgE2DFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 23:05:18 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9486C08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 20:05:17 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p30so635487pgl.11
        for <stable@vger.kernel.org>; Thu, 28 May 2020 20:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3XkDn7k1tixvPMzOH3abfUZpZgBSSDZI8fICBpfB2D0=;
        b=gLoESED8YiXskh4NBcMIhndZq/CqAK/C4zQemilS3wRmRX3ZL12/iP86sYExKP3eFc
         8rOqjKAB1GsF86QW9pAo1v2qmeMJlKo/u32wn9Ot3Z48NJ8IhTuK+1NJGAjcokcMzmJ5
         3wSbP9WAs6R+khZOsqFp8rF/splqsREWJmPka2pC2mvfbDCt15/annULjJM5QJf/jG63
         V8VVZ82xhNQW0tZ75KdGLBO2v2obk95yefd9ntRN43phtcKZF9F4zU53A8v8XN5N2c9R
         YTrO8tERUkCFgfkdSLZGtjB9UrFe0oXZboJO4TMIMuOS5f6CY8mcNBmVkxUWpnqS4du1
         n2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3XkDn7k1tixvPMzOH3abfUZpZgBSSDZI8fICBpfB2D0=;
        b=k73KsgnGAKdPHRlxPZfEiKVor339OMuBt66abFct3szlIBe3sHVtNGmLRFfmlSd0mM
         oFCHRpGSf6HfKm+I454ANQXqw/z3XYyIqR0OBPOJXCyEaRJfuvzRKiGWRBgR1QSFouom
         E11AGGeExie6sxKOFT6NT96wHJ3/tkaBSH9KQe81iXlnacBB7xBl3nTS+JXNBj0X6TnL
         Y81MUKKKk5QcZz4j7FAKTMOdPXnyrSb++t+LI1KlQmI8aQQp9wcBvJw2o/ycdm4AJ3ag
         7HzBuEow+VLHVN7euR8DFdxV+3DhpH4smuFrCFdbsYVJys0Gd2SFnBuC6axgjy7N5f4a
         TnBg==
X-Gm-Message-State: AOAM532KekQV7tBmKmaem85jwfsVbnzlLspMcd2f4XQufISR9poxLICn
        LmYAC70qYSp8/sSHoL20u4nKbPv8IRc=
X-Google-Smtp-Source: ABdhPJxaHf7m5xZ3hBa2guuzS20DMGqlhHHgyrLH8VOPFFKwItYAoNS2A1isiIshV1V3yZ3yNFQmoQ==
X-Received: by 2002:a63:30c2:: with SMTP id w185mr5893380pgw.353.1590721516719;
        Thu, 28 May 2020 20:05:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s36sm5508555pgl.35.2020.05.28.20.05.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 20:05:16 -0700 (PDT)
Message-ID: <5ed07bec.1c69fb81.31729.15bc@mx.google.com>
Date:   Thu, 28 May 2020 20:05:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.6.15
Subject: stable-rc/linux-5.6.y boot: 132 boots: 2 failed,
 120 passed with 7 offline, 3 untried/unknown (v5.6.15)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kernel/v5.6.15/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.6.y boot: 132 boots: 2 failed, 120 passed with 7 offline,=
 3 untried/unknown (v5.6.15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.15/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.15/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.15
Git Commit: 183673bef8533a3744ad27e32ca901de59e09307
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 88 unique boards, 23 SoC families, 19 builds out of 156

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.6.14-121-g8f40203f49=
15)

riscv:

    defconfig:
        gcc-8:
          sifive_fu540:
              lab-baylibre-seattle: new failure (last pass: v5.6.14-121-g8f=
40203f4915)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxm-nexbox-a1: 1 offline lab

riscv:

    defconfig:
        gcc-8
            sifive_fu540: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
