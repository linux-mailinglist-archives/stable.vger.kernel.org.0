Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2531D2040
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 22:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgEMUhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 16:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbgEMUho (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 16:37:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82DDC061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 13:37:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ms17so11496793pjb.0
        for <stable@vger.kernel.org>; Wed, 13 May 2020 13:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nu0hW+M1pebW59JVnAn3mGOG+YT94LSbEEyBBC7jPdo=;
        b=YlFt+AH0mSVMXpOp/P9FZDfGP/Cj9nIwUCZnNcEbdSb8ItCGBSfZKLsZd2YP7bNKje
         81QAFhUGFU7EBxIxZH0qqJbx1hcFjEq0vbTi7nrAVS4Sw4xb+fHnnE7TP1ypzg78nfy9
         w8aOmE0U4ctb2oIuwVs3YdZswDLz5NgyGSLoKuXE2soHs2+fgqzr4mtxajj0ykAMbo1g
         TxiirZof4yXjUf2Qiutv2lN6j2kTDZNhbQ/LOXmWo6NnYrCsON/kjCxFzArkv5ClQFa+
         YavrVKGd4Uhra2Og1u+t2vp/JiOqFi0l2jWAGAhEYPMRidX6ibg0k8ew48FCRH+p6HvD
         mUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nu0hW+M1pebW59JVnAn3mGOG+YT94LSbEEyBBC7jPdo=;
        b=lIt0x2gGdm3Q5h1I3iF4BvmkwU0v226kJSfstEIEd5xRLxfAKmD0sCJraqW8IujY3o
         Kaqi6BppcR61oUTfbuj7wQ3HNsA0UgP8V9fI4VNw8JS/wjiSBLwOi6aW6FOSdPC9H5yO
         wlZFZWNFUyrcaEcXc5IGK+7NAN7mO1Vx7LO5msXceVHpIR7aodjUKqQA8JrcBle1fjRM
         xnv2rfy/hKXiNbnpkN0XLuoT0nXPi0CczcNytRvxD3uSfqZQrhvMeVfj0+IYMXX7PVWr
         O4urIm+W8+gL63jWYzIAsKTYtanibHvJQt10Ae9cflgjuuCx0fojpuI+EIZBKKbD/WeC
         rvcA==
X-Gm-Message-State: AOAM53208l0tZWg/SsJWr5AjC3fgqmgdAiga1Mmw2G5gMK1tu06PO5zd
        w1UDT2BLcwhWhsmDzejNFzlsyPk8ATk=
X-Google-Smtp-Source: ABdhPJyDVG64wx+27eDbpl47L6DqmUA0qNcaD0F7a+ChcEWEZuZKvH8dCgva7jO66GRpQNLeDkESqA==
X-Received: by 2002:a17:902:fe03:: with SMTP id g3mr937086plj.28.1589402263964;
        Wed, 13 May 2020 13:37:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w13sm354719pfn.192.2020.05.13.13.37.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 13:37:42 -0700 (PDT)
Message-ID: <5ebc5a96.1c69fb81.5fcc3.1650@mx.google.com>
Date:   Wed, 13 May 2020 13:37:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.12-119-gf1d28d1c7608
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 130 boots: 4 failed,
 118 passed with 2 offline, 6 untried/unknown (v5.6.12-119-gf1d28d1c7608)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 130 boots: 4 failed, 118 passed with 2 offline,=
 6 untried/unknown (v5.6.12-119-gf1d28d1c7608)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.12-119-gf1d28d1c7608/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.12-119-gf1d28d1c7608/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.12-119-gf1d28d1c7608
Git Commit: f1d28d1c7608478dd10b7a36c40f2375bcc1648e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 90 unique boards, 23 SoC families, 19 builds out of 200

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-g12a-sei510:
              lab-baylibre: new failure (last pass: v5.6.12)
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.6.12)
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v5.6.12)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12a-sei510: 1 failed lab
            meson-gxm-q200: 1 failed lab
            sun50i-a64-pine64-plus: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
