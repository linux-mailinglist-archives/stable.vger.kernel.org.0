Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7DFDD03
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 13:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfKOMGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 07:06:02 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38840 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfKOMGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 07:06:01 -0500
Received: by mail-wm1-f68.google.com with SMTP id z19so10146571wmk.3
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 04:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NBITj17KIDDQ/wzdId3cQD3bmEwVbK2XADeS/shNAmE=;
        b=vJIt5DdvANyNpwESaFAnzPhuYUaSdLkjzwP9Val4+cQuVfSyUrfJ3ztu7vj53TfH7H
         TfWa08A2xhnHLsUkRes5l6eNUcRFx3mXecQdNjARlOfrPTkgZVr6NqvCM0b1d7AyUSWy
         bvNz9aElWrfpAHpjSI0Fn5GfxJuzxBNzcCjOhlpIwBVOhomgYRBy7swL/+0MwUFhh0zA
         3f2uWI0NbitjDs+1yR87J/YfUBYCjLiV3K87fAn8d+9Uk/loeXQtwqPvLPeE7ZvD1H2T
         w71e8rUiCTOMDgYNI+HqC9QUCFilhl1mxSWqttsN31i4/EKuqy6NfBmhPaHZbJK8jeA0
         J2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NBITj17KIDDQ/wzdId3cQD3bmEwVbK2XADeS/shNAmE=;
        b=DEksncV1ZZPvK8d4ywKcOyhgnD9KX1TKelP1WHp4r8oCgQS2q2esMak2WwTt0OYjsW
         aPxN3nOIH7ddO1w7dlXlDOF1MmU48j3eL7eClSBiuVxTvPodQO4zdk8UGhHPgNVCRZkA
         Yb2ozq2pfyhNXdDED107qFn2YQaafpvmmk0s6xMIWPvG71YN3GcaHzmuu3iH8lUWM0Xm
         jNc5w0XN7851nmEZgpRNMMOwkgPjibpAK4bMfs0vrGbhDnmRkKRo5/BBJDQWgDWt31CZ
         yqsOZcHeeUu7D7gn5jVL6R6OTZVbeG+JtQ6UAhUxCDj4oMqBZ7lvak/SOELqCpJiLKsT
         dq0g==
X-Gm-Message-State: APjAAAUL0MVyUH+BLw3Wl5+8/qTj61YX8iQ8ix6cJrS/owaTgcE160pM
        WAby6OIX0aO5NBUbSjXG6SDbCqzxKf4FeA==
X-Google-Smtp-Source: APXvYqzL5/GuS/XGmBsNXlYgin9Xs9raVkyQdOygK1bd77dkRj/dFYpm3PALFSC+/bBElzy+XiwGxA==
X-Received: by 2002:a1c:7701:: with SMTP id t1mr15385356wmi.113.1573819557889;
        Fri, 15 Nov 2019 04:05:57 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l10sm13106774wrg.90.2019.11.15.04.05.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 04:05:57 -0800 (PST)
Message-ID: <5dce94a5.1c69fb81.13455.d7c7@mx.google.com>
Date:   Fri, 15 Nov 2019 04:05:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.201-21-gb0074e36d782
Subject: stable-rc/linux-4.4.y boot: 80 boots: 1 failed,
 75 passed with 3 offline, 1 conflict (v4.4.201-21-gb0074e36d782)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 80 boots: 1 failed, 75 passed with 3 offline, 1=
 conflict (v4.4.201-21-gb0074e36d782)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.201-21-gb0074e36d782/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.201-21-gb0074e36d782/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.201-21-gb0074e36d782
Git Commit: b0074e36d782e84e6a2e08910103642762949d2b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 17 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v4.4.201)

Boot Failure Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            bcm4708-smartrg-sr400ac: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
