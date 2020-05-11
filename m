Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3047F1CE0D1
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 18:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgEKQn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 12:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgEKQn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 12:43:29 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91A2C061A0C
        for <stable@vger.kernel.org>; Mon, 11 May 2020 09:43:28 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so8048764pjb.3
        for <stable@vger.kernel.org>; Mon, 11 May 2020 09:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t2YvUZ+6AkZ4jmk9XyVqlCqkrY5aCDcc6K9Gau93OEA=;
        b=mkMMBRwf2aFrpxCCatPiuaNKKHNnGKkiPGt3dSA4c40hn6hf4CTwq0ol1XNgk7fsVu
         IU5ZdLnUNhZHk3+5InRk7rgiYWDuDTMiUHlO+HvPHIBRZ/Rxf4JNOiA4Mcp0Sn8k8FxW
         0ZMyTY/lNplWNdbs8bH+vf7fYl0wM84B+6RqTjjx81TPd5iBwGkGYPMZa+ACF+MUzyd0
         lU1iVW5YYLY07y9SAoj8R0Z4tWJfQ5N/1yh4PsCaT5wKMbK1ykL54H1STwmOxhGQtKRH
         jYzAopfOcakV3DqcqWN0kwbToEQfBIuihLfJFbfcUqF7qHfC4blySpzI7gwE5g4mhEQq
         w9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t2YvUZ+6AkZ4jmk9XyVqlCqkrY5aCDcc6K9Gau93OEA=;
        b=fSzIqGGl27fLkFLMS1Q1hq0NCqj7iR+6QabESMErYqrDmmd+YV4ZRR53fwrIQVpNc+
         EdEuH7tX1KdSIomwn5SzkS2pKLDwULfcpd26oJUUdKQHu1lbjeIE7mIi3OBTl2TFzZ0O
         hlwS0wuTDy5I9PRElL89bN2CcakZU9UiigZ4eCsImxzOu4PQZoZb2FJvIj7he/bZ7rZK
         CvaW5HARvNQdmPgBaFodMZHBc6w18FE1ZOnLu6cf5MZqgJV0lTqFLcYveKMsc04+2Qke
         cEflynZO/91kzdbJAv+Tm2nTGpMp0H1TLuju/+BzlsgPITXKiCwGIKL6DDYLF0EbBHQ8
         Y1Hg==
X-Gm-Message-State: AGi0PuaL4A7qSeAlKJRnfY3UB0+ZsFTFyiU9mEY2d8dX46omOF/WIC1r
        Bro5/JpomRLBFHvRde/c1S/iVpVtGy0=
X-Google-Smtp-Source: APiQypLq5eGMGCBywKUW6cr0X/sdjalAucOxQthDn32wn29rCkOOiC67h0rKRCXqib1V/C7QHqR5zA==
X-Received: by 2002:a17:90a:364c:: with SMTP id s70mr23091128pjb.143.1589215406858;
        Mon, 11 May 2020 09:43:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x4sm9451541pfj.76.2020.05.11.09.43.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 09:43:25 -0700 (PDT)
Message-ID: <5eb980ad.1c69fb81.9d25.2e72@mx.google.com>
Date:   Mon, 11 May 2020 09:43:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.40
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 159 boots: 1 failed,
 139 passed with 13 offline, 6 untried/unknown (v5.4.40)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 159 boots: 1 failed, 139 passed with 13 offline=
, 6 untried/unknown (v5.4.40)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.40/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.40/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.40
Git Commit: f015b86259a520ad886523d9ec6fdb0ed80edc38
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 99 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v5.4.39-50-g695=
621e78832)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v5.4.39-50-g695=
621e78832)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v5.4.39-50-g695=
621e78832)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 33 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    tegra_defconfig:
        gcc-8:
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v5.4.39-50-g695=
621e78832)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.39-50-g695621e788=
32)

arm64:

    defconfig:
        gcc-8:
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v5.4.39-50-g695621e7883=
2)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            omap3-beagle: 1 offline lab
            stih410-b2120: 1 offline lab
            tegra30-beaver: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
