Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316BABD63E
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 04:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633716AbfIYCBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 22:01:33 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:35561 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394649AbfIYCBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 22:01:33 -0400
Received: by mail-wr1-f42.google.com with SMTP id v8so4305272wrt.2
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 19:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zplZ3yZXAb1RkMNzgFffzteIogtXfAyTsMvLXupVdn8=;
        b=TzEihIYM1HEPOHZFFURGLJEF3GNc29UWaerVoFe22+44w2BbTjQXUca2dfRFihou19
         YMpwV3X6e8Be0wIoTwpEHjRTkwIlwRniQcjGb1PmjA0eGspr3DV+pU3rnwpMfqW5FP5m
         BcxiVJm5h+I10eRIbhWeIcNA3mssybeS4nk7+y34qF27h3A9xM0keLxa19bmV1YdDsrA
         ZCdn/bHPxUFXnHAvv2DZwnek1c3aHCyChGNFVPfuz9LVH7aqLcQ6enUcpF3iptbmiPJI
         Rydph6OdsmqhDdPgy9GzK8PKFdD/E6rocNY222+Fat9G5UmSX6HKMxdpKWjxLaYk/aMd
         25OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zplZ3yZXAb1RkMNzgFffzteIogtXfAyTsMvLXupVdn8=;
        b=HfvaKboHi1ozXLBQ7xW5IYq/m6ICPGzBf/VVSWJJbu4eGpwfxI2+dSQqUpbLsDPuQw
         x+h36AegB/wRoSJQ5mvvKpEVlC/ZwU6x4hiknTzQYL3V6A3HelNfoO1ptviokVXcLFE6
         MFKQyKciSAC98Ku5gBXSIZH/A6FQh5f4YVPXP/QGhbYB/5/WjiUU0BIzJmyINDqAU5xb
         HhAZsJLxCvUn7Bl4j6VJGkhFr2YYoy1iue48VHNp/Tyc5ywKi6Ikc3ntz+ZkLLZ4LxTT
         wPq6keuvoiypxbBY6leVdGdJ6oKj2wI08LbgWtkDDJzuBbEcGw0J+5WcZ8dgeX4nYU/F
         jWvg==
X-Gm-Message-State: APjAAAUUhK7BjUDmpJTltymnL8ilRDFXlDubUqbgCjYsvERXzzuN5M7x
        C2RPgp92mAvHXTqrU/8Z4V3yL0WsOgW3fg==
X-Google-Smtp-Source: APXvYqy68zCWfRkmMxlYKKCNPRcv1NauZPppTbPMux9fBXihuPbxSzzJQmvu0xZL+82zWF61pod6Tg==
X-Received: by 2002:a5d:4041:: with SMTP id w1mr5951574wrp.313.1569376890886;
        Tue, 24 Sep 2019 19:01:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m62sm1989619wmm.35.2019.09.24.19.01.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 19:01:29 -0700 (PDT)
Message-ID: <5d8aca79.1c69fb81.42c74.a1cb@mx.google.com>
Date:   Tue, 24 Sep 2019 19:01:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.194-10-gae270337be64
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 112 boots: 0 failed,
 103 passed with 9 offline (v4.9.194-10-gae270337be64)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 0 failed, 103 passed with 9 offline =
(v4.9.194-10-gae270337be64)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.194-10-gae270337be64/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.194-10-gae270337be64/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.194-10-gae270337be64
Git Commit: ae270337be64974c67c8390adb83b729f6cb0ba9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 21 SoC families, 15 builds out of 197

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
