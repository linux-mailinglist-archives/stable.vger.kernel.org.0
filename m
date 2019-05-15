Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735721E8C0
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 09:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfEOHGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 03:06:31 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:34268 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfEOHGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 03:06:31 -0400
Received: by mail-wr1-f43.google.com with SMTP id f8so1360586wrt.1
        for <stable@vger.kernel.org>; Wed, 15 May 2019 00:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v8MVMpfEIe4LNL5xtZAvFjhLysmYkmgLzpJKxCAROUY=;
        b=P7djh0BYhOagPIBrgRw/sHoia7gytwZQKNFNkukHBvjvMdO1J/tInVfCzeKnPRb7tn
         DdJG+ZmRILdyP9v5DP9gF7bQD86V7Z3advVENLstz8oiF+/O4PfX5bJv/ZHtDNCgNoa0
         uaAU4ARTBmT+wCw/zYoY73GtiMVpNOQRelrT2QEcVD+IEj+EMhrVus6oRthbjwt5cntS
         5GbG6fCaqo1oWDjLSxFnzXWqyCmYyGLWM4kGdwzgIJi+ftwek0DT5song9MV/cHo50oS
         pmPksS83thzPcBqwOCKGT+wpb8ivONMxUsNFmlHIzFLGeIqbX2ZkcBMcxl1K7BsUQ4MU
         jT8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v8MVMpfEIe4LNL5xtZAvFjhLysmYkmgLzpJKxCAROUY=;
        b=B0PhFfLYTtHMT1v/ZrY1pGgXO2LSQv2hhCgjku3j1rXOtkp3/KHsldTQ9lzzAq6tV9
         Yg3Ir9S1PdqjBfNiweCtkbWlfSmcsXG/+tj8OnEC7INwszJ7Ye095uhLmgRiGzgP/Wxi
         kZ6DmsV25y7yJPjTIhqOXpEY4wZAZms9XHKhFdWzySrl0k2LZoEGxlFEqzH1+pRZ3cnq
         x5DmF/l+QpczNFkFcl2RbP0EHM+dd2JPDj1X3n9mybMcYNvucUswFHARDnIZelQsrxsT
         JyINlnqGNEgPLnzcop/hKcvoYrdyab51void4zVNklgHWaUOFyuuwSiJrxkXN1eqMjMf
         ahiQ==
X-Gm-Message-State: APjAAAXcB0+uAPci195ZuLvumkaHkKPmsJY/PuW1ImpxxMSn11S1NitX
        vG6N8RCfn1NxvMMFchBBX9Cguaoc1YJTYA==
X-Google-Smtp-Source: APXvYqySEQIzmt6NnoYw0KqLNiXYClGLpLI2WvBXV9zQ1VqPGZjfPJZqJWXHTFGnAAlrYYv0XVu6CA==
X-Received: by 2002:a5d:6610:: with SMTP id n16mr16333393wru.250.1557903989308;
        Wed, 15 May 2019 00:06:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l8sm1251003wrw.56.2019.05.15.00.06.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 00:06:28 -0700 (PDT)
Message-ID: <5cdbba74.1c69fb81.1212f.64f5@mx.google.com>
Date:   Wed, 15 May 2019 00:06:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.179-254-gce69be0d452a
Subject: stable-rc/linux-4.4.y boot: 97 boots: 1 failed,
 92 passed with 3 offline, 1 conflict (v4.4.179-254-gce69be0d452a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 97 boots: 1 failed, 92 passed with 3 offline, 1=
 conflict (v4.4.179-254-gce69be0d452a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.179-254-gce69be0d452a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.179-254-gce69be0d452a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.179-254-gce69be0d452a
Git Commit: ce69be0d452a13d98590bac57d197473147236dd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 21 SoC families, 14 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: new failure (last pass: v4.4.179-160-g2c68c4c9b=
112)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-drue: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
