Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C051022C8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 12:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfKSLRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 06:17:07 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39794 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfKSLRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 06:17:07 -0500
Received: by mail-wr1-f68.google.com with SMTP id l7so23326386wrp.6
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 03:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pmLBujEphKkpDcEb0Ulnil8Cqx256T7mYb2KwVCXUZI=;
        b=sHP6bfpmiz2ylEe+M6v4A6U7U9S6RcKXY2paJUe4VpORrKrMoiSPpZi668R3pm3XvR
         wpGW76VzM6MnvJYiEhi+zJxz5ZAfaYnypUoypenitZ2XAZhMI2VdSitbO7mff72TQDgq
         IhmrAg15Vr9V+iXf37wxdwOSdz0isQxz3D63lD8S4OkeA4QY0rLMv9s0+MZwy+sw4u6N
         b/Vm+1GNi+ApNP3YpDqvGT9gBFhKm+AFrad5rSkJFRYGnp9EiMTwis+uvmcvB0A2iNiX
         2TY/Wd5JIk06CAGlsI6smIL0RIwc/7FyV38SGfaCMbr67sE4aR9RGXqve/psPB6H0Lll
         8y1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pmLBujEphKkpDcEb0Ulnil8Cqx256T7mYb2KwVCXUZI=;
        b=MAo2/y5j2fDavO8jcWkG2cg3ENEdFD5JfbFThO7rAjCkPmbkLxgHoa6bxBr37zTgEH
         f+cQ1B1rl9VIvIJnkzFpJ17O2l04MPTTBTmh5QDm5RLOPPJnOtFt9YDY7FjTFLtmrENb
         S6mvnHuanV10N852OWM6WTbmzY9hua7kiS0dA5E2kOA5qbcHA3Rz621vw+r7neJ1EcHi
         pJxADGrAXWA+e2HNxpc6CW/KBOccBXZi15dAAPSfRO/2OkHMZ1x2zfOd+GeUODkNOmV6
         FgHJ5NVnp0NqDdpWFA5PvdBEPrg3e5+9R10W2VpmedqzfHAp+dphXndcOb3wSX/CkWHP
         lqMQ==
X-Gm-Message-State: APjAAAUGwYLtCXfTkfiJgRmik4FyxTWGv6SPwRi/8iASGROfIrJzFzRf
        6go7BGSsMcH3gGR3S0ktVmUYplRmya4MBQ==
X-Google-Smtp-Source: APXvYqzW9qkqK5PFS4Eg0kJ4vYfuvP3DAV3v4VaHYQY6CfOZekXVd7CvD95l4gm2Gma6RR0sc0SxYQ==
X-Received: by 2002:adf:e506:: with SMTP id j6mr37259979wrm.19.1574162224162;
        Tue, 19 Nov 2019 03:17:04 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z17sm26315760wrh.57.2019.11.19.03.17.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 03:17:03 -0800 (PST)
Message-ID: <5dd3cf2f.1c69fb81.c4469.d810@mx.google.com>
Date:   Tue, 19 Nov 2019 03:17:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.154-240-gab050cd3bb84
Subject: stable-rc/linux-4.14.y boot: 83 boots: 1 failed,
 73 passed with 9 offline (v4.14.154-240-gab050cd3bb84)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 83 boots: 1 failed, 73 passed with 9 offline (=
v4.14.154-240-gab050cd3bb84)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.154-240-gab050cd3bb84/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.154-240-gab050cd3bb84/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.154-240-gab050cd3bb84
Git Commit: ab050cd3bb84dbcaf833a1abd102e5814a2112cd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.14.154)

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.14.154)

Boot Failure Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            mt7622-rfb1: 1 offline lab

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
            mt7623n-bananapi-bpi-r2: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
