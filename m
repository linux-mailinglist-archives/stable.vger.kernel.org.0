Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A639B742A5
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 02:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388181AbfGYAo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 20:44:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33880 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387421AbfGYAo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 20:44:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so48847517wrm.1
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 17:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oVLa9gMrLQRPf+k8SnAfuG1XQqfI3a6mPKd3mweODEc=;
        b=zqggpVsAH3ue/pSfHtet6qnNqbwyXW4RbHnpZt1ZGacZdiSfiq8S1sQG6bDbZKyTtb
         9nXWRI3Vr+C/GTMKlsHftnTTggZeeNf1dNuzHkIrqHbDeiMKcObZIrFhzbZlZTu2pmbn
         kGX0K9yt/hZ1ZhKY/5INT8y7UfvjI94ZCHo7YZqgY17WdtP3kyngneTu2x8wR5Vkt8tv
         XIsgmni1w/B9OJRmnh93IEoGuP8pbw2G7rfPL+uPbB/Tr8QTTm9HTDBYGUyvF9nb7LDi
         1rrTddelBwHLtcJJ93M6FdptmSsUT0mkfwdnEDnlmtt44ppIbJZ5xWegpqALDr/I77ks
         zY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oVLa9gMrLQRPf+k8SnAfuG1XQqfI3a6mPKd3mweODEc=;
        b=rSNNPYAhjemo1uwHmjvUKgLXRC2umfx+XlljEyyVC/SvVbyx54eZ9y/kfA1jw15rNY
         Q0AL3d4S+T3IQvMH3UMiKEQoWJfnfy3a65VDHgEG4T8Hz9t3mvGFRmblUcnEqipYkAYQ
         hleyptzYdZGJLVZ8J9VIVZVQzElXzepuiBFlxsqmQyAzK8xlBSgRoA0XTlSb8JNIgcYX
         /XxlNuz1OthwxVHUj2msUd/7GFE2Zu9ki24GGjZwIsL1TQDFy+qGnDlYyWGiuuzwsKSl
         fAMY70zHL02m40bAD8Bze89nX6OOyXV2BIkYvVHMx/od0SoZmXFDiKC0w69NefRh9q1s
         2o5w==
X-Gm-Message-State: APjAAAUYslqxWNy9oAt3nD6efJHwUucpsklkvsi3pA5+H5JRGuDaDxJ9
        y6yCEIaGleU63dyq/8aPa25r8JepocA=
X-Google-Smtp-Source: APXvYqyH502+NevflzB7UH6XxV+HuKw0Lffcm5CTb0IqBFR4KT5565VrBxJukbH/20JPtWECALcJ+w==
X-Received: by 2002:a5d:5647:: with SMTP id j7mr14413867wrw.191.1564015467485;
        Wed, 24 Jul 2019 17:44:27 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c78sm68849887wmd.16.2019.07.24.17.44.26
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 17:44:26 -0700 (PDT)
Message-ID: <5d38fb6a.1c69fb81.88e8f.700a@mx.google.com>
Date:   Wed, 24 Jul 2019 17:44:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.2-414-gdb628fe0e67f
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 139 boots: 1 failed,
 135 passed with 1 offline, 2 untried/unknown (v5.2.2-414-gdb628fe0e67f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 139 boots: 1 failed, 135 passed with 1 offline,=
 2 untried/unknown (v5.2.2-414-gdb628fe0e67f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.2-414-gdb628fe0e67f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.2-414-gdb628fe0e67f/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.2-414-gdb628fe0e67f
Git Commit: db628fe0e67ff8c66e8c6ba76e5e4becfa75fe21
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 28 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.2.2-414-ga4059e390eb=
8)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v5.2.2-414-ga4059e390eb=
8)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
