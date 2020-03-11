Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0AA31820B0
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730691AbgCKSYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:24:48 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42156 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730654AbgCKSYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 14:24:48 -0400
Received: by mail-pf1-f196.google.com with SMTP id x2so1426252pfn.9
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 11:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=flb8H5uPjfZcLb+oQ//3YVKBxbl3Q/IwAMSanlRzcQM=;
        b=eYmnte9+YTR74zwIGBRFBaontN8BQWIA5vjCuDOKUxlht/QyNev9lKZ1Gv4vCsb8Uf
         PIXaww95Paa2Wu3TBHx3PBD3Kw95OBqTfZvUnEWCdRLv+FyseSe+Mbnw5F/sTqfN7J14
         tvyF1JqBlRJyzkk3t81dKEMMCiWKxW6OfaGoi2TwD/WwDipJz9bXr3brokaVtp635bjP
         XAh8aU441EphXPPzI3zQJwOYJ/uGkzQ9aH7LpYnCUESiSsWCNdoxMwSh2Q949k7dlGNe
         lZnyrXvEnabixdLqP7nPTg78ZCzgOHpR9846BrlZLxCGlFroqZ4FIGrbi1W59oMRYuI8
         2iEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=flb8H5uPjfZcLb+oQ//3YVKBxbl3Q/IwAMSanlRzcQM=;
        b=G0a2A3XVS5Hodm+rc4hhgVdvxJwoxRAIjyNqUPc3RXw09nU7XRr5DNf6K5ZTs9VPqp
         8T8zHARh9hZg+GeN9ZgGBwfEKRM4dZ/72ivgreCaw3bEKdh/RAjbr2a7exEy7q/7gDWE
         gOJFCyj6FYC1gB5xYQtv6clKJawTolSmHIxuaPKp30NsLg7avOlb87FoqzvdNKhpUPIl
         vpDUhvW6nxJLUoWEOQxrhDZlwkFxyawQmh1cUSFSdIbLFfC3UjVPQ979qSm3b/0hs8Y3
         S/GYJ6hEEbPUEJN4nCakMmbTrAKNmM+JarXDccWNUD4HcRevnzlHlPFoqTxyz8yqCmMI
         Z8gg==
X-Gm-Message-State: ANhLgQ2KdYPSLEk7IpRilqnnlg54YwJ/iL3gn2vFBcC0Pu2N4XY3VY/7
        SDHMKOjq2RDgUglEWR/kqEYS7/QcbH4=
X-Google-Smtp-Source: ADFU+vuqENVxAYHAZ4hVqdEdgS+VfzNumzY2fNgWxSKD17DNGVP3zQgN4w9qR80JQGmCght5VbZLPw==
X-Received: by 2002:a65:53c9:: with SMTP id z9mr3596664pgr.405.1583951087207;
        Wed, 11 Mar 2020 11:24:47 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6sm6294512pjz.39.2020.03.11.11.24.46
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 11:24:46 -0700 (PDT)
Message-ID: <5e692cee.1c69fb81.c0926.4c69@mx.google.com>
Date:   Wed, 11 Mar 2020 11:24:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.172-127-gc23e0b0dc693
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 94 boots: 2 failed,
 88 passed with 2 offline, 1 untried/unknown,
 1 conflict (v4.14.172-127-gc23e0b0dc693)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 94 boots: 2 failed, 88 passed with 2 offline, =
1 untried/unknown, 1 conflict (v4.14.172-127-gc23e0b0dc693)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.172-127-gc23e0b0dc693/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.172-127-gc23e0b0dc693/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.172-127-gc23e0b0dc693
Git Commit: c23e0b0dc6930b41fc7af94bfa48cee04f327d8d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 21 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 32 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 20 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.172-127-gd5b7f77=
0c4ed)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    tegra_defconfig:
        tegra124-jetson-tk1:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
