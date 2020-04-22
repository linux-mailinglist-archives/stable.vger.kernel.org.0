Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1656E1B4DB4
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgDVTwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 15:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726079AbgDVTwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 15:52:20 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AA4C03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 12:52:19 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f7so1647211pfa.9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 12:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eYWV8LsXdxtpZr7a9LyHlL9gRW5p/KSEpHf/ulUN/O4=;
        b=AL3X14gdlF1VCy+/V06OSmg2bsAG0+3iyw8N5/qHrZ6SA/tqg+k2c3o8O8h2F2k5Uw
         isw0Q/KP2CR7KR5258eE9N/hvZm8w67WICw8zxXOk2nJ0JdwgG81YlGsnqFAyJf0Tnh0
         wP6OZ/HBuqHg5hPnrXgwLxZEMVDPiosG3kUegq9W/UGW0JhsQvobdqdpZXBYxaQ3hgRO
         4RfI2GaB7Qi+XLGOAoSGUT1kKMDm/rgGsdEV9DZXflqbCbvC/Qc9ljroS3r8CAq87MQl
         4SfUaslvNScSEbBbnBHGn+Iln5IZxC7gYx/0POnw511xeLTsl3GzE2Uy/MEJEfiimHC+
         920w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eYWV8LsXdxtpZr7a9LyHlL9gRW5p/KSEpHf/ulUN/O4=;
        b=BzFJ0dMc11E4Sylel4wBKwvnrAA3aXdhhlHYhMCV1lrZos9OwFRJkNGO9JeucbN1k8
         vqkYXzsuTwZAQxZC7XEC6okOWXrBEFLL0QdOsbPG4xm7IHMhWFF/2FTxtwWxwIiLGexh
         lg/FiPhdlOsMF7XKR0AJ+nCCGzHXP44dIxjs0l5rUHGSt/oyMBcspRKRfWA6kitHUR5z
         JCirouC9a0qFfTVcZHFtQwdxSPisygRyHiKRKRzk6mhRlMzhZd8VVwLYo3+eXe3aVjPR
         X0rppEZHzcfp44J8lTCHotGyDNk2wONcLLefgB3iPlkeFWwRj1jrrlyBmFMbtXqkcAto
         e0og==
X-Gm-Message-State: AGi0Pubx758vXrSIbfqBYhmW3+nPawQVp5tzcnHca82ua7yhCwRiZjsH
        s2zXx+oUJbe1Ws/a7cXbyEsV/2jj1is=
X-Google-Smtp-Source: APiQypK84PM7T5f2TSVCQirKVByqfM7OhPF5VuzkSXIgHf8SFfDhe6A/LMcCFHgzfMbsb58yRD6BBg==
X-Received: by 2002:a62:e206:: with SMTP id a6mr151236pfi.208.1587585138521;
        Wed, 22 Apr 2020 12:52:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s63sm307345pfb.44.2020.04.22.12.52.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 12:52:17 -0700 (PDT)
Message-ID: <5ea0a071.1c69fb81.62706.152d@mx.google.com>
Date:   Wed, 22 Apr 2020 12:52:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.117-65-gb5f03cd61ab6
Subject: stable-rc/linux-4.19.y boot: 59 boots: 0 failed,
 52 passed with 7 offline (v4.19.117-65-gb5f03cd61ab6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 59 boots: 0 failed, 52 passed with 7 offline (=
v4.19.117-65-gb5f03cd61ab6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.117-65-gb5f03cd61ab6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.117-65-gb5f03cd61ab6/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.117-65-gb5f03cd61ab6
Git Commit: b5f03cd61ab67da20381e80c220d6727b914c3bb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 15 SoC families, 13 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.19.117-18-gf=
f69db5bee37)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.117-18-gf=
f69db5bee37)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 74 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.117-18-gf=
f69db5bee37)

Offline Platforms:

arm:

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

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
