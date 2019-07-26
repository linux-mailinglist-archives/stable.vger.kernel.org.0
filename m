Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2844B76E41
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfGZPs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:48:57 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:41871 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfGZPs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 11:48:57 -0400
Received: by mail-wr1-f52.google.com with SMTP id c2so51718793wrm.8
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 08:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4dOzDwn3fIttrvvksYMW1rX7oHzntAwiJo1/wPjCBxk=;
        b=JOlRqIxNCiceE/YE9Bv5RVzuyUBCG1xZYLpYTjPt/D/jLVCKfEKqqRHB5jgtmErr1y
         FlMaDXhieXKcCY/9lPDgafb2xu8NQxT1wkvTbk8qfyvCK5RPze+xghUWlXZvPYmZG4/b
         k4C0RGkCKi2Ctn6RDA/o0QSGNAAwTehGkO0ELfoa8DHVdCrw5+bdEmCYDBEKtweBB3Do
         MwvZ5jHZWihkU8dJWzfR01if5rtup8SAEPLTwJP1SvQaCbSVMn4bVyLKBLtVX1NUHT44
         Jw0Uco0HzOV2OTx9cHtDyEmS0P+1kGrR05DA1Bi06LZF5qSr/a6UE5JKW2e0snItVJTz
         zT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4dOzDwn3fIttrvvksYMW1rX7oHzntAwiJo1/wPjCBxk=;
        b=dHNEj22mhPLrLLG9sxjPY/ASdRDUlaPMacpftCPYox4yAjki8DmA8lkm35gDWfeORf
         xUzjaRebOWJozGq97G0OhmwL2NDdAkUtq6gpJOE4eBg/ZNuTzRnkHmHzSTpIdYyAwNY8
         RjlZ/bkiow2XXW7r/SJSfJ6P/ue2aH+Uma8FyX6W+sn9cM8J6jgehF8jnajFNKIGVjmG
         IW4xqpBZXnGSS37ceoosH13ff6SVk2QhOgNNWUQRXcEXWvLeny6iRWGMIeQkG8Y/reee
         WtsrfHMSmx7e+I49vpTFWTU1N/FxE1nXJBc+5euK33u4g/k4s+sEet8LQAvsj14e6eMH
         OmvQ==
X-Gm-Message-State: APjAAAX8mtsM6mx3891CpRzaCA+K0DzYtQV8XQoWZ6dAsT6KAzPQTtCn
        7Ysv1nTCfvA2reVzFoB0Suw2jtNnouU=
X-Google-Smtp-Source: APXvYqwL4w3J3WWVmOXvg0WpfKYgvKCN/sNc31cqlBE1g5uPEX5++egJVa0OZEikMYk4SiQN8wJs5w==
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr20349359wru.27.1564156134747;
        Fri, 26 Jul 2019 08:48:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u13sm62673601wrq.62.2019.07.26.08.48.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 08:48:54 -0700 (PDT)
Message-ID: <5d3b20e6.1c69fb81.ad9d5.f370@mx.google.com>
Date:   Fri, 26 Jul 2019 08:48:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.60-272-g872cde3ebfc9
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 123 boots: 3 failed,
 119 passed with 1 offline (v4.19.60-272-g872cde3ebfc9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 123 boots: 3 failed, 119 passed with 1 offline=
 (v4.19.60-272-g872cde3ebfc9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.60-272-g872cde3ebfc9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.60-272-g872cde3ebfc9/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.60-272-g872cde3ebfc9
Git Commit: 872cde3ebfc93ca6ac127f51bbb54eafe1d8eda5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 26 SoC families, 17 builds out of 205

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.60-272-g975cffe32=
ab5)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
