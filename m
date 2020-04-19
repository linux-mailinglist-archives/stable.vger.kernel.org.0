Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F37D1AF8A0
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 10:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgDSILy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 04:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgDSILx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 04:11:53 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DB8C061A0C
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 01:11:53 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w3so2753162plz.5
        for <stable@vger.kernel.org>; Sun, 19 Apr 2020 01:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ogefS+ZBk4R/auVUbY2v0NfhVJiYtXv762ZDmgCzEos=;
        b=f0Zfc4rlCn2sB4lk8tGuXtnA6eE5KK0Jffn/slpCgqe7NBbym3wAkbC0AsbGAIoyLG
         X1/2QEJNOkUekYhfRo4xGYEEFmtUX3vUrX7l5YG0ztaoZ7puzjz0p7F781uQXeaPfade
         S9lUECyBWgEGIkK6xg+quTleZcOnnLxvn1XJIIxqlfnjePDZqcjH0Hhn3rgB6Wv4aR9i
         52SPefNrolVRwiA06yLh/lpx5NkEnPwtZ8X98gR0mY0lxDPdBQChuK50ovcOHdPjRObA
         OoDho0lyDkrJtyPRkDplCKdJ9UNEQLB80QvfJ+FPvSP/q1dvWYPDwKV+xcvy0i8KVphP
         aVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ogefS+ZBk4R/auVUbY2v0NfhVJiYtXv762ZDmgCzEos=;
        b=Z+PWMrDlK1WlRLzEBaXk/kZkxjgDIKc/74RSsfgbM7YMDcNVMLB8Ri840kYx7Gdw6k
         eZVF0Lj3DzuCymPr2S5C14r9EcdgZQsYujrl4nZjWnlko2JDpU1MEbx9zmUMY9dLlgxH
         lzPe5XnN2572iqYvG0GTAHUfLqRviIdHMyg2M7dVOd+wiLAnm/SCndM8q9Oa9vdp/n8Q
         S8jh4XvPpDK277mYVfyhU2K2Q7TnAkfG8DjB3CBL+W5oK3227htaVrg9o7umpU3e+QGX
         2bvCrUtFZc1Fa/XXQXeECkQb6796H5r+zr2LKkDOyXpuDE0DrV4SKyt9uG8YByDEAMmd
         Fkag==
X-Gm-Message-State: AGi0PubC0pFD2NkfyOOR6ALD15oUTXnXyJo+cujjjlBGDwMMGnVxPNZw
        V2W29IC4m//YWNA27heroZf2a78mMDY=
X-Google-Smtp-Source: APiQypIHma1DGdqu1vLDQaypicfayGhsxfR8MDwqoPaO22KFnLdliq/Ews+HPxKc/k3JShjVTm5LIA==
X-Received: by 2002:a17:90a:d98e:: with SMTP id d14mr14116214pjv.178.1587283913105;
        Sun, 19 Apr 2020 01:11:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm22736916pgg.67.2020.04.19.01.11.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 01:11:52 -0700 (PDT)
Message-ID: <5e9c07c8.1c69fb81.68a68.eb43@mx.google.com>
Date:   Sun, 19 Apr 2020 01:11:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.219-66-gb854626c8720
Subject: stable-rc/linux-4.4.y boot: 93 boots: 3 failed,
 84 passed with 2 offline, 4 untried/unknown (v4.4.219-66-gb854626c8720)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 93 boots: 3 failed, 84 passed with 2 offline, 4=
 untried/unknown (v4.4.219-66-gb854626c8720)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.219-66-gb854626c8720/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.219-66-gb854626c8720/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.219-66-gb854626c8720
Git Commit: b854626c8720c0834048bc3bdf29b775746884a5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 17 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.218-85-g72558784a8=
3f)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 70 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 24 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
