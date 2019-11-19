Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E2A102F90
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 23:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKSWvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 17:51:32 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38127 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfKSWvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 17:51:32 -0500
Received: by mail-wr1-f68.google.com with SMTP id i12so25883442wro.5
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 14:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YSoaZYdBjL7ucX8PM9u4AOnNEd9TCR2lqT9F4bK3Ils=;
        b=SF6dCx563jb9rWZ7TepxGmxSlZ6CNOdpBIbeYbZAJtsVyqnyFPmRvovnmPIKRWpWgc
         pz6ehug29a5boWlj5uMkJ+Ova3sLhKq6Vx1vXrygEtDl8kdBIxzG17Y+5K9RNFa5d8LG
         PQaZ7BZ5P+ETursZPM5hekB7ECSFYhta6rWlY86agLTSXFVU39WALQNOZIo0Tmwofdpz
         ExiD49tJTmEACUYCNHjivAz+U2OHQA7bLn5yrRu3r6haMslGh40WsRpCWF7KPOlRyfLe
         boEVv+tfj31EAwpIM1/+oeEwkuMdh02BHvW3rmT3CRdPjVfcqq1HkKC4eyqlEszQNSe6
         D3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YSoaZYdBjL7ucX8PM9u4AOnNEd9TCR2lqT9F4bK3Ils=;
        b=eWlSFPlhPt5AqtBhDYAWPoSNb3hqQZpSGk6yxcuZzUajTr18fhBGmKKV/0cbwjl9zA
         UtlWv2rNcoWns5uQACw2D4VBvie8G51pSlk9tBcQBcKH8gP8jfjKubDjzUECRvb/IGTo
         4wGuRcV3+MffV6Fej8gnHbSKEtVrR7fL6BfIdIjFZC4aOXIrJZZ/ELnQ3Pa8uDDTIUn2
         Wv9kXpgbf+2U2YAEGYmRMk5xvOta9zhg5IaLv2WwLEPU2N5b5plZZvNX/tXaFybNU8/s
         ZNY+jq1q21K2jx5qzytAM4/Zx6ErEcqKnuWeD9sd7RyN1ChLZ159p+aCLD7CfsjwCJSX
         SPHg==
X-Gm-Message-State: APjAAAVza4ypfbwZmO/UXEMYOB583JoE8V5LhgKUVPNqJMYJVegfcuC4
        d1UJ/UBI0E4Pg0C4NGkHpNh1Ftqns06DQA==
X-Google-Smtp-Source: APXvYqyEy24/xTXYSl6mz1ASx7ZQRDktkLSqrRWuGDADoO3OFmqaDsJLOIuBJPTngI+8SjjTOt1zqw==
X-Received: by 2002:adf:fe0e:: with SMTP id n14mr41878184wrr.72.1574203889768;
        Tue, 19 Nov 2019 14:51:29 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w81sm5008497wmg.5.2019.11.19.14.51.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 14:51:28 -0800 (PST)
Message-ID: <5dd471f0.1c69fb81.412df.8caf@mx.google.com>
Date:   Tue, 19 Nov 2019 14:51:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.84-420-g824c9adafc93
Subject: stable-rc/linux-4.19.y boot: 81 boots: 3 failed,
 77 passed with 1 untried/unknown (v4.19.84-420-g824c9adafc93)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 81 boots: 3 failed, 77 passed with 1 untried/u=
nknown (v4.19.84-420-g824c9adafc93)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.84-420-g824c9adafc93/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.84-420-g824c9adafc93/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.84-420-g824c9adafc93
Git Commit: 824c9adafc9321640f8338fd99d6b2b122d61e07
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 16 SoC families, 11 builds out of 206

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v4.19.84-422-gaf1bb7db3=
102)

arm:

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.19.84 - fir=
st fail: v4.19.84-423-g1b1960cc7ceb)

Boot Failures Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs

---
For more info write to <info@kernelci.org>
