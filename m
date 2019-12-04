Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9778211375D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 23:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfLDWAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 17:00:32 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37319 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfLDWAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 17:00:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id f129so1475912wmf.2
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 14:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S3Ry3OxJsnNoYlgWlaLs0P0rgEoaGtc5VL9A8LEuOL4=;
        b=bDI727rMFd3D6zoV3UwA2tMnOa/JirI8+8hca1PqRSpHdSujsAQcAslxbgIrwOj0T+
         Q+nSUiTOQjeq3OdUsqIDn0bdjNgHTQdTRdBfQ9YDhxdN4AN/B/Rpg/r3OMV6CdKD72Z2
         TnxTE7iJ7aAJrFCBmb+SXeGrtL4Ytbxelmc704qGx6MlRiMIb+sNaTHZcZSshVdRpJIf
         HY6xmjxbTlYwY79Z/Af9tk3i77TtmPFg3WNg1cZmGb+IB3Vakm65zYIFdkDWzpCqPO7a
         blDEh+Llf15JPmTlG+I4u55hLbeoInykrSk/WDJt+JyLQQZkeoiznjPUZ+PpluyV7YLE
         mWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S3Ry3OxJsnNoYlgWlaLs0P0rgEoaGtc5VL9A8LEuOL4=;
        b=H5l4S4WWvvhLrX5QcCZlNhtS8ooZ0de3GudCqEyP8AtlFZ06wmndZKsaTA9NHeSCDZ
         v13W1z+uykrMKl+AAyQGF0Ffb5SUdWEfZ0WCnRB5/xGvhejA12jPkjfZBKqXf/B7coab
         E3IMQ8/Oi2PHGy4qvev8+G9RupN6zcEAZi3IVywp7iraoWztRagZoiV3iBOaKiVFKRIr
         t8cXXXPP+zwZofyltqpJzWX2+UXL2qNVfnr8l2VRmfoAzqThwBntt+HxJffd3N9er58G
         KZWPptKRqxXKfTMVp/4Gb0n/i8C1lTO14ldPe5NeheODhc/RTVG5TfS//f6S1FrGlWEP
         OVww==
X-Gm-Message-State: APjAAAUiD3NXF9E/5W87KWWngVhCpKG/7695wtmatAArKQTTOKZI/0rI
        lxZ9JB7/FQkWP4WuFyTPjwAEE+fdvnw=
X-Google-Smtp-Source: APXvYqzXfZMTr4CMdicwjxKyavOCIHxm2bYWfjyEuL6AY60Nx+RXSqkN+UQN9kGHZxFe6n+skW+iNw==
X-Received: by 2002:a7b:c113:: with SMTP id w19mr1805027wmi.144.1575496830733;
        Wed, 04 Dec 2019 14:00:30 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j12sm10386279wrw.54.2019.12.04.14.00.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 14:00:28 -0800 (PST)
Message-ID: <5de82c7c.1c69fb81.d7872.4582@mx.google.com>
Date:   Wed, 04 Dec 2019 14:00:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.205-93-g4fd2af91bc35
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 96 boots: 0 failed,
 89 passed with 5 offline, 2 conflicts (v4.4.205-93-g4fd2af91bc35)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 0 failed, 89 passed with 5 offline, 2=
 conflicts (v4.4.205-93-g4fd2af91bc35)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.205-93-g4fd2af91bc35/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.205-93-g4fd2af91bc35/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.205-93-g4fd2af91bc35
Git Commit: 4fd2af91bc35d9c97085ffa7098b4bd9384cd9db
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 16 SoC families, 14 builds out of 190

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
