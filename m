Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACB7905A7
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 18:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfHPQVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 12:21:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40710 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfHPQVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 12:21:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id c3so2067510wrd.7
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 09:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i+0HlxWH1Yu9GZm88WC8Wf1ADH/1Tm+wlnNeLonpcjg=;
        b=cWMJ9Kt3DP5RkHgMFtmWrQ0M94SfqC3Orlhho35hT2UjRJl2cosUSedXwOgP+4MUVA
         Q+c72hE/9CkVXHudXt+21Q4iHM6iSj0IZG1pBaKUb2QB+GSUGgiGdhHmt5TwaD9Fe0jm
         RNUHVGGfnRFv0KnF0pxoVEsKkPXqetsB1k7Nh8t5lyPxbk++Qgwft5dHZRRhK9OwYSVT
         5i0sZHcUNalCdTZDL6TDsyAcc4MJqDBTybsSMib4PnIv3lBMepO7lZ5W9xtLAuPDyvL1
         SbfFsKjo1PMjcC+iYirLXl/S3I4MgcDXyTcJLHpLEWu8YYVJTVlN9WaPiYyi4ifI2nUU
         wBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i+0HlxWH1Yu9GZm88WC8Wf1ADH/1Tm+wlnNeLonpcjg=;
        b=qRAnCPvDlEjBUagksni5iIxbD3fJrV4oQob/D8yKptUHYO1BggAiUIzkRwZIaBq5Qt
         dQ7Z+DgApAZpjiWAEweoKab0g9qhA5sJqZuTwXwM4qdf4uQFoMFrno7X+hipPZAzUdVN
         hUkEEVpAUM9h4AMlf86mGpNgGGlcHvzB6mOhZTSp1jsaKPCq8ZU1YS/Y/xEFzvvuJS30
         EBsmuACtiX9OLQXe5FDotTYyjYUi4JLbRL94wSI9WLAkmgbV2NcGS3LPXsBFuCYUf6ed
         Dfa6oRqk0KShvljLRPU/4zjcxyXm0WFMUnCHYhvewOfJIhIxwzm7fuGN5j5xKolYSxcr
         t3Gg==
X-Gm-Message-State: APjAAAVHUTCJKjc7iyPOPzhI9k1E2fXaA0TA6XniV8TeeCFRliRFKfjP
        fdlWnG9Q778oe1IT27b6oh+ZF0S2fNY=
X-Google-Smtp-Source: APXvYqzT/WhMv2BcXwZ3v71sabCGr0BABJQtq0/Dq9OxNQ1FzT28f0nHPytZosQDrDB+b4shcGQGGA==
X-Received: by 2002:a5d:4a0e:: with SMTP id m14mr11006086wrq.72.1565972477655;
        Fri, 16 Aug 2019 09:21:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z1sm7190299wrp.51.2019.08.16.09.21.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 09:21:16 -0700 (PDT)
Message-ID: <5d56d7fc.1c69fb81.55212.296b@mx.google.com>
Date:   Fri, 16 Aug 2019 09:21:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138-73-g1a4682459a61
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 126 boots: 2 failed,
 116 passed with 8 offline (v4.14.138-73-g1a4682459a61)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 126 boots: 2 failed, 116 passed with 8 offline=
 (v4.14.138-73-g1a4682459a61)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.138-73-g1a4682459a61/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.138-73-g1a4682459a61/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.138-73-g1a4682459a61
Git Commit: 1a4682459a619ce2e75c88d270856420db241da9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 26 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38 - first fail: v4.14.138-70-g736c2f07319a)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
