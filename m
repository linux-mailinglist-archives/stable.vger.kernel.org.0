Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFFB9A20B
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 23:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393106AbfHVVRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 17:17:04 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50801 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390343AbfHVVRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 17:17:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so6968939wml.0
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 14:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=JXgFg85dZHZEnnD7WQXs9gXAOtdzngXWL4jdrsUNdbM=;
        b=h1YHFFXFi8ALbP9egCdFztrE9LZDcjw/p5F0eUuteQdHs6JbW+tFO2XL0kR1A1lxa4
         sWKdxIsAYfWNgjhdHi74a62EHBKpeuyT7lxL/8LE2ba7gD6u27/+A+4LK+08YTjIg7id
         XQUkZ/yZwTL5xzxHq3Xwko8FYl3NKk1GNaAG1ECwZmyTfkmsM4bM6g1GS12m9U4IpumC
         BcyKbHVCy/0YVwePoBVTui4r6mbAR8ZBZgrVSKUfJX7KnwFMagcewyMJzOucavTx+mhN
         eSLDq7X8OEvl7gtIR753kmKZRzfkfYHN/MwjKM1JnoFrZHZloNqEwagS78Rc0zQE3JMm
         mbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=JXgFg85dZHZEnnD7WQXs9gXAOtdzngXWL4jdrsUNdbM=;
        b=GdhyDBREDVe76me6anXxpprV9AaS4Grp6ZrvoOVP20oJ3WzM1HH5wZdWyJyCZQyEtG
         XyWfopjSKPYqXuLpHEwraJoY4RIS8dBWm4rU0FMHpV0dLh1qXsNy4XNl3908pGUrc6Gw
         aQdpIm2WFk4lxzcEUy6rA1MMyuQp9ZwW2RMqpl6zuSC2S9zjPPBRxjv3f1dmVnIAyUlU
         l01KeZn11MXxd4xi7FjTnFyh85ViRx6n3BDQFBwgV0t3gMeGZkm5MoWoOtiwcESFhlcb
         txD1bAaaFSXZBj8SQl+XGYiwWw2eLPYyci69g5XNBb1geRykTSqZ78fnzxlvWQJ7BruD
         P51g==
X-Gm-Message-State: APjAAAUcHlEO6JkSe118HBEO6i6FvV2kG4M/IublFALajp6cbPEoF3rf
        govq1tFrMgy9FtZjxfSAEciveg==
X-Google-Smtp-Source: APXvYqx3PCJSGg2+eWoDByCx1D7/6ErcnO+3iKn+jMdbY4uSJ1R+r1sawrf+9GfMc6258/Q5IisFDg==
X-Received: by 2002:a7b:c019:: with SMTP id c25mr1141538wmb.116.1566508620876;
        Thu, 22 Aug 2019 14:17:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e3sm1849035wrs.37.2019.08.22.14.16.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 14:17:00 -0700 (PDT)
Message-ID: <5d5f064c.1c69fb81.f049d.97cb@mx.google.com>
Date:   Thu, 22 Aug 2019 14:17:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-104-gfefc589434fc
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
Subject: Re: [PATCH 4.9 000/103] 4.9.190-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 0 failed, 94 passed with 15 offline,=
 1 untried/unknown (v4.9.189-104-gfefc589434fc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-104-gfefc589434fc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-104-gfefc589434fc/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-104-gfefc589434fc
Git Commit: fefc589434fcd4cf95d9dc24271b21e7913ef6e4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 54 unique boards, 21 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v4.9.189-105-g9c965ba1a288)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-96-g4cd56b7fcd6f - first fail: v4.9.189-97-g6971d2d959e5)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

---
For more info write to <info@kernelci.org>
