Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF8E3981D9
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 19:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfHURz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 13:55:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35418 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728591AbfHURz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 13:55:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id k2so2899270wrq.2
        for <stable@vger.kernel.org>; Wed, 21 Aug 2019 10:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0i/B4N1uUKn39gW6CKzddRGMqMAE8IUJXmHV1krCefk=;
        b=ndGuHdFkVgsEOXKnNvH6z89L5Trv+0F0Fl0H70eQ6VrqL2n0Rgih1C1fe4lyS1aEID
         l+bk8OaVr66u/yYon1yTVswYJXTyKyOfZ3JcOyTnNBhTAIhAD7pelIJIfGO2nzyAPPLU
         n6O5qcZ5gjfLPgjGBNH2vKpHMM7Ue9QGXkMLCXJgnAlFIHUbXzkkDI3vee/tvEh8MrPC
         kGrG6zQV7nAs162cgpB8Fs+wWrdRmqtMwUUQRk2VuDTsq9gFicei2FvdGk2+V0yRdpDN
         7DlMZYe+efBlzUkwiaIncot2mN799uXTqCq12uL07SC3QQW9AGA6KV6d3YvO7gY0TQWz
         ghjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0i/B4N1uUKn39gW6CKzddRGMqMAE8IUJXmHV1krCefk=;
        b=Xo3Zc14TlorHFFKgJM0wUgCu4/EFNhIH93VmIX6ouOy7SWdvpMdaM6RDArJDSkW6jI
         VyQQ3hsTfXp+RU1ORRP8sb2phnu10pwL2mmr9JKLvcBWPmDdvtlbxluCaz7LgQtRkAEJ
         wZpVHXPwfNiTUrBJzSFF6EoaNoabRYYcoVPs9r4JCICyqnR5Q4VutNS8faiyYrbw3fF+
         jRDA5mwQTG+BXIO+PHBB3GSRgwgVh/PJNNcfR1OZUeHAYNXZR01gcjiTd/JfY1Ggfgzf
         kXHhjsVen3tRsEQB3if0Uu+e/zYtynzueeAk3zFjxhQGbw88iAk3sUWkp2o6rLTalDHi
         Um5Q==
X-Gm-Message-State: APjAAAVp4AH0qKlrqs6lWnxlkK2647lst9njnC6xuNm1Lt0oYjL1Htpi
        tHWPfzHRzSE6iZOsljM2nqV3iEAB9lRFGg==
X-Google-Smtp-Source: APXvYqxmVYBVagSG631OFogoyLEu0BFcUGjQ1k0iow5WXNFqHt0IhS6JqecaDkNCcwDFlUy8fbTeVg==
X-Received: by 2002:a5d:568e:: with SMTP id f14mr41081043wrv.167.1566410125509;
        Wed, 21 Aug 2019 10:55:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c201sm1437946wmd.33.2019.08.21.10.55.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 10:55:24 -0700 (PDT)
Message-ID: <5d5d858c.1c69fb81.87065.6c21@mx.google.com>
Date:   Wed, 21 Aug 2019 10:55:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.9-136-g6451706234b4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 134 boots: 0 failed,
 114 passed with 18 offline, 1 untried/unknown,
 1 conflict (v5.2.9-136-g6451706234b4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 134 boots: 0 failed, 114 passed with 18 offline=
, 1 untried/unknown, 1 conflict (v5.2.9-136-g6451706234b4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.9-136-g6451706234b4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.9-136-g6451706234b4/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.9-136-g6451706234b4
Git Commit: 6451706234b494afc737f64c0b442d6594c4ccf9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 27 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
