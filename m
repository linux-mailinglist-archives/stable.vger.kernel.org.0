Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224771D1F63
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 21:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390443AbgEMTib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 15:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732626AbgEMTia (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 15:38:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE889C061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 12:38:30 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q24so11431888pjd.1
        for <stable@vger.kernel.org>; Wed, 13 May 2020 12:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ouRRto31Kq6AOgxicr8qNko6dxOtVSltARc83qJSmTY=;
        b=yqQbnpEszUVjAm3KhLnIHBOSwQ6qUOiVnFuA0Dc3B6wj+NPT8K5gm3PyLpWHpbBNcQ
         3rN97gAiMHGHtxgtTPePwR7t9HPFFSt9VvJhDYnkiqrr2xkxSff8BJtOHzKjYnjOVzw8
         4QvVw2bYBNNpOTNJkoluA4oGlj/7Edd+vV3/3gwhOgFxrZPA4eClheWjU9suAxUXseJO
         NY4sHDEbjvmfSHswgPJHSbiUjjCX4PAVRiFb9cjUd6TA8QpQxjV4ABeaDeYf9rsQvRf6
         cAZtFeOpb1dGmYQCozBzmzfppCP843K7xNe/sGJ17uJr1/fTF85gJDRRuqnt59t8Q+pL
         QVBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ouRRto31Kq6AOgxicr8qNko6dxOtVSltARc83qJSmTY=;
        b=BusNsC9t/SQTe4iKOKLjLWE25d/6MiugRYuoGoAzT67WZQARfbuHd3X9HlJZN2o7g2
         4GbP/8VpMUU27mCpMk9po50ZgBerNJd+umTbASmpyRMF1AZ6jGSwF/79zGNkDn18efYw
         RPFW3/dJu/aTj8mXtFqhCKjmueN0X46gJRTK+Okpi0NNCdUajTc5AcfX5DMMMFLv+o24
         2V0uiVQQagi0PExfnLKiMaozy4rC3P8o0YlyrDXRtyFPNJslBKRXQZzBPQYtbAN2kJh6
         4r2Yd5gJT6jaTMHFt+kl9M+H3bi0uwoWFLStK/iP/c6mDkEOLqd/h8Fa24yovURRWT65
         oFXw==
X-Gm-Message-State: AGi0PuZZhlRiJsjetIbbrOG78FTEJv+ZFIpoXBrlthP74c/3rj9VJ9oF
        m5Cqm+Rf40FW7cQR0GmgnaUwMBZ2Ry4=
X-Google-Smtp-Source: APiQypIIqBsxvmPszlDg+wPjfXCEgC8RcdDHl+oYc2lsd/upl7PIbWheAcfQ/mvEV/KbaK0dexBqMg==
X-Received: by 2002:a17:90a:154e:: with SMTP id y14mr37450814pja.180.1589398709991;
        Wed, 13 May 2020 12:38:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a16sm304469pff.41.2020.05.13.12.38.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 12:38:29 -0700 (PDT)
Message-ID: <5ebc4cb5.1c69fb81.38cc0.109f@mx.google.com>
Date:   Wed, 13 May 2020 12:38:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.180-49-g188e090339cf
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 128 boots: 2 failed,
 115 passed with 5 offline, 6 untried/unknown (v4.14.180-49-g188e090339cf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 2 failed, 115 passed with 5 offline=
, 6 untried/unknown (v4.14.180-49-g188e090339cf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.180-49-g188e090339cf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.180-49-g188e090339cf/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.180-49-g188e090339cf
Git Commit: 188e090339cf9e022f51461e094756a0e44efb43
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 20 SoC families, 17 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
80 - first fail: v4.14.180-37-gad4fc99d1989)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.180-37-gad4fc99d=
1989)

arm64:

    defconfig:
        gcc-8:
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v4.14.180-37-gad4fc99d1=
989)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

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
