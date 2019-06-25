Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47300528E4
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 12:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfFYKBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 06:01:45 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:39635 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfFYKBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 06:01:45 -0400
Received: by mail-wr1-f50.google.com with SMTP id x4so17122978wrt.6
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 03:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=byrwc7tJxXt1Mj66FktGpXsxWBGdDFER0Gmo5pRuhCA=;
        b=2Q5LtaVDvTVpd0ZS9dXdWvZOikSFjWKW1/WDj3zCFk9XK11zFER/ExPyt3jIaDqSGG
         VL1z/7Jd6heysxYJN4dOO2M1h08MtgaOe9nWfp7WQWrAqMeqTvBLlmhbmlIhwhC1BusM
         B1DZVbsBYc94gcJB6O29Nj5AiwK40y00t9Tk21ox2omf79oHLdhpEbo2CrzTk6gdd44Q
         c/5EgnKM3YqCxcyQwxsE/bb4oe0FB/Z6c8szjBo/6jUDMGvkIxcEbV28Po8o05ApwS1G
         pBT7X045MC+HJst0xjyrbJAQX90W2TcRRH33r4Km2wXYNcIVzTykVfJ1GS0hShDeoUSq
         r5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=byrwc7tJxXt1Mj66FktGpXsxWBGdDFER0Gmo5pRuhCA=;
        b=Sk2OHgRMyf9gjfxj9TcBSNDtZCZPoj4P9HeERx+PfaD8GpH1JWABHvEXIJ/A5bTCvx
         qDa6keMdjyS7IrAxuvvnv+JZGEAzytbByTsEEEV1iDQMCtJQX2FItdKoKNtaztCQMRMY
         8bVz6bDy4TwyOvZm2X1X/SVCi8zm+IA/JsTGOhwHXMAFFhEf0byFTiRognpxwRJ07NVA
         yBsXzxmwIzTTj3Ff6PiC0mg/3hUMTxM24qsXqcpdVNbaxTdcc4nJGQ4JHjfQB5i9NZ1V
         gjkBFG0gv2gJmNO/L2NDNDTb0tyeULMx1K4KFK84BzjALpxuZoFc4BNg+yBl+TSFZSp9
         VTvg==
X-Gm-Message-State: APjAAAWp8K3gyNyBN3rQW1ljNXeCj/7fZNOyC93t4azGeqMnrvAA8u3D
        Eij3l2QymFRO8O4my1BCdYIIRGz0Am8fog==
X-Google-Smtp-Source: APXvYqyhtB9R+yy8w4F8JTK2O2x1zcKexX7afRmN4SJQw5gm0NesWYx7PrghP3vPGxPsF0qhkKx8Ew==
X-Received: by 2002:adf:ea92:: with SMTP id s18mr36113154wrm.257.1561456903432;
        Tue, 25 Jun 2019 03:01:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o20sm40848998wrh.8.2019.06.25.03.01.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 03:01:42 -0700 (PDT)
Message-ID: <5d11f106.1c69fb81.cef30.7079@mx.google.com>
Date:   Tue, 25 Jun 2019 03:01:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.130
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 129 boots: 2 failed,
 127 passed (v4.14.130)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 129 boots: 2 failed, 127 passed (v4.14.130)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.130/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.130/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.130
Git Commit: bc2bccef19ee4353d759a12950088b968b5c6618
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 24 SoC families, 15 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.14.129-52-g5=
7f3c9aebc30)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.14.129-52-g5=
7f3c9aebc30)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
