Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159AF67731
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 02:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfGMASO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 20:18:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44618 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfGMASO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 20:18:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so11505426wrf.11
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 17:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jBVsHFCBQCTICJpli+8t8mAjinX9sSz1RMmkwf37aJo=;
        b=NPkxWJ9gJ86t3eac/s3p3S+9yZ4Agvi6DA4s6qlDbPBtk5+SJesbirDIP3Tdu6Rv2E
         FdsDdVVL5+DHV5sdk7Ydbtj2FPN1lYyY1JWhE6N5wcGheQbhSD/MoHFcyqIS8+wp7N1K
         9uiL3MnDdvptx4hF91sAQUtxiLiqQVztTrXosRG5dJXmsJ+mw7GXUFUdt+H5u5l5p5B0
         UgSBGOx/x2++V1xRCTkufhLv76zhPSZ5YM1tUB9jJqNiMbc5x9faqlfHnUbVL7oMzg3X
         0SNwbOaY0NL0vREjiJAiu1l6ZTvHmj7RyJlWNzA03xvacAsDUqyD+GMhoFjWRa1RpJXz
         15Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jBVsHFCBQCTICJpli+8t8mAjinX9sSz1RMmkwf37aJo=;
        b=IEnn+z8j49X/6pUaDLHnkopsXbHv8kDytuxwHduBzLBAwucM/vkJ9trE9Dc+nUdrTc
         jjuqfbKu8AV85uR/jgebhDdUo4ZraYIyEJYpQgqknpGFKgmKP6WIGcbr5rGnVWVXDDpf
         5Yf5g02xleIE8eeJlLpgKwDOcfKLGXsTs/tkXWDIb0CDhTtBlv6KNdx2bKX6ytb1ppuU
         0Oo114rRnEH9kPiH2NUbVKIN9JRFnBCNCJjPKOfs/tlMdsDDxsDVKMssMQeqVk0xhJy7
         3WAPmAYP0HoHQI2mi+QkRwy4k5jWHR9/mkZIhKrc6/8Pr5ky/1jSGYZimkVjmTKy4tzZ
         hLBQ==
X-Gm-Message-State: APjAAAXACXvWgQYlCL6se2F5zaeDJcSbONel5/t1vxS3YD3HDMiKbl+n
        0uLeoluZp/OioKDwD4CRZNf/OBy9hOQ=
X-Google-Smtp-Source: APXvYqwxjxjYDTkersLTqkR1wHtz8gbHgFePwOKWLEzZvqcLXnj/j7U7RluXMZpA20laxoLtoPNzDg==
X-Received: by 2002:adf:f64a:: with SMTP id x10mr13472936wrp.287.1562977091512;
        Fri, 12 Jul 2019 17:18:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x6sm11232941wrt.63.2019.07.12.17.18.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 17:18:11 -0700 (PDT)
Message-ID: <5d292343.1c69fb81.2f7f9.10d1@mx.google.com>
Date:   Fri, 12 Jul 2019 17:18:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.17-137-gde182b90f76d
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 92 boots: 2 failed,
 88 passed with 1 offline, 1 conflict (v5.1.17-137-gde182b90f76d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 92 boots: 2 failed, 88 passed with 1 offline, 1=
 conflict (v5.1.17-137-gde182b90f76d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.17-137-gde182b90f76d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.17-137-gde182b90f76d/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.17-137-gde182b90f76d
Git Commit: de182b90f76d9beac11a216bcdbe52542014de24
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 23 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-g12a-x96-max:
              lab-baylibre: new failure (last pass: v5.1.9)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxl-s905d-p230: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-g12a-x96-max:
            lab-baylibre-seattle: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
