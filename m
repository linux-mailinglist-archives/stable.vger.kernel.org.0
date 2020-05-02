Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276F11C2208
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 02:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgEBAnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 20:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgEBAnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 20:43:15 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC61C061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 17:43:14 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t7so4232027plr.0
        for <stable@vger.kernel.org>; Fri, 01 May 2020 17:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TOFHAGqLpHwaPNJe47hHXyW9QYUukkvge2aEtaj1LuQ=;
        b=zq83ZIzXEInR+2cRBYfSU1B3PnH/8iRTZUT8vyRo7TDoi54nxf9I6VF+paaHm61pnc
         7a8ECiQcmfvy0ZXPoiFRZR8gBgcuEzFxaQSxgLbPYVcGqWA1wjPMVOScIkSGsmbt6tOh
         gJqXgdCf4C3Bgg81srWYroZwrl6d80ZgQCyinuzFGJADZ+fBDfpnJw+SeTftoScoUrln
         OqGDKQ3RUErnjMgEU1StTHCuaN//ibw153psSiRH3vPhKW7FKNdQjJvo8FbzIC9nKqvP
         Egb79de4nlpX+x52/8xpuZxOfO1jrqr7C+JNLEUGExbl6gjRzpyT2gqUTobIUsXhQP5v
         RjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TOFHAGqLpHwaPNJe47hHXyW9QYUukkvge2aEtaj1LuQ=;
        b=WF2HkGEA+ew+pXHcjBB9yxrBq0AiRJp96QjejUzaTEwgmRZDLJ1Bx3hRNBg0Uw7TPu
         RFhxZIkAx1gx+AjqBdXACTdQJ9qeP+UM6oEe5VfapS+384ygawbrZ/UcFPV1/6D6KsSi
         ig2qClMnGQUkhGGDqqeihkZk0VH9vQYML1Tf375mLAJvygcWtJGzjDuK9BWkJa3lsVje
         jxnxTRf+vliGYkOZv3qUSBiLOYjUShnS7Ruvi92vi+HgCudmjfOn8ZO82w8DcQELpt3l
         wXjBjvJv26fevOqHUwBOG5Bnyb3fiUSHX6j7xHZVf+ewO4EsMQEObwCpS4wJ4Iim/DhD
         03RA==
X-Gm-Message-State: AGi0PuZU5yw6//9vlelG3MU4J50CTTg8SlraYWqkMYUX+xuOyX90G8kZ
        MQA/wJBNeP8tXmRVWJK0TdK1Draohgs=
X-Google-Smtp-Source: APiQypJ0zBqhEXzVolCow7Q3TnDjSlrcXAdzKHcd3+08kSwcTywNVxCgRwK9YQPJy8iChRbXjzHs8g==
X-Received: by 2002:a17:90a:9f92:: with SMTP id o18mr2705527pjp.180.1588380194163;
        Fri, 01 May 2020 17:43:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t103sm681207pjb.46.2020.05.01.17.43.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 17:43:13 -0700 (PDT)
Message-ID: <5eacc221.1c69fb81.b4358.28ce@mx.google.com>
Date:   Fri, 01 May 2020 17:43:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.36-84-gbecd7d89321d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 139 boots: 2 failed,
 128 passed with 5 offline, 4 untried/unknown (v5.4.36-84-gbecd7d89321d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 139 boots: 2 failed, 128 passed with 5 offline,=
 4 untried/unknown (v5.4.36-84-gbecd7d89321d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.36-84-gbecd7d89321d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.36-84-gbecd7d89321d/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.36-84-gbecd7d89321d
Git Commit: becd7d89321d9b96617ee5a99498213c703be541
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 96 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          imx6q-var-dt6customboard:
              lab-baylibre: new failure (last pass: v5.4.36-52-g35bbc55d9e2=
9)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 23 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.36-52-g35b=
bc55d9e29)
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.4.36-52-g35bbc55d9e2=
9)
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.4.36-52-g35bbc55d9e2=
9)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12b-a311d-khadas-vim3: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
