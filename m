Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A571BF06A
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 08:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgD3GmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 02:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3GmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 02:42:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB039C035494
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 23:42:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id hi11so312545pjb.3
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 23:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T3jiM6S2EZPgxwdUoJDJ9EbJ7BvjKwMsD7b+O4sIZW0=;
        b=Er2yA3cRy5QzVlrzg4k5LNndKseD3jVa5hrv55w/sU+INi3RIiHgVd4uca1RNI9Y5J
         pJhM+IPKBsUHl9L4f6S2sspxoea65f/KepHmp90amKgTk1rVxYykaVgBEkeDQKqJVmtm
         kgd4apcx/jQFyz59KFKbUT7h5YhldUtrBybqMG81XGDFRjlA5nxy+KDE6RFYSv7ViNAp
         Q8WefU3j7WH7xOQVT1z95X8q26x5oDmwobY3xcE/A9P4S6O40zxCp/5D4QE4F6rqBKdh
         1qnepVqIOadQqu+bmeQnJPYi2kdN92nxZDhTqJDvwD6NJABeYJ5Edp/ZwJsPBjxtL/se
         mnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T3jiM6S2EZPgxwdUoJDJ9EbJ7BvjKwMsD7b+O4sIZW0=;
        b=oARaGLTXqBYj5ODvIuB0p+C4r994vcIQetNfkBILQlSHf1c82zSdTCaN3lZTnAZb9t
         IwIOnCiIZ3kEYpYQ0Se+5kWMVus/WfINljM4yCsj8Jj206Pf9D943L168pMogWSPLety
         1MrTM90aT+++qiHm2s1uHlCsehijM73jXYZVyWvY99OkBPH7LWXzi3zxlKr4FtscxAfQ
         uY0LsRIRxIWjQnwYidm9+4QLM5wGm54uD7tYxm4zVMZeW/YvzACLokeiZHEqAuzLhJeR
         Jr4FIkm4gqauDlIQEkQsG3qzPSwHCmSY5W2lTP4xOeJWTXCicM68yNeAZWzhUdMNp0VQ
         83hQ==
X-Gm-Message-State: AGi0PubDknmXyBmDkHQUc+wNGrRIkzhOs6haFvGPlakPVsUna7NbyMuw
        7esmA93RLMZCOc1Zoow9qzpmTqzsY1M=
X-Google-Smtp-Source: APiQypIwEkmY6ffzBzmH8XmrboG2uC80X3gSKSaf2Hd2leIkLVPaY7ceqW18Oc3MGWkCZuBAqNJ3gg==
X-Received: by 2002:a17:90a:930c:: with SMTP id p12mr1245738pjo.64.1588228924760;
        Wed, 29 Apr 2020 23:42:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x10sm2367001pgq.79.2020.04.29.23.42.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 23:42:04 -0700 (PDT)
Message-ID: <5eaa733c.1c69fb81.8b800.88d7@mx.google.com>
Date:   Wed, 29 Apr 2020 23:42:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.36
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 167 boots: 2 failed,
 151 passed with 5 offline, 6 untried/unknown, 3 conflicts (v5.4.36)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 167 boots: 2 failed, 151 passed with 5 offline,=
 6 untried/unknown, 3 conflicts (v5.4.36)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.36/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.36/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.36
Git Commit: aa73bcc376865c23e61dcebd467697b527901be8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 100 unique boards, 26 SoC families, 22 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 81 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 22 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.4.35-169-g388ff47a1f=
ba)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.35-169-g388ff47a1=
fba)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.4.35-169-g388ff47a1f=
ba)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
