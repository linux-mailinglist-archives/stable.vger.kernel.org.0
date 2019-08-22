Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC2D9A3DC
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfHVXe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:34:27 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37288 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfHVXe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 19:34:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id z11so6943717wrt.4
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 16:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rSeTzG7ra3zoQC+ZNjMLQKVdlxRhFsbidRFW3HeL6t0=;
        b=jd7RP2Ecst/eToEElp1ABC+561Q908ogvQ1lit0r1u95tZFqsX1pThFBfhry+PP+hR
         LWh96jx3+1xXwMgh/JbguCrJ87PaeIYDUA3S0LEWoktieCb7F5eRNmDoDe/Vh+t+WAVF
         QPP193HA9sJSlNSPlvcdavs20VIwlGna9hCnUqv0czvH+IgFudTU2of+9GMYxYSc4Kzv
         U8+JnLP5z+S74WiAXNQMq1bvvTPUXficHObcOeiHHskgkJe/l0fM3bnrpVb/pHH9bjSa
         ej7N+psDzuFPVcVLgltgp++5LaRtD1jFBxIUrf28NmQFNEpeaymJ3r94/gQGlyTqthYv
         LgHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rSeTzG7ra3zoQC+ZNjMLQKVdlxRhFsbidRFW3HeL6t0=;
        b=V7G2QutLw99wS4NO+SpoY50uWvdIw1J6i7JhZCt+L+pm38LDFikKU5hlLk0ew3zpBx
         /h9u2vWnmd/kbcSOuu30UKjSSK7KipiRKjvcdrrDSoJbYbFY2N+NAytEHDwGr58A/Vq9
         bYc7cJRngXFNSas1QIqqYdYFUm0IsVFsc7mD6XgbhOwsT4X1FdLGBJvAhLqx1iD6mxRo
         de78ysMlKZT5ERkUej0nq+zcYGAoLkgLCvAubXUlRMdvUZCWva1zC/P4zoa0rNtd9HO6
         MzNkuTSCYf7BCS1lN1/NofMQ5/5rT+4EeNvOTTAB0LwZEq0EPxRMgMegtpjwfczRDdbS
         Jphw==
X-Gm-Message-State: APjAAAXp6gFjw3QI9jCXZN7tN9lIovYztzZ03QBikh01ynA4xNGEKUdD
        ri17RqkUuCOth7DKoHBVWIOz51jHBiiKXQ==
X-Google-Smtp-Source: APXvYqyRLZlSa9/NlfMGqVz20zJaNCB2a1eYoCdmRIYW/bZqT0K6846eHUfwg2drrVT5Qs4xRKbZzQ==
X-Received: by 2002:a5d:4101:: with SMTP id l1mr1383114wrp.202.1566516864717;
        Thu, 22 Aug 2019 16:34:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e9sm775810wmd.25.2019.08.22.16.34.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 16:34:23 -0700 (PDT)
Message-ID: <5d5f267f.1c69fb81.a8e73.3a43@mx.google.com>
Date:   Thu, 22 Aug 2019 16:34:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.9-135-gf5284fbdcd34
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 138 boots: 3 failed,
 117 passed with 17 offline, 1 untried/unknown (v5.2.9-135-gf5284fbdcd34)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 138 boots: 3 failed, 117 passed with 17 offline=
, 1 untried/unknown (v5.2.9-135-gf5284fbdcd34)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.9-135-gf5284fbdcd34/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.9-135-gf5284fbdcd34/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.9-135-gf5284fbdcd34
Git Commit: f5284fbdcd34b923c32f702a0d46a00b9e744d71
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

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

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
