Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316029163D
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfHRKvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 06:51:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36511 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRKvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 06:51:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so5747864wrt.3
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 03:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bj0nfUYB+bP6udobIt017O03L305y5orVskQ9hgzdeY=;
        b=e2C9cleFFCXzksHveQiBMtcN/iP0z4d2nOwu9r2r0JfZlAnPabE3ackF0BilDvfaQc
         F6FwRP2esihnklTuIjTnx/Fb9mosQbCnvK+QBjEKUDcul5Yg7lDiEx0uACi34lbq74xp
         TZNKp0oerbQMJPs9qOLlVbtJF2N9sLZurFzclMfu3ywZxaCNOidg0HIGI05X6OMyQHNB
         rz+2Nw1qEb1suC2koy3FbTLsBnyPgjNIcnIGhPQE8uLt4w2WTJ0ttQBJXBrhuQeAsTiJ
         r1InZ0/NuVnqQHwGdSEQIxmcMLFYrKPQ/i+TwNH1aAl1tIhuMc9BJqHciKvyQuHrwKO4
         KGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bj0nfUYB+bP6udobIt017O03L305y5orVskQ9hgzdeY=;
        b=jk8G55luSUwP2NhLoGjJdWRX4y/yVG5ja9UM5PpyWPeojUg1SxUNBnq/shC38lcyYM
         UOozuBlFoUMILfYuexkupm/nHiOr6O4TnSPRWb2EGRu8K+FNZo8Tja5aD2kdbkDhBJwt
         saSGyE37oSCzv8r/lhvYy8xJS9014M2P+bc2TrCHovMn2OdIAotBbqxnzsNF0NDeKTj3
         3qbSAq3NL5WK3Jh/Lru2ZxAbhWmauhsMImmzygTdnB7RSaaq4+4CyX23JXzzMuVsyyoD
         u3m+Kk7dEbYTmY8nI3m+p88t2rZ07CiD/PrfCrsZyVyC1g5gdCvBTsVTuTAdT/t8Bokl
         ivWA==
X-Gm-Message-State: APjAAAX0MKbBPdoCWBcdd7dKMDxgAZnh4qGStPlNADCnckdEXgGP40T+
        BwuTGU5X9IXC15j6dx6RW1vev6B9vns=
X-Google-Smtp-Source: APXvYqy1bOThEpJncrAdzMHt2QiTVytBzCrv6zSE3VT7owZAb2LvcwZwyKOyr+pQlfUh/1mZkryZNg==
X-Received: by 2002:adf:f042:: with SMTP id t2mr20569487wro.139.1566125495576;
        Sun, 18 Aug 2019 03:51:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u7sm9421372wrp.96.2019.08.18.03.51.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 03:51:35 -0700 (PDT)
Message-ID: <5d592db7.1c69fb81.8ef63.d0af@mx.google.com>
Date:   Sun, 18 Aug 2019 03:51:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66-117-g060dc63c0495
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 129 boots: 5 failed,
 104 passed with 15 offline, 2 untried/unknown,
 3 conflicts (v4.19.66-117-g060dc63c0495)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 129 boots: 5 failed, 104 passed with 15 offlin=
e, 2 untried/unknown, 3 conflicts (v4.19.66-117-g060dc63c0495)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66-117-g060dc63c0495/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66-117-g060dc63c0495/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66-117-g060dc63c0495
Git Commit: 060dc63c0495b75411806f6550187ff1ad44f72f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 27 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab
            rk3399-gru-kevin: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            imx6dl-riotboard: 1 failed lab
            imx6q-sabrelite: 1 failed lab
            rk3288-veyron-jaq: 1 failed lab

Offline Platforms:

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

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        r8a7796-m3ulcb:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

arm:
    multi_v7_defconfig:
        exynos5422-odroidxu3:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

    exynos_defconfig:
        exynos5800-peach-pi:
            lab-baylibre-seattle: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
