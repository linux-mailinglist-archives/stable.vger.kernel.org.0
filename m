Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69321BEFCD
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 07:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgD3FgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 01:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3FgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 01:36:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF294C035494
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 22:36:17 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f8so1843560plt.2
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 22:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xwVx/EbeUHxa9tzUXAvys5PNXXFYsvRZzLalpF7N5Oc=;
        b=hWQwzR3RfJ6hwXQzYq10skbprhK2ldfrxSuJfYe6TG72aT+Sc9Qt/nJV3xe+aDBON0
         XBNX5DvfmycaWmaFeneZ5tn3vkIz2VoBNO3UrhBSXA23VcKpmRZj5YgBhG2SQmLxRKes
         iz938gPvSNa0aZeIBZfws/W7bWT1OvJ6nhL6PocXMhTFtAf3yWXTgxHAaX6QJj2L0F2C
         e1ndXbjzfDsD65aHDazBBVIil0I3z1pYOEudbgxfmEqqA16X2YNpoTS3hz8y2IdjLtqF
         LXEck1VHotFn2pRD5GH5AYPpEn/+xuwso9ortx2jINZFA2oBrgRmUdo8UkRJfKDG4Nfz
         SGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xwVx/EbeUHxa9tzUXAvys5PNXXFYsvRZzLalpF7N5Oc=;
        b=TP3lDy0IFAT+jiK+lnlf0KwLw0km7etcClbZoE/ga2h+OFKuw9cNKdNn/8rEsFiH++
         kDmDukg/WTG8qflP3oC31qXvS/7MdZABMg/GG6gevf2lUeOv3wyd9X4AobWluI+pxXI5
         dDgQKtFffxMywuHfTWlyuNwoWI6JXPs9PaQERhnadAS/4UxRZEZr0JDhp6SqbJqxVFzX
         MFvhe+rS6rktjB2uHtIMWE1FspfKLkZkdCogUKdqnUXTFTw8zPyy24EUtQyqhA7EOHFU
         UgLRoRrfnGGFP0LK3yJ6FJuKoqq74nK98K/cW8HH1EFuV96x/d6tjcb6OAFz7z20QjGH
         q/Gw==
X-Gm-Message-State: AGi0PuYgZnchSJvan9VuiZ39/0HLP4zPe1hOL3xvQtOX/seW9tsRyzLH
        dNlidU882iUOKVppvEhY/y0JB7XlRjM=
X-Google-Smtp-Source: APiQypIDLS9HYAtXuA/eKjh9PLrSq8+FHHgbgbQd6b7ktUSPWR3HyzlZamhaZ3LgnZhJ30Z/nM7zVw==
X-Received: by 2002:a17:90a:ca8f:: with SMTP id y15mr1029664pjt.88.1588224976867;
        Wed, 29 Apr 2020 22:36:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u11sm583415pfc.208.2020.04.29.22.36.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 22:36:16 -0700 (PDT)
Message-ID: <5eaa63d0.1c69fb81.6f481.2a17@mx.google.com>
Date:   Wed, 29 Apr 2020 22:36:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.119
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 149 boots: 1 failed,
 133 passed with 6 offline, 7 untried/unknown, 2 conflicts (v4.19.119)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 149 boots: 1 failed, 133 passed with 6 offline=
, 7 untried/unknown, 2 conflicts (v4.19.119)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.119/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.119/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.119
Git Commit: 765675379b6253b6901563e649a2f87d28ada3ff
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 86 unique boards, 22 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v4.19.118-132-g3fc812d65d=
b6)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 81 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 47 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.118-132-g3fc812d=
65db6)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.118-132-g=
3fc812d65db6)
          sun50i-h5-nanopi-neo-plus2:
              lab-clabbe: new failure (last pass: v4.19.118-132-g3fc812d65d=
b6)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.19.118-132-g3fc812d=
65db6)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v4.19.118-132-g3fc812d=
65db6)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
