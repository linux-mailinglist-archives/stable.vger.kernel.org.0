Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C5C102349
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 12:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfKSLhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 06:37:48 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35739 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727557AbfKSLhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 06:37:47 -0500
Received: by mail-wm1-f68.google.com with SMTP id 8so3186283wmo.0
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 03:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZQpO1iO3m4MmPWlKOsrOg7w+/ReoqHz0s9xrlKZvmlU=;
        b=y3+WlFomBz0yzuCYYxGKF0YMSxwawpZFSXhTyOBtN6yY3PAQ4XWnvE56ZfKHF7/j7Z
         vKK2yL88ecUhudIrOjd+xYUl2fQDf8ojojbda3u5ssNAKlkMVsyOECopaZidRKXbO9o1
         mNtC6L9SM7AyBr7kMU8pC078YvsXNX6nbVyw012u8bDFvE+zC5YAUamaeddbX+Go6WJN
         NXuXM6Z0RdDzPm9ZLK2ft5Xi0buxxMZamqXRYE2X2W5AA/RvMD3qePXeLDIwtP4v/iTF
         kOl4MPIzA+wjUELMw6AO0CCI0JBB53wrItoY2IdkSH1FBhSZQGITqk6tJvMnoMRdShAV
         qJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZQpO1iO3m4MmPWlKOsrOg7w+/ReoqHz0s9xrlKZvmlU=;
        b=BFxWTNnydZKBMYYbGa51I1xOTplBa+JoUQjxqSANr1Zu3pvKqBO6WM21cIuy5jouQK
         WFqnCX4BKHe0qR5AXxBHC2BHhM9z1Q4AjU6l3oqo5irhcJCZicZCxs3XPoPkM5CH15dQ
         VEK3UBniLy1iWJuQ4cOpKN4QAJKrjAs+MFIYPSMOZGEgnIi/pvINX6zTT5x2IE+L5HE5
         pweK3UsQqKLRke3UhmDK1dKgRuN7ZC+LrK5xCN/ngm9pOnxeCT/Ww9hX2D5P4k+bOV5x
         P0lTlY7IzWzGdLkb0R37oV65MipchNho+59Ocpvygs8j7JGfXos5GdbbPlS9JcZDqVwK
         FkpA==
X-Gm-Message-State: APjAAAWs5nYyLHckaOLH7nUfvye7EmjJGC1Lv1eSegnobwrEnaDe+zk3
        O7BA86/JhbhJKF/spi7b+noPUy+dJXbgng==
X-Google-Smtp-Source: APXvYqwU1jD1L9YebKmp4xQjRnWVMV4/Gw9cBoH1ECEbqJ5l9n08S6jXAFRYpSaOztXvD2tL3AbRNg==
X-Received: by 2002:a1c:99cb:: with SMTP id b194mr5323943wme.100.1574163465858;
        Tue, 19 Nov 2019 03:37:45 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p4sm27696366wrx.71.2019.11.19.03.37.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 03:37:44 -0800 (PST)
Message-ID: <5dd3d408.1c69fb81.c2258.3da5@mx.google.com>
Date:   Tue, 19 Nov 2019 03:37:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.201-180-ga01b8802acde
Subject: stable-rc/linux-4.9.y boot: 78 boots: 1 failed,
 67 passed with 10 offline (v4.9.201-180-ga01b8802acde)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 78 boots: 1 failed, 67 passed with 10 offline (=
v4.9.201-180-ga01b8802acde)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.201-180-ga01b8802acde/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.201-180-ga01b8802acde/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.201-180-ga01b8802acde
Git Commit: a01b8802acde97795921ca736e348541c0669c94
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 18 SoC families, 14 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.9.201-32-gd7=
f83e4f45e8)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v4.9.201-32-gd7=
f83e4f45e8)

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

---
For more info write to <info@kernelci.org>
