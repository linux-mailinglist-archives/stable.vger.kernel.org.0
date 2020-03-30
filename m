Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC78E1986CD
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 23:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgC3VvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 17:51:14 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50418 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728864AbgC3VvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 17:51:14 -0400
Received: by mail-pj1-f66.google.com with SMTP id v13so196089pjb.0
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 14:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cjv6tZ7FcMrttiayFZJoIdfDavhrU12OclWThW481nM=;
        b=0JFAlqBrUw8NesL1+KNkPV5krg/zN7Iv3G6+nHS9zW1U25+PYyhLPF0ObKtnplbFeL
         m0Wl8a/4lO1kbGcEN5NSI/hXsT5uxVuugkVNPw6LhUARt0qWWkDACnboDdMb0TFGiv6R
         TVW5Ouno/PhZTB0lQDXF9SVAVxOtJ/z8ORsnksE1JCwYzWbpMBRzO3Cl09lYr0EVdEQX
         s1vJGpAWYZvWqeYG7XILlvzSZGk0wKOPjQww2s8eGyz/5JPnTFyY8iJCoqwwEHjmd7sU
         /avwXwobAO575rSKHsJHCS5yX46bBbRbehym95DHK6OX9Lk7qUc5rHPq+eB4w9mmXvNu
         KQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cjv6tZ7FcMrttiayFZJoIdfDavhrU12OclWThW481nM=;
        b=h2R+QwjWzGHOyhm1y2IhJdWwRJwiHi/8tLE+xITqYqGbmYe+y6t6wge7eXlIi180Cg
         I/ZuvI8E+7J6cjqfhYrEEbEhLk9UGdt3d280COzS583D40/37iyglbSZaj++ktn8GoQX
         7m+hMICYTpNEOjBugAf+hG/jolZiCqZG8eMm+k6BTfi+XLPdMiqUwmDEqO2ykh8QhJ+x
         LZi6uTqJnmwGPk9FdKo7mSm6kgZqQS4XnlB2mqvIDA3SoQ4J3/vrWiNJ41GAL8Cx8Axg
         002vLhF4Ig8YBd4UfODuoNzRd94y8c6Pi1faGY8KTm9CbKMBrvxcTRqIfqvKFfsOCOTk
         V/og==
X-Gm-Message-State: AGi0PubK2vu0KkbqZVy7K/FBiP1YU+NVByKu71Eajq3F0eFwFE6h8DqE
        gwts6IBNtKxa64021g81N+4thPEMVJg=
X-Google-Smtp-Source: APiQypJyxNk63s5j44jiPehn4WeLa91fmqpnuIk0LYWP0rALT4LyzDGRq1hBPEIxv8Fdi9aYXok78A==
X-Received: by 2002:a17:90a:a385:: with SMTP id x5mr213299pjp.102.1585605071089;
        Mon, 30 Mar 2020 14:51:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r63sm11139934pfr.42.2020.03.30.14.51.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:51:10 -0700 (PDT)
Message-ID: <5e8269ce.1c69fb81.54443.0c7b@mx.google.com>
Date:   Mon, 30 Mar 2020 14:51:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.113-79-g81a370c0d238
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 93 boots: 1 failed,
 84 passed with 2 offline, 6 untried/unknown (v4.19.113-79-g81a370c0d238)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 93 boots: 1 failed, 84 passed with 2 offline, =
6 untried/unknown (v4.19.113-79-g81a370c0d238)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.113-79-g81a370c0d238/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.113-79-g81a370c0d238/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.113-79-g81a370c0d238
Git Commit: 81a370c0d2380a99e6a2fad5d3d9456ce054966c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 21 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 51 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 17 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.113)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: failing since 6 days (last pass: v4.19.109-192-=
gbae09bf235a5 - first fail: v4.19.109-202-g69e7137de31c)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
