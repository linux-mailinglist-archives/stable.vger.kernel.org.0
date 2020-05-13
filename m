Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732281D03E5
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 02:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgEMApR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 20:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgEMApR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 20:45:17 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB0BC061A0C
        for <stable@vger.kernel.org>; Tue, 12 May 2020 17:45:16 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a5so10349622pjh.2
        for <stable@vger.kernel.org>; Tue, 12 May 2020 17:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ursyr3uchyTaW9ssSePw4TNz8y55VPjNz9Q8Krv2dnE=;
        b=SK/zmYBDbZy6xHdKPv8p4k9eiZsMmCLUki5GLmxPydnBGddEJfqLBotP5YrRiANvCO
         l9k8TDT56NOuVK4EemqmLrOtkLfjlx8NaWU6Wj9TkMYvXvC0jAJzKGyiD355CbEMRNDS
         ZTQPoKmxDriFsZhDnqZgvlF0SmJ7imWIrFDzhVJXJDBQhtfRsVARCI7qyMEAO9dQz5ND
         LAPZ2It8EKyQXdA1o5n9geRy2YBdxSXvxlnfmglHY2klAyYa7oR8A3DztnjnXBmpJENp
         WmPLskd/MhRA70u8+L8pSeHDYdKTi7lgwDRUjoerSjtKagG1fLmgJQ7hyo4CG9wCklkf
         XnHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ursyr3uchyTaW9ssSePw4TNz8y55VPjNz9Q8Krv2dnE=;
        b=oFKAQ5vf3HqhNHzKD2qsW1FDblSjYJ7EIY+ggKVyXP6cI4Wi2XNs0C+x89f1jtVSbL
         xyOMkRsEffn7yiHEWkvmeNBU9JgieHIEnWpTXp70rvgSoxLZ5kE42pKcaLysf4pZgfUw
         B6i/IFYz/r1rje7DZtDZAYzpHX/BHsKge+WNm8hsfBsqYny88S5ZvnEMNaZPYzI0/K3w
         pjBmRaObVhAvNgyDGZR820UyrsRQubJH995vds2/0OcGJVFT5mFCHcnNYQOgzHaCT47u
         Evee0fIft9Cg77lZro+Ncv0ZwraFI3OvFlOYRoShmfOGNUfMrCFqh6bvjmUT48+cokJ+
         ofOw==
X-Gm-Message-State: AOAM530YaWq27LED1zsHQyXknWyGV4ei1G5WuOkmDlIJtjS5xvconrWN
        fQeyauZt56j/Zx8H6vMHk9a/LaGBVNk=
X-Google-Smtp-Source: ABdhPJz/gM20HGqByD5E7X4V9WnfyswqjvxmNPCIQzcJdOOrLfNz43e7Z3D4tKgY7HZcLTJ7QSRScA==
X-Received: by 2002:a17:90b:1004:: with SMTP id gm4mr1674754pjb.35.1589330715393;
        Tue, 12 May 2020 17:45:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4sm10899818pgk.2.2020.05.12.17.45.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 17:45:14 -0700 (PDT)
Message-ID: <5ebb431a.1c69fb81.3b1e3.6640@mx.google.com>
Date:   Tue, 12 May 2020 17:45:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.122-48-g92ba0b6b33ad
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 144 boots: 2 failed,
 130 passed with 7 offline, 5 untried/unknown (v4.19.122-48-g92ba0b6b33ad)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 144 boots: 2 failed, 130 passed with 7 offline=
, 5 untried/unknown (v4.19.122-48-g92ba0b6b33ad)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.122-48-g92ba0b6b33ad/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.122-48-g92ba0b6b33ad/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.122-48-g92ba0b6b33ad
Git Commit: 92ba0b6b33adce776edd773ce07fbf0b6097f9d5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 21 SoC families, 19 builds out of 202

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.19.122)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.122)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.19.122)

    sunxi_defconfig:
        gcc-8:
          sun8i-r40-bananapi-m2-ultra:
              lab-clabbe: new failure (last pass: v4.19.108-87-g624c124960e=
8)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun8i-r40-bananapi-m2-ultra: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx7s-warp: 1 failed lab

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
