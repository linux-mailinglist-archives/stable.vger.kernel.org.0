Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1821860A4
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 01:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgCPAAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 20:00:45 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40230 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729087AbgCPAAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Mar 2020 20:00:45 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so7132889plk.7
        for <stable@vger.kernel.org>; Sun, 15 Mar 2020 17:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8N0KazntbFhveJ/RZKsffsPocWJ96iEW+1HkdCzU1dw=;
        b=vJXulYfA5Dz1W2ZxoCpMjO0OYcM0w1ernrcPeLXUb1qYGgmayOUDZuPKCYU0//H/av
         6MVptdAKtw/1zW0KZfSM5RdxW6iZnQaFXiyjWSSGVjVgNvA1e/SBfZBZDV5VNy9h24uL
         Fxs/WGaw6n9NSule4S7Bw4gUj0ftcP6oFw7Lc7KAXo414pXKxFtvJTrXHReCMgUDjhyz
         XBsJ2g14vjwhRpRJeb0hIErlsyyfV0kY55doz17AlvC3zFAXs20ybkA5SMY5/kGwPZon
         00JVq/8Fjm7Kl1RqA/GLo+4fiPqmInto8YqzSN6b0zjh5YG1K6abJbbF1CfBNNv0vcXq
         M20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8N0KazntbFhveJ/RZKsffsPocWJ96iEW+1HkdCzU1dw=;
        b=m8FSKQy6iNmS1IBnXmCvAtm2vguUQ89/xmKIG6vu6IMgeq0bJeuc41Exx6v2PGbBDw
         sQPNdlJMhpnD6Gl3wLA8agZmXhXlt2QR8qMRMD+U/GbD6zmSicvn7G1Su+UVc/RV2qJ2
         YeY8tsevbRJ+CP80T8qsktF4D+nq/tFpQ58EWYcW0F6vWfVqCmIMqp1glytGLZqwwDUo
         UNt+xZMO/u5I1P62iLzxGGzQxumM5yALOTLE9/zPk8oZOV3URys5u3rKNVAdgIYFOZHw
         qF0MuVHQcnrRPp3jtL8fxOvzmBNKFEza7/wCInU4R5XTwxePvgkudrqfXELTL6Drg0e4
         hDjg==
X-Gm-Message-State: ANhLgQ2ggXumrGRt0bnPUWSM2PFt5i0vON2r64dqvrYh73ldDRV/qplc
        G+xPjUS1U5hSiKCyCZxIcE7s0+69ZiM=
X-Google-Smtp-Source: ADFU+vuWMAhH41F7zPv8ygPocCEE9ToWETSnHtjnMs/2WeS7Gq8YaUuN11rcNW6aIN0vJbA9cI6L/A==
X-Received: by 2002:a17:90a:d103:: with SMTP id l3mr22957316pju.91.1584316842762;
        Sun, 15 Mar 2020 17:00:42 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13sm10199229pgn.22.2020.03.15.17.00.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 17:00:42 -0700 (PDT)
Message-ID: <5e6ec1aa.1c69fb81.f0fd6.3c41@mx.google.com>
Date:   Sun, 15 Mar 2020 17:00:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.109-46-g8fb46e602a12
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 144 boots: 2 failed,
 132 passed with 5 offline, 5 untried/unknown (v4.19.109-46-g8fb46e602a12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 144 boots: 2 failed, 132 passed with 5 offline=
, 5 untried/unknown (v4.19.109-46-g8fb46e602a12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.109-46-g8fb46e602a12/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.109-46-g8fb46e602a12/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.109-46-g8fb46e602a12
Git Commit: 8fb46e602a12df8969d54dff4a706b43395a6119
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 23 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 36 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 2 days (last pass: v4.19.108-87-g=
624c124960e8 - first fail: v4.19.109)

    sunxi_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.109)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: new failure (last pass: v4.19.109)
              lab-baylibre: new failure (last pass: v4.19.109)
          vexpress-v2p-ca9:
              lab-collabora: new failure (last pass: v4.19.109)
              lab-baylibre: new failure (last pass: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.109)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

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

---
For more info write to <info@kernelci.org>
