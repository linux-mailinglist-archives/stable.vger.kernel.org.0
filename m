Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A092A71D
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 23:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfEYVld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 17:41:33 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:56048 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbfEYVlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 17:41:32 -0400
Received: by mail-wm1-f54.google.com with SMTP id x64so12544533wmb.5
        for <stable@vger.kernel.org>; Sat, 25 May 2019 14:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZdB0jN7aTg14EEdYfvcdHVXqDXNnXoB/BgvzTjaiXEI=;
        b=mkLGEHrdO9NAVB+FYmLvePP3TV6qCD1tdX7X17yEaBAH/0bFMuy2ZMUGnkAD8EYtoa
         L8FFSMEsyenpMEEuIVurpH2i97UTAfH8Or6qrDFxUy1vmIODZBWWOogthvL/CJiw9pok
         Un1d2NUfaMYm1q73wR7WtTdJOULAsP11vSv8yINyAKYEcLdmhINmOSo5mk3wU4YJA/vf
         WeT5M3DiW84+tJCYsyN9BaXuWsa7rsAGnECKIsp+wS/53+ycl5F0/qlEXTFxQwLRMdU3
         SfeY5C8PbMvUSHl/Y9/3fuKNV9tQsMt7BIaKzH0ffLQpYcc1V0soiMvYGdwMv7NSWVEv
         P6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZdB0jN7aTg14EEdYfvcdHVXqDXNnXoB/BgvzTjaiXEI=;
        b=boFg3iXC3e63+WjKzb1M1hy35Wk8HgBZb06CTrEIBZ8EG1lWTe2TRjOBHWBlCDOvTl
         LCYqy7WwCVpKYd114ECcCRcDaGKa2kY5H0EtHK8v7/NjLhvR9PX+F1VMb8jhvpzN0w0d
         7rL6jPn3cdMO4TIQem+yFvjBHQ57PnrXKO4dMBoQiD453CWA7pCpCBFDh/kMf5Y3O1bk
         dawJckbE0A8Y/6uTLawzOuzyyWDoD56JEnpYXKKe4Yx2HqUK62mZlSCwXRc4om7uo0kW
         EXKYAiF476a27LdkNepXV8zpmbV/CFMD0Ha5UAIX4JFQtZJGUFGP2DpRRBc2Zx58xDTX
         k+1w==
X-Gm-Message-State: APjAAAV+CuchYq55HpmDJ3NImHYXOtcKLzx30uGRA0VyXTD7C9HJlI33
        ZwlJzEjk8k+joWKsjRB5z8vS5aZI0nU=
X-Google-Smtp-Source: APXvYqwS7td66n9VWNYSdsKKoUChuPmAY5KcvexUOMY/6mERB+TWeEah1GsYBfJDEyNZukYS2gKpAg==
X-Received: by 2002:a7b:cc8c:: with SMTP id p12mr4274219wma.59.1558820490664;
        Sat, 25 May 2019 14:41:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 65sm10443082wro.85.2019.05.25.14.41.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 14:41:30 -0700 (PDT)
Message-ID: <5ce9b68a.1c69fb81.c86b3.a407@mx.google.com>
Date:   Sat, 25 May 2019 14:41:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.122
Subject: stable-rc/linux-4.14.y boot: 119 boots: 0 failed,
 102 passed with 17 offline (v4.14.122)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 119 boots: 0 failed, 102 passed with 17 offlin=
e (v4.14.122)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.122/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.122/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.122
Git Commit: 44a05cd896d97a3cd4f0c2ddb29a221ab2fdf43d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 24 SoC families, 14 builds out of 201

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            tegra124-jetson-tk1: 1 offline lab
            tegra20-iris-512: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
