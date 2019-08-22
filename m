Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B4F99E5D
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfHVR7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:59:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33449 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731347AbfHVR7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 13:59:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id p77so7600816wme.0
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 10:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f9ICOaMhf+P4t1loD+/kpbQ/JtjZEmiIQ2pu2dEnJS0=;
        b=tO1lC7uCySWtkOiTIMQocwU9vKKTfKYYY8C/GvHVVsQWpW48rTPixSXPzI9dadUjLN
         mDrdl8uwTL1rg0XhNDU1lZOv/oxyaHExGKN8QQo/JlEQ/BbPvknNNOVr9FuIl9Jazh3e
         fyZ2WQZHhRri4Pi44IOZ13XavUaJup4uIHQa5PLUooXPrW/ZPZP8s2wK8I3mVO2lqml7
         WCWgKIdr1IVe+0uf9Hx3bDthIG4Ne3zcsHM5mIPD6pk0m0jSDWUhfitIV33VK5ijK0La
         r0xExQcFPCqJH39L1dB/g/LPGuZd0Ht/lVpng8CFMLAGyb3J88bg061TMYQXOSUWnrwk
         X3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f9ICOaMhf+P4t1loD+/kpbQ/JtjZEmiIQ2pu2dEnJS0=;
        b=sT9J1BZ2Mkggu0/VS++cy7qrJCb5QuI0wzp9XDBn/C/8jK6kaIppzsPDPkO357nT9V
         kc3Lfi8TE9DfntS7xKqbeB1dMp6GZkRR+iO3ScIn7cxAPTgvXK+CHYGUUNNSSttebRMJ
         i4JtoP0+XTFIIRwT38nwiQUrsjs8E7e/IwWP6fSrsyAwwbV5jUAucNaFL0l5oDi2dWVk
         NE6uOcvaP71UeZwBPJzpKDwM0rZx5rcxzotgsFy2uzxVKIt6xa0C7jmeOE4eEi30YReV
         EH8BnZHUSsrn7CCSrcikyYnAEaI1jD/CXnjQNR0N7JEkr5bX5zRexuNK2BDN+EcSaryh
         10SQ==
X-Gm-Message-State: APjAAAUwZUacNo+3QwHjOLLiaW4b39q+5bXrOMr9BlSyFswo+Jc0H0qN
        4OqhXrWwVXX+3fIQWeHy7PLllN1K1k/v7A==
X-Google-Smtp-Source: APXvYqyuFQf+215xUqVkjjbFTmInXqAce8sGwqQ27eJo+TEI5XfPqVaXbeuKUYgZQCngpuxcP2uiNw==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr273075wml.175.1566496768403;
        Thu, 22 Aug 2019 10:59:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i93sm671464wri.57.2019.08.22.10.59.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 10:59:27 -0700 (PDT)
Message-ID: <5d5ed7ff.1c69fb81.cd479.3337@mx.google.com>
Date:   Thu, 22 Aug 2019 10:59:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-79-gf18b2d12bf91
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 101 boots: 2 failed,
 84 passed with 12 offline, 2 untried/unknown,
 1 conflict (v4.4.189-79-gf18b2d12bf91)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 101 boots: 2 failed, 84 passed with 12 offline,=
 2 untried/unknown, 1 conflict (v4.4.189-79-gf18b2d12bf91)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-79-gf18b2d12bf91/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-79-gf18b2d12bf91/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-79-gf18b2d12bf91
Git Commit: f18b2d12bf9162bef0b051e6300b389a674f68e1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 19 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-75-g138891b71be5 - first fail: v4.4.189-80-gae3cc2f8a3ef)

    multi_v7_defconfig:
        gcc-8:
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.4.189-80-gae3cc2f8a=
3ef)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-75-g138891b71be5 - first fail: v4.4.189-80-gae3cc2f8a3ef)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-linaro-lkft: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
