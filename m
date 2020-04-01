Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6EC19B7DB
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 23:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbgDAVmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 17:42:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33653 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732357AbgDAVmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 17:42:43 -0400
Received: by mail-pg1-f193.google.com with SMTP id d17so805340pgo.0
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 14:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tpkYkegso9nP4PwHeoUkWVRN7vGKiOwAbYp8C+5XNks=;
        b=Byl06HzB+j4Tp79hdZxJ45Ez/3jV85YSwXiU4XZsxXVOXFAj9UaV1zkNeQc2CAuqDI
         Ca3nYNBVTb4v1Sii6FALmZjeme5oouxkLA8myuy50rlXI1CgR6Qx3kzszBBnEaVze9SH
         idqmVyZoh6Jj0la0h6RcxzE6Nxf3xCHCBJg3zGh0GhpD0LIajpJMN4Hcv9FZ6/ZmYbsD
         5KOW+r2zbwTcgQZdI1TnOqFEHCdQOoYJHY/EjzSe/DvKhWRL5sj+rDX9fv8kA6BxLucM
         XWjEKEjfRdgBcenN9cSzxemXZtD2UAcLH/SQsb11DVDZKB38dC2qD52SnJeE+kVpNtjR
         lVlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tpkYkegso9nP4PwHeoUkWVRN7vGKiOwAbYp8C+5XNks=;
        b=Z6lP24ffoJMaypat0GANU4lSW8K13pyxX2DqzhH9i1NTixDRhT+ZcuY7rsqm7KIGJ+
         2OblW5BtYdT4avcDXrX2Ydu7IN/HI7eblkNCgGPG1/iXOo2kghxkz9yVvUl0J5lIGWMV
         RsnsoHaBV8RZEOUUbGSDcG0xrBd8efnCnRnFswS1VMAl+HoO3YmbFOrZQqGcegSSSXLl
         ul+SNkCXa+RjqDfuUkQib+qJTDFEVymKwWGE5Fg3waoycc/+Z+7F6Oc3iGauj+JTDMrX
         gQvo+ESkzyKWycDrPEZrY4X1dJWVItWE0DZgTF+xISQ8O8Zzg+uMU2b/Z8E7IBu5vBkB
         gjAQ==
X-Gm-Message-State: ANhLgQ2aHSujGj+3lmTi0VOyrqNQvzfE4ZKn3EMpb7/hFbk6mIEHVoT+
        8LCuSkt8LRPTQ4nd4yYqO0TwXfS7zOw=
X-Google-Smtp-Source: ADFU+vtFHS50dVZBulRCnKppnsL32Ar6m22xsHKKjuksikOwGLq5QJ0zOYlBkEDhqLgTBsPbDhVLzw==
X-Received: by 2002:a62:1847:: with SMTP id 68mr25664619pfy.288.1585777361791;
        Wed, 01 Apr 2020 14:42:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e9sm2266698pfl.179.2020.04.01.14.42.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 14:42:40 -0700 (PDT)
Message-ID: <5e850ad0.1c69fb81.360e2.afc7@mx.google.com>
Date:   Wed, 01 Apr 2020 14:42:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.217-92-g2d26509e19e3
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 98 boots: 3 failed,
 88 passed with 2 offline, 5 untried/unknown (v4.4.217-92-g2d26509e19e3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 3 failed, 88 passed with 2 offline, 5=
 untried/unknown (v4.4.217-92-g2d26509e19e3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.217-92-g2d26509e19e3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.217-92-g2d26509e19e3/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.217-92-g2d26509e19e3
Git Commit: 2d26509e19e30e927f01e298d1ce71dadc5ec33a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.217-82-gb193eaf188=
1d)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 53 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 6 days (last pass: v4.4.216-127-g=
955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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
