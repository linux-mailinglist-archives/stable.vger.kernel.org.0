Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C330991659
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 13:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfHRLVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 07:21:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53764 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRLVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 07:21:08 -0400
Received: by mail-wm1-f65.google.com with SMTP id 10so630107wmp.3
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 04:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RMrlIdJig3t0VsW0haEZAFVv35y/kNQMkh/pow1QXQA=;
        b=tex46osFSFW4bxstCPNldBMwEkPFh4l33uegluUonJi7egvRswvXhYGpQTnZkFxAek
         caIJYAJqvkMqhfgw3E9F5z+BCqkaO3dGKxDugg1ndFSm+j8px8jzLdft8+V7Y/NjNV0X
         GE2seVJR2u6fv0YrG0jzOuo7u2OQvqrV4br+pVhPiCsOt9XWlIYkCGOCSD6e94jkrrWS
         /8/QS6BAq/jNzVMRtZ/T0h8ZEa8zyq5urbVNB84f5Z7uy1uR8frA0z7Wj7gqsRAU4QMW
         k8oSY6OowyOOJPZcLZ+M52C9nCOtmsufugsEcb5Jj5KRZLX+faEUBNFRS5AWka/lKAYi
         54FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RMrlIdJig3t0VsW0haEZAFVv35y/kNQMkh/pow1QXQA=;
        b=uVsnjUKCXIxVognwECELOzmznZWiAjGCI85xORQRQvCce4DPmIZYqz21NfaikT9FBg
         g7KANAkqoL4NgILtw3Z7oOuYWU6+NyDrHxjhK+tE8fzkYtBt3iNHNZj6iexEqP04tWIf
         GyVhqegijUvhVwyC55bNOhkaliOP12vEt3xzdGsAoap754ydR2wtik07JYsEfSKrJgpq
         79k7JpuofSwAg8eZG6hTbJVb78RSys3oaugMbYAxCV8AIOQIt+xWW8trRjlkog5SJzn2
         +BOmbkxlpqaQZKmwuD7o5VFFvfmWWMm1Z/49RyIfSJ60e87mEHo4op2wOPowVyISCrMN
         trCQ==
X-Gm-Message-State: APjAAAVYkjNibuFnVJ7KojmMZCdPeJNTr1qkULv4Qz4IA225UVZ8pBMe
        5nlvgYMSGoVvDM3arr5DMH7OeBgl2mI=
X-Google-Smtp-Source: APXvYqx6PSU3hjMM4PmErGT3X0YrZG5j1YTOTSVGE3QExXYsvr5abzxj28rW8iRg1PuY13pN0WvtAg==
X-Received: by 2002:a1c:c1cd:: with SMTP id r196mr16051994wmf.127.1566127266119;
        Sun, 18 Aug 2019 04:21:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r190sm12072102wmf.0.2019.08.18.04.21.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 04:21:05 -0700 (PDT)
Message-ID: <5d5934a1.1c69fb81.4c562.9aa5@mx.google.com>
Date:   Sun, 18 Aug 2019 04:21:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138-91-g248e04a69071
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 123 boots: 5 failed,
 94 passed with 15 offline, 4 untried/unknown,
 5 conflicts (v4.14.138-91-g248e04a69071)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 5 failed, 94 passed with 15 offline=
, 4 untried/unknown, 5 conflicts (v4.14.138-91-g248e04a69071)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.138-91-g248e04a69071/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.138-91-g248e04a69071/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.138-91-g248e04a69071
Git Commit: 248e04a690717bac57426d5816a63425bdcba0f0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 26 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-73-g1=
a4682459a61)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-73-g1=
a4682459a61)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            qcom-qdf2400: 1 failed lab
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

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)
        r8a7796-m3ulcb:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)

arm:
    multi_v7_defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

    exynos_defconfig:
        exynos5422-odroidxu3:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
