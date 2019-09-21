Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B94DB9E4C
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394273AbfIUPEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 11:04:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33640 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394261AbfIUPEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 11:04:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id r17so11606063wme.0
        for <stable@vger.kernel.org>; Sat, 21 Sep 2019 08:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vN4Vlem8ACvqLtrLNEGxJSA27kgUwSXkJKlal7TKJd8=;
        b=N2OdIvyQ/bJ7z7KMcEzPrCT7JD5P3M15Jkbq6nT2UdkvTIZ764D+O1DekPsYhE8yOc
         MbwDTilV7jg5wCJnZI8zhDAwsoSrIDCWxMS/IMY0RqbqDOqRYodnRK0C65w0o7ltiFfH
         rWam19KQK8azBIOU78Gnipt3Ks9/JAODt/5DYdV4kZltW9j6gXAXF7jYuFWNYYGMrL2D
         Xvgg3sHbtuN35IY7I3iTwD2EzkwY+Cidc79Dp0eHad/GaArdN08Z9BqambyuLzd48zOo
         ItDn753m7oTlk2Mx3jqShofRg/XSsaVSHWfjZwczjOxNyOQb2HszRNuyB+lEb267Vwuo
         caqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vN4Vlem8ACvqLtrLNEGxJSA27kgUwSXkJKlal7TKJd8=;
        b=FVRVBLaVg1FQEwHiGrErooQK8lSv65EbncAAh8c8Kj1EPGjfYgh9sVaYCOkETg2bOl
         lG4fuis43QjkQuaj2i4BKiIU3HgcD8rJ9jbx3HJdNMyMQnmhkQO+4aPHTYiVzj8dkdr5
         Iit2a30AijM/ZZYEkvbfkMr1I3mtwiK9HZqkYHxt7Ea5hkQUQEs6wwU9DXP1dkcmG81w
         ptIawtk5mgaSLXUum/r+U4V0PEXj5jKLrfL5hl/IKIaedHydvuZQtG8w418hKrndVmpT
         Ru2J80MFps6LQMq5OuRj0z46lMbalsJrx54VV6DgCrE+//NLEG7YdOcHdJW0DR45NDQC
         p4xQ==
X-Gm-Message-State: APjAAAVkEJ5PtrtfxgyGzRduokN/FPBjUFjVrtneISimcPsIvkl0jrl+
        g2+o+DgYSgPnqTCVeh1sz4OGS+kZtud45A==
X-Google-Smtp-Source: APXvYqwv01Dld+jeGOsE1xxXt86VT0uE5VIub2ms6ra8v3jd/B6eJXC0OoeyZ0KdAKgJ5epdO/dtIQ==
X-Received: by 2002:a1c:d183:: with SMTP id i125mr7767002wmg.1.1569078274002;
        Sat, 21 Sep 2019 08:04:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l10sm7363987wrh.20.2019.09.21.08.04.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 08:04:33 -0700 (PDT)
Message-ID: <5d863c01.1c69fb81.4c94f.3b52@mx.google.com>
Date:   Sat, 21 Sep 2019 08:04:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.17
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 140 boots: 1 failed,
 129 passed with 9 offline, 1 conflict (v5.2.17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 140 boots: 1 failed, 129 passed with 9 offline,=
 1 conflict (v5.2.17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.17/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.17/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.17
Git Commit: 5e408889e4af03a27b77cf4635934fefb9f4afab
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 27 SoC families, 18 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
