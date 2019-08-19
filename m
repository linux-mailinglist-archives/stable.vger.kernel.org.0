Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE23192101
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 12:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfHSKLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 06:11:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39072 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfHSKLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 06:11:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id i63so1078854wmg.4
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 03:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rWSLq5ZZ27SRE7p1n9hoDOAoExb2h3edyH5cN0TEqfk=;
        b=xU5zSLOFGv0orB2AK1Y1CLngTWNwOlc6BfcJu5kWdFH/+Qn6i3U82zHr9D7BVxP/ad
         hOiX5AREvYUh/sohFSIL1x14jZQuG3hp6rljKOOgatWXngIyXnrHHHFv8YkR4NbZ3NA2
         8LGY/C8WWKu/Ib+6tHdIE1lApw3hb6AZ0XrGw+49Ufv3gwGnXYbu8WKKerOHeAkgphhF
         cY6q39wExrBA+qZr3/ug1vgh2zvQ1/xYUx2cWFoVnx7zNQ3aTsLJZJw+PhMhnqROuTjh
         1qGw3Yqt7rLW7BmDMcv4/xi/EPfGpyUvTEEoX9waFj1iE2s+QuWdjaDqtgTpFIo4bgGb
         toUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rWSLq5ZZ27SRE7p1n9hoDOAoExb2h3edyH5cN0TEqfk=;
        b=hh3tQzph+FurkhGD+3NQVFByjHjLRO59faLeXZ4qajF4+sOeWC/VyGtHm4NFfyoXJB
         Urd08LeiEVY0x2YgD97SbRSOuDllwoXAUFr0HBJTqhvtP1nBrfMc4b/1KpH1ANZsMO6w
         3xhYq4+eD59hS+b6O/3engM9eEbEyV13h8/sDiZrrgVLc4rT4PfDqADd4BlmwUezPpEh
         nVvKaPzZzbvU1PQS9EEHBCgITPTDBoLzR/0ejsubAhEZmkhUIY2d8IVW/3MZobI4cRyj
         Ocf6MeM9Metxhekm/c2mIEpZL5wiHtRsvwxe1Yp7ctPiSR1mw0ufEyfYJN2yoB9c+K5m
         6W6Q==
X-Gm-Message-State: APjAAAV/aKleJVHZPcnsm6prVVAefCOhwetQzt8QloJq8SuVwevguAtZ
        LHwXBghcY+M5OJhrN18zGWamIWQ3scY=
X-Google-Smtp-Source: APXvYqzutM4ahucqk8aXaGWo2B326Q6W9xogZvLZ14wYTM7DtfbiGKYNQ5j3otjLwl1UxPOmcDzp2A==
X-Received: by 2002:a7b:c8c1:: with SMTP id f1mr17942417wml.87.1566209464725;
        Mon, 19 Aug 2019 03:11:04 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c8sm13645076wrn.50.2019.08.19.03.11.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 03:11:04 -0700 (PDT)
Message-ID: <5d5a75b8.1c69fb81.11e6b.0b2a@mx.google.com>
Date:   Mon, 19 Aug 2019 03:11:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8-250-g9f31e50a6fc0
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 136 boots: 2 failed,
 117 passed with 16 offline, 1 untried/unknown (v5.2.8-250-g9f31e50a6fc0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 136 boots: 2 failed, 117 passed with 16 offline=
, 1 untried/unknown (v5.2.8-250-g9f31e50a6fc0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.8-250-g9f31e50a6fc0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.8-250-g9f31e50a6fc0/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.8-250-g9f31e50a6fc0
Git Commit: 9f31e50a6fc03f57a6dfd1d5006856877259c12f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 27 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 4 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 4 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
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

---
For more info write to <info@kernelci.org>
