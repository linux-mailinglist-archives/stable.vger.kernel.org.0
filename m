Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2A8740CE
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 23:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfGXVZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 17:25:58 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:33095 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfGXVZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 17:25:58 -0400
Received: by mail-wr1-f51.google.com with SMTP id n9so48549599wru.0
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 14:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RGEY3mYxkWEqImEly6WYCNVdsZNIN8wx5uDmBL35Vow=;
        b=ephyloP85SrHxkulicrULtIny19bp636uRFChiSpc0yO2WE3nKGG1r3gBGWXyQuVd3
         tRVYqEYgfUfH+F5I+TW6lrB/9f/NPs0GwDEUaIdguuA8pSolOHFJD2pa3VCVp93ltYat
         qRw1Xtfs1pxk0uSVAVh0OPRbQ1aDg3Y/6DedjDS3FjwkphgDNKjGYPBeQMfKo3xJP5NY
         zifnZWPDug23gVI1rWZ6JC/Pd3c7/N5aNoU4m7TcGZYbB9ZFq+JUpa3KVmD2dOFeItMP
         Z6467DKZnoei8+zrM/RY/2LyCq1ib6mfrQUdV97EfOpA47AN8hePJK3k8EJ2Jyu8JGQO
         BZIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RGEY3mYxkWEqImEly6WYCNVdsZNIN8wx5uDmBL35Vow=;
        b=YjWSBmMTZ+EEuNcTOGvPzLd+p02zX92hHHwRgEEuFLkKwZUqqi85n/fMnjQUuOBlQp
         af/iKmOjUIKFG5UEM5A8PT7v5QkaAtPeozgafrjlItZCkXIWz07/oImMKvDvmK5+E7hG
         2zYiyVP9+d5FcSHeARqPKseR9cCUpBl/MKLIfRHLAN2jM+SBYwdGotql6AG9gnhbzhRC
         0XqPIgZdDbzbzN4UD6EsFS5qMg/WDzyssVUurgYIrR+uhuDPKBW0W/BPYhNVWeY9idzh
         TNRs1IdAbJo6ByBpzt+PrYy8UF3qlLI2u87cPg4peeCGwk1iprn0docvSNKMjBER6Rjf
         scgQ==
X-Gm-Message-State: APjAAAXFI9XXFlG9nhrkPxVsiHUPI0Q+1z+WzE9y56sZmfAwVz3qkO5Y
        0i6maYG/b/ayrbpVLfSLcbAwehl5Sbs=
X-Google-Smtp-Source: APXvYqyAJUzET7dSb4Uaq1Vu/vMCbnwsLirrs2/x6GzcoPajrHrQkcD0Pqji4SOOKkr/TLQN/BXo6g==
X-Received: by 2002:a5d:4090:: with SMTP id o16mr16168935wrp.292.1564003555497;
        Wed, 24 Jul 2019 14:25:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j17sm71985340wrb.35.2019.07.24.14.25.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 14:25:54 -0700 (PDT)
Message-ID: <5d38cce2.1c69fb81.35920.1757@mx.google.com>
Date:   Wed, 24 Jul 2019 14:25:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.134-179-gbe99b7e83989
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 125 boots: 2 failed,
 115 passed with 8 offline (v4.14.134-179-gbe99b7e83989)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 125 boots: 2 failed, 115 passed with 8 offline=
 (v4.14.134-179-gbe99b7e83989)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-179-gbe99b7e83989/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-179-gbe99b7e83989/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-179-gbe99b7e83989
Git Commit: be99b7e839890dfb790c2bd75eb446e200d8fb37
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 26 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.14.134-165-g=
735ae2998a0c)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            meson-gxl-s905x-nexbox-a95x: 1 offline lab
            mt7622-rfb1: 1 offline lab

---
For more info write to <info@kernelci.org>
