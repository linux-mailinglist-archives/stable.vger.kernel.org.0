Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7527D9BE1
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 22:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437222AbfJPUeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 16:34:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51084 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437191AbfJPUeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 16:34:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id 5so218851wmg.0
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 13:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+OXRRzCRqg72QfU08vYZqUv1hrouQY4Q+8He8Y3WZYc=;
        b=Dukuln+K5eToXQng8Ql1yHdjznokIpTgdHXALfRi/lzzgcBJKdmwHFdO6bu7i9FLpc
         ZpgaKFuiGPnqgdrrgbunEFfkfAuYvfpNjv7izqCRjP3XMs/X8bHUXI1g/j/b8iYfkGX0
         SZ1ueg3By9lbj0XYdpNixH7oF3vEy9uf/b07GocnEjhHDVPd//hznJL7BqHbnNG8Kx4S
         E4znDqKk62QL7nFdLFJnPaiIqFHx8YlmtULvbxTKeho0egI+Vr0euAFTGg5Llbab0N/M
         9CM7kADyWTBi0HPhUC/zehJ26G2uqkF1lKxPKx2nhEujbXWfAX5hrnHedgizfL4nk1PP
         H8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+OXRRzCRqg72QfU08vYZqUv1hrouQY4Q+8He8Y3WZYc=;
        b=POf/ze4jQXdPPT9/kPHOhdhSSSpEbqvXKQ6g1uRatjt+dOlpDNjv4T2O5lsaReOoJM
         jjtnWxOtJd/7Ph6mJuswD8KUL4P/pNWe/zFvuP/G2/KK/wYfuVHzw7zzioNLvb19P4lq
         OUmgef315FgtCTE/Efz4ka/aJ6IpRKuoBG8R5axg/Wi8A/ScjSCvFeQC+Nx9WhMoaa5e
         J6uQWbF86bytVXLsQk1E2KzWqTnjTGwWyafGiQIprtCaeAeDQ3MHUFx6GvEjJmaDXIZf
         oGLCXLdbW6Lj5zQHxpqeKVZJMIm10T7QyOiEAXY5YHW+ll7Oca7QNoFlqE5rmGXw5eiQ
         8w1Q==
X-Gm-Message-State: APjAAAXwPshThINmLDpAy8pw2eOgOPJ+/eJnj5QSrFwCDmTUNGsHa9ny
        kTsRydzDEVcdaGrL543DzEoxC2Ux5ys=
X-Google-Smtp-Source: APXvYqx30aW9qzVP05V582nBJ+rItFir62p2M3SIrxGWZ7HRM6jo7u5OiK4JVaMaOCVWYF3Fe6Kvlg==
X-Received: by 2002:a7b:cb03:: with SMTP id u3mr4935908wmj.126.1571258052179;
        Wed, 16 Oct 2019 13:34:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n8sm86270wma.7.2019.10.16.13.34.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 13:34:11 -0700 (PDT)
Message-ID: <5da77ec3.1c69fb81.860b0.06f9@mx.google.com>
Date:   Wed, 16 Oct 2019 13:34:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.196-80-g645def690295
Subject: stable-rc/linux-4.4.y boot: 77 boots: 2 failed,
 69 passed with 6 offline (v4.4.196-80-g645def690295)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 77 boots: 2 failed, 69 passed with 6 offline (v=
4.4.196-80-g645def690295)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.196-80-g645def690295/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.196-80-g645def690295/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.196-80-g645def690295
Git Commit: 645def69029558d1f5833e6b95e81180671da907
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 42 unique boards, 17 SoC families, 13 builds out of 190

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
