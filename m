Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8559628DAC
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 01:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387760AbfEWXQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 19:16:10 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:39133 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387693AbfEWXQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 19:16:10 -0400
Received: by mail-wr1-f45.google.com with SMTP id w8so7999399wrl.6
        for <stable@vger.kernel.org>; Thu, 23 May 2019 16:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uakjPDFebRs0u9tyFD9o4VuZZUThZRMY1cyeZyLtIZg=;
        b=LCET5b4usLifAVfj53DIXjHQM+giBSEZ9+LrPtG5Tv2y6maWICpCN4XQX758M8CkRm
         PSUe8qNwKCgWw3HPYRKb+Wq+AKYBDU/cTTKBogo6K/qk7vJ0HCKzwiQoGfgn9h/koAST
         rfhasYk1T6wF+iiyjJhs+qX9dTh2+edj+g3I6fKfcjFWT0CdVVxh5cf2bwKWCqDFiNHp
         O5llFqgSv3PzC8u2fMfjeR2ilei5xatqiOrEJszNuF/shXWaCWArtdSP3d/mAp+jb65l
         SWdalpC4nOalFLOrdd8kF3HX+cHBeaDMmEomQ2DCWaO1MMBNOlREOMqkPDjGAIfA2zVB
         5P2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uakjPDFebRs0u9tyFD9o4VuZZUThZRMY1cyeZyLtIZg=;
        b=LtAKRyiWur/CnDGLJXzz24/8VH6Qm4kD31oWXO040EM7DmdN6MhIuapNTEugArIrGL
         6Sn6xxxR6tYgdFvwMWIyt76fQqXOAGd7qGu5CRHXah5l4cFR3RXOE95S+6UUVUeHNojQ
         lLjeQ7lFGrSpRQf+lggZ8J616mY4sR0CR8DpwnoLlLEi0C9mbl1O36UoIKxaDG+rbwtC
         oTcD09jScSvCIq5RxfNmHzu+/bMFAju+xPSOnUH6KY5ImYr8+8I7yQKzoo+4lFH8frow
         TvFLYEsMNss0i9AKD+iUaPVhADL2L+QsoRxer1CMRuHHtIcfg12ufROkmIiV75y65OZo
         cpcA==
X-Gm-Message-State: APjAAAV/Br1BIjZIIzyJ4y3YhxWzE2BJ+pLiaI0lrk0Jf04YoIchjnuy
        ovJRVA+jgI0hxGM+V7KV2LKHOFwQvpDC/w==
X-Google-Smtp-Source: APXvYqy61UJgViwnG2DX+aynXXB8Nav6PDdKid2zrcDde0XCIK2vRhwoNrNqgkyEJ0H8070D3+hXKw==
X-Received: by 2002:adf:b611:: with SMTP id f17mr63302076wre.162.1558653368543;
        Thu, 23 May 2019 16:16:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o11sm1170415wrp.23.2019.05.23.16.16.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 16:16:07 -0700 (PDT)
Message-ID: <5ce729b7.1c69fb81.8758a.6d1e@mx.google.com>
Date:   Thu, 23 May 2019 16:16:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.180-76-gb17fdeda327c
Subject: stable-rc/linux-4.4.y boot: 95 boots: 1 failed,
 80 passed with 13 offline, 1 conflict (v4.4.180-76-gb17fdeda327c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 95 boots: 1 failed, 80 passed with 13 offline, =
1 conflict (v4.4.180-76-gb17fdeda327c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.180-76-gb17fdeda327c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.180-76-gb17fdeda327c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.180-76-gb17fdeda327c
Git Commit: b17fdeda327c7698810cd9d96df9fe9f3641292e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 21 SoC families, 14 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 6 days (last pass: v4.4.179-267-g=
be756dada5b7 - first fail: v4.4.180)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
