Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310251CE1DA
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 19:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbgEKRjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 13:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730215AbgEKRjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 13:39:22 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95020C061A0C
        for <stable@vger.kernel.org>; Mon, 11 May 2020 10:39:22 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u5so2273977pgn.5
        for <stable@vger.kernel.org>; Mon, 11 May 2020 10:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o8ikOR3Yrfcdajhq9Ltdlg3+3v1t4TX59qeN8PVErug=;
        b=lS8SOZCeVFvW3TA8eiNqLrU34vpGdOxeGJp0k1mZeP3AFZThcQLJ0KME/AGwa5nLAV
         uNBz/PoigXXZxvi01wxW/OTb78iqzVIKyeE34xYDQXleM9cM0SbOCXYz29YxxN6lAk+Y
         LSNtxXZM1k7t7VPWbXmipSDrRIwzLLFPsv9Ny0NcZLM1HicNw7FeMluQcw8WUbEg2hOG
         BxWdgGMt7f4TowNbk8Qe1uGLbNwr6ZjyKpJJcdRUlnkooTnoIsefZVoFGV0S8QHr30W/
         V3AIjqNS+DgEajLcLsEY0jwjANQcSNbLrC+SWXrsChrKeIEZoRTVvwEVyLquR63yiBwf
         /xWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o8ikOR3Yrfcdajhq9Ltdlg3+3v1t4TX59qeN8PVErug=;
        b=Wkm6itpWgxqF9fyQcLv/2BU5s18Rdwy7TV3LWL3z7HXdWXgZF9kkKwDE5YTo/W1gsD
         9kmASBR54JlEJw4+6oLuOB9mKwRtkyq+owHjghchNSnOp/Xw4vG9r/XM+dcE27bpQXXf
         8ZKrqWO8FbJbWlm9YDDp/p51YmxCZC9RztUZlopVbouNMrYn/8xt+BcTHZP6dYHQm8RP
         CmcwwU9b09peT0z9TFXHwC6B0SzckfYHujsfzPrr5suCl3n4JVWXb/os3YsZ6VZ/TnGu
         TcqTt6XcgTGoKCk2bAeeOk/BjNMCZdFAqjVTDHj4XNz2jPjVYk9Bvg+gHY7sEiB9QYF0
         Wj1A==
X-Gm-Message-State: AGi0PuYYNdspbD0BhDdQBESxwoti2P1nVD/7EuH1s3PvA4PZzkKnbfhl
        Dr3R8bD2iHRm/GHAeoSVw1lAJunbnD8=
X-Google-Smtp-Source: APiQypJ6DLvlJ750h5CyAgjFIOKIegoOtr7t1sw2eAXRm6xEYkM/oNMyk9Qw7BbhXDMQKl3RXsI2yg==
X-Received: by 2002:a63:2ec7:: with SMTP id u190mr13539572pgu.89.1589218761691;
        Mon, 11 May 2020 10:39:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm9697840pfd.139.2020.05.11.10.39.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 10:39:20 -0700 (PDT)
Message-ID: <5eb98dc8.1c69fb81.cbf2f.30ad@mx.google.com>
Date:   Mon, 11 May 2020 10:39:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.122
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 133 boots: 1 failed,
 113 passed with 13 offline, 5 untried/unknown, 1 conflict (v4.19.122)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 133 boots: 1 failed, 113 passed with 13 offlin=
e, 5 untried/unknown, 1 conflict (v4.19.122)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.122/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.122/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.122
Git Commit: 033c4ea49a4ba7a2b13aabf3ec755557924a9cda
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 21 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.19.121-33-g7=
ad26f947708)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.19.121-33-g7=
ad26f947708)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.19.121)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 59 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.121)

    tegra_defconfig:
        gcc-8:
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.19.121-33-g7=
ad26f947708)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.121-33-g7ad26f94=
7708)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.19.121-33-g7ad26f947=
708)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            omap3-beagle: 1 offline lab
            stih410-b2120: 1 offline lab
            tegra30-beaver: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
