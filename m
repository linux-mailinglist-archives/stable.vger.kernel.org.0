Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9C91AF94D
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 12:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgDSKTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 06:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725832AbgDSKTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 06:19:01 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFC0C061A0C
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 03:19:01 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h69so3549594pgc.8
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 03:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z298D7K4BMPBv0apQe4HNEd/PtoKbxkqAJj/KzmAakE=;
        b=gelVeoV9qvLyN6/3j4Mx8fgIbXECRz2yzbn9Q4Aw++Y6iRGWGqaU5VPkBJU/zsVK7q
         JwrdSmxkkQSGySoHJYyj6npXSP5uuYJorIrbymKJqq5PqbxprcXhQbe1KdIpBPNUySP7
         UPlsw7j5FQlhUtrqJIeZBp3bZkvxFmZVdKTytaNPFeVB0gdhEkogionYyMs1adnqlFcU
         QeO7mJBKRMibl8OMecZsx7kx5ilUEjGTBBXGSCohgY2ULQo1sfMije7cNQOgf8+8tcvb
         Og+v6ZQ56xhyxaZwo2NQzSlzy2kFBQ9dJpVb0kX8TFhh1xsqlM9tAhmZ/sUvEYJ3MT/p
         bC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z298D7K4BMPBv0apQe4HNEd/PtoKbxkqAJj/KzmAakE=;
        b=ATHzk5s96i1lZ1QcWCXVq97d+C2rJcdyzCunHygmMzrDGs/ZHgqJe3Lv8XoCGDjgvm
         bCwi/euclUOa5/3D6qXs8j+uDyB8r8Lsod8NOxfhLc0lt1WZXuJVvg4vocxa78M3Y9AV
         ZFAa4P8mmRLTwO64xJ5SqqeV2b7dNAe7WbFMzY+vUhMa7WAqONAJV4BL12KECYqFTlg8
         owfArvNxZV5hOyC5+tQ8FhY3pops/kD8V9lFDqYoA4l8H7WWC6ap2biapLFHqfSfXxmR
         ta2hqgAeYWCEIqWvNlHx7o7KJu1PV+kSmPfnQD1mCbOUJziyhYlgPC51oo3nRLqsbTAH
         0Btw==
X-Gm-Message-State: AGi0PuZNB+jlUznZySehzv1oidQK1scRjr7SFICUx1WjLkyaQeIr4tOy
        eHNYvSNjbIT9JHgMZKDW0Wc5tWHg3gw=
X-Google-Smtp-Source: APiQypKogVOQQGkFFWFr+OHGIgTFPEqGBmSCmkyhIwr8Qg/r620GjlK5hi105+VB2bGY6bW3G8nO2A==
X-Received: by 2002:a62:1b44:: with SMTP id b65mr10815647pfb.219.1587291540327;
        Sun, 19 Apr 2020 03:19:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e27sm24153069pfl.219.2020.04.19.03.18.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 03:18:59 -0700 (PDT)
Message-ID: <5e9c2593.1c69fb81.4370b.6880@mx.google.com>
Date:   Sun, 19 Apr 2020 03:18:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.33-48-g8661e77d45ae
Subject: stable-rc/linux-5.4.y boot: 170 boots: 1 failed,
 156 passed with 7 offline, 6 untried/unknown (v5.4.33-48-g8661e77d45ae)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 170 boots: 1 failed, 156 passed with 7 offline,=
 6 untried/unknown (v5.4.33-48-g8661e77d45ae)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.33-48-g8661e77d45ae/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.33-48-g8661e77d45ae/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.33-48-g8661e77d45ae
Git Commit: 8661e77d45aef660ae852f2af9db730a54d08123
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 104 unique boards, 26 SoC families, 22 builds out of 200

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 3 days (last pass: v5.4.3=
0-81-gf163418797b9 - first fail: v5.4.31-258-gd88fa8738f21)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 3 days (last pass: v5.4.3=
0-81-gf163418797b9 - first fail: v5.4.31-258-gd88fa8738f21)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 70 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 11 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.31-275-gcc=
ba204bf567)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

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

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
