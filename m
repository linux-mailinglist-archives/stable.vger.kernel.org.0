Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B421D0A77
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 10:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgEMIEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 04:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgEMIEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 04:04:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EB0C061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 01:04:44 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so7439105pgb.7
        for <stable@vger.kernel.org>; Wed, 13 May 2020 01:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F1Bkmb1qKXIiney4vDs2ANZt0OaJ4EhSInWo3xGnfGY=;
        b=bVz7ZdHpoev3mnnYD+kjb9D9qe5LYRF5iWs0qQh3dSkTdOHSlygqk4zmMmALVnz6t9
         q5TGuppoX0U+GJI4KwfY0ckTsyiNDKkij/TQ+fBZlUj2YEIN8x8Q121I3FUvr52rLnTp
         o3BByGowU6bD6dbvkoGttWSGUrTH4bEngns08XLy4HmB4QzGDbpbqUxzGqrQxWiCoev6
         lPV61Wz3DOQMe+r+uXu5kwiff+TqX63jT1xEywvnx6Q5snJdEIaZun7vOmGznDXolnQ3
         Bvhp1DGrd1UmsXThItwyYFfgp1yUOBHMWjE6pxiiFmFv1c1STIPvX4eBvRTINo9t1AN3
         F2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F1Bkmb1qKXIiney4vDs2ANZt0OaJ4EhSInWo3xGnfGY=;
        b=f66riD1Ulm9+mA2WJl8MU/UynllPI3ajuN73kwZrtA50c5JOVZDvBSVv1XK8Miq7xt
         78b75lno4oeTI/SjXxh+Jfhh3qhZdyi/9mrDblnxUcx8409IPOVE0xIRULydTt5DhuG2
         WWOlSkCgY7rurtcDgjlrDEmSEESoro+G4G8Vpwe7pbsILC3St3FY6Cb4/HGt5Dd1UOwS
         lVf5DHipeKHbLu49z6qiAo553dj3ieveuzhS1hYAs5Cs6vJit3r1ecRcdohLCCNajz4J
         6nitzDxfM9T7D88kmCwv63sTsc2tmCR6O0UBCg0CpL60myjYG7seh2fozEJ5oz0KvRdV
         QhHw==
X-Gm-Message-State: AGi0PuaIKZgY815v/UNDuWPPj61Idc4Xjq5Gj+GKx3pycU34+1P6SNrX
        Q1w/nEYPNGnoqxX5iApiHuHl+aOb4+Y=
X-Google-Smtp-Source: APiQypJPMqQ2Epg7dlHrXTKbn3ALi+5EK/qgGjyOR+ZU0rgG5sbpkXFlwHZ8iQONGZvB9yU8bhrnug==
X-Received: by 2002:a63:5552:: with SMTP id f18mr22841576pgm.366.1589357083436;
        Wed, 13 May 2020 01:04:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g17sm3600085pgg.43.2020.05.13.01.04.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 01:04:42 -0700 (PDT)
Message-ID: <5ebbaa1a.1c69fb81.f87f2.dccd@mx.google.com>
Date:   Wed, 13 May 2020 01:04:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.180-37-gad4fc99d1989
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 101 boots: 2 failed,
 90 passed with 7 offline, 2 untried/unknown (v4.14.180-37-gad4fc99d1989)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 101 boots: 2 failed, 90 passed with 7 offline,=
 2 untried/unknown (v4.14.180-37-gad4fc99d1989)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.180-37-gad4fc99d1989/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.180-37-gad4fc99d1989/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.180-37-gad4fc99d1989
Git Commit: ad4fc99d19898b966c3fa74c7adaaee8d12da3a9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 18 SoC families, 17 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.180)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.180)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.14.180)

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

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
