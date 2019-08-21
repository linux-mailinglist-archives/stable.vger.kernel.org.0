Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22FA96F8B
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 04:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfHUChz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 22:37:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46070 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfHUChz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 22:37:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id q12so455404wrj.12
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 19:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=56NW93Eeg+ZfJyo6ISh7/WpT74AmkKBP/vx5std1HBs=;
        b=OzzbPb1sssxAxSOZ5xOki7BwtviErlfIsyhnOy6w7JNsHU5Z/jLAnbVv4SUujfVj3U
         gOcA3whDUX+Xb3TuOKAUnQPkfeQ2RQceqtBokKI0gOMfsR8UStFZUqq393ME8Xl7AxGD
         yZZ3ME9CrBbLCPi4ciyZeB54Q8r4ATV+JUgCZXuRMvAkKVDIm0fi3u3wWznDEH6iRHCx
         b3C89xXLNyvEEPDr+wyhS4CQiGhcphRO9QpqRV31rQ0xZizBX2BkRnMYYmsWpgM4sN7j
         Uvtd4IrBdlvMOMo1Z0iV4fjr5cIZ7WQwaQiEWl9BYC8QOzaAHWDUYk9sgOImX5dLFnQf
         7GEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=56NW93Eeg+ZfJyo6ISh7/WpT74AmkKBP/vx5std1HBs=;
        b=DX6yVgsxQTaZTwJ17Xv4+hEOFQLXmnf8Wos4nqsj2RPGXfNum7+SmBesXSDZ4mIgVE
         mhzqrff0stOZA0KsWRwmi9l/cOSxV/xv0g9BUuEpIuwzv9LgCeEuVxFpow6dmOY6oNxu
         aMuyb5p2vAo8PsXQdctHf5n/obVNaCJXyVY5oq6jyYQA7iZi7jjPDQEB1FxK79NhHQhW
         jr7FIpIzA8AuQC51Wd4DL/ksKP8BF4LZczTfJ3a/IL4S188OfWUmpjvGtk7lhNiTcY/w
         de3FNQxOrdyPnWXldUbgN3X+bCKogj/cuCqfvt+DO9BonAp2k+b2bfHeq6N3G6DPkCgJ
         sXgA==
X-Gm-Message-State: APjAAAXj9CGJ7rvgR3K8IEgPGM7fFzuCqfpZCO5eaGAFVfaRhWePTrWW
        deOa7uqzEcOvS51PZRegQthdlj2RocBdDA==
X-Google-Smtp-Source: APXvYqyFxFXlmPhu+iswUhLMrdGQkliAzl4S7jzIVr+VWLNQTJ64MiBrW5KabwxMkxOp01QB/j5q3A==
X-Received: by 2002:adf:fc51:: with SMTP id e17mr37384601wrs.348.1566355073436;
        Tue, 20 Aug 2019 19:37:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x20sm44534801wrg.10.2019.08.20.19.37.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 19:37:52 -0700 (PDT)
Message-ID: <5d5cae80.1c69fb81.d5e3e.9751@mx.google.com>
Date:   Tue, 20 Aug 2019 19:37:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.9-108-gd3ad3ee990bc
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 135 boots: 1 failed,
 124 passed with 10 offline (v5.2.9-108-gd3ad3ee990bc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 135 boots: 1 failed, 124 passed with 10 offline=
 (v5.2.9-108-gd3ad3ee990bc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.9-108-gd3ad3ee990bc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.9-108-gd3ad3ee990bc/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.9-108-gd3ad3ee990bc
Git Commit: d3ad3ee990bc5e4167fc5cd553f6f73cdaf10fa6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 26 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.2.8-252-g0953e780f37=
b)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)

mips:

    pistachio_defconfig:
        gcc-8:
          pistachio_marduk:
              lab-baylibre-seattle: new failure (last pass: v5.2.8-252-g095=
3e780f37b)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
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
