Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A891843A6
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 10:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgCMJaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 05:30:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42929 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgCMJaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 05:30:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id x2so4509085pfn.9
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 02:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a1wigKj0W7DPQquukCnCfuDCVFuGBnNi894xmOF82vE=;
        b=RBMvdoxdNIvsncysdFm0ixLuj8uHIogUCmd97ZyHpNhaEfvOiSnuzvsr6fPA9EqOBX
         me8tiDkYlVZawvNgpioJLhwRh0tpmI7jaOErtZ/L1U8xDFqLNSeiReMJSNbzVPY4MiBl
         +M4ITOmWriBbiGuwqcVYkpLt1GFoJtBvfzxVbGTonqtevdc+n+QfKrzv8ji8eQJ6Rrcs
         jGkV72T900zl1g/BKLWH+gNRq38tw6vhhFk+aMAfAB6zLFxbOec2REQNE4KaO+L8izpC
         bXxlYj9l/OhF9V60JjVLPc1l7GYSrm10Xk8t9Fp9HlNuLx4D3ssch1ThcCAYODsdoe6x
         jr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a1wigKj0W7DPQquukCnCfuDCVFuGBnNi894xmOF82vE=;
        b=WvKDYFbPVVw03EQBs5xQPSxhUG8rTwhDOjsp14qKfNwZNFBhfYxfkQLOUO390e63P6
         ojIn4UGRlbve4mqvnhpEAcsCztazhSJfJed/kIbGNapaZy/kQts/H6VYsfkPWkHhI2TO
         E+K2mBTv06LK0MN2U+NQxhguiLlDgaFo0HJWi7uQTd2I7SvImr9TQYmKQbqAOGkdzIBO
         Esbemc3aekKQBTn7uYMrevttl2JeljEYB0bHACZOPZrJWngJ0sR2LeSAB8ez05lAMsM9
         um8Lu9jTJLLFp8cFC+BFCN1wTRxMK5qGyDayk3qZJStkt+RqsbLqxpWZTG+K6n3moCXd
         75Ag==
X-Gm-Message-State: ANhLgQ2EVJHHfBXKwzYc16QorJmO1KjIGFH4dbhiKR/QNd0pBbhnJtvj
        4KoiGVszXOuN8Fj3YSW4g4Kkg2mftOU=
X-Google-Smtp-Source: ADFU+vueRna26btyxLl3AJr5i10Ok3ku/JTv+Qt0gcdK7RpwNBZ+8NMr0NcXxfeapDlYEbYERLTBfQ==
X-Received: by 2002:a62:e211:: with SMTP id a17mr13393145pfi.198.1584091811176;
        Fri, 13 Mar 2020 02:30:11 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l26sm25417373pff.136.2020.03.13.02.30.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 02:30:09 -0700 (PDT)
Message-ID: <5e6b52a1.1c69fb81.9607e.f9dc@mx.google.com>
Date:   Fri, 13 Mar 2020 02:30:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.173
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 90 boots: 2 failed,
 85 passed with 2 offline, 1 untried/unknown (v4.14.173)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 90 boots: 2 failed, 85 passed with 2 offline, =
1 untried/unknown (v4.14.173)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.173/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.173/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.173
Git Commit: 12cd844a39ed16aa183a820a54fe6f9a0bb4cd14
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 20 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 33 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 22 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.172-127-gc23e0b0=
dc693)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
