Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4121D0453
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 03:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731604AbgEMBab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 21:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgEMBab (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 21:30:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9539BC061A0C
        for <stable@vger.kernel.org>; Tue, 12 May 2020 18:30:29 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t40so10251631pjb.3
        for <stable@vger.kernel.org>; Tue, 12 May 2020 18:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jeuTjskCsiMDuwRsvjTcpT140Ed/PL+uXa/ukvFrpm0=;
        b=0OicHegi0n8sYDJlLVzVTHtLlKPhJyg8nQeiHy16fK7PqazxZepIiTYRWdj2b48nyU
         bWd4H8S24Dws+RYE/DAHSZCBOOfqbKu1/LlD9PEcAuVqO+7K+oBhntmeYe+Nl746eabD
         r7r1Qsyh05AZIBVKGbBpdV8uLoIapkL6bXbtagkvWKuqgthmvVZQYuc5OPYNwpkSFlrX
         3pOsCQlY35S43I4Y1IXa0GzYBc8D9QyYID2fNRXGCu0X07g1pXHnQa4y7vrfAXp9to7u
         zkvmY48kERwWWtrqmDLcUUnwLXB4jRJj0d3J8yZ+0h6nneO6cQQkdLSnm3LQCOe0GWww
         MWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jeuTjskCsiMDuwRsvjTcpT140Ed/PL+uXa/ukvFrpm0=;
        b=VqGwLV2jB0WccQPXBD45QIg7084kOo4FCacUeccI/QyaGTchdmkz2UyYMgDVSvBULP
         fxwvZ7tS5E2I+iRBD7BI7bbYZKp0QNk9ytxZSOhMEGaihiylECXGuZu42xGSTAtsbg3G
         o2oCeSkNhcKRKWXqgliB9gnQixv0NjiJxEqrch/kaFV+pDPjcUvPCdZ9nh/bycZb+8Gd
         TWd/Gluhe6YT7m+BQ0+i03/hI91rW7t0PX9QWdn8USMNtBKZELV9KVP51z0bxCV0oTyX
         wXFB7zGVKGN+dfEHg2cOay0wmSM3r8ILgnveCxo0K4UtTigb9qc5qHyuKBFFgTObpwg3
         iPfw==
X-Gm-Message-State: AOAM533WFyjaIiynbr6GFWBGx5UIWT/5lzjpSN4z9Hw3aT5Z18Yu9Liq
        7vC1+kxbWAlcSa+LLdmCoIKmlNo0VUU=
X-Google-Smtp-Source: ABdhPJytBKYGpanjY56j015gGohG1ue3sl8PPlCnJGxQu8vKzZu1z3MJQSmzhYGo3J7FrSm4eixgrw==
X-Received: by 2002:a17:90a:a102:: with SMTP id s2mr1390915pjp.94.1589333428575;
        Tue, 12 May 2020 18:30:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13sm2978335pjm.38.2020.05.12.18.30.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 18:30:28 -0700 (PDT)
Message-ID: <5ebb4db4.1c69fb81.5b9f6.c562@mx.google.com>
Date:   Tue, 12 May 2020 18:30:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.223-25-g6dfb25040a46
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 110 boots: 0 failed,
 98 passed with 7 offline, 5 untried/unknown (v4.9.223-25-g6dfb25040a46)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 0 failed, 98 passed with 7 offline, =
5 untried/unknown (v4.9.223-25-g6dfb25040a46)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.223-25-g6dfb25040a46/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.223-25-g6dfb25040a46/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.223-25-g6dfb25040a46
Git Commit: 6dfb25040a462e890aebd5342dbb6878a3b0177c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 18 SoC families, 18 builds out of 193

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.223)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.223)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.9.223)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.223)

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
