Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169321CA53
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 16:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfENO1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 10:27:38 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:39702 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfENO1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 10:27:38 -0400
Received: by mail-wm1-f53.google.com with SMTP id n25so3025164wmk.4
        for <stable@vger.kernel.org>; Tue, 14 May 2019 07:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GnCf+iCoyQF6poOwO1vAyWvZ0YgXDKPmwI2YBMj5F5E=;
        b=EbPEnsm3RcX/zOZM64zfE5q+SdX7dQuNho0nytsanJyJPwK4kAQA4fgRF1wxxdGg33
         Pzi7lhsJwdNrhsYTZxekPKEvwx4wRwGi0yfw+BQ0bKvBhVv4m5tQoiLwwKTUyPtEkmYU
         QZ1eCGfq/CbYzQdGtQ0a9jCaeSdrmDgCFOQRsmQ7kSVOCCuwzUVqrOG9TdB5FdErlkeG
         yMk3sJSBFnSUCag1paTHfxOtcLrQfefhIkpFGZ4YoJ4MtcWa5JGvJ4vOWOQzaXD67tqJ
         cqw1/jbDoHUyEljqPCLouSiMzygMkvl+Q9Fzjcj/Ffe2KEGgO/jbenuvPTtgVav+I9x3
         yM5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GnCf+iCoyQF6poOwO1vAyWvZ0YgXDKPmwI2YBMj5F5E=;
        b=a4GeB/XD2ezBZCN2lSb3FA+evD06dhZvqxKE/5mPWsg+xZ6ou7VsR5F5D0kPS6NQiK
         OfqrF8vruCtw1+E8KYReV5vvhHcXggKgGKy/S9pjFQ+NOJ6D1Cf1su4Qlsgr0yvw4hrh
         t4K77RN00PgOaBN0Y4wn8+RUXPhE/FLBZCa0pXs4viPelLN+KZQPMzeAyOTITPiF6N32
         njFZC8jB6DQmWjTMCby9QwJxegGoqhQ58XlvX0zJ/r9y3ShZPrtxJ8D5jUR4CKumfS2R
         Jn4pNYokkixSZtn66ecjtiUt9uvWtTMsaautMjuujRBgLsIzg+VLhsNOgX2yzly9pyee
         yqjQ==
X-Gm-Message-State: APjAAAXg7HpTAjPO8JKNHTCPS2ujvHAXl0FGl3tYdtG4zSiBzfX2g/6V
        ClZlxjg+v32ymbWH/7MYKY2QyC5y9NVy1Q==
X-Google-Smtp-Source: APXvYqwEJTdu5/ugGoVQC2psW/ZRSaLequP8LFv84dTsdLUXHJzlJlkYtwqRLgWDiD0+AMl/dk/UQQ==
X-Received: by 2002:a1c:ca01:: with SMTP id a1mr20753925wmg.30.1557844056383;
        Tue, 14 May 2019 07:27:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 19sm3346142wmk.3.2019.05.14.07.27.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 07:27:35 -0700 (PDT)
Message-ID: <5cdad057.1c69fb81.b7b12.14f0@mx.google.com>
Date:   Tue, 14 May 2019 07:27:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Kernel: v5.0.15-106-gfaddc6604ec4
Subject: stable-rc/linux-5.0.y boot: 135 boots: 1 failed,
 126 passed with 7 offline, 1 conflict (v5.0.15-106-gfaddc6604ec4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 135 boots: 1 failed, 126 passed with 7 offline,=
 1 conflict (v5.0.15-106-gfaddc6604ec4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.15-106-gfaddc6604ec4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.15-106-gfaddc6604ec4/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.15-106-gfaddc6604ec4
Git Commit: faddc6604ec40ecc25d17a782d76f0de82d564be
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 23 SoC families, 14 builds out of 208

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 3 days (last pass: v5.0.14-96-gdf=
1376651d49 - first fail: v5.0.15)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
