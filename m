Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE1B57C9B
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 08:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfF0G6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 02:58:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55418 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfF0G6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 02:58:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so4527656wmj.5
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 23:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qiakBNWMCdjSPaSNwBLn+MUgBlH9PyDOMaHlg3+JxsE=;
        b=MIsOZZVK0e/ghqNbJBVwYo2kIBuz0tpUzBcx63A9tVlCaB+4oSCGczyBrn2chiU7qF
         dcYyLxnJFVLJu+zk8DFPk30w8pJY3XCHGLQzUqNpgubN+smRZ4jXHQ5gO7tgRrssi/15
         7vdT1LvvYhLkufdYu9Ft4BDrKF/mB4lghNVRLINT8FEmuJ6kJC6KwFHksqUEFqnsJhlD
         PLYuFoevXCZGubaob+ogTjhqjQfdz+hUfydNDLmdexxTUqIkA/5+FGNLA1+PwkHDde2Q
         08dZs5e+zgBqi2XZtpjRrUQya9ibF2pNjJMaqyc0OM2LHoLMDfA0A1R19+cG3NZHXgv0
         /Cdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qiakBNWMCdjSPaSNwBLn+MUgBlH9PyDOMaHlg3+JxsE=;
        b=czvhZPCVCSCOkVATBPJl3LQUHYaZbYPNH8xDofJ94lY6p1o1wMUO1ne8KKwibYPGzx
         uvu1v+Y6x5TX77gvUpI4riJO0fCJQHp+7KDmPNK4sssLu7cY+XOZB34lJ3qwBFrGZZyF
         u8roaNZ2VlDQShqgruPSkYP6aI64BrFAmt0zu14yEVboho9T4m2m9HW38O9s245XEhAS
         YvA8g5edFB6Rm8upctksuFC2yOYDV0EZFENVhCjj7/bIXCfCUipRDoeQzRhyXtQXv27n
         t9DHZHtki/OHPNOwVkF8omxO9aJOgNVYpDY2TZKSPWZrvPSricr4Ea9m2fY4VRzYhYK6
         smVg==
X-Gm-Message-State: APjAAAUnUlkq4TidgEpy3HmBEL+45vbdTgfyZM4Fr2jU60w3YxZ9/ixj
        qWAl8sEOOa/rA8MWZhTMoojWKC6rWizEYw==
X-Google-Smtp-Source: APXvYqxRkTqRNsEamkGlVWXn5MmytLN4h6dy61vFSegAvu3SNjodvgXm43kUIHCwQdQ5m/mw45xTZA==
X-Received: by 2002:a1c:4484:: with SMTP id r126mr1970056wma.27.1561618694019;
        Wed, 26 Jun 2019 23:58:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o11sm4862190wmh.37.2019.06.26.23.58.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 23:58:12 -0700 (PDT)
Message-ID: <5d146904.1c69fb81.5c66d.9f6b@mx.google.com>
Date:   Wed, 26 Jun 2019 23:58:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 97 boots: 3 failed,
 85 passed with 8 offline, 1 untried/unknown (v4.4.184)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 97 boots: 3 failed, 85 passed with 8 offline, 1=
 untried/unknown (v4.4.184)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184
Git Commit: 72d1ee93e9311c88809585a114c138bc6a43627a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
3-4-g393ba32583a8 - first fail: v4.4.183-2-g5f1824292521)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
3-4-g393ba32583a8 - first fail: v4.4.183-2-g5f1824292521)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

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
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
