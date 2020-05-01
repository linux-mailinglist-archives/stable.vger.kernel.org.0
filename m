Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0801C0F46
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 10:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgEAIQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 04:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbgEAIQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 04:16:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA61C035494
        for <stable@vger.kernel.org>; Fri,  1 May 2020 01:16:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a5so2059842pjh.2
        for <stable@vger.kernel.org>; Fri, 01 May 2020 01:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mks1ORbPc1vsdESVE66hWscgKDfuOmnOCjrpWi808Yw=;
        b=uvZ/6sEHam7w+pIlj5UlV1HELwwLkZTKzwHmAuIadN/P9fVkw96+zcGxtiTLZubDOF
         Abnw5Og8DXd5SAUi2VOk97ENxpZkTtknTmEG4csQ+3gFrY7F3betCxdn9KrtKgPKQLIW
         CPM/8TxsHfZ0z3+RGjFbZwBKeSqU3/DRWLHjm5Rrl2luqS0DJP2u57uKdnsPomenxudP
         Gw6gLksUmzI1RXuyKE44GMyWo36KwQw8eFRofCLAWvbdMXEk58jEZigSQ9D9AG2JJ4OC
         0IKg2bxDpX9UE9anDea48RWVyWEX3qwUBf9yhsPUvY2JY2D9cAiHaxWA+nY5XDj4yHuB
         G4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mks1ORbPc1vsdESVE66hWscgKDfuOmnOCjrpWi808Yw=;
        b=Dq6UA9ymvlDz1ufs6GfwCogxhE/qLeB2H55uE+1wCIgEBCF4YA/SGul/HBQoomQUB2
         0FiTmgdaME2WNrCRf0Jpu5Mg11336s7jKHwiaSgmz8at96y66Mwu2p7upOkm5Cq1VZDL
         x6Ms7jgMlCY95+VmcGQwx6fngl8eMes8nyx+Ba2y1W4CCF0C+sqJBLx92BYvvnNWZjSX
         bRF2/Qf6vBXKyBcEGObrKLBlIZTcbs0O3jYvqhOBICRSQ0fYnaHK/6Sn9LV+PLwrcSMp
         DMkZVNwTntqwTOYFyqI9f+pfBLZHOXiLeCds62voatmFWAD5jP6/HFN1kqgnN+Fox6yG
         w38Q==
X-Gm-Message-State: AGi0PubMxe1suyWkNS2Qyn9a5KWZ36SBHCltfnP7XHNTYO8GyH/aqwG1
        40GE68B4cFKE2B4XrXnzQuqtCzn2Y18=
X-Google-Smtp-Source: APiQypJpfkeFMBtYlM72DqnEogMSO6fW4EQH4XpgaFCBuBsRA8nyxmE6pbQwfoEypg0+iW4EZ35caw==
X-Received: by 2002:a17:902:522:: with SMTP id 31mr1144319plf.68.1588321005695;
        Fri, 01 May 2020 01:16:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b29sm1653921pfp.68.2020.05.01.01.16.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:16:45 -0700 (PDT)
Message-ID: <5eabdaed.1c69fb81.8a8f5.6d17@mx.google.com>
Date:   Fri, 01 May 2020 01:16:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.220-66-g764c88f8b2c2
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 114 boots: 1 failed,
 100 passed with 7 offline, 5 untried/unknown,
 1 conflict (v4.9.220-66-g764c88f8b2c2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 114 boots: 1 failed, 100 passed with 7 offline,=
 5 untried/unknown, 1 conflict (v4.9.220-66-g764c88f8b2c2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.220-66-g764c88f8b2c2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.220-66-g764c88f8b2c2/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.220-66-g764c88f8b2c2
Git Commit: 764c88f8b2c286cb1528f4c1ec059ad3bbc0ba28
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.9.2=
19-125-g01b8cf611034 - first fail: v4.9.220)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.9.2=
19-125-g01b8cf611034 - first fail: v4.9.220)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 82 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.220-59-g49bfc79b0=
bcc)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
