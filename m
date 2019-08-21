Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3AE982CD
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 20:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfHUSb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 14:31:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39095 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfHUSb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 14:31:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so2977419wra.6
        for <stable@vger.kernel.org>; Wed, 21 Aug 2019 11:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8SO+opl+zAnAWNr3gogpABPqjzpL3zXqsu4zw5Qy0SU=;
        b=Gh2tMpBBIC4zO6v+ErAaI4QDYtAspli0QX8FMMYZ4kVIZkYp+jK2/D4vnTyc3Bl0dt
         ErFg4GGMjcsfjFNvhkavbXCtLnH3Nf5FoHnpv2qsi6JrsOEhVml18TUKCmjIpJ9aDdZB
         xtAEOljQUWuVGV0Z2ZMzheHacT1T68d7tC1rWr5rmHAykpj6T/n5r+PnVAV+0YKXuyZ8
         rXyZEi186DAG25IzoH7mrtUPR0MSCfHWC7QXM/UkdkDa65tkyTmlUuVI9puE9f4NbFvW
         ifad04zx928OLrYwpmTqC6r5slf5FK/MG2BqE0s7Kgj6h/7n36vR/WMiwnsiBIb9AwIr
         088w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8SO+opl+zAnAWNr3gogpABPqjzpL3zXqsu4zw5Qy0SU=;
        b=bTEcmN/p41LBys40NIunSdwPx55jTxbKRjSPwtLO0g4W1+WBnR5iJF61gSuhTOkJdc
         S4HRxn+WRgumyeMqgl9eQFQVwdCOQnJk9NE4m0pFutEM707okOLd1FTqgZlw28GnHIfT
         1XSY1hoBzQLfhRLm53Y57+bH4ArdIN4+ZbBTaTW/Xuz10HyyWtvDBrHNYC6UZzoL3rqQ
         o7pCBBU+khfYMsFVi+hao6ZOgiYgTOE2uqNHRUM7hZ5U4gZyP3JwTYZdODh/ndmj9ff5
         29OTYjWzj3D7fJNK4GY3DeH6arRpckLo3xAR5tc4LgibxUbd/zyHLwbsxq+WM62pgVP9
         5nDg==
X-Gm-Message-State: APjAAAW4kdrk6ki3VpTjA26RZLp9zIoqF55hPBGaoSZ1n8uSPNk1qxUX
        SpfoLDQxn7y6gKT455XN3ZvKQqX0cWR0gA==
X-Google-Smtp-Source: APXvYqxvwDtFT1ZpOp+8+RaPyMi20DlDdWib+D7P3Itu8Z3lFgyMSODZHVmD/ZaSkI0lb8egXWtHpQ==
X-Received: by 2002:adf:e94a:: with SMTP id m10mr34120668wrn.245.1566412286368;
        Wed, 21 Aug 2019 11:31:26 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u186sm1760072wmu.26.2019.08.21.11.31.25
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 11:31:25 -0700 (PDT)
Message-ID: <5d5d8dfd.1c69fb81.d12d9.8136@mx.google.com>
Date:   Wed, 21 Aug 2019 11:31:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-80-gae3cc2f8a3ef
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 98 boots: 2 failed,
 83 passed with 12 offline, 1 conflict (v4.4.189-80-gae3cc2f8a3ef)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 2 failed, 83 passed with 12 offline, =
1 conflict (v4.4.189-80-gae3cc2f8a3ef)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-80-gae3cc2f8a3ef/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-80-gae3cc2f8a3ef/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-80-gae3cc2f8a3ef
Git Commit: ae3cc2f8a3ef3c529b3d8b981e7da05b2b2fc8ee
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 19 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-75-g13=
8891b71be5)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-75-g13=
8891b71be5)

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
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
