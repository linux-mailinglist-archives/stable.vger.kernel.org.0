Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E9B1D41B1
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 01:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgENXaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 19:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbgENXaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 19:30:16 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FA6C061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 16:30:16 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s69so138568pjb.4
        for <stable@vger.kernel.org>; Thu, 14 May 2020 16:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KCliDnGd2pigcrCNWSIr/GC+rbrkDaLd7pmmK5t5mZg=;
        b=J3gb49AqumA6SOQGJZ8uS+Z4hXNnUGTuhPSI9HydehnUNvMaHJ+YTirRDGdwDY9/Jv
         PqHt7kcQVc+bmR2A5CXvv6OzqiVoj4ZmQ6xi5+rqmiK5Gbne5l5du5GbSWRohnq18ktw
         jLNPPiHTpEW/GT5abQlNGe628+kjoeptRnTqOSLU1s/wbKD1D4cD1oMglK1ysboAmgHb
         eThXQPLyh65pym++f7SyRp8Mx/Vgsw0y5XVK2p9EStPU1Rc9Hbbxy5OroDKKah9qd90x
         S8KtUCHz4TzOCG62rveDTW67MYTzgphLSYpBoE4yad3bDPkHMsao9Vsl78H6qGH45R6U
         Rz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KCliDnGd2pigcrCNWSIr/GC+rbrkDaLd7pmmK5t5mZg=;
        b=H4c812cX4iX8NO9R35BBvSqmcvtNGCzr3rxd2RihCxOoOMhQOnR3d2gT4lmrrN76CO
         oY1zLFosYCin1zQw50fnmImeAzW7AVyHzuyzc8sEEHCeef5bA0cyypKzQdf0wht/jtoE
         LA2jFFlIzWll7dKew4Q/s0rDLRNC2z8YQPyUZr7OKvwCS7Vtx30x0RTgZgvqNtA7isJ0
         FITvkplfTZr1XhJ4Jr0b5nKB0CwI029G3+HFa9sXYtOL5DeRHDo+Pf6U1ImWWaEn/E8N
         Zzam0TrneW8JmuBDPyrqBA4iX2ioTbArzmSD6TmU5S6CePrUcJC1EpJmy4E8DI+FKk4Q
         yj1w==
X-Gm-Message-State: AOAM533uBGuZ4+7V5dnlpgvpdw9Q/WL1fV4O0EV/OBpGlX/zF6IvCrd1
        qPKzmJobXpO2FZT2cGW8WtkoLdVryZs=
X-Google-Smtp-Source: ABdhPJyhNBKB5PovMuErmfQnLm2NPH6XnYyfGqI1Dgfp8834OyEdkO6WyKIvqeeDFmX/hQbpMTSXNQ==
X-Received: by 2002:a17:902:c403:: with SMTP id k3mr979153plk.12.1589499015750;
        Thu, 14 May 2020 16:30:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d184sm249746pfc.130.2020.05.14.16.30.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 16:30:15 -0700 (PDT)
Message-ID: <5ebdd487.1c69fb81.9cf74.12c4@mx.google.com>
Date:   Thu, 14 May 2020 16:30:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.41-2-ged1728340b22
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 165 boots: 2 failed,
 153 passed with 5 offline, 5 untried/unknown (v5.4.41-2-ged1728340b22)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 165 boots: 2 failed, 153 passed with 5 offline,=
 5 untried/unknown (v5.4.41-2-ged1728340b22)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.41-2-ged1728340b22/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.41-2-ged1728340b22/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.41-2-ged1728340b22
Git Commit: ed1728340b22cd2d0143fcc832c76ac40f409888
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 101 unique boards, 26 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v5.4.40-91-g132220af41e=
6)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 96 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 36 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.40-87-g4fdbdad796=
26)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    bcm2835_defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab

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

---
For more info write to <info@kernelci.org>
