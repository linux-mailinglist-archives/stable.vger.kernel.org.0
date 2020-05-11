Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F0D1CDA8E
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 14:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgEKMzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 08:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728090AbgEKMzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 08:55:54 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FD3C061A0C
        for <stable@vger.kernel.org>; Mon, 11 May 2020 05:55:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id p25so4692188pfn.11
        for <stable@vger.kernel.org>; Mon, 11 May 2020 05:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yjOPeNVSzkBljym70eArtvgFHJVy8iNjrCnaNzoaDEE=;
        b=uBuz9ccC1FJTBEaYs8y4FF6dCmJevelUn9OaDK0C5F+lW5j/I7jsCZ5O5pSnhpcr1r
         mfQId+qaDB0R75p7uB7lvUuIHPUYkG2Z3LKIR2bABzJMg5xwwybmx4jpm7X6/4Qp49F3
         W6T7bAZDAQBtJpzML8w7ilFW1nhnp+wwMaULVIA+YLTeeZjiDymDIGL3L02lI3PO1EaK
         cCgJ9sG42CFMOyxhTzdfOwskesfWbyFAuBvHjks0HIol97OACHB49WBca17KWbyKWjKV
         29iWHHrLdbg9K1BvzhBbExEJGKol6VGrvIaZ6/tkVtz06zIk4Fft+MhrYbGuIS73fe6V
         cJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yjOPeNVSzkBljym70eArtvgFHJVy8iNjrCnaNzoaDEE=;
        b=bWGUHz54HUshPlf1D6rTqzYZUNH4ObjxNnutr8EcID3a4q2M0eNJ4ACzGkKRN1akSB
         gv+zTrpZdGH41l4LehMl98hyRAy9tzw4/eaj5Azik0rkKvcWySs8gaKBHXyGCHWRwiFU
         nMKjXD8jAXyp3uww3UMQeT+Seei00Bx7v/fn39ca/w3ovn6YejlBHVdheiLZm/i3UAVk
         OJnz+oNumNE5u+gkkMO5gS4R3cs3nMSjTDyE6gTWJkQwfQbBdl8jg5Tct0w6pPja4IkU
         9JQM/7laG905/4bursN3sTSN88CwIB8C/QXy/U1M7uzGQ3u7ZXMLkkj5qW85wasPZGYV
         CK/w==
X-Gm-Message-State: AGi0PuakEVIsKhkThK9b/2CdHGkfPjKxFcLBXeYMTtsn/yJHzhOI0A0z
        VZEktnU1lm/5bs4A9utFaiK9wSmy+AQ=
X-Google-Smtp-Source: APiQypInHzPtDfC5ZKNBWUuosGEi7W3z7ORQZT7bSM9QBxjE6GxJHAYyZcEGkFafcSJ+7d9Brd3K8A==
X-Received: by 2002:a62:3644:: with SMTP id d65mr15558963pfa.186.1589201753018;
        Mon, 11 May 2020 05:55:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p190sm9445748pfp.207.2020.05.11.05.55.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 05:55:52 -0700 (PDT)
Message-ID: <5eb94b58.1c69fb81.c8b43.08de@mx.google.com>
Date:   Mon, 11 May 2020 05:55:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.223
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 91 boots: 4 failed,
 71 passed with 12 offline, 4 untried/unknown (v4.4.223)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 4 failed, 71 passed with 12 offline, =
4 untried/unknown (v4.4.223)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.223/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.223/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.223
Git Commit: e157447efd85bb2e6f8deaabbb62663bccd9bad2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 16 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.4.222-307-g2=
11c2a20b085)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.4.222-307-g2=
11c2a20b085)

    multi_v7_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 2 days (last pass: v4.4.222 - fir=
st fail: v4.4.222-309-g1a571d63aabc)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.4.222-307-g2=
11c2a20b085)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 46 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            omap3-beagle: 1 offline lab
            tegra30-beaver: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
