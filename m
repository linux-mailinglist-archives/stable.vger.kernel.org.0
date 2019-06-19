Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB374C41B
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 01:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfFSX2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 19:28:18 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:35756 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSX2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 19:28:18 -0400
Received: by mail-wm1-f43.google.com with SMTP id c6so1221515wml.0
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 16:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HyO6jtcVtA3BWq6PoRQ3zWeafLe2xF5L9ecV7yI0KUE=;
        b=uK9fB4tEmAbdRimcgAwBXHQ1SMfaQkM1oJv+evrFQkAwc2WFLHy5Te+EcF5jLvLBwl
         lsLPW4fWgyYutTWX2UfdqW++mbI0cPoQ6p6YWbwOUSmAS+F0ONOxxN4EM/isc/im/Ych
         i9gVWSe/tqWwv4UP+8QoZVZLHquBXFME45qHiUr5gAtwcWC7Tpmo3JIQO4Duc7BdSLdh
         EDCkCYh6UqHoqAzDa8Lt9TduITe8F4lZY7ANAnxuee055FhdEPZsyGRw1YDXIdh3w6Cc
         SyxsriHU2Fo3saazpQyCT7SsNn6UAQTVSsEfWyqNk30/BUWzOVsdiCWuYlD1F1HG8hXt
         PBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HyO6jtcVtA3BWq6PoRQ3zWeafLe2xF5L9ecV7yI0KUE=;
        b=qvzuAmxvHHsM3FjNPfUbVm+twApNY97zU2Yj63z5EezM72+wkbOHe7PnqD9qV8mNik
         NIptCTnErsRWJQZOzOYWIJGlB1uc3RyPfpWxXMA+VvjrWiSfHVPKTOFcVQvm3i9zH47G
         z+2jT43ufCFT+E62DXIspgGfXRvjTlpopEWB0/i5+KkfJKGe1q2ycGsFs2YAVtY44MT0
         PLZnpO2BOd4jC6sJ3y2O7/Gu2nZxPltb1LXF2kApG4D411WD21trQuAre7ieVl3iJM7M
         PWMWZUBP3g3s6TsTjkwiH3YbIwmcqLAufbAGi38Jhqec3AvsEpyaTfoi9p8Us+EzYrvZ
         HM+A==
X-Gm-Message-State: APjAAAVD05krKKoBi5zzbcNos8Qlmekdi+B8zWfCdugge3yrptK+hiWf
        YqEVpU2nUl2sODpoI28R5XN4ljwue2nyvw==
X-Google-Smtp-Source: APXvYqykz4nfg+hIp9klBvm1l+HAc9J5fMPCN7uet2F83eBEgNwoQknRqAplgAhc3G14wL9nuRIFQw==
X-Received: by 2002:a1c:c003:: with SMTP id q3mr9998691wmf.42.1560986895797;
        Wed, 19 Jun 2019 16:28:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p140sm2980991wme.31.2019.06.19.16.28.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 16:28:15 -0700 (PDT)
Message-ID: <5d0ac50f.1c69fb81.5b3b5.0e47@mx.google.com>
Date:   Wed, 19 Jun 2019 16:28:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.182
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 94 boots: 1 failed,
 81 passed with 12 offline (v4.4.182)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 1 failed, 81 passed with 12 offline (=
v4.4.182)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.182/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.182/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.182
Git Commit: 33790f2eda7393d422927078597a33475792c82c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

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

    qcom_defconfig:
        gcc-8
            qcom-apq8064-ifc6410: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra30-beaver: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
