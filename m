Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD12090840
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 21:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfHPTiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 15:38:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46185 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbfHPTiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 15:38:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so2548061wru.13
        for <stable@vger.kernel.org>; Fri, 16 Aug 2019 12:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lw26MzifeBS+EqPVJYGj/JQJtKX2FPAaIxw5E4kFPYU=;
        b=lBiGrr8zm6gJHJR1I/RtOKMqht2l7FWXzstFLgk3rLhx5W2oJXHooBXaOINmb6XQF0
         gNQf5hgJ3T6BFsT9uVcJLk7rZKGpoicLkhjExCR2RMZtefOXYeV/R2gZbTkxxHAHmFh+
         OaKfljx+lgwsB98XcRNbK72vWVra9PQIX4h9xOqCfe3LvZHKMRnKXF4tRN+Y3bSkh08O
         cHcMqTJftvpmKfxRcOEAxww9mmuJS5nWPLQInEBqhFJRhZ5KYNuCKUN1GZ1K1CSJ2D8S
         fsowYFp07/nCIcUvNdmJ/47nscrJlVn2cgXtdN8xdryojReXwhfwwDDVNypQ4kvEyrt+
         lzdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lw26MzifeBS+EqPVJYGj/JQJtKX2FPAaIxw5E4kFPYU=;
        b=bOVcf6ioYO7KsP02FV++EnfruWEyax/bQOLyQpY50SkuGdewre3PrBScB7B1CLwg4d
         AlE/DBUkUvE5eDfMNRWj6O4pkfomq4vRTXngARkeRQX/WBmHyqgHti2QFEb+85yrdt3n
         K84FtmA16QcKSXzyGz2P5JS4BydlFpRMj5+Y9RP7wr+ClYgVy+Vk7IRO/6Sjx/HIe0SP
         doRPtnhJ4+WUxJSHM9ZmSl/GQn8gFKkdhos5+0k7l9azQFTvwbwpmHbxEKGEcf0zxOqe
         FhgHHyunZzF7j4hFZh5wQcpo3ur+BXQBeVMArCV3SlVWk4zEU09qfkJRZrxURwNxHUJB
         Uu+A==
X-Gm-Message-State: APjAAAVQEamm0+V/U+Dp/dHgzwW+oW8wm/9pBaQgFMS1WQazTd+8BBGY
        iab6g4y8l+CmNWLalg6mHdl9eQoigpw=
X-Google-Smtp-Source: APXvYqzknVuyclflz0d2J73dgJIvTVrD/Oh2a0sPv4kuThxBO4S5tkZ1RM5ctEkUgvb6LHwoaXCSxw==
X-Received: by 2002:adf:ecc3:: with SMTP id s3mr12942888wro.302.1565984285066;
        Fri, 16 Aug 2019 12:38:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e4sm10659959wrh.39.2019.08.16.12.38.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 12:38:04 -0700 (PDT)
Message-ID: <5d57061c.1c69fb81.bea40.51c3@mx.google.com>
Date:   Fri, 16 Aug 2019 12:38:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-35-ge6790d05646d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 99 boots: 3 failed,
 88 passed with 7 offline, 1 conflict (v4.4.189-35-ge6790d05646d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 99 boots: 3 failed, 88 passed with 7 offline, 1=
 conflict (v4.4.189-35-ge6790d05646d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-35-ge6790d05646d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-35-ge6790d05646d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-35-ge6790d05646d
Git Commit: e6790d05646d3c874dba68c3010faca10a21a1d0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9 - first fail: v4.4.189-32-g35ba3146be27)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
