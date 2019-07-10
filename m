Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7886469A
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 14:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfGJM7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 08:59:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54215 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfGJM7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 08:59:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so2223187wmj.3
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 05:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZOo7Yj/qFSmNF/ymUS4LJW3j6BPNfdTszrbvU+MgKNI=;
        b=B17Su9eQMnA179uNhtMRH4UwA43P8unVCXs1fBdgtAim0FbHEE5NONE23fwJkvq3qj
         Cv4ppAST4WM+SC1icXwECunnxacqAXxI6jfCVBIc+FV8eiNSE3BJX2qaU3B2/XhJPNTL
         tgdK891I5ldyPcgQ3SoigRfWocMRwvE42RZB9An854Y2L5Xbsf27DHEjhCTVNMtjEXws
         CiABk51rBBCa4ipIzcz+FG7Cpsa65/Wa/XgSOKUuldBVtksjR96sa0y/aF5uFF0boGXf
         x3uHaVzGDzK4XGV3DN2GEtP94o/w3LKgbaAH+f+rM8sW8oHo6n3oSSD/MMoLDFxuDIA9
         5kBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZOo7Yj/qFSmNF/ymUS4LJW3j6BPNfdTszrbvU+MgKNI=;
        b=m8xSKyUSPDv48m3X5iNQj92KKmj17feC2uz9VjzUGxd1Y1n9ZrPAowL+BLoCa+JClX
         n36von/SRfhN+p/eUsFocixgzkUquedSDHfCOeXNFJcuISrktSzohHeqfy5rPsSoiAgQ
         kngFEZffrjRIno5tt+NyuKV5Q1J4D4ly9unfvpVUPsr7A+FWSKUXMaq+K5Lks4Jmrm6S
         5gnGxIBDanFzalbPp7eePfIryyGKF8YKMRoiI3CfJDSNTemzCx7/EBiR8QaDWnAotRwc
         9uuU6NRFlW74HOJ705xcXQTqLVSIv/iAc0vEwIwhZKuhIf++ZZSuYaFsBjZuLeAk2kMF
         aO4w==
X-Gm-Message-State: APjAAAXRdBd2v2rtt+gCJGqVzvulp5zfY86FnY/mnDTyB5CQHkanyzBG
        3sq4bOOgSnuFz6bs0Sj87sS8nDtfNYdaAg==
X-Google-Smtp-Source: APXvYqxBr9DyZpDq7/6Li0Fwdtu9wgN9IFo1JKduUrUUo72hadEHIEFsqSE84hZH1xjh02XVTMXy2g==
X-Received: by 2002:a7b:c745:: with SMTP id w5mr5307401wmk.21.1562763563146;
        Wed, 10 Jul 2019 05:59:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t63sm1680350wmt.6.2019.07.10.05.59.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 05:59:22 -0700 (PDT)
Message-ID: <5d25e12a.1c69fb81.4e1ae.921b@mx.google.com>
Date:   Wed, 10 Jul 2019 05:59:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.58
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 70 boots: 5 failed, 65 passed (v4.19.58)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 70 boots: 5 failed, 65 passed (v4.19.58)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.58/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.58/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.58
Git Commit: 7a6bfa08b938d33ba0a2b80d4f717d4f0dbf9170
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 16 SoC families, 11 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.56)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v4.19.57)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.56)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v4.19.57)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.56)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun8i-h2-plus-orangepi-r1: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun8i-h2-plus-orangepi-r1: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-p241: 1 failed lab

---
For more info write to <info@kernelci.org>
