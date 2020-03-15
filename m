Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D82918608F
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 00:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgCOXcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 19:32:07 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45296 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbgCOXcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Mar 2020 19:32:07 -0400
Received: by mail-pf1-f193.google.com with SMTP id 2so8857737pfg.12
        for <stable@vger.kernel.org>; Sun, 15 Mar 2020 16:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6jcBqBLDLmXiq8JpaosAlqyxpAPsuyMrP/bYbWN9ZnQ=;
        b=K8E7LSpgBRhstt8CSGJDSmqYR+l4Xc38HAdifFXp6MxbWuY5ftWb/bg8f0XRU1QKYg
         i765UED5U3zpAUrMHvgPc04mn1vns4A4Mb3gAna9QP3cvUcHr6Miih7pCya5TkLJSuGv
         JcqD1f6PxGX9EYLy6RxvCKVdZTGjYNDc+o+H8xwZYKRq87M2mOulEH8GP7DMGDMLRIhE
         JpqT9sYxDLnRgMbuM3nMSRkqYbyWoUgVMQCsFR+ucPNjBJofy9zh4MjbUm1kWAu+hp7s
         fNfNtulHMwZywpCJPV7JQ+GSom37Ln37Qfvz1hVorLsjc1NLhRsnVqPscGRPBPyucipY
         uS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6jcBqBLDLmXiq8JpaosAlqyxpAPsuyMrP/bYbWN9ZnQ=;
        b=fPTnIBsMr4TVIp23dixakf2kNi5pdrZbTHKyDTm5NKBSEe1fEcHtBGKnukuMVt7sJH
         QMXhVaHL5FUWl+tGWphUcCh75NshPd70VnMlbHPUos+eQoadLNRfuDhZIUTYm5qr0PUy
         R9etVaydBkcB7QbvEjJUgMN3m2GNfRcwyrWFvmFCYtcI72CYTq/EDeg/HJboPXTghLJC
         +yF/EgSKYxsmM0zlJbcnHgIQ+EmT0nwHnIN/PDMVZDnpVV2+b8+8R7n+tja2fTL7xaZt
         /J9V2L7Y6ion+LcVgkF5wqrYmtIjN05X7Z1Tht8rFUgI2RoTKHVir5bUdqbPCYGyFzfl
         Yhmw==
X-Gm-Message-State: ANhLgQ0vI+cki0oQxXERylHa27QW7NusjCrj/yeTnLIyo87arZJrqBqd
        Yi+KoTuHt9rcoZhIY+AXr5zwzsQRDmg=
X-Google-Smtp-Source: ADFU+vuG4TEOhL2e64JNGTucyjFVqX1CstqEXHv4FfPt3kP0c4uagKXzLG3Lzgw9TkSlS1yxaTo6CQ==
X-Received: by 2002:a63:d658:: with SMTP id d24mr24641050pgj.340.1584315126042;
        Sun, 15 Mar 2020 16:32:06 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15sm20285298pfq.107.2020.03.15.16.32.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 16:32:05 -0700 (PDT)
Message-ID: <5e6ebaf5.1c69fb81.62c6a.47d6@mx.google.com>
Date:   Sun, 15 Mar 2020 16:32:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.25-58-gc72f49ecd87b
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 140 boots: 2 failed,
 129 passed with 3 offline, 5 untried/unknown,
 1 conflict (v5.4.25-58-gc72f49ecd87b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 140 boots: 2 failed, 129 passed with 3 offline,=
 5 untried/unknown, 1 conflict (v5.4.25-58-gc72f49ecd87b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.25-58-gc72f49ecd87b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.25-58-gc72f49ecd87b/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.25-58-gc72f49ecd87b
Git Commit: c72f49ecd87bfdf12a828d45681d371089850113
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 93 unique boards, 23 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 36 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v5.4.25)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v5.4.25)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.25)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: new failure (last pass: v5.4.25)
              lab-baylibre: new failure (last pass: v5.4.25)
          vexpress-v2p-ca9:
              lab-collabora: new failure (last pass: v5.4.25)
              lab-baylibre: new failure (last pass: v5.4.25)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.25)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
