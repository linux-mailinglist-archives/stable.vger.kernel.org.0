Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC091B87B8
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 18:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgDYQfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 12:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgDYQfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 12:35:02 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550EFC09B04D
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 09:35:02 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id x26so6192229pgc.10
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 09:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3V2u7iG83xFbRHbtjZuKKsOZ1wf/+GLsM/MAtENXgiE=;
        b=d6E+GpQo4ostwP2ovePhWKOUSB7UAHBtN/PsQ3xar0qyj9KPcwyH8Xl1RqFLL0y7EN
         xmY4gAisJ0BX6Gzf6jrLidbTpfYISoSxE6oMFwjzUNdNQ9RrX7HJLQTxiQY9zQNtfoyE
         mp4W8hUCnnaZ0l7cXuaEviQuwtDTSf3mkW475kErAVYofTLWZCsymARMdtAbtJ/5O/Kf
         8EPUHzGHbOz9KTSxRzgCG8rfK6TRD2ddoqFvAFFfmX448/do6g2tva06ZqeQSWBkQELq
         ATr4s4xG0TjEXEU6mQEPVUfzQqfHOpCw06jK25dIMgXH5iILxwBmwn8txHCZ3E/Zt+h3
         iWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3V2u7iG83xFbRHbtjZuKKsOZ1wf/+GLsM/MAtENXgiE=;
        b=k5ednSAHqG7sZN4yWJSOwpfyL+qizXTnp/ItdFygyFG6cMB47u6i7RfszNpah91X9P
         oPeDTora3KNd/rJOtFssXV2C/UBXlEADR0N9PUpdkwuivFi01ab498lVlIiZnMvyDgGu
         Mxc08kGtY5A+4+5VCISVHl0ceACnk8XfRVEnpLICZkAZQNKugFXpEx1cJ3v0N/DUGjuw
         U4PnrNskzKdOC5myHJTcyia3qjZQhLmAjoFdkmqKdGbU9wmnjrTIYYzCWQo2CzOx7Op9
         29CBgT7RVCfQgGrHXi9Pz3nhU5/35CZYxz3Mgeb8PlBpFkyqeS5/r96s39ox1a+0jXNi
         Jaug==
X-Gm-Message-State: AGi0Puaib4dhjX7N0XPVJNDHFyyDaAcfQc+CbUDrY4+9hNufJsZ+2xU/
        g/FWARhpciWdTjktcsE7rVT4nDlYLDY=
X-Google-Smtp-Source: APiQypIYlUDscLC/HeC1YMV2pbZmhGuIgysBvD28Ck2YDTGJ2jLcy/z3vXhjdoLU0BgYscguKD+UjQ==
X-Received: by 2002:a63:df42:: with SMTP id h2mr15155956pgj.216.1587832501218;
        Sat, 25 Apr 2020 09:35:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a142sm8488987pfa.6.2020.04.25.09.35.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2020 09:35:00 -0700 (PDT)
Message-ID: <5ea466b4.1c69fb81.b26c0.cfbf@mx.google.com>
Date:   Sat, 25 Apr 2020 09:35:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.35
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 171 boots: 1 failed,
 156 passed with 7 offline, 7 untried/unknown (v5.4.35)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 171 boots: 1 failed, 156 passed with 7 offline,=
 7 untried/unknown (v5.4.35)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.35/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.35/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.35
Git Commit: 0c418786cb3aa175823f0172d939679df9ab9a54
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 105 unique boards, 26 SoC families, 22 builds out of 200

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 2 days (last pass: v5.4.3=
4-32-g913df976b290 - first fail: v5.4.34-119-g186764443bf3)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 2 days (last pass: v5.4.3=
4-32-g913df976b290 - first fail: v5.4.34-119-g186764443bf3)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 77 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 17 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.34-119-g18=
6764443bf3)
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.4.33-61-gf969422316c=
7)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
