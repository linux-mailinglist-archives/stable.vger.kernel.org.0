Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184371C4B22
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 02:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgEEAng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 20:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgEEAng (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 20:43:36 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC760C061A0E
        for <stable@vger.kernel.org>; Mon,  4 May 2020 17:43:35 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x77so47271pfc.0
        for <stable@vger.kernel.org>; Mon, 04 May 2020 17:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lEeFUCzOxVEBFo87KyjNr3s+/BWcZh0V9fGHd3tmscQ=;
        b=Gw26IHTivuqzwDAVPgmykrbd9W2e9HohPSsPLBDD+PhWR+lPlGC4HqhyNh/g1S01Qr
         HrKfPp9jnL9Nr3E/bNKsBPU1O7UmWcUKNlDfg8cy6up+RoaBvZO8nEbi/skTn3ml+TH3
         /i7Jhtw7Rp8CSiynukme0f/bmv8c+G8f7JNUk1QdcJV7ITM8sUfwQ8ct+PfW9CqR8NuX
         AhQoFQWpE1JIlW/w4mV7C0HbTtVe1qPqA1+ortmR2zexawS8xR6d/tOCoMNdDM+esqWD
         LPWtyRwQ4O0cM2cVB8iw8R4uDZkaFutfiqGZz4RFA+eGuYeMaZKId3Oe61E9z5w1xZ0j
         92hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lEeFUCzOxVEBFo87KyjNr3s+/BWcZh0V9fGHd3tmscQ=;
        b=c8oNzqcsFfk/hUAnlts2kHyjWzZak07f84Wj3FurSYfgtSnB2/AM9YHzDgwD52MdNY
         ArUjAeC0Tcem06sQVUGPbPRZzHlX5IYrCzNRtOp3iUq+InXqkg0SAdRiewhSu1B9s4Fw
         sHhHpROKMx65SZ/OM6v7ueE7HSI7pDaDeZlQqH40Vk22nHEF3d59UJy3I/IIvMhuda73
         7rlEx7/pzzrqOkzyn/t9rLjUqBCuVD39evnNHiCW1t8SdX+wj/e3TezSEWlcBCMVHaOy
         t07iKaUtNsqI9WzfoZWpFqy+PR0fEfEe5kFN9ECqBBh8jMGLrboL7qBVWV873S5mpe29
         iq7w==
X-Gm-Message-State: AGi0PuazXDSvD0z0YREhUio5tIQhAFdWQbUNgrTsuN4+phhxNzYeqwqF
        S6ygmxSm4P8JiZMzQUgIWqTjTBsszic=
X-Google-Smtp-Source: APiQypKIcrfXcfOIxPuyhbzgUvQkfxY2U6hR5aLQQOKaBKQh+FdvjDuDja/OX8+EseoVtnHzQJ/dcA==
X-Received: by 2002:a63:7745:: with SMTP id s66mr818741pgc.340.1588639415086;
        Mon, 04 May 2020 17:43:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r28sm255479pfg.186.2020.05.04.17.43.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 17:43:34 -0700 (PDT)
Message-ID: <5eb0b6b6.1c69fb81.3a91c.1336@mx.google.com>
Date:   Mon, 04 May 2020 17:43:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.178-27-g6d39cf919746
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 126 boots: 1 failed,
 114 passed with 5 offline, 5 untried/unknown,
 1 conflict (v4.14.178-27-g6d39cf919746)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 126 boots: 1 failed, 114 passed with 5 offline=
, 5 untried/unknown, 1 conflict (v4.14.178-27-g6d39cf919746)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.178-27-g6d39cf919746/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.178-27-g6d39cf919746/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.178-27-g6d39cf919746
Git Commit: 6d39cf91974673a74d6d976ecc107e43bb5c3eb4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 20 SoC families, 17 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 86 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.178)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

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

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
