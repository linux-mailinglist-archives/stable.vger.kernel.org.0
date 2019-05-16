Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED46620706
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 14:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfEPMd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 08:33:58 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:43066 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbfEPMd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 08:33:57 -0400
Received: by mail-wr1-f49.google.com with SMTP id r4so3175810wro.10
        for <stable@vger.kernel.org>; Thu, 16 May 2019 05:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Go2j094jdvx/RVgtV3w1dULiVV3KxmKXmARI7xlwEw0=;
        b=P4GqwBIo+rnjHb6HFAxSX3i/JJgGdLt5DtxC4CoONYhGvFewT4IuiM28Qc3bv7atmb
         oOOVYVzBxL8mo50LiutuR8mF/pcXHTHEYEk5DyA70YUoewkP2w54Ihja2pWclFXbqD6s
         HgcJhRx7HISVQzBF05q4/3bZcDDZ3F7I8ne9LlS1czOFlCkwdLaZTIQw+MGzYZCCAQf6
         P54ENj0JYH0vGVRRES+semCVNJLLWkamPzf/AK6vTQ3s6YhO74Hqv25CDBmevE4c3u9a
         mFBtXzkatkKmAsyI2/aD1bLvUniefIZr8H37t3Owcb4CLQnn3HImHOiu/wqHOWA/9RAs
         J6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Go2j094jdvx/RVgtV3w1dULiVV3KxmKXmARI7xlwEw0=;
        b=saTYqTVpS5smEhE4xruYfl90S1Bo7SEDRilRJgzXblcgWC7Z7pJzCgf0uc+OwJB6iA
         aM3ISVdOCv9KNvz2aEsY1r1Dydj8IQ/gMsO+I8hnJZOTC+2NuSwbEUkoLtKfjunzI6bY
         OqyeLFnBZ/ZeNcD5Xrz0SQfeSlXkimpCGvntgxzGOYKnvLt4IK/0J9ZVsIBZJEW6WGsQ
         4Pu/dqOML45PfygWZ4DLc0XRBpptDhGfEjxAdzysXTTvx4aU2ZkOAGIBm95QYbLas7PB
         /MXFovlLFMSdEhGuy7V+ir+rk66KFxAVTmutkLWrDYbj0zWRGGp7+AwgtfV1wvswCY7C
         YgAA==
X-Gm-Message-State: APjAAAWktMrr1SIOUqGh64JJUF0iJXnaabar5ar1xIqC08NDRz5jrI10
        bMHr6m9wiUm3FyZq4+9se2W6bpU+6t0XCQ==
X-Google-Smtp-Source: APXvYqy4P9NVIkDiFMObfRC3+cnWwB8arFJipyT2cZu3julIAe9AFWjLLBtVC2BCKpnfAQLOtGJrVA==
X-Received: by 2002:adf:e649:: with SMTP id b9mr24841752wrn.195.1558010035888;
        Thu, 16 May 2019 05:33:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j206sm5653724wma.47.2019.05.16.05.33.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 05:33:55 -0700 (PDT)
Message-ID: <5cdd58b3.1c69fb81.c4af.1b13@mx.google.com>
Date:   Thu, 16 May 2019 05:33:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Kernel: v3.18.140
Subject: stable-rc/linux-3.18.y boot: 57 boots: 5 failed,
 49 passed with 2 offline, 1 conflict (v3.18.140)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.18.y boot: 57 boots: 5 failed, 49 passed with 2 offline, =
1 conflict (v3.18.140)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.18.y/kernel/v3.18.140/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.18.=
y/kernel/v3.18.140/

Tree: stable-rc
Branch: linux-3.18.y
Git Describe: v3.18.140
Git Commit: 6b1ae527b1fdee86e81da0cb26ced75731c6c0fa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 12 SoC families, 13 builds out of 189

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v3.18.139-87-g063109026=
72a)

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu: 4 failed labs

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
