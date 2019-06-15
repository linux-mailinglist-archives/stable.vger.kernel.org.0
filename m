Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411B147087
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 16:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfFOOsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 10:48:38 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:40883 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOOsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 10:48:38 -0400
Received: by mail-wr1-f47.google.com with SMTP id p11so5411764wre.7
        for <stable@vger.kernel.org>; Sat, 15 Jun 2019 07:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZRh0KnszMJzyEBFbhC+33cKgntGZlaTBKi/vfZ8vHYQ=;
        b=fcBZ+O/yRMyNg/8rEMaqLZQkXZNU6RdzcGh+L4KLUQ7wQYFtL/aOG7/4OaOXbhUtLM
         P1OYCtP6D5wWuxCEqDcowmDMjXTS7FwcNnGS9mj4lMEKG6niEkTOZ+dbdQ+IA0AzO/Uk
         MmSgD/lyuyo8e/lAqzmJcEaofi839b9vlUF23YjKUq9rtdnXroz49SDUSpaI7ewap/vR
         0JDt3pAvTaFKcc0beZmXaxGyiIw+GGNi9iYUVDZvc5g3GYt0IaZLVaMivykuurdnUg9Z
         eMuFDPGteFnqdN0rRUZFOTghc/YfZBYMT81ckjQ4xr/WAQsEKG1jvPy/4HinYPAXxLY0
         v+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZRh0KnszMJzyEBFbhC+33cKgntGZlaTBKi/vfZ8vHYQ=;
        b=CqnvPXPEKC+R39DDO8C1Zl7PF6rp+xkcNhBgftGg9hnV72bG6TswxARNi5wvr+eWBA
         WrCMO8c+5bh4UZRJFyYiRmI73+Yw+UGjOy1Wjtxaa02s0TYjGu0uTY/3OymQTPsNZdBx
         o9rKwCldUSP8oSK4kjToNGrr+8x2fA7bH9O+3WmeuQKyeSKprSLcUy/6reEfk/5zRAfO
         0pP301uWl4JUn9yO7zqOBumKuD5ScRPAl9m+paKI+X54G8d4SW6xgzRdWth7ozmp2Jc1
         AKRNMq2c6z2uMnrb2sFwkuMrbmKuVpcIYwrkeTEWACYLQus/PZTiky1b8XXk/SOZNXmT
         fFmg==
X-Gm-Message-State: APjAAAVW7oHtr/uX6/aJOPac3MLnUKJxBeVWQx3AGwMy9opF6Rw18zxq
        Z4v3HsJd2RiDYinj3oVFsFQXLJrpoxNdKw==
X-Google-Smtp-Source: APXvYqwhU69/QjkRDrIpCdaCK/PlRbFNrvamx9Hcew7i/9ZGJ74H0JpDNQeHuj2X9n6TIoU/RnILsQ==
X-Received: by 2002:adf:d081:: with SMTP id y1mr24072507wrh.34.1560610115733;
        Sat, 15 Jun 2019 07:48:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g2sm6797615wmh.0.2019.06.15.07.48.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 07:48:35 -0700 (PDT)
Message-ID: <5d050543.1c69fb81.94869.473a@mx.google.com>
Date:   Sat, 15 Jun 2019 07:48:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.9-157-g859f357cb9f2
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 118 boots: 1 failed,
 105 passed with 12 offline (v5.1.9-157-g859f357cb9f2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 118 boots: 1 failed, 105 passed with 12 offline=
 (v5.1.9-157-g859f357cb9f2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.9-157-g859f357cb9f2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.9-157-g859f357cb9f2/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.9-157-g859f357cb9f2
Git Commit: 859f357cb9f20a0324e8af8c4ad4207bb6dc8e77
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

---
For more info write to <info@kernelci.org>
