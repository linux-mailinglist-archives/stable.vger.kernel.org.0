Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D3C4727F
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 01:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfFOXFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 19:05:10 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38547 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfFOXFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 19:05:09 -0400
Received: by mail-wr1-f46.google.com with SMTP id d18so6090082wrs.5
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 16:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I33zfTX+maQgKxYeyRb2VJc9p9mLqevMz5aZmVTFEYg=;
        b=qbHJjALkReVwYn6iDFWR4uR/l8S3jc5JHZb2fVZxkUeP/vnPWXkc3zbAOMsdIJjYUv
         jN2Id243D0QTkK0J09AT0asritTlc5KcVwtIp849d0Rk8Mz5TEdu1IBboYKkHUq7pG8u
         RiZiwfxLye1cjKORzYL705q5M1HpEYg5NcyDYldLi/5eevAO5TxYueTux3avvdOk8bjO
         Go3f5C3gH6nmMQ9EMe/kC9lODQW2FR+o9ig20E2Qwm0/P+5aUT7d1LAgrmilExih10/m
         R5+c3y2Wo9KMlcGr1+C29Jit5WrGWjmm2FN+HatJ7XADriREMdxluCtw9DXP6mnDxT6N
         dGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I33zfTX+maQgKxYeyRb2VJc9p9mLqevMz5aZmVTFEYg=;
        b=sG+QtrPQZLwrI4T6jnVH36KWQChnSfkVnnlowAqrbH3SLhmjC4g1zvKAP2R2Zt0C67
         z2PkBb3C+Fn3eYBIueqgp0R3fAuSxRyZjnCJBUa8PBHufbiNoMKaBrfwknGKyYvTplbc
         Yq6mELqH6ebnSoAZA5CMS9FHVADx7J5r6FoING1NdTuEG8Oi090iMoloE91YXS/Dbfbw
         US0TL/vAonLI5sajsx2qfmP8mMz9JkIYIoGtmCaAMYrF2uKbHDAy8DStkhdc0oBK6qhi
         a0URa/BqK3hss7UiSDgDqBoJb95wF4Mxx93NByALHdMmngH++hSxDPeIbS2rsL5XGDjr
         U4sg==
X-Gm-Message-State: APjAAAVnm5Mw7p0WR+7eIbEN7+SwniMoD7RP2yWWVmlolmtgCkjYMPc2
        8HFrP6XuLnZS+FEQGPSyZ9INMkBf/N8Yrw==
X-Google-Smtp-Source: APXvYqynkbF46B/IS0KLsBGptvywfbDMwS3w9DIirZPJgkJNZejqdTMdJQB1B1m5W8R57Ns7y7/Svg==
X-Received: by 2002:adf:ee03:: with SMTP id y3mr2339228wrn.128.1560639907362;
        Sat, 15 Jun 2019 16:05:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r4sm12200250wra.96.2019.06.15.16.05.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 16:05:06 -0700 (PDT)
Message-ID: <5d0579a2.1c69fb81.75b45.201e@mx.google.com>
Date:   Sat, 15 Jun 2019 16:05:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.181-69-ga35e0afc257b
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 92 boots: 0 failed,
 82 passed with 10 offline (v4.9.181-69-ga35e0afc257b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 92 boots: 0 failed, 82 passed with 10 offline (=
v4.9.181-69-ga35e0afc257b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.181-69-ga35e0afc257b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.181-69-ga35e0afc257b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.181-69-ga35e0afc257b
Git Commit: a35e0afc257bed87330986d5b0d0d8e2657f34a1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 23 SoC families, 15 builds out of 197

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
