Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5BD89A17D
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 22:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388193AbfHVUyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 16:54:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34869 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731775AbfHVUyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 16:54:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so7075973wmg.0
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 13:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7pneTNGR0EVw0coJhkXhUmYqmrHW6DiyxpIB++RBRhY=;
        b=ZlzO6pTQ53gkiipu1IY3OJ1e4dt1MGEqmMn7YsvrmfGe86BaU/xQqA6VR5yluGMGc+
         La6jEiSmD63j8KBrUXicWvhMa4ZaNvlkb64erFZgjBivabMHRDiwGOoBcMw/43PEOE7t
         NOFdXZlNO88f+FcqyO5hYjTaeiJcGtGPgqCutRmHsqqQ4aPz6FJD5V35nlqGqhzG/V9t
         n2w4wJ6Wbs/XTzJkOp8f7r7pMs3cu7MOwVfud9PyXjntxrWmrGmG+b2lhlbjSUtt8i2v
         LT8Pub/iirRt+46ruEadkZi0qm/yMy2YayS1kETWfLqRB3kw43sWFDtRnmed6yPuog5P
         YOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7pneTNGR0EVw0coJhkXhUmYqmrHW6DiyxpIB++RBRhY=;
        b=CRulmwY1B4dy5neI6vsHL4n+OxAEwCvwMXV0NqGqi2F9+7DWet1FIwr4Sb6sRWMcgN
         9tdp4cTai3p08x/1GlvWOFEmgqVeE+NCnO3sL8vKBPjlfS8Wkk8taWFeRaNKaXd4yVVj
         zXj12WcbAsP/uOKd8czMezLxI1B1hr7jxE5v1muhJJKTG5kODGM8WzdmfTev5udb95Xk
         339ZFX1STMjuDXb9w6qrkvqssVa/bAfVdWecCyK/PM4LNiL4iseBPJE9x5c/QER6krBm
         B6k/EDAoc83htS0qDfNJliSWG75H16d6jtfDX34uWz/4SHAGiW/4hhw83NVjZ4fWU37l
         p8Ow==
X-Gm-Message-State: APjAAAWr4zjiv4eLQdx4C0zwV756Lb/b+my5LlF2NXW7MwDdpqT+0Gzr
        wi9l/ruT+JEAB+k1AXCrXGBNqtFAeSidiA==
X-Google-Smtp-Source: APXvYqwhAywdsztN1ilx1sd8zlhFS/L9s5QFeNAhl+KfygSeqXhqSPqMo2n3hMmm6mVhDaKYGyAgIQ==
X-Received: by 2002:a1c:1d42:: with SMTP id d63mr1015569wmd.34.1566507254346;
        Thu, 22 Aug 2019 13:54:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c15sm2007375wrb.80.2019.08.22.13.54.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 13:54:13 -0700 (PDT)
Message-ID: <5d5f00f5.1c69fb81.b7f85.a65a@mx.google.com>
Date:   Thu, 22 Aug 2019 13:54:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-79-gf240767af21b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 101 boots: 2 failed,
 86 passed with 12 offline, 1 untried/unknown (v4.4.189-79-gf240767af21b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 101 boots: 2 failed, 86 passed with 12 offline,=
 1 untried/unknown (v4.4.189-79-gf240767af21b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-79-gf240767af21b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-79-gf240767af21b/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-79-gf240767af21b
Git Commit: f240767af21bda52764c5a9389062097546420f1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 19 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-75-g138891b71be5 - first fail: v4.4.189-80-gae3cc2f8a3ef)

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v4.4.189-79-gf18b2d12bf91)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-75-g138891b71be5 - first fail: v4.4.189-80-gae3cc2f8a3ef)

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

---
For more info write to <info@kernelci.org>
