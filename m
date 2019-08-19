Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A751920E1
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 12:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfHSKBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 06:01:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40003 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHSKBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 06:01:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id c3so8052610wrd.7
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 03:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bq+lXWpTD8OD2kEI+Rf4LLwnr1BJSfpQTEKpBGQxNRc=;
        b=mdYl7arhQf8/xC8l/8BEmC0Tu1rUUMYnKibGbny2AfGPpxxW0q+wwTVc814dlBXhew
         aZpf5n97ONUZHU/9xvTrQsXszuEeTEGMU0y/IFf5Th3mL+irBI+be6bnvPfg7E2PQM55
         flRQ3xT6Zr/PN0sJHVgokKz8BQVjIe9PZ7yNmO2Bx/WKFKD6X4CkCXIPRHaUqLpg3eAO
         HwY7rJ9Fz4tkZNz4HzJnsBCA+cTNftyGi4/qelBsErDefueRbK4OtyqakeWiVF/65zNJ
         03ZL0GZ0jJPUnwxZXAjXHJnKFMc/IoAnhRTo2eQftTzBNU9QIPaIgSR7l/La8B1gZbpc
         dyzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bq+lXWpTD8OD2kEI+Rf4LLwnr1BJSfpQTEKpBGQxNRc=;
        b=XVdNjmFqTqLRMqgYJHjTQ8eq58meCqOXgFgWJCnF1j2MXIAltx1e36+rWOyRrDbD7d
         +/gsFiOOfibOfcFfYQ8svpT6PQEEL75cSLV+nnX7JgLy2aPD03p9IaOxEGeo/dOSONJJ
         p1bT6bkb8MVfssXnLdnsDPidG9lWD1SCqyufcAf46yZGlYywTkGddmXbu3AIKuiUGsSz
         OaXBoNbTj65edT3iiqM6AJo+2cYFCNXrCvR8R9kQDzTpG6W6Co7LpBnmosCTAombPe46
         tBoYo0WvwSA+pmbOjez2McHPfGZ3IQE/nIKADnP5CDoa9db7DOq8KC5T0J/4XcaH8958
         tHPw==
X-Gm-Message-State: APjAAAWv+/kkf2TEPLTBk+Qc0pWlyl8g7Qbnq7qCWCaQ20l+4ZQhPR7T
        6WNwXE6eJL3dPahPvQfRGkkErvztAtI=
X-Google-Smtp-Source: APXvYqw+0oP8PMyeHykDKRpIV9GHLcdWXAhwq7mfCI0oP7X4p86E5rOdQ6nRahfVUZHNPEoaPtVNfw==
X-Received: by 2002:adf:fe10:: with SMTP id n16mr26996845wrr.92.1566208898348;
        Mon, 19 Aug 2019 03:01:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 91sm44599609wrp.3.2019.08.19.03.01.36
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 03:01:36 -0700 (PDT)
Message-ID: <5d5a7380.1c69fb81.84b59.7f5b@mx.google.com>
Date:   Mon, 19 Aug 2019 03:01:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-93-gcb43723042f9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 103 boots: 0 failed,
 88 passed with 15 offline (v4.9.189-93-gcb43723042f9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 103 boots: 0 failed, 88 passed with 15 offline =
(v4.9.189-93-gcb43723042f9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-93-gcb43723042f9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-93-gcb43723042f9/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-93-gcb43723042f9
Git Commit: cb43723042f9d84597a7afb90b9c523000e88dae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

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
