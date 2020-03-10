Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29A3180B95
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 23:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgCJWdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 18:33:14 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52214 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgCJWdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 18:33:14 -0400
Received: by mail-pj1-f67.google.com with SMTP id y7so1042429pjn.1
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 15:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sf6IfLf2vgB8dNNRkWKi2YJLKC4Ejal3afE6EFlrzWQ=;
        b=d4tAUTAqc/0uapISIuZhO+suj34XUilCSNc+KuXaAEIeyEorpf8OCa/lkW75EHPwjd
         dB4W45fAO68o3Wh1Lu8NYZzOqkTWurKn6wpGve3OvIJoiZk2ONCDitGkgPRWHh8HIfw5
         CmknorYzmIF3l4mjYnyO27HwJeUGTWhsLv1DUoXLoHIId3buwBVW0916TytN5B2dWBzV
         V7l6roeGVZXgpBBVH2/MsW+yCfR24tqFxsoL0sGZ6xFMNLx6xgO1+aXSGwyeOWV2T5HZ
         bRdJK55/02+fZJfapQKwxaFV/M9fE8+FuP42c6qFbHL/3HpBOYEOOCDtLrjZbCvEKnLQ
         J/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sf6IfLf2vgB8dNNRkWKi2YJLKC4Ejal3afE6EFlrzWQ=;
        b=BzWbVgFO9Q6U6AUQvYX/fyDkBFowBcINGBDzv4uMDhqT9SFqUDdVYIfEBvBUYrnonQ
         +6TQz1uU1x5WKJNLzDpqYom2q7lK4U0drQztPM6BIlC1dFQbRlsXInl4aCCnf/gN8An+
         RzDDANVui/PfX38u3dpUaibofyf1HRWIZbUUq8APiHK3JbRvFTOs3mrPhV+AejVyHQZo
         Z0XNiGykP34ndZuwRVRDq1UWeXWFEDnrwdJTz2wd6OEyvP4d1k2n6YKLh8OsJ72JKXUP
         fg104qJ0cUR1vJoKQudKjK80pIT8RoatEWOzknza/XymCd6LR8qksLlpFveNUv3WaBqy
         M54g==
X-Gm-Message-State: ANhLgQ3bgsbptRhELv9v0HgHsm7h3CeyVAe2ASX8k2z7N2asuKJyI18p
        VE7+wZgWO57Ont0JwI8JHymPNEtOIPw=
X-Google-Smtp-Source: ADFU+vuZV49Oo3zxB4LRUppkWQ42Wvb7l2BfNUrVhFIzQAt2kyiE7CBJoGJL3mJOI4Oha9eWvqdEDQ==
X-Received: by 2002:a17:902:a9c5:: with SMTP id b5mr174266plr.126.1583879593247;
        Tue, 10 Mar 2020 15:33:13 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id my6sm3565822pjb.10.2020.03.10.15.33.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 15:33:12 -0700 (PDT)
Message-ID: <5e6815a8.1c69fb81.a1ae0.c580@mx.google.com>
Date:   Tue, 10 Mar 2020 15:33:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.24-168-g877097a6286a
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 121 boots: 3 failed,
 112 passed with 3 offline, 3 untried/unknown (v5.4.24-168-g877097a6286a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 121 boots: 3 failed, 112 passed with 3 offline,=
 3 untried/unknown (v5.4.24-168-g877097a6286a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.24-168-g877097a6286a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.24-168-g877097a6286a/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.24-168-g877097a6286a
Git Commit: 877097a6286abcb4d5eaa7d683640e3a86b7a95c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 89 unique boards, 23 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 31 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v5.4.24-169-g01=
c3b21f542b)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.24-169-g01c3b21f5=
42b)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.24-169-g01=
c3b21f542b)
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.4.24-169-g01c3b21f54=
2b)
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.4.24-169-g01c3b21f54=
2b)
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.4.24-169-g01c3b21f54=
2b)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
