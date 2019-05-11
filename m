Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870FC1A80A
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 15:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfEKN7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 09:59:39 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:35521 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfEKN7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 May 2019 09:59:39 -0400
Received: by mail-wm1-f44.google.com with SMTP id q15so5863654wmj.0
        for <stable@vger.kernel.org>; Sat, 11 May 2019 06:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6d7VXRkZ2hKgbr/HMzO56/dC5vUefhGGUJcSv8WL1x4=;
        b=eg28veJzk1AjQ736vT5Ek3BX61kp3Au4mgOU3WWByNG7qhHZ34Yj9HnY/U4ItfOTso
         gFRYwpe/HDTDWHus2cupiOWtbb02uhO3yGt5+Uq/gLsimKxVmWrWqyjiivVjjau34YmO
         9PNhCo1vkxAHZtUKK4vnBy7uWL+uWJEsIMtyblt0BSF+gC7Cralj5BrV9koSW/CV5k7L
         2Plkqh6/MaCSyyOKWlBq6DmNq6KZR9pChgx8cnUlV6LFqa77hSYBuPpbPPRXt9BA/xZb
         1mdnXC8OdF7/+HPH/z9p9/ENW3iizcZpQJKlqQ9qlP/jeq+uJo+YgyAzWo2eAkHRSJw1
         cVAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6d7VXRkZ2hKgbr/HMzO56/dC5vUefhGGUJcSv8WL1x4=;
        b=NeCNlvB7ecejUVRomnMGNojg46AzY8lpCLAEVJCOUTxJwxLezcYEQzpMV9JX8in8Il
         DlpfMe94veR4F6keHeY3v+VtWzb6EZBoZnobbLlD/tv2hNjp1F+TpS5n1LJWKi6MWOCG
         yNBkvhzs3giyGOLB1uvfkWkfmC41OWVX1RkzUz36ghufj4QXY0/uxsPyUY43955xIi5X
         OztGXSlmCrdJoJ4AAmn/f5l1AqJFa3fnakq44wtjlPVNH1RB2FgMnK2ZyAG34rxir+7f
         JsRnSkywzR9Gm6UTuLu8SSfaEG07h8tmW8TuAq2g83wDz+zFX/swFw7jZFUhdV17H5Ua
         CcNg==
X-Gm-Message-State: APjAAAWZO2HEstklS7md1O24ZQFKmeFqVIFkRCEvsYBRbGdDdWiUHAUJ
        zYbCFBNDGVzpW2PW+5ZGY9oNGUpHyGm6Vg==
X-Google-Smtp-Source: APXvYqycCJAk9GJY2Y/VOK3aMIkUyLAdzegyjYAZdNnkWkRyJL6hAias+ZF2jUTIiURbThS+VTm65g==
X-Received: by 2002:a05:600c:24d2:: with SMTP id 18mr10841295wmu.117.1557583177373;
        Sat, 11 May 2019 06:59:37 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r64sm19862884wmr.0.2019.05.11.06.59.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 06:59:36 -0700 (PDT)
Message-ID: <5cd6d548.1c69fb81.68158.5c7c@mx.google.com>
Date:   Sat, 11 May 2019 06:59:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.175
Subject: stable-rc/linux-4.9.y boot: 112 boots: 0 failed,
 106 passed with 2 offline, 4 conflicts (v4.9.175)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 0 failed, 106 passed with 2 offline,=
 4 conflicts (v4.9.175)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.175/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.175/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.175
Git Commit: bb4f008d1e075986888ad01579c21f79b62f5775
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          meson8b-odroidc1:
              lab-baylibre: new failure (last pass: v4.9.174-29-g50bbfeb1e2=
a3)

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.9.174 - firs=
t fail: v4.9.174-29-g50bbfeb1e2a3)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: failing since 1 day (last pass: v4.9.174 - firs=
t fail: v4.9.174-29-g50bbfeb1e2a3)

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    multi_v7_defconfig:
        meson8b-odroidc1:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

arm64:
    defconfig:
        meson-gxbb-p200:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
