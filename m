Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36671FCA8
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 01:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfEOXGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 19:06:45 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:46474 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfEOXGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 19:06:45 -0400
Received: by mail-wr1-f51.google.com with SMTP id r7so1170707wrr.13
        for <stable@vger.kernel.org>; Wed, 15 May 2019 16:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kPKvbpnRN3oi4XMW6CFRbUDhUXF6rpS8bPmGsf4kzNM=;
        b=hRYTr2ax8tqum1jGJVcH1y9HOptLW12CiZvBcAE1fxRDGVpTWje2PG7cGwN7tE83LE
         dxnhJb8Vh4ER9QAbm3sYJeIen6GCg40UevQjf93mTFs1GyTwxBzkVnpEU5wI0eCNcoh5
         j37X+ocL4qw1AhwewB0ry6Jbggnkr8BM8dFHL8uQGTNKIFFsHZxmlvg7mhUhX1UEN3OQ
         zxZobWuU3G9L7IuPaBLK/mjfqUWGw+d1FYMvPt5PkdINYKPaEBnutZ8E/g1/4sXSikCg
         IKbGJCKz3HvH0KPNCRKx2MWuJfbilzq+bebwSvWJ5tfg6KPzKxGJViblT//U1OGHJ4Tt
         kXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kPKvbpnRN3oi4XMW6CFRbUDhUXF6rpS8bPmGsf4kzNM=;
        b=uen+bkX2dnYQtQ3OIZRWIIRHqoTXm43mSLQ1ANvPDFElgDwWKAnOQL4vG2zJiX8/zU
         rpowbQAQOr19HTwQbCENhsMZA2TJ/v9oLPyRqG1tM8Zm4kcfktGqpBhQyqi+6BURwsUW
         aV9DoWfqigHhXeKLR7NyFy8sP0EsQF4898S2+EBgrBO+p9KZRkQZnaFX6VsJW5ZeOoPY
         K2mm0/hnAiME+c504v65DB/y0dEGz7cwwVTkR9b0LjfGbdEBI+xgEMxNLwcpUWUZK+mx
         uz6WH9Fgux4PnP5LAHyotkqlqUR6xHRTxtWgvbOQvu2xaNYqIxOt8GmEwEUr9jXys2Kh
         RkRg==
X-Gm-Message-State: APjAAAVxNMb1fJ5tc1TXuMLwxe2FRenUSnXnQ0sqgmgNTHg7ITVLSUuV
        isBhScRz5VcV8VmvQP46uQl/rBx9C8M+Nw==
X-Google-Smtp-Source: APXvYqwfJEdeCy++dlapN1MdMxPnE+On8RpJiIdeAftgjzG1Yq0b7SO/vu0S9Hbdvq/d7kELFXS1ig==
X-Received: by 2002:a5d:53c6:: with SMTP id a6mr2922518wrw.232.1557961603179;
        Wed, 15 May 2019 16:06:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k17sm3221242wrm.73.2019.05.15.16.06.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 16:06:42 -0700 (PDT)
Message-ID: <5cdc9b82.1c69fb81.741a7.2f98@mx.google.com>
Date:   Wed, 15 May 2019 16:06:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.119-115-g76f297797325
Subject: stable-rc/linux-4.14.y boot: 125 boots: 3 failed,
 117 passed with 4 offline, 1 conflict (v4.14.119-115-g76f297797325)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 125 boots: 3 failed, 117 passed with 4 offline=
, 1 conflict (v4.14.119-115-g76f297797325)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.119-115-g76f297797325/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.119-115-g76f297797325/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.119-115-g76f297797325
Git Commit: 76f297797325042039484d833822c683d6335075
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 23 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.14.119-116-g7b9ae87=
6e241)

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.119-116-g7b9ae876=
e241)

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.14.119-116-g7b9ae87=
6e241)

Boot Failures Detected:

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
