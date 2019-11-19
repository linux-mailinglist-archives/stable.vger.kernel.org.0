Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69BB102614
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 15:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfKSOL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 09:11:57 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43356 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfKSOLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 09:11:55 -0500
Received: by mail-wr1-f66.google.com with SMTP id n1so23981916wra.10
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 06:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=//MJCMbKx7BFr7A6XuDVtkr5kfgTstgjwnzawfqPlqs=;
        b=cK9pFgPeXoGYAvdM9QmD8YDagZlurfqTObqcHWX770RfvmpdBrLGAxwQHFAtfhcusr
         YrNjVaUP/lOZeN+ov3X+j93GshkMTCiil4x+C9mpph1zyPHolOZPBF1Yc6Rkxj0tfSr8
         K9AvcK6M3t/n7FLt3QP4EefCdpynWwOahJfG9l6DcFpjRkXtsgG/7aw0EgFBOS3YqfjE
         wdWkvvkzL8Qoijx2u0hifoRTZWM2WIoVZqZqUqYngov3ZUylvJB49cup1j1vhbVBa+IP
         TNg9xWFA0oO3OFoKKQIsAylD6UL4SNMmmNsWwuu6xfudvQMjso2tORjVtR+QPGjw7hxd
         8KTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=//MJCMbKx7BFr7A6XuDVtkr5kfgTstgjwnzawfqPlqs=;
        b=Iai2PXqmvh6UVVJWrHY6rgLC849h1FNEKdXGDrqIe6sLL9XpKjeJEMZuyRbA9pV8oF
         8qqPl/k7EPb1og5ZYsEpuYheeQKTbCMpVu9A+LK5MXPBdkj1tK49V76Ne+kudcBYdnLE
         aeb/9lRmW9ZksmAfPAb1TMA6s7OfcRDOCCQW5ouF19ui7It2b3hV7WDGPbkqKFfUaA8v
         WIPmbHdctUu1qxyDJ/dkXTR89dwtMHkSyETqxCtlVFYKxIfp7A1jikfh4WiZ0ewHxQwY
         u5XH8SEuA8AzMdRiZXWvOEjfavjwJpWt3rpEw8PevYYR92th1lM6A1ynzsXZp259Tu9c
         DbKg==
X-Gm-Message-State: APjAAAV0YCIOvPyNXqeEk2XqJRrUUyaExidNP447XfBUqq56MYncrgFj
        TyysB5spRyNDhtCeF44FvbgjucplxLCclw==
X-Google-Smtp-Source: APXvYqy8TI1DDQ30OiV25tqZGLtCpyOPAlpzefCK/+IfS3XSJJ9TTOQ1MtY9JUW5jGP8pwPjH8WoaQ==
X-Received: by 2002:adf:f20c:: with SMTP id p12mr34357650wro.379.1574172714159;
        Tue, 19 Nov 2019 06:11:54 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m3sm26843732wrw.20.2019.11.19.06.11.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 06:11:53 -0800 (PST)
Message-ID: <5dd3f829.1c69fb81.4b91a.004b@mx.google.com>
Date:   Tue, 19 Nov 2019 06:11:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.154-240-g8dd59dbecd7d
Subject: stable-rc/linux-4.14.y boot: 100 boots: 3 failed,
 87 passed with 10 offline (v4.14.154-240-g8dd59dbecd7d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 100 boots: 3 failed, 87 passed with 10 offline=
 (v4.14.154-240-g8dd59dbecd7d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.154-240-g8dd59dbecd7d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.154-240-g8dd59dbecd7d/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.154-240-g8dd59dbecd7d
Git Commit: 8dd59dbecd7db5dcf057d35a76f5f998f0c90d3c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 20 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
54 - first fail: v4.14.154-240-gab050cd3bb84)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.14.154)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.14.154 - fir=
st fail: v4.14.154-240-gab050cd3bb84)

Boot Failures Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
