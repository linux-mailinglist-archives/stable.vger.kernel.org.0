Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCCFB646B5
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 15:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfGJNDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 09:03:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36647 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJNDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 09:03:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so2202030wme.1
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 06:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QaxHz2F8MbmYGTkoW/jJRfU/fR2lf1QBxTTCo7qfib4=;
        b=UWCunYtUYHcw9G8T1EWd0tnWHrEXb9KNBDx3FreF+Du2exmnuhdKqvqVaEyfoDBCGU
         J83bdJKRVQADHXuIKu1Q3jTkXEFAOuxAh7JhaLpYpkPieqOja+Lu4j2NutNy7awk2pD0
         WNjQnkIr0D+tH+BydpilYp+hrkPBYRTcU4MwA624DHVE5ywSY3vPnbZxsquAXQjBco05
         KUvSjV4I2Nzl7R0h7rPCAM6bJddCaIDYvgYQDp82ZTeazFvOY86ezAl2HbphWSj2MER2
         HM2YA+i5fVgFGLD9cocxJNnsQKxZLKQCEFuU+ujUzys7CXx8gLWsMHPpPYMEhLuyI9qY
         It3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QaxHz2F8MbmYGTkoW/jJRfU/fR2lf1QBxTTCo7qfib4=;
        b=DAoyvRABBLFVEpnnf2xbAxLzxmFlqYZycic0eJlr9ITyOz9F5D3eMk44d4wLrIEWlY
         KMTCglsnpVn1VCdDyKe44g3GhUiu1EirxrELpOhrX+W5+ZjsEhbjqHWEBqlGZfuwt9E4
         tQPA5fkl/mzv+32tyJIWK5BuRyneDtE2gm2HJGUeCregSC604BNb8i61wz5OgCv/EuZd
         38hH/wL/0CWfMMn7+3M3vVWw1FHZOQ+PCr6wReWQdjxN8klkZc2poII61SSmz6+S8L6m
         q5d2ONuCAnsicZiveCJQwy8YuCXS+fJSEgi2r2VRSHGcaJKpTBz+kebn7fwcuCtobqtl
         OffA==
X-Gm-Message-State: APjAAAUbuCx1GglItnJs6oYD/LoNFw1eFPD5DlV+NURmezHyP8B59JBu
        1y0zKD+tPG1Ae+zNzR3BZPxoXENFi9FtMQ==
X-Google-Smtp-Source: APXvYqzkEdALLgTtwT6c/nxw8YJl/FYgAHIUJO+P3I3e4BK+QngJwUqd/BZQnCdEStLyd+uklyfE3Q==
X-Received: by 2002:a1c:345:: with SMTP id 66mr5567069wmd.8.1562763803177;
        Wed, 10 Jul 2019 06:03:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g25sm1420306wmk.39.2019.07.10.06.03.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 06:03:22 -0700 (PDT)
Message-ID: <5d25e21a.1c69fb81.be40b.784b@mx.google.com>
Date:   Wed, 10 Jul 2019 06:03:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.17
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 68 boots: 7 failed, 61 passed (v5.1.17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 68 boots: 7 failed, 61 passed (v5.1.17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.17/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.17/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.17
Git Commit: 4b886fa2b8f167b70af8a21340dfb3e24711e084
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 33 unique boards, 14 SoC families, 11 builds out of 209

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5250-snow:
              lab-collabora: new failure (last pass: v5.1.16)

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.1.15)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v5.1.16)

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.1.15)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v5.1.16)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v5.1.14)
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.1.15)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun8i-h2-plus-orangepi-r1: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun8i-h2-plus-orangepi-r1: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxl-s805x-p241: 1 failed lab

---
For more info write to <info@kernelci.org>
