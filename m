Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8513E5C5CE
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 00:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfGAW6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 18:58:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44737 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGAW6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 18:58:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id e3so6001938wrs.11
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 15:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y7oqh6DHH8cTpA+T+ppqgIWi4xD6n2RCJYAGn7MQ6O8=;
        b=K7vcJEYVIO+xHhlFLb2MXeeYbfUEPKLhkfKfJc5WO3h+npMOvEXsZyq1UhaxB8G3qS
         37t56a4HGl2KE2vQ1tR1A8iNy6LJtFXcS2sb3QVu2dGVSoHNs3veDg93HuxI9cwp7yWV
         GsPiAS4WCG9lluNMV6m6tnpqtSqPQR6vIp278RtD5Y636e3BWo+iPU4N3UMJP6OPvIUt
         e6WrowalljC8SKgwEzQkN2gH6Q3cWzLZFAnkFKeUqxej58wPr9v/eYPS/iqiDriqhbNQ
         5hmAzMdSftHqSNix1qY79RT90Ls4rHJiZOsOszutAfdwaCt6jTERXmCGbkcxxz385PJA
         DhHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y7oqh6DHH8cTpA+T+ppqgIWi4xD6n2RCJYAGn7MQ6O8=;
        b=ooCJj0GEZ0ztVAHdcn6/bslI3j+PMpIOzD/Q3L22DQt9dZ2nwPNw+FsytaqyPvykTS
         G22m2ITMGsjicYNf1uQYDQoT1t5vwrWBcdEsmPdyQwdsXq2cVp1V7fV5SgjSz86fJz3T
         jfk8eRs4EPEKKqeqTPsUOxsKiGqpjuAeR6uiePFmvue82BL4Cm7xD4q6ALFXF8VbII0k
         FZtebuGzOl4bmuxB4vR0Luz9nAWh9hftLvjenKQePaGY0dP/DjIO4UsAC2OLSala05ej
         aoQAL2FGAFfsuxfpBQWv5vrTtQpC0CGxbCog4OVa2SL3OEQDWzUk1j5Ckjkse5Dmjwrm
         o+1A==
X-Gm-Message-State: APjAAAUMd+mxF2ZPQ9vjtRIM5QMR1E1D/tazi+dLWaBrkv1dO0VpN5GV
        OSpQENHs9WZlXDlatCLDhjxbeVE8EWc=
X-Google-Smtp-Source: APXvYqyh0uN3tkgS3ucXtQ31MLHdF2Oq0gs4MIR/m6i2IASwS8orcl1nWuS1oslOwqjTJ4W0k/vtPg==
X-Received: by 2002:a5d:4941:: with SMTP id r1mr19725312wrs.225.1562021923215;
        Mon, 01 Jul 2019 15:58:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 60sm2789968wrc.68.2019.07.01.15.58.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 15:58:42 -0700 (PDT)
Message-ID: <5d1a9022.1c69fb81.70399.2df2@mx.google.com>
Date:   Mon, 01 Jul 2019 15:58:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.56-50-gb1933911f3fa
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 131 boots: 2 failed,
 126 passed with 1 offline, 2 untried/unknown (v4.19.56-50-gb1933911f3fa)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 2 failed, 126 passed with 1 offline=
, 2 untried/unknown (v4.19.56-50-gb1933911f3fa)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.56-50-gb1933911f3fa/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.56-50-gb1933911f3fa/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.56-50-gb1933911f3fa
Git Commit: b1933911f3fa0882b789a539c3e3682ba4b9bc08
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 26 SoC families, 16 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.19.56-7-gba8d1b75298=
c)

arm64:

    defconfig:
        gcc-8:
          r8a7796-m3ulcb:
              lab-baylibre: new failure (last pass: v4.19.56-7-gba8d1b75298=
c)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
