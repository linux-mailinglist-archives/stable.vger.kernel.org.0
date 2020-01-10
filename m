Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3E31377B1
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 21:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgAJUKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 15:10:14 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:39317 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgAJUKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 15:10:14 -0500
Received: by mail-wm1-f41.google.com with SMTP id 20so3237186wmj.4
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 12:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PwJS69BToM76KlIDH0dqBMnrQT8edcAhu/AcWdU9Y34=;
        b=bxhOtrIuZbNOjyrX/PlO1YRYV2kcAx/1NSne/h+rE2yRZnbcby/1hbLATSlHd7jWcF
         khYWBYnPlFjUlpk9g4ar3JrW1thJ7QIpK3VI6aN+pxWuZYB3bHOmOhERxbOEOU1dGDHX
         kUATWLsHDl3Bq7e+tn5MJvEe+zykv0eK03Gw3PmIpBG0l/D3Fc3YUIB+R0YRW094QfM/
         UvPBTefJUB3MIITCnMEQgKO+oGCJEWSBNiBE7gxb5nqLNYcfpTmqWIA54eHxFaMB8f22
         hjG0V8e9ODwcorBtO2e2GhfQQd2EBrC09q6Y0UFejhzc85NqSvNaGKUf7helvSzyWQmo
         8MvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PwJS69BToM76KlIDH0dqBMnrQT8edcAhu/AcWdU9Y34=;
        b=LfXalRgOkLnvW6IwkOhbTGGXetOKni6w2O3qZVR+Ufo/oo+f/1ahsu2NzIvgXpZUs3
         2GpAAYywK2iD6QE4Aecf4o3VuK9JhodRR8uv7+QYGPv2nM9v2HIJxY3M5uHOEmh/l5wM
         2/7EEBDuBqPj6cxrLtnK2ca8AE0K/YtKb4DTgC7u47di8GfE8/iY7sv0X1bMCyN7eNmI
         44o+gXD2vC98lHAsRwQR21Z2+GHtTGcCgUD1GgaHHcQNeCCIYE3CdnT2wsM+RQMPJJw9
         yksXx/Il9F668L5gYy/9CGRmtotOYFLTjFEsY+u1OgNdeKVg5bmpaFktx9EKye2XcVrq
         v4NQ==
X-Gm-Message-State: APjAAAXfgqAvx+oCmouHDZJzCUcHZV2Vtgt2mJ7mrdve6KQxaN0ZO+SI
        4msFY/k5m7vLMQXkCKJZbsLBVygD73IJCQ==
X-Google-Smtp-Source: APXvYqyUR3hujU7gyi6n7zYa1wG3HwiCItScru8E1X0z3x5+jHw6DmmfU6Nl8qCGLtxdPmsGzJaMbw==
X-Received: by 2002:a05:600c:409:: with SMTP id q9mr6038842wmb.19.1578687011978;
        Fri, 10 Jan 2020 12:10:11 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k82sm3522751wmf.10.2020.01.10.12.10.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 12:10:11 -0800 (PST)
Message-ID: <5e18da23.1c69fb81.6717d.0ea1@mx.google.com>
Date:   Fri, 10 Jan 2020 12:10:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.163-48-gc277ad1cbef4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 45 boots: 3 failed,
 35 passed with 7 untried/unknown (v4.14.163-48-gc277ad1cbef4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 45 boots: 3 failed, 35 passed with 7 untried/u=
nknown (v4.14.163-48-gc277ad1cbef4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.163-48-gc277ad1cbef4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.163-48-gc277ad1cbef4/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.163-48-gc277ad1cbef4
Git Commit: c277ad1cbef473690df9183fe3accb307f93094e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 10 SoC families, 11 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.14.163-42-gd508caa26=
185)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre: new failure (last pass: v4.14.163-42-gd508caa26=
185)
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.14.163-42-gd508caa26=
185)

arm64:

    defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v4.14.163-40-g258da0180=
e68)
          meson-gxl-s905d-p230:
              lab-baylibre: failing since 1 day (last pass: v4.14.163 - fir=
st fail: v4.14.163-40-g258da0180e68)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.14.163-40-g258da0180=
e68)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
