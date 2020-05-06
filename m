Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9248F1C7C85
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 23:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgEFVeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 17:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEFVeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 17:34:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BF9C061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 14:34:19 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t16so1137087plo.7
        for <stable@vger.kernel.org>; Wed, 06 May 2020 14:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9WRtin8qNHNncKgcSKn91xBuW4xAW7rXzLmiXzxw804=;
        b=Lofx/uYFo2WIvTr1DMEX1hMii0UAsO6nyZjMYH0YpDYtZy7mNEpfzZce7DgqnJcpFf
         EoP9wKNEKd6D5xgNPa57Zk+i5h0jhbyRDBVwb2VJf41wYQo2gOZf/fZ+E+OxB0k+rfYL
         epO3zbZxg/WnyfyQdBQKGQBbwgKKm81r7orZC19GMtYxBhEnuUamn/Tqy4Nj0D2EhzEc
         e0+sp9knUeFMeSSpKnJiJZSjeV6ysx+5sr7UyBZ3XI07JRLJh2EFxcYskVP7Djdg7AwO
         4p4zAYrtTC9S9PvZt5oRZ/vRRjdQ91DJwJwWuM36XcLMG7N05/n6jTLQfY2yy367EyrE
         cyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9WRtin8qNHNncKgcSKn91xBuW4xAW7rXzLmiXzxw804=;
        b=mhEon/99JLCd6sogPu+ECRbKWUcmo3I9GzStivtPneIsOXu089UIm/VZhOV39wuNl1
         tyeMWLsYTaKpshJ19u3KgNiLPx9n7H8zvm/NbDkQc/4oHNayc7wqItF4FZ04DJoXuROh
         +i46XAyPyOXw/J+hlnh8/aYq4KUcUmxzcbNm/PI9OgMj8ZoUA8UHUThMeHH+NfaYynoO
         4WRFmaxXaGQyqdjgerwK2TkbfLribngiI5orDIz8b+Q68RwE70LyURbR6wd7/L20oBFq
         f0mxqIYbXHVrFiex8sVUCJCGAWHQI0GVlA8Bcg78p2/vgX0ff/T+OyeOnI7Tld6o4NyM
         tcIA==
X-Gm-Message-State: AGi0PuYo2r9hjSXEbGszpUOhOD3tmKGS3RhJUU0OcoBY+UeNpGrJdiDT
        JOoaBiVCIkVpaoCLd7r9kvcnALnomIUJPA==
X-Google-Smtp-Source: APiQypKqI1H+ypW/aXLzj7/zTVS3oQt/0LxaWAHFlIXrMYmR7kAT156KSENiSByiaqU46SmedpsAFw==
X-Received: by 2002:a17:90a:270d:: with SMTP id o13mr11763198pje.34.1588800859163;
        Wed, 06 May 2020 14:34:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 127sm2806010pfw.72.2020.05.06.14.34.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 14:34:18 -0700 (PDT)
Message-ID: <5eb32d5a.1c69fb81.30594.905d@mx.google.com>
Date:   Wed, 06 May 2020 14:34:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.121
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 147 boots: 1 failed,
 133 passed with 5 offline, 6 untried/unknown, 2 conflicts (v4.19.121)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 147 boots: 1 failed, 133 passed with 5 offline=
, 6 untried/unknown, 2 conflicts (v4.19.121)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.121/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.121/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.121
Git Commit: 84920cc7fbe10e838689e8e1437dfd18d6e54a2c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 21 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.120-38-g2e3613309=
d93)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 88 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 54 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.120-38-g2e361330=
9d93)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v4.19.120-38-g2e361330=
9d93)

Boot Failure Detected:

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

---
For more info write to <info@kernelci.org>
