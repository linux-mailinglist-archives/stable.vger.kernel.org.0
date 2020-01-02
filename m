Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC73312E1CA
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 03:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgABCua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 21:50:30 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45845 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbgABCua (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 21:50:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so37964079wrj.12
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 18:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fscz//aF8CcsB6TEJ4qpVBwAu9k1kKJqaXQnqj3e+GE=;
        b=bf3CA/YxKAtm5yXnvBkve7iJdZ3xEOznvFqOA8wtr0g2aoc0zfnmh+ZkTkWBusV6uA
         fKPeUtHGngudSoHp3AD7vgQYefyGfyszGL5heMlB77TRSJdj+Ubq7EmDsJDMAOSUWk+M
         CQ4Nkk3NIL+qqgisYwYjeHB4JvFuMg2/O1ZykJuEXI0Igv3Wmi0GTaYJLhpVrkXvSoR4
         xZN/qGS1HxF2eP4PoeiVNE9taqv6RRmekWm3Lp9S6KvqpH4k7rSc0MAR3+7Aes7yDyEU
         uulhNbCMLxGW17g1DQ6xaJQwUVAoFQ/IoPUd8aaFkmkmMiJy4Y0d+czXFEARd2CGFuaJ
         2V7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fscz//aF8CcsB6TEJ4qpVBwAu9k1kKJqaXQnqj3e+GE=;
        b=c+1eKquzkl8rxfoYi4o5pZllw8R13PPSDU6Ka3dF5dD/Dz8atxxkDIuv53pfU1eSwC
         zegMq2KSwp0DVlClqOHsICnDAZ+ftwJPDZf96XIRc3yZgLMVWkj1v5p2b87SO3GM4oka
         1tK7jLEBqUzYiyFfThLE9biG/tH5IgFA2wC5AIuMlOS7oHyJxjNdK5rulvP0LsP5JAdH
         W6ge6ACZ2c09vyI1rTDSvPU8bdxDyuo+AE30YPVQmGbIy7CTrjiQmzm4dTMPM5MCXUx/
         BVO0yG92pCq19vcSmWtJmzZ60HSeay3I+3H4ydm8Zs0g+fiHnm7LEMmj/gob54g0TAPi
         qEBg==
X-Gm-Message-State: APjAAAVdtuplYrGce/vTiFxfdrvSgN5NzLUG5gRj04wqcC98KHImM/jF
        L+/aiweBoXKUd7JaY1NTVq6RXpfPG+y+vw==
X-Google-Smtp-Source: APXvYqwAjTsKLMXxAp+7MptUyBFH6PFWMcfOP3N4jIYcM6UJ6/2hm3BStAUc0YhU64aiwYpxm0u4Ag==
X-Received: by 2002:a5d:4cc9:: with SMTP id c9mr77537568wrt.70.1577933427970;
        Wed, 01 Jan 2020 18:50:27 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i5sm54532568wrv.34.2020.01.01.18.50.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 18:50:27 -0800 (PST)
Message-ID: <5e0d5a73.1c69fb81.589f9.ac0d@mx.google.com>
Date:   Wed, 01 Jan 2020 18:50:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.92-112-g4e040169e8b7
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 67 boots: 0 failed,
 65 passed with 2 untried/unknown (v4.19.92-112-g4e040169e8b7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 67 boots: 0 failed, 65 passed with 2 untried/u=
nknown (v4.19.92-112-g4e040169e8b7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.92-112-g4e040169e8b7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.92-112-g4e040169e8b7/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.92-112-g4e040169e8b7
Git Commit: 4e040169e8b7f4e1c50ceb0f6596015ecc67a052
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 15 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.92-90-g04f3d64d29=
85)

---
For more info write to <info@kernelci.org>
