Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF7E4FDE8
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfFWUNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:13:55 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:36800 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfFWUNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:13:55 -0400
Received: by mail-wr1-f49.google.com with SMTP id n4so10423320wrs.3
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 13:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lj81ZOM4eWpD0GbTEcETcnkTOVWJsBXV2HrIMTbz0BE=;
        b=ONWhsyp8NvSKkgh3NJurA/34CD3uLXGy7+Av+x5TrvcArsTIUaNAq9Aa2IWqQQd9DR
         XAhyLgs93K1sKRYY1gTpS0qOkVJIPRQAON7l5PJMjZJZsmpjV7fTjOwTKx5SrrrlFQCU
         Z2i/AHPB/Dj+BztlH5Msg0TSYTk7RM4UPd5H7mDIRe9srF7Qob9SJHsao22zDElCCuH1
         ZmIPbF3iMqhKtZZ2ztBWim9MkTsgZ3A79MiRLF179QeV9WSBVzRXW1zD+VOW/FN+0mSZ
         Qe1BdnEDB52Yv+5MgE7+LpEXQA8BeApUv6YEa13rzolicR3go/fHASt5VewOqLrXDuAR
         SHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lj81ZOM4eWpD0GbTEcETcnkTOVWJsBXV2HrIMTbz0BE=;
        b=bHI+3Y6VqeMWD7eyx0vo55nF5E3OypNamq+7qZmr4ssp87t6dqqITuG4LGZq+1Fexg
         ioc4e9sTAyMQgme5ZEwsgk3WJZ6Swttw4T/t/Mj3l8qH9bMfWYeuLILZrmAZLnu1851I
         G1tz5L2S/dpylmWhhEdTcSwAF9rsaeVRbV8EGf8cZ0W9A0KSjCX2LF4Y+rWhXAnvfj0R
         WIvMqYQaS7A7skEkJJ5HjTMi5YO9q43DoVXwTVMIEqPwWSS/y/kYyj+4Lu5ZDWSEZfdj
         y/CCUr8ceZOj9+TeS2b2N/Zm9tt2ObdhvW75AOJmwdWjVxENvxBNAYMtErJw2/32RsfJ
         d+UA==
X-Gm-Message-State: APjAAAVGFDYAVkE9LR+fiVexBzl3qdrpF09z6OWujOCE13Tqyw8MFGrF
        +FLlX0mxs2kqTDbCq+mSEqmhFFIPv/M=
X-Google-Smtp-Source: APXvYqx8Jx03I9NYoFI02hgX1S2jar94+1KpmSTO63xAdxKMi+nrQtTWkYR5iky8dtBdt+KQswcr5w==
X-Received: by 2002:adf:db81:: with SMTP id u1mr103199275wri.296.1561320832771;
        Sun, 23 Jun 2019 13:13:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e11sm21664225wrc.9.2019.06.23.13.13.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 13:13:52 -0700 (PDT)
Message-ID: <5d0fdd80.1c69fb81.9efbc.75bf@mx.google.com>
Date:   Sun, 23 Jun 2019 13:13:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.55-20-gfe2561876905
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 120 boots: 1 failed,
 112 passed with 7 offline (v4.19.55-20-gfe2561876905)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 120 boots: 1 failed, 112 passed with 7 offline=
 (v4.19.55-20-gfe2561876905)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.55-20-gfe2561876905/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.55-20-gfe2561876905/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.55-20-gfe2561876905
Git Commit: fe256187690531b19cd163d73ca03f718b7c1b2f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 24 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.55-20-ged5d16b9e4=
f4)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
