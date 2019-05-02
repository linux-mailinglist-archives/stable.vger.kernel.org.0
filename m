Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BFB11EF7
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfEBPoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:44:54 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:56172 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbfEBP0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 11:26:18 -0400
Received: by mail-wm1-f54.google.com with SMTP id y2so3092952wmi.5
        for <stable@vger.kernel.org>; Thu, 02 May 2019 08:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VmjWDNKEbptsOicK4yZ4YouunUg7S6FsVTADCxX99c0=;
        b=YlOHxuZHXkudBO8BQ67k1BAMHzNqFh5KelEPXZ3CB4mpB+FmMSJddHKTvf7ODENzhX
         yAoG4w07y3glnzJUzDx/Srb0nE2vlynK/QGxewOsZ7glGF5JjfKyv+fUaBiqetWy2iHE
         FV3/m0pOXs4LKEy/NphLHzv9C9U1hM0eQSlkF5RUUhe/k6ZWfbqLGfvFKYghyi6SUEnU
         4VvVQanXdsZ5e7hT6dOBcBomDZNyFqMPvQ27/bw2ihT5XCF9H5ejW76SLS6/fTxNX7sI
         THXvsIbZShpc5n6sqkXK3zEjMErPYwPiH0pccZ5YBXiuHMS5lkPhlRI9Cc4ttbfDQ1Qo
         283g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VmjWDNKEbptsOicK4yZ4YouunUg7S6FsVTADCxX99c0=;
        b=EYsZj+6gO95gx8nhjPhmu5iFoooUiAzukk5qcRktH0Nnnq8iBYczEW4R6B60Advy48
         Mrss5aVlC0PF/fX6gkt/Hu5Ib3D4EeSUaMcpWyKqsCcQ31yKBwiW7h91PK2ClI2/VmcE
         kRlUDBFEcpH+sOxnABwnal9jSEsXZHpN5liW767tX5gbmK+wVQQ9utGNxIrl8koElSmY
         QVteUwNqlsVfRP1qh1gaywQwxoDwPyVOXfH1bfU6QA0oK0ss63Sed3THP3mtK9eiE5N4
         RUiCU8xXXqE2Z2JNlp/sudwKfzJ7uiHUw2xr98Xw2rBlo9+ABtI0HGXyAiujAcvkwVN0
         Li7Q==
X-Gm-Message-State: APjAAAWQHmuu2vqIHfuaZP+L2Pxoy9p21m+1bbXKK4MBhtINdOxSHn/N
        bIsF+ujTHZ/W/PEaAXjQVa4dqOrRHFP1uA==
X-Google-Smtp-Source: APXvYqxhoXNdBCZP3kbDZNYqKhrLZTME9sdO8FcvKmWLlN+haGek+NKUudLB+KzP5g89g3TpYawWWw==
X-Received: by 2002:a1c:1dd7:: with SMTP id d206mr2813010wmd.140.1556810776541;
        Thu, 02 May 2019 08:26:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q7sm19138428wra.57.2019.05.02.08.26.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 08:26:15 -0700 (PDT)
Message-ID: <5ccb0c17.1c69fb81.7925b.bc22@mx.google.com>
Date:   Thu, 02 May 2019 08:26:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.172
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 102 boots: 3 failed,
 96 passed with 1 offline, 2 conflicts (v4.9.172)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 102 boots: 3 failed, 96 passed with 1 offline, =
2 conflicts (v4.9.172)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.172/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.172/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.172
Git Commit: 5383785aaa49fc5f02adbd29fc01248895f477de
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          exynos5800-peach-pi:
              lab-baylibre-seattle: new failure (last pass: v4.9.171-42-ga7=
07069e56d0)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.9.171-42-ga7=
07069e56d0)
          tegra124-nyan-big:
              lab-collabora: failing since 64 days (last pass: v4.9.158 - f=
irst fail: v4.9.160-64-g0c0f9f653c9f)

    tegra_defconfig:
        gcc-7:
          tegra124-nyan-big:
              lab-collabora: failing since 64 days (last pass: v4.9.158 - f=
irst fail: v4.9.160-64-g0c0f9f653c9f)

arm64:

    defconfig:
        gcc-7:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.9.171-42-ga707069e56=
d0)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            qcom-apq8064-cm-qs600: 1 failed lab
            tegra124-nyan-big: 1 failed lab

    tegra_defconfig:
        gcc-7:
            tegra124-nyan-big: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        exynos5800-peach-pi:
            lab-baylibre-seattle: FAIL (gcc-7)
            lab-collabora: PASS (gcc-7)

arm64:
    defconfig:
        meson-gxbb-p200:
            lab-baylibre-seattle: PASS (gcc-7)
            lab-baylibre: FAIL (gcc-7)

---
For more info write to <info@kernelci.org>
