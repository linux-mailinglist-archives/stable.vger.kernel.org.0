Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5409323FB8
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 19:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfETR56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 13:57:58 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:53195 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbfETR56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 13:57:58 -0400
Received: by mail-wm1-f44.google.com with SMTP id y3so260206wmm.2
        for <stable@vger.kernel.org>; Mon, 20 May 2019 10:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2WY0IabKSdQhHGJ5mcTL+5/L5bLYjovhd3hAWOIllWs=;
        b=DL6D0/2pEGwDrMv5fF8wH+VVCMQadc18w6hS8KWRuO8d0AyyGTAIYerdzkNUnzJOof
         fOc/BlAQTYXoGrSyJLNZs0PozlLzMNb8457vctgzelNrSkxD+iz8lqTUHP7iIan779Hk
         gbgWEHHIDZ6QJFo6sZ6bIzh7bZD7J2jkrgRMpSrqmSPg2h9LwZ+JvDD9TeJyooAFmQg6
         EiXmuUcfYfndS/aLnEuQ5eZqwl2lpaPpGUJ0qJSkQw9iVTryGxOe53DxzC1jt4Xj3u/p
         q1TEy/rZ9sbhbAOo5jloHzIEw12Ak8PXmVll/rWtEZyJRgCAbci0ljdz4AuUTXeLuCnn
         G5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2WY0IabKSdQhHGJ5mcTL+5/L5bLYjovhd3hAWOIllWs=;
        b=nLLX4wZhPuVtIMU3FRT2sTihhMRSHbEU8GuzPr3fJNkY0onM2FcakUM5wfGXkXFqBr
         rlrDCX2nIwKyTo/tpQDezFBQ7yLa1LcAh9533JgIbKYynPcYf2Zu8N0Tfdf9UanoV6Z0
         mQK7jBsTw1gaFdRsWUPURYblFtHGQF2RwWku/gQg1L4bUYDACo1WYkI85xoubYmNtrVW
         LtyQ9wVI4rF6gkVHIHj7V994zlSrEDYTJWOIPrSvbNLNeXl5gAsqgkYDJ34l8Xj6xlRU
         hHUgkIVxRQdPHZdQWAfURF/aCrxz8XBk7zCTHhGtp+vVNZnCu15BVveRxNB33L+9Xj3f
         Eacw==
X-Gm-Message-State: APjAAAVB4JmuLX5zzpYpVgEGsf7v1+qZ4a0YV3Nkgo69f+v9noqH65cD
        jiAqyt9/MCAY7NEcFtSgARcoW/Sz/6/pVg==
X-Google-Smtp-Source: APXvYqxjIyA1DjVqXQ+60go0gk74DoI/5UJwVAQc7/fJRRxlO3ZB43fUp0qm6W2y4OwbPtRiLM2nHQ==
X-Received: by 2002:a05:600c:254e:: with SMTP id e14mr262104wma.70.1558375076316;
        Mon, 20 May 2019 10:57:56 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o6sm37305893wrh.55.2019.05.20.10.57.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 10:57:55 -0700 (PDT)
Message-ID: <5ce2eaa3.1c69fb81.10168.b609@mx.google.com>
Date:   Mon, 20 May 2019 10:57:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.3-129-gcce3bc9ebd2f
Subject: stable-rc/linux-5.1.y boot: 128 boots: 1 failed,
 125 passed with 1 offline, 1 conflict (v5.1.3-129-gcce3bc9ebd2f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 128 boots: 1 failed, 125 passed with 1 offline,=
 1 conflict (v5.1.3-129-gcce3bc9ebd2f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.3-129-gcce3bc9ebd2f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.3-129-gcce3bc9ebd2f/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.3-129-gcce3bc9ebd2f
Git Commit: cce3bc9ebd2fd2d9cfc0bfe53abbf3525a7fab45
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 24 SoC families, 14 builds out of 209

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.1.3)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
