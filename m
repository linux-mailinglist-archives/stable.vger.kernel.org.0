Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A95899067D
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 19:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfHPRLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 13:11:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36405 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfHPRLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 13:11:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so2224803wrt.3
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 10:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NI4YJ+GmUms9a2VvlpLISi8cv8GgECbZ5fsJbUfwM40=;
        b=w7qJDIaSNigLgaJv/w/O5aY9gQwq2ri+oZKvGnOqU02Z1Sw/4z7+uz1+rkYe+qaaDH
         Aq4hFjBOHWX8+kghcenGwimBNXd1JjmRJLtULohbwxjhF/VJFxi+kT3/unKwna0Ropxt
         Evzs6kvBJP+zHZbmCj2kwYq0KyWk32P8ZkRU0T8WoF9tsHL8g1rnLOaaCSTx3QxrWUOZ
         TlGBKZLGiErCvwfnTROyajOfuAFJ+g0XsW063Z0n43sgIQUvrJGGGZnyB/2SEtXbMMGW
         f4Nrk//2J851LqtRp6hp0VGHePENYmYOifgVszWXXCQRoTElhe6/gtBAnWT2HAZG++jt
         aosA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NI4YJ+GmUms9a2VvlpLISi8cv8GgECbZ5fsJbUfwM40=;
        b=H2wPQ8ty7LVOW5FQhaJZk2CQ74R7NuINNf6R3LdstUJZufIB5mWdhbgvrv+buJUq86
         f9DMygJHDukcFOlIiAyTwfgwZntyjWTVpcV9KqFq3fe5nc94/fwQ2V1B0OsVPkwYy3PN
         5MwMhKVLpXLQ8503iEQRQLqsW2SffxTFcZySHP6Y+4JIrjGjSZaUriqVXyUlZPcgbT5O
         xHNwoabEvOYpkcjao7mSKe8FOgkHJtnWCAU7sHmcclYpuEH48sS1u9B+IlofW5D1U5ZB
         frm74e6nHR0EA+qmCeMY0wH78QP2ab8A5qxO/Nv3kG9zXS5LfathSzLGgztEgee3Yy8N
         69Tg==
X-Gm-Message-State: APjAAAU74dby+gZJxWb33aaI3F5CSF/7GgEvyfdiWUFT+8dH9kr/ewNs
        WzPQ/nlSOp2KRuiNhT+JvaX83MV8uUU=
X-Google-Smtp-Source: APXvYqxIgLey2pGLUWpjmKQn9/y+Qb03mx0PfYCamL4m7woTX4emRQf2z+M3UBeMDs4PafRuCLxyAg==
X-Received: by 2002:adf:e8d2:: with SMTP id k18mr12523703wrn.229.1565975481824;
        Fri, 16 Aug 2019 10:11:21 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g2sm9995959wru.27.2019.08.16.10.11.20
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 10:11:21 -0700 (PDT)
Message-ID: <5d56e3b9.1c69fb81.45066.2c4a@mx.google.com>
Date:   Fri, 16 Aug 2019 10:11:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66-100-g3a10b2060ca3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 132 boots: 1 failed,
 123 passed with 8 offline (v4.19.66-100-g3a10b2060ca3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 132 boots: 1 failed, 123 passed with 8 offline=
 (v4.19.66-100-g3a10b2060ca3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66-100-g3a10b2060ca3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66-100-g3a10b2060ca3/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66-100-g3a10b2060ca3
Git Commit: 3a10b2060ca30843d9251b80a2e1ca71e68035bd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 27 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.6=
6 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.6=
6 - first fail: v4.19.66-92-gf777613d3df0)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-nanopi-k2:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-92-gf7=
77613d3df0 - first fail: v4.19.66-92-gabb1bb8b9ba6)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
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
