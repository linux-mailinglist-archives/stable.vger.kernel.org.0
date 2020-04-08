Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E811A1A4C
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 05:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgDHDf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 23:35:29 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42015 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgDHDf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 23:35:29 -0400
Received: by mail-pg1-f196.google.com with SMTP id g6so2709318pgs.9
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 20:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=For3VaL6Umot9+8Wh+Qd8AbRyJdxTyRbRbz/oHOMeVM=;
        b=BOkqeqD/+DWeKlbY4yAfa26LQ55T6oKYw/UuSGwpw+YCUr7U/afTOz9IjBpN8mYhf/
         IQrjN2MsEKU0oDexTvpMW3BJncJ6SUe0Vfv4R4DZhQAV8Yyq++8JVEIGBDE3z9gf03Mg
         YaHCLl4KIaLb+F98oikPDyDe8Xt3aMardinXyXz2TXQIq9iIwUJtKB8Jd4X262zcLDIg
         owy/ihkibud1k5rDcsUR0KgxkcgYz3+QFKJ4AGg6rv8DpTOdQMeqDQMpO550l5pLlwqI
         O2Lwi7xo0kRNPB1QI6jY0nI1lEtCXvBqzE9Mmv+Hh9S/9RrGNbd3BRYaWASBQgl81+PX
         v4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=For3VaL6Umot9+8Wh+Qd8AbRyJdxTyRbRbz/oHOMeVM=;
        b=WTE8txN4cARBQAmU/LUm//ZJLc7MyG+S/undPNSAHVO5JDJpOi6xIkg0KL5ibIiohD
         546rKh/UMwVJ9wjHJJeEeHr9aBYSYIDc8SKIm1A6taqx6gazQ27q+lPDTkVNJNCXay+x
         hXnzGIzyEMsXXwO1tpZjSkzs9WOJ7/C3uKbhc48ldfBSpZZQAka0GRRPUZJr543/SmEz
         gWL8hkLSEIaS6Ly3Vurm+Wg8EMS8yzLdj0rBi6+ASggE44XYD7d/QdI66fBqUOcKwI6h
         UR5cC2zH71omL/iBC09n4qJZHaNJok1Vli8CILjVdDlGB0d8u4zCBo2gGFZHPpT19C2+
         fYXA==
X-Gm-Message-State: AGi0Pua0tVQbcT7G/cbtyS5dizX0pM2ZzNuDUuCq8aJYi2kcMxAOCvRh
        Z8syKvmgULQP1oVwnvC0EFJqrBDvQ1E=
X-Google-Smtp-Source: APiQypKyoVFU8GAdEajCOqGXz4O8QFDVgPCTcjLIxJ3xtWvYwoPs5DOxxpWTf8vAqDK23WqhL16ntg==
X-Received: by 2002:a63:2804:: with SMTP id o4mr5291390pgo.35.1586316926847;
        Tue, 07 Apr 2020 20:35:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id hg20sm2897297pjb.3.2020.04.07.20.35.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 20:35:26 -0700 (PDT)
Message-ID: <5e8d467e.1c69fb81.e710f.b357@mx.google.com>
Date:   Tue, 07 Apr 2020 20:35:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175-16-g34f2709a5c8d
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 132 boots: 4 failed,
 121 passed with 2 offline, 5 untried/unknown (v4.14.175-16-g34f2709a5c8d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 132 boots: 4 failed, 121 passed with 2 offline=
, 5 untried/unknown (v4.14.175-16-g34f2709a5c8d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.175-16-g34f2709a5c8d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.175-16-g34f2709a5c8d/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.175-16-g34f2709a5c8d
Git Commit: 34f2709a5c8d9a2dd66f62c26bbdc98da53ad411
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 59 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 47 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.175-14-gca15f551=
7c01)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

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

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
