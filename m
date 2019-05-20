Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1028B2403E
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 20:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfETSYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 14:24:54 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:51035 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfETSYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 14:24:53 -0400
Received: by mail-wm1-f47.google.com with SMTP id f204so344855wme.0
        for <stable@vger.kernel.org>; Mon, 20 May 2019 11:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4+YpJZOUyd98a4LEbiohNQZPN9PaSfJ+2ip66ADcGg8=;
        b=ZWHyFZJyaIvJx+FU+cTJJTEcbcKF3hVfDd/JT9M45pw72/pVN7azTi3seZHqYWyr7p
         SapHdpohcaaM/s8G965ZOo/YfLFvr87G+AWHTOOjO7oHE4NiPWG04mYIvrIowtopaaI4
         /bZ9UxDynqNOaOT4ugD0E2H/VToxh/3XneU+cwft7WpZ0KoDTlk65jOfOd9mP0MpytcQ
         IRY+2SMs9QF2MOTuBrG13MY4cZ3R7sU6RaY+d7JcFufwx92i6O3SajEupW8SLjsoEtEz
         ATsDsiyM8t+ldWAR1MJUrin3Mi8+gngo56fwzz1Iko+5wDoWJpO9JlW4zQxxQNjjPQoZ
         plxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4+YpJZOUyd98a4LEbiohNQZPN9PaSfJ+2ip66ADcGg8=;
        b=K35HBEFLUJ5v1lUvicWPPRGlVu2+8Yz6QzwoQQXtIs+rY2y6RcQSRSromTtGL8jRdu
         FJfsRTqWdy3ENgLn+7XwS6f1b1YzaLOSlxKJZWLIKpNmoB8ANerlsPfXCrQU1pmgW3cX
         2/KXzIUEf65/lJ9eG0P0UGavUhKyazwaRfRbrOL+FJhD5PWmAZo11IMvjdbaphD0ox1G
         7v7FRBwLPfV089MYSNLwydZDaRQqCtasGKGD3MaDzj2Kfvz1fqYQFCo97C4IPEmfaBgv
         ny6FprOb7iDNOTnYZmsrKL3gGsn1u66ho3ipOcFHt3YY7WGl49MPiWswtJrBsNJYFIxE
         osmg==
X-Gm-Message-State: APjAAAUs16aFUqaSQzdWG4E7HRLRIFNFSN8bvxifHWJA0Oy+L6aSS1BB
        949AnSD5HjU090XMninXTd6r1rZij/SD7Q==
X-Google-Smtp-Source: APXvYqyUAtICPGss7U6lNBvcADVocBGJV97V7hZM+0jrPrEsdj9qCfhCAwt6sUTx0yP5Rr/y4f50aQ==
X-Received: by 2002:a05:600c:22cc:: with SMTP id 12mr307663wmg.141.1558376691365;
        Mon, 20 May 2019 11:24:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f7sm170380wmc.26.2019.05.20.11.24.50
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 11:24:50 -0700 (PDT)
Message-ID: <5ce2f0f2.1c69fb81.c5d94.0d40@mx.google.com>
Date:   Mon, 20 May 2019 11:24:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.180-32-g8c78d05b0ad4
Subject: stable-rc/linux-4.4.y boot: 90 boots: 1 failed,
 86 passed with 1 offline, 2 conflicts (v4.4.180-32-g8c78d05b0ad4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 90 boots: 1 failed, 86 passed with 1 offline, 2=
 conflicts (v4.4.180-32-g8c78d05b0ad4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.180-32-g8c78d05b0ad4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.180-32-g8c78d05b0ad4/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.180-32-g8c78d05b0ad4
Git Commit: 8c78d05b0ad4717cba1c83adc30f97ad43a02376
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 21 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.4.180)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 3 days (last pass: v4.4.179-267-g=
be756dada5b7 - first fail: v4.4.180)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
