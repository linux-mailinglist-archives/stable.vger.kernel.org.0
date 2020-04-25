Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F691B8766
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 17:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgDYPdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 11:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726174AbgDYPdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 11:33:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE13C09B04B
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 08:33:01 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e6so5154333pjt.4
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 08:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=woIqWvRt9ynNe81BRaK2zcaCPrPDigVAmYRoQEBO3Eo=;
        b=A/XjjNw0YjY7ahniKwXlvEA3W9+8MDAIbZg5Gdl9MUlqSyYvjaVmOSXuCVtVLV3wIb
         z8kXyIplY/fAonujxGXJjt/cI1fYnc4vMkAo9xY7tlPpRpQpqCDzol+Xg6QgZ1KHAS+J
         K3Gvsuu+AwAXr2LLfHlJBOO7xKRc/auPmQczkjWkf8NoUS4FULy+qt+4N9KSF4BfOt/S
         9+IizaIDVPgL1JkO4LqQnd0v7orq0BtWigQptogCb0+i1WeuKwBpXCRMJR+lMezrezEy
         c4iubCoiLXeIuu2/DrmQHkAjY+Pfbq39ud09uhRmw7hW6kntSU/TaS49G4bji5GXCOuO
         yfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=woIqWvRt9ynNe81BRaK2zcaCPrPDigVAmYRoQEBO3Eo=;
        b=aXXsE4mLk5jTEtS5W367khtVk57NUedTtrLsbsV3P8pNY2DkZ2jW6V0mSHlSOJUoOR
         abjhuodfi6nbP8w02RQx9ASYk5VT6LTYKkj2ZdeyaR7sWvox1CKgFUD9fhPqY6HaBeSL
         B5CG2JA5jZU1wJVE5EaQgUnuNYVePHPHkvZbbCw6ZAVbij8k03fRYMqyPyoR3NM/CNQ4
         tnU+GGTFMhzYqRzfuFGoVpUBF2E0priylYDSsCy9Asa4vDluGyyxorQEtau4XJxqXmtM
         gl2tpLHswcu/8G8Gt9vujzi01hqZstidM5AOs9/EPHPqqvUDC/jtb9E7o4StL+9xlTVX
         ZilQ==
X-Gm-Message-State: AGi0PuZd0Av02Ineh8lhCZP1RkmcOmtj38cAcujkaaND2R4OphKxlgaU
        VvgEOfXj0tgBgqK8CJg5nuWQStug2oM=
X-Google-Smtp-Source: APiQypI1B5NGD9Q2zT9LcNJ55xF6rElXbMqL7eO6uph4ukk5OSmrg41VeyPB3QXsO8X9eWIFm2Q5/A==
X-Received: by 2002:a17:902:748c:: with SMTP id h12mr12833366pll.310.1587828781023;
        Sat, 25 Apr 2020 08:33:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13sm8416828pfv.95.2020.04.25.08.32.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2020 08:33:00 -0700 (PDT)
Message-ID: <5ea4582c.1c69fb81.b5222.d97f@mx.google.com>
Date:   Sat, 25 Apr 2020 08:33:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.7
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 168 boots: 3 failed,
 150 passed with 8 offline, 5 untried/unknown, 2 conflicts (v5.6.7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 168 boots: 3 failed, 150 passed with 8 offline,=
 5 untried/unknown, 2 conflicts (v5.6.7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.7/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.7
Git Commit: 55b2af1c23eb12663015998079992f79fdfa56c8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 103 unique boards, 24 SoC families, 22 builds out of 200

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.6.6-168-g0c5=
e841761a8)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.6.6-168-g0c5=
e841761a8)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.6-168-g0c5=
e841761a8)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v5.6.6-39-gc5f3b541dbc=
1)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    vexpress_defconfig:
        gcc-8:
            vexpress-v2p-ca9: 1 failed lab

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
