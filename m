Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317701A5386
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 21:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgDKT3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 15:29:37 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:46227 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgDKT3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 15:29:37 -0400
Received: by mail-pl1-f175.google.com with SMTP id x2so1853724plv.13
        for <stable@vger.kernel.org>; Sat, 11 Apr 2020 12:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Iq3uGBSxgrj3h79/tWBPU1n7lYFl5atD6NTYOS0Mz+8=;
        b=p7MC9hQ9VKtiYIeBEtGjRXMoR/05WEndZ4I3EWUQLfY6dvoh4WTp1de+x+4xOnJN/h
         N7a0WEKmdNEwr9DHtegfqLnq7PS2/atq8U5VXQokoB+rpyilL9ZjizAU1wrPn3rbW48i
         kzYK4xAdOOklOrjVx3jBQhAL4cBOkNTF9mcxyLkbR4z5bv+GMsAQbH8hiZ58GblMiLBl
         6qr6mGKcTqgSy2xp5hmEQSzdfTo6rixQIyxgjvXsT5pU3QG+/HlUtCmJZIg5rCaonXSP
         VV0YOXlCPSjbwnP4opgfld1jhBWkwAmCQTGfvcsjJS9DJJuyPlOp0obFx+rQNBF6xzBc
         ZpRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Iq3uGBSxgrj3h79/tWBPU1n7lYFl5atD6NTYOS0Mz+8=;
        b=Z5uNk7mUrgnT1Jfdo203+keEk9ik6tNl0/lqVm3atdHaB5+wZdYhvAGH9h+GC8zILI
         j9Sx2gHhzAV4mCtgi1X/myuMbLuKAGB9QIjCkCRP3fOuuUEy+1guxEWHf619PfIpXS7d
         MievkZFtfbhyGML/Hp27WoP5E+sTV18KNl1Urgs99OKTKApn5kqqtMVlcDnclAxku9Zg
         K9nR9WTxQfmdY/TlxxHd4wVd5K0t1F3k4kUJLLRQ6i1oIA3zpXH/RiMiRxN9O3CEzP94
         qKKPjPon5YSA/eqvsOQ+pNxtcLCBm0cD71MeexzqiIe5pbnk2ZshB1huQ6YOW57B9QdD
         WvLg==
X-Gm-Message-State: AGi0PuYWRDBGswsTLOeCB6QoAiBHmD0Q2lCqcwhozRn5LtTJR5TySBIq
        aD6vZ/A013K85LrAV2kcsp97chbqfP8=
X-Google-Smtp-Source: APiQypL/yuiBiLdHItHjE5Nvwslfz4PndU74IlxTkgHttKo4JKIJWt0GA8jvg2ZziW+2GrwO/UaUhg==
X-Received: by 2002:a17:902:ba86:: with SMTP id k6mr10610846pls.47.1586633373074;
        Sat, 11 Apr 2020 12:29:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o125sm4246818pgo.74.2020.04.11.12.29.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 12:29:32 -0700 (PDT)
Message-ID: <5e921a9c.1c69fb81.8395.d8f9@mx.google.com>
Date:   Sat, 11 Apr 2020 12:29:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.2-70-g62251e4703ac
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 160 boots: 3 failed,
 146 passed with 4 offline, 7 untried/unknown (v5.6.2-70-g62251e4703ac)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 160 boots: 3 failed, 146 passed with 4 offline,=
 7 untried/unknown (v5.6.2-70-g62251e4703ac)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.2-70-g62251e4703ac/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.2-70-g62251e4703ac/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.2-70-g62251e4703ac
Git Commit: 62251e4703ac6d416aeeec0bfe2af46dfa423a7b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 101 unique boards, 24 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.6.2-47-g4491f12cfc6a)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.6.2-47-g4491f12cfc6a)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.2-47-g4491f12cfc6=
a)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.2-47-g4491=
f12cfc6a)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5800-peach-pi: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
