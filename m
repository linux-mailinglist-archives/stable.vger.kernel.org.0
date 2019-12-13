Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD67C11E5C3
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 15:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfLMOky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 09:40:54 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53969 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbfLMOky (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 09:40:54 -0500
Received: by mail-wm1-f66.google.com with SMTP id w8so3403666wmd.3
        for <stable@vger.kernel.org>; Fri, 13 Dec 2019 06:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YnWCjYHAhic972mNYiPJM3SfWN96YgSPeOKeHHQL3rY=;
        b=F/ZW7MVp8aVGYTEcpqDNtRfhE0w/fnnQ6HMEd4b+YU5ILMgXuk1PtX6CrRUsfQnu1T
         dqWq4P64neVIWrRSfHtsyAJV2mF8cQrcsNLK7O2lXNgutvSqOeurBBzh00H1CV/AEy/Q
         wLQWuoMF4MpZZaKCQmVpNPIUh9jzRMloIGvHqgkohoj34nRRJTQ+idjxJySdD1RBPF0I
         Q2vlb3zZn748HSUlsdZMwiw+g5qxDzEcyWdwavW93ijUWH3iqwd2rR7Xte7mOtqbpCw/
         J0e5xSrsAuOiujiR2Qft2UBmmyRpXuZcoG2oRhp4QWtTxehr7HygTZHy+VM6ZIp/sUkM
         yOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YnWCjYHAhic972mNYiPJM3SfWN96YgSPeOKeHHQL3rY=;
        b=bK2B0PDa93gVOlsj9sZXZIntczypDmcWpeA9vlG0njueZR/KcZsNHWVPlxq/UjANkj
         VlI+Qm52KTNSlzpL1io7k1VmFezv43ouD1s54jhcVDZH4/lue5rSAmxTSxVT5TxXZzwn
         /UatGop+s1jdKqxoAOOp8lSByYH2FXLwTa7KPcCvHkdunMx/To4idBANvLXJCCgzrI5B
         cL8DUXyUz6+MOv28UGoj3Y7xFp3aRizXPwERSQ+/RZNgqVXauTcdinkKn7Rc5FXM85U2
         0YWhP97B3d0CMexXKvc/ldAfb0yrcIiaw4l1a96wRQjA7s8iB3UAQLguDyc54MaRHN58
         AiXA==
X-Gm-Message-State: APjAAAWIh8OHwt4A79b8s/ENlz9XjT5Uyfb4g13/vPumxoXcbbX/Wc8w
        bEInZjJrwXCJ6yIgaZk+wGJrxCNf24K9dg==
X-Google-Smtp-Source: APXvYqwUjxsHC4US9Fm98YEWtThCqZrgqfjWJJNIENk30NVtGALczbN8vaDrnyXZjpLS3Y0xra7DgQ==
X-Received: by 2002:a1c:9c08:: with SMTP id f8mr14251733wme.171.1576248051602;
        Fri, 13 Dec 2019 06:40:51 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a20sm10909802wmd.19.2019.12.13.06.40.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 06:40:51 -0800 (PST)
Message-ID: <5df3a2f3.1c69fb81.d0210.7bb4@mx.google.com>
Date:   Fri, 13 Dec 2019 06:40:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.89
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 93 boots: 1 failed,
 90 passed with 2 untried/unknown (v4.19.89)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 93 boots: 1 failed, 90 passed with 2 untried/u=
nknown (v4.19.89)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.89/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.89/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.89
Git Commit: 312017a460d5ea31d646e7148e400e13db799ddc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 16 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v4.19.88-255-gb71ac9dfc6f=
0)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.88-255-gb71ac9dfc=
6f0)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-p241: 1 failed lab

---
For more info write to <info@kernelci.org>
