Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4FAAFF40
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 16:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfIKOzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 10:55:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45828 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbfIKOzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 10:55:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id l16so24847975wrv.12
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 07:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KxDFMmNCu89AbLLZ1ABrLG8MlHI1MRFWZx5+4GFIF5s=;
        b=DY/70FamkKnjfWeSnbyivFSKBC0iJEWUkGLZJmSz+hlEp4ifOxIvhZGhryDi00Ka1F
         QBZYLVzm82UUXRwsdUt+C4kkp7CZQjg9jBDd4ypjE2wRcxwfE2Tofom3dT8YKvyG2amT
         RVd2a+rTVf+Vx+pqew0ZaSBi/odbNyhVaczPzZUYyMkBysaMXUTm5LIzVP0dGJPq5/oY
         kNXsVnUMJjhqsyVPOLYzfhh0PlQ/3DXnwmOcQbS01U4eWkkV5UAHDvcBUQFO3R/KA0xm
         SvVlQPlFlDZeLYj9gW9Rsrkns7nWlEjVUXJT/rZM/k8QC+MB/i8qS1f/1AdkZAHnVi4f
         QRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KxDFMmNCu89AbLLZ1ABrLG8MlHI1MRFWZx5+4GFIF5s=;
        b=RNKJebEYyZE9ypRurbLWUfrSXnpss/hOfhs4jn0m1EGDTUjLtB3DFGlgVzrALE0n/G
         C3kBYPEfJJCOnDqvJyAjyGRHTzlrcr837bPFj/w/5npGlzAi7fGlNpzJPv9zK0RY44tD
         U8aM3GzEPdvIszht2Kt5cgTmoStouuJkkxrQ+GxSKC91OuVisRAnKouu4eB2N523CBmn
         2ui1j8kRhAreQrMYP+XfZQqiadu8kcXbo20OXurVz0mZ/BzkLJg3ZGx+gzRJW9RMEP/g
         E3DnOyf+1QvuJujVZZjeOWMb1v+KFUvDEMJi8SETEKUE0UJ6dR6WRtaEA8tVdWHx/fxH
         mLmw==
X-Gm-Message-State: APjAAAU9XXvGXkjyb/+ovjppboL5i4TGlYJnG/LWx6IScSI7GQFn9zE+
        akNnJR7ZttiA0SEtfHM6iNHYsq2dyZR0Xg==
X-Google-Smtp-Source: APXvYqwHl/KJw6JD/HPG/RJAzkCEHr48oTUQKxBNmoh3dy3jlSpmSpUlmA4SW+0yNbLuvfDBCfPO2Q==
X-Received: by 2002:adf:dc81:: with SMTP id r1mr4645992wrj.52.1568213700247;
        Wed, 11 Sep 2019 07:55:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f15sm3194568wml.8.2019.09.11.07.54.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 07:54:59 -0700 (PDT)
Message-ID: <5d790ac3.1c69fb81.455f1.fec9@mx.google.com>
Date:   Wed, 11 Sep 2019 07:54:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.14-36-gfda53119ddbd
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 140 boots: 1 failed,
 130 passed with 9 offline (v5.2.14-36-gfda53119ddbd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 140 boots: 1 failed, 130 passed with 9 offline =
(v5.2.14-36-gfda53119ddbd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.14-36-gfda53119ddbd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.14-36-gfda53119ddbd/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.14-36-gfda53119ddbd
Git Commit: fda53119ddbde247a9eef68ecc9de569ec7a7d6b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
