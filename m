Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD4A99FC6
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 21:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404098AbfHVTVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 15:21:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37739 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731916AbfHVTVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 15:21:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id d16so6852841wme.2
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 12:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xVkk2TtHCMjaT/b2A3PDHK+txD20IUwswytGofvQ9HU=;
        b=EhbpnNNW5b12knk0dsy0owhRmUN9ujhXNJjQ84G4xLP0j+cJJIIuRvP1oG55BDQXYU
         c9I+KM+t0zw6SEOT34SJhXV8i6PovwfvCOfPiD5QypzQwGv6ZfRRivCxUQmAWWbQ6Kho
         qqBMBufTOUN+4VBo/N5qeLE5I4FqoqZJR2Ibn4AxgcTe662yPrh39yB2qC8PrVSHBBAW
         k2SY/MVI8KyUtHy6hbtaKnS3zCcNTQF0rIGAlOU6iJCMrwQYMBo4WYSVH0SoQocidcDo
         up4KVI1KCj/CkXA/qwlWQ3qraf5C0AA8wzl/zWA3IVX14s047I0uJ6KePXJdy0DXMP39
         k5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xVkk2TtHCMjaT/b2A3PDHK+txD20IUwswytGofvQ9HU=;
        b=IiQLoosX6HrmdKr3WaBnU6Yib55iNwakws+1gWXuTSI/3zFakaloGPvN/C4faAW032
         OEi/1Nhd3q7gV+dMniD8W3kclQrFYL05gAR/WcstXTF69rqznwsSkBCQqU7Ufl9sqE6B
         /7Pru3gDARTVBN6c2ibXRiPY0ERub7mIXkDm0++fYdLPwZm9pfs9xLjewtwFI7VsZ4fY
         Q8ww/2ilyYK3bQOoYe0GyfsPTjX5F96oxrmuiGkwySvVzCqJZ9+qt8wjb31mxA7S4GRa
         yLdnXyOINe5zy2a7oyy00jmACKxBHfOgD6tfv+NE+R1W94UosQgbRYMXNvhAy/Sy2ot5
         WUYQ==
X-Gm-Message-State: APjAAAV3MnAXlrcjjbz996HznaZvLlXo2eVHBABHOGkdkiFjFrZQlbLx
        qMK+kbLVkdR5Ho+WzL2CfFRGocYkpfB+gw==
X-Google-Smtp-Source: APXvYqy7CVCcEEl/xWX1CvGFMrcO86fy63nqYviBdStB786DYiWMtUDg7gvUZ8Qv+psH+7g15uFhnQ==
X-Received: by 2002:a1c:c188:: with SMTP id r130mr652056wmf.73.1566501705591;
        Thu, 22 Aug 2019 12:21:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c15sm1339688wrb.80.2019.08.22.12.21.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 12:21:45 -0700 (PDT)
Message-ID: <5d5eeb49.1c69fb81.b7f85.6921@mx.google.com>
Date:   Thu, 22 Aug 2019 12:21:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.9-135-ge94dc5db6710
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 138 boots: 2 failed,
 119 passed with 17 offline (v5.2.9-135-ge94dc5db6710)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 138 boots: 2 failed, 119 passed with 17 offline=
 (v5.2.9-135-ge94dc5db6710)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.9-135-ge94dc5db6710/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.9-135-ge94dc5db6710/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.9-135-ge94dc5db6710
Git Commit: e94dc5db671071447b4989380ff92e66ebca46e6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 27 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 7 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 7 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

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
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
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
