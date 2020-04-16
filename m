Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD221AB49F
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 02:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391270AbgDPAMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 20:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389085AbgDPAMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 20:12:36 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB8DC061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 17:12:36 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h69so759858pgc.8
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 17:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AEwwK8DWDbl+rI2qiYsPB50ejQ5AHxZt5l0p1LH/MDY=;
        b=sg/0FF41iQGdJ6yr6bqsl4JQXRTC6IFYAenMuouLQmvQnTp6BSCiWyxulnULyiauTK
         WK9ENzELNlBGcPpOq5B6eJQbXgdCHgI58rfF+aD3Fj5MclgIAlKepJyXvwy0YiVryzqO
         WENSlUHKlAFtFemTGBwRddqgnqOUR8xsK4ISxUb5d52AYtuDJdhc63T9/Tr+lJdUGKzi
         ykcJ4nE/sPcHb/CaguFqczRg3ieRe2qtbHOX7eoy6nq3Ud7b8wkcnLzZ+NMAzwzt8NED
         XyNwDbwlkLaxIX/W82O8IqDJdIO6RWJFQz6HN7b0Nhj97v69TXZaBIVeXB75scAnhUYO
         MvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AEwwK8DWDbl+rI2qiYsPB50ejQ5AHxZt5l0p1LH/MDY=;
        b=KddFlM++qW1RaLJY/b5V3aclQeoVYu96es6yS7oVACif3qo/HD7nAAbwMcDZ++iFkP
         OD0cG3L0UYyco2SeJIrgbAk9ziRIOqzsrroq1o9dt+TCclPMJh1nfam2WQhP2wMF0Tr9
         kMA0ndUmlk921nYmAjYDZXw2iez3RyyZo3pr4DmMBPimpGbMFPFldGLAganS9JqIJXbU
         SzzmjxQ21DKBJAnwP4W5CtyLK7zp84hsiu6s6YSyR/utNHJC4zDZktc69a1wjicnBCwG
         MKZChrEenIXjSNbZCzMPsTi8X7oLsU/8LiMVHggz/x1bIOt8jP+jv/B5Xd1F04tHXZQF
         Fitg==
X-Gm-Message-State: AGi0PuaYYo7sRqiJ32bZ39ylUz1ry3wExt/NGN+f0h+T2/kepSrfDZQP
        lPFIIUAqCrLnrNUi87fSHYcpF3zX63w=
X-Google-Smtp-Source: APiQypJzwPXGUXZKMpmFLPcn0n7kTEVgiiNV7VOW09aWUPuqPOqUkAR8FsetZiPEDID8eHuD+myX1w==
X-Received: by 2002:a62:64c9:: with SMTP id y192mr30610500pfb.26.1586995954321;
        Wed, 15 Apr 2020 17:12:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c14sm13977863pgi.54.2020.04.15.17.12.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 17:12:33 -0700 (PDT)
Message-ID: <5e97a2f1.1c69fb81.3c146.d033@mx.google.com>
Date:   Wed, 15 Apr 2020 17:12:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175-133-gf8a222f3e349
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 132 boots: 3 failed,
 119 passed with 5 offline, 5 untried/unknown (v4.14.175-133-gf8a222f3e349)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 132 boots: 3 failed, 119 passed with 5 offline=
, 5 untried/unknown (v4.14.175-133-gf8a222f3e349)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.175-133-gf8a222f3e349/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.175-133-gf8a222f3e349/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.175-133-gf8a222f3e349
Git Commit: f8a222f3e349b82d65e159e80cd3431296a5f9d9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.175-39-g4=
2fb2965c7ca)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.175-39-g4=
2fb2965c7ca)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 67 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 55 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.175-39-g42fb2965=
c7ca)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
