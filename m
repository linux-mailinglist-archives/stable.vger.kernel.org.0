Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7953919B684
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 21:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732527AbgDATpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 15:45:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34054 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732307AbgDATpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 15:45:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id l14so649258pgb.1
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 12:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1Rshf/gTGuKNUYMn1KzNwkO090hTHhRwnfO535Fi9PM=;
        b=JsP7/BOFkZ7+NJ41SuNIn96M6rj/1ho+f7mAFdjs3lCkcy7GKs3DzAwIeYhX75KYQi
         KlflaKjngsyoAh8J/EoeNgcBcGeo0Xqu7bjfWBfdVRW+Z1GFB/Yy/9jRNWHpyu302u3u
         t6rYcn2N5K83b01U1iIz0+W2XGqS1qVVwH8pCn5vMHO4oaJ4vtRv7kv4dzWThGlagtfx
         LWajjzU6noFglq/2zCZY5g9RhNEHmREaavft65GmatvytPwuWwHfgOFZ4tNIG3gvHDar
         uqn14GFweP2ziuVVvu/RGep+M2Cg8DE6o/sSdVbAxUL0kXEQ3U9OF+SG/VdVhQiHEZsN
         dx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1Rshf/gTGuKNUYMn1KzNwkO090hTHhRwnfO535Fi9PM=;
        b=bbq4i8+75hW2TTrn18uOBEgUFMN87zU2zo9JR2FZtrBkUZOQsTekvtQ5yx6S82Uuin
         HVwSFTLfl7Qhc9zpQI2pOyFULx3roeQWmx/xO1cp5mC7s376j1RRHITNFpjD8g3cjkPC
         FzRobAK6z4xl1tgBW7eroiWUCilWQLFOv12glyG9FFbRBanOq+xNVGuHcxYGD6B4Yq3R
         xfWR4U7bHZS7S18dCMBAsIVbEvxLluFJVdKrEhygqA4btD2oREW66MPOHsK0rIv5cp5/
         1GFtWCjoEohfVqJ9Db29CQE3+k6V42JVYwbcuuGAZj4dcfUIVtEt751kwAmimmw1aegS
         JQUw==
X-Gm-Message-State: ANhLgQ25Wx1rj8zzyNtDo4RWPI2MhcW+mo9e+6BYXwrlMhSusi5Jbjf9
        IonFmBh7L60JLwOCaawgYAgarW68x2E=
X-Google-Smtp-Source: ADFU+vunq4B02vWj4Pnm0nOxFIlZB3/PKliFsobuCNjiX1LnxDvow/Zs2j7MgdO8yX32zjeFK0SUgg==
X-Received: by 2002:aa7:963d:: with SMTP id r29mr23754106pfg.87.1585770328586;
        Wed, 01 Apr 2020 12:45:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fa16sm2237475pjb.35.2020.04.01.12.45.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 12:45:27 -0700 (PDT)
Message-ID: <5e84ef57.1c69fb81.fa9e6.b611@mx.google.com>
Date:   Wed, 01 Apr 2020 12:45:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.174
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 133 boots: 3 failed,
 121 passed with 4 offline, 5 untried/unknown (v4.14.174)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 133 boots: 3 failed, 121 passed with 4 offline=
, 5 untried/unknown (v4.14.174)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.174/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.174/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.174
Git Commit: 01364dad1d4577e27a57729d41053f661bb8a5b9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-155-g=
78d092884075)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 46 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 35 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-155-g=
78d092884075)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: failing since 1 day (last pass: v4.14.172-114-g=
734382e2d26e - first fail: v4.14.174-131-g234ce78cac23)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.14.173-155-g78d09288=
4075)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
