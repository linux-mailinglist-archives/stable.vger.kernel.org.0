Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3616D1AB1C6
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 21:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410911AbgDOTcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 15:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2441804AbgDOTcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 15:32:06 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB34DC061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 12:32:05 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b72so455169pfb.11
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 12:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O6pdH3tA1qmZHNSCStJwlcAFRQhhEkcv+uEDFGGNyFs=;
        b=iu9BRWZAT3h/opLHUajLPAAPtNwOC2uKCpjgOT0ChR2C5UcaN4YTiBpGfmVcCs8xia
         GwD7nCv0SzIzblNNFJYJhpNTdOHtYG1FBr/qTV4bivTEHkKM+pwQtBq7V9lAMvOJsA0M
         zPNMCkquzLIF+veeCsden7K1NOylX2l4Y95k6JJEJZ2I3Lic+uQTLjXYgsnXmpneV6tF
         O2C7wSk1IMDFZVzGET4PnCRBintj35CbMEi73FV64grNzDgArYT6oG+kP77Exs1Tb8jw
         3ZK03Lm1bbsYlR6fU9IJJiZEQ9eRBaZY3s7B3dt/cQ5o9nbufVmbl6mX1AidIpv+4zxV
         luuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O6pdH3tA1qmZHNSCStJwlcAFRQhhEkcv+uEDFGGNyFs=;
        b=oX+vlRJ6Ab1HOa3TXKInuzc7Uy843rYft5z7VJkU7YjtMTgMWwhbyBBIqvtIjm64Y2
         PzyI3ptKSZ9BfyuCYhdloqBdL5HiJs9E4ir5ECzzFeeaOaD+Igsvp3keR4QJOQNRdZCW
         lx9Y+ZvP7jdRI/uugDOQecml5JCuKsCsS98FLsVLK82zsPW8aMxp3PGtw3yO5Z+iNkdr
         Ojsz5ogoMEI6nwa/lxjCM8i2nIId2A+5+EfHInxQ3vjfAmOa7A1OgPCVVmY8XHmjN+Pp
         Vi5Dwxkgq1ErAAXlamrTnZhykfTAsoDtu6HM1hWA2tWXiC7UF0B0n3K3wBO4mET1aVsb
         XqDA==
X-Gm-Message-State: AGi0PuYnI0DzaB7015+PtyR+Ez5j3hFwgULJK3WJkMGnkpiOOt4bw8yR
        iGNP0DDaVI+dWIJLUUgoQjUm9mKfy0s=
X-Google-Smtp-Source: APiQypJZLGFCShksWx30YOgIBlsaHDT3WG1hxaYs8RURssxAsC+4s3cK/25290m4auPAUI37LMQC1Q==
X-Received: by 2002:aa7:9e42:: with SMTP id z2mr28828220pfq.109.1586979124929;
        Wed, 15 Apr 2020 12:32:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7sm12455963pfu.90.2020.04.15.12.32.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 12:32:04 -0700 (PDT)
Message-ID: <5e976134.1c69fb81.eb2de.be5b@mx.google.com>
Date:   Wed, 15 Apr 2020 12:32:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218-80-g197dfb137d6a
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 96 boots: 3 failed,
 83 passed with 5 offline, 5 untried/unknown (v4.4.218-80-g197dfb137d6a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 3 failed, 83 passed with 5 offline, 5=
 untried/unknown (v4.4.218-80-g197dfb137d6a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.218-80-g197dfb137d6a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.218-80-g197dfb137d6a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.218-80-g197dfb137d6a
Git Commit: 197dfb137d6a7ddfc9083c9bf4df319c8041edcd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.4.218-30-g8cd74c57ff=
4a)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 67 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 20 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
