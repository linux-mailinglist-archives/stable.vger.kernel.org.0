Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D808F28C53
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 23:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387533AbfEWV34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 17:29:56 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:44224 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387447AbfEWV3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 17:29:55 -0400
Received: by mail-wr1-f41.google.com with SMTP id w13so7769554wru.11
        for <stable@vger.kernel.org>; Thu, 23 May 2019 14:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B0AMlDk/okqg967cO8tqX2MYW9FcukrB4R969et3urU=;
        b=rBmXLK+adbw9abxVXR4emJrDLo0E45NijcR7phHOfokPZtNfd9G6DR8HEmTQoxqss5
         pokYNA7NoPPbI5YIfVDSz0qwk8sae1/4WS/wAAqifXn++a5T06AAMCobCNI8BC20VoHg
         xEBnQs363jqNUFLba7tKUtFQf1F59NDOxQMIcDwPfXQytHXIpa0qbrCr3WotocemUB2R
         9jCFnZ6mHAgC3kjaM+MWTxvx+jbVKN0vp9+1J2DQXBXwh33YUw821e9L/yhCTEovTpq0
         UK3hUvHUZ0F8i59qeVpdgaa3baSWpvBQGsYitc7QXgh5dTW3GKBEku9iEGm2UU1B441V
         QVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B0AMlDk/okqg967cO8tqX2MYW9FcukrB4R969et3urU=;
        b=taTylxQLQE4P1omaHA0yXCiPSgXya99dHgxrQ3nvvpzwAVlul7bI/u7wRYwZQlk2a/
         +yirQjLN7SqjmOj7QLUkEB6gtatSpR44uTjc16Qx6jWBjTf1e2nUToiHE3twg1ymffwx
         155B7zYwUOhSsbyEjhBCbnRF9K6PfZvNBZCru4KWtdhYOPQ6s0UUw9y/7Ae4Qpr3pZyl
         kYmr82FAFyd751nKyKmw+HJWhCFQ5wa3qxJjIJcxQbMybXviwIlIpFGvl6H13QflxLOB
         4ZpeFP2NKhicnma4Qprvw9sUG49tjELoDDAFl/Jzl0K7P9EtHgWQnJCMskccPaeohz42
         aj4Q==
X-Gm-Message-State: APjAAAVCgGRPRvN9Wnj3LKqtvDNfqoHxxnYe8cnJSguUDlktu3xXylJ9
        QPIkgp7Um+692LZh+bngCnAT3pVUPzY0Pw==
X-Google-Smtp-Source: APXvYqwWJJH7dt95l9JRcRV4oajcbQyZBhEWFlL5X8loVTYD02+VuYqA8RgaoqVV+dPAPpZtJzcECA==
X-Received: by 2002:adf:eb09:: with SMTP id s9mr2894442wrn.127.1558646993933;
        Thu, 23 May 2019 14:29:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m10sm491462wmf.40.2019.05.23.14.29.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 14:29:53 -0700 (PDT)
Message-ID: <5ce710d1.1c69fb81.fc01b.2e88@mx.google.com>
Date:   Thu, 23 May 2019 14:29:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.121
Subject: stable-rc/linux-4.14.y boot: 126 boots: 1 failed,
 110 passed with 15 offline (v4.14.121)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 126 boots: 1 failed, 110 passed with 15 offlin=
e (v4.14.121)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.121/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.121/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.121
Git Commit: bbcb3c09eae4cc8d33415c29816debbec20a08df
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 14 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

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
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
