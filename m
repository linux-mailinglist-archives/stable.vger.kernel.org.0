Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0138311BD6
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 16:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfEBOyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 10:54:44 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:54485 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEBOyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 10:54:43 -0400
Received: by mail-wm1-f44.google.com with SMTP id b10so3267799wmj.4
        for <stable@vger.kernel.org>; Thu, 02 May 2019 07:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X2PevsvMgcYAF5YoSEzLskwnOJa9F0Jfxq4jGYPV3tE=;
        b=0bVr+RtjcnuNIzJkIwVzO6bdUksYN5IkEVF1Pp4XlmyOKlz7IJPdPs6m0NOyDPkFhC
         fzfkqyMKWYfZ0CQF87YfPBy9RsqADO+BM82bOq7vigYS0GTbrvzhm1T1Kqxjln8nHUxk
         R/Oy4FWlI/oAohl7KmpbX1TxdB7sE23vVebKSUmLAFwOFPJPYTEErrTUIg3w2EbhDer3
         01Whkrc+k2QeKnPUeZhXNls3gYy9j4h3Ynlu9WnpVyXl2DuD4VN/ds2g8nHdDekpb2E0
         mHmQEm1gd9GtdmOjKFS3jzv0ahPTP1MsGY8ICodOmVYFgPs1THO5RH+73IeRAPbIEBkp
         oLWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X2PevsvMgcYAF5YoSEzLskwnOJa9F0Jfxq4jGYPV3tE=;
        b=qnR/7hykRKLHbcU8qO+FKL0ie4kThf3ZzFua7LPqBz8+TvAO48kX0drz+9WS3jv7Tl
         TPcI1FBUPePF6y84ia/kdX0Uniubg75ZwwR5JkIoUY4K/2Ub88fplB4tp1BvhHIHiYRw
         9YxIRJU6IS1lNqa9YuCxdKuXe/K5f1SE54wsQQINDqhTMJPX/3zdngmSi7NU95na1wW0
         XKXwOAc0CiwuhB6IhP2JBgU/XuJum9RL45yHjkbvBVEqsAh98grdD7YvMjg5P+eyTYZW
         CiyJ91AaZkQweKrX7RS08gyZc4tLvoGg6UyvyyYd9wsv6KxCsi8x+/GMD+W2xkGi4JaB
         QcIQ==
X-Gm-Message-State: APjAAAVAEP3eQ5evE66UrAz9pMVlOPbEijf4rUCSsslkt7P5sJR85nCz
        XGwdFhdMcHqZe/8NrwVCv4l0zpumV0BR/g==
X-Google-Smtp-Source: APXvYqzXB3ppeHWCoznmsdbBG4oc1qezzf4aViw50/tg5kib5QNQiLFdkH37ZbQ15Yg/zsrKIrOguA==
X-Received: by 2002:a1c:2d0e:: with SMTP id t14mr2683367wmt.33.1556808881662;
        Thu, 02 May 2019 07:54:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t18sm15160759wrg.19.2019.05.02.07.54.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 07:54:41 -0700 (PDT)
Message-ID: <5ccb04b1.1c69fb81.80f78.0f39@mx.google.com>
Date:   Thu, 02 May 2019 07:54:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.38
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 120 boots: 2 failed,
 115 passed with 3 offline (v4.19.38)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 120 boots: 2 failed, 115 passed with 3 offline=
 (v4.19.38)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.38/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.38/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.38
Git Commit: a03957ab0fd5d7d03b512a72ab9106a1749f556e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 24 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          tegra124-nyan-big:
              lab-collabora: failing since 5 days (last pass: v4.19.30-281-=
gf4bc3dea377c - first fail: v4.19.37)

    tegra_defconfig:
        gcc-7:
          tegra124-nyan-big:
              lab-collabora: failing since 5 days (last pass: v4.19.30-281-=
gf4bc3dea377c - first fail: v4.19.37)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            tegra124-nyan-big: 1 failed lab

    tegra_defconfig:
        gcc-7:
            tegra124-nyan-big: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
