Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72FA4B6291
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 13:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfIRLzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 07:55:32 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:40740 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfIRLzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 07:55:32 -0400
Received: by mail-wr1-f45.google.com with SMTP id l3so6571113wru.7
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 04:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D2Mhzyqo/v35e/xRJ8+Nam06unYlMaKp1nR55A3m48g=;
        b=JRJ25e1/YpkANTvCTgEhV4Q1H0noNiX3dwFBB9Hviyhhp9O+l3UklzO+nahIAJQw7x
         kxXclPSstNMbRjFHN7ckjwTaPLCdNqtCA1mtxdakGJmvhJGADpTwsHtxoCbqy6mm9G0d
         gLNRKIMYehZL2hzDBiV0BwyBrwavzjckFzLlZOYHg5y0wn3LmYBT0yh/nZclt8G2gsf8
         5Pj2CwvQ2U9hmhousfk0Cpdrw9+rnxLHn251RGLSmYJolykOk9cgl822Ajk/AD0R6nGt
         eTzDrnYFREMlOxLiywJuty208rYOxbQw2G1fckKYQFtZh9C5Totj3XRj2gYaQqeteRan
         64MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D2Mhzyqo/v35e/xRJ8+Nam06unYlMaKp1nR55A3m48g=;
        b=OmWt/yDfmjtoaA9n1BQ2cEfW7YA5dxJwBWNXTaa3TZBFoogxSENpfpXLIteiVXTbN5
         CnNEoQ9u9qnS04l+3rXTDSfxb/zpBMtyKB3PdLv9T9mgarrDfKTwcD8aITiWSIFLJmjm
         NoLN46gCiXoW/qUrIspyd0Xtt8Ihv7LUKjole4sW0/iixmXYodKgpKfnucKS799cgxOz
         IoJpbjrx067gGyJ73HCpBBqRCQwUTuECsCFdr535+IwEc7bVgp9ORYOqBGbCGgk1eoHq
         PXp6AmBMN/Ijrm1Rvfc74qyaxSVi9+jWJ1cCd2SE1Tarzl3f0eZYG2+ttgJ2G3i+UlCO
         GXig==
X-Gm-Message-State: APjAAAXC2ooBkaARC32L0YPwlfNJvUhJm++yA5mqSSu99GTUJQ5CKvSL
        fmN6AeMa9HqvjEwFW5uznOPC1R8lbw1LNw==
X-Google-Smtp-Source: APXvYqwDdf3gAgBK4mq8yZaHJwL26U7yfTAGPWXSVgVB4ar6Grdk+LAHrrsZ5h0EbFCDzGeMZQdX2w==
X-Received: by 2002:adf:e350:: with SMTP id n16mr2509226wrj.99.1568807729977;
        Wed, 18 Sep 2019 04:55:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a7sm8141543wra.43.2019.09.18.04.55.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 04:55:29 -0700 (PDT)
Message-ID: <5d821b31.1c69fb81.5efbd.5d1b@mx.google.com>
Date:   Wed, 18 Sep 2019 04:55:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.193-35-gada314c30b46
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 117 boots: 0 failed,
 108 passed with 9 offline (v4.9.193-35-gada314c30b46)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 117 boots: 0 failed, 108 passed with 9 offline =
(v4.9.193-35-gada314c30b46)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.193-35-gada314c30b46/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.193-35-gada314c30b46/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.193-35-gada314c30b46
Git Commit: ada314c30b46c208151c8e0e0c77c7dae079c9a7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 22 SoC families, 14 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
