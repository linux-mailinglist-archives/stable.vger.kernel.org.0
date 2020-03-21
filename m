Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7572918DC51
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 01:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgCUAEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 20:04:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42545 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCUAEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 20:04:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id 22so519454pfa.9
        for <stable@vger.kernel.org>; Fri, 20 Mar 2020 17:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZLpwZMdPCozShYeQmW5B3P5r2nq9UB3xwaSwQD/NeKo=;
        b=qZAEVb8RUuXCR6MZWHBQJHRz6CrSZLVA7ScBsfPqXxNLH08zMJQXdHUGlnieCbM2g/
         SJAnvZ+oCeHrVMYRkcdQAWPMQPx09rh29o2DFdA4kQ0GD6CK6oEki/MfLfxJCMQVvqye
         SE2Ryl+XbfHIMa1A+AA3/XI5AMW3lRIedmA7ScJltterUfud53EfHs6csUzqHGWZBFGB
         JIqdluxblncmVXvomQwcM3ht7TLS/5ie1UZ7Qql53NvKE/rs+hfftOa6Tp8uO2nf5bCl
         UrushdkDr6lK7JUKTXYVOi6cQmOpfDmjQH7gbwz1xriVqucwMInCoP0NRfzVpBNuPuHx
         xEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZLpwZMdPCozShYeQmW5B3P5r2nq9UB3xwaSwQD/NeKo=;
        b=udJjqMg0qwmB4+023vivK7Lm9m5q43HZ9dppPBRE/jDNUTcH2kse7VcfLuIAPuxwVN
         Chj/rVWnnhT3AVLBhadApAnfs//l6qdXzUK1a/6ZnXFHTk4qNCUrqUbGrDSaBv18+Mna
         2XDIxA4T6MR/PLsn/qoLUsnpYAOAa3RkCThZuGhBk6Blirf1e71TUh3DiHW5yggeDinI
         AkxBu886lsdEOg6EFIUxueayRTRN/RYDy71xG99JbTw7IYnDQKfN6BWfu1T3hd2tMjiJ
         rlarFCeHquhpmLy/M60CdCytZPFkwvoQc7xEYdeUxc50D0uBmE9EIvdzgIqdg7ZxDtdR
         9gyA==
X-Gm-Message-State: ANhLgQ2GWTLaPfyefK7OfnNbZTVfCAtbmDbX5r8pMwerPvZx/AkJtxJ5
        Z0uLozPkR7Ic9mu3ApCE8Q9EoPd1YTo=
X-Google-Smtp-Source: ADFU+vtH8T/VOgvPTgRNMQ7RWKjI6NHh/1WHNtD58artqisozvN2PZpApVCB6I4NzjSwU1AdrglV+g==
X-Received: by 2002:a62:ce8a:: with SMTP id y132mr12160179pfg.163.1584749047498;
        Fri, 20 Mar 2020 17:04:07 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9sm6206741pgs.89.2020.03.20.17.04.06
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 17:04:06 -0700 (PDT)
Message-ID: <5e7559f6.1c69fb81.7bca3.6b18@mx.google.com>
Date:   Fri, 20 Mar 2020 17:04:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.109-136-gd078cac7a422
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 145 boots: 1 failed,
 135 passed with 2 offline, 7 untried/unknown (v4.19.109-136-gd078cac7a422)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 145 boots: 1 failed, 135 passed with 2 offline=
, 7 untried/unknown (v4.19.109-136-gd078cac7a422)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.109-136-gd078cac7a422/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.109-136-gd078cac7a422/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.109-136-gd078cac7a422
Git Commit: d078cac7a42286ba7c97801a763fc42ad7baf5c1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 24 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v4.19.109-141-g8977fd00=
fd70)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 41 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 7 days (last pass: v4.19.108-87-g=
624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.109-141-g8977fd00=
fd70)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
