Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3A51D3C63
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgENSxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728661AbgENSxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 14:53:22 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672FFC061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 11:53:22 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id hi11so12945253pjb.3
        for <stable@vger.kernel.org>; Thu, 14 May 2020 11:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F6WLU9w6PeX/s4H3hi3K3y+xcBMPlMa1VaAKCsaR+Yk=;
        b=zgMagJk8qJ3fd/KicQnoIdwNC+HnY7nAXak6kuQKovjYeMpmXZBvSzx6BWdoexIt5i
         1XSYLlPxzvjX61SKlwG7Jqk4tjQmISD3nyRDNHndtQZUhTCzOxPeScKlQ5NC4URk5d2H
         xaPZV+ufOaB1hebvTeRpJML7/xtsw+as//esiKw6LGJl54P2k5p+7v9HB1qKGY7NLQzR
         usyeWOlSWnDVzkMyR8CcZ7x9Vnwf5s7jDyXqiXOn1wy0JvYHKujgJrgxDgpCYs487nqq
         d/FVPUCDFXXbSKBEGvG3j1Sz3s0zpy0XqIbsR586C9f70g9+vstnHGZJQz/WPD17Yvfi
         D1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F6WLU9w6PeX/s4H3hi3K3y+xcBMPlMa1VaAKCsaR+Yk=;
        b=nrJKDJSWuQjKwxK3s96A4SQUOdXzC4Z7PMw570Cyeq/sGIEnEdYaGb9nPcGe1Ve8fx
         DPo0gDo1I0kmXydZnH2i/pwryo8/CMNwmBR2tGJEqYFVtJNepLvuYzjz09YIT3GzPntw
         f8r1DxFkGmgz4wrY8vTA4KSs6U+eUta4ev/PHzhbw6jU14ZQtKKzfrNHv2zqxCwZGlP3
         Br4rwN6BRAhW5eBOciv+1ftH16sc4d/+lIP48xcJqZr6FJCmaXyOfpmyrlF+yaOXwSrf
         kHUbPBGI0mEAOdGAhWjSwiAO8L9R6yGiGsx0ytx+z8sgvt6YhHEYjWWRcuq9Nbq9eFLI
         KmzA==
X-Gm-Message-State: AOAM53330SahYX4MgAmCVm2kir9zkp4N6RRJxNq16RRuxZITqmBFn43o
        7JSX0c0uOR5ph8FqgPxotwCUEeoTVUc=
X-Google-Smtp-Source: ABdhPJzv2M83+ro/XF6uj6fQyZSwbyHda6FAQ5Q95wChyFoeXXZQ0KNtwxbHf1NuEkItGh/cDXl2rw==
X-Received: by 2002:a17:90b:358c:: with SMTP id mm12mr433889pjb.134.1589482401605;
        Thu, 14 May 2020 11:53:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21sm2919405pfn.71.2020.05.14.11.53.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 11:53:19 -0700 (PDT)
Message-ID: <5ebd939f.1c69fb81.e6494.8aaf@mx.google.com>
Date:   Thu, 14 May 2020 11:53:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.223-36-gceb6b0b3f45d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 92 boots: 3 failed,
 81 passed with 3 offline, 5 untried/unknown (v4.4.223-36-gceb6b0b3f45d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 92 boots: 3 failed, 81 passed with 3 offline, 5=
 untried/unknown (v4.4.223-36-gceb6b0b3f45d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.223-36-gceb6b0b3f45d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.223-36-gceb6b0b3f45d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.223-36-gceb6b0b3f45d
Git Commit: ceb6b0b3f45d368cf15b65cb3d690cffaab7bf38
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.22=
3 - first fail: v4.4.223-36-g32f5ec9b096d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 49 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.223-36-g32f5ec9b09=
6d)

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

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
