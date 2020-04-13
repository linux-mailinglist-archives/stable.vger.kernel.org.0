Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934261A6C2B
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 20:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387753AbgDMSnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 14:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387752AbgDMSns (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 14:43:48 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E75C0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 11:43:47 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mn19so4165783pjb.0
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 11:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8kFVp2Pj0iT0F4lR5PdqWAtZFU3tyWHID692Dq1qzT4=;
        b=l66yAhy25+J2HdeYylzERg/ANXU7h8EtJ00nOjNaaQFf4XFo/YqLbLGMDsfhwztdz8
         alEkTjXoN4VOuIilb9RgH0Bue2jgLsdTZu4Kpfu0DWpbc5Or+F5FAFZQizodBHkDZZiv
         NcPqSfoOFw8/ASdJsLTwN58ytcsby0IuJZznuConu78Kkyl0ZVsL6sDD9WguMd6bTCut
         fY+v+zICAm8zJ1QAapQQk/z9H/QWJR+clTidBqrJHcGILx6LJsBHWouSZ+yRtaOqE2hl
         gbY4n59qZrXqZfmYLPVG+AJKBeOUFc4DUJfyAXXgiNPI4vAlQ0BCoSRYf3dD5e2nC6hv
         JCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8kFVp2Pj0iT0F4lR5PdqWAtZFU3tyWHID692Dq1qzT4=;
        b=qfd1L/fh5a3tio+iTj82mAwnEisw/0WsSXIWmlMNwsL6escWqgmvUTxALyT4fToLL1
         4vYhpAbjilqXbXuJEEgi8lpNba8ugjL4JVEfZR1OdXDK+w+9VoEBLR360IMLG/F1C72G
         +plFqRpx3z5VFSprB1GGvu9BeCgOzg/UYBB1AJsJPRkX3hT6j1RItlUIjjw3xOjYxGUi
         Sf1R9BQhMetxSvX6nN7eDVifqZxa/OVHlXpbEFd5gn5qTEsAdnEIZv5OMA2i+ky995Xq
         gIcxzrW+eVnt5bGhg6urGxFP8QD+mu5/cPe9cggH3BJwDQIvc0Zbp2hDQEk/FmVOxv18
         a0dw==
X-Gm-Message-State: AGi0PuZOPvh/jKO+BdEErWlQeKcMJjXAyq/zcHBziEX2VLYIot3rAcam
        zXaR6T71gwicEtyTIhAe0nfWKAX9a6M=
X-Google-Smtp-Source: APiQypKAOYPp90CgYsZnHLmyGnCwomTO0Yz2IolFBvp0NrpzENdAIcH7Z3UjuiX/yi8jXQSboH8f8Q==
X-Received: by 2002:a17:90a:c295:: with SMTP id f21mr16077161pjt.176.1586803426571;
        Mon, 13 Apr 2020 11:43:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x63sm1063798pfx.122.2020.04.13.11.43.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 11:43:45 -0700 (PDT)
Message-ID: <5e94b2e1.1c69fb81.1faa9.2c3b@mx.google.com>
Date:   Mon, 13 Apr 2020 11:43:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.4
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.6.y
Subject: stable/linux-5.6.y boot: 101 boots: 4 failed,
 92 passed with 5 untried/unknown (v5.6.4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.6.y boot: 101 boots: 4 failed, 92 passed with 5 untried/unkn=
own (v5.6.4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
6.y/kernel/v5.6.4/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.6.y/ke=
rnel/v5.6.4/

Tree: stable
Branch: linux-5.6.y
Git Describe: v5.6.4
Git Commit: 0a27a29496060843ae3a8fe78aaec0062cbd5dfa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 64 unique boards, 16 SoC families, 17 builds out of 200

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v5.6.2)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.3)

arm64:

    defconfig:
        gcc-8:
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.6.3)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
