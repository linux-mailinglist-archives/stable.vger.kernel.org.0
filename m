Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4682B1B4E90
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 22:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgDVUts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 16:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgDVUts (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 16:49:48 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FBFC03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 13:49:47 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x26so1692325pgc.10
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 13:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PGBueBDHziAVUcrgAs9hZgskr1s3CbcqQFlV8Fv9/6Y=;
        b=YCfGfFfNcSCnt4amRZXi55g7dAu8vNFO8j8FAs/glgITAxWDSuE3F456QhyGLcsixj
         RYeTL4oHnKYZh3R36B9AAaHmYk9JvFeXCcNRyP/nkXom/E1kUrzVMVWWEm61V2p5PXwr
         nsDSnOAJkrkE7JpYr+6Iv0RS9tseGqzc9AIHy1R7KeaxZbWELwofS5wEw2w0ARK+2rDI
         WmlxbDWRAp5G2d1WlLMsD+pG2W/4k+3Al/ZOp6sR+6A/qDneK5zBPTujZZ4spvnNcNi3
         sCjz/Nb0Kem2re01CC8qJMNzpy3unLyb9CUD1JMleV6SmJjIIlgmD9mXr9CCGqFRPiak
         5Q9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PGBueBDHziAVUcrgAs9hZgskr1s3CbcqQFlV8Fv9/6Y=;
        b=tuo17y/Sfm8TtE5kJRfmSlVmXSDsLEM0wtQKNSGKbqTyCT1nPMsPKED4wcAMGlTLnm
         K2kqif9aF+1hX9EJYY14bYKBLNvnoth7JUT3pflZ6qWuCQpJsAnXDAnxPBdTkHWVH6YC
         8rUM4+0A3Jl7WoVKWHVx7pJ8y5iUgaAbBEMGt4NC8H+TBBp9IMlPdQ7/opXsxPg9DpjD
         wn4a/0wNs7iagfmqjfjCOLDDaa0YXc7lAUlxpqCIX7bElvbRkaJntJQx6sZSJoSBPdmc
         AZdDvCX3p3IkMnyHu44FkMUpSpTROXCQ23gPZSjBqzNOLiwJ+Yj98tOYtxwc60ZMn826
         wzmg==
X-Gm-Message-State: AGi0PuYyxkjiD+6qb/ztfdaecPDJtEbhtn37Bxa2RmlvOLb6DGWnyEux
        IfU/ts2RH7ihZr1rXImROCUfLDjBf3k=
X-Google-Smtp-Source: APiQypLK9VbNdRUJrUhHZG5vPXYNUhgrmNsMOYA0U0vY7nFIMhwGZwppVJvh9BSm+p3+ag5vB8aGbA==
X-Received: by 2002:aa7:9832:: with SMTP id q18mr372418pfl.179.1587588586823;
        Wed, 22 Apr 2020 13:49:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 184sm386359pfy.144.2020.04.22.13.49.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 13:49:46 -0700 (PDT)
Message-ID: <5ea0adea.1c69fb81.d3a4d.17bd@mx.google.com>
Date:   Wed, 22 Apr 2020 13:49:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.6-168-g0c5e841761a8
Subject: stable-rc/linux-5.6.y boot: 69 boots: 0 failed,
 64 passed with 5 offline (v5.6.6-168-g0c5e841761a8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 69 boots: 0 failed, 64 passed with 5 offline (v=
5.6.6-168-g0c5e841761a8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.6-168-g0c5e841761a8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.6-168-g0c5e841761a8/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.6-168-g0c5e841761a8
Git Commit: 0c5e841761a8a86b28a132964a4418cc9970cc82
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 18 SoC families, 15 builds out of 200

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.6-39-gc5f3=
b541dbc1)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

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
